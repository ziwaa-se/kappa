import Lean

/-!
# PVTools — read-only audit commands for the TeX proof-check kit (v1.2)

These commands only read the environment; they never add declarations to it.
Build this file once (`scripts/pv_lean.sh build PVTools`). Then write a probe that imports the module
under audit and this file, for example `pv_work/probes/auditor/T01/auditor_T01_walk.lean`:

```lean
import T01
import PVTools
#pv_axioms T01                          -- axioms of every theorem/definition of module T01
#pv_walk T01                            -- full transitive constant walk from all of module T01
#pv_walk T01 stopping L09 L10           -- walk that records modules L09, L10 but does not enter them
#pv_walk_decl Paper.T01.main            -- walk from ONE declaration (optionally `stopping …`)
#pv_hyp_usage Paper.T01.main            -- which hypotheses of ONE theorem its proof term mentions
#pv_type_hashes T01                     -- statement fingerprints, to diff against the gate snapshot
```

For a statement draft (it still contains `sorry`, so it has no `.olean` to import), put
`import PVTools` at the top of a *copy* of the draft and `#pv_type_hashes_here` at its end.

Fingerprint lines have the form `name|kind|th=<type hash>|vh=<value hash>|bi=<binder info>`:
* `th` hashes the type. `Expr.hash` ignores the names of bound variables and also ignores
  explicit/implicit annotations; `bi` records those annotations of the leading binders
  (`e` explicit, `i` implicit, `s` strict implicit, `c` instance).
* `vh` hashes the **value of definitions** (`def`, `opaque`). This matters: external inputs and
  consumed clauses are `def Tool : Prop := …`, whose type is just `Prop`; without `vh`, changing
  their body would go unnoticed. Theorems print `vh=-`, because their proofs are meant to change.
* Both `#pv_type_hashes` and `#pv_type_hashes_here` sort the lines as strings, so outputs can be
  compared line by line.

`#pv_hyp_usage` reports `USED` when the proof term syntactically mentions a hypothesis. A mention
inside a helper lemma that does not itself need it, or inside a `have` that is never used, still
counts as `USED`; run the command on that helper to go one level deeper. `UNUSED` is conclusive.
Only hypotheses that the proof term binds with a leading `fun` are visible; when the type has more
leading `∀`/`→` binders than the proof term has leading `fun`s (for example `theorem t : A → B := h`),
the command prints a WARNING that the usage of the remaining hypotheses is unknown.

A walk reports `sorryAx` wherever it occurs. Grepping `.olean` files for "sorry" is not a substitute:
docstrings are stored in oleans and produce false positives.
-/

open Lean Elab Command

namespace PVTools

/-- The only axioms a finished proof may depend on. -/
def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Root namespaces of library modules (toolchain and packages). Everything else is project code.
If your mathlib version ships other packages, add their root names here. -/
def libRoots : List Name :=
  [`Init, `Std, `Lean, `Mathlib, `Batteries, `Aesop, `Qq, `ProofWidgets, `ImportGraph,
   `LeanSearchClient, `Plausible, `Lake]

def kindStr : ConstantInfo → String
  | .axiomInfo _ => "axiom" | .defnInfo _ => "def" | .thmInfo _ => "thm" | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quot" | .inductInfo _ => "induct" | .ctorInfo _ => "ctor" | .recInfo _ => "rec"

def modOf (env : Environment) (n : Name) : Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]!
  | none => `_current

def isLib (m : Name) : Bool := libRoots.contains (m.components.headD Name.anonymous)

def valueOf? : ConstantInfo → Option Expr
  | .defnInfo d => some d.value
  | .thmInfo t => some t.value
  | .opaqueInfo o => some o.value
  | _ => none

/-- Binder-info letters of the leading `∀` binders of a type. -/
partial def binderInfos (e : Expr) (acc : String := "") : String :=
  match e with
  | .forallE _ _ b bi =>
    let c := match bi with
      | .default => 'e' | .implicit => 'i' | .strictImplicit => 's' | .instImplicit => 'c'
    binderInfos b (acc.push c)
  | .mdata _ b => binderInfos b acc
  | _ => acc

/-- One fingerprint line for a declaration. Only definitions and opaques get a value hash. -/
def fingerprint (n : Name) (ci : ConstantInfo) : String :=
  let vh := match ci with
    | .defnInfo d => toString d.value.hash
    | .opaqueInfo o => toString o.value.hash
    | _ => "-"
  s!"{n}|{kindStr ci}|th={ci.type.hash}|vh={vh}|bi={binderInfos ci.type}"

/-- Constants a declaration refers to: its type and value, plus the structural links of
inductives, constructors and recursors. -/
def succs (ci : ConstantInfo) : Array Name := Id.run do
  let mut acc : Array Name := ci.type.getUsedConstants
  if let some v := valueOf? ci then acc := acc ++ v.getUsedConstants
  match ci with
  | .inductInfo i => acc := acc ++ i.ctors.toArray ++ i.all.toArray
  | .ctorInfo c => acc := acc.push c.induct
  | .recInfo r =>
      acc := acc ++ r.all.toArray
      for rule in r.rules do
        acc := acc.push rule.ctor
        acc := acc ++ rule.rhs.getUsedConstants
  | _ => pure ()
  return acc

/-- All constants declared in module `m`, sorted by name. -/
def moduleConsts (env : Environment) (m : Name) : Array Name := Id.run do
  let mut out : Array Name := #[]
  for (n, _) in env.constants.toList do
    if modOf env n == m then out := out.push n
  return out.qsort Name.lt

/-- Transitive closure from `roots`. Constants whose module is in `stops` are recorded as reached,
but their type and value are not followed. -/
def walk (env : Environment) (roots : Array Name) (stops : List Name) :
    Std.HashSet Name × Std.HashMap Name (Array Name) := Id.run do
  let mut visited : Std.HashSet Name := {}
  let mut refs : Std.HashMap Name (Array Name) := {}
  let mut stack : Array Name := roots
  for r in roots do visited := visited.insert r
  while !stack.isEmpty do
    let n := stack.back!
    stack := stack.pop
    if stops.contains (modOf env n) then continue
    match env.find? n with
    | none => pure ()
    | some ci =>
      for c in succs ci do
        let old := refs.getD c #[]
        if !old.contains n then refs := refs.insert c (old.push n)
        if !visited.contains c then
          visited := visited.insert c
          stack := stack.push c
  return (visited, refs)

/-- Shared report for `#pv_walk` and `#pv_walk_decl`. -/
def reportWalk (env : Environment) (title : String) (roots : Array Name) (stops : List Name)
    (skipModule : Name) : CommandElabM Unit := do
  let (closure, refs) := walk env roots stops
  let mut axs : Array Name := #[]
  for n in closure.toList do
    if let some (.axiomInfo _) := env.find? n then axs := axs.push n
  logInfo m!"WALK {title} stopping {stops}: {roots.size} roots, {closure.size} constants reached"
  logInfo m!"AXIOMS in closure: {axs.qsort Name.lt}; sorryAx reached: {closure.contains ``sorryAx}"
  let mut modCount : Std.HashMap Name Nat := {}
  for n in closure.toList do
    let mm := modOf env n
    if !isLib mm then modCount := modCount.insert mm (modCount.getD mm 0 + 1)
  for (mm, k) in modCount.toList.toArray.qsort (fun a b => a.1.toString < b.1.toString) do
    let tag := if stops.contains mm then " (stopped)" else ""
    logInfo m!"MODULE|{mm}|{k}{tag}"
  let mut lines : Array String := #[]
  for n in closure.toList do
    let mm := modOf env n
    if isLib mm || mm == skipModule then continue
    let some ci := env.find? n | continue
    let vh := match valueOf? ci with | some v => toString v.hash | none => "-"
    let via := ((refs.getD n #[]).filter (fun r => !isLib (modOf env r))).map (fun r => s!"{r}")
    lines := lines.push s!"REACHED|{mm}|{n}|{kindStr ci}|th={ci.type.hash}|vh={vh}|via={via.toList.take 3}"
  for l in lines.qsort (· < ·) do
    logInfo m!"{l}"

/-- `#pv_axioms M`: for every theorem and definition declared in module `M`, list the axioms it
depends on. Lines marked `NONSTANDARD` need attention; a clean module prints `ALL STANDARD`. -/
syntax (name := pvAxioms) "#pv_axioms " ident : command

@[command_elab pvAxioms] def elabPvAxioms : CommandElab := fun stx => do
  let m := stx[1].getId
  let env ← getEnv
  let consts := moduleConsts env m
  if consts.isEmpty then
    throwError "no constants found for module {m}; is it imported, and is the module name right?"
  let mut bad : Nat := 0
  let mut checked : Nat := 0
  for n in consts do
    let some ci := env.find? n | continue
    match ci with
    | .thmInfo _ | .defnInfo _ | .opaqueInfo _ =>
      if n.isInternal then continue
      checked := checked + 1
      let axs ← collectAxioms n
      let nonstd := axs.filter (fun a => !standardAxioms.contains a)
      if nonstd.isEmpty then
        logInfo m!"OK|{n}|{axs.qsort Name.lt}"
      else
        bad := bad + 1
        logInfo m!"NONSTANDARD|{n}|{axs.qsort Name.lt}"
    | _ => pure ()
  if bad == 0 then
    logInfo m!"#pv_axioms {m}: ALL STANDARD ({checked} declarations checked)"
  else
    logWarning m!"#pv_axioms {m}: {bad} of {checked} declarations use a nonstandard axiom (including sorryAx)"

/-- `#pv_walk M` or `#pv_walk M stopping A B …`: transitive constant walk from every declaration of
module `M`. -/
syntax (name := pvWalk) "#pv_walk " ident (" stopping" (ppSpace ident)+)? : command

@[command_elab pvWalk] def elabPvWalk : CommandElab := fun stx => do
  let m := stx[1].getId
  let stops : List Name :=
    if stx[2].isNone then [] else (stx[2][1].getArgs.map (·.getId)).toList
  let env ← getEnv
  let roots := moduleConsts env m
  if roots.isEmpty then
    throwError "no constants found for module {m}; is it imported, and is the module name right?"
  reportWalk env s!"module {m}" roots stops m

/-- `#pv_walk_decl c` or `#pv_walk_decl c stopping A B …`: the same walk from a single declaration
`c` (a full name). Use it to see what one theorem really reaches. -/
syntax (name := pvWalkDecl) "#pv_walk_decl " ident (" stopping" (ppSpace ident)+)? : command

@[command_elab pvWalkDecl] def elabPvWalkDecl : CommandElab := fun stx => do
  let c := stx[1].getId
  let stops : List Name :=
    if stx[2].isNone then [] else (stx[2][1].getArgs.map (·.getId)).toList
  let env ← getEnv
  unless env.contains c do
    throwError "unknown declaration {c}; use its full name"
  reportWalk env s!"declaration {c}" #[c] stops Name.anonymous

/-- `#pv_hyp_usage c`: for theorem or definition `c`, list its leading hypotheses and whether its
proof term (or the types of later hypotheses) mentions each of them. -/
syntax (name := pvHypUsage) "#pv_hyp_usage " ident : command

partial def lamTelescope (e : Expr) (acc : Array (Name × Expr)) : Array (Name × Expr) × Expr :=
  match e with
  | .lam n t b _ => lamTelescope b (acc.push (n, t))
  | .mdata _ b => lamTelescope b acc
  | e => (acc, e)

@[command_elab pvHypUsage] def elabPvHypUsage : CommandElab := fun stx => do
  let c := stx[1].getId
  let env ← getEnv
  let some ci := env.find? c | throwError "unknown declaration {c}; use its full name"
  let some v := valueOf? ci | throwError "{c} has no value (it is not a theorem or definition)"
  let (binders, body) := lamTelescope v #[]
  let n := binders.size
  let mut lines : Array String := #[]
  for k in [0:n] do
    let (nm, ty) := binders[k]!
    let mut used := body.hasLooseBVar (n - 1 - k)
    for j in [k+1:n] do
      if (binders[j]!).2.hasLooseBVar (j - 1 - k) then used := true
    let tyStr := (toString ty).take 100
    lines := lines.push s!"HYP|{k}|{nm}|{if used then "USED" else "UNUSED"}|{tyStr}"
  let typeBinders := (binderInfos ci.type).length
  if typeBinders > n then
    lines := lines.push s!"WARNING: the type has {typeBinders} leading binders but the proof term binds only {n}; usage of the remaining {typeBinders - n} hypotheses is unknown"
  logInfo m!"HYPOTHESIS USAGE {c} ({n} leading binders)\n{String.intercalate "\n" lines.toList}"

/-- `#pv_type_hashes M`: one fingerprint line per non-internal declaration of module `M`, sorted.
Diff against the gate snapshot to confirm that no gated statement or definition changed. -/
syntax (name := pvTypeHashes) "#pv_type_hashes " ident : command

@[command_elab pvTypeHashes] def elabPvTypeHashes : CommandElab := fun stx => do
  let m := stx[1].getId
  let env ← getEnv
  let consts := moduleConsts env m
  if consts.isEmpty then
    throwError "no constants found for module {m}; is it imported, and is the module name right?"
  let mut out : Array String := #[]
  for n in consts do
    if n.isInternal then continue
    let some ci := env.find? n | continue
    out := out.push (fingerprint n ci)
  out := out.qsort (· < ·)
  logInfo m!"TYPE HASHES {m} ({out.size} declarations)\n{String.intercalate "\n" out.toList}"

/-- `#pv_type_hashes_here`: the same fingerprints for the declarations of the *current file*
(use it at the end of a copy of a statement draft). -/
syntax (name := pvTypeHashesHere) "#pv_type_hashes_here" : command

@[command_elab pvTypeHashesHere] def elabPvTypeHashesHere : CommandElab := fun _ => do
  let env ← getEnv
  let mut out : Array String := #[]
  for (n, ci) in env.constants.map₂.toList do
    if n.isInternal then continue
    out := out.push (fingerprint n ci)
  out := out.qsort (· < ·)
  logInfo m!"TYPE HASHES (current file, {out.size} declarations)\n{String.intercalate "\n" out.toList}"

end PVTools

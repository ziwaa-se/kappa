# Verification methods and commands

All commands are run from the project root.

## 1. Compilation

```bash
scripts/pv_lean.sh check T01Draft      # type-check only; use this for drafts; does not produce an .olean
scripts/pv_lean.sh build T01           # type-check and produce pv_work/T01.olean; refuses to keep the .olean if there is a sorry or an error
scripts/pv_lean.sh probe pv_work/probes/auditor/T01/auditor_T01_walk.lean   # run a probe file
```

- Every run writes a numbered log `pv_work/logs/<name>_<k>.log`; the log ends with `EXIT=<exit_code>`, and the terminal prints one `RESULT …` line. When there are errors, it then prints a `FIRST ERRORS` block: the position, message and goal of the first 3 errors (v1.3), so that the whole log rarely has to be read.
- Reports must give the **real** exit code and log path.
- If modules `import` one another, `build` them in dependency order. **After a module is rebuilt, every `pv_work` module that imports it must be rebuilt**; otherwise downstream modules use the old version.
- Whenever `build` is refused, it deletes the module's previous `.olean`. There are two kinds of exit code:
  - compiles but has `sorry`: exit code 3;
  - compilation errors: the compiler's own exit code (usually 1).
- Before first use, run `scripts/pv_lean.sh build PVTools` once.
- Probes are named `pv_work/probes/<role>/<ID>/<role>_<ID>_<purpose>.lean`, e.g. `pv_work/probes/auditor/T01/auditor_T01_walk.lean`, so that log names do not clash.
- **When a mathlib module is missing**, first run `scripts/pv_lean.sh packages`. If it prints `linked`, the packages are shared with other projects, and `lake build` is **forbidden** (see `POLICY.md` §2).
- **Copy files** (e.g. copying a draft to the proof file) with the Read/Write tools, not `cp`; **move stale files away** with `python3 scripts/pv_status.py supersede <file> "<reason>" [<replaced_by>]`, not `mv`. That way the permission settings do not need to allow `cp`, `mv`, `mkdir`.

## 2. Review commands (`pv_work/PVTools.lean`)

Write a probe file, e.g. `pv_work/probes/auditor/T01/auditor_T01_audit.lean`:

```lean
import T01
import PVTools
#pv_axioms T01                    -- axioms of every theorem/definition in module T01; prints ALL STANDARD if all are standard
#pv_walk T01                      -- full transitive constant walk from module T01: axioms in the closure, sorryAx, constant count per module
#pv_walk T01 stopping L09 L10     -- modules L09, L10 are recorded but not entered when the walk reaches them (for "only via audited interfaces" judgments)
#pv_walk_decl Paper.T01.main     -- walk starting from a single declaration only (stopping … may also be added)
#pv_hyp_usage Paper.T01.main     -- whether each premise of this theorem is used by the proof term (USED / UNUSED)
#pv_type_hashes T01               -- one line per declaration: `name|kind|th=type hash|vh=def content hash|bi=binder annotations`
```

- **Per-theorem conditionality**:
  - `#pv_hyp_usage` gives the first-level answer. `UNUSED` is definitive: the premise is not used at all. `USED` means it appears in the proof term; if it is only passed on to some helper lemma, run `#pv_hyp_usage` on that lemma too, confirming level by level.
  - `#pv_walk_decl` shows which constants a theorem actually touches.

- **Statement snapshot comparison.**
  - Drafts contain `sorry` and have no `.olean`, so the gate takes the snapshot on a **copy** of the draft: in the copy, add `import PVTools` after the imports at the top and `#pv_type_hashes_here` at the end, then run `pv_lean.sh probe`.
  - The final audit runs `#pv_type_hashes T01` on the final module.
  - The gated declarations in the two outputs should match line by line: name, kind, `th`, `vh`, `bi` all identical. Helper lemmas may be added.
  - `vh` is the hash of a `def`'s content. External parameters, consumed clauses and `PrintedClause` are all `def … : Prop := …`; their type is just `Prop`, so only `vh` can detect that their content was changed (tested: changing a parameter's content to `False` changes `vh`).
  - `th` ignores the names of bound variables and ignores explicit/implicit annotations; the latter are recorded by `bi`.
  - Both outputs are sorted by whole line, so they can be compared line by line directly. It has been tested that the same statement gives the same hashes whether taken from a "draft copy" or from a "compiled module".
  - When hashes differ, read the `#print` output on both sides before drawing a conclusion.
- **Namespaces**: each result's files are written in `namespace Paper.<ID>`, and definitions used in the statement are declared only once, in `<ID>Stmt.lean` (`PIPELINE.md`, "Namespace and name-clash rules").
- **Claims of the form "only via some interface" must be confirmed with a walk, plus a positive control.**
  - When a `stopping` walk is used to judge "X is used only via Y", first run the same walk on a declaration known to use X, and confirm that it is detected.
  - A module given to `stopping` has its constants listed but not expanded, so any `sorryAx` inside it is invisible. You may stop there only if that module itself has passed independent review.
- **Do not use grep to judge sorry or axioms.** A byte grep of an `.olean` gives false positives, because docstrings are stored in the olean; and some shells' `grep` aliases skip binary files.

## 2b. How to check the "exact statement" (tested)

**Gap file.** In a probe, copy the gated version of the main theorem verbatim, with proof `by sorry`; its `th` must equal the value in the gate snapshot. Then use `example` to check that `_mod_gaps` is exactly "Gap premises → that statement":

```lean
import PVTools
import T01ModGaps
namespace Probe
theorem T01_main_gated (hT : Paper.T01.ToolT) (x y : Nat) (h : x ≤ y) : x ≤ y + 2 ∧ 0 ≤ x ∧ 0 < 1 := by sorry  -- copied verbatim from the draft, with fully qualified names
end Probe
#pv_type_hashes_here   -- the th on the T01_main_gated line must equal the th of T01_main in the gate snapshot
example (g1 : Paper.T01.T01_S1_Gap) : type_of% @Probe.T01_main_gated := Paper.T01.T01_main_mod_gaps g1
```

Writing only the `example` without first comparing `th` is not enough: a weakened conclusion also passes the `example` (tested). Check each "gap-dependent" obligation the same way.

**Gap content.** `def <ID>_S<k>_Gap : Prop := …` must be the **full ∀-closure** of the obligation's type, including variables introduced by `variable` and auto-bound implicit arguments. Only then does its `vh` equal the `th` of `S<k>` in the gate snapshot (tested: this holds for explicit, implicit, instance and universe binders).

**Exception: auxiliary proof constants (found while testing v1.3).** Lean names auxiliary proofs after their declaration: a real numeral `2 : ℝ` elaborates to `instOfNatAtLeastTwo … <declaration>._proof_1`. A `_Gap` definition, or any copy of a statement under **another name**, can therefore hash differently from an identical statement (the examples above use `Nat` numerals, which have no such proof). When `vh ≠ th`, or when a copied statement's `th` differs, decide it this way: in a probe that imports the gap file, redeclare the statement **verbatim under its original full name** (the gap file no longer declares `S<k>`, and it renamed the main theorem to `_mod_gaps`, so both names are free), confirm with `#pv_type_hashes_here` that its `th` equals the snapshot, and then check

```lean
import T01ModGaps
import PVTools
namespace Paper.T01
theorem T01_S1 (x : ℝ) (h : 0 < x) : 0 < 2 * x := by sorry      -- verbatim from the draft, original name
theorem T01_main (hT : ToolT) (x y : ℝ) (h : x ≤ y) : x ≤ y + 2 := by sorry
end Paper.T01
#pv_type_hashes_here   -- both th must equal the gate snapshot
example : Paper.T01.T01_S1_Gap = type_of% @Paper.T01.T01_S1 := rfl
example (g1 : Paper.T01.T01_S1_Gap) : type_of% @Paper.T01.T01_main := Paper.T01.T01_main_mod_gaps g1
```

`pv_audit_mech.py` reports such a case as a manual check, never as a PASS.

**Reconnection file.** X's main theorem comes from an audited module, so it need not be copied. Conventions:
- X's main theorem puts its (p) parameters first;
- `main_closed` puts **the conditions of each predecessor result** first, followed by X's other conditions.

It can then be checked like this:

```lean
-- when predecessor P is unconditional (UNCONDITIONAL):
example : type_of% @Paper.L2.main = (Paper.L2.L2_L1Consumed → type_of% @Paper.L2.main_closed) := rfl
-- when predecessor P has its own condition ToolK (CONDITIONAL): first pass P's conditions in as arguments of the example
example (hK : Paper.K1.ToolK) :
    type_of% @Paper.K2.main = (Paper.K2.K2_K1Consumed → type_of% (Paper.K2.main_closed hK)) := rfl
```

All the snippets above were tested and compile on Lean 4.19.0, covering gap files, the `Stmt` split, (p) names with a consumer prefix, and reconnection files in both predecessor cases.

## 3. Private `.olean` rebuild (for the final audit)

```bash
scripts/pv_lean.sh rebuild T01 T01
```

This command privately recompiles `T01.lean` in `pv_work/probes/auditor/T01/rebuild/`, then compares its sha256 with that of the delivered `pv_work/T01.olean`, printing `IDENTICAL` or `DIFFERENT`. `IDENTICAL` shows that what is being audited is exactly the artifact the prover delivered.

## 4. How to write external parameters

```lean
/-- EXTERNAL (i): Author–Author (2016) Theorem 3.5, cited at source `app.tex:171`. Specialized to the source's usage; weaker than the cited literature result (extra premises …).
Not proved in this project. mathlib search: `#check …` found nothing (see notes). -/
def CitedMomentBound : Prop := ∀ …, …

theorem main_result (hCited : CitedMomentBound) : … := …
```

- A parameter's `def` is declared only once, in `<ID>Stmt.lean` (if it has already been declared in another `Stmt` file, import and reuse it); it appears only in the signatures of theorems that need it, and it must be registered in `external_tools` in `RESULTS.json` and in `EXTERNAL_TOOLS.md`.
- Consumed clauses of predecessor results are written the same way, named `<ThisResultID>_<PredID>Consumed`; e.g. when `T01` uses `L07`, write `def T01_L07Consumed : Prop := …` and put it in `T01Stmt.lean`. Write only the clauses actually used; the provenance type is recorded as (p).
- Gap hypotheses are named `<ID>_S<k>_Gap`, appear only in the gap file `<ID>ModGaps.lean`, are recorded in the result's `gaps` field, and are **not** registered in `external_tools` (see `PIPELINE.md` Stage 4).

## 5. How to write counterexamples

```lean
/-- The (W) clause printed at source `app.tex:121`, encoded verbatim (for every function G it quantifies over). -/
def PrintedClauseW : Prop := ∀ G, (all printed hypotheses) → (printed conclusion)

theorem counterexample : ¬ PrintedClauseW := by
  intro h
  have := h G₀ (proof_of_hyp_1) (proof_of_hyp_2) …   -- the concrete instance satisfies every printed hypothesis
  …                                                  -- derive a contradiction
```

- Review points:
  1. `PrintedClauseW` is not stronger than the source. Extra premises only make it weaker, which is allowed; **a missing premise or a stronger conclusion is not allowed**.
  2. The instance satisfies every printed hypothesis.
  3. No definition in the source excludes the instance.
- Also add a `consumed_of_printed`-style lemma showing that "the printed clause implies the version actually used downstream", to confirm the scope of the refutation.

## 6. Non-vacuity

```lean
/-- Witness: the constant density ρ ≡ 1 satisfies the hypothesis class. -/
example : HolderDensity 3 1 (fun _ => 1) ∧ ∀ x, (1/2 : ℝ) ≤ 1 := …
/-- Instantiating the main theorem at the witness and compiling it shows that the hypotheses are not vacuous. -/
example (hTool : Tool) : … := main_result hTool (witness_proof)
```

- Preferably also have a **non-trivial** witness (e.g. a non-constant density), so that the theorem does not have content only in degenerate cases.

## 7. Hashes and snapshots

```bash
python3 scripts/pv_snapshot.py hash pv_work/T01.lean pv_work/T01.olean   # put this in the audit report
python3 scripts/pv_snapshot.py save --label T01                          # milestone snapshot
python3 scripts/pv_snapshot.py list
python3 scripts/pv_snapshot.py restore 20260922-114005-T01               # name format YYYYMMDD-HHMMSS-label; restores into restored_<name>/, does not overwrite
```

## 7b. v1.3 helper scripts

```bash
python3 scripts/pv_audit_mech.py T01                 # auditor: all mechanical final-audit checks, report verification/audits/T01_mech.md
python3 scripts/pv_audit_mech.py T01 --module T01ModGaps
python3 scripts/pv_status.py outputs T01             # coordinator: verdict lines of T01's reports, last EXIT= of its logs, its files
python3 scripts/pv_status.py record T01 --verdict CONDITIONAL --stage FINAL_PASSED --conditions ToolA --lean-main "…" --summary-en "…"
python3 scripts/pv_status.py add-tool '{"id": "ToolA", "lean": "pv_work/T01Stmt.lean:12", "meaning": "…", "provenance": "i", "source_loc": "source/main.tex:171", …}'
python3 scripts/pv_status.py init-checklist          # /pv-setup: one Unfinished row per result, header counts
python3 scripts/pv_usage.py                          # where the tokens went: by role, model and result (list-price estimate)
scripts/pv_drive.sh                                  # unattended /pv-run in fresh headless sessions (the kit's docs/MANUAL.md, section 3)
python3 scripts/pv_cards_check.py                    # after changing a rules file: every section cited by a rule card still exists
```

- `pv_audit_mech.py` replaces the auditor's manual probes for compile, rebuild, the `PVTools.lean` hash, fingerprint comparison, `#pv_axioms`, `#pv_walk` and the first level of `#pv_hyp_usage`, and (v1.5) checks that every Lake package is the git checkout of its `lake-manifest.json` revision with no local changes (item 13). (v1.5) When the module walk reaches a non-standard axiom, it walks each declaration on its own: the compiler auxiliaries of a computable `def` (internal names such as `…._cstage1`) refer to the core axiom `lcProof`, which no theorem reaches, so they do not fail item 7. It only reports; the auditor still judges route fidelity, helpers, unaudited constants, gap-file `example` checks and non-vacuity. The auditor runs it; results from the prover or coordinator are not accepted.
- `record` and `add-tool` only write, count and look up paths; every judgement is passed in by the coordinator.

## 8. Status and progress

```bash
python3 scripts/pv_status.py validate    # run after every update to RESULTS.json
python3 scripts/pv_status.py table       # English progress table (for screenshots)
python3 scripts/pv_status.py next        # results that can start (predecessor statements have passed the gate), sorted by how many results depend on them; respects run_scope
python3 scripts/pv_status.py next --second-pass   # results to retry in the second pass
python3 scripts/pv_status.py reconnect   # results whose predecessors are proved and that can be reconnected (stage 6b)
python3 scripts/pv_status.py tools       # external input registry table (Markdown)
python3 scripts/pv_status.py paths verification/report/FILES_TO_CHECK.md   # check that all paths referenced in the file exist
date '+%Y-%m-%d %H:%M'                   # get the timestamp; never estimate it
```

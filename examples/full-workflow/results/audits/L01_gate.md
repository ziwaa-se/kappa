# Statement gate — L01 (PDF 2.1, Lemma, `lem:amgm`)

- **Reviewer**: `pv-gate` (independent statement gate; model Opus 5, 1M context)
- **Date**: 2026-09-30 19:49 EDT (`date` → `Wed Sep 30 19:49:49 EDT 2026`)
- **Result**: L01, statement `source/main.tex:37-43`, proof `source/main.tex:45-50`
- **Shared definitions**: none (`RESULTS.json` `defs` = `{"id": "NONE"}`, RESULTS.json:16-21) — confirmed by reading the source: L01 uses no notation from the "Notation" section (`main.tex:26-33`).
- **Predecessors**: none (`depends_on: []`, RESULTS.json:31).

## Reviewed files and hashes

`python3 scripts/pv_snapshot.py hash pv_work/L01Stmt.lean pv_work/L01Draft.lean`:

```
0d6e1b15c197913cc7b29a6d113fdcff5091490ca7e938154459ef993d8cacf3  pv_work/L01Stmt.lean
67e30f093a51fac70ad36f9a3e906d5665848f2dee2824f77b555279ca04b310  pv_work/L01Draft.lean
```

Also read: `pv_work/notes/L01_draft_notes.md` (leads only, not used as evidence),
`source/main.tex` in full (93 lines; statement, proof, notation section, and the
surrounding results that reuse L01).

## Compilation (run by the gate itself)

```
$ scripts/pv_lean.sh check L01Draft
RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none
```

Real exit code: **0**. Log: `pv_work/logs/L01Draft_2.log`. Five `sorry` warnings =
one each for `L01_S1`…`L01_S4` and `L01_main`, as expected for a draft. No
`admit`/`axiom`/`native_decide`/`unsafe` etc. (`nonstandard_axiom_lines=0`).

```
$ scripts/pv_lean.sh packages
PACKAGES linked -> <shared Lean environment>/.lake/packages; mathlib modules compiled: 2452 of 6305
linked: do NOT run 'lake build'
```
No `lake build` / `lake update` / `lake exe cache get` was run.

Probe logs written by this gate: `pv_work/logs/gate_L01_stmtcopy_1.log`,
`gate_L01_draftcopy_1.log`, `gate_L01_imports_1.log`, `gate_L01_imports2_1.log`.

## Source quotations

Statement, `source/main.tex:37-43`:

> ```
> \begin{lemma}\label{lem:amgm}
> For all real numbers $a$ and $b$ we have
> \[
>   ab \le \frac{a^2+b^2}{2},
> \]
> with equality if and only if $a = b$.
> \end{lemma}
> ```

Proof, `source/main.tex:45-50`:

> ```
> \begin{proof}
> Since $(a-b)^2 \ge 0$, expanding the square gives $a^2 - 2ab + b^2 \ge 0$,
> that is, $2ab \le a^2 + b^2$.  Dividing by $2$ gives the inequality.
> Moreover, equality holds if and only if $(a-b)^2 = 0$, that is, if and only
> if $a = b$.
> \end{proof}
> ```

Relevant convention, `source/main.tex:28-29`: "Throughout, $\R$ denotes the real
numbers and $\Rpos$ the positive real numbers." L01 quantifies over *all* real
numbers (`\R`), **not** over `\Rpos`; the Lean encoding uses `(a b : ℝ)` with no
positivity premise, which matches. (The `S(x,y,z)` notation of `main.tex:31` is not
used by L01.) No global convention on constants is stated in the paper and L01
introduces no constants.

Downstream use, `source/main.tex:61-62`: P01 applies L01 to positive triples only;
this does not restrict L01's own statement, and L01's Lean form (all reals) is at
least as strong as what P01 needs — correct direction.

## Item-by-item rulings

### 1. Hypotheses — PASS

The only hypotheses in the source are the typing "for all real numbers $a$ and
$b$". `L01Stmt.lean:25` renders this as `structure L01Conclusion (a b : ℝ) : Prop`
with `a b` **explicit** binders, and every step obligation and `L01_main` takes
`(a b : ℝ)`. The snapshot confirms the binder annotations: `L01Conclusion|induct|…
|bi=ee`, `L01Conclusion.mk|ctor|…|bi=iiee`, and every step theorem `bi=ee`, i.e. no
extra implicit or instance-implicit argument has crept in.

- No extra premises anywhere: no positivity, nonzero, nondegeneracy or ordering
  hypothesis is added (in particular no `a ≠ b`, `0 ≤ a`, `0 < a` — which would have
  silently weakened the lemma and would have been exactly the trap here, since the
  neighbouring results P01/L02 *do* carry positivity/`x ≠ -1` side conditions).
- No hidden hypotheses in the `structure`: `L01Conclusion` has exactly the two
  fields `ineq` and `equality_iff` and the two parameters `a b : ℝ`; the type-hash
  listing of the stmt copy shows only the auto-generated `mk`/`rec`/`recOn`/
  `casesOn`/`noConfusion`/`noConfusionType` companions, no further declaration.
- No type classes, no `variable` block, no imported definition carrying hypotheses:
  `L01Stmt.lean` imports only `Mathlib.Data.Real.Basic`; `L01Draft.lean` imports only
  `L01Stmt`. I read both files in full; there is no `variable` line in either.
- **No conclusion-as-hypothesis**: none of `L01_S1`…`L01_S4`, `L01_main` takes any
  hypothesis at all, so no `(hB : B) : B` form and no equivalent is possible.
- There are **no `def … : Prop` external parameters and no consumed clauses** in
  `L01Stmt.lean`, consistent with L01 having no predecessor and citing nothing.

### 2. Conclusion — PASS (this is the focus item)

Source conclusion has two printed clauses; both are present, neither weakened nor
strengthened, none missing:

| Source clause | Lean | Ruling |
|---|---|---|
| `ab \le \frac{a^2+b^2}{2}` (main.tex:39-41) | `ineq : a * b ≤ (a ^ 2 + b ^ 2) / 2` (`L01Stmt.lean:26`) | faithful: literal transcription; `/` is real division (`Mathlib.Data.Real.Basic`, field division on `ℝ`, total and equal to the `\frac` of the source since the denominator `2 ≠ 0`); `a ^ 2` with `ℕ`-exponent equals `a * a` on `ℝ` — a pure notational conversion |
| "with equality if and only if $a = b$" (main.tex:42) | `equality_iff : a * b = (a ^ 2 + b ^ 2) / 2 ↔ a = b` (`L01Stmt.lean:27`) | faithful, see below |

On the focus question, in three parts:

1. **Is "equality" tied to the right relation?** The word "equality" in
   `main.tex:42` can only refer to equality in the immediately preceding displayed
   inequality `ab \le \frac{a^2+b^2}{2}` — i.e. to the case where `≤` is `=`, namely
   `ab = \frac{a^2+b^2}{2}`. The Lean left-hand side of the iff is exactly
   `a * b = (a ^ 2 + b ^ 2) / 2`, the same two expressions in the same order joined by
   `=`. This is the correct reading, and it is also the one the source's own proof
   uses: `main.tex:48-49` identifies equality with `(a-b)^2 = 0`, which is equivalent
   to `2ab = a^2+b^2`, i.e. to equality in the display. No alternative reading (e.g.
   equality in the intermediate `2ab \le a^2+b^2`) would give a different Lean
   proposition, since the two are equivalent over `ℝ`; so the encoding is unambiguous.
2. **Are both directions recorded?** Yes. `↔` in Lean is the biconditional, so
   `equality_iff` carries both `a * b = (a^2+b^2)/2 → a = b` (the substantive
   direction) and `a = b → a * b = (a^2+b^2)/2` (the trivial direction). Encoding
   only the forward implication would have been a weakening; encoding only the
   backward one would have been a serious weakening. Neither happened.
3. **Is anything stronger than the source claimed?** No. The source asserts the
   biconditional for all real `a,b`; `equality_iff` asserts precisely that, with the
   same universal quantification and no side condition. It is not, for instance,
   strengthened to a quantitative statement such as `(a^2+b^2)/2 - a*b = (a-b)^2/2`
   (which the paper never prints).

The bundling into a `structure` rather than an `∧` is an inessential presentational
choice; `L01Conclusion a b` is logically the conjunction of the two clauses, so the
bundling neither adds nor removes content.

### 3. Quantifiers and dependence of constants — PASS

Source: "For all real numbers $a$ and $b$". Lean: `a b : ℝ` universally quantified
(as leading explicit binders of `L01_main`, `L01Conclusion`, and each `L01_Sk`). The
order of the two independent universal quantifiers is immaterial and matches anyway.
L01 introduces **no constants**, so no question of "before which objects a constant
is chosen" arises and no global constants convention is engaged (the paper states
none). The step obligations are each quantified over the same `(a b : ℝ)` as the
main theorem, so no obligation is secretly a statement about a fixed pair.

### 4. Domains and details — PASS

- **Domain**: `ℝ`, matching `\R` of `main.tex:28`; *not* `\Rpos` — correctly, since
  L01 (unlike P01) says "real numbers" with no positivity. No periodicity /
  measure-theoretic aspect arises.
- **Equality vs. a.e. equality**: no measure space is involved; `=` on `ℝ` is the
  only sensible reading.
- **Existence/construction, finiteness, measurability, regularity**: not applicable
  — the statement is a first-order arithmetic assertion about two reals.
- **`ℝ≥0∞` truncation traps**: none. Everything lives in `ℝ`; there is no
  `ENNReal`, `ofReal` or `toReal` anywhere in either file, so no `⊤`/truncation or
  subtraction-truncation trap. Note in particular that the source's `a^2 - 2ab + b^2`
  (main.tex:46) involves real subtraction, and the Lean rendering stays in `ℝ`
  (`(a - b) ^ 2` in `L01_S1`), where subtraction is genuine, not truncated. Division
  by `2` is real division by a nonzero constant, so no `x / 0 = 0` convention issue.

### 5. Step obligations — PASS

| Step | Lean statement (line) | Labelled source sentence | Correspondence | True as stated? |
|---|---|---|---|---|
| S1 | `(a - b) ^ 2 ≥ 0` (`L01Draft.lean:26`) | "Since $(a-b)^2 \ge 0$" (main.tex:46) | exact, including the `≥` orientation | **True** for all real `a,b` (square of a real) |
| S2 | `2 * (a * b) ≤ a ^ 2 + b ^ 2` (`L01Draft.lean:33`) | "expanding the square gives $a^2 - 2ab + b^2 \ge 0$, that is, $2ab \le a^2 + b^2$" (main.tex:46-47) | exact: the sentence's own end form "$2ab \le a^2+b^2$" is taken as the obligation; the intermediate `a^2-2ab+b^2 ≥ 0` is the same statement rearranged, and the docstring records that the expansion is what carries S1 to S2 | **True** (equivalent to S1 by `ring_nf`) |
| S3 | `a * b ≤ (a ^ 2 + b ^ 2) / 2` (`L01Draft.lean:39`) | "Dividing by $2$ gives the inequality." (main.tex:47) | exact: the result of halving S2 is literally the displayed inequality | **True** |
| S4 | `a * b = (a ^ 2 + b ^ 2) / 2 ↔ a = b` (`L01Draft.lean:49`) | "Moreover, equality holds if and only if $(a-b)^2 = 0$, that is, if and only if $a = b$." (main.tex:48-49) | faithful: the source chains `equality ⟺ (a-b)^2 = 0 ⟺ a = b`; the obligation records the composite `equality ⟺ a = b`, which is the clause the lemma prints. The intermediate link `(a-b)^2 = 0` is not given its own obligation, but it is recorded in the docstring as the route, and both links are elementary real algebra of the same kind as S2 | **True**: forward, `2ab = a^2+b^2 ⟹ (a-b)^2 = 0 ⟹ a = b`; backward, `a = b ⟹ a·a = (2a^2)/2` |
| main | `L01Conclusion a b` (`L01Draft.lean:54`) | the lemma (main.tex:37-43) | assembled as `⟨S3, S4⟩` | **True** |

Truth checks were not left to inspection: I proved the two substantive obligations
independently in `pv_work/probes/gate/L01/gate_L01_imports2.lean` (the exact
statements of S3 and S4), `RESULT … exit=0 errors=0`, log
`pv_work/logs/gate_L01_imports2_1.log`. So **no obligation is false as stated**, and
in particular none is missing a premise ([…]
here there is genuinely no side condition to omit — S1–S4 all hold for *all* real
`a, b`, including `a = b`, `a = 0`, and negative values).

- **No smuggling.** No obligation takes a hypothesis, so nothing can be assumed.
  S3 and S4 *are* the two conclusion clauses, which is correct and not smuggling:
  they are the final sentences of the source proof, they carry `sorry` in the draft
  (so they must be proved, not assumed), and they are to be derived from S1/S2 inside
  the same module rather than supplied by any parameter. No obligation is stronger
  than what its source sentence asserts (S2 is not, e.g., stated as an equality; S4
  is not stated as a quantitative gap identity).
- **Assembly is complete.** `L01Conclusion` has exactly the fields `ineq` and
  `equality_iff`; S3 is verbatim the type of `ineq` and S4 verbatim the type of
  `equality_iff` (same expressions, same associativity — confirmed by comparing the
  draft and stmt texts I read, and consistent with `L01_S3`/`L01_S4` compiling
  against the same `Mathlib.Data.Real.Basic` notation). Hence `L01Conclusion.mk S3 S4`
  yields `L01_main`, with no residual gap. S1 and S2 are the honest intermediate
  steps of the source paragraph feeding S3 (and, as the docstring of S4 says, the same
  expansion re-used as an equation feeds S4); their presence adds no assumption.

### 6. External parameters — PASS (vacuous)

`L01Stmt.lean` declares **no** `def … : Prop` and no `<ID>_<PredID>Consumed`; there
are no external parameters and no consumed clauses, and none is needed:

- The source proof of L01 cites nothing (the paper's single citation,
  `\cite[Theorem~1]{Nesbitt1903}` at `main.tex:60`, belongs to P01);
- everything used — nonnegativity of a real square, the binomial expansion, and
  "a real square vanishes iff its base does" — is ordinary `ℝ` ring/order arithmetic,
  at the same level as the lemma's own statement, and available in mathlib. These are
  `FAIR_IMPLICIT_STEP`-level facts, correctly *not* registered as external tools.
- No "mathlib does not have X" claim is made anywhere in `L01Stmt.lean`,
  `L01Draft.lean` or the notes, so there is nothing of that kind to verify. (I did
  verify positively that mathlib here supplies what is needed:
  `gate_L01_imports2.lean` uses `sq_nonneg` and `pow_eq_zero_iff` and compiles,
  exit 0.)
- Naming/location requirements are trivially satisfied; both files are entirely
  inside `namespace Paper.L01` … `end Paper.L01`, and no name collides with
  `pv_work/L02Stmt.lean` (which lives in `namespace Paper.L02`, checked).

### 7. Doubts about the source itself — PASS (none)

I found no suspected paper issue in `main.tex:37-50`, and the drafter reports none.
The statement is true as printed, both clauses of the conclusion are justified by the
printed proof, the proof's three sentences are each valid, and no hypothesis is
missing (the lemma holds for all real `a, b` with no side condition). No case or
range is left uncovered (`a = b` is exactly the equality case and is handled). No
dispatch of `pv-issue-checker` is recommended for L01.

*Non-issue note (not a paper matter, and not a required change):* the drafter's note
§7 says `import Mathlib.Tactic` does not load in this linked, partially built mathlib.
I checked the narrower modules myself: `Mathlib.Tactic.Linarith` and
`Mathlib.Tactic.Ring` **do** load and `nlinarith`/`ring`/`linarith` work
(`pv_work/logs/gate_L01_imports_1.log` — the two errors there are only the missing
`ℝ` instances, because that probe deliberately omitted `Mathlib.Data.Real.Basic`; and
`gate_L01_imports2_1.log`, exit 0, with all three imports). So there is **no
TRANSLATION_BLOCKED risk** for L01; the prover should import
`Mathlib.Data.Real.Basic`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.Ring` rather
than the umbrella `Mathlib.Tactic`.

## TFA table

| Candidate extra premise | Ruling | Reason |
|---|---|---|
| (none) | — | The Lean statement adds no premise to the source's "for all real numbers $a$ and $b$"; there is nothing to rule on. |

## External-parameter table

| Name | Provenance | Ruling | Reason |
|---|---|---|---|
| (none) | — | — | No `def … : Prop` and no consumed clause is declared in `pv_work/L01Stmt.lean`; L01 cites nothing and has no predecessor, so the file is correctly parameter-free. Consequence: if the proof goes through, L01 can be **UNCONDITIONAL**. |

## Required changes

None.

## Statement snapshot

Both snapshots were taken on copies under `pv_work/probes/gate/L01/`, made with
Read/Write from the exact texts reviewed above, with `import PVTools` added after the
imports and `#pv_type_hashes_here` at the end. The stmt copy contains no `sorry`; the
draft copy keeps `import L01Stmt` (using the drafter's `L01Stmt.olean`) and contains
the five `sorry`s.

### `pv_work/L01Stmt.lean`
copy: `pv_work/probes/gate/L01/gate_L01_stmtcopy.lean`;
`RESULT gate_L01_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L01_stmtcopy_1.log`

```
TYPE HASHES (current file, 9 declarations)
Paper.L01.L01Conclusion.casesOn|def|th=1454288434|vh=1533326364|bi=iiiee
Paper.L01.L01Conclusion.equality_iff|thm|th=261512754|vh=-|bi=iie
Paper.L01.L01Conclusion.ineq|thm|th=173032269|vh=-|bi=iie
Paper.L01.L01Conclusion.mk|ctor|th=838139543|vh=-|bi=iiee
Paper.L01.L01Conclusion.noConfusionType|def|th=2552020671|vh=1366535989|bi=iieee
Paper.L01.L01Conclusion.noConfusion|def|th=2588493557|vh=4050502746|bi=iiiiie
Paper.L01.L01Conclusion.recOn|def|th=1454288434|vh=2107731693|bi=iiiee
Paper.L01.L01Conclusion.rec|rec|th=2626472951|vh=-|bi=iiiee
Paper.L01.L01Conclusion|induct|th=1185911348|vh=-|bi=ee
```

### `pv_work/L01Draft.lean`
copy: `pv_work/probes/gate/L01/gate_L01_draftcopy.lean`;
`RESULT gate_L01_draftcopy mode=probe exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L01_draftcopy_1.log`

```
TYPE HASHES (current file, 5 declarations)
Paper.L01.L01_S1|thm|th=1002552111|vh=-|bi=ee
Paper.L01.L01_S2|thm|th=72149719|vh=-|bi=ee
Paper.L01.L01_S3|thm|th=740771191|vh=-|bi=ee
Paper.L01.L01_S4|thm|th=3407856599|vh=-|bi=ee
Paper.L01.L01_main|thm|th=3116722683|vh=-|bi=ee
```

In the final audit, `#pv_type_hashes L01` must reproduce these lines for the
corresponding declarations; any differing `th`, `vh` or `bi` means the statement
changed after this gate.

## Summary

Items 1-7 all PASS. The statement is faithful to `source/main.tex:37-43`; the
equality clause records both directions of the source's "if and only if" and ties
"equality" to the displayed inequality correctly; the S1-S4 split follows the three
sentences of `main.tex:45-50` and assembles to the main theorem; no extra premises,
no TFAs, no external parameters, no false obligation, no suspected paper issue.
Proof work may begin.

STATEMENT GATE: PASS

# C01 statement gate (Corollary cor:unit, Corollary 2.6)

- Reviewer: pv-gate (independent subagent, Opus), first gate for C01
- Date: Mon Oct 12 22:28:06 EDT 2026 (from `date`)
- Reviewed files (sha256 from `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/C01Stmt.lean` 88443d3b96bd10da5cfcb77b402bb01d6021cf8b8b0ac10296e9a2f187334656
  - `pv_work/C01Draft.lean` 33224feab805c77f95774b37dba405cb8bcccd7eecba6a4db8c45c024d5fe370
  - imported: `pv_work/L03Stmt.lean` 0528bec8e0be738607a171ca1998262b777cebb4eb5601bf3377ea880bf4e2d4
  - imported: `pv_work/Defs.lean` e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e
  - source: `source/main.tex` 1cbdd1aa5b3d8616c3f4505b9062441d71b2f7e2644e20af8eaa1f4aed5a3250
- Compilation: `scripts/pv_lean.sh check C01Draft` -> `exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0`, log `pv_work/logs/C01Draft_2.log` (the 4 sorries are S1, S2, S3, main; expected in a draft).
- Draft notes `pv_work/notes/C01_draft_notes.md` were read as leads only; every point below was checked against the `.tex` and the Lean text.

## Source quotations (read directly)

- main.tex:26 "Throughout, $n \ge 1$ is an integer and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$."
- main.tex:29 "The sample mean of $x$ is $\bar x = \frac{1}{n} \sum_{i=1}^n x_i$."
- main.tex:33-37 "For $n \ge 2$, the sample variance of $x$ is $s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar x)^2$ ..."
- main.tex:85-87 (Lemma lem:raw, L03) "Suppose that $n \ge 2$. Then $s^2 \le \frac{1}{n} \sum_{i=1}^n x_i^2$."
- main.tex:94-96 (Corollary cor:unit, C01) "Suppose that $n \ge 2$ and that $|x_i| \le 1$ for $i = 1, \dots, n$. Then $s^2 \le 2$."
- main.tex:98-100 (proof) "By Lemma~\ref{lem:raw}, $s^2 \le \frac{1}{n} \sum_{i=1}^n x_i^2 \le 1 \le 2$."

No constants are chosen; there is no global convention on constants that affects this result.

## Item rulings

### 1. Hypotheses: PASS
- `hn : 2 ≤ n` = ":95 n ≥ 2" (also implies the global n ≥ 1 of :26).
- `hx : ∀ i, |x i| ≤ 1` = ":95 |x_i| ≤ 1 for i = 1..n" (`Fin n` indexing, Defs.lean:13, gated).
- `hL : C01_L03Consumed` is not a TFA: it is the consumed clause of the paper's own Lemma lem:raw, the only justification the source gives at :99 (see item 6). It is not the conclusion or an equivalent of it (it does not mention the bound 2 or |x_i| ≤ 1).
- No hidden hypotheses: `Sample` is an `abbrev` for `Fin n → ℝ`; `sampleVar` / `sampleMean` are total definitions (Defs.lean:17-25), with no structures, type classes or `variable`s involved. No extra premises.

### 2. Conclusion: PASS
`Conclusion x := sampleVar x ≤ 2` (C01Stmt.lean:6-7) is exactly ":95 s^2 ≤ 2" under the gated definition of `sampleVar` (real `(n:ℝ) - 1`, correct for n ≥ 2). Neither weakened nor strengthened; it is the only clause.

### 3. Quantifiers and constants: PASS
`C01_main` quantifies n, x and then the hypotheses; no constants. Matches the source.

### 4. Domains and details: PASS
Real-valued throughout; no ENNReal/toReal; no measurability, a.e. or existence issues. Division by n and by n-1 is harmless since n ≥ 2 is a hypothesis.

### 5. Step obligations: PASS
- **S1** (:99 "By Lemma lem:raw, s^2 ≤ (1/n)∑x_i^2"): `hL → 2 ≤ n → sampleVar x ≤ (1/n)∑(x i)^2`. Exactly the instance of the consumed clause at the corollary's own n, x. True as stated (direct instantiation of `hL`). Its conclusion is the printed lemma's conclusion, not a smuggled-in stronger intermediate.
- **S2** (:99 "(1/n)∑x_i^2 ≤ 1"): with n ≥ 2 and |x_i| ≤ 1, each x_i^2 ≤ 1, so ∑ ≤ n and (1/n)∑ ≤ 1. True as stated; all needed premises (n > 0, |x_i| ≤ 1) are present. FAIR_IMPLICIT_STEP.
- **S3** (:99 "1 ≤ 2"): true.
- **Assembly**: S1, S2, S3 by transitivity give `sampleVar x ≤ 2` = `Conclusion x`. The chain is exactly the printed chain at :99.
- Checked each obligation for truth as stated (LESSONS 10): none is false as stated.

**Caution for the prover and auditor (not a statement defect).** `C01_L03Consumed` is refutable: `Paper.L03.counterexample_consumed` (pv_work/L03_Counterexample1.lean:57) refutes the weaker `ConsumedByC01`, hence also this clause (instance n = 2, x = (1, -1)). `C01_main` is therefore vacuously provable by ex falso. VERDICTS §4.2 forbids deriving B from contradictory premises: the proof must follow S1 -> S2 -> S3 and use `hL` only through the instantiation in S1; the auditor should confirm with `#pv_walk` / `#pv_hyp_usage` that no counterexample module is imported and that `hL` is used only at S1.

### 6. External parameters / consumed clause: PASS
`C01_L03Consumed` (C01Stmt.lean:14-16):
- **Exactly what :99 uses.** :99 cites Lemma lem:raw to get `s^2 ≤ (1/n)∑x_i^2` for the corollary's sample with n ≥ 2. The clause is `∀ n (x : Sample n), 2 ≤ n → sampleVar x ≤ (1/(n:ℝ)) * ∑ i, (x i)^2`, which is the printed statement of lem:raw (main.tex:85-86) quantified over all n, x, and is definitionally `∀ n x, 2 ≤ n → Paper.L03.Conclusion x` (L03Stmt.lean:7-8 has the identical body). It equals `Paper.L03.PrintedClause` up to binder order and implicitness. It is the exact printed clause, not a repaired version (so it is not stronger than the lemma, and the false clause is kept as printed, which is correct). It is slightly stronger than the minimal use at :99 (which also has |x_i| ≤ 1 available), but VERDICTS §4.2 explicitly allows the **exact** consumed clause of a predecessor; it is not stronger than lemma A.
- **Not goal-shaped**: it contains neither `≤ 2` nor `≤ 1` nor any estimate that first appears in C01's proof.
- **Visible parameter, not an axiom**: `def ... : Prop`, used as explicit hypothesis `hL` in `C01_S1` and `C01_main`; no `axiom` in either file (compile log: nonstandard_axiom_lines=0).
- **Naming and location**: declared only in `C01Stmt.lean`, in `namespace Paper.C01`, named `C01_L03Consumed` per the `<ID>_<PredID>Consumed` rule. `Conclusion` is also declared in `Paper.L03`, but in a different namespace, so no name is redeclared.
- **Provenance**: (p), predecessor L03, location of the clause in L03: `L03Stmt.lean:7-8` `Paper.L03.Conclusion`, used through `L03_main (hn : 2 ≤ n) (x) : Conclusion x`. Applicability: lem:raw only needs n ≥ 2, which is the corollary's own hypothesis (:95). **Registry note:** `python3 scripts/pv_status.py outputs L03` shows `L03_final.md: SUGGESTED VERDICT: ISSUE` and `L03_issue_1.md: ISSUE VERDICT: ERROR`. Per VERDICTS §4.1 row (p), a (p) clause whose predecessor ends ISSUE "counts as (iv)". When registering it (it is not yet in `verification/EXTERNAL_TOOLS.md` or `external_tools`), the coordinator should record it as (p)/(iv) with `predecessor: L03`, worksheet priority A, and put L03's issue in C01's `upstream_issues` (VERDICTS §1, line 58), not in C01's `issues`. This is a registry action, not a change to the Lean statement.
- **mathlib evidence**: not applicable (this is a clause of the paper's own lemma, not a library fact).
- Minor doc-comment remark (no change required, since changing it would change the .olean): the docstring says "issue B01", while the L03 issue file is `L03_issue_1.md`. If B01 is not the BLOCKERS id of that issue, record it in `verification/DOC_ERRATA.md`.

### 7. Doubts about the source: PASS (recorded, not ruled)
- main.tex:99: the step "By Lemma lem:raw, s^2 ≤ (1/n)∑x_i^2" relies on lem:raw, whose printed clause is false (L03 issue 1, counterexample n = 2, x = (1, -1), where s^2 = 2 > 1 = (1/n)∑x_i^2). At that instance the intermediate `s^2 ≤ 1` asserted at :99 also fails, while the corollary's conclusion `s^2 ≤ 2` holds (`L03_Counterexample1.lean:72-76`). Preliminary class: inherited from L03. Under VERDICTS §1 (line 58) this makes C01 CONDITIONAL on the consumed clause with `upstream_issues` = L03 issue 1, not ISSUE by itself. Whether :99 also carries its own PAPER_ARGUMENT_GAP (the false intermediate `s^2 ≤ 1` printed in C01's own proof) is for `pv-issue-checker` to rule on. I recommend dispatching it. The gate does not rule on it.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| none | - | The draft has no extra premises beyond the source hypotheses and the consumed clause |

## External parameters / consumed clauses

| Name | Ruling | Provenance | Notes |
|---|---|---|---|
| `C01_L03Consumed` (C01Stmt.lean:14) | approved | (p), predecessor L03 (lem:raw, main.tex:85-86), used at :99; counts as (iv) because L03 is ISSUE (VERDICTS §4.1) | exact printed clause, false (L03 issue 1); not goal-shaped; not an axiom |

## Required changes

None to the Lean files. Registry action for the coordinator: register `C01_L03Consumed` as described in item 6.

## Statement snapshot

`pv_work/probes/gate/C01/gate_C01_stmtcopy.lean` (probe log `pv_work/logs/gate_C01_stmtcopy_1.log`, exit=0):
```
TYPE HASHES (current file, 2 declarations)
Paper.C01.C01_L03Consumed|def|th=3944470172|vh=3770461433|bi=
Paper.C01.Conclusion|def|th=3418533756|vh=1612149043|bi=ie
EXIT=0
```

`pv_work/probes/gate/C01/gate_C01_draftcopy.lean` (probe log `pv_work/logs/gate_C01_draftcopy_1.log`, exit=0, 4 sorry warnings):
```
TYPE HASHES (current file, 4 declarations)
Paper.C01.C01_S1|thm|th=2706750135|vh=-|bi=eiee
Paper.C01.C01_S2|thm|th=2579116952|vh=-|bi=ieee
Paper.C01.C01_S3|thm|th=2745721755|vh=-|bi=
Paper.C01.C01_main|thm|th=2600442862|vh=-|bi=eieee
EXIT=0
```

## Overall verdict

The statement faithfully encodes Corollary cor:unit (main.tex:94-96). The consumed clause is the exact printed L03 clause that :99 uses, and it appears as a visible hypothesis, not as an axiom. Proof work may begin, subject to the prohibition on ex-falso use of the false clause.

STATEMENT GATE: PASS

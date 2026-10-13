# C01 final audit (Corollary cor:unit, Corollary 2.6)

- Auditor: pv-auditor (independent, Opus), session 9fc1c499; date from `date`: Mon Oct 12 22:48:21 EDT 2026.
- Audited object: `pv_work/C01.lean` (no gap file; prover notes: no gaps, no helpers).
- Source read directly: source/main.tex:26-38 (setting, definitions), :85-92 (lem:raw), :94-100 (cor:unit and proof).
- Read in full: `pv_work/C01.lean`, `pv_work/C01Stmt.lean`, `pv_work/Defs.lean`, `pv_work/L03_Counterexample1.lean`, `verification/audits/C01_gate.md`, `pv_work/notes/C01_prover_notes.md`, `verification/audits/L03_issue_1.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py C01` -> `verification/audits/C01_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `C01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL (571eea51…) |
| 3 | PVTools.lean hash | PASS |
| 4 | gated fingerprints vs C01_gate.md (6 decls) | PASS |
| 5 | Defs vs DEFS_gate.md | PASS |
| 6 | `#pv_axioms C01` | ALL STANDARD |
| 7 | `#pv_walk C01` | no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` gated theorems | no UNUSED |
| 11 | traced conditions | C01_L03Consumed |

## 2. Gap files

None (not applicable).

## 3. Per-theorem conditionality (probe `pv_work/probes/auditor/C01/auditor_C01_audit.lean`, log `pv_work/logs/auditor_C01_audit_2.log`, exit 0)

| Declaration | `hL : C01_L03Consumed` | `#pv_walk_decl` reaches `C01_L03Consumed`? |
|---|---|---|
| `C01_S1` | USED (log:8) | yes (positive control, log:22) |
| `C01_S2` | not a binder | no (log:27-33) |
| `C01_S3` | not a binder | no (log:34-37) |
| `C01_main` | USED (log:2) | yes, via `[C01_main, C01_S1]` only (log:43) |

hL enters `C01_main` only through S1, where it is instantiated as `hL n x hn` (C01.lean:8), the exact printed use at main.tex:99. The closure of `C01_main` (log:38-53) reaches only modules C01, C01Stmt, Defs: no L03 counterexample module, no `False.elim`/ex-falso route. The VERDICTS §4.2 prohibition on deriving the conclusion from the contradictory premise is respected.

## 4. Infrastructure

| Constant | Module | Record |
|---|---|---|
| `C01_L03Consumed`, `Conclusion`, `Conclusion._proof_1` | C01Stmt | C01_gate.md (named, PASS) |
| `Sample`, `sampleMean`, `sampleVar` | Defs | DEFS_gate.md (PASS) |
| `C01_S2._proof_1` | C01 | auto-generated auxiliary proof of S2 (audited here, part of S2) |

No other in-project constant is reached. No new infrastructure.

## 5. Route fidelity (main.tex:99 "By Lemma lem:raw, s^2 ≤ (1/n)∑x_i^2 ≤ 1 ≤ 2")

| Source | Lean | Assessment |
|---|---|---|
| "By Lemma lem:raw, s^2 ≤ (1/n)∑x_i^2" | `C01_S1 := hL n x hn` | faithful; exact printed clause of lem:raw (:86), not repaired, not strengthened |
| "(1/n)∑x_i^2 ≤ 1" | `C01_S2`: x_i^2 ≤ 1 from |x_i| ≤ 1 (`sq_le_one_iff_abs_le_one`), sum ≤ n, multiply by 1/n > 0 | FAIR_IMPLICIT_STEP (source writes no justification; filled by termwise bound and summation) |
| "1 ≤ 2" | `C01_S3` by `norm_num` | faithful |
| chain | `C01_main := S1.trans (S2.trans S3)` | exactly the printed chain |

No change of route, no stronger result used, no helpers beyond the gated obligations.

## 6. Non-vacuity (honest statement)

- Source hypotheses are satisfiable: `n = 2`, `x = (1,-1)` (`Paper.L03.x0`, with `x0_bounded`) and `n = 3`, `x = 0`; `C01_main hL …` instantiates at both (probe, compiles).
- **But the visible parameter hL is refutable.** Probe theorem `audit_hL_false : ¬ C01_L03Consumed` compiles (axioms: propext, Classical.choice, Quot.sound), from `Paper.L03.counterexample` (L03 issue 1, COUNTEREXAMPLE VALID in `L03_issue_1_audit.md`). The probe also shows `C01_L03Consumed ↔ Paper.L03.PrintedClause`.
- Consequence: C01's conditional theorem is **conditional on a false clause**. As a Lean implication it is true but carries no information about cor:unit: its antecedent can never be discharged. The CONDITIONAL verdict below means only "the printed proof of :99 is a correct deduction from the printed lem:raw". It does **not** mean that cor:unit is verified.
- At the instance x0 the intermediate `s^2 ≤ 1` printed at :99 is false (`x0_C01_intermediate_fails`), while `s^2 ≤ 2` holds with equality (`x0_C01_conclusion_holds`).
- Is C01's own conclusion true separately? Reasoning only, not proved in Lean, not used: by lem:shortcut, (n-1)s^2 = ∑x_i^2 - n x̄^2 ≤ n, so s^2 ≤ n/(n-1) ≤ 2 for n ≥ 2. So the printed conclusion `s^2 ≤ 2` appears **true**; what fails is the printed justification (it goes through a false lemma and a false intermediate `s^2 ≤ 1`). This argument was constructed by the reviewer and is only a suggestion to the authors.

## 7. Notes for the coordinator

- Per VERDICTS §1.3 (line 58), L03's ERROR does not make C01 ISSUE; record `upstream_issues: L03 issue 1 (B01)`.
- The intermediate `s^2 ≤ 1` printed in C01's own proof at :99 is false (Lean-checked at x0). Whether this counts as C01's **own** PAPER_ARGUMENT_GAP, separate from the inherited issue, is not ruled on here. The gate made the same recommendation, and I endorse it: send it to pv-issue-checker. If an issue is confirmed, C01 becomes ISSUE and supersedes the verdict below.
- Doc-comment "issue B01" in C01Stmt.lean:12 is consistent with `verification/BLOCKERS.md:23` (B01 = L03 / 2.5 / ERROR); no erratum is needed.
- The external parameter is the (p) consumed clause of an ISSUE predecessor, so it counts as (iv) (VERDICTS §4.1). Register it as `C01_L03Consumed` with predecessor L03 and mark it as **refuted**, so that it is never offered as a human-checkable or reconnectable input.

## 8. Status for the authors

Verified: the proof at main.tex:99 is a correct deduction from the printed Lemma lem:raw (plus a fair implicit step), and the deduction depends on that lemma's printed clause only.
That clause is false (L03, B01), so C01 is only formally conditional and not verified. The printed intermediate s^2 ≤ 1 fails at x = (1,-1).
The conclusion s^2 ≤ 2 appears true by a different route (reasoning, not checked). The source proof of cor:unit needs repair.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: C01_L03Consumed

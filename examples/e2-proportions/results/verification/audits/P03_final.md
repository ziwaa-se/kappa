# P03 final audit (prop:sum), gap file `pv_work/P03ModGaps.lean`

- Reviewer: pv-auditor (fresh subagent, Opus); date Mon Oct 12 22:28:32 EDT 2026 (from `date`)
- Source read directly: main.tex:1-34 (setting, def:svar), main.tex:81-88 (prop:sum and proof)
- Read in full: `pv_work/P03ModGaps.lean`, `pv_work/P03.lean`, `pv_work/P03Stmt.lean`, `pv_work/P03Draft.lean`, prover notes, gate report `P03_gate.md`, DEFS gate (relevant lines), issue audit `P03_issue_1_audit.md`
- Not modified: any audited file. Probe: `pv_work/probes/auditor/P03/aud_P03_final1.lean` (log `pv_work/logs/aud_P03_final1_1.log`)

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P03 --module P03ModGaps`)

Report `verification/audits/P03_mech.md`: MECH CHECKS: PASS.

| # | Check | Result |
|---|---|---|
| 1 | compile `P03ModGaps` | PASS (exit=0, errors=0, sorry=0) |
| 2 | private rebuild sha256 | IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 / 4b | gated fingerprints; `P03_S1_Gap` vh = snapshot th of `P03_S1` (827841601) | PASS |
| 5 | Defs vs DEFS snapshot | PASS |
| 6-7 | `#pv_axioms`, `#pv_walk`: standard axioms only, no `sorryAx` | PASS |
| 10 | `#pv_hyp_usage`: no UNUSED hypotheses | PASS |
| 11 | TRACED CONDITIONS | none |

## 2. Gap-file exact-statement check (VERIFICATION_METHODS §2b), my probe

| Check | Result |
|---|---|
| `P03_S1` redeclared verbatim (original name) | th=827841601 = gate snapshot |
| `P03_main` redeclared verbatim (original name) | th=4267815131 = gate snapshot |
| `example : P03_S1_Gap = type_of% @P03_S1 := rfl` | compiles |
| `example (g1 : P03_S1_Gap) : type_of% @P03_main := P03_main_mod_gaps g1` | compiles |
| `P03_S2` type = draft statement (rfl) and th=2223477596 (mech item 4) | PASS; S2 is not gap-dependent |
| `#print axioms` `P03_S2`, `P03_main_mod_gaps` | [propext, Classical.choice, Quot.sound] |

Probe: exit=0, errors=0; its 2 sorry warnings are the probe's own copies of `P03_S1`/`P03_main` used for fingerprinting.

`P03.lean` vs `P03ModGaps.lean`: same `s2_nonneg`, `P03_S2` and main-theorem body; they differ only in the stopped obligation (`P03_S1` with `sorry` in `P03.lean` vs the `P03_S1_Gap` premise `hGap_1` in the gap file). PASS.

## 3. Per-theorem conditionality

`P03_S2`: uses m, hm, x, y; no external parameters. `P03_main_mod_gaps`: `hGap_1` is USED (via `rw`, main.tex:86), as expected; no external parameters. The gap premise is the confirmed-false sentence main.tex:86 (`P03_issue_1_audit.md`: COUNTEREXAMPLE VALID), so it is not a condition. It is the recorded paper gap.

## 4. Infrastructure

| Constant | Record | Ruling |
|---|---|---|
| `Paper.DEFS.mean`, `Paper.DEFS.s2` | `DEFS_gate.md` (names both, lines 22-23, 49-50) | definitions, PASS |
| `Paper.P03.P03Concl` (+ `_proof_1`) | `P03_gate.md` | definition, PASS |
| helper `s2_nonneg` (private, item 9) | reviewed here | true statement (`0 ≤ s2 u` for m ≥ 2: factor `1/((m:ℝ)-1) ≥ 0` times a sum of squares), standard axioms, does not contain the target; a technical fill-in of "both terms are nonnegative" |

No earlier theorem is in the closure.

## 5. Route fidelity

| Source (main.tex) | Lean | Ruling |
|---|---|---|
| :86 "s²(x+y) = s²(x)+s²(y)" | `P03_S1_Gap` (premise), used by `rw` | STOPPED: PAPER_ARGUMENT_GAP (confirmed; cross term 2·cov(x,y) missing; fails at m=2, x=y=(0,1)) |
| :86-87 "≤ 2s²(x)+2s²(y) because both terms are nonnegative" | `P03_S2` via `s2_nonneg` + `linarith` | faithful; nonnegativity of s² from def:svar (main.tex:33) is a FAIR_IMPLICIT_STEP, filled in as mul_nonneg of a nonnegative scalar and `Finset.sum_nonneg`/`sq_nonneg` |
| chaining | `rw [hGap_1 …]; exact P03_S2 …` | faithful; route unchanged; no stronger result used |

## 6. Non-vacuity

`P03_S2` is instantiated at m=3 with x=(0,1,5), y=(2,-1,4) (hm discharged by `norm_num`); this compiles. `P03_main_mod_gaps` is vacuous in its gap premise, because `P03_S1_Gap` is refuted. That is the expected status of a theorem proved modulo a false step, and it is why this result cannot be verified.

## 7. Status for the authors

Verified: the second step (main.tex:86-87) and the assembly, modulo the first step. The first step, s²(x+y) = s²(x)+s²(y) (main.tex:86), is false (counterexample checked in Lean): PAPER_ARGUMENT_GAP. The printed bound main.tex:82 is not refuted, and appears true by another route.
No external parameters.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none

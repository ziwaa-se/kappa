# Mechanical audit checks — T01 (`T01ModGaps`)

Run by: pv-auditor (agent a7f056da, session f0fedf08), with `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps` on 2026-10-13 01:23. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01ModGaps exit=0 delivered=504e9d58b5a71e511f22739569e76cec59900b127becfe7532035adc5a814725 rebuilt=504e9d58b5a71e511f22739569e76cec59900b127becfe7532035adc5a814725 IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate_r2.md` (13 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.T01.T01_S0_Gap`: vh = snapshot th of `Paper.T01.T01_S0`; `Paper.T01.T01_S2_Gap`: vh = snapshot th of `Paper.T01.T01_S2` |
| 6 | `#pv_axioms T01ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T01ModGaps.lean` | PASS | pv-prover (agent a94e099c), 2026-10-13 01:15:25 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent a9586f6d), 2026-10-13 01:10:28 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 5 | `verification/audits/L01_gate.md` | `Paper.L01.F`, `Paper.L01.IsInvSub`, `Paper.L01.SubCond`, `Paper.L01.SubadditiveOn`, `Paper.L01.invDist` |
| `T01Stmt` | 5 | `verification/audits/T01_gate_r2.md` | `Paper.T01.AntiStarShaped`, `Paper.T01.StarShaped`, `Paper.T01.T01_L01Consumed`, `Paper.T01.T01_X02Tool`, `Paper.T01.ginv` |

## Declarations in `pv_work/T01ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma F_eq`, `lemma bdd_of_S2`, `lemma real_Iic_zero`, `lemma sub_down`, `lemma sub_eq`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.T01_S1` | 9 | — |  |
| `Paper.T01.T01_S3` | 5 | — |  |
| `Paper.T01.T01_S4` | 6 | — |  |
| `Paper.T01.T01_S5` | 7 | inst._@.T01ModGaps._hyg.422: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS, hθ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T01.T01_S6` | 7 | inst._@.T01ModGaps._hyg.554: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.T01.T01_main_mod_gaps` | 10 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.T01.T01_main` renamed to `Paper.T01.T01_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

# Mechanical audit checks — P02 (`P02ModGaps`)

Run by: pv-auditor (agent aa8ebda9, session 6cb4a36f), with `python3 scripts/pv_audit_mech.py P02 --module P02ModGaps` on 2026-10-12 22:28. Probes: `pv_work/probes/auditor/P02/auditor_P02_mech1.lean`, `pv_work/probes/auditor/P02/auditor_P02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P02ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P02ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P02ModGaps exit=0 delivered=e570e6dee6d0d2d11c2be3bb2467cfe85a0ce41242f338439bec3c13e3ac6263 rebuilt=e570e6dee6d0d2d11c2be3bb2467cfe85a0ce41242f338439bec3c13e3ac6263 IDENTICAL log=pv_work/probes/auditor/P02/rebuild/P02ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P02_gate_r2.md` (11 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.P02.P02_S1_Gap`: vh = snapshot th of `Paper.P02.P02_S1` |
| 6 | `#pv_axioms P02ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk P02ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P02ModGaps.lean` | PASS | pv-prover (agent acae61c3), 2026-10-12 22:18:56 |
| 12 | last writer of `pv_work/P02Stmt.lean` | PASS | pv-drafter (agent aa69007b), 2026-10-12 21:53:24 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `P02Stmt` | 3 | `verification/audits/P02_gate_r2.md` | `Paper.P02.InfiniteMean`, `Paper.P02.StDom`, `Paper.P02.TwoCase` |

## Declarations in `pv_work/P02ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem sqrt_integrable_aux`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P02.P02_S2` | 14 | inst._@.P02ModGaps._hyg.365: MeasureTheory.IsProbabilityMeasure.{0} #2 #1 #0, hX: Measurable.{0, 0} #7 Real #6 Real.measurableSpace #3, hX₁: Measurable.{0, 0} #8 Real #7 Real.measurableSpace #3, hX₂: Measurable.{0, 0} #9 Real #8 Real.measurableSpace #3 |  |
| `Paper.P02.P02_S3` | 12 | — |  |
| `Paper.P02.P02_S4a` | 7 | inst._@.P02ModGaps._hyg.580: MeasureTheory.IsProbabilityMeasure.{0} #2 #1 #0 |  |
| `Paper.P02.P02_S4b` | 15 | hdom: Paper.P02.StDom #12 #11 #10 #8 #7 |  |
| `Paper.P02.P02_S5` | 19 | — |  |
| `Paper.P02.P02_S6` | 22 | hind: ProbabilityTheory.IndepFun.{0, 0, 0} #13 Real Real #12 Real. |  |
| `Paper.P02.P02_main_mod_gaps` | 18 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.P02.P02_main` renamed to `Paper.P02.P02_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

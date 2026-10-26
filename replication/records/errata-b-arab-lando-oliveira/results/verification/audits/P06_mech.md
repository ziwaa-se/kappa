# Mechanical audit checks — P06 (`P06`)

Run by: pv-auditor (agent a4f74b75, session b64a0af0), with `python3 scripts/pv_audit_mech.py P06` on 2026-10-13 02:19. Probes: `pv_work/probes/auditor/P06/auditor_P06_mech1.lean`, `pv_work/probes/auditor/P06/auditor_P06_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P06` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P06_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P06 exit=0 delivered=a324ab900368093ede4aa02d3e03b80d41f60854fd8f69e5c22a5b727c6c95ac rebuilt=a324ab900368093ede4aa02d3e03b80d41f60854fd8f69e5c22a5b727c6c95ac IDENTICAL log=pv_work/probes/auditor/P06/rebuild/P06.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P06_gate.md` (13 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms P06` | PASS | ALL STANDARD |
| 7 | `#pv_walk P06`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P06.lean` | PASS | pv-prover (agent af372ad5), 2026-10-13 02:18:40 |
| 12 | last writer of `pv_work/P06Stmt.lean` | PASS | pv-drafter (agent a947d3a6), 2026-10-13 02:13:29 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `P06Stmt` | 7 | `verification/audits/P06_gate.md` | `Paper.P06.IsInvSub`, `Paper.P06.SubadditiveOn`, `Paper.P06.genInv`, `Paper.P06.isbOrder`, `Paper.P06.paretoCdf`, `Paper.P06.recipE`, `Paper.P06.recipE.match_1` |

## Declarations in `pv_work/P06.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma approx_left`, `lemma leftLim_mem`, `lemma pareto_greatest`, `lemma s3_ab`, `lemma s3_ba`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P06.P06_S1` | 3 | — |  |
| `Paper.P06.P06_S1'` | 3 | — |  |
| `Paper.P06.P06_S2` | 2 | — |  |
| `Paper.P06.P06_S3` | 2 | inst._@.P06._hyg.679: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.P06.P06_S4` | 3 | inst._@.P06._hyg.750: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.P06.P06_main` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

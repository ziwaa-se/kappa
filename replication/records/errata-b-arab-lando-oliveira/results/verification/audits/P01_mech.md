# Mechanical audit checks — P01 (`P01`)

Run by: pv-auditor (agent afd833cd, session 6cb4a36f), with `python3 scripts/pv_audit_mech.py P01` on 2026-10-12 22:19. Probes: `pv_work/probes/auditor/P01/auditor_P01_mech1.lean`, `pv_work/probes/auditor/P01/auditor_P01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P01_10.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P01 exit=0 delivered=c248ed73ea566180faf9d56279eba532e9de42e0044aca0ed3751c79525534fd rebuilt=c248ed73ea566180faf9d56279eba532e9de42e0044aca0ed3751c79525534fd IDENTICAL log=pv_work/probes/auditor/P01/rebuild/P01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P01_gate_r2.md` (16 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms P01` | PASS | ALL STANDARD |
| 7 | `#pv_walk P01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P01.lean` | PASS | pv-prover (agent a4814945), 2026-10-12 22:18:25 |
| 12 | last writer of `pv_work/P01Stmt.lean` | PASS | pv-drafter (agent a049901f), 2026-10-12 22:09:21 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `P01Stmt` | 8 | `verification/audits/P01_gate_r2.md` | `Paper.P01.AntiStarShaped`, `Paper.P01.F`, `Paper.P01.Fbar`, `Paper.P01.InvSub`, `Paper.P01.SubadditiveOnPos`, `Paper.P01.hazard`, `Paper.P01.invDist`, `Paper.P01.vExt` |

## Declarations in `pv_work/P01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem Fbar_eq`, `theorem ae_haz`, `theorem ae_haz_ennreal`, `theorem hpt_id`, `theorem key`, `theorem tonelli_id`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P01.P01_S1` | 5 | — |  |
| `Paper.P01.P01_S2` | 5 | — |  |
| `Paper.P01.P01_S3` | 5 | — |  |
| `Paper.P01.P01_S4` | 6 | — |  |
| `Paper.P01.P01_S5` | 6 | — |  |
| `Paper.P01.P01_S6` | 3 | inst._@.P01._hyg.789: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.P01.P01_S7` | 7 | inst._@.P01._hyg.820: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.P01.P01_main` | 7 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

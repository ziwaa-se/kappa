# Mechanical audit checks — P05 (`P05Closed_r1`)

Run by: pv-auditor (agent aad2e8dc, session 8d34e999), with `python3 scripts/pv_audit_mech.py P05 --module P05Closed_r1 --skip-statement` on 2026-10-13 11:11. Probes: `pv_work/probes/auditor/P05/auditor_P05_mech1.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P05Closed_r1` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P05Closed_r1_5.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P05Closed_r1 exit=0 delivered=61f2b29b3fcfcc9acd5774cd322a5d56218f876b39bba48e59227a90538be114 rebuilt=61f2b29b3fcfcc9acd5774cd322a5d56218f876b39bba48e59227a90538be114 IDENTICAL log=pv_work/probes/auditor/P05/rebuild/P05Closed_r1.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms P05Closed_r1` | PASS | ALL STANDARD |
| 7 | `#pv_walk P05Closed_r1`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: P05_P04Consumed |
| 12 | last writer of `pv_work/P05Closed_r1.lean` | PASS | pv-prover (agent a2823e16), 2026-10-13 11:10:36 |
| 12 | last writer of `pv_work/P05Stmt.lean` | PASS | pv-drafter (agent aac6e3c0), 2026-10-13 10:44:20 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 9 | `verification/audits/DEFS_gate_r2.md` | `Paper.Erep`, `Paper.HS`, `Paper.IsConsistent`, `Paper.IsEValue`, `Paper.IsMixingMeasure`, `Paper.IsStrictlyConsistent`, `Paper.elemScore`, `Paper.expPi`, `Paper.mixtureScore` |
| `P04` | 40 | `verification/audits/P04_final.md` | `Paper.P04.P04_S1`, `Paper.P04.P04_S10`, `Paper.P04.P04_S2`, `Paper.P04.P04_S9a`, `Paper.P04.P04_S9a._proof_1`, `Paper.P04.P04_S9a._proof_2`, `Paper.P04.P04_S9b`, `Paper.P04.P04_S9b._proof_1`, `Paper.P04.P04_S9c`, `Paper.P04.P04_S9c._proof_1`, `Paper.P04.P04_S9c._proof_2`, `Paper.P04.P04_S9c._proof_3` … |
| `P04Stmt` | 21 | `verification/audits/P04_gate_r2.md` | `Paper.P04.HSc`, `Paper.P04.HScInt`, `Paper.P04.Ik`, `Paper.P04.Mk`, `Paper.P04.P04_MixingOfStrict`, `Paper.P04.P04_T01Consumed`, `Paper.P04.SeqSetting`, `Paper.P04.SeqSetting.Y_adapted`, `Paper.P04.SeqSetting.Y_mem`, `Paper.P04.SeqSetting.c_mem`, `Paper.P04.SeqSetting.lam_adapted`, `Paper.P04.SeqSetting.lam_mem` … |
| `P05` | 51 | `verification/audits/P05_final_r2.md` | `Paper.P05.P05_S0`, `Paper.P05.P05_S0._proof_1`, `Paper.P05.P05_S0._proof_10`, `Paper.P05.P05_S0._proof_11`, `Paper.P05.P05_S0._proof_2`, `Paper.P05.P05_S0._proof_3`, `Paper.P05.P05_S0._proof_4`, `Paper.P05.P05_S0._proof_5`, `Paper.P05.P05_S0._proof_6`, `Paper.P05.P05_S0._proof_7`, `Paper.P05.P05_S0._proof_8`, `Paper.P05.P05_S0._proof_9` … |
| `P05Stmt` | 6 | `verification/audits/P05_gate_r2.md` | `Paper.P05.IsStopTime`, `Paper.P05.IsStopTime.le_meas`, `Paper.P05.IsStopTime.mk`, `Paper.P05.IsStopTime.pos`, `Paper.P05.P05Conclusion`, `Paper.P05.P05_P04Consumed` |
| `T01Stmt` | 1 | `verification/audits/T01_gate.md` | `Paper.T01.MixtureRep` |

## Declarations in `pv_work/P05Closed_r1.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| — | — | — | — |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- external inputs registered for P05 but not reached by any gated theorem (P05_P04Consumed): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

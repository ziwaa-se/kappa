# Mechanical audit checks — P03 (`P03Closed_r1`)

Run by: pv-auditor (agent a0478708, session a091d246), with `python3 scripts/pv_audit_mech.py P03 --module P03Closed_r1 --skip-statement` on 2026-10-13 11:26. Probes: `pv_work/probes/auditor/P03/auditor_P03_mech1.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P03Closed_r1` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P03Closed_r1_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P03Closed_r1 exit=0 delivered=dbf0445a63ee409ec9ac5e7e585e45b8476b0e416233dfb66a50b0693c24faf4 rebuilt=dbf0445a63ee409ec9ac5e7e585e45b8476b0e416233dfb66a50b0693c24faf4 IDENTICAL log=pv_work/probes/auditor/P03/rebuild/P03Closed_r1.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |
| 6 | `#pv_axioms P03Closed_r1` | PASS | ALL STANDARD |
| 7 | `#pv_walk P03Closed_r1`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: P03_P02Consumed, P03_T02Consumed, T02_L01Consumed |
| 12 | last writer of `pv_work/P03Closed_r1.lean` | PASS | pv-prover (agent ad584291), 2026-10-13 11:25:42 |
| 12 | last writer of `pv_work/P03Stmt.lean` | PASS | pv-drafter (agent a793cf72), 2026-10-13 01:38:10 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 5 | `verification/audits/L01_gate.md` | `Paper.L01.F`, `Paper.L01.IsInvSub`, `Paper.L01.SubCond`, `Paper.L01.SubadditiveOn`, `Paper.L01.invDist` |
| `P02Stmt` | 2 | `verification/audits/P02_gate_r2.md` | `Paper.P02.InfiniteMean`, `Paper.P02.StDom` |
| `P03` | 16 | `verification/audits/P03_final.md` | `Paper.P03.P03_S1`, `Paper.P03.P03_S1._proof_1`, `Paper.P03.P03_S2`, `Paper.P03.P03_S2._proof_1`, `Paper.P03.P03_S2._proof_2`, `Paper.P03.P03_S2._proof_3`, `Paper.P03.P03_S4`, `Paper.P03.P03_S5`, `Paper.P03.P03_S6`, `Paper.P03.P03_S6._proof_1`, `Paper.P03.P03_S7`, `Paper.P03.P03_main` … |
| `P03Stmt` | 3 | `verification/audits/P03_gate.md` | `Paper.P03.P03_P02Consumed`, `Paper.P03.P03_T02Consumed`, `Paper.P03.P03_T02Consumed._proof_1` |
| `T02` | 48 | `verification/audits/T02_final.md` | `Paper.T02.T02_S1`, `Paper.T02.T02_S1._proof_1`, `Paper.T02.T02_S1._proof_2`, `Paper.T02.T02_S1._proof_3`, `Paper.T02.T02_S2`, `Paper.T02.T02_S3`, `Paper.T02.T02_S4`, `Paper.T02.T02_S5`, `Paper.T02.T02_S5._proof_1`, `Paper.T02.T02_S5._proof_2`, `Paper.T02.T02_S5._proof_3`, `Paper.T02.T02_S5._proof_4` … |
| `T02Stmt` | 9 | `verification/audits/T02_gate.md` | `Paper.T02.Fbar`, `Paper.T02.IIDCopies`, `Paper.T02.IIDCopies.ident`, `Paper.T02.IIDCopies.indep`, `Paper.T02.IIDCopies.meas`, `Paper.T02.IIDCopies.measXs`, `Paper.T02.IIDCopies.mk`, `Paper.T02.StDom`, `Paper.T02.T02_L01Consumed` |

## Declarations in `pv_work/P03Closed_r1.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| — | — | — | — |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- external inputs registered for P03 but not reached by any gated theorem (P03_P02Consumed, P03_T02Consumed, T02_L01Consumed): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

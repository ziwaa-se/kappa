# Mechanical audit checks — P01 (`P01`)

Run by the auditor with `python3 scripts/pv_audit_mech.py P01` on 2026-09-30 20:13. Probes: `pv_work/probes/auditor/P01/auditor_P01_mech1.lean`, `pv_work/probes/auditor/P01/auditor_P01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P01_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P01 exit=0 delivered=bcb9ed759eb9b9f154112b5c38fd129671cb4d6a4c2d5bea20e965151de982d1 rebuilt=bcb9ed759eb9b9f154112b5c38fd129671cb4d6a4c2d5bea20e965151de982d1 IDENTICAL log=pv_work/probes/auditor/P01/rebuild/P01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P01_gate.md` (9 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms P01` | PASS | ALL STANDARD |
| 7 | `#pv_walk P01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01` | 4 | `verification/audits/L01_final.md` | `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `Paper.L01.L01_S4`, `Paper.L01.L01_main` |
| `L01Stmt` | 3 | `verification/audits/L01_gate.md` | `Paper.L01.L01Conclusion`, `Paper.L01.L01Conclusion.ineq`, `Paper.L01.L01Conclusion.mk` |
| `P01Stmt` | 4 | `verification/audits/P01_gate.md` | `Paper.P01.NesbittInequality`, `Paper.P01.NesbittInequality._proof_1`, `Paper.P01.NesbittInequality._proof_2`, `Paper.P01.P01Conclusion` |

## Declarations in `pv_work/P01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P01.P01_S1` | 6 | — |  |
| `Paper.P01.P01_S2` | 7 | — |  |
| `Paper.P01.P01_S3` | 3 | — |  |
| `Paper.P01.P01_S4` | 6 | — |  |
| `Paper.P01.P01_S5` | 6 | — |  |
| `Paper.P01.P01_S6` | 6 | — |  |
| `Paper.P01.P01_main` | 7 | — |  |

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

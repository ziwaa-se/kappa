# Mechanical audit checks — L01 (`L01`)

Run by the auditor with `python3 scripts/pv_audit_mech.py L01` on 2026-09-30 19:55. Probes: `pv_work/probes/auditor/L01/auditor_L01_mech1.lean`, `pv_work/probes/auditor/L01/auditor_L01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L01_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L01 exit=0 delivered=07a93f25e36f75a5e902a750f99743ff4dde10449c5fef76da32dcfa69b4544d rebuilt=07a93f25e36f75a5e902a750f99743ff4dde10449c5fef76da32dcfa69b4544d IDENTICAL log=pv_work/probes/auditor/L01/rebuild/L01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L01_gate.md` (14 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms L01` | PASS | ALL STANDARD |
| 7 | `#pv_walk L01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.L01Conclusion`, `Paper.L01.L01Conclusion.mk` |

## Declarations in `pv_work/L01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L01.L01Conclusion.equality_iff` | 3 | — |  |
| `Paper.L01.L01Conclusion.ineq` | 3 | — |  |
| `Paper.L01.L01_S1` | 2 | — |  |
| `Paper.L01.L01_S2` | 2 | — |  |
| `Paper.L01.L01_S3` | 2 | — |  |
| `Paper.L01.L01_S4` | 2 | — |  |
| `Paper.L01.L01_main` | 2 | — |  |

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

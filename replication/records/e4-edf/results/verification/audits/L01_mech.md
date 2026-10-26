# Mechanical audit checks — L01 (`L01`)

Run by: pv-auditor (agent a3d9d9dc, session b3b8d1c9), with `python3 scripts/pv_audit_mech.py L01` on 2026-10-12 22:08. Probes: `pv_work/probes/auditor/L01/auditor_L01_mech1.lean`, `pv_work/probes/auditor/L01/auditor_L01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L01_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L01 exit=0 delivered=76a95bd965c30a92c27c2c9b3cd7e4e5d11412470c560a5e0642c18e4f62dd1e rebuilt=76a95bd965c30a92c27c2c9b3cd7e4e5d11412470c560a5e0642c18e4f62dd1e IDENTICAL log=pv_work/probes/auditor/L01/rebuild/L01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L01_gate.md` (12 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L01` | PASS | ALL STANDARD |
| 7 | `#pv_walk L01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L01.lean` | PASS | pv-prover (agent a6431d0d), 2026-10-12 22:07:42 |
| 12 | last writer of `pv_work/L01Stmt.lean` | PASS | pv-drafter (agent a71606d3), 2026-10-12 21:48:47 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 1 | `verification/audits/DEFS_gate.md` | `Paper.Defs.edf` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Conclusion`, `Paper.L01.Conclusion.mk` |

## Declarations in `pv_work/L01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L01.Conclusion.mono` | 3 | — |  |
| `Paper.L01.Conclusion.values` | 3 | — | WARNING: the type has 4 leading binders but the proof term binds only 3; usage of the remaining 1 hypotheses is unknown |
| `Paper.L01.L01_S1` | 6 | — |  |
| `Paper.L01.L01_S2` | 4 | — |  |
| `Paper.L01.L01_main` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

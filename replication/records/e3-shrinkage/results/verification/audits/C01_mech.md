# Mechanical audit checks — C01 (`C01`)

Run by: pv-auditor (agent a0da2be9, session a79d9234), with `python3 scripts/pv_audit_mech.py C01` on 2026-10-13 01:23. Probes: `pv_work/probes/auditor/C01/auditor_C01_mech1.lean`, `pv_work/probes/auditor/C01/auditor_C01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `C01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/C01_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD C01 exit=0 delivered=a72c0c736c26f51901d28e0cd4ba4003ff575c11f841d9d36132c7d07d5b5084 rebuilt=a72c0c736c26f51901d28e0cd4ba4003ff575c11f841d9d36132c7d07d5b5084 IDENTICAL log=pv_work/probes/auditor/C01/rebuild/C01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/C01_gate.md` (6 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms C01` | PASS | ALL STANDARD |
| 7 | `#pv_walk C01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/C01.lean` | PASS | pv-prover (agent a9725fc5), 2026-10-13 01:23:13 |
| 12 | last writer of `pv_work/C01Stmt.lean` | PASS | pv-drafter (agent ac046e22), 2026-10-13 01:20:57 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `C01Stmt` | 2 | `verification/audits/C01_gate.md` | `Paper.C01.Conclusion`, `Paper.C01.Conclusion._proof_1` |
| `Defs` | 7 | `verification/audits/DEFS_gate.md` | `Paper.Setting`, `Paper.Setting.mk`, `Paper.Setting.sigma_pos`, `Paper.Setting.theta_ne`, `Paper.oracleFactor`, `Paper.oracleRisk`, `Paper.risk` |
| `L01` | 6 | `verification/audits/L01_final.md` | `Paper.L01.L01`, `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `Paper.L01.L01_S4`, `Paper.L01.L01_S5`, `_private.L01.0.Paper.L01.s_ne` |
| `L02` | 4 | `verification/audits/L02_final.md` | `Paper.L02.L02_S1`, `Paper.L02.L02_S2`, `Paper.L02.L02_S3`, `Paper.L02.L02_main` |
| `L02Stmt` | 1 | `verification/audits/L02_gate.md` | `Paper.L02.Conclusion` |

## Declarations in `pv_work/C01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.C01.C01` | 3 | — |  |
| `Paper.C01.C01_S1` | 3 | — |  |
| `Paper.C01.C01_S2` | 3 | h: Paper.Setting #1 #0 |  |
| `Paper.C01.C01_S3` | 3 | — |  |
| `Paper.C01.C01_S4` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

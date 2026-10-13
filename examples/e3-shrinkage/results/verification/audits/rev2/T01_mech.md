# Mechanical audit checks — T01 (`T01`)

Run by: pv-auditor (agent a65cb5cc, session d516f55c), with `python3 scripts/pv_audit_mech.py T01` on 2026-10-12 22:16. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01 exit=0 delivered=d1a4b789bd4c3603eb8ce879027f75da2fa2cc4db4d1fd35b389da4dc4844aaf rebuilt=d1a4b789bd4c3603eb8ce879027f75da2fa2cc4db4d1fd35b389da4dc4844aaf IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate.md` (17 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T01.lean` | PASS | pv-prover (agent a8462936), 2026-10-12 22:15:39 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent a3c5e580), 2026-10-12 22:12:56 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 6 | `verification/audits/DEFS_gate.md` | `Paper.Setting`, `Paper.Setting.mk`, `Paper.Setting.sigma_pos`, `Paper.oracleFactor`, `Paper.oracleRisk`, `Paper.risk` |
| `L01` | 5 | `verification/audits/L01_final.md` | `Paper.L01.L01`, `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `_private.L01.0.Paper.L01.pos_of_setting` |
| `L02Stmt` | 1 | `verification/audits/L02_gate.md` | `Paper.L02.Conclusion` |
| `T01Stmt` | 3 | `verification/audits/T01_gate.md` | `Paper.T01.Conclusion`, `Paper.T01.Conclusion.mk`, `Paper.T01.T01_L02Consumed` |

## Declarations in `pv_work/T01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.Conclusion.eq_iff` | 3 | — | WARNING: the type has 4 leading binders but the proof term binds only 3; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.Conclusion.ge` | 3 | — | WARNING: the type has 4 leading binders but the proof term binds only 3; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.Conclusion.le_min` | 3 | — |  |
| `Paper.T01.T01` | 4 | — |  |
| `Paper.T01.T01_S1` | 4 | — |  |
| `Paper.T01.T01_S2` | 4 | — |  |
| `Paper.T01.T01_S3` | 2 | — |  |
| `Paper.T01.T01_S4` | 2 | — |  |
| `Paper.T01.T01_S5` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

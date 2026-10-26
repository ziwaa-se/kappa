# Mechanical audit checks — L01 (`L01`)

Run by: pv-auditor (agent a90cd083, session d516f55c), with `python3 scripts/pv_audit_mech.py L01` on 2026-10-12 22:08. Probes: `pv_work/probes/auditor/L01/auditor_L01_mech1.lean`, `pv_work/probes/auditor/L01/auditor_L01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L01_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L01 exit=0 delivered=d278d7ba34a76a77c205bbf70e7d43b9f8a5d931a4eff571b9d99218330ed25b rebuilt=d278d7ba34a76a77c205bbf70e7d43b9f8a5d931a4eff571b9d99218330ed25b IDENTICAL log=pv_work/probes/auditor/L01/rebuild/L01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4a | `L01Stmt` fingerprints | PASS | `pv_work/L01Stmt.lean` declares nothing (0 declarations); any gated declaration expected there is still checked in item 4 |
| 4 | statement fingerprints vs `verification/audits/L01_gate.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L01` | PASS | ALL STANDARD |
| 7 | `#pv_walk L01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L01.lean` | PASS | pv-prover (agent a60b94ad), 2026-10-12 22:05:02 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 6 | `verification/audits/DEFS_gate.md` | `Paper.Setting`, `Paper.Setting.mk`, `Paper.Setting.sigma_pos`, `Paper.oracleFactor`, `Paper.oracleRisk`, `Paper.risk` |

## Declarations in `pv_work/L01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem pos_of_setting`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L01.L01` | 4 | — |  |
| `Paper.L01.L01_S1` | 3 | — |  |
| `Paper.L01.L01_S2` | 4 | — |  |
| `Paper.L01.L01_S3` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

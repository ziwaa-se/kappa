# Mechanical audit checks — P02 (`P02`)

Run by: pv-auditor (agent afd5f96e, session cd40fe3b), with `python3 scripts/pv_audit_mech.py P02` on 2026-10-12 22:19. Probes: `pv_work/probes/auditor/P02/auditor_P02_mech1.lean`, `pv_work/probes/auditor/P02/auditor_P02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P02_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P02 exit=0 delivered=bdff0db4872bebd169324f6dba378f6273e2d5419e9224a919057b71d2b0055b rebuilt=bdff0db4872bebd169324f6dba378f6273e2d5419e9224a919057b71d2b0055b IDENTICAL log=pv_work/probes/auditor/P02/rebuild/P02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P02_gate.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P02` | PASS | ALL STANDARD |
| 7 | `#pv_walk P02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P02.lean` | PASS | pv-prover (agent a221578d), 2026-10-12 22:18:51 |
| 12 | last writer of `pv_work/P02Stmt.lean` | PASS | pv-drafter (agent a1207164), 2026-10-12 22:16:12 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 1 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.V` |
| `L01` | 3 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_main` |
| `L01Stmt` | 3 | `verification/audits/L01_gate.md` | `Paper.L01.Conclusion`, `Paper.L01.Conclusion.bound`, `Paper.L01.Conclusion.mk` |
| `P02Stmt` | 1 | `verification/audits/P02_gate.md` | `Paper.P02.Conclusion` |

## Declarations in `pv_work/P02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P02.P02_S1` | 3 | — |  |
| `Paper.P02.P02_S2` | 0 | — |  |
| `Paper.P02.P02_main` | 0 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

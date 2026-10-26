# Mechanical audit checks — L01 (`L01`)

Run by: pv-auditor (agent a0a253c6, session 0a40983b), with `python3 scripts/pv_audit_mech.py L01` on 2026-10-12 22:08. Probes: `pv_work/probes/auditor/L01/auditor_L01_mech1.lean`, `pv_work/probes/auditor/L01/auditor_L01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L01_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L01 exit=0 delivered=f0c56c561350f4b0e9fb3eeb54e8f5633960d1a8eac5a337a7bcc5fe0ca0e58a rebuilt=f0c56c561350f4b0e9fb3eeb54e8f5633960d1a8eac5a337a7bcc5fe0ca0e58a IDENTICAL log=pv_work/probes/auditor/L01/rebuild/L01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L01_gate.md` (12 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L01` | PASS | ALL STANDARD |
| 7 | `#pv_walk L01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L01.lean` | PASS | pv-prover (agent a8f4866c), 2026-10-12 22:07:27 |
| 12 | last writer of `pv_work/L01Stmt.lean` | PASS | pv-drafter (agent ab9498a5), 2026-10-12 21:48:40 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 1 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.V` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Conclusion`, `Paper.L01.Conclusion.mk` |

## Declarations in `pv_work/L01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L01.Conclusion.bound` | 3 | — |  |
| `Paper.L01.Conclusion.identity` | 3 | — |  |
| `Paper.L01.L01_S1` | 1 | — |  |
| `Paper.L01.L01_S2` | 3 | — |  |
| `Paper.L01.L01_main` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

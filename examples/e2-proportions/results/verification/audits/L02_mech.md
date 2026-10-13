# Mechanical audit checks — L02 (`L02`)

Run by: pv-auditor (agent ae78a4e7, session 0a40983b), with `python3 scripts/pv_audit_mech.py L02` on 2026-10-12 22:09. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02 exit=0 delivered=dd4e7282c2c69387cbdb657aeb5b89c2f70ac775519e778a90e16ba1d4b9bec3 rebuilt=dd4e7282c2c69387cbdb657aeb5b89c2f70ac775519e778a90e16ba1d4b9bec3 IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L02` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L02.lean` | PASS | pv-prover (agent a79292b4), 2026-10-12 22:07:27 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent a16202ea), 2026-10-12 21:48:46 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 2 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.IOpen`, `Paper.DEFS.V` |
| `L02Stmt` | 1 | `verification/audits/L02_gate.md` | `Paper.L02.L02Claim` |

## Declarations in `pv_work/L02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 2 | — |  |
| `Paper.L02.L02_S2` | 2 | — |  |
| `Paper.L02.L02_main` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

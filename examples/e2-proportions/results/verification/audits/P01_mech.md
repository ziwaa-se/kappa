# Mechanical audit checks — P01 (`P01`)

Run by: pv-auditor (agent a442afac, session 0a40983b), with `python3 scripts/pv_audit_mech.py P01` on 2026-10-12 22:13. Probes: `pv_work/probes/auditor/P01/auditor_P01_mech1.lean`, `pv_work/probes/auditor/P01/auditor_P01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P01_5.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P01 exit=0 delivered=384504418408fe44d6088f39da0a723431f4c48f09babcc78d6fc250339b4bbf rebuilt=384504418408fe44d6088f39da0a723431f4c48f09babcc78d6fc250339b4bbf IDENTICAL log=pv_work/probes/auditor/P01/rebuild/P01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P01_gate_r2.md` (7 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P01` | PASS | ALL STANDARD |
| 7 | `#pv_walk P01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P01.lean` | PASS | pv-prover (agent ad74d159), 2026-10-12 22:12:54 |
| 12 | last writer of `pv_work/P01Stmt.lean` | PASS | pv-drafter (agent a4df68d1), 2026-10-12 22:09:13 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 2 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.IClosed`, `Paper.DEFS.V` |
| `P01Stmt` | 3 | `verification/audits/P01_gate_r2.md` | `Paper.P01.P01Claim`, `Paper.P01.P01Claim._proof_1`, `Paper.P01.SqrtConcave` |

## Declarations in `pv_work/P01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P01.P01_S0` | 0 | — |  |
| `Paper.P01.P01_S1` | 4 | — |  |
| `Paper.P01.P01_S2` | 3 | — |  |
| `Paper.P01.P01_S3` | 4 | — |  |
| `Paper.P01.P01_main` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

# Mechanical audit checks — C01 (`C01`)

Run by: pv-auditor (agent af43e6f9, session 9fc1c499), with `python3 scripts/pv_audit_mech.py C01` on 2026-10-12 22:42. Probes: `pv_work/probes/auditor/C01/auditor_C01_mech1.lean`, `pv_work/probes/auditor/C01/auditor_C01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `C01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/C01_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD C01 exit=0 delivered=571eea51b3411cfc7893d88d81d316d6049b7a81bd3131637c0d58bc0ed2fa71 rebuilt=571eea51b3411cfc7893d88d81d316d6049b7a81bd3131637c0d58bc0ed2fa71 IDENTICAL log=pv_work/probes/auditor/C01/rebuild/C01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/C01_gate.md` (6 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms C01` | PASS | ALL STANDARD |
| 7 | `#pv_walk C01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: C01_L03Consumed |
| 12 | last writer of `pv_work/C01.lean` | PASS | pv-prover (agent a02748f2), 2026-10-12 22:32:27 |
| 12 | last writer of `pv_work/C01Stmt.lean` | PASS | pv-drafter (agent abba9a2c), 2026-10-12 22:26:45 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `C01Stmt` | 3 | `verification/audits/C01_gate.md` | `Paper.C01.C01_L03Consumed`, `Paper.C01.Conclusion`, `Paper.C01.Conclusion._proof_1` |
| `Defs` | 3 | `verification/audits/DEFS_gate.md` | `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleVar` |

## Declarations in `pv_work/C01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.C01.C01_S1` | 4 | — |  |
| `Paper.C01.C01_S2` | 4 | — |  |
| `Paper.C01.C01_S3` | 0 | — |  |
| `Paper.C01.C01_main` | 5 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: C01_L03Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

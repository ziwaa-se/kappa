# Mechanical audit checks — L03 (`L03ModGaps`)

Run by: pv-auditor (agent a47540ea, session 9fc1c499), with `python3 scripts/pv_audit_mech.py L03 --module L03ModGaps` on 2026-10-12 22:20. Probes: `pv_work/probes/auditor/L03/auditor_L03_mech1.lean`, `pv_work/probes/auditor/L03/auditor_L03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L03ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L03ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L03ModGaps exit=0 delivered=46f5ba38c616703d254545e5322136eaec21d72f97121ceb59b5be2a32db60c7 rebuilt=46f5ba38c616703d254545e5322136eaec21d72f97121ceb59b5be2a32db60c7 IDENTICAL log=pv_work/probes/auditor/L03/rebuild/L03ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L03_gate.md` (5 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.L03.L03_S3_Gap`: vh = snapshot th of `Paper.L03.L03_S3` |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L03ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk L03ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L03ModGaps.lean` | PASS | pv-prover (agent a5cf5cc2), 2026-10-12 22:17:51 |
| 12 | last writer of `pv_work/L03Stmt.lean` | PASS | pv-drafter (agent a984b44a), 2026-10-12 22:15:12 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 3 | `verification/audits/DEFS_gate.md` | `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleVar` |
| `L02` | 3 | `verification/audits/L02_final.md` | `Paper.L02.L02_S1`, `Paper.L02.L02_S2`, `Paper.L02.L02_main` |
| `L02Stmt` | 1 | `verification/audits/L02_gate.md` | `Paper.L02.Conclusion` |
| `L03Stmt` | 1 | `verification/audits/L03_gate.md` | `Paper.L03.Conclusion` |

## Declarations in `pv_work/L03ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L03.L03_S1` | 3 | — |  |
| `Paper.L03.L03_S2` | 2 | — |  |
| `Paper.L03.L03_main_mod_gaps` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.L03.L03_main` renamed to `Paper.L03.L03_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

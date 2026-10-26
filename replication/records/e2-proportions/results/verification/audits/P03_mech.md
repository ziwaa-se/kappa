# Mechanical audit checks — P03 (`P03ModGaps`)

Run by: pv-auditor (agent a5d82b94, session cd40fe3b), with `python3 scripts/pv_audit_mech.py P03 --module P03ModGaps` on 2026-10-12 22:27. Probes: `pv_work/probes/auditor/P03/auditor_P03_mech1.lean`, `pv_work/probes/auditor/P03/auditor_P03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P03ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P03ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P03ModGaps exit=0 delivered=dd2196b2b78b5b28f2b58fddb3f55d9b3e3422689d8fc8f7c7940a17469da7cf rebuilt=dd2196b2b78b5b28f2b58fddb3f55d9b3e3422689d8fc8f7c7940a17469da7cf IDENTICAL log=pv_work/probes/auditor/P03/rebuild/P03ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P03_gate.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.P03.P03_S1_Gap`: vh = snapshot th of `Paper.P03.P03_S1` |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P03ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk P03ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P03ModGaps.lean` | PASS | pv-prover (agent aa3eb0f7), 2026-10-12 22:23:35 |
| 12 | last writer of `pv_work/P03Stmt.lean` | PASS | pv-drafter (agent a62d8cde), 2026-10-12 22:16:12 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 2 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.mean`, `Paper.DEFS.s2` |
| `P03Stmt` | 2 | `verification/audits/P03_gate.md` | `Paper.P03.P03Concl`, `Paper.P03.P03Concl._proof_1` |

## Declarations in `pv_work/P03ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma s2_nonneg`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P03.P03_S2` | 4 | — |  |
| `Paper.P03.P03_main_mod_gaps` | 5 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.P03.P03_main` renamed to `Paper.P03.P03_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

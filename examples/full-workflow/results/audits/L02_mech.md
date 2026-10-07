# Mechanical audit checks — L02 (`L02`)

Run by the auditor with `python3 scripts/pv_audit_mech.py L02` on 2026-09-30 20:50. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02 exit=0 delivered=add4d82319e79e538a8d473078ec52291bb6f3c0bb6d93644db525078aed6821 rebuilt=add4d82319e79e538a8d473078ec52291bb6f3c0bb6d93644db525078aed6821 IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate.md` (5 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms L02` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| — | 0 | — | — |

## Declarations in `pv_work/L02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 2 | — |  |
| `Paper.L02.L02_S2` | 2 | — |  |
| `Paper.L02.L02_S3` | 1 | — |  |
| `Paper.L02.L02_S4` | 1 | — |  |
| `Paper.L02.L02_main` | 2 | — |  |

## For the auditor (judgement not done by this script)

- probe `pv_work/probes/auditor/L02/auditor_L02_mech1.lean` had errors (log `pv_work/logs/auditor_L02_mech1_1.log`):
```
pv_work/probes/auditor/L02/auditor_L02_mech1.lean:3:0: error: no constants found for module L02Stmt; is it imported, and is the module name right?
TYPE HASHES L02 (5 declarations)
Paper.L02.L02_S1|thm|th=399946927|vh=-|bi=ee
Paper.L02.L02_S2|thm|th=2050626304|vh=-|bi=ee
Paper.L02.L02_S3|thm|th=2900165390|vh=-|bi=e
Paper.L02.L02_S4|thm|th=2894931473|vh=-|bi=e
Paper.L02.L02_main|thm|th=2848314126|vh=-|bi=ee
OK|Paper.L02.L02_S1|[propext, Classical.choice, Quot.sound]
```
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: FAIL (probe)

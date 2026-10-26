# Mechanical audit checks — L01 (`L01`)

Run by: pv-auditor (agent ad2a0d37, session c0e71d40), with `python3 scripts/pv_audit_mech.py L01` on 2026-10-12 22:27. Probes: `pv_work/probes/auditor/L01/auditor_L01_mech1.lean`, `pv_work/probes/auditor/L01/auditor_L01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L01_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L01 exit=0 delivered=76b7722d22bd7f2bc0216d3fa3ee74addfed5eca6f0e3631c6f5f63b6d346b38 rebuilt=76b7722d22bd7f2bc0216d3fa3ee74addfed5eca6f0e3631c6f5f63b6d346b38 IDENTICAL log=pv_work/probes/auditor/L01/rebuild/L01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L01_gate.md` (8 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L01` | PASS | ALL STANDARD |
| 7 | `#pv_walk L01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L01.lean` | PASS | pv-prover (agent a2a164fe), 2026-10-12 22:24:02 |
| 12 | last writer of `pv_work/L01Stmt.lean` | PASS | pv-drafter (agent a969dded), 2026-10-12 22:03:20 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 7 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.xLF` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl._proof_1`, `Paper.L01.ConclFixedDelta` |

## Declarations in `pv_work/L01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L01.L01_S1` | 5 | — |  |
| `Paper.L01.L01_S2` | 6 | — |  |
| `Paper.L01.L01_S3` | 7 | — |  |
| `Paper.L01.L01_S4` | 6 | — |  |
| `Paper.L01.L01_S5` | 7 | — |  |
| `Paper.L01.L01_main_fixedDelta` | 7 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

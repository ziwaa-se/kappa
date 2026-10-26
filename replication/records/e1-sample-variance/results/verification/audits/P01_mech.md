# Mechanical audit checks — P01 (`P01`)

Run by: pv-auditor (agent a64ecd69, session bc9967e9), with `python3 scripts/pv_audit_mech.py P01` on 2026-10-12 22:12. Probes: `pv_work/probes/auditor/P01/auditor_P01_mech1.lean`, `pv_work/probes/auditor/P01/auditor_P01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P01_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P01 exit=0 delivered=63ba92a19120f49c3a53d64adc64b7462ebb8bc5471698e6cf7b9a6baa6ffb19 rebuilt=63ba92a19120f49c3a53d64adc64b7462ebb8bc5471698e6cf7b9a6baa6ffb19 IDENTICAL log=pv_work/probes/auditor/P01/rebuild/P01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P01_gate_r2.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P01` | PASS | ALL STANDARD |
| 7 | `#pv_walk P01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: Popoviciu |
| 12 | last writer of `pv_work/P01.lean` | PASS | pv-prover (agent a2df58ca), 2026-10-12 22:12:02 |
| 12 | last writer of `pv_work/P01Stmt.lean` | PASS | pv-drafter (agent ad0ae000), 2026-10-12 22:08:30 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 3 | `verification/audits/DEFS_gate.md` | `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleVar` |
| `P01Stmt` | 2 | `verification/audits/P01_gate_r2.md` | `Paper.P01.Popoviciu`, `Paper.P01.Popoviciu._proof_1` |

## Declarations in `pv_work/P01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P01.P01` | 7 | — |  |
| `Paper.P01.P01_S1` | 7 | — |  |
| `Paper.P01.P01_S2` | 6 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: Popoviciu

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

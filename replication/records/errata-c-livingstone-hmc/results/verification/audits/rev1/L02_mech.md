# Mechanical audit checks — L02 (`L02ModGaps`)

Run by: pv-auditor (agent a5b3aa04, session 094f9f86), with `python3 scripts/pv_audit_mech.py L02 --module L02ModGaps` on 2026-10-13 01:07. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02ModGaps exit=0 delivered=deaec769bfc46b2d5d5c6f81c1397dd615aa5911136653b710b63a303b00004c rebuilt=deaec769bfc46b2d5d5c6f81c1397dd615aa5911136653b710b63a303b00004c IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate_r2.md` (19 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.L02.L02_main_Gap`: vh = snapshot th of `Paper.L02.L02_main`; `Paper.L02.L02_main_fixedDelta_Gap`: vh = snapshot th of `Paper.L02.L02_main_fixedDelta` |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L02ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L02ModGaps.lean` | PASS | pv-prover (agent a57dd552), 2026-10-12 22:41:03 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent a599f936), 2026-10-12 22:14:30 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 9 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillations`, `Paper.Defs.HypOscillations._proof_3`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.xLF` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl._proof_1`, `Paper.L01.ConclFixedDelta` |
| `L02Stmt` | 4 | `verification/audits/L02_gate_r2.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1`, `Paper.L02.ConclFixedDelta`, `Paper.L02.L02_L01Consumed` |

## Declarations in `pv_work/L02ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma gen`, `lemma hbig`, `lemma norm5`, `lemma ple`, `lemma seq_mono`, `lemma seq_sum`, `lemma step_bound`, `lemma x1_bound`, `lemma xLF_diff`, `lemma xLF_one`, `lemma xLF_rec`, `lemma xLF_zero`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 5 | — |  |
| `Paper.L02.L02_S10` | 10 | — |  |
| `Paper.L02.L02_S11` | 12 | hδ: LT.lt.{0} Real Real.instLT #0 (OfNat.ofNat.{0} Real 1 (One.t |  |
| `Paper.L02.L02_S1_general` | 6 | — |  |
| `Paper.L02.L02_S2` | 7 | — |  |
| `Paper.L02.L02_S3` | 9 | — |  |
| `Paper.L02.L02_S4` | 8 | — |  |
| `Paper.L02.L02_S5` | 7 | — |  |
| `Paper.L02.L02_S6` | 10 | — |  |
| `Paper.L02.L02_S7` | 7 | — |  |
| `Paper.L02.L02_S8a` | 10 | — |  |
| `Paper.L02.L02_S8b` | 8 | heps: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.L02.L02_S9` | 9 | — |  |
| `Paper.L02.L02_main_fixedDelta_osc` | 10 | — |  |
| `Paper.L02.L02_main_fixedDelta_mod_gaps` | 8 | — |  |
| `Paper.L02.L02_main_mod_gaps` | 8 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

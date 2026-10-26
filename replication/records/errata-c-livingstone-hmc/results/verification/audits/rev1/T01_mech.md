# Mechanical audit checks — T01 (`T01`)

Run by: pv-auditor (agent ad0640bf, session 140c7d85), with `python3 scripts/pv_audit_mech.py T01` on 2026-10-13 01:54. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01 exit=0 delivered=fa9b4bf41a246431ba424208f190df1c93edc807b6a069ebc9d44d506c83acc7 rebuilt=fa9b4bf41a246431ba424208f190df1c93edc807b6a069ebc9d44d506c83acc7 IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate.md` (16 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: T02_L02Consumed |
| 12 | last writer of `pv_work/T01.lean` | PASS | pv-prover (agent a1697526), 2026-10-13 01:54:13 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent a5f0f285), 2026-10-13 01:40:58 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 16 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.HypOscillations`, `Paper.Defs.HypOscillations._proof_3`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep` … |
| `L02Stmt` | 2 | `verification/audits/L02_gate_r2.md` | `Paper.L02.Concl._proof_1`, `Paper.L02.ConclFixedDelta` |
| `L03` | 30 | `verification/audits/L03_final.md` | `Paper.L03.L03_S1`, `Paper.L03.L03_S10`, `Paper.L03.L03_S11`, `Paper.L03.L03_S12`, `Paper.L03.L03_S12._proof_1`, `Paper.L03.L03_S2`, `Paper.L03.L03_S2._proof_1`, `Paper.L03.L03_S3`, `Paper.L03.L03_S4a`, `Paper.L03.L03_S4a._proof_1`, `Paper.L03.L03_S4a._proof_2`, `Paper.L03.L03_S4a._proof_3` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.L03_L02Consumed`, `Paper.L03.L03_L02Consumed._proof_1` |
| `T01Stmt` | 7 | `verification/audits/T01_gate.md` | `Paper.T01.HypPartI`, `Paper.T01.HypPartII`, `Paper.T01.T01Concl`, `Paper.T01.T01Concl.mk`, `Paper.T01.Thm518`, `Paper.T01.Thm518._proof_1`, `Paper.T01.Thm518._proof_2` |
| `T02` | 10 | `verification/audits/T02_final.md` | `Paper.Defs.tailMomFilter.eq_1`, `Paper.T02.T02_S2`, `Paper.T02.T02_S3`, `Paper.T02.T02_S5`, `Paper.T02.T02_S6`, `Paper.T02.T02_S7`, `Paper.T02.T02_S7'`, `Paper.T02.T02_S8`, `Paper.T02.T02_main`, `_private.T02.0.Paper.T02.tail_ne_zero` |
| `T02Stmt` | 16 | `verification/audits/T02_gate_r2.md` | `Paper.T02.GaussFacts`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.Prop35`, `Paper.T02.T02_L02Consumed`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcStep` … |

## Declarations in `pv_work/T01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.T01Concl.partI` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01Concl.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01_S1` | 14 | — |  |
| `Paper.T01.T01_S2` | 3 | — |  |
| `Paper.T01.T01_S3` | 12 | — |  |
| `Paper.T01.T01_main` | 14 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: T02_L02Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

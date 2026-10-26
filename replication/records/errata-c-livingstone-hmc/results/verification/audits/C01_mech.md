# Mechanical audit checks — C01 (`C01`)

Run by: pv-auditor (agent a5355964, session 13bf576d), with `python3 scripts/pv_audit_mech.py C01` on 2026-10-13 11:34. Probes: `pv_work/probes/auditor/C01/auditor_C01_mech1.lean`, `pv_work/probes/auditor/C01/auditor_C01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `C01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/C01_8.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD C01 exit=0 delivered=e9ffc14424c490f7beb022ac28f7fa1edc013ade9780b1354fee3ab4434faf07 rebuilt=e9ffc14424c490f7beb022ac28f7fa1edc013ade9780b1354fee3ab4434faf07 IDENTICAL log=pv_work/probes/auditor/C01/rebuild/C01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/C01_gate.md` (21 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms C01` | PASS | ALL STANDARD |
| 7 | `#pv_walk C01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: T01_Thm518 |
| 12 | last writer of `pv_work/C01.lean` | PASS | pv-prover (agent ae2987f5), 2026-10-13 11:33:56 |
| 12 | last writer of `pv_work/C01Stmt.lean` | PASS | pv-drafter (agent a3bb7fb0), 2026-10-13 11:27:33 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `C01Stmt` | 8 | `verification/audits/C01_gate.md` | `Paper.C01.C01Concl`, `Paper.C01.C01Concl.mk`, `Paper.C01.C01_T01Consumed`, `Paper.C01.C01_T01Consumed._proof_2`, `Paper.C01.C01_T01Consumed._proof_3`, `Paper.C01.InExpFam`, `Paper.C01.TailGrad`, `Paper.C01.TailGrad._proof_1` |
| `Defs` | 13 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1` |
| `T01Stmt` | 1 | `verification/audits/T01_gate_r2.md` | `Paper.T01.HypPartII` |
| `T02Stmt` | 12 | `verification/audits/T02_gate_r2.md` | `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcStep`, `Paper.T02.targetMeas`, `Paper.T02.targetMeas._proof_4`, `Paper.T02.tvDist` |

## Declarations in `pv_work/C01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma expfam_U`, `lemma expfam_fin`, `lemma expfam_grad`, `lemma grad_vec_aux`, `lemma norm1`, `lemma nz_of_pos`, `lemma rpow_sq_aux`, `lemma tail_norm_of_tg`, `lemma tail_norm_of_vec`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.C01.C01Concl.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.C01.C01_S1a` | 7 | — |  |
| `Paper.C01.C01_S1b` | 5 | — | WARNING: the type has 7 leading binders but the proof term binds only 5; usage of the remaining 2 hypotheses is unknown |
| `Paper.C01.C01_S1c` | 13 | — |  |
| `Paper.C01.C01_S2` | 6 | — |  |
| `Paper.C01.C01_S3` | 7 | — |  |
| `Paper.C01.C01_S4` | 7 | — |  |
| `Paper.C01.C01_S5a` | 7 | hL: LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 1 (instOfNatNat |  |
| `Paper.C01.C01_S5b` | 7 | — |  |
| `Paper.C01.C01_S6` | 13 | — |  |
| `Paper.C01.C01_main` | 12 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- external inputs registered for C01 but not reached by any gated theorem (T01_Thm518): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

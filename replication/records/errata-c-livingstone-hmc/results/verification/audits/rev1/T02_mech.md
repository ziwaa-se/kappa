# Mechanical audit checks — T02 (`T02`)

Run by: pv-auditor (agent abc7e12a, session 094f9f86), with `python3 scripts/pv_audit_mech.py T02` on 2026-10-13 01:29. Probes: `pv_work/probes/auditor/T02/auditor_T02_mech1.lean`, `pv_work/probes/auditor/T02/auditor_T02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T02_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T02 exit=0 delivered=6ba1998371cc443ecff2eb8de5ab17d8138e8d320d2e61ac31b4c3a704e6a572 rebuilt=6ba1998371cc443ecff2eb8de5ab17d8138e8d320d2e61ac31b4c3a704e6a572 IDENTICAL log=pv_work/probes/auditor/T02/rebuild/T02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T02_gate_r2.md` (21 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T02` | PASS | ALL STANDARD |
| 7 | `#pv_walk T02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T02.lean` | PASS | pv-prover (agent a28cf209), 2026-10-13 01:28:32 |
| 12 | last writer of `pv_work/T02Stmt.lean` | PASS | pv-drafter (agent abbb642d), 2026-10-13 01:20:56 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 16 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.HypOscillations`, `Paper.Defs.HypOscillations._proof_3`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep` … |
| `L02Stmt` | 2 | `verification/audits/L02_gate_r2.md` | `Paper.L02.Concl._proof_1`, `Paper.L02.ConclFixedDelta` |
| `L03` | 30 | `verification/audits/L03_final.md` | `Paper.L03.L03_S1`, `Paper.L03.L03_S10`, `Paper.L03.L03_S11`, `Paper.L03.L03_S12`, `Paper.L03.L03_S12._proof_1`, `Paper.L03.L03_S2`, `Paper.L03.L03_S2._proof_1`, `Paper.L03.L03_S3`, `Paper.L03.L03_S4a`, `Paper.L03.L03_S4a._proof_1`, `Paper.L03.L03_S4a._proof_2`, `Paper.L03.L03_S4a._proof_3` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.L03_L02Consumed`, `Paper.L03.L03_L02Consumed._proof_1` |
| `T02Stmt` | 16 | `verification/audits/T02_gate_r2.md` | `Paper.T02.GaussFacts`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.Prop35`, `Paper.T02.T02_L02Consumed`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcStep` … |

## Declarations in `pv_work/T02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma acc_meas`, `lemma acc_nonneg`, `lemma gU_meas`, `lemma intg01`, `lemma lf_meas`, `lemma step_meas`, `lemma tail_ne_zero`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T02.T02_S1` | 7 | — |  |
| `Paper.T02.T02_S2` | 13 | — |  |
| `Paper.T02.T02_S3` | 9 | — |  |
| `Paper.T02.T02_S4` | 10 | — |  |
| `Paper.T02.T02_S5` | 4 | — |  |
| `Paper.T02.T02_S6` | 13 | hgrad: Paper.Defs.IsGradField #5 #4 #3 |  |
| `Paper.T02.T02_S7` | 10 | — |  |
| `Paper.T02.T02_S7'` | 6 | — |  |
| `Paper.T02.T02_S8` | 12 | — |  |
| `Paper.T02.T02_main` | 16 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

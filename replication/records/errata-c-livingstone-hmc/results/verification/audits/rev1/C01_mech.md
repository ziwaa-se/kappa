# Mechanical audit checks — C01 (`C01ModGaps`)

Run by: pv-auditor (agent ad435438, session 140c7d85), with `python3 scripts/pv_audit_mech.py C01 --module C01ModGaps` on 2026-10-13 02:12. Probes: `pv_work/probes/auditor/C01/auditor_C01_mech1.lean`, `pv_work/probes/auditor/C01/auditor_C01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `C01ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/C01ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD C01ModGaps exit=0 delivered=f3d3c72a329ec33d3aa43219f66f8344a4ad22b5cda08cc8b2408f67d5e53748 rebuilt=f3d3c72a329ec33d3aa43219f66f8344a4ad22b5cda08cc8b2408f67d5e53748 IDENTICAL log=pv_work/probes/auditor/C01/rebuild/C01ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/C01_gate.md` (15 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | MANUAL | `Paper.C01.C01_S2_Gap`: vh ≠ snapshot th of `Paper.C01.C01_S2`: manual check |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms C01ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk C01ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: T01_Thm518 |
| 12 | last writer of `pv_work/C01ModGaps.lean` | PASS | pv-prover (agent aa41de3e), 2026-10-13 02:09:40 |
| 12 | last writer of `pv_work/C01Stmt.lean` | PASS | pv-drafter (agent af648019), 2026-10-13 01:59:55 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `C01Stmt` | 3 | `verification/audits/C01_gate.md` | `Paper.C01.C01Concl`, `Paper.C01.C01Concl.mk`, `Paper.C01.InExpFam` |
| `Defs` | 16 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.HypOscillations`, `Paper.Defs.HypOscillations._proof_3`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep` … |
| `L02Stmt` | 2 | `verification/audits/L02_gate_r2.md` | `Paper.L02.Concl._proof_1`, `Paper.L02.ConclFixedDelta` |
| `L03` | 30 | `verification/audits/L03_final.md` | `Paper.L03.L03_S1`, `Paper.L03.L03_S10`, `Paper.L03.L03_S11`, `Paper.L03.L03_S12`, `Paper.L03.L03_S12._proof_1`, `Paper.L03.L03_S2`, `Paper.L03.L03_S2._proof_1`, `Paper.L03.L03_S3`, `Paper.L03.L03_S4a`, `Paper.L03.L03_S4a._proof_1`, `Paper.L03.L03_S4a._proof_2`, `Paper.L03.L03_S4a._proof_3` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.L03_L02Consumed`, `Paper.L03.L03_L02Consumed._proof_1` |
| `T01` | 4 | `verification/audits/T01_final_r2.md` | `Paper.T01.T01_S1`, `Paper.T01.T01_S2`, `Paper.T01.T01_S3`, `Paper.T01.T01_main` |
| `T01Stmt` | 9 | `verification/audits/T01_gate.md` | `Paper.T01.HypPartI`, `Paper.T01.HypPartII`, `Paper.T01.T01Concl`, `Paper.T01.T01Concl.mk`, `Paper.T01.T01Concl.partI`, `Paper.T01.T01Concl.partII`, `Paper.T01.Thm518`, `Paper.T01.Thm518._proof_1`, `Paper.T01.Thm518._proof_2` |
| `T02` | 10 | `verification/audits/T02_final.md` | `Paper.Defs.tailMomFilter.eq_1`, `Paper.T02.T02_S2`, `Paper.T02.T02_S3`, `Paper.T02.T02_S5`, `Paper.T02.T02_S6`, `Paper.T02.T02_S7`, `Paper.T02.T02_S7'`, `Paper.T02.T02_S8`, `Paper.T02.T02_main`, `_private.T02.0.Paper.T02.tail_ne_zero` |
| `T02Stmt` | 16 | `verification/audits/T02_gate_r2.md` | `Paper.T02.GaussFacts`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.Prop35`, `Paper.T02.T02_L02Consumed`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcStep` … |

## Declarations in `pv_work/C01ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma expfam_U`, `lemma expfam_grad`, `lemma grad_norm_aux`, `lemma rpow_sq_aux`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.C01.C01Concl.partII` | 7 | — | WARNING: the type has 8 leading binders but the proof term binds only 7; usage of the remaining 1 hypotheses is unknown |
| `Paper.C01.C01_S1` | 7 | — |  |
| `Paper.C01.C01_S3` | 8 | gU: (Paper.Defs.E (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) -> ( |  |
| `Paper.C01.C01_S4` | 7 | — |  |
| `Paper.C01.C01_S5` | 8 | — |  |
| `Paper.C01.C01_main_mod_gaps` | 16 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.C01.C01_S2_Gap`: its vh differs from the snapshot th of `Paper.C01.C01_S2`. Auxiliary proof constants are named after their declaration (a real numeral `2 : ℝ` becomes `instOfNatAtLeastTwo … Paper.C01.C01_S2_Gap._proof_1`), so identical statements can hash differently. Decide with the §2b probe: import `C01ModGaps`, redeclare `Paper.C01.C01_S2` verbatim under its original full name, confirm its th equals the snapshot, then `example : Paper.C01.C01_S2_Gap = type_of% @Paper.C01.C01_S2 := rfl`.
- `Paper.C01.C01_main` renamed to `Paper.C01.C01_main_mod_gaps`: do the §2b copy-and-`example` check
- external inputs registered for C01 but not reached by any gated theorem (T01_Thm518): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (3 manual checks listed above)

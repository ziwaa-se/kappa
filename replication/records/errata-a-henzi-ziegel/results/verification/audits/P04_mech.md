# Mechanical audit checks — P04 (`P04`)

Run by: pv-auditor (agent abc54ad8, session 8d34e999), with `python3 scripts/pv_audit_mech.py P04` on 2026-10-13 10:47. Probes: `pv_work/probes/auditor/P04/auditor_P04_mech1.lean`, `pv_work/probes/auditor/P04/auditor_P04_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P04` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P04_21.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P04 exit=0 delivered=db55f693947fa586e89f5ab5213e7be9100eb6656b54a5f922a97ac064380b29 rebuilt=db55f693947fa586e89f5ab5213e7be9100eb6656b54a5f922a97ac064380b29 IDENTICAL log=pv_work/probes/auditor/P04/rebuild/P04.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P04_gate_r2.md` (55 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms P04` | PASS | ALL STANDARD |
| 7 | `#pv_walk P04`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: P04_MixingOfStrict, P04_T01Consumed |
| 12 | last writer of `pv_work/P04.lean` | PASS | pv-prover (agent a64e7992), 2026-10-13 10:42:33 |
| 12 | last writer of `pv_work/P04Stmt.lean` | PASS | pv-drafter (agent ac1e3271), 2026-10-13 02:30:00 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 9 | `verification/audits/DEFS_gate_r2.md` | `Paper.Erep`, `Paper.HS`, `Paper.IsConsistent`, `Paper.IsEValue`, `Paper.IsMixingMeasure`, `Paper.IsStrictlyConsistent`, `Paper.elemScore`, `Paper.expPi`, `Paper.mixtureScore` |
| `P04Stmt` | 24 | `verification/audits/P04_gate_r2.md` | `Paper.P04.HSc`, `Paper.P04.HScInt`, `Paper.P04.Ik`, `Paper.P04.IsEValueUnder`, `Paper.P04.Mk`, `Paper.P04.P04Conclusion`, `Paper.P04.P04Conclusion.mk`, `Paper.P04.P04_MixingOfStrict`, `Paper.P04.P04_T01Consumed`, `Paper.P04.SeqSetting`, `Paper.P04.SeqSetting.Y_adapted`, `Paper.P04.SeqSetting.Y_mem` … |
| `T01Stmt` | 1 | `verification/audits/T01_gate.md` | `Paper.T01.MixtureRep` |

## Declarations in `pv_work/P04.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma Mk_meas`, `lemma Mk_range`, `lemma Mk_zero`, `lemma S0_mono`, `lemma S1_anti`, `lemma clamp_eq`, `lemma clamp_mem`, `lemma clamp_mono`, `lemma core6`, `lemma filtK_eq`, `lemma filtK_le`, `lemma fk_div`, `lemma fk_ge`, `lemma fk_le_iff`, `lemma lint_condExp`, `lemma meas_Erep`, `lemma meas_S0`, `lemma meas_S1`, `lemma meas_SZ`, `lemma meas_Sb`, `lemma prod_meas`, `lemma pt_bound`, `theorem cond_prep`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P04.P04Conclusion.evalue` | 12 | — |  |
| `Paper.P04.P04Conclusion.measurable` | 12 | — |  |
| `Paper.P04.P04_S0` | 22 | hh: LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 1 (instOfNatNat |  |
| `Paper.P04.P04_S1` | 19 | hh: LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 1 (instOfNatNat |  |
| `Paper.P04.P04_S10` | 23 | — |  |
| `Paper.P04.P04_S11` | 19 | hT: LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (in |  |
| `Paper.P04.P04_S12` | 4 | — |  |
| `Paper.P04.P04_S13` | 11 | — |  |
| `Paper.P04.P04_S14` | 11 | hh: LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat |  |
| `Paper.P04.P04_S2` | 13 | — |  |
| `Paper.P04.P04_S3` | 15 | hT: LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (in |  |
| `Paper.P04.P04_S4` | 14 | — |  |
| `Paper.P04.P04_S5` | 20 | — |  |
| `Paper.P04.P04_S6` | 20 | — |  |
| `Paper.P04.P04_S7` | 19 | — |  |
| `Paper.P04.P04_S8` | 9 | — |  |
| `Paper.P04.P04_S9a` | 16 | — |  |
| `Paper.P04.P04_S9b` | 21 | hk: Membership.mem.{0, 0} Nat (Finset.{0} Nat) (Finset.instMembe |  |
| `Paper.P04.P04_S9c` | 24 | — |  |
| `Paper.P04.P04_main` | 19 | — |  |
| `Paper.P04.SeqSetting.Y_adapted` | 9 | — | WARNING: the type has 10 leading binders but the proof term binds only 9; usage of the remaining 1 hypotheses is unknown |
| `Paper.P04.SeqSetting.Y_mem` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |
| `Paper.P04.SeqSetting.c_adapted` | 9 | — | WARNING: the type has 10 leading binders but the proof term binds only 9; usage of the remaining 1 hypotheses is unknown |
| `Paper.P04.SeqSetting.c_mem` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |
| `Paper.P04.SeqSetting.lam_adapted` | 9 | — | WARNING: the type has 10 leading binders but the proof term binds only 9; usage of the remaining 1 hypotheses is unknown |
| `Paper.P04.SeqSetting.lam_mem` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |
| `Paper.P04.SeqSetting.lam_zero` | 9 | — | WARNING: the type has 12 leading binders but the proof term binds only 9; usage of the remaining 3 hypotheses is unknown |
| `Paper.P04.SeqSetting.p_adapted` | 9 | — | WARNING: the type has 10 leading binders but the proof term binds only 9; usage of the remaining 1 hypotheses is unknown |
| `Paper.P04.SeqSetting.p_mem` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |
| `Paper.P04.SeqSetting.q_adapted` | 9 | — | WARNING: the type has 10 leading binders but the proof term binds only 9; usage of the remaining 1 hypotheses is unknown |
| `Paper.P04.SeqSetting.q_mem` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |

## Conditions traced (item 11)

TRACED CONDITIONS: P04_MixingOfStrict, P04_T01Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

# Mechanical audit checks — P05 (`P05`)

Run by: pv-auditor (agent ab82983a, session 8d34e999), with `python3 scripts/pv_audit_mech.py P05` on 2026-10-13 11:04. Probes: `pv_work/probes/auditor/P05/auditor_P05_mech1.lean`, `pv_work/probes/auditor/P05/auditor_P05_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P05` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P05_9.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P05 exit=0 delivered=4bb8caa13ef211ff9bae2a1724e93ce32c6fae62bf5f1be035ecb61440663e4a rebuilt=4bb8caa13ef211ff9bae2a1724e93ce32c6fae62bf5f1be035ecb61440663e4a IDENTICAL log=pv_work/probes/auditor/P05/rebuild/P05.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P05_gate_r2.md` (21 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms P05` | PASS | ALL STANDARD |
| 7 | `#pv_walk P05`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: P05_P04Consumed |
| 12 | last writer of `pv_work/P05.lean` | PASS | pv-prover (agent ab73ec63), 2026-10-13 11:02:00 |
| 12 | last writer of `pv_work/P05Stmt.lean` | PASS | pv-drafter (agent aac6e3c0), 2026-10-13 10:44:20 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 8 | `verification/audits/DEFS_gate_r2.md` | `Paper.Erep`, `Paper.HS`, `Paper.IsConsistent`, `Paper.IsMixingMeasure`, `Paper.IsStrictlyConsistent`, `Paper.elemScore`, `Paper.expPi`, `Paper.mixtureScore` |
| `P04Stmt` | 19 | `verification/audits/P04_gate_r2.md` | `Paper.P04.HSc`, `Paper.P04.HScInt`, `Paper.P04.Ik`, `Paper.P04.Mk`, `Paper.P04.SeqSetting`, `Paper.P04.SeqSetting.Y_adapted`, `Paper.P04.SeqSetting.Y_mem`, `Paper.P04.SeqSetting.c_mem`, `Paper.P04.SeqSetting.lam_adapted`, `Paper.P04.SeqSetting.lam_mem`, `Paper.P04.SeqSetting.lam_zero`, `Paper.P04.SeqSetting.mk` … |
| `P05Stmt` | 6 | `verification/audits/P05_gate_r2.md` | `Paper.P05.IsStopTime`, `Paper.P05.IsStopTime.le_meas`, `Paper.P05.IsStopTime.mk`, `Paper.P05.IsStopTime.pos`, `Paper.P05.P05Conclusion`, `Paper.P05.P05_P04Consumed` |
| `T01Stmt` | 1 | `verification/audits/T01_gate.md` | `Paper.T01.MixtureRep` |

## Declarations in `pv_work/P05.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma Erep_nonneg`, `lemma S0_mono`, `lemma S1_anti`, `lemma clamp_eq`, `lemma clamp_mem`, `lemma clamp_mono`, `lemma core1`, `lemma fk_le_iff`, `lemma lint_condExp`, `lemma meas_Erep`, `lemma meas_S0`, `lemma meas_S1`, `lemma meas_SZ`, `lemma meas_Sb`, `lemma meas_factor`, `lemma ofReal_sum_le'`, `lemma pt_bound1`, `theorem cond_prep`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P05.IsStopTime.le_meas` | 5 | — | WARNING: the type has 6 leading binders but the proof term binds only 5; usage of the remaining 1 hypotheses is unknown |
| `Paper.P05.IsStopTime.pos` | 5 | — | WARNING: the type has 6 leading binders but the proof term binds only 5; usage of the remaining 1 hypotheses is unknown |
| `Paper.P05.P05_S0` | 15 | — |  |
| `Paper.P05.P05_S1` | 9 | — |  |
| `Paper.P05.P05_S2` | 13 | — |  |
| `Paper.P05.P05_S3` | 4 | — |  |
| `Paper.P05.P05_S4` | 10 | hk: Membership.mem.{0, 0} Nat (Finset.{0} Nat) (Finset.instMembe |  |
| `Paper.P05.P05_S5` | 11 | — |  |
| `Paper.P05.P05_S6` | 17 | hh: LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat, hk: Membership.mem.{0, 0} Nat (Finset.{0} Nat) (Finset.instMembe |  |
| `Paper.P05.P05_S7` | 22 | — |  |
| `Paper.P05.P05_S8` | 20 | — |  |
| `Paper.P05.P05_main` | 18 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- external inputs registered for P05 but not reached by any gated theorem (P05_P04Consumed): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

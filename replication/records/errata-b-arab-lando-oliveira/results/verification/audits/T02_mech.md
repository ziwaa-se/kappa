# Mechanical audit checks — T02 (`T02`)

Run by: pv-auditor (agent a207548e, session a091d246), with `python3 scripts/pv_audit_mech.py T02` on 2026-10-13 11:16. Probes: `pv_work/probes/auditor/T02/auditor_T02_mech1.lean`, `pv_work/probes/auditor/T02/auditor_T02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T02_16.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T02 exit=0 delivered=e63013a0d25e933e5006507cee3690bacc2230f67f4c25782142b8730b8ddc4f rebuilt=e63013a0d25e933e5006507cee3690bacc2230f67f4c25782142b8730b8ddc4f IDENTICAL log=pv_work/probes/auditor/T02/rebuild/T02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T02_gate.md` (23 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms T02` | PASS | ALL STANDARD |
| 7 | `#pv_walk T02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: T02_L01Consumed |
| 12 | last writer of `pv_work/T02.lean` | PASS | pv-prover (agent a91b859e), 2026-10-13 11:14:38 |
| 12 | last writer of `pv_work/T02Stmt.lean` | PASS | pv-drafter (agent a87bce51), 2026-10-12 22:47:35 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 5 | `verification/audits/L01_gate.md` | `Paper.L01.F`, `Paper.L01.IsInvSub`, `Paper.L01.SubCond`, `Paper.L01.SubadditiveOn`, `Paper.L01.invDist` |
| `T02Stmt` | 9 | `verification/audits/T02_gate.md` | `Paper.T02.Fbar`, `Paper.T02.IIDCopies`, `Paper.T02.IIDCopies.ident`, `Paper.T02.IIDCopies.indep`, `Paper.T02.IIDCopies.meas`, `Paper.T02.IIDCopies.measXs`, `Paper.T02.IIDCopies.mk`, `Paper.T02.StDom`, `Paper.T02.T02_L01Consumed` |

## Declarations in `pv_work/T02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`def PosVersion`, `lemma F_abs_le`, `lemma F_aff_meas`, `lemma F_eq_real`, `lemma F_le_one`, `lemma F_meas`, `lemma F_mono`, `lemma F_nonneg`, `lemma ae_nonneg_of_ident`, `lemma integrable_bdd`, `lemma last_lt_one`, `lemma meas_cond`, `lemma prob_gt_eq_Fbar`, `lemma real_Icc_le`, `lemma real_Ioc`, `lemma stdom_neg`, `lemma toReal_le_compl`, `theorem pos_all`, `theorem pos_step`, `theorem zero_weights`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T02.IIDCopies.ident` | 7 | — | WARNING: the type has 8 leading binders but the proof term binds only 7; usage of the remaining 1 hypotheses is unknown |
| `Paper.T02.IIDCopies.indep` | 7 | — |  |
| `Paper.T02.IIDCopies.meas` | 7 | — |  |
| `Paper.T02.IIDCopies.measXs` | 7 | — | WARNING: the type has 8 leading binders but the proof term binds only 7; usage of the remaining 1 hypotheses is unknown |
| `Paper.T02.T02_S1` | 18 | hx: LE.le.{0} Real Real.instLE (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.T02.T02_S2` | 7 | h0: Eq.{1} Real (Paper.L01.F #1 (OfNat.ofNat.{0} Real 0 (Zero.to |  |
| `Paper.T02.T02_S3` | 8 | — |  |
| `Paper.T02.T02_S4` | 18 | — |  |
| `Paper.T02.T02_S5` | 15 | hx: LE.le.{0} Real Real.instLE (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.T02.T02_S6` | 15 | hits: Paper.L01.IsInvSub (MeasureTheory.Measure.map.{0, 0} #8 Real, hθ: forall (i : Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{, hsum: Eq.{1} Real (Finset.sum.{0, 0} (Fin (HAdd.hAdd.{0, 0, 0} Nat, hx: LE.le.{0} Real Real.instLE (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.T02.T02_S7` | 15 | — |  |
| `Paper.T02.T02_S8` | 17 | — |  |
| `Paper.T02.T02_main` | 13 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: T02_L01Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

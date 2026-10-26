# Mechanical audit checks — T02 (`T02ModGaps`)

Run by: pv-auditor (agent aecd4b06, session f7a2892c), with `python3 scripts/pv_audit_mech.py T02 --module T02ModGaps` on 2026-10-13 01:07. Probes: `pv_work/probes/auditor/T02/auditor_T02_mech1.lean`, `pv_work/probes/auditor/T02/auditor_T02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T02ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T02ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T02ModGaps exit=0 delivered=650064714255488060e41d97b1d3d2d9c45d8d5842e3cf8448f339bdd1cb86ff rebuilt=650064714255488060e41d97b1d3d2d9c45d8d5842e3cf8448f339bdd1cb86ff IDENTICAL log=pv_work/probes/auditor/T02/rebuild/T02ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T02_gate.md` (29 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.T02.T02_S11_Gap`: vh = snapshot th of `Paper.T02.T02_S11`; `Paper.T02.T02_S15_Gap`: vh = snapshot th of `Paper.T02.T02_S15`; `Paper.T02.T02_S3a_Gap`: vh = snapshot th of `Paper.T02.T02_S3a`; `Paper.T02.T02_S3b_Gap`: vh = snapshot th of `Paper.T02.T02_S3b`; `Paper.T02.T02_S8_Gap`: vh = snapshot th of `Paper.T02.T02_S8` |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms T02ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk T02ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T02ModGaps.lean` | PASS | pv-prover (agent a1ce89e8), 2026-10-12 22:40:03 |
| 12 | last writer of `pv_work/T02Stmt.lean` | PASS | pv-drafter (agent a7479764), 2026-10-12 22:17:38 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 13 | `verification/audits/DEFS_gate_r2.md` | `Paper.EGrow`, `Paper.Erep`, `Paper.GrowFinite`, `Paper.HS`, `Paper.IsConsistent`, `Paper.IsEValue`, `Paper.IsGrowLambda`, `Paper.IsMixingMeasure`, `Paper.elemScore`, `Paper.expPi`, `Paper.growthRate`, `Paper.kappa` … |
| `T01Stmt` | 1 | `verification/audits/T01_gate.md` | `Paper.T01.MixtureRep` |
| `T02Stmt` | 4 | `verification/audits/T02_gate.md` | `Paper.T02.Conclusion`, `Paper.T02.Conclusion.mk`, `Paper.T02.T02_T01Consumed`, `Paper.T02.growLambda` |

## Declarations in `pv_work/T02ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma core`, `lemma core2`, `lemma erep_lt`, `lemma growLambda_eq`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T02.Conclusion.evalue` | 6 | — | WARNING: the type has 8 leading binders but the proof term binds only 6; usage of the remaining 2 hypotheses is unknown |
| `Paper.T02.Conclusion.grow_iff` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T02.T02_S1` | 14 | hcons: Paper.IsConsistent #1, hrep: Paper.T01.MixtureRep #2 #1, hp: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi, hq: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi, hpq: Ne.{1} Real #3 #2, hν: LT.lt.{0} ENNReal (Preorder.toLT.{0} ENNReal (PartialOrder.t, hπ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T02.T02_S10` | 13 | — |  |
| `Paper.T02.T02_S12` | 13 | hcons: Paper.IsConsistent #1, hpq: Ne.{1} Real #3 #2, hπ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T02.T02_S13a` | 15 | hcons: Paper.IsConsistent #1, hpq: Ne.{1} Real #3 #2, hπ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T02.T02_S13b` | 13 | — |  |
| `Paper.T02.T02_S14` | 15 | — |  |
| `Paper.T02.T02_S2` | 13 | hcons: Paper.IsConsistent #1, hpq: Ne.{1} Real #3 #2, hπ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T02.T02_S4` | 15 | — |  |
| `Paper.T02.T02_S5` | 17 | hcons: Paper.IsConsistent #1, hrep: Paper.T01.MixtureRep #2 #1, hp: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi, hq: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi, hpq: Ne.{1} Real #3 #2, hν: LT.lt.{0} ENNReal (Preorder.toLT.{0} ENNReal (PartialOrder.t, hπ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi, hπ': Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T02.T02_S6` | 16 | — |  |
| `Paper.T02.T02_S7` | 15 | — |  |
| `Paper.T02.T02_S9` | 15 | hT01: Paper.T02.T02_T01Consumed | WARNING: the type has 16 leading binders but the proof term binds only 15; usage of the remaining 1 hypotheses is unknow |
| `Paper.T02.T02_mod_gaps` | 15 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.T02.T02` renamed to `Paper.T02.T02_mod_gaps`: do the §2b copy-and-`example` check
- `Paper.T02.T02_S9` changed in the gap file (gap-dependent?): check it with the §2b method
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (2 manual checks listed above)

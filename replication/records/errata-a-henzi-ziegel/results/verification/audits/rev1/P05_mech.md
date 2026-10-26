# Mechanical audit checks — P05 (`P05ModGaps`)

Run by: pv-auditor (agent ab082e97, session f7a2892c), with `python3 scripts/pv_audit_mech.py P05 --module P05ModGaps` on 2026-10-13 01:50. Probes: `pv_work/probes/auditor/P05/auditor_P05_mech1.lean`, `pv_work/probes/auditor/P05/auditor_P05_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P05ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P05ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P05ModGaps exit=0 delivered=e992ef4b01badda70494dd9e405b03096c420917fadb59f1427b4fb09c8d43e6 rebuilt=e992ef4b01badda70494dd9e405b03096c420917fadb59f1427b4fb09c8d43e6 IDENTICAL log=pv_work/probes/auditor/P05/rebuild/P05ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P05_gate_r2.md` (10 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | MANUAL | `Paper.P05.P05_Sbridge_Gap`: vh ≠ snapshot th of `Paper.P05.P05_Sbridge`: manual check |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms P05ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk P05ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P05ModGaps.lean` | PASS | pv-prover (agent a973db9c), 2026-10-13 01:44:05 |
| 12 | last writer of `pv_work/P05Stmt.lean` | PASS | pv-drafter (agent a14c5e23), 2026-10-13 01:39:38 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 4 | `verification/audits/DEFS_gate_r2.md` | `Paper.Erep`, `Paper.IsConsistent`, `Paper.IsStrictlyConsistent`, `Paper.expPi` |
| `P04Stmt` | 12 | `verification/audits/P04_gate_r2.md` | `Paper.P04.HSc`, `Paper.P04.HScInt`, `Paper.P04.Ik`, `Paper.P04.IsEValueUnder`, `Paper.P04.P04Conclusion`, `Paper.P04.P04Conclusion.casesOn`, `Paper.P04.P04Conclusion.mk`, `Paper.P04.P04Conclusion.rec`, `Paper.P04.SeqSetting`, `Paper.P04.SeqSetting.c_mem`, `Paper.P04.SeqSetting.mk`, `Paper.P04.eT` |
| `P05Stmt` | 1 | `verification/audits/P05_gate_r2.md` | `Paper.P05.P05_P04Consumed` |

## Declarations in `pv_work/P05ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P05.P05_S0` | 8 | — |  |
| `Paper.P05.P05_S1` | 14 | hQ: Membership.mem.{u, u} (MeasureTheory.Measure.{u} #11 #10) (S, hτ1: Filter.Eventually.{u} #12 (fun (ω : #12) => LE.le.{0} Nat in |  |
| `Paper.P05.P05_S2` | 17 | ht: LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (in |  |
| `Paper.P05.P05_S3` | 15 | hQ: Membership.mem.{u, u} (MeasureTheory.Measure.{u} #10 #9) (Se, ht: LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (in |  |
| `Paper.P05.P05_S4` | 6 | — |  |
| `Paper.P05.P05_Sapp` | 13 | — |  |
| `Paper.P05.P05_Snn` | 16 | — |  |
| `Paper.P05.P05_main_mod_gaps` | 20 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.P05.P05_S0` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_S1` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_S2` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_S3` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_S4` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_Sapp` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_Sbridge_Gap`: its vh differs from the snapshot th of `Paper.P05.P05_Sbridge`. Auxiliary proof constants are named after their declaration (a real numeral `2 : ℝ` becomes `instOfNatAtLeastTwo … Paper.P05.P05_Sbridge_Gap._proof_1`), so identical statements can hash differently. Decide with the §2b probe: import `P05ModGaps`, redeclare `Paper.P05.P05_Sbridge` verbatim under its original full name, confirm its th equals the snapshot, then `example : Paper.P05.P05_Sbridge_Gap = type_of% @Paper.P05.P05_Sbridge := rfl`.
- `Paper.P05.P05_Snn` changed in the gap file (gap-dependent?): check it with the §2b method
- `Paper.P05.P05_main` renamed to `Paper.P05.P05_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (9 manual checks listed above)

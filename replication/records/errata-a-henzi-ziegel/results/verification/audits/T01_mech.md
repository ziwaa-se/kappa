# Mechanical audit checks — T01 (`T01ModGaps`)

Run by: pv-auditor (agent ad6478ef, session a80accfd), with `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps` on 2026-10-12 22:28. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01ModGaps exit=0 delivered=6b9374244f77430a42427c3f4289fc1ec56b9d9473b9625296a4520bd1a3191f rebuilt=6b9374244f77430a42427c3f4289fc1ec56b9d9473b9625296a4520bd1a3191f IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate.md` (12 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.T01.T01_S10_Gap`: vh = snapshot th of `Paper.T01.T01_S10`; `Paper.T01.T01_S8_Gap`: vh = snapshot th of `Paper.T01.T01_S8` |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms T01ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T01ModGaps.lean` | PASS | pv-prover (agent aea64c29), 2026-10-12 22:20:18 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent ab6a9736), 2026-10-12 22:12:26 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 8 | `verification/audits/DEFS_gate_r2.md` | `Paper.Erep`, `Paper.HS`, `Paper.IsConsistent`, `Paper.IsEValue`, `Paper.IsMixingMeasure`, `Paper.elemScore`, `Paper.expPi`, `Paper.mixtureScore` |
| `T01Stmt` | 1 | `verification/audits/T01_gate.md` | `Paper.T01.MixtureRep` |

## Declarations in `pv_work/T01ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`def cc`, `lemma cfacts`, `lemma cmem`, `lemma dsign`, `lemma erep_eq`, `lemma key`, `lemma pos_int`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.T01_S1` | 12 | hcons: Paper.IsConsistent #1 | WARNING: the type has 14 leading binders but the proof term binds only 12; usage of the remaining 2 hypotheses is unknow |
| `Paper.T01.T01_S2` | 12 | — |  |
| `Paper.T01.T01_S3` | 10 | hcons: Paper.IsConsistent #1 |  |
| `Paper.T01.T01_S4` | 4 | — |  |
| `Paper.T01.T01_S5` | 5 | — |  |
| `Paper.T01.T01_S6` | 6 | — |  |
| `Paper.T01.T01_S7` | 7 | — |  |
| `Paper.T01.T01_S9` | 7 | h0: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi | WARNING: the type has 9 leading binders but the proof term binds only 7; usage of the remaining 2 hypotheses is unknown |
| `Paper.T01.T01_mod_gaps` | 13 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.T01.T01` renamed to `Paper.T01.T01_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

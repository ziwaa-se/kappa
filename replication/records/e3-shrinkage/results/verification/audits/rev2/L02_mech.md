# Mechanical audit checks — L02 (`L02ModGaps`)

Run by: pv-auditor (agent a8da10b2, session d516f55c), with `python3 scripts/pv_audit_mech.py L02 --module L02ModGaps` on 2026-10-12 22:12. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02ModGaps_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02ModGaps exit=0 delivered=6291a03ea99841de6cc715f3209ae20c0cb30d48a46797f9b9aa655554223638 rebuilt=6291a03ea99841de6cc715f3209ae20c0cb30d48a46797f9b9aa655554223638 IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate.md` (8 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | MANUAL | `Paper.L02.L02_S2_Gap`: vh = snapshot th of `Paper.L02.L02_S2`; `Paper.L02.L02_S3_Gap`: vh ≠ snapshot th of `Paper.L02.L02_S3`: manual check |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L02ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L02ModGaps.lean` | PASS | pv-prover (agent ac1b638f), 2026-10-12 22:11:01 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent a18a5d6d), 2026-10-12 21:48:47 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 3 | `verification/audits/DEFS_gate.md` | `Paper.Setting`, `Paper.Setting.mk`, `Paper.oracleRisk` |
| `L02Stmt` | 4 | `verification/audits/L02_gate.md` | `Paper.L02.Conclusion`, `Paper.L02.HarmonicLeMin`, `Paper.L02.harmonicMean`, `Paper.L02.harmonicMean._proof_1` |

## Declarations in `pv_work/L02ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 3 | h: Paper.Setting #1 #0 |  |
| `Paper.L02.L02_S4` | 3 | h: Paper.Setting #1 #0 |  |
| `Paper.L02.L02_mod_gaps` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.L02.L02` renamed to `Paper.L02.L02_mod_gaps`: do the §2b copy-and-`example` check
- `Paper.L02.L02_S3_Gap`: its vh differs from the snapshot th of `Paper.L02.L02_S3`. Auxiliary proof constants are named after their declaration (a real numeral `2 : ℝ` becomes `instOfNatAtLeastTwo … Paper.L02.L02_S3_Gap._proof_1`), so identical statements can hash differently. Decide with the §2b probe: import `L02ModGaps`, redeclare `Paper.L02.L02_S3` verbatim under its original full name, confirm its th equals the snapshot, then `example : Paper.L02.L02_S3_Gap = type_of% @Paper.L02.L02_S3 := rfl`.
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (2 manual checks listed above)

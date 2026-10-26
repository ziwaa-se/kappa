# Mechanical audit checks — L02 (`L02ModGaps`)

Run by: pv-auditor (agent a1fde85f, session f0fedf08), with `python3 scripts/pv_audit_mech.py L02 --module L02ModGaps` on 2026-10-13 01:14. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02ModGaps exit=0 delivered=08cba73672dea1aced2ed2f394653a54a7feb8340818cf83a92b71967446353d rebuilt=08cba73672dea1aced2ed2f394653a54a7feb8340818cf83a92b71967446353d IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate_r2.md` (8 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | MANUAL | `Paper.L02.L02_main_Gap`: vh ≠ snapshot th of `Paper.L02.L02_main`: manual check |
| 6 | `#pv_axioms L02ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L02ModGaps.lean` | PASS | pv-prover (agent af92bb40), 2026-10-13 01:08:25 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent af57c862), 2026-10-12 22:46:16 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 1 | `verification/audits/L01_gate.md` | `Paper.L01.F` |
| `L02Stmt` | 4 | `verification/audits/L02_gate_r2.md` | `Paper.L02.InvNWUCond`, `Paper.L02.IsSuperHeavyTailed`, `Paper.L02.SubadditiveOnE`, `Paper.L02.negLogInv` |

## Declarations in `pv_work/L02ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma F_nonneg`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 7 | — |  |
| `Paper.L02.L02_S2` | 5 | inst._@.L02ModGaps._hyg.102: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS, hθ: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.L02.L02_S3` | 7 | — |  |
| `Paper.L02.L02_main_mod_gaps` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.L02.L02_main_Gap`: its vh differs from the snapshot th of `Paper.L02.L02_main`. Auxiliary proof constants are named after their declaration (a real numeral `2 : ℝ` becomes `instOfNatAtLeastTwo … Paper.L02.L02_main_Gap._proof_1`), so identical statements can hash differently. Decide with the §2b probe: import `L02ModGaps`, redeclare `Paper.L02.L02_main` verbatim under its original full name, confirm its th equals the snapshot, then `example : Paper.L02.L02_main_Gap = type_of% @Paper.L02.L02_main := rfl`.
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

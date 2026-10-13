# Mechanical audit checks — L03 (`L03ModGaps`)

Run by: pv-auditor (agent a744d0f1, session cd40fe3b), with `python3 scripts/pv_audit_mech.py L03 --module L03ModGaps` on 2026-10-12 22:45. Probes: `pv_work/probes/auditor/L03/auditor_L03_mech1.lean`, `pv_work/probes/auditor/L03/auditor_L03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L03ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L03ModGaps_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L03ModGaps exit=0 delivered=e9db4b401456d71c196e68657544009c27b359792864b73d8b7e5f6d75222e46 rebuilt=e9db4b401456d71c196e68657544009c27b359792864b73d8b7e5f6d75222e46 IDENTICAL log=pv_work/probes/auditor/L03/rebuild/L03ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L03_gate.md` (4 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | MANUAL | `Paper.L03.L03_S2_Gap`: vh ≠ snapshot th of `Paper.L03.L03_S2`: manual check |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L03ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk L03ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L03ModGaps.lean` | PASS | pv-prover (agent af1709e6), 2026-10-12 22:39:00 |
| 12 | last writer of `pv_work/L03Stmt.lean` | PASS | pv-drafter (agent a9a17f74), 2026-10-12 22:16:13 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 2 | `verification/audits/DEFS_gate.md` | `Paper.DEFS.IOpen`, `Paper.DEFS.V` |
| `L01` | 3 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_main` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Conclusion`, `Paper.L01.Conclusion.mk` |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.L03Claim`, `Paper.L03.L03Claim._proof_1` |

## Declarations in `pv_work/L03ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L03.L03_S1` | 3 | — |  |
| `Paper.L03.L03_main_mod_gaps` | 5 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.L03.L03_S2_Gap`: its vh differs from the snapshot th of `Paper.L03.L03_S2`. Auxiliary proof constants are named after their declaration (a real numeral `2 : ℝ` becomes `instOfNatAtLeastTwo … Paper.L03.L03_S2_Gap._proof_1`), so identical statements can hash differently. Decide with the §2b probe: import `L03ModGaps`, redeclare `Paper.L03.L03_S2` verbatim under its original full name, confirm its th equals the snapshot, then `example : Paper.L03.L03_S2_Gap = type_of% @Paper.L03.L03_S2 := rfl`.
- `Paper.L03.L03_main` renamed to `Paper.L03.L03_main_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (2 manual checks listed above)

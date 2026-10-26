# Mechanical audit checks — P05 (`P05ModGaps`)

Run by: pv-auditor (agent aa35ca0c, session b64a0af0), with `python3 scripts/pv_audit_mech.py P05 --module P05ModGaps` on 2026-10-13 02:27. Probes: `pv_work/probes/auditor/P05/auditor_P05_mech1.lean`, `pv_work/probes/auditor/P05/auditor_P05_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P05ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P05ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P05ModGaps exit=0 delivered=8b6e88d03e30cead6929fcddeb50e2033ed36e71f35ed8bf1c47d1b797b997c5 rebuilt=8b6e88d03e30cead6929fcddeb50e2033ed36e71f35ed8bf1c47d1b797b997c5 IDENTICAL log=pv_work/probes/auditor/P05/rebuild/P05ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P05_gate.md` (12 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.P05.P05_main_Gap`: vh = snapshot th of `Paper.P05.P05_main` |
| 6 | `#pv_axioms P05ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk P05ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P05ModGaps.lean` | PASS | pv-prover (agent a54ce251), 2026-10-13 02:21:34 |
| 12 | last writer of `pv_work/P05Stmt.lean` | PASS | pv-drafter (agent a4c0457d), 2026-10-13 02:13:21 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 1 | `verification/audits/L01_gate.md` | `Paper.L01.F` |
| `L02Stmt` | 3 | `verification/audits/L02_gate_r2.md` | `Paper.L02.IsSuperHeavyTailed`, `Paper.L02.SubadditiveOnE`, `Paper.L02.negLogInv` |
| `P05Stmt` | 8 | `verification/audits/P05_gate.md` | `Paper.P05.Hcdf`, `Paper.P05.InvSubLE`, `Paper.P05.P05Conclusion`, `Paper.P05.genInv`, `Paper.P05.invSubFn`, `Paper.P05.leftVer`, `Paper.P05.recipE`, `Paper.P05.recipE.match_1` |

## Declarations in `pv_work/P05ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`def psi`, `lemma F_leftLim_mem`, `lemma F_mem`, `lemma genInv_mid`, `lemma genInv_one`, `lemma genInv_zero`, `lemma psi_anti`, `lemma psi_cont`, `lemma psi_eq`, `lemma psi_nonneg`, `lemma transfer`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P05.P05_S1` | 2 | — |  |
| `Paper.P05.P05_S2` | 3 | hx: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.P05.P05_S3` | 1 | — |  |
| `Paper.P05.P05_main_mod_gaps` | 2 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

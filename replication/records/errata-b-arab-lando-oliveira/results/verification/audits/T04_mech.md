# Mechanical audit checks — T04 (`T04`)

Run by: pv-auditor (agent abc319ff, session 3b514bad), with `python3 scripts/pv_audit_mech.py T04` on 2026-10-13 01:44. Probes: `pv_work/probes/auditor/T04/auditor_T04_mech1.lean`, `pv_work/probes/auditor/T04/auditor_T04_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T04` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T04_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T04 exit=0 delivered=d53e91f54553914a60c38c0f36fc6129419abb8af60f90829a3e2fc3f11dd1c0 rebuilt=d53e91f54553914a60c38c0f36fc6129419abb8af60f90829a3e2fc3f11dd1c0 IDENTICAL log=pv_work/probes/auditor/T04/rebuild/T04.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4a | `T04Stmt` fingerprints | PASS | `pv_work/T04Stmt.lean` declares nothing (0 declarations); any gated declaration expected there is still checked in item 4 |
| 4 | statement fingerprints vs `verification/audits/T04_gate_r2.md` (7 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms T04` | PASS | ALL STANDARD |
| 7 | `#pv_walk T04`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T04.lean` | PASS | pv-prover (agent ac1ded02), 2026-10-13 01:43:29 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 4 | `verification/audits/L01_gate.md` | `Paper.L01.F`, `Paper.L01.IsInvSub`, `Paper.L01.SubadditiveOn`, `Paper.L01.invDist` |
| `L02Stmt` | 3 | `verification/audits/L02_gate_r2.md` | `Paper.L02.IsSuperHeavyTailed`, `Paper.L02.SubadditiveOnE`, `Paper.L02.negLogInv` |

## Declarations in `pv_work/T04.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma F_le_one`, `lemma F_nonneg`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T04.T04_S1` | 9 | — |  |
| `Paper.T04.T04_S2` | 9 | — |  |
| `Paper.T04.T04_S3` | 4 | — |  |
| `Paper.T04.T04_S4` | 6 | — |  |
| `Paper.T04.T04_S4z` | 7 | hx: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO, hy: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.T04.T04_S5` | 4 | inst._@.T04._hyg.482: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.T04.T04_main` | 3 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

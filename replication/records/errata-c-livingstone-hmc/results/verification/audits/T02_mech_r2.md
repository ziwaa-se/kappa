# Mechanical audit checks — T02 (`T02Closed_r1`)

Run by: pv-auditor (agent a740d4d0, session 13bf576d), with `python3 scripts/pv_audit_mech.py T02 --module T02Closed_r1 --skip-statement` on 2026-10-13 11:28. Probes: `pv_work/probes/auditor/T02/auditor_T02_mech1.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T02Closed_r1` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T02Closed_r1_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T02Closed_r1 exit=0 delivered=215b9927b4757f0736a399111e1595e944ae7bf9baf258084a66931fbe2468a4 rebuilt=215b9927b4757f0736a399111e1595e944ae7bf9baf258084a66931fbe2468a4 IDENTICAL log=pv_work/probes/auditor/T02/rebuild/T02Closed_r1.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T02Closed_r1` | PASS | ALL STANDARD |
| 7 | `#pv_walk T02Closed_r1`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: T02_GaussFacts, T02_L03Consumed, T02_Prop35, T02_Prop35Rand |
| 12 | last writer of `pv_work/T02Closed_r1.lean` | PASS | pv-prover (agent a0910928), 2026-10-13 11:27:30 |
| 12 | last writer of `pv_work/T02Stmt.lean` | PASS | pv-drafter (agent a9350b7c), 2026-10-13 11:06:53 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 14 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L01` | 7 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `Paper.L01.L01_S4`, `Paper.L01.L01_S5`, `Paper.L01.L01_S6`, `Paper.L01.L01_main` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl`, `Paper.L01.Concl._proof_1` |
| `L02` | 19 | `verification/audits/L02_final.md` | `Paper.L02.L02_S1`, `Paper.L02.L02_S1._proof_1`, `Paper.L02.L02_S2`, `Paper.L02.L02_S3`, `Paper.L02.L02_S4a`, `Paper.L02.L02_S4b`, `Paper.L02.L02_S5`, `Paper.L02.L02_S5._proof_1`, `Paper.L02.L02_S5._proof_2`, `Paper.L02.L02_S6`, `Paper.L02.L02_S7`, `Paper.L02.L02_S7._proof_1` … |
| `L02Closed_r1` | 2 | **NO RECORD: audit these constants individually** | `Paper.L02.L02_L01Consumed_holds`, `Paper.L02.main_closed` |
| `L02Stmt` | 3 | `verification/audits/L02_gate.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1`, `Paper.L02.L02_L01Consumed` |
| `L03` | 37 | `verification/audits/L03_final.md` | `Paper.L03.L03_S1`, `Paper.L03.L03_S10`, `Paper.L03.L03_S11`, `Paper.L03.L03_S12`, `Paper.L03.L03_S13`, `Paper.L03.L03_S14`, `Paper.L03.L03_S14._proof_1`, `Paper.L03.L03_S2`, `Paper.L03.L03_S2._proof_1`, `Paper.L03.L03_S3`, `Paper.L03.L03_S4a`, `Paper.L03.L03_S4a._proof_1` … |
| `L03Closed_r1` | 2 | **NO RECORD: audit these constants individually** | `Paper.L03.L03_L02Consumed_holds`, `Paper.L03.main_closed` |
| `L03Stmt` | 4 | `verification/audits/L03_gate.md` | `Paper.L03.Concl`, `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1`, `Paper.L03.L03_L02Consumed` |
| `T02` | 22 | `verification/audits/T02_final.md` | `Paper.Defs.tailMomFilter.eq_1`, `Paper.T02.T02_S1`, `Paper.T02.T02_S2`, `Paper.T02.T02_S3`, `Paper.T02.T02_S4`, `Paper.T02.T02_S5`, `Paper.T02.T02_S7`, `Paper.T02.T02_S8`, `Paper.T02.T02_S9`, `Paper.T02.T02_SR1`, `Paper.T02.T02_SR2`, `Paper.T02.T02_SR3` … |
| `T02Stmt` | 22 | `verification/audits/T02_gate_r2.md` | `Paper.T02.A1Law`, `Paper.T02.GaussFacts`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.GeomErgodicRand`, `Paper.T02.Prop35`, `Paper.T02.Prop35Rand`, `Paper.T02.T02_L03Consumed`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3` … |

## Declarations in `pv_work/T02Closed_r1.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| — | — | — | — |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- module `L02Closed_r1` reached without an audit record: audit its 2 constants one by one
- module `L03Closed_r1` reached without an audit record: audit its 2 constants one by one
- external inputs registered for T02 but not reached by any gated theorem (T02_GaussFacts, T02_L03Consumed, T02_Prop35, T02_Prop35Rand): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (3 manual checks listed above)

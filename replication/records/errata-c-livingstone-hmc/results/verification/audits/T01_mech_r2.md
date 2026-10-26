# Mechanical audit checks — T01 (`T01`)

Run by: pv-auditor (agent a8bae1f4, session 13bf576d), with `python3 scripts/pv_audit_mech.py T01` on 2026-10-13 11:30. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01 exit=0 delivered=fdf85a96cd42a961ca742e4e482a5f2d748a10906f527d79a98acc498439f3e1 rebuilt=fdf85a96cd42a961ca742e4e482a5f2d748a10906f527d79a98acc498439f3e1 IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate_r2.md` (32 gated declarations) | FAIL | Paper.T01.T01_main_randL (missing) |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: T01Rand_T02Consumed, T01_T02Consumed; registered for this result but not reached: T01_Thm518, T01_Thm518Rand |
| 12 | last writer of `pv_work/T01.lean` | PASS | pv-prover (agent a28b362e), 2026-10-13 11:27:39 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent aa9f2137), 2026-10-13 11:21:16 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 13 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1` |
| `T01Stmt` | 11 | `verification/audits/T01_gate_r2.md` | `Paper.T01.HypPartI`, `Paper.T01.HypPartII`, `Paper.T01.HypPartIRand`, `Paper.T01.T01Concl`, `Paper.T01.T01Concl.mk`, `Paper.T01.T01Rand_T02Consumed`, `Paper.T01.T01_T02Consumed`, `Paper.T01.Thm518`, `Paper.T01.Thm518._proof_1`, `Paper.T01.Thm518._proof_2`, `Paper.T01.Thm518Rand` |
| `T02Stmt` | 16 | `verification/audits/T02_gate_r2.md` | `Paper.T02.A1Law`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.GeomErgodicRand`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcPowRand`, `Paper.T02.hmcStep` … |

## Declarations in `pv_work/T01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.T01Concl.partI` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01Concl.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01ConclRand.partI` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01ConclRand.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01_S1` | 12 | — |  |
| `Paper.T01.T01_S2` | 3 | — |  |
| `Paper.T01.T01_S3` | 12 | — |  |
| `Paper.T01.T01_SR1` | 12 | — |  |
| `Paper.T01.T01_SR3` | 14 | — |  |
| `Paper.T01.T01_main` | 12 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: T01Rand_T02Consumed, T01_T02Consumed

## For the auditor (judgement not done by this script)

- external inputs registered for T01 but not reached by any gated theorem (T01_Thm518, T01_Thm518Rand): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: FAIL (statement)

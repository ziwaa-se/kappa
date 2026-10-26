# Mechanical audit checks — T01 (`T01ModGaps`)

Run by: pv-auditor (agent a8bae1f4, session 13bf576d), with `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps` on 2026-10-13 11:29. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01ModGaps_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01ModGaps exit=0 delivered=d28898e3deefcdfac28e61ea16b8d50818a399f69d44db0875942625385493fe rebuilt=d28898e3deefcdfac28e61ea16b8d50818a399f69d44db0875942625385493fe IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate_r2.md` (32 gated declarations) | FAIL | Paper.T01.T01_S1 (missing); Paper.T01.T01_S2 (missing); Paper.T01.T01_S3 (missing); Paper.T01.T01_SR1 (missing); Paper.T01.T01_SR3 (missing); Paper.T01.T01_main (missing) |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: T01Rand_T02Consumed; registered for this result but not reached: T01_T02Consumed, T01_Thm518, T01_Thm518Rand |
| 12 | last writer of `pv_work/T01ModGaps.lean` | PASS | pv-prover (agent a28b362e), 2026-10-13 11:28:21 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent aa9f2137), 2026-10-13 11:21:16 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 13 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1` |
| `T01` | 2 | **NO RECORD: audit these constants individually** | `Paper.T01.T01_S2`, `Paper.T01.T01_SR3` |
| `T01Stmt` | 8 | `verification/audits/T01_gate_r2.md` | `Paper.T01.HypPartII`, `Paper.T01.HypPartIRand`, `Paper.T01.T01ConclRand`, `Paper.T01.T01ConclRand.mk`, `Paper.T01.T01Rand_T02Consumed`, `Paper.T01.Thm518._proof_1`, `Paper.T01.Thm518._proof_2`, `Paper.T01.Thm518Rand` |
| `T02Stmt` | 14 | `verification/audits/T02_gate_r2.md` | `Paper.T02.A1Law`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.GeomErgodicRand`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3`, `Paper.T02.hmcPow.match_1`, `Paper.T02.hmcPowRand`, `Paper.T02.hmcStep`, `Paper.T02.hmcStepRand`, `Paper.T02.targetMeas` … |

## Declarations in `pv_work/T01ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.T01Concl.partI` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01Concl.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01ConclRand.partI` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01ConclRand.partII` | 6 | — | WARNING: the type has 7 leading binders but the proof term binds only 6; usage of the remaining 1 hypotheses is unknown |
| `Paper.T01.T01_main_randL_mod_gaps` | 14 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: T01Rand_T02Consumed

## For the auditor (judgement not done by this script)

- `Paper.T01.T01_main_randL` renamed to `Paper.T01.T01_main_randL_mod_gaps`: do the §2b copy-and-`example` check
- module `T01` reached without an audit record: audit its 2 constants one by one
- external inputs registered for T01 but not reached by any gated theorem (T01_T02Consumed, T01_Thm518, T01_Thm518Rand): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: FAIL (statement)

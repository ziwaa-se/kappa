# Mechanical audit checks — L03 (`L03Closed_r1`)

Run by: pv-auditor (agent a05a4268, session 13bf576d), with `python3 scripts/pv_audit_mech.py L03 --module L03Closed_r1 --skip-statement` on 2026-10-13 11:05. Probes: `pv_work/probes/auditor/L03/auditor_L03_mech1.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L03Closed_r1` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L03Closed_r1_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L03Closed_r1 exit=0 delivered=c6b5f0b0b68136c5ed43ff9df20aa5d201e017c97fa524442efa463ee266674c rebuilt=c6b5f0b0b68136c5ed43ff9df20aa5d201e017c97fa524442efa463ee266674c IDENTICAL log=pv_work/probes/auditor/L03/rebuild/L03Closed_r1.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L03Closed_r1` | PASS | ALL STANDARD |
| 7 | `#pv_walk L03Closed_r1`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: L03_L02Consumed |
| 12 | last writer of `pv_work/L03Closed_r1.lean` | PASS | pv-prover (agent a976416f), 2026-10-13 11:04:56 |
| 12 | last writer of `pv_work/L03Stmt.lean` | PASS | pv-drafter (agent a98c1e6d), 2026-10-13 10:51:45 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 12 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens`, `Paper.Defs.tailMomFilter`, `Paper.Defs.xLF` |
| `L01` | 7 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `Paper.L01.L01_S4`, `Paper.L01.L01_S5`, `Paper.L01.L01_S6`, `Paper.L01.L01_main` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl`, `Paper.L01.Concl._proof_1` |
| `L02` | 19 | `verification/audits/L02_final.md` | `Paper.L02.L02_S1`, `Paper.L02.L02_S1._proof_1`, `Paper.L02.L02_S2`, `Paper.L02.L02_S3`, `Paper.L02.L02_S4a`, `Paper.L02.L02_S4b`, `Paper.L02.L02_S5`, `Paper.L02.L02_S5._proof_1`, `Paper.L02.L02_S5._proof_2`, `Paper.L02.L02_S6`, `Paper.L02.L02_S7`, `Paper.L02.L02_S7._proof_1` … |
| `L02Closed_r1` | 2 | **NO RECORD: audit these constants individually** | `Paper.L02.L02_L01Consumed_holds`, `Paper.L02.main_closed` |
| `L02Stmt` | 3 | `verification/audits/L02_gate.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1`, `Paper.L02.L02_L01Consumed` |
| `L03` | 37 | `verification/audits/L03_final.md` | `Paper.L03.L03_S1`, `Paper.L03.L03_S10`, `Paper.L03.L03_S11`, `Paper.L03.L03_S12`, `Paper.L03.L03_S13`, `Paper.L03.L03_S14`, `Paper.L03.L03_S14._proof_1`, `Paper.L03.L03_S2`, `Paper.L03.L03_S2._proof_1`, `Paper.L03.L03_S3`, `Paper.L03.L03_S4a`, `Paper.L03.L03_S4a._proof_1` … |
| `L03Stmt` | 4 | `verification/audits/L03_gate.md` | `Paper.L03.Concl`, `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1`, `Paper.L03.L03_L02Consumed` |

## Declarations in `pv_work/L03Closed_r1.lean` that are not in the gate snapshot (item 9: helpers to review)

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
- external inputs registered for L03 but not reached by any gated theorem (L03_L02Consumed): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (2 manual checks listed above)

# Mechanical audit checks — L02 (`L02`)

Run by: pv-auditor (agent ad56f914, session 13bf576d), with `python3 scripts/pv_audit_mech.py L02` on 2026-10-13 10:51. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`, `pv_work/probes/auditor/L02/auditor_L02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02 exit=0 delivered=324c2ab4a4a9313c3dd4a645614481755821b77657d6cf9bbc6e972d73c16224 rebuilt=324c2ab4a4a9313c3dd4a645614481755821b77657d6cf9bbc6e972d73c16224 IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L02_gate.md` (12 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L02` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: L02_L01Consumed |
| 12 | last writer of `pv_work/L02.lean` | PASS | pv-prover (agent a30dcfdd), 2026-10-13 10:50:24 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent a7e7c36f), 2026-10-13 10:40:09 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 7 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.xLF` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl`, `Paper.L01.Concl._proof_1` |
| `L02Stmt` | 3 | `verification/audits/L02_gate.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1`, `Paper.L02.L02_L01Consumed` |

## Declarations in `pv_work/L02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L02.L02_S1` | 7 | — |  |
| `Paper.L02.L02_S2` | 5 | — |  |
| `Paper.L02.L02_S3` | 6 | — |  |
| `Paper.L02.L02_S4a` | 8 | — |  |
| `Paper.L02.L02_S4b` | 8 | — |  |
| `Paper.L02.L02_S5` | 7 | — |  |
| `Paper.L02.L02_S6` | 12 | — |  |
| `Paper.L02.L02_S7` | 11 | — | WARNING: the type has 14 leading binders but the proof term binds only 11; usage of the remaining 3 hypotheses is unknow |
| `Paper.L02.L02_S8` | 7 | — |  |
| `Paper.L02.L02_main` | 9 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: L02_L01Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

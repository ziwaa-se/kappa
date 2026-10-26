# Mechanical audit checks — L02 (`L02Closed_r1`)

Run by: pv-auditor (agent a4b2a019, session 13bf576d), with `python3 scripts/pv_audit_mech.py L02 --module L02Closed_r1 --skip-statement` on 2026-10-13 10:56. Probes: `pv_work/probes/auditor/L02/auditor_L02_mech1.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L02Closed_r1` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L02Closed_r1_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L02Closed_r1 exit=0 delivered=c7d9acfb4978b14039d9aa3872dc2711653e2f641c875413ae5a983ea7fa7332 rebuilt=c7d9acfb4978b14039d9aa3872dc2711653e2f641c875413ae5a983ea7fa7332 IDENTICAL log=pv_work/probes/auditor/L02/rebuild/L02Closed_r1.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs gate snapshot | SKIPPED | --skip-statement |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L02Closed_r1` | PASS | ALL STANDARD |
| 7 | `#pv_walk L02Closed_r1`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none; registered for this result but not reached: L02_L01Consumed |
| 12 | last writer of `pv_work/L02Closed_r1.lean` | PASS | pv-prover (agent a3227e82), 2026-10-13 10:55:05 |
| 12 | last writer of `pv_work/L02Stmt.lean` | PASS | pv-drafter (agent a7e7c36f), 2026-10-13 10:40:09 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 7 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.xLF` |
| `L01` | 7 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_S3`, `Paper.L01.L01_S4`, `Paper.L01.L01_S5`, `Paper.L01.L01_S6`, `Paper.L01.L01_main` |
| `L01Stmt` | 2 | `verification/audits/L01_gate.md` | `Paper.L01.Concl`, `Paper.L01.Concl._proof_1` |
| `L02` | 19 | `verification/audits/L02_final.md` | `Paper.L02.L02_S1`, `Paper.L02.L02_S1._proof_1`, `Paper.L02.L02_S2`, `Paper.L02.L02_S3`, `Paper.L02.L02_S4a`, `Paper.L02.L02_S4b`, `Paper.L02.L02_S5`, `Paper.L02.L02_S5._proof_1`, `Paper.L02.L02_S5._proof_2`, `Paper.L02.L02_S6`, `Paper.L02.L02_S7`, `Paper.L02.L02_S7._proof_1` … |
| `L02Stmt` | 3 | `verification/audits/L02_gate.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1`, `Paper.L02.L02_L01Consumed` |

## Declarations in `pv_work/L02Closed_r1.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

None.

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| — | — | — | — |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- external inputs registered for L02 but not reached by any gated theorem (L02_L01Consumed): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

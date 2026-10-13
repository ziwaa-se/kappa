# Mechanical audit checks — P02 (`P02`)

Run by: pv-auditor (agent a5700133, session 9fc1c499), with `python3 scripts/pv_audit_mech.py P02` on 2026-10-12 22:27. Probes: `pv_work/probes/auditor/P02/auditor_P02_mech1.lean`, `pv_work/probes/auditor/P02/auditor_P02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P02_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P02 exit=0 delivered=03a0134f6317d3972306f5d762667b8e6cb847a69e1543b58edb726542313cd6 rebuilt=03a0134f6317d3972306f5d762667b8e6cb847a69e1543b58edb726542313cd6 IDENTICAL log=pv_work/probes/auditor/P02/rebuild/P02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P02_gate.md` (11 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P02` | PASS | ALL STANDARD |
| 7 | `#pv_walk P02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P02.lean` | PASS | pv-prover (agent afc510ed), 2026-10-12 22:23:08 |
| 12 | last writer of `pv_work/P02Stmt.lean` | PASS | pv-drafter (agent a1057311), 2026-10-12 22:15:16 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 4 | `verification/audits/DEFS_gate.md` | `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleStd`, `Paper.sampleVar` |
| `L01` | 3 | `verification/audits/L01_final.md` | `Paper.L01.L01_S1`, `Paper.L01.L01_S2`, `Paper.L01.L01_main` |
| `L01Stmt` | 1 | `verification/audits/L01_gate.md` | `Paper.L01.Conclusion` |
| `P02Stmt` | 2 | `verification/audits/P02_gate.md` | `Paper.P02.Conclusion`, `Paper.P02.z` |

## Declarations in `pv_work/P02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma std_sq`, `lemma sum_sq_eq`, `lemma var_nonneg`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P02.P02_S1` | 3 | — |  |
| `Paper.P02.P02_S2` | 4 | — |  |
| `Paper.P02.P02_S3` | 4 | — |  |
| `Paper.P02.P02_S4` | 4 | — |  |
| `Paper.P02.P02_S5` | 5 | — |  |
| `Paper.P02.P02_S6` | 5 | — |  |
| `Paper.P02.P02_S7` | 5 | — |  |
| `Paper.P02.P02_S8` | 5 | — |  |
| `Paper.P02.P02_main` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

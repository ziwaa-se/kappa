# Mechanical audit checks — P01 (`P01`)

Run by: pv-auditor (agent aa8f6524, session b3b8d1c9), with `python3 scripts/pv_audit_mech.py P01` on 2026-10-12 22:12. Probes: `pv_work/probes/auditor/P01/auditor_P01_mech1.lean`, `pv_work/probes/auditor/P01/auditor_P01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P01_2.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P01 exit=0 delivered=21d3b8f0b3b265615472d8249ad4d03d606b650a30f4dc923aec6144fb883924 rebuilt=21d3b8f0b3b265615472d8249ad4d03d606b650a30f4dc923aec6144fb883924 IDENTICAL log=pv_work/probes/auditor/P01/rebuild/P01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P01_gate.md` (15 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms P01` | PASS | ALL STANDARD |
| 7 | `#pv_walk P01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P01.lean` | PASS | pv-prover (agent ab02c7bb), 2026-10-12 22:11:09 |
| 12 | last writer of `pv_work/P01Stmt.lean` | PASS | pv-drafter (agent a7a7251b), 2026-10-12 21:48:56 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 4 | `verification/audits/DEFS_gate.md` | `Paper.Defs.Dn`, `Paper.Defs.cdfOf`, `Paper.Defs.edf`, `Paper.Defs.edfRV` |
| `P01Stmt` | 4 | `verification/audits/P01_gate.md` | `Paper.P01.GCConclusion`, `Paper.P01.GlivenkoCantelli`, `Paper.P01.IsIIDSeq`, `Paper.P01.IsIIDSeq.mk` |

## Declarations in `pv_work/P01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem P01_S1.`, `theorem P01_main.`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P01.IsIIDSeq.ident` | 5 | — | WARNING: the type has 6 leading binders but the proof term binds only 5; usage of the remaining 1 hypotheses is unknown |
| `Paper.P01.IsIIDSeq.indep` | 5 | — |  |
| `Paper.P01.IsIIDSeq.meas` | 5 | — | WARNING: the type has 6 leading binders but the proof term binds only 5; usage of the remaining 1 hypotheses is unknown |
| `Paper.P01.IsIIDSeq.prob` | 5 | — |  |
| `Paper.P01.P01_S1` | 6 | — |  |
| `Paper.P01.P01_main` | 6 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

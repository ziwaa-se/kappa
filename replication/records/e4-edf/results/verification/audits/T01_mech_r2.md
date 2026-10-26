# Mechanical audit checks — T01 (`T01`)

Run by: pv-auditor (agent ae1bf14d, session 284c04ae), with `python3 scripts/pv_audit_mech.py T01` on 2026-10-12 22:48. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01_6.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01 exit=0 delivered=2b288052c90bcc35fa20ad23422e5645dd9084e6be8bbd99495f383e6a891e12 rebuilt=2b288052c90bcc35fa20ad23422e5645dd9084e6be8bbd99495f383e6a891e12 IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate.md` (22 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: DonskerUniformSup, KolmogorovFormula |
| 12 | last writer of `pv_work/T01.lean` | PASS | pv-prover (agent a54cad74), 2026-10-12 22:45:28 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent a0edd8e1), 2026-10-12 21:49:35 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 4 | `verification/audits/DEFS_gate.md` | `Paper.Defs.Dn`, `Paper.Defs.cdfOf`, `Paper.Defs.edf`, `Paper.Defs.edfRV` |
| `T01Stmt` | 9 | `verification/audits/T01_gate.md` | `Paper.T01.ConvInDist`, `Paper.T01.DonskerUniformSup`, `Paper.T01.IsBrownianBridge`, `Paper.T01.KSConclusion`, `Paper.T01.KSConclusion.mk`, `Paper.T01.Kfun`, `Paper.T01.Kfun._proof_1`, `Paper.T01.KolmogorovFormula`, `Paper.T01.supAbs` |

## Declarations in `pv_work/T01.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma Iic_inter_Icc01`, `lemma cdfOf_eq_cdf`, `lemma edf_bounds`, `lemma law_comp`, `lemma meas_exists_mem_Ico`, `lemma meas_finset_inf`, `lemma meas_finset_sup`, `lemma pit_law`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.KSConclusion.cdf` | 5 | — | WARNING: the type has 13 leading binders but the proof term binds only 5; usage of the remaining 8 hypotheses is unknown |
| `Paper.T01.KSConclusion.conv` | 5 | — | WARNING: the type has 11 leading binders but the proof term binds only 5; usage of the remaining 6 hypotheses is unknown |
| `Paper.T01.T01` | 11 | — |  |
| `Paper.T01.T01_S1` | 6 | — |  |
| `Paper.T01.T01_S2` | 9 | — |  |
| `Paper.T01.T01_S3` | 8 | — |  |
| `Paper.T01.T01_S4` | 12 | — |  |
| `Paper.T01.T01_S5` | 16 | — |  |
| `Paper.T01.T01_S6` | 7 | — | WARNING: the type has 9 leading binders but the proof term binds only 7; usage of the remaining 2 hypotheses is unknown |

## Conditions traced (item 11)

TRACED CONDITIONS: DonskerUniformSup, KolmogorovFormula

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

# Mechanical audit checks — T01 (`T01ModGaps`)

Run by: pv-auditor (agent ac969ca3, session b3b8d1c9), with `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps` on 2026-10-12 22:27. Probes: `pv_work/probes/auditor/T01/auditor_T01_mech1.lean`, `pv_work/probes/auditor/T01/auditor_T01_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T01ModGaps` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T01ModGaps_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T01ModGaps exit=0 delivered=6b578619ec95768b947fef7c0afa30d9c1ece7730a72541ee910a68de773f733 rebuilt=6b578619ec95768b947fef7c0afa30d9c1ece7730a72541ee910a68de773f733 IDENTICAL log=pv_work/probes/auditor/T01/rebuild/T01ModGaps.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T01_gate.md` (22 gated declarations) | PASS | all gated th/vh/bi identical |
| 4b | gap definitions | PASS | `Paper.T01.T01_S1_Gap`: vh = snapshot th of `Paper.T01.T01_S1` |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T01ModGaps` | PASS | ALL STANDARD |
| 7 | `#pv_walk T01ModGaps`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T01ModGaps.lean` | PASS | pv-prover (agent a3abd735), 2026-10-12 22:24:28 |
| 12 | last writer of `pv_work/T01Stmt.lean` | PASS | pv-drafter (agent a0edd8e1), 2026-10-12 21:49:35 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 4 | `verification/audits/DEFS_gate.md` | `Paper.Defs.Dn`, `Paper.Defs.cdfOf`, `Paper.Defs.edf`, `Paper.Defs.edfRV` |
| `T01Stmt` | 9 | `verification/audits/T01_gate.md` | `Paper.T01.ConvInDist`, `Paper.T01.DonskerUniformSup`, `Paper.T01.IsBrownianBridge`, `Paper.T01.KSConclusion`, `Paper.T01.KSConclusion.mk`, `Paper.T01.Kfun`, `Paper.T01.Kfun._proof_1`, `Paper.T01.KolmogorovFormula`, `Paper.T01.supAbs` |

## Declarations in `pv_work/T01ModGaps.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma Iic_inter_Icc01`, `lemma cdfOf_eq_cdf`, `lemma edf_bounds`, `lemma law_comp`, `lemma pit_law`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T01.KSConclusion.cdf` | 5 | — | WARNING: the type has 13 leading binders but the proof term binds only 5; usage of the remaining 8 hypotheses is unknown |
| `Paper.T01.KSConclusion.conv` | 5 | — | WARNING: the type has 11 leading binders but the proof term binds only 5; usage of the remaining 6 hypotheses is unknown |
| `Paper.T01.T01_S2` | 9 | — |  |
| `Paper.T01.T01_S3` | 8 | — |  |
| `Paper.T01.T01_S4` | 12 | — |  |
| `Paper.T01.T01_S5` | 16 | — |  |
| `Paper.T01.T01_S6` | 7 | — | WARNING: the type has 9 leading binders but the proof term binds only 7; usage of the remaining 2 hypotheses is unknown |
| `Paper.T01.T01_mod_gaps` | 11 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- `Paper.T01.T01` renamed to `Paper.T01.T01_mod_gaps`: do the §2b copy-and-`example` check
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)

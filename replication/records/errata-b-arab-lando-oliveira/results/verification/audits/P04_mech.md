# Mechanical audit checks — P04 (`P04`)

Run by: pv-auditor (agent a1b25cd6, session 3b514bad), with `python3 scripts/pv_audit_mech.py P04` on 2026-10-13 01:59. Probes: `pv_work/probes/auditor/P04/auditor_P04_mech1.lean`, `pv_work/probes/auditor/P04/auditor_P04_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P04` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P04_4.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P04 exit=0 delivered=8bbc890de3fe2794857f807bd43ea30b9f84a0956674ef6d6ed425f5861554f1 rebuilt=8bbc890de3fe2794857f807bd43ea30b9f84a0956674ef6d6ed425f5861554f1 IDENTICAL log=pv_work/probes/auditor/P04/rebuild/P04.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P04_gate_r2.md` (18 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms P04` | PASS | ALL STANDARD |
| 7 | `#pv_walk P04`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/P04.lean` | PASS | pv-prover (agent a092129e), 2026-10-13 01:58:10 |
| 12 | last writer of `pv_work/P04Stmt.lean` | PASS | pv-drafter (agent a480b697), 2026-10-13 01:43:26 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `P04Stmt` | 12 | `verification/audits/P04_gate_r2.md` | `Paper.P04.ConvexTransformLE`, `Paper.P04.DOR`, `Paper.P04.F`, `Paper.P04.Fbar`, `Paper.P04.IOR`, `Paper.P04.Lam`, `Paper.P04.P04_X01Tool`, `Paper.P04.SuperPareto`, `Paper.P04.paretoCdf`, `Paper.P04.paretoMeasure`, `Paper.P04.quantile`, `Paper.P04.suppIn` |

## Declarations in `pv_work/P04.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`def s4_G`, `lemma lam_eq`, `lemma s4_F_le_of_lt_Q`, `lemma s4_F_mono`, `lemma s4_Q_le`, `lemma s4_Q_mono`, `lemma s4_key_le`, `lemma s4_key_lt`, `lemma s4_lam_add_one`, `lemma s4_le_F_Q`, `lemma s4_le_Q`, `lemma s4_pareto_val`, `lemma s4_set_bdd`, `lemma s4_set_nonempty`, `lemma s4_supp_pareto`, `theorem s4_bwd`, `theorem s4_fwd`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P04.P04_S1` | 3 | — |  |
| `Paper.P04.P04_S2` | 4 | inst._@.P04._hyg.37: MeasureTheory.IsProbabilityMeasure.{0} Real Real.measurableS |  |
| `Paper.P04.P04_S3` | 2 | — |  |
| `Paper.P04.P04_S4` | 3 | — |  |
| `Paper.P04.P04_S5` | 3 | — |  |
| `Paper.P04.P04_main` | 4 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS

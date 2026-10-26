# L02 final audit (Lemma 5.16, `lem:xlower`), revision 1

- Auditor: pv-auditor (independent subagent, Claude Opus 5.5); not the drafter, gate or prover.
- Date: Tue Oct 13 10:54:00 EDT 2026 (`date`).
- Audited object: `pv_work/L02.lean` (no gap file; prover notes: all obligations proved).
- Source read directly: `source/geo_erg_HMC_v3.1.tex:960-1007` (statement and proof), 945-958 (L01 = Lemma 5.15), 897-899 (eqn:explode), 330-336 (leapfrog recursion, `ε > 0`).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L02`)

Report `verification/audits/L02_mech.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L02` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (324c2ab4…) |
| 3 | PVTools hash | PASS |
| 4 | 12 gated fingerprints vs `L02_gate.md` | PASS, all th/vh/bi identical |
| 5 | Defs vs `DEFS_gate.md` | PASS |
| 6-7 | `#pv_axioms L02`, `#pv_walk L02` | PASS: propext, Classical.choice, Quot.sound; no sorryAx |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED premise in any gated theorem |
| 11 | traced conditions | `L02_L01Consumed` |

Item 10 warning on `L02_S7` (14 binders vs 11 bound): the 3 unbound binders are `i`, `1 ≤ i`, `i ≤ L` of the conclusion `∀ i, 1 ≤ i → i ≤ L → …` (introduced by `intro` at L02.lean:132); they are conclusion binders, not premises. Not a FAIL.

## 2. Gap files

None (no `L02ModGaps.lean`; no stopped obligations).

## 3. Per-theorem conditionality

Probe `pv_work/probes/auditor/L02/final_L02_r1_probe.lean` (log `pv_work/logs/final_L02_r1_probe_2.log`, exit 0).

| Hypothesis of `L02_main` | USED? | Passed to | Actually used at |
|---|---|---|---|
| `hL01 : L02_L01Consumed gU eps` (external, (p)) | USED | only `L02_S3` (L02.lean:155) | `L02_S3`: `hL01 δ hδ` gives L01's η and base case, `#pv_hyp_usage L02_S3`: hL01 USED. TEX:982-983 "The case i=1 then follows from Lemma lem:xelower". |
| `heps : 0 < eps` | USED | only `L02_S2` | `#pv_hyp_usage L02_S2`: USED (positivity of ε², TEX:976-981; source convention TEX:336) |
| `hexp : HypExplode gU` | USED | only `L02_S2` | `#pv_hyp_usage L02_S2`: USED (TEX:976, "By (17)") |

The only external parameter is `L02_L01Consumed`; it is a predecessor clause of L01, consumed exactly (`∀ δ<1, Paper.L01.Concl gU eps δ`, equal to the type of `Paper.L01.L01_main` after `heps`, `hexp`; my probe applies `Paper.L01.L01_main` to discharge it, which typechecks).

## 4. Infrastructure (item 8) — individual review of each constant

No constant had an individual final-audit record; I reviewed each one.

| Constant | Review | Verdict |
|---|---|---|
| `Paper.Defs.E` | `abbrev` for `EuclideanSpace ℝ (Fin d)`, Euclidean norm, TEX:192-194 | PASS |
| `Paper.Defs.H._proof_1` | auto-generated `(0+2).AtLeastTwo` numeral proof (`#print`), no mathematical content, shared by the elaborator for the literal `2` | PASS |
| `Paper.Defs.HypExplode` | `Tendsto (‖gU x‖/‖x‖) (comap ‖·‖ atTop) atTop` = (17), TEX:897-899 | PASS |
| `Paper.Defs.leapfrogStep` | half-step p, full x, half-step p, M = I: matches TEX:332-334 | PASS |
| `Paper.Defs.leapfrogState` (+ `match_1`) | `n`-fold iteration from `(x0,p0)`, TEX:330 "L steps of the recursion" | PASS |
| `Paper.Defs.xLF` | first component = `x_{iε}` | PASS |
| `Paper.L01.Concl` | L01 conclusion, TEX:946 (strict `>`), definition only | PASS |
| `Paper.L02.Concl` | TEX:961-965, both clauses (stepwise, `3^L`), non-strict as printed | PASS |
| `Paper.L02.L02_L01Consumed` | exactly L01's conclusion for all δ<1; not goal-shaped (base case only) | PASS |

All are definitions (no theorems smuggled), none encodes the target conclusion as an assumption; all compiled with standard axioms.

## 5. Route fidelity (sentence by sentence)

| Source | Lean | Faithful? |
|---|---|---|
| 969-975 recurrence by eliminating half-step momentum | S1: unfold `leapfrogStep` twice, `module` | yes |
| 976-981 R with ε²‖∇U(x)‖/‖x‖ ≥ 16/3 for ‖x‖ ≥ R, by (17) | S2: `eventually_ge_atTop (16/(3ε²))` along the comap filter | yes |
| 982-983 choose ‖x0‖ ≥ max(R,η); case i=1 from Lemma 5.15 | S3 + main: η' = max(max η R) 0, strict `η' < ‖x0‖` | yes (see FIS 1, EDITORIAL) |
| 984-997 taking norms in recurrence; ‖x_{i-1}‖/‖x_i‖ ≤ 1/3 | S4a (triangle inequality on S1, divide by ‖x_i‖), S4b | yes |
| 998-999 preceding steps give ‖x_i‖ ≥ ‖x0‖ ≥ R | S5 (induction on the stepwise bounds) | yes |
| 1000-1004 16/3 − 7/3 = 3 | S6 | yes |
| 1005-1006 induction; 3^L follows | S7 (induction, base S3, step S6), S8 (telescoping) | yes |

No route change, no stronger result used than the source cites, no helper lemmas.

FAIR_IMPLICIT_STEPs:
1. TEX:982 "‖x0‖ ≥ max(R,η)" while L01 needs strict ‖x0‖ > η, and reuse of the symbol η for L01's constant: filled by taking L02's η' = max(max η R) 0 with strict `η' < ‖x0‖` (EDITORIAL, as the gate ruled).
2. Divisions by ‖x_{iε}‖ (TEX:987-996) and by ‖x‖ (TEX:978): filled by `0 < ‖x0‖` from η' ≥ 0 and ‖x_i‖ ≥ ‖x0‖ (S5); gate-approved TFA `hx`, `hx0`.
3. "The claim holds once ‖x_0‖ is large enough" with ε > 0 (TEX:336) used for 16/(3ε²).

## 6. Non-vacuity

Probe `final_L02_r1_probe.lean`: witness `gU x = ‖x‖ • x` (∇ of ‖x‖³/3) on `E 1`, `ε = 1`, `L = 2`. Proved `HypExplode` for it, discharged `hL01` via `Paper.L01.L01_main`, obtained `Concl (gW 1) 1 2 δ` for every δ<1, and extracted a concrete point x0 (norm |η|+1 > 0, p0 = 0) with `9‖x0‖ ≤ ‖x_{2ε}‖`. Axioms of both probe theorems: propext, Classical.choice, Quot.sound. Hypotheses are satisfiable and the conclusion is non-trivially instantiated.

## 7. Status for the authors

Verified: Lemma 5.16 (both the stepwise bound (eqn:stepwise) and ‖x_{Lε}‖ ≥ 3^L‖x0‖) along the revised proof TEX:968-1007, under (17) and ε > 0.
Depends on: Lemma 5.15 (L01) for the case i = 1 (TEX:983), passed as the predecessor clause `L02_L01Consumed`.
Source: the revised proof is correct; only editorial slips (η reused for L01's constant, ≥ max(R,η) against L01's strict >, divisions by norms whose nonvanishing is left implicit).

## FAIL items

None.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: L02_L01Consumed

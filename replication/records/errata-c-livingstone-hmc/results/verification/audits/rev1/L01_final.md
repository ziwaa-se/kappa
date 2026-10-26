# L01 (Lemma 5.15, lem:xelower): final audit

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), session c0e71d40. I am not the drafter, gate, prover or issue checker.
- Date: Mon Oct 12 22:32:18 EDT 2026 (from `date`).
- Audited object: `pv_work/L01.lean` (no gap file). Verdict-bearing theorem: `Paper.L01.L01_main_fixedDelta : ConclFixedDelta gU eps`.
- Source read directly: `source/geo_erg_HMC_v3.1.tex:860-909` (statement 884-886, proof 888-897, hypothesis (17) at 865-867, consumers at 879 and 899-901). Shared definitions read in full: `pv_work/Defs.lean` l.1-92. Statement file: `pv_work/L01Stmt.lean`. Gate reports: `verification/audits/L01_gate.md`, `verification/audits/DEFS_gate.md`. Prover notes: `pv_work/notes/L01_prover_notes.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L01` -> report `verification/audits/L01_mech.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL (76b7722d…) |
| 3 | PVTools.lean hash | PASS |
| 4 | fingerprints vs L01 gate (8 gated decls) | PASS, all th/vh/bi identical |
| 5 | Defs vs DEFS gate | PASS, identical |
| 6 | `#pv_axioms L01` | PASS, ALL STANDARD |
| 7 | `#pv_walk L01` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` gated theorems | no UNUSED hypothesis |
| 11 | traced conditions | none |
| 12 | last writers | L01.lean: pv-prover; L01Stmt.lean: pv-drafter |

## 2. Gap file

None (no `L01ModGaps.lean`; prover notes: no gaps). N/A.

## 3. Axioms and sorry

Items 6-7 PASS. Confirmed independently in probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (log `pv_work/logs/auditor_L01_nonvac_1.log`, exit 0): `L01_main_fixedDelta` depends on `[propext, Classical.choice, Quot.sound]`.

## 4. Per-theorem conditionality

- No external parameter (`def Tool : Prop`) occurs in any gated theorem. Hypotheses of `L01_main_fixedDelta`: `heps : 0 < eps` (printed, TEX:336), `hexp : HypExplode gU` (printed (17), TEX:865-867), `hδ : δ < 1` (printed, TEX:885). All USED (probe log l.8-15).
- `hexp` is consumed at S4 (`#pv_hyp_usage L01_S4`: hexp USED, log l.16-22), the step TEX:896 "Using (17)". `hδ` consumed at S5 (log l.23-30), TEX:896 "as ‖p0‖ ≤ ‖x0‖^δ for some δ<1". Both are the paper's own hypotheses, not conditions.
- TRACED CONDITIONS: none, confirmed.

## 5. Infrastructure (item 8): constants in the closure, individually

| Constant | Record | My check |
|---|---|---|
| `Paper.Defs.E` | DEFS_gate (named in snapshot) | `EuclideanSpace ℝ (Fin d)`, TEX:192 Euclidean norm. OK |
| `Paper.Defs.leapfrogStep` | DEFS_gate (named) | Matches TEX:331-334 with M=I; `xLF … 1 = x0 - (ε²/2)∇U(x0) + εp0` (proved as S1). OK |
| `Paper.Defs.leapfrogState`, `.match_1` | DEFS_gate (named) | n-fold iteration from (x0,p0); match_1 is the compiler-generated matcher. OK |
| `Paper.Defs.xLF` | DEFS_gate (named) | first component. OK |
| `Paper.Defs.HypExplode` | DEFS_gate (named) | `Tendsto (‖gU x‖/‖x‖) (comap ‖·‖ atTop) atTop` = (17). Not conclusion-shaped. OK |
| `Paper.Defs.H._proof_1` | DEFS_gate covers module; audited here | `#print`: `(0+2).AtLeastTwo := instNatAtLeastTwo`, numeral instance proof, no axioms. Harmless |
| `Paper.L01.ConclFixedDelta` | L01_gate (named, th/vh identical) | Fixed-δ reading of TEX:885, approved by gate item 3; I concur (proof TEX:896 and consumers TEX:879, 899-901, 940 use fixed δ). OK |
| `Paper.L01.Concl._proof_1` | L01_gate covers module; audited here | `(0+2).AtLeastTwo := instNatAtLeastTwo`, no axioms. Harmless |

No in-project theorem is consumed from another result; no helper lemmas. `Paper.L01.Concl` (uniform-δ reading) is a dead definition, not in the closure of the main theorem and not an open obligation (gate ruling, which I accept).

## 6. Route fidelity (sentence by sentence)

| Source (TEX) | Lean | Fidelity |
|---|---|---|
| 890 "x_ε = x0 - (ε²/2)∇U(x0) + εp0" | S1: unfold `xLF/leapfrogState/leapfrogStep`, `module` | conversion of notation only |
| 890 "≥ (ε²/2)‖∇U(x0)‖ - ‖x0‖ - ε‖p0‖" | S2: `norm_sub_le`, `norm_add_le`, `norm_smul`, ε>0 | reverse triangle inequality, as printed |
| 892-895 "Dividing by ‖x0‖ gives (20)" | S3: `le_div_iff₀`, `field_simp`, premise x0 ≠ 0 | as printed; x0≠0 is approved TFA (gate) |
| 896 "Using (17), first term larger than [a constant]" | S4: for any B, ∃η₁, ‖x0‖>η₁ → B < (ε²/2)‖∇U‖/‖x0‖; main uses B=4 | same route; constant filled in, see FAIR_IMPLICIT_STEP 1 |
| 896 "last term negligibly small as ‖p0‖≤‖x0‖^δ, δ<1" | S5: ‖p0‖/‖x0‖ ≤ ‖x0‖^(δ-1) → 0 (`tendsto_rpow_neg_atTop`), ζ=1 | same route; see FAIR_IMPLICIT_STEP 2 |
| 896 "which establishes the result" | main: η = max(η₁,η₂,1), ratio > 4-1-1 = 2, multiply by ‖x0‖ | arithmetic assembly |

No route change, no stronger result used, no helper lemmas, no mathematics beyond the source.

FAIR_IMPLICIT_STEP:
1. Constant in S4: the source says "larger than 6/ε²" for the first term; (17) makes the first term exceed any constant, and the Lean proof takes B = 4 (any B > 3 together with a small enough last term works). Filled in by quantifying S4 over all B.
2. "Negligibly small": made explicit as ε‖p0‖/‖x0‖ < 1 for ‖x0‖ > η₂(δ), via ‖x0‖^(δ-1) → 0.
3. η ≥ 1 to ensure ‖x0‖ > 0 (division at TEX:892) and to use ‖p0‖/‖x0‖ ≤ ‖x0‖^(δ-1).

## 7. Non-vacuity

Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean`, exit 0, 0 sorry:
- `auditor_L01_explode`: `HypExplode (fun x => ‖x‖ • x)` proved for every d (nontrivial witness, ‖∇U(x)‖/‖x‖ = ‖x‖ → ∞; it is ∇ of ‖x‖³/3).
- `L01_main_fixedDelta` instantiated at d = 2, ε = 1/10, gU x = ‖x‖•x: compiles.
- Antecedent of the conclusion is satisfiable for every η, δ (d = 1, x0 = single 0 (|η|+1), p0 = 0), so the conclusion is not vacuous.

## 8. Source assessment

- TEX:896 "the first term on the right-hand side is larger than 6/ε²": EDITORIAL slip. Literally (first term > 6/ε²) it does not give ratio > 2 when ε is large (e.g. ε = 10: first term > 0.06); read as ‖∇U(x0)‖/‖x0‖ > 6/ε² it gives first term > 3, hence ratio > 2 - (negligible), still not strictly > 2. The argument is unaffected because (17) allows any constant; no paper-side issue.
- TEX:885 quantifier placement of "for some δ<1": ambiguous; EDITORIAL / at most DOMAIN_CLARIFICATION-level wording, resolved by the proof and by Lemma 5.17's "for any δ<1" (TEX:940); both readings were found true in the archived ruling `verification/audits/revenc1/L01_issue_1.md`. Not dispatched.
- Doc erratum (formalization side, not paper): docstrings in `pv_work/L01Stmt.lean` l.15 and l.22 describe `Concl` as the "literal" reading and `ConclFixedDelta` as the "alternative" one, whereas `ConclFixedDelta` is the verdict-bearing statement; for `verification/DOC_ERRATA.md` (file must not be edited).

## Status for the authors

Lemma 5.15 (fixed-δ reading: for each δ<1 there is η) is verified along the printed route from (17) and ε>0 alone, with no external inputs.
Depends on nothing beyond the paper's own hypothesis (17).
Source: correct; one editorial slip (TEX:896 constant "6/ε²") and an ambiguous quantifier order at TEX:885, neither affecting validity.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

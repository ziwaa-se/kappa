# Henzi and Ziegel, "Valid sequential inference on probability forecast performance": final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator; a draft was fact-checked independently (`verification/report/work/factcheck.md`) and the corrections listed there have been applied.

- **This report is not a claim that the whole paper is fully verified.** The two conditionally verified results depend on 3 visible external parameters (X03; `P04_T01Consumed`, `P04_MixingOfStrict`) that have not been verified in Lean. A fourth registered parameter, `P05_P04Consumed`, belongs to P05 (ISSUE); a fifth, `T02_T01Consumed`, is unregistered and not load-bearing. Three results carry recorded issues.
- **For per-result details, `verification/PAPER_VERIFICATION.md` and the audit reports are the records; where they differ from this report (see §8), the audit reports take precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).
- Source: `source/VSIFP_02.tex`. Numbering follows the PDF (no .aux was available). Proposition 3.4 is called "Lemma" in the text (l.220, l.236, l.261).

---

## 0. Summary table (English, for screenshots)

**5 numbered results: 0 verified unconditionally · 2 verified conditionally · 3 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions (exceptions recorded in words: §3 and §7). None of the three recorded issues is a counterexample to the *statement* of a main result at the instances checked, except P05 for h ≥ 2, where the printed conclusion itself fails (Lean counterexample).

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 3.1 (T01) | Theorem: characterization of e-values for H_S | Issue recorded | Proof step "E(0) ∈ (0,1)" at l.419 (mirror l.423) is false at λ = 1 (PAPER_ARGUMENT_GAP, minor). The statement is not contradicted. |
| 3.2 (T02) | Theorem: GROW e-value for score dominance | Issue recorded | l.435 (mirror l.462) claim fails at π₁ = 1 (resp. π₁ = 0) (PAPER_ARGUMENT_GAP); sign error at l.454. The statement is not contradicted at the instances checked. |
| 3.3 (T03) | Theorem: GROW e-value for all scores | Verified conditionally | Condition X03 (Theorem 1 of Grünwald, de Heide, Koolen 2019). |
| 3.4 (P04) | Proposition: sequential e-values for lag h | Verified conditionally | Conditions `P04_T01Consumed` (Theorem 3.1 sufficiency clause) and `P04_MixingOfStrict` (l.106); scope: integrable score differences, mixture-representation convention. |
| 3.5 (P05) | Proposition: validity under optional stopping | Issue recorded | The proof step E(e_t∣ℱ_t) ≤ 1 (l.474/476) is unjustified; the printed conclusion fails for h ≥ 2 (Lean counterexample, E e_τ = 5/4, ERROR). h = 1 believed true (reasoning only). |

No result has had every condition checked by a person (no human check was recorded; all four registered parameters read "not yet").

## 1. Overall findings

1. **Counterexample to a main result.** Yes, one: Proposition 3.5 for h ≥ 2 (ERROR, paper side; Lean instance at h = 2, reading A of `e_τ`, see §6). The issues in Theorems 3.1 and 3.2 are gaps at boundary cases of the *proof* (λ = 1, π₁ = 1); at those instances the theorem's conclusion still holds. This is not a complete list of observations; see §4 for all issues.
2. Results verified unconditionally: none.
3. Results verified conditionally: T03 (condition X03) and P04 (conditions `P04_T01Consumed`, `P04_MixingOfStrict`). Exceptions and debts recorded in words: the mixture representation is taken as a hypothesis (TFA-2), integrability scopes (TFA-1), `p_t = q_t` convention (P04, unruled); see §3 and §7.
4. Results with an issue recorded: T01 (B1), T02 (B2), P05 (B3). All three have Lean evidence for the specific failing step (counterexample files, each reviewed by pv-auditor: COUNTEREXAMPLE VALID). Only T02's *issue 1* and not its issue 2 (l.454 sign) was reviewed this way.
5. Downstream impact: B1 and B2 do not propagate to other numbered results through their statements (P04 consumes only the sufficiency direction of Theorem 3.1, which is proved gap-free as `T01_S2`). B3 affects every use of `e_τ` for h ≥ 2 (l.252 anytime-valid p-value, l.292, Appendix l.480-495 insofar as they rely on P05; not checked).

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 3.1 T01 | ISSUE (B1) | Sufficiency (l.403) and necessity for p < q (l.403-418, 421) proved in Lean with standard axioms and no parameters; the p > q necessity (l.423, "similar arguments") is a gap hypothesis `T01_S10_Gap`; step l.419 is a gap `T01_S8_Gap`, false at λ = 1. Main: `pv_work/T01ModGaps.lean:308 Paper.T01.T01_mod_gaps`. |
| 3.2 T02 | ISSUE (B2) | e-value clause for p < q (S14, via S12/S13a) proved with no gaps but *with the sign-corrected l.454*; GROW-maximality clause proved only modulo `T02_S8_Gap`, false at π₁ = 1; the p > q case is not written in the source and is a gap. Gaps S3a, S3b, S8, S11, S15. Main: `pv_work/T02ModGaps.lean:385 Paper.T02.T02_mod_gaps`. |
| 3.3 T03 | CONDITIONAL (X03) | S1-S4 (direct computation) proved without parameters; S5 is Theorem 1 of Grünwald et al. 2019 (X03). Main: `pv_work/T03.lean:145 Paper.T03.T03_main`. |
| 3.4 P04 | CONDITIONAL | Proved along the h = 1 route with the l.470 index list corrected (editorial). Main: `pv_work/P04.lean:556 Paper.P04.P04_main`. |
| 3.5 P05 | ISSUE (B3) | Steps S1-S4 of the general lemma (l.474-476) proved from its premise; the premise (bridge E(e_t∣ℱ_t) ≤ 1) is not implied by P04 and is false for the instance; Main: `pv_work/P05ModGaps.lean:135 Paper.P05.P05_main_mod_gaps`. |

**Scope reading for the two "holds" statements.** The records say "Theorem 3.1 holds" and "Theorem 3.2 holds". The evidence is: Lean covers the parts listed above; the truth of the remaining edge cases and of the p > q case of Theorem 3.2 rests on the gate's hand checks and reasoning, not on Lean (§6, items 13-14).

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected (it counts as (iv), and gets priority A, when the predecessor has an issue; PIPELINE stage 6b). Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4. There are no type (iii) or (v) parameters.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `Paper.T03.GruenwaldThm1` (X03), `pv_work/T03Stmt.lean:42` | (i) | T03 (step S5) | Theorem 1 of Grünwald, de Heide, Koolen 2019 gives the LR as GROW e-value **and** a.s. uniqueness, in the encoded form | not yet |
| 2 | `Paper.P04.P04_T01Consumed`, `pv_work/P04Stmt.lean:78` | (p), counts as (iv) because T01 is ISSUE; not reconnected | P04 (e-value clause) | The *sufficiency* direction of Theorem 3.1 (source l.144-149, proved at l.403 by "one can easily verify"). The gate probe derives it from the gap-free `T01_S2`. | not yet |
| 3 | `Paper.P04.P04_MixingOfStrict`, `pv_work/P04Stmt.lean:90` | (ii) | P04 | l.106 "strictly consistent iff ν charges every non-degenerate interval" (only-if half), against the work cited at l.93 as `Gneiting2007` (Gneiting, Balabdaoui, Raftery 2007, Thm 2.3; see §6 item 2). The gate and final audit also call its use in P04 silent ((ii)/(iii)); it is asserted at l.106, so it is not A′. | not yet |
| 4 | `Paper.P05.P05_P04Consumed`, `pv_work/P05Stmt.lean:21` | (p), predecessor P04 | P05 (step Snn); not load-bearing for the verdict (issue) | Inherits #2, #3 and P04's integrability scope | not yet |
| 5 | `Paper.T02.T02_T01Consumed`, `pv_work/T02Stmt.lean:40` | (p), counts as (iv) because T01 is ISSUE; **unregistered** | only a premise of `T02_mod_gaps` (S15 gap) | The necessity direction of Theorem 3.1 (the part with issue B1). Not load-bearing. | not yet |

Debts recorded in words (not Lean hypotheses): mixture representation as hypothesis (TFA-2: scores without an exact representation, e.g. Brier − 5, are excluded; the "mild regularity conditions" of l.93 are not encoded); integrability inside `MixtureRep` (TFA-1); integrability of score differences in ℋ_{S;c} for P04/P05 (stated with the verdict, per P04_final); `τ` finite everywhere and τ ≥ h+1 a.s. (P05 TFA); `p_t = q_t` read as "no bet" (`Erep = 1`) in P04 (candidate DOMAIN_CLARIFICATION, never ruled); route deviations (P04 S7 uses the corrected conditioning list; T02 S12/S13a use the sign-corrected d(y)).
External assertions not encoded (no audit record examines them): Vovk-Wang 2020 merging motivation (l.220); the l.174 remark on obtaining Theorem 3.2 from Theorem 1 of Grünwald et al.; anytime-valid p-values (l.252); Table 1 κ values (l.176-186); Sections 4-5 and Appendices B-C.

## 4. Substantive issues for the authors (in PDF order)

### 4.1 Theorem 3.1, proof l.419 and mirror l.423: PAPER_ARGUMENT_GAP (minor), paper side. BLOCKERS B1

- **Location.** l.419: "It follows from (eq:evalueCond) and (eq:ratio) that E(0) ∈ (0,1), so with λ = 1 − E(0)". Mirror l.423: "Similar arguments for the case p > q".
- **What fails.** The theorem allows λ ∈ (0,1] (l.145), and l.403 itself notes E{1(p>q)} = 1 − λ ≥ 0. At λ = 1, E(0) = 0, so "E(0) ∈ (0,1)" is false; the same for E(1) when p > q.
- **Lean evidence.** `pv_work/T01_Counterexample1.lean`: ν = δ_{1/2}, p = 1/4, q = 3/4, E = E_{p,q;1} with E(0) = 0, E(1) = 2 (`not_PrintedClause_l419`, `not_S8Gap`, `mirror_E1_zero`). Reviewed: `verification/audits/T01_issue_1_audit.md`, COUNTEREXAMPLE VALID.
- **Not affected.** The theorem's two directions are not contradicted (the instance lies in the family with λ = 1); P04's use of the e-value formula; T02's use at l.430; sufficiency (proved as `T01_S2`).
- **Recorded suggestion** (T01_issue_1 §6, confirmed sufficient in T01_issue_1_audit §5; suggestion only): replace `E(0) ∈ (0,1)` by `E(0) ∈ [0,1)`; then λ = 1 − E(0) ∈ (0,1]; mirror: `E(1) ∈ [0,1)`.
- **Limit.** The p > q necessity direction is a gap in Lean (`T01_S10_Gap`), with a fill-in recipe in T01_issue_1 §8, not proved.

### 4.2 Theorem 3.2, proof l.435 and mirror l.462: PAPER_ARGUMENT_GAP, paper side. BLOCKERS B2 (issue 1)

- **Location.** l.435: "g is continuous in λ with g(0) = 0 and lim_{λ→1} g(λ) = −∞, so a maximum is attained at some λ ∈ [0,1)." Mirror l.462: "The case p > q is analogous."
- **What fails.** At the admissible alternative π₁ = 1 (p < q) (π₁ = 0 for p > q; l.448 says "for all π₁ ∉ H_S"), g(λ) = log(1 − λh) with h < 0 is finite and strictly increasing, so the limit is not −∞ and no maximum exists in [0,1). The silent step S8 fails there too (λ₀ = 1). For π₁ < 1 the limit claim is true.
- **Lean evidence.** `pv_work/T02_Counterexample1.lean` (ν = δ_{1/2}, p = 1/4, q = 3/4, π₁ = 1): `counterexample_l435_lim`, `counterexample_l435_max`, mirror `analogue_l462_fails`; `conclusion_holds_at_instance` and `conclusion_holds_at_mirror` show the theorem's conclusion holds at both edges. Reviewed: `verification/audits/T02_issue_1_audit.md`, COUNTEREXAMPLE VALID.
- **Threatens the conclusion?** No at the instances (Lean); in general by hand (reasoning, not Lean).
- **Not affected.** The e-value clause for p < q; steps S1, S2, S4-S7, S10, S12-S13b; all π₁ ∈ (κ,1) for p < q. No other numbered result depends on T02.
- **Recorded suggestion** (T02_issue_1; audit §6, suggestion only): add the edge case at l.435: "If π₁ = 1, then g(λ) = log(1 − λh) is strictly increasing and the maximum over (0,1] is attained at λ = 1, in agreement with the formula; for π₁ < 1, lim g = −∞", and the mirror for π₁ = 0.
- **Related ruling (issue 3, FAIR_IMPLICIT_STEP).** The proof maximises over [0,1) while the statement ranges over (0,1]; away from π₁ = 1 this is a fair implicit step.

#### 4.2b l.454, sign of d_{p,q}(y): PAPER_ARGUMENT_GAP (minor) by the ruling; "a human may reasonably downgrade it to EDITORIAL"

- l.454 prints `d_{p,q}(y) = ∫ 1{p ≤ θ < q}(θ − y) dν`; from l.98-105 the integrand should be `(y − θ)`. The printed formula gives d(0) > 0, contradicting d(0) < 0 at l.435. Lean: `counterexample_l454` (y = 0: LHS −1/2, RHS 1/2), gate `S11_false`.
- Affects S11 only; S12, S13a, S13b, S14 are invariant under a global sign change, and the e-value clause is therefore reported as "proved with the sign-corrected l.454" (T02_final §5).
- Recorded classification is inconsistent across records: the ruling says PAPER_ARGUMENT_GAP, T02_final reads it as editorial level, BLOCKERS B2 calls it a "side note", and no counterexample review covers it (only issue 1 was reviewed). It is reported here as ruled by the issue-checker, unreviewed.
- Recorded suggestion (reviewer's, not used in verification): replace `(θ − y)` by `(y − θ)` at l.454 and the middle expression of l.456 by `ν[p,q) / (ν[p,q) − ∫_{[p,q)} θ dν)`. T02_final §8 disputes the need for the l.456 change: the printed l.456 chain is a true chain of real numbers and only l.454 must change; the l.456 replacement is equivalent and optional.

### 4.3 Proposition 3.5, proof l.474/476 with statement l.235-240: ERROR (h ≥ 2, confirmed by the counterexample review); PAPER_ARGUMENT_GAP (h = 1, issue-checker ruling, not reviewed), paper side. BLOCKERS B3

- **Location.** l.474: "a sequence of random variables such that E(e_t∣ℱ_t) ≤ 1 almost surely"; l.476: "E(e_τ) = Σ E{e_t 1(τ=t)} = Σ E{E(e_t∣ℱ_t) 1(τ=t)} ≤ 1". Statement l.236-238: "E_Q(e_τ) ≤ 1, Q ∈ ℋ_S".
- **What fails.** (i) P04 gives only E e_t ≤ 1, and e_t is ℱ_t-measurable, so E(e_t∣ℱ_t) ≤ 1 would mean e_t ≤ 1 a.s., false in general, for every lag. (ii) For h ≥ 2 the printed conclusion is itself false: Lean counterexample at h = 2 with E_Q e_τ = 5/4, satisfying all printed hypotheses and P04's conclusion. (iii) For h = 1 the conclusion is believed true, but the printed proof does not establish it.
- **Lean evidence.** `pv_work/P05_Counterexample1.lean` (Ω = Bool, Q uniform, Brier score, λ₂ = 1, τ ∈ {3,4}): `lintegral_stopped`, `not_printed`, `not_Sbridge`, `condExp_self_of_P04`. The gap premise is shown false: `example : ¬ P05_Sbridge_Gap`. Reviewed: `verification/audits/P05_issue_1_audit.md`, COUNTEREXAMPLE VALID, "subject to the reading-A human check". General h ≥ 2 (E e_τ = 1 + 1/(2h)) and the h = 1 truth are reasoning only.
- **Reading dependence.** Under reading B (the l.242 "stopped e-value", λ_t zeroed from τ on) the instance gives E = 1 and no violation; the source does not print that statement. A person should confirm reading A.
- **Not affected.** P04; the case study; the general lemma at l.474-476 itself (true for sequences satisfying its premise).
- **Possibly affected, not checked.** The l.252 anytime-valid p-value claim for h ≥ 2, l.292, and the τ_{α,h} procedure (l.248-252, Appendix l.480-495) insofar as they rely on P05.
- **Recorded suggestion** (P05_issue_1 §7, plausible per P05_issue_1_audit §7; suggestion only, not Lean-checked): restrict Proposition 3.5 to h = 1 and prove it from Proposition 3.4 with λ'_t = λ_t 1{t<τ} and Fatou, dropping the premise E(e_t∣ℱ_t) ≤ 1; for h ≥ 2 state the version used at l.242 and in the Appendix (the stopped e-value e'_{τ+h−1}).
- **Minor parts.** l.236-238 `ℋ_S` in the conclusion versus general c_t in the assumptions (DOMAIN_CLARIFICATION); l.223 versus l.236, e_τ for τ < h+1 (FAIR_IMPLICIT_STEP).

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| l.470 (P04) | Conditioning σ-fields listed as ℱ_{k+hl}, l = 1..⌊(T−k)/h⌋, are shifted by h | FAIR_IMPLICIT_STEP / editorial ("as in the case h = 1", l.469); the corrected list is ℱ_l, l ∈ I_k, in decreasing order | `verification/audits/P04_issue_1.md` (concurred in `P04_final.md`; **no independent reasoning review exists**, `P04_issue_1_audit.md` absent) |
| l.223 (P04) | p_t = q_t is allowed but E_{p,q;λ} is 0/0 there | Candidate DOMAIN_CLARIFICATION, **never ruled**; no reading makes the conclusion false (P04_final §4). Suggestion (P04_issue_1 §3): state E_{p,p;λ} :≡ 1 | `verification/audits/P04_issue_1.md`, `verification/audits/P04_final.md` (final audit says ISSUE only if opened and confirmed) |
| l.93 (P04 gate item 7.3) | "all consistent scoring functions are of the form (mixture)" ignores additive terms a(y) | Preliminary EDITORIAL / DOMAIN_CLARIFICATION, low priority, never ruled | `verification/audits/P04_gate.md` |
| l.435 / l.454 / l.462 (T02) | Issue 2 (sign) and issue 3 (range [0,1) vs (0,1]) | issue 2 PAPER_ARGUMENT_GAP (minor), issue 3 FAIR_IMPLICIT_STEP; neither threatens the conclusion | `verification/audits/T02_issue_1.md` (only issue 1 reviewed in `T02_issue_1_audit.md`) |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| The P04 verdict CONDITIONAL would become ISSUE if the p_t = q_t candidate were opened and confirmed; it is not in BLOCKERS or RESULTS `issues`. | `consistency_check.md` M1; `P04_final.md` §4 |
| The registry row for `P04_T01Consumed` cites `tex:205-223` and directs the human to T01's necessity step; the clause consumed is the sufficiency direction (l.144-149, l.403). The worksheet corrects this. | `consistency_check.md` M2; `P04Stmt.lean:72-78`; `BLOCKERS.md` B1 |
| DEFS_gate N2 (logarithmic score is infinite at p ∈ {0,1}, so `IsConsistent S` over [0,1] excludes it although Table 1 l.183 lists it) was not discussed in `T01_gate.md` / `T02_gate.md`; how T01/T02 treat the log score is UNVERIFIED. | `consistency_check.md` C7; `DEFS_gate.md` N2 |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | l.470 | Conditioning list shifted by h (see §4.x; recorded in P04_issue_1). |
| 2 | l.456 | Stray `\}` at the end of `\frac{1}{1 - \kappa_{\nu}\{[p,q)\}\}}` (T02_gate item 7.5; checked in the .tex). |
| 3 | l.236 (also l.220, l.261) | "Lemma \ref{prop:combination}" / "the following lemma" refer to Proposition 3.4 (P05_final §8). |
| 4 | l.165 | `\kappa_{\nu}\{[\min(p,q),\max(p,q))\big\}`: `\big\}` has no matching `\big\{`. pv-compiler's reading of the .tex; not in any audit record. |
| 5 | l.236 | "a almost surely finite stopping time". pv-compiler's reading of the .tex; not in any audit record. |
| 6 | l.176 | `\label{tab:scores}` precedes `\caption` in the table environment. pv-compiler's reading of the .tex; not in any audit record. |
| 7 | l.151 | "the accumulated capital at time if T the initial capital is 1" is garbled. pv-compiler's reading of the .tex; not in any audit record. |

Items 4-7 were confirmed against the .tex by the fact check and carry no suggested fix; items 1-3 are recorded in audits. Notation questions raised by the architect, never ruled (INVENTORY A01-A11): ν on (0,1) versus [0,1]; `h` as both lag and d(1)/d(0) in the proof of Theorem 3.2 (l.435); P and Q both used for hypothesis measures; "maximal in λ" over (0,1] (l.154) versus [0,1) (l.435); notation E^{π₁}_{p,q} versus E^{η_t}_{p_t,q_t} at l.229; time convention at l.208. T03: the case p = q is not discussed and vacuous (EDITORIAL at most).

## 6. Human-check list

**Literature and citations**
1. X03: does Theorem 1 of Grünwald, de Heide, Koolen 2019 give the LR identification and a.s. uniqueness as encoded? (priority D)
2. `P04_MixingOfStrict`: the sentence at l.106 and the regularity conditions of the Theorem 2.3 cited at l.93. Citation check: l.93 cites key `Gneiting2007`, which the .bbl resolves to Gneiting, Balabdaoui and Raftery (2007, JRSSB), not Gneiting and Raftery (2007, JASA; key `Gneiting2007a`); the records repeat the latter name. Confirm which paper was meant. l.106 has no citation of its own. (C)
3. `P04_T01Consumed`: accept the sufficiency direction of Theorem 3.1 as stated, or reconnect via `T01_S2`. (A)
4. `P05_P04Consumed` inherits items 2, 3 and the P04 integrability scope. (A by inheritance)
5. `T02_T01Consumed` (unregistered; not load-bearing). (A)

**Author intent**
6. P05: does `e_τ` mean e_{τ(ω)}(ω) (reading A, as l.233, l.476 indicate) or the stopped e-value of l.242 (reading B)?
7. P05 l.236-238: is ℋ_S (c ≡ 1) intended, or ℋ_{S;c}?
8. P04 l.223: is p_t = q_t meant to be allowed, with what convention? If confirmed as an issue, P04 becomes ISSUE.
9. Confirm the classes of T01 l.419 (ARGUMENT_GAP vs EDITORIAL; optional per the ruling), T02 l.435 (ARGUMENT_GAP vs EXPOSITION_GAP) and T02 l.454 (ARGUMENT_GAP vs EDITORIAL).
10. P04 l.470: an independent review of the FAIR_IMPLICIT_STEP / editorial ruling is missing.

**Mathematical completion (parts supported by reasoning only)**
11. P05, h = 1: the conclusion and the repair (λ'_t = λ_t 1{t<τ}, Fatou).
12. P05, general h ≥ 2 and the strict-interior variant (Lean covers h = 2 with Q on the boundary of ℋ_S).
13. T02: truth of Theorem 3.2 at the edges for general (S, ν, p, q) and the p > q case.
14. T01: the p > q necessity direction (`T01_S10`, l.423-426).
15. Downstream claims relying on P05 for h ≥ 2 (l.252, l.292, Appendix l.480-495).
16. DEFS_gate N2: treatment of the logarithmic score.
17. l.93: scores without an exact mixture representation (excluded by TFA-2).
18. P04 TFA-1: the e-value clause holds for Q ∈ ℋ_{S;c} with integrable score differences only.

**Experiments and unnumbered assertions**
19. Table 1 κ values (l.176-186), Sections 4-5 and Appendices B-C have no audit record.

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0, Mathlib c44e0c8e; Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`). Mathlib was fully compiled, but no `#check`/search evidence for "not in Mathlib" is recorded for the registered parameters (all are paper-specific notions or predecessor clauses); this is a record gap (§8).
- Technical formalization assumptions approved by the gates: TFA-1 (integrability inside `MixtureRep`; integrable score differences in P04/P05), TFA-2 (mixture representation as hypothesis), P05 τ finite and ≥ h+1 a.s., `Erep = 1` at p = q.
- Scope restrictions: real-valued consistency over [0,1] (logarithmic score, see §4.x); the P04 proof follows the h = 1 route with the corrected index list.
- Corrections on the formalization side: (a) DEFS gate A1: an ENCODING_ERROR in `IsGrowLambda` (`Real.log 0 = 0` would have manufactured a false paper error in Theorem 3.2), fixed and re-gated (DEFS_gate_r2); (b) P04 gate R1: `P04_MixingOfStrict` was amended after the gate rejected the first form (counterexample (p−y)² − 5); (c) P04 gate R2: `hS` added to `P04_S4`, whose earlier form could be false as stated; (d) P05 gate A1-A4: the first `P05_P04Consumed` was rejected because it turned the unjustified step l.474 into a hypothesis and would have hidden the gap.
- Lean comment errata: `verification/DOC_ERRATA.md` is empty.

## 8. Process disclosure

- Violations: none recorded. The coordinator did not edit audit reports (a guard hook blocked this once; pv-auditor rewrote the closing line of `T01_issue_1_audit.md`).
- Coordinator errors found and corrected by subagents: none beyond the above.
- Record inconsistencies found by pv-compiler and **not corrected in the records** in this unattended run (they are disclosed in this report instead; see `verification/report/work/consistency_check.md`): stale `partial` field of T02, `evidence.issues` lacking the `_audit.md` links, stale text of `P04_MixingOfStrict`/`P04_T01Consumed` registry rows, B2 wording on l.454 and S9/S11, empty tables in `EXTERNAL_TOOLS.md` and `PAPER_VERIFICATION.md`, stale upper sections of `RESUME.md`, duplicate `AUDIT.md` history entries, `*_mech.md` "TRACED CONDITIONS: none" for T03/P04/P05 not regenerated, `T02_T01Consumed` not registered, no `P04_issue_1_audit.md`, `upstream_issues: B1` on P05 but not on P04 (whose parameter links to T01), citation of the "Gneiting–Raftery" paper in the records versus `Gneiting2007` in the source, and no `#check` evidence recorded for "not in Mathlib". None changes a verdict count.
- The independent fact check of this report's first draft found 18 problems (0 Major, 7 Moderate, 11 Minor), which have been corrected (first draft: `verification/report/work/AUTHOR_REPORT_v1.md`). Not checkable by the fact check: Lean recompilation, PDF numbering, the cited literature. One observation of the fact check, not a finding: the introduction's general claim of validity under optional stopping (l.62, l.80) may also be touched by B3 for h ≥ 2; no audit examines it.
- Permission denials and guard refusals: not tallied in this run.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/` (`external_tools.md`, `author_notes.md`, `consistency_check.md`)
- `verification/report/work/factcheck.md` (independent fact-check report)

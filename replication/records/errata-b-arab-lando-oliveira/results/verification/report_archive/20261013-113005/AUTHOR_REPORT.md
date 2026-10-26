# Convex combinations of random variables stochastically dominate the parent for a new class of heavy tailed distributions: final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator. An independent fact check was run (`verification/report/work/factcheck.md`); its corrections are applied as listed in §8.

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 6 registered external inputs that have not been verified in Lean (a seventh Lean parameter, `T03_T01Consumed`, is refuted and no verdict uses it), and 8 of 12 results carry recorded issues.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).
- The source is `source/SuperParetoPaper-v12.tex`; `:N` means line N of it. PDF numbers come from the shared counter (no `.aux` was available), so numbers after 4.3 are inferred.

---

## 0. Summary table (English, for screenshots)

**12 numbered results: 3 verified unconditionally · 1 verified conditionally · 8 with recorded issues · 0 unfinished.**

"Verified conditionally" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain; those inputs are explicit Lean parameters, never hidden assumptions. Exceptions recorded in words: the encoding is for real-valued random variables only (Example 2.7, mass at +∞, is outside it), and "infinite mean" is encoded as "not integrable". Among the 8 recorded issues, B05 (Thm 2.8) and B09 (Thm 4.8) are Lean-checked counterexamples to a theorem as printed; B01, B04, B07, B08 are Lean-checked counterexamples to a lemma or proposition as printed (a missing hypothesis); B02, B03, B06, B10 are argument gaps or readings, and B06 does not threaten the conclusion.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.3 | L01 Lemma, InvSub characterisation | Issue recorded | B01: omits F_X(0)=0 from Def 2.2; X=0 a.s. refutes the "if" direction (Lean) |
| 2.5 | P01 Prop, InvSub via hazard rate bound | Verified (unconditional) | none; "negative" at :153 should read non-positive (editorial) |
| 2.8 | T01 Thm, closure under star-shaped maps | Issue recorded | B05: false as printed, h=max(x-1,0) gives F_{h(X)}(0)=1/2 (Lean); conditions T01_X02Tool, T01_L01Consumed |
| 3.1 | T02 Thm, main dominance theorem | Issue recorded | B06: invalid step at :256, conclusion not refuted; condition T02_L01Consumed; two suspicions unruled |
| 3.2 | P02 Prop, dominance forces infinite mean | Issue recorded | B02: √X used without X≥0; B03: n=2 reduction depends on reading |
| 3.3 | P03 Prop, InvSub implies infinite mean | Verified (conditional) | P03_T02Consumed, P03_P02Consumed, T02_L01Consumed |
| 4.6 | P04 Prop, DOR via convex transform order | Issue recorded | B07: false for a.s. constant X (Lean); clause 2 conditional on P04_X01Tool |
| 4.8 | T03 Thm, super-Pareto implies InvSub | Issue recorded | B09: false as printed (Lean); B10: h(0)=0 at :337 fails |
| 4.10 | L02 Lemma, super-heavy-tailed characterisation | Issue recorded | B04: omits F_X(0)=0 from Def 4.9; "if" direction false for X=0 a.s. (Lean) |
| 4.12 | T04 Thm, super-heavy-tailed implies InvSub | Verified (unconditional) | none; Log 0 case at :381 is a fair implicit step; "exponential is superadditive" (:385) editorial |
| 5.2 | P05 Prop, super-heavy-tailed via i-sb order | Issue recorded | B08: omits F_X(0)=0; "if" direction false for X=0 a.s. (Lean) |
| 5.3 | P06 Prop, InvSub via i-sb order | Verified (unconditional) | none; F^- to F switch and p=1 edge are fair implicit steps (editorial) |

No result has every condition checked by a person: no human check has been recorded.

## 1. Overall findings

1. **Counterexamples to theorems as printed.** Theorem 2.8 (B05) and Theorem 4.8 (B09) are false as printed, with Lean-checked counterexamples. B05 and B09's first instance share one mechanism: a continuous star-shaped map can make F_{h(X)}(0)>0, which Def 2.2 excludes. B09's second instance (X=Z+1) fails subadditivity, so "positive" does not repair Thm 4.8. The same missing condition F_X(0)=0 makes Lemma 2.3 (B01), Lemma 4.10 (B04) and Proposition 5.2 (B08) false in the "if" direction (X=0 a.s.), and Prop 4.6 (B07) is false for a.s. constant X. This is not a complete list; see §4.
2. **Verified unconditionally:** Prop 2.5 (P01), Thm 4.12 (T04), Prop 5.3 (P06).
3. **Verified conditionally:** Prop 3.3 (P03), on three consumed predecessor clauses (T02, P02, L01); the predecessors are ISSUE and so do not close them.
4. **Issue recorded, 8 results.** Lean evidence: B01, B04, B05, B07, B08, B09, B10 (counterexample or obstruction files, reviews VALID), B06 (counterexample to the intermediate step, review VALID). B02 has obstruction evidence only; B03 is reasoning only.
5. **Downstream impact.** B06 does not refute Theorem 3.1's conclusion. Thm 4.12 does not cite Lemma 4.10 and is unaffected. Prop 3.3 uses only n=2 and positive laws. No numbered result depends on T03 (Thm 4.8). Gap-file theorems of T01, T02, L02, P05 are vacuous (their gap hypotheses are refutable) and are not evidence for the stopped steps.
6. Four-way note: formalization-side items (ENCODING_ERROR for T01 obligation S0; encoding of `T01_X02Tool` for increasing h only) are not paper issues.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.3 L01 | ISSUE | "If" direction false (X=0 a.s.); "only if" and the subadditivity equivalence hand-checked only, not in Lean. `L01_gate.md`, `L01_issue_1_audit.md` |
| 2.5 P01 | UNCONDITIONAL | Derivative step rendered in integrated (Tonelli) form, faithful per the audit. `P01_final.md` |
| 2.8 T01 | ISSUE | Steps S1, S3-S6 verified in the gap file; the assembled subadditivity half depends there on the false encoding gap S0 (ENCODING_ERROR), and a source-strength route without S0 exists only in an unreviewed probe (`T01_issue_2.md` §4); the F(0)=0 half fails. `T01_final.md`, `T01_issue_1_audit.md` |
| 3.1 T02 | ISSUE | n=2 case, S6b, S7-S9, S10a, S11 verified conditional on T02_L01Consumed; step :256 invalid; S5/S6a (atoms, :222-223) and zero weights unruled and not verified. `T02_final.md` |
| 3.2 P02 | ISSUE | n=2 argument verified for nonnegative X only; B02 and B03. `P02_final.md` |
| 3.3 P03 | CONDITIONAL | Non-degeneracy at :269 is a fair implicit step. `P03_final.md` |
| 4.6 P04 | ISSUE | All clauses verified for non-degenerate X (the super-Pareto parenthetical conditional on `P04_X01Tool`); :320 step fair implicit. `P04_final.md` |
| 4.8 T03 | ISSUE | No proof session (refutable); no final audit. `T03_issue_1_audit.md`, `T03_issue_2_audit.md` |
| 4.10 L02 | ISSUE | S1-S3 and "only if" verified in gap file. `L02_final.md` |
| 4.12 T04 | UNCONDITIONAL | Uses only definitions of L01/L02 (no consumed clause, per `T04_final.md`). |
| 5.2 P05 | ISSUE | S1-S3 verified in gap file; "only if" unaffected. `P05_final.md` |
| 5.3 P06 | UNCONDITIONAL | `P06_final.md`. Caveat: the F⁻→F passage at :445 is classified FAIR_IMPLICIT_STEP by the final audit alone; the issue-checker ruling the gate requested (`P06_gate.md:76`) was not run, and an EXPOSITION_GAP ruling would make P06 ISSUE (`P06_final.md:69`). |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person |
|---|---|---|---|---|---|
| 1 | `T01_X02Tool` | (i) | T01 | Lemma 4.1 of ineq-order2024 states star-shaped ⇒ inverse anti-star-shaped; whether it needs h increasing | not yet |
| 2 | `T01_L01Consumed` | (p) → counts as (iv) (L01 ISSUE) | T01 | Repaired Lemma 2.3 (with F(0)=0 premise on "if"); never proved in Lean | not yet |
| 3 | `T02_L01Consumed` | (p) → counts as (iv) (L01 ISSUE) | T02, P03 | Lemma 2.3 "only if" direction only (InvSub ⇒ eq:sub-1x); the direction B01 says is unaffected | not yet |
| 4 | `P03_T02Consumed` | (p) → counts as (iv) (T02 ISSUE) | P03 | Thm 3.1 for n=2, θ=1/2; might be reconnectable to T02's verified n=2 case (not compared) | not yet |
| 5 | `P03_P02Consumed` | (p) → counts as (iv) (P02 ISSUE) | P03 | Prop 3.2 at n=2 for real-valued X; only the nonnegative case was verified | not yet |
| 6 | `P04_X01Tool` | (i) | P04 (clause 2) | Prop 1 of superPareto2024 in the encoded form (F<1, domain of concavity) | not yet |
| 7 | `T03_T01Consumed` | (p) → (iv) (T01 ISSUE) | none for any verdict | Clause is **refutable** (`not_T03_T01Consumed`); it is defined in Lean but absent from the registry, so T03 cannot be CONDITIONAL on it | not applicable |

Debts recorded in words: real-valued encoding (Example 2.7 outside); technical assumption `hnd` (non-degeneracy) in P04; domain `(0,∞)` of the inverted distribution; "infinite mean" := not integrable; L01 S1, S2 hand-checked only. (Readings R2, R3, R4 of concavity in P04 were checked in Lean by the counterexample review probe, `P04_issue_2_audit.md` §4.) External assertions not encoded: Theorems 4.2, 4.11, 4.15 and Thm 2.14 of Muller2024 (cited, unused by any numbered result), the Pareto/Cauchy claims at :279 (Pareto proved as by-product, Cauchy not encoded), computations in the Examples, :323 and :448. Details: `verification/report/work/external_tools.md` §5-6.

## 4. Substantive issues for the authors (in PDF order)

Suggestions are quoted from audit records and are "suggestion only"; none was used in any verification.

### 4.1 Lemma 2.3 (L01, B01), PAPER_ASSUMPTION_GAP, :130-133
- **Fails:** the lemma omits "such that F_X(0)=0" of Def 2.2 (:124). X=0 a.s. satisfies (eq:sub-1x) (at x=0 it reads 2F(0) ≤ F(0)+1) but has F_X(0)=1. The proof (:137) argues only the equivalence of subadditivity with (eq:sub-1x).
- **Evidence:** `pv_work/L01_Counterexample1.lean` (`L01_if_counterexample`, `L01_main_as_printed_false`), standard axioms only, review VALID (`L01_issue_1_audit.md`). A non-degenerate instance p·δ₀+(1-p)·Fréchet(1) is reasoning only.
- **Not affected:** the "only if" direction and the equivalence (hand-checked, not in Lean); Thm 3.1 at :201; Prop 2.5; Examples 2.4, 2.6, 2.7; Prop 5.3 (:442 prints the qualifier); Thm 4.12.
- **Recorded fix** (`L01_issue_1.md` §6): "A random variable X such that F_X(0)=0 is InvSub if and only if", mirroring :442. Does not repair Thm 2.8.
- **Needs a human:** whether a standing convention F_X(0)=0 was intended (evidence against: :354, :442, the use at :180).

### 4.2 Theorem 2.8 (T01, B05), ERROR, :171, :174, :180
- **Fails:** false as printed. A continuous star-shaped h can vanish on [0,a], so F_{h(X)}(0)>0. Instance: X with cdf x/(1+x) (InvSub, proved in Lean) and h(x)=max(x-1,0) give F_{h(X)}(0)=1/2. The subadditivity conjunct holds, so only F(0)=0 fails. It survives the fix of B01 and the refutation does not use L01.
- **Evidence:** `pv_work/T01_Counterexample1.lean` (`T01_counterexample`, `not_T01_S2_Gap`), standard axioms only, review VALID (`T01_issue_1_audit.md`). `T01_main_mod_gaps` is vacuous: do not cite it.
- **Not affected:** subadditivity half; Thm 3.1.
- **Recorded fix** (`T01_issue_1.md` §6, reasoning only): add "h(x)>0 for x>0" (or "P(h(X)≤0)=0", which does not make h increasing; see `T01_issue_1_audit.md` §6); "h nonconstant" or "increasing and convex" do not suffice.
- **Formalization side (not a paper issue):** S0 ("every function considered is increasing", :174) was ruled ENCODING_ERROR (`T01_issue_2.md`, no counterexample review); `T01_X02Tool` was encoded for increasing h only.
- **Needs a human:** ERROR vs PAPER_ASSUMPTION_GAP.

### 4.3 Theorem 3.1 (T02, B06), PAPER_ARGUMENT_GAP, :256
- **Fails:** the first inequality at :256, P(Σθᵢ Xᵢ > x) ≥ F̄(x/θₙ)+F̄(x/(1-θₙ)), is false; the stated reason ("the large parenthesis is negative") yields only a quantity at least as large as the bound, not a lower bound. At x=0 both terms equal 1, sum 2 > 1. The final bound P ≥ F̄(x) is not refuted and follows from :254 and (eq:sub-1x).
- **Evidence:** `pv_work/T02_Counterexample1.lean` (`intermediate_fails_at_zero`, `not_printedInference`, `final_of_254`), standard axioms only, review VALID (`T02_issue_1_audit.md`). `T02_main_mod_gaps` is uninformative.
- **Recorded fix** (`T02_issue_1.md` §7): the lower bound at :254 minus F̄(x) equals (1-F̄(x))(F̄(x/θₙ)+F̄(x/(1-θₙ))-F̄(x)) ≥ 0 by (eq:sub-1x); delete the claim at :256.
- **Unruled suspicions (not registered issues, no review):** :222-223 strict vs non-strict events with possible atoms (S5, S6a); :95 (θᵢ ≥ 0) vs :219 (θᵢ > 0), zero weights and n=1. The argument that real-valued InvSub laws have no atoms is gate reasoning only and does not cover Example 2.7.

### 4.4 Proposition 3.2 (P02, B02 and B03), :263, :266
- **B02, PAPER_ARGUMENT_GAP:** the proof uses √X, Var(√X) and Jensen for √, which need X ≥ 0, but :263 assumes no nonnegativity (the paper writes "nonnegative" at :150, :159, :334; :354 says nonnegativity is "not strictly necessary"). The conclusion is not refuted. Evidence: obstruction only (`issue_P02_sqrtneg.lean`: √ is not concave on ℝ), review CONFIRMED (`P02_issue_2_audit.md`). Fix (`P02_issue_2.md` §6): add "nonnegative" at :263, or use a strictly convex function integrable on ℝ such as √(1+x²) (reasoning only).
- **B03, DOMAIN_CLARIFICATION:** "If (eq:main-st) holds" can mean the given n and weights, or a property for every n and all weights; "it is enough to prove n=2" (:266) is fair under the second reading and gives no argument for n ≥ 3 under the first. Reasoning only, no Lean evidence. Rulings `P02_issue_1.md` (EXPOSITION_GAP, review NOT CONFIRMED) and `P02_issue_1_r2.md` (DOMAIN_CLARIFICATION, review CONFIRMED). Fix (`P02_issue_1_r2.md` §5): state the reading explicitly.
- **Not affected:** the n=2 part (verified for nonnegative X); Prop 3.3's use.
- **Needs a human:** intended domain; meaning of "infinite mean" for signed X.

### 4.5 Proposition 4.6 (P04, B07), PAPER_ASSUMPTION_GAP, :317
- **Fails:** the first sentence is false for a.s. constant X: for δ₀ the transform is constant, so 𝒫 ≤c F_X holds, yet δ₀ is not super-Pareto (:286, h nonconstant). Non-degeneracy is printed elsewhere (:263, :286) with no standing convention.
- **Evidence:** `pv_work/P04_Counterexample2.lean` (`not_PrintedClause1`, `not_PrintedClause2`), standard axioms only, review VALID (`P04_issue_2_audit.md`); readings R2, R3 (and R4) of concavity were also checked in Lean by the review's probe (§4 there): the δ₀ counterexample fails a clause of the first sentence of :317 under every reading. `P04.lean` verifies all clauses for non-degenerate X.
- **Fix** (`P04_issue_2.md` §7): "Let X be a non-degenerate random variable". The :320 step is a fair implicit step (`P04_issue_1.md`).
- **Needs a human:** whether Def 4.5 is tacitly limited to continuous laws (then DOMAIN_CLARIFICATION); PAPER_ASSUMPTION_GAP vs ERROR (both admissible per the reviewers); the domain on which concavity of Λ_X and 1/F̄_X is meant (:301, :306, :310) and the meaning of "increasing odds rate" (DOMAIN_CLARIFICATION, not ruled; `P04_issue_2_audit.md:69`).

### 4.6 Theorem 4.8 (T03, B09 ERROR and B10 PAPER_ARGUMENT_GAP), :332-337
- **B09:** false as printed. X=max(Z-2,0) (Z Pareto) is nonnegative super-Pareto with F_X(0)=1/2, not InvSub. X=Z+1 has F_X(0)=0 but violates subadditivity (x=y=1/4: 1-F(2)=1 > 2/3), so "positive" does not repair it. ERROR rather than ASSUMPTION_GAP because the natural repair fails (the gate and drafter had proposed ASSUMPTION_GAP).
- **B10:** :337 asserts "h(0)=0"; the cited shift invariance does not give it, and :426 says the i-sb order is not shift invariant. For X=Z the representing map is y+1.
- **Evidence:** `pv_work/T03_Counterexample1.lean`, `T03_Counterexample2.lean`, standard axioms only, reviews VALID (`T03_issue_1_audit.md`, `T03_issue_2_audit.md`). No proof session, no final audit.
- **Affected:** the claims at :107 and :331 (reasoning, `T03_issue_1.md` §5).
- **Fix** (`T03_issue_1.md` §6, `T03_issue_2.md` §6, reasoning only): replace "nonnegative" by "F_X(0)=0 and F_X(x)>0 for every x>0"; then h(0)=0 follows and the shift-invariance reference can go.

### 4.7 Lemma 4.10 (L02, B04), PAPER_ASSUMPTION_GAP, :361-364
- **Fails:** omits "such that F_X(0)=0" of Def 4.9 (:346); "if" direction false for δ₀. No printed proof (:358 "straightforward").
- **Evidence:** `pv_work/L02_Counterexample1.lean`, review VALID (`L02_issue_1_audit.md`). In `L02ModGaps.lean` S1-S3 and "only if" are verified; `L02_main_mod_gaps` is vacuous.
- **Fix:** add "such that F_X(0)=0" at :361 (`L02_issue_1.md` §6). **Caution:** an alternative recorded in `L02_issue_1_audit.md:58` (drop the qualifier from Def 4.9(1)) is not consistent paper-wide: `P05_issue_1_audit.md:56` notes that Thm 4.12 (F(0)=0 taken from the definition, `T04_final.md`) would then fail at δ₀. `BLOCKERS.md` B04 and `L02_final.md` §8 repeat the alternative without this caveat.
- **Needs a human:** whether :346 is a standing convention (then DOMAIN_CLARIFICATION).

### 4.8 Proposition 5.2 (P05, B08), PAPER_ASSUMPTION_GAP, :431
- **Fails:** omits "such that F_X(0)=0"; "if" direction false for δ₀ under both domain readings checked. :426 does not exclude it.
- **Evidence:** `pv_work/P05_Counterexample1.lean`, review VALID (`P05_issue_1_audit.md`); S1-S3 verified in `P05ModGaps.lean`; `P05_main_mod_gaps` is vacuous.
- **Fix** (`P05_issue_1.md` §6): add the qualifier, as at :442. "Only if" and its use at :448 unaffected.

### 4.9 Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by |
|---|---|---|---|
| :269 | Non-degeneracy of i.i.d. copies of InvSub X | FAIR_IMPLICIT_STEP (an InvSub point mass violates eq:sub-1x at x=c/2, θ=1/2) | `P03_issue_1.md`, `P03_final.md` |
| :320 | Concavity/convexity duality of inverse | FAIR_IMPLICIT_STEP | `P04_issue_1.md`, `P04_final.md` §6 |
| :381 | Log 0 case in Thm 4.12 | FAIR_IMPLICIT_STEP (S4z) | `T04_final.md` |
| :434, :445 | F^- to F switch; p=1 edge | FAIR_IMPLICIT_STEP | `P05_final.md`, `P06_final.md` |
| :256 | Invalid inequality | PAPER_ARGUMENT_GAP (B06) | `T02_issue_1.md` |

**Observations of the coordinator (no review behind them).** None is a finding about the paper.

| Observation | Based on |
|---|---|
| Our T04 row lists L01 and L02 (both ISSUE) in `depends_on`, yet T04 is UNCONDITIONAL. The audit shows only definitions are reused and Thm 4.12's proof cites neither lemma. | `T04_final.md:36,46`, `pv_status.py validate` warning |
| `T02_final.md` verifies the n=2 case S1-S4, so `P03_T02Consumed` (n=2, θ=1/2) might be dischargeable from it. Statement shapes were not compared. | `P03_final.md:43`, `T02_final.md:81`, compiler note Mo8 |
| Registry text for `T02_L01Consumed` said "iff" while the Lean clause is one implication; corrected in the registry during this report. | `pv_work/T02Stmt.lean:33-34` |
| Statement "ITS laws have no atoms" in T02 gate reasoning needs F(+∞)=1 and so excludes Example 2.7. | `T02_gate.md` item 4, :165 |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | :153 | "easily seen to be negative": only ≤ 0 follows (and suffices); read "non-positive" (`P01_final.md` §4) |
| 2 | :385 | "as the exponential is superadditive": literally false at a=b=0; the intended fact is that t ↦ e^t-1 is superadditive on (-∞,0] (`T04_final.md` §4; records cite :383, the phrase is on :385) |
| 3 | :174 | "As every function considered is increasing": only F_X increasing is needed (`T01_issue_2.md`) |
| 4 | :434 | F_X written where Def 5.1 (:424) uses F_X^- (`P05_final.md`) |
| 5 | :445 | same F_X vs F_X^- passage (`P06_final.md` §6) |
| 6 | :434, :445 | conventions 1/0=+∞, 1/∞=0, -Log 0=+∞, 𝒫⁻¹(1)=+∞ unstated (`P05_final.md` §6, `P06_final.md` §8) |
| 7 | :143 | "θ∈[0,1]" while Lemma 2.3 and (eq:sub-1x) use θ∈(0,1). Coordinator-compiler observation, not in any audit record |
| 8 | :137 | "for every x ≥ 0" in a proof about 1-F_X(1/x); x=0 vacuous, substitution unwritten (`L01_gate.md`) |
| 9 | :349 (also :381, :434) | -Log F_X(1/x) undefined where F_X(1/x)=0, domain unspecified (`L02_gate.md`) |

Presentational suggestions from the audits: :153 say "derivative" means a.e.; :269 optionally state InvSub laws are non-degenerate; :320 add the concavity/convexity duality sentence (`P04_issue_1.md` §6); :263-266 introduce X and state i.i.d.; :445, :434 remark on one-sided limits; :174 state the scope of Lemma 4.1 of ineq-order2024. Document-numbering slips in the records themselves (e.g. "Thm 2.6" for Thm 2.8, "Prop 4.2" for :263) are internal.

## 6. Human-check list

**Literature and citations:** worksheet items `T01_X02Tool` (Lemma 4.1 of ineq-order2024), `P04_X01Tool` (Prop 1 of superPareto2024).
**Mathematical completion (reasoning only, no Lean):** B03 reduction to n=2 and both readings; B02 truth of Prop 3.2 for signed X; L01 S1, S2 (hand-checked); B01 mixture instance; sufficiency of every recorded fix; T02 atoms and zero weights; `P02_S6` has no non-vacuity witness.
**Predecessor clauses:** `T01_L01Consumed`, `T02_L01Consumed`, `P03_T02Consumed`, `P03_P02Consumed` (§3).
**Author intent:** B01 and B04/B08 (standing convention F_X(0)=0? then DOMAIN_CLARIFICATION); B05/B09 (ERROR vs PAPER_ASSUMPTION_GAP); B07 (continuous laws only? ASSUMPTION_GAP vs ERROR; domain of concavity; "increasing odds rate"); P06 :445 F⁻→F step (classified by the final audit alone; no issue-checker ruling); B02/B03 domain and "infinite mean" for signed X; T01 S0 (ENCODING_ERROR ruling has no counterexample review).
**Experiments and unnumbered assertions:** Examples 2.4, 2.6, 2.7, 4.7, 4.13, 4.16 and their computations; Cauchy claims at :279; :323, :448 were not checked.

## 7. Limits on the formalization side (not paper issues)

- External parameters remain unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0 (`lean-toolchain`); Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json`), linked from the shared `lean-env`; Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`). So "not available in Mathlib" claims were checked against the full compiled library.
- Technical formalization assumptions: real-valued random variables only; `hnd` (non-degeneracy) in P04, gate-approved and exactly the hypothesis missing in B07; `InfiniteMean := ¬ Integrable`; domain (0,∞) for the inverted distribution.
- Scope restrictions: Example 2.7 (mass at +∞) is not encoded; Thm 3.1: the n=2 case is verified conditional on `T02_L01Consumed`, the n≥3 step has gaps S5/S6a, S10b and zero weights; `P03` consumed clauses are n=2, θ=1/2.
- Vacuous gap theorems: `T01_main_mod_gaps`, `T02_main_mod_gaps`, `L02_main_mod_gaps`, `P05_main_mod_gaps`. The drafts `T02.lean`, `P02.lean`, `L02.lean`, `P05.lean`, `T01.lean`, `T03Draft.lean`, `L01Draft.lean` contain `sorry` and have no `.olean`.
- Lean comment errata: `verification/DOC_ERRATA.md`.

## 8. Process disclosure

- Unattended run: no user decisions were available. The reviewing auditor for T03 first wrote a verdict line with a colon and reformatted it at the coordinator's request (the guard hook blocks coordinator edits to reports).
- Coordinator/records errors found by the compiler and corrected or noted: the registry described `T02_L01Consumed` as "iff" (corrected via `add-tool`); `T03_T01Consumed` is unregistered (listed in §3); B04's alternative fix lacks the Thm 4.12 caveat (stated in §4.7, `BLOCKERS.md` not rewritten); `RESUME.md`, some `PAPER_VERIFICATION.md` rows and `T01_final.md` §8 are stale in wording (full list: `verification/report/work/consistency_check.md`, 2 Major, 9 Moderate, 10 Minor).
- An independent fact check of the first draft (saved as `verification/report/work/AUTHOR_REPORT_v1.md`) found 23 problems (1 Major, 9 Moderate, 13 Minor), which have been corrected in this report and in the worksheet and file index. The Major item was a nonexistent `L01.lean` pointer in `FILES_TO_CHECK.md`.
- Permission denials: a few of the coordinator's combined shell commands were refused and re-issued as single commands; no check was run by a role other than the one the rules name.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
- `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md` (compiler's working drafts)

# Convex combinations of random variables stochastically dominate the parent for a new class of heavy tailed distributions: final report of the faithful LaTeX → Lean check (state after revision 1)

2026-10-13, summary by the coordinator, compiled from the pv-compiler notes (`verification/report/work/`). This report describes the state **after revision 1** of the manuscript. The earlier report (before the revision) is archived in `verification/report_archive/20261013-113005/` and is stale.

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 5 registered external inputs that have not been verified in Lean (`P03_T02Consumed` is registered but discharged) (a seventh Lean parameter, `T03_T01Consumed`, is refuted, unregistered, and no verdict uses it), and 7 of 12 results carry recorded issues.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).
- The source is `source/SuperParetoPaper-v12.tex` (the revised manuscript); `:N` means line N of it, **current numbering**. The audit reports, `BLOCKERS.md` and `INVENTORY.md` keep baseline (pre-revision) numbers; baseline lines up to 216 are unchanged and baseline lines from 258 on map to `old - 23` (`AUDIT.md`, "Revision mapping"; each mapped line was re-read in the current `.tex`). PDF numbers come from the shared theorem counter; `source/` contains no PDF or `.aux`, so the numbers after Prop 4.3 are inferred and unverified for the revised manuscript.
- **Fact check:** done; see §8 and `verification/report/work/factcheck.md`.

---

## 0. Summary table (English, for screenshots)

**12 numbered results: 3 verified unconditionally · 2 verified conditionally · 7 with recorded issues · 0 unfinished.**

"Verified conditionally" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain; those inputs are explicit Lean parameters, never hidden assumptions. Exceptions recorded in words: the encoding is for real-valued random variables only (Example 2.7, mass at +∞, is outside it), and "infinite mean" is encoded as "not integrable". Among the 7 recorded issues, B05 (Thm 2.8) and B09 (Thm 4.8) are Lean-checked counterexamples to a theorem as printed; B01, B04, B07, B08 are Lean-checked counterexamples to a lemma or proposition as printed (a missing hypothesis); B02, B03, B10 are argument gaps or readings. B06 (Thm 3.1) was resolved by the revision.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.3 | L01 Lemma, InvSub characterisation | Issue recorded | B01: omits F_X(0)=0 from Def 2.2; X=0 a.s. refutes the "if" direction (Lean) |
| 2.5 | P01 Prop, InvSub via hazard rate bound | Verified (unconditional) | none; "negative" at :153 should read non-positive (editorial) |
| 2.8 | T01 Thm, closure under star-shaped maps | Issue recorded | B05: false as printed, h=max(x-1,0) gives F_{h(X)}(0)=1/2 (Lean); conditions T01_X02Tool, T01_L01Consumed |
| 3.1 | T02 Thm, main dominance theorem | Verified (conditional) | T02_L01Consumed (only-if direction of Lemma 2.3); revised induction step :219-233 correct as written; B06 resolved |
| 3.2 | P02 Prop, dominance forces infinite mean | Issue recorded | B02: √X used without X≥0; B03: n=2 reduction depends on reading |
| 3.3 | P03 Prop, InvSub implies infinite mean | Verified (conditional) | T02_L01Consumed, P03_P02Consumed (P03_T02Consumed discharged by reconnection to T02) |
| 4.6 | P04 Prop, DOR via convex transform order | Issue recorded | B07: false for a.s. constant X (Lean); clause 2 conditional on P04_X01Tool |
| 4.8 | T03 Thm, super-Pareto implies InvSub | Issue recorded | B09: false as printed (Lean); B10: h(0)=0 at :314 fails |
| 4.10 | L02 Lemma, super-heavy-tailed characterisation | Issue recorded | B04: omits F_X(0)=0 from Def 4.9; "if" direction false for X=0 a.s. (Lean) |
| 4.12 | T04 Thm, super-heavy-tailed implies InvSub | Verified (unconditional) | none; Log 0 case at :358 is a fair implicit step; "exponential is superadditive" (:362) editorial |
| 5.2 | P05 Prop, super-heavy-tailed via i-sb order | Issue recorded | B08: omits F_X(0)=0; "if" direction false for X=0 a.s. (Lean) |
| 5.3 | P06 Prop, InvSub via i-sb order | Verified (unconditional) | none; F^- to F switch and p=1 edge are fair implicit steps (editorial) |

No result has every condition checked by a person: no human check has been recorded.

## 0b. What the revision changed

The manuscript was revised once (revision 1): the proof of Theorem 3.1 was rewritten (baseline :190-257 became :190-234; the induction step now bounds the complementary probability and reuses Figure 1), and the later lines moved up by 23. The statements of all numbered results are unchanged (`T02_gate.md`: `T02_main` fingerprint identical to the pre-revision snapshot). `pv_status.py followup` reports:

| No. | ID | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|---|
| 3.1 | T02 | Recorded issue (revision 1) | Verified conditionally | B06 | B06: resolved |

- **T02 (Thm 3.1): ISSUE → CONDITIONAL.** B06 (invalid inequality at baseline :256) concerned text the revision removed. The re-run gate and final audit (`T02_gate.md`, `T02_final.md`) find the revised induction step (:219-233) correct and the whole proof verified in Lean, conditional only on `T02_L01Consumed`. The two earlier unruled suspicions are closed: the atom-sensitive lines are gone from the source, and zero weights and n=1 were ruled a fair implicit step (`T02_issue_1.md`, review CONFIRMED in `T02_issue_1_audit.md`); x<0 and weight renormalisation were classed fair implicit steps by the gate and final audit, without an issue-checker ruling (`T02_gate.md` item 7, `T02_final.md` §6). Earlier B06 files are in `verification/audits/rev1/`.
- **P03 (Prop 3.3): re-checked and reconnected.** `P03_recheck.md` (RECHECK: PASS) and `P03_reconnect_r1.md` (RECONNECT AUDIT: PASS) show that the clause `P03_T02Consumed` is now proved from `T02_main` (`pv_work/P03Closed_r1.lean`, `main_closed`) and is no longer a parameter. P03 stays CONDITIONAL, now on `T02_L01Consumed` and `P03_P02Consumed`.
- **All other results were not reset and keep their verdicts** (P01, T04, P06 UNCONDITIONAL; L01, T01, P02, P04, T03, L02, P05 ISSUE) and their issues (B01-B05, B07-B10 remain open). Their locations were remapped to the current line numbers.

## 1. Overall findings

1. **Counterexamples to theorems as printed.** Theorem 2.8 (B05) and Theorem 4.8 (B09) are false as printed, with Lean-checked counterexamples. B05 and B09's first instance share one mechanism: a continuous star-shaped map can make F_{h(X)}(0)>0, which Def 2.2 excludes. B09's second instance (X=Z+1) fails subadditivity, so "positive" does not repair Thm 4.8. The same missing condition F_X(0)=0 makes Lemma 2.3 (B01), Lemma 4.10 (B04) and Proposition 5.2 (B08) false in the "if" direction (X=0 a.s.), and Prop 4.6 (B07) is false for a.s. constant X. This is not a complete list; see §4.
2. **Verified unconditionally:** Prop 2.5 (P01), Thm 4.12 (T04), Prop 5.3 (P06).
3. **Verified conditionally:** Thm 3.1 (T02), on the "only if" direction of Lemma 2.3, which Lemma 2.3's issue B01 records as not affected but which has no Lean proof in this project; and Prop 3.3 (P03), on that same clause and on the Prop 3.2 clause `P03_P02Consumed` (P02 is ISSUE and does not close it).
4. **Issue recorded, 7 results.** Lean evidence: B01, B04, B05, B07, B08, B09, B10 (counterexample or obstruction files, reviews VALID). B02 has obstruction evidence only; B03 is reasoning only.
5. **Downstream impact.** Thm 4.12 does not cite Lemma 4.10 and is unaffected. Thm 3.1 uses only the "only if" direction of Lemma 2.3. Prop 3.3 uses only n=2 and positive laws. No numbered result depends on T03 (Thm 4.8). Gap-file theorems of T01, L02, P05 are vacuous (their gap hypotheses are refutable) and are not evidence for the stopped steps.
6. Formalization-side items (ENCODING_ERROR for T01 obligation S0; encoding of `T01_X02Tool` for increasing h only) are not paper issues.
7. Scope: every statement is encoded for real-valued X; Example 2.7 (mass at +∞) is outside all verified statements.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.3 L01 | ISSUE | "If" direction false (X=0 a.s.); "only if" and the subadditivity equivalence hand-checked only, not in Lean. `L01_gate.md`, `L01_issue_1_audit.md` |
| 2.5 P01 | UNCONDITIONAL | Derivative step rendered in integrated (Tonelli) form, faithful per the audit; classed by the final audit alone. `P01_final.md` |
| 2.8 T01 | ISSUE | F(0)=0 half of the conclusion fails (B05). Steps S1, S3-S6 verified in the gap file, but the gap theorem is vacuous (S0, S2 refutable); `T01_main_mod_gaps` must not be cited. `T01_final.md`, `T01_issue_1_audit.md` |
| 3.1 T02 | CONDITIONAL | Full proof (weights θᵢ ≥ 0, all real x, real-valued X) verified in `T02_main` (`pv_work/T02.lean:611`) on `T02_L01Consumed`. Zero weights, n=1, x<0, normalisation: fair implicit steps. `T02_final.md`, `T02_issue_1.md` |
| 3.2 P02 | ISSUE | n=2 argument verified for nonnegative X only; B02 and B03. `P02_final.md` |
| 3.3 P03 | CONDITIONAL | Non-degeneracy at :246 is a fair implicit step; `P03_T02Consumed` discharged through `main_closed`. `P03_final.md`, `P03_recheck.md`, `P03_reconnect_r1.md` |
| 4.6 P04 | ISSUE | All clauses verified for non-degenerate X (the super-Pareto parenthetical conditional on `P04_X01Tool`); :297 step fair implicit. `P04_final.md` |
| 4.8 T03 | ISSUE | No proof session (refutable); no final audit. `T03_issue_1_audit.md`, `T03_issue_2_audit.md` |
| 4.10 L02 | ISSUE | S1-S3 and "only if" verified in gap file. `L02_final.md` |
| 4.12 T04 | UNCONDITIONAL | Uses only definitions of L01/L02 (no consumed clause, per `T04_final.md`). |
| 5.2 P05 | ISSUE | S1-S3 verified in gap file; "only if" unaffected. `P05_final.md` |
| 5.3 P06 | UNCONDITIONAL | `P06_final.md`. Caveat: the F⁻→F passage at :422 is classified FAIR_IMPLICIT_STEP by the final audit alone; the issue-checker ruling the gate requested (`P06_gate.md`, item 7.1) was not run, and an EXPOSITION_GAP ruling would make P06 ISSUE (`P06_final.md` §6). The same holds for P05's identical step and for P01's a.e. derivative step. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person |
|---|---|---|---|---|---|
| 1 | `T01_X02Tool` | (i) | T01 | Lemma 4.1 of ineq-order2024 states star-shaped ⇒ inverse anti-star-shaped; whether it needs h increasing | not yet |
| 2 | `T01_L01Consumed` | (p) → counts as (iv) (L01 ISSUE) | T01 | Repaired Lemma 2.3 (with F(0)=0 premise on "if"); never proved in Lean | not yet |
| 3 | `T02_L01Consumed` | (p) → counts as (iv) (L01 ISSUE) | T02, P03 | Lemma 2.3 "only if" direction only (InvSub ⇒ eq:sub-1x); the direction B01 says is unaffected; the sole condition of T02 | not yet |
| 4 | `P03_P02Consumed` | (p) → counts as (iv) (P02 ISSUE) | P03 | Prop 3.2 at n=2 for real-valued X; only the nonnegative case was verified | not yet |
| 5 | `P04_X01Tool` | (i) | P04 (clause 2) | Prop 1 of superPareto2024 in the encoded form (F<1, domain of concavity) | not yet |
| 6 | `T03_T01Consumed` | (p) → (iv) (T01 ISSUE) | none for any verdict | Clause is **refutable** (`not_T03_T01Consumed`); defined in Lean but absent from the registry, so T03 cannot be CONDITIONAL on it | not applicable |

Discharged by revision 1: `P03_T02Consumed` (no longer a parameter of any result; proved from `T02_main` in `pv_work/P03Closed_r1.lean`).

Registered parameters: 5 conditions of results (rows 1-5), plus the discharged `P03_T02Consumed`, which makes 6 in the registry; row 6 is unregistered. (`pv_status.py tools` lists the registered six.)

Debts recorded in words: real-valued encoding (Example 2.7 outside); technical assumption `hnd` (non-degeneracy) in P04; domain `(0,∞)` of the inverted distribution; "infinite mean" := not integrable; L01 S1, S2 hand-checked only (this is what stands behind `T01_L01Consumed` and `T02_L01Consumed`). External assertions not encoded: Theorems 4.2, 4.11, 4.15 and Thm 2.14 of Muller2024 (cited, unused by any numbered result), the Pareto/Cauchy claims at :256 (Pareto proved as by-product, Cauchy not encoded), computations in the Examples, :300 and :425. Details: `verification/report/work/external_tools.md` §6-7.

## 4. Substantive issues for the authors (in PDF order)

Suggestions are quoted from audit records and are "suggestion only"; none was used in any verification.

### 4.1 Lemma 2.3 (L01, B01), PAPER_ASSUMPTION_GAP, :130-133
- **Fails:** the lemma omits "such that F_X(0)=0" of Def 2.2 (:124). X=0 a.s. satisfies (eq:sub-1x) (at x=0 it reads 2F(0) ≤ F(0)+1) but has F_X(0)=1. The proof (:137) argues only the equivalence of subadditivity with (eq:sub-1x).
- **Evidence:** `pv_work/L01_Counterexample1.lean` (`L01_if_counterexample`, `L01_main_as_printed_false`), standard axioms only, review VALID (`L01_issue_1_audit.md`). A non-degenerate instance p·δ₀+(1-p)·Fréchet(1) is reasoning only.
- **Not affected:** the "only if" direction and the equivalence (hand-checked, not in Lean); Thm 3.1 (uses only "only if", at :201 and :231-233); Prop 2.5; Examples 2.4, 2.6, 2.7; Prop 5.3 (:419 prints the qualifier); Thm 4.12.
- **Affected:** Thm 2.8 consumed the "if" direction at :180 (confirmed as B05, §4.2).
- **Recorded fix** (`L01_issue_1.md` §6): "A random variable X such that F_X(0)=0 is InvSub if and only if", mirroring :419. Does not repair Thm 2.8.
- **Needs a human:** whether a standing convention F_X(0)=0 was intended (evidence against: :331, :419, the use at :180).

### 4.2 Theorem 2.8 (T01, B05), ERROR, :171, :174, :180
- **Fails:** false as printed. A continuous star-shaped h can vanish on [0,a], so F_{h(X)}(0)>0. Instance: X with cdf x/(1+x) (InvSub, proved in Lean) and h(x)=max(x-1,0) give F_{h(X)}(0)=1/2. The subadditivity conjunct holds, so only F(0)=0 fails. It survives the fix of B01 and the refutation does not use L01.
- **Evidence:** `pv_work/T01_Counterexample1.lean` (`T01_counterexample`, `not_T01_S2_Gap`), standard axioms only, review VALID (`T01_issue_1_audit.md`). `T01_main_mod_gaps` is vacuous: do not cite it.
- **Not affected:** subadditivity half; Thm 3.1.
- **Recorded fix** (`T01_issue_1.md` §6; sufficiency re-checked by reasoning only in `T01_issue_1_audit.md` §6): add "h(x)>0 for x>0" (or "P(h(X)≤0)=0", which removes S2 but not S0); "h nonconstant" or "increasing and convex" do not suffice.
- **Formalization side (not a paper issue):** S0 ("every function considered is increasing", :174) was ruled ENCODING_ERROR (`T01_issue_2.md`, no counterexample review); `T01_X02Tool` was encoded for increasing h only.
- **Needs a human:** ERROR vs PAPER_ASSUMPTION_GAP.

### 4.3 Theorem 3.1 (T02): no open issue after revision 1
B06 (PAPER_ARGUMENT_GAP at baseline :256) is resolved: the step no longer exists in the revised proof (:190-234). Verdict CONDITIONAL on `T02_L01Consumed`; see §0b. Zero weights and n=1 were ruled FAIR_IMPLICIT_STEP (`T02_issue_1.md`, review CONFIRMED); x<0 and the normalisation of the induction weights θᵢ/(1-θₙ) were classed fair implicit steps by the gate and final audit only, with no issue-checker ruling (`T02_gate.md` item 7, `T02_final.md` §6). The ruling records a stricter fallback: if an unwritten case split is never "implicit", the class would be a minor EXPOSITION_GAP (the reviewer called this "defensible but not required"). Optional fix from `T02_issue_1.md` §8 (sufficiency checked in `T02_issue_1_audit.md`): add at :191 "Terms with θᵢ=0 can be discarded, so we may assume all weights are strictly positive; the case of a single positive weight is trivial (equality in distribution)."

### 4.4 Proposition 3.2 (P02, B02 and B03), :240, :243
- **B02, PAPER_ARGUMENT_GAP:** the proof uses √X, Var(√X) and Jensen for √, which need X ≥ 0, but :240 assumes no nonnegativity (the paper writes "nonnegative" at :150, :159, :311; :331 says nonnegativity is "not strictly necessary"). The conclusion is not refuted. Evidence: obstruction only (`pv_work/probes/issue/P02/issue_P02_sqrtneg.lean`: √ is not concave on ℝ), review CONFIRMED (`P02_issue_2_audit.md`). Fix (`P02_issue_2.md` §6): add "nonnegative" at :240, or use a strictly convex function integrable on ℝ such as √(1+x²) (reasoning only) with "X does not have a finite mean".
- **B03, DOMAIN_CLARIFICATION:** "If (eq:main-st) holds" can mean the given n and weights, or a property for every n and all weights; "it is enough to prove n=2" (:243) is fair under the second reading and gives no argument for n ≥ 3 under the first. Reasoning only, no Lean evidence. Rulings `P02_issue_1.md` (EXPOSITION_GAP, review NOT CONFIRMED) and `P02_issue_1_r2.md` (DOMAIN_CLARIFICATION, review CONFIRMED in `P02_issue_1_r2_audit.md`). Fix (`P02_issue_1_r2.md` §5): state the reading explicitly, either "We give the proof for n=2; the general case is identical, ..." under the fixed-instance reading, or state that (eq:main-st) holds for all n and weights.
- **Not affected:** the n=2 part (verified for nonnegative X); Prop 3.3's own use.
- **Needs a human:** intended domain; meaning of "infinite mean" for signed X.

### 4.5 Proposition 4.6 (P04, B07), PAPER_ASSUMPTION_GAP, :294
- **Fails:** the first sentence is false for a.s. constant X: for δ₀ the transform is constant, so 𝒫 ≤c F_X holds, yet δ₀ is not super-Pareto (:263, h nonconstant). Non-degeneracy is printed elsewhere (:240, :263) with no standing convention.
- **Evidence:** `pv_work/P04_Counterexample2.lean` (`not_PrintedClause1`, `not_PrintedClause2`), standard axioms only, review VALID (`P04_issue_2_audit.md`); readings R2, R3 (and R4) of concavity were also checked in Lean by the review's probe (§4 there): clause 2 fails under every reading. `P04.lean` verifies all clauses for non-degenerate X.
- **Fix** (`P04_issue_2.md` §7): "Let X be a non-degenerate random variable". The :297 step is a fair implicit step (`P04_issue_1.md`).
- **Needs a human:** whether Def 4.5 is tacitly limited to continuous laws (then DOMAIN_CLARIFICATION); PAPER_ASSUMPTION_GAP vs ERROR (both admissible per the reviewers); the domain on which concavity of Λ_X and 1/F̄_X is meant.

### 4.6 Theorem 4.8 (T03, B09 ERROR and B10 PAPER_ARGUMENT_GAP), :309-315
- **B09:** false as printed. X=max(Z-2,0) (Z Pareto) is nonnegative super-Pareto with F_X(0)=1/2, not InvSub. X=Z+1 has F_X(0)=0 but violates subadditivity (x=y=1/4: 1-F(2)=1 > 1/3+1/3), so "positive" does not repair it. ERROR rather than ASSUMPTION_GAP because the natural repair fails (the gate and drafter had proposed ASSUMPTION_GAP).
- **B10:** :314 asserts "h(0)=0"; the cited shift invariance does not give it, and :403 says the i-sb order is not shift invariant. For X=Z the representing map is y+1.
- **Evidence:** `pv_work/T03_Counterexample1.lean`, `T03_Counterexample2.lean`, standard axioms only, reviews VALID (`T03_issue_1_audit.md`, `T03_issue_2_audit.md`). No proof session, no final audit.
- **Affected:** the claim at :107 (reasoning, `T03_issue_1.md` §5).
- **Fix** (`T03_issue_1.md` §6, `T03_issue_2.md` §6, reasoning only): replace "nonnegative" by "F_X(0)=0 and F_X(x)>0 for every x>0"; then h(0)=0 follows and the shift-invariance reference can go.

### 4.7 Lemma 4.10 (L02, B04), PAPER_ASSUMPTION_GAP, :338-342
- **Fails:** omits "such that F_X(0)=0" of Def 4.9 (:323); "if" direction false for δ₀. No printed proof (:335 "straightforward").
- **Evidence:** `pv_work/L02_Counterexample1.lean`, review VALID (`L02_issue_1_audit.md`). In `L02ModGaps.lean` S1-S3 and "only if" are verified; `L02_main_mod_gaps` is vacuous.
- **Fix:** add "such that F_X(0)=0" at :338 (`L02_issue_1.md` §6). **Caution:** an alternative recorded in `L02_issue_1_audit.md` §5 (drop the qualifier from Def 4.9(1)) is not consistent paper-wide: `P05_issue_1_audit.md` §2 and §5 note that Thm 4.12 (F(0)=0 taken from the definition, `T04_final.md` §4) would then fail at δ₀. `L02_final.md` §8 repeats the alternative without this caveat; `BLOCKERS.md` B04 was corrected at report time (§8).
- **Needs a human:** whether :323 is a standing convention (then DOMAIN_CLARIFICATION).

### 4.8 Proposition 5.2 (P05, B08), PAPER_ASSUMPTION_GAP, :408
- **Fails:** omits "such that F_X(0)=0"; "if" direction false for δ₀ under both domain readings checked. :403 does not exclude it.
- **Evidence:** `pv_work/P05_Counterexample1.lean`, review VALID (`P05_issue_1_audit.md`); S1-S3 verified in `P05ModGaps.lean`; `P05_main_mod_gaps` is vacuous.
- **Fix** (`P05_issue_1.md` §6, `P05_final.md` §8): add the qualifier, as at :419. "Only if" and its use at :425 unaffected.

### 4.9 Boundary cases ruled by a gate or an audit, and observations of the coordinator and compiler

**Ruled by a gate or an audit (findings).**

| Source location | Question | Ruling | Ruled by |
|---|---|---|---|
| :246 | Non-degeneracy of i.i.d. copies of InvSub X | FAIR_IMPLICIT_STEP (an InvSub point mass violates eq:sub-1x at x=c/2, θ=1/2) | `P03_issue_1.md`, `P03_final.md` |
| :297 | Concavity/convexity duality of inverse | FAIR_IMPLICIT_STEP | `P04_issue_1.md`, `P04_final.md` §6 |
| :358 | Log 0 case in Thm 4.12 | FAIR_IMPLICIT_STEP (S4z) | `T04_final.md` |
| :411, :422 | F^- to F switch; p=1 edge | FAIR_IMPLICIT_STEP (classified by the final audit alone) | `P05_final.md`, `P06_final.md` |
| :191, :219 | Zero weights, n=1 (Thm 3.1) | FAIR_IMPLICIT_STEP (fallback: minor EXPOSITION_GAP) | `T02_issue_1.md`, `T02_issue_1_audit.md` |
| :174 | S0 "every function considered is increasing" | ENCODING_ERROR (formalization side; no counterexample review) | `T01_issue_2.md` |

**Observations of the coordinator or compiler (no review behind them).** None is a finding about the paper.

| Observation | Based on |
|---|---|
| Examples 4.13 (:369) and 4.16 (:393) as printed do not appear to define cdfs (the printed functions exceed 1: about 2.31 at x=1 for a=0.5 in 4.13; 1+e^{-1} at x=1 in 4.16). **Compiler only, unaudited.** Unnumbered examples; no verdict depends on them. | compiler arithmetic; `INVENTORY.md` H12, H14 ("not checked") |
| T04 lists L01 and L02 (both ISSUE) in `depends_on`, yet is UNCONDITIONAL. The audit shows only definitions are reused and Thm 4.12's proof cites neither lemma. | `T04_final.md`, consistency check Mo5 |
| P03's step S3 proves X>0 a.s. for every InvSub X, so `P03_P02Consumed` could in principle be restated with a nonnegativity premise and reconnected to the verified `P02_S6`; not decided, not done. | `P03_final.md` §4 |
| "ITS laws have no atoms" in the earlier T02 gate reasoning needs F(+∞)=1 and so excludes Example 2.7; the atom lines are gone after revision 1. | `T02_gate.md` item 4, :165 |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | :153 | "easily seen to be negative": only ≤ 0 follows (and suffices); read "non-positive" (`P01_final.md` §4) |
| 2 | :362 | "as the exponential is superadditive": literally false at a=b=0; the intended fact is that t ↦ e^t-1 is superadditive on (-∞,0] (`T04_final.md` §4; the displayed inequality is at :359-360) |
| 3 | :174 | "As every function considered is increasing": only F_X increasing is needed (`T01_issue_2.md`) |
| 4 | :411 | F_X written where Def 5.1 (:401) uses F_X^- (`P05_final.md`) |
| 5 | :422 | same F_X vs F_X^- passage (`P06_final.md` §6) |
| 6 | :411, :422 | conventions 1/0=+∞, 1/∞=0, -Log 0=+∞, 𝒫⁻¹(1)=+∞ unstated (`P05_final.md` §6, `P06_final.md` §6) |
| 7 | :143 | "θ∈[0,1]" while Lemma 2.3 and (eq:sub-1x) use θ∈(0,1). **Compiler only, unaudited.** |
| 8 | :137 | "for every x ≥ 0" in a proof about 1-F_X(1/x); x=0 vacuous, substitution unwritten (`L01_gate.md` item 7) |
| 9 | :326, :335 (also :358, :411) | -Log F_X(1/x) undefined where F_X(1/x)=0, domain unspecified (`L02_gate.md` item 7.2; unruled, gate preliminary DOMAIN_CLARIFICATION / minor EXPOSITION_GAP; also a question of author intent, §6) |
| 10 | :369 (Ex 4.13) | printed function exceeds 1, not a cdf. **Compiler only, unaudited.** |
| 11 | :393 (Ex 4.16) | printed V exceeds 1, not a cdf. **Compiler only, unaudited.** |

8 items come from audit records; items 7, 10, 11 are compiler only.

Presentational suggestions from the audits: :153 say "derivative" means a.e. (`P01_final.md` §4); :246 optionally state that InvSub laws are non-degenerate (`P03_issue_1.md` §7); :297 add the concavity/convexity duality sentence (`P04_issue_1.md` §6); :240, :243 introduce X and state i.i.d. (`P02_gate.md` item 1); :411, :422 remark on one-sided limits (`P05_final.md`, `P06_final.md` §6); :174 state the scope of Lemma 4.1 of ineq-order2024 (`T01_issue_2.md`); :191, :217, :219 the zero-weight sentence of §4.3 and, optionally, that x<0 is immediate and that the induction hypothesis is applied to normalised weights θᵢ/(1-θₙ) (`T02_gate.md` item 7, `T02_final.md` §6); (coordinator observation, no audit suggests it: the Log 0 = -∞ convention used at :358 is unstated; it rests on `T04_gate.md` items 5, 7.1 and `T04_final.md` §4, where the branch is dead code). Document-numbering slips in the records themselves (e.g. "Thm 2.6" for Thm 2.8) are internal.

## 6. Human-check list

**Literature and citations:** worksheet items `T01_X02Tool` (Lemma 4.1 of ineq-order2024), `P04_X01Tool` (Prop 1 of superPareto2024).
**Mathematical completion (reasoning only, no Lean):** B03 reduction to n=2 and both readings; B02 truth of Prop 3.2 for signed X; L01 S1, S2 (hand-checked; this is what stands behind `T01_L01Consumed` and `T02_L01Consumed`); B01, B04, B08 non-degenerate mixture instances; sufficiency of every recorded fix (B05, B09, B10); `P02_S6` has no non-vacuity witness.
**Predecessor clauses:** `T01_L01Consumed`, `T02_L01Consumed`, `P03_P02Consumed` (§3); `T03_T01Consumed` (refutable; confirm T03 stays ISSUE).
**Author intent:** B01 and B04/B08 (standing convention F_X(0)=0? then DOMAIN_CLARIFICATION; the alternative reading conflicts with Thm 4.12); B05/B09 (ERROR vs PAPER_ASSUMPTION_GAP; B05 also asks whether an unstated restriction h>0 on (0,∞) was intended, which :314 contradicts); B07 (continuous laws only? ASSUMPTION_GAP vs ERROR; domain of concavity); B02/B03 domain and "infinite mean" for signed X; T02 (whether the zero-weight reduction is regarded as implicit or the sentence of §4.3 is wanted); T01 S0 (ENCODING_ERROR ruling has no counterexample review).
**Classifications by the final auditor without a separate issue-checker ruling:** P06 S3 and P05 S3 (F⁻→F), P01 a.e. derivative step. The UNCONDITIONAL verdicts of P06 and P01 rest on these classifications (`P06_final.md` §6).
**Experiments and unnumbered assertions:** Examples 2.4, 2.6, 2.7, 4.7, 4.13, 4.16 and their computations (4.13 and 4.16 appear not to define cdfs as printed; ask the authors for the intended functions); Cauchy claims at :256; :300 and :425 were not checked.
**Scope:** all statements are for real-valued X; Example 2.7 is not encoded. PDF numbering after Prop 4.3 is inferred and unverified.

## 7. Limits on the formalization side (not paper issues)

- External parameters remain unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0 (`lean-toolchain`); Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json`), linked from the shared `lean-env`; **mathlib modules compiled: 6305 of 6305** (`scripts/pv_lean.sh packages`). So "not available in Mathlib" claims for project-defined notions could be checked against the full compiled library; note however that for the two (i) parameters `T01_X02Tool` and `P04_X01Tool` no `#check` evidence is recorded (the gates call them research lemmas, "no search needed").
- Technical formalization assumptions: real-valued random variables only; `hnd` (non-degeneracy) in P04, gate-approved and exactly the hypothesis missing in B07; `InfiniteMean := ¬ Integrable`; domain (0,∞) for the inverted distribution.
- Scope restrictions: Example 2.7 (mass at +∞) is not encoded; Thm 3.1 is verified for θᵢ ≥ 0 as printed at :95, for real-valued X; `P03` consumed clauses are n=2, θ=1/2.
- Vacuous gap theorems: `T01_main_mod_gaps`, `L02_main_mod_gaps`, `P05_main_mod_gaps` (refutable gap hypotheses). `P02_main_mod_gaps` carries gap hypotheses `P02_S1_Gap`, `P02_TwoCase_Gap`. The drafts `T01.lean`, `P02.lean`, `L02.lean`, `P05.lean`, `T03Draft.lean`, `L01Draft.lean` contain `sorry` and have no `.olean`. `pv_work/T02ModGaps.lean` is superseded by `T02.lean` (no gap hypothesis remains for T02) but is still in `pv_work/`; do not cite it.
- Lean comment errata: `verification/DOC_ERRATA.md` (three entries, including the T02 S4 docstring).

## 8. Process disclosure

- Unattended run: no user decisions were available.
- An independent fact check of the first draft found 17 problems (1 Major, 3 Moderate, 13 Minor). The Major and Moderate items were corrected; the Minor items are in `verification/report/work/factcheck.md` and were not all individually applied. The first draft is `verification/report/work/AUTHOR_REPORT_v1.md`.
- Corrected by the coordinator at report time (after the compiler's consistency check): `BLOCKERS.md` B04 now carries the missing caveat that the alternative fix "drop the qualifier from Def 4.9" would make Thm 4.12 (UNCONDITIONAL) false; the stale body of `BLOCKERS.md` B06 (text about the removed step at baseline :256 and evidence pointers) was corrected to mark it historical.
- **Record-level inconsistencies found by the compiler and NOT corrected** (full list: `verification/report/work/consistency_check.md`, 1 Major, 13 Moderate, 15 Minor before the corrections above):
  - Registry prose for `T02_L01Consumed` (consumers "S3, S4, pos_step for S10a/S11"; S10a and S11 no longer exist; `source_loc` omits the second use at :231-233) and for `P03_T02Consumed` (human check text still says "T02 is ISSUE (B06)") in `EXTERNAL_TOOLS.md` and `RESULTS.json` is stale.
  - `RESUME.md` has stale lines (still says B06 is "marked RECHECK", P03 is conditional on `P03_T02Consumed`, to re-run T02, results "not started", and points to the archived report files).
  - `upstream_issues` is empty for T02 and absent for P03 in `RESULTS.json` although their conditions come from results with issues (verdicts are right; the tracking field is incomplete).
  - T04 `depends_on` lists L01 and L02 without a condition or upstream issue (the audit supports UNCONDITIONAL; see §4.9).
  - `PAPER_VERIFICATION.md` rows for P04 and T04 carry only the title, and two of its sections are empty tables; `RESULTS.json` `summary_en` and `PAPER_VERIFICATION.md` still cite baseline line numbers for several results; several `evidence` fields are incomplete (e.g. T02 omits the zero-weights ruling).
  - `T03_T01Consumed` is defined in Lean but not registered in `RESULTS.json` or `EXTERNAL_TOOLS.md` (listed in §3 of this report).
  - `EXTERNAL_TOOLS.md` candidate (X05-X19) and debt tables are stale or empty; `T01_final.md` §8 still calls S0 a source claim with "ruling pending".
  - The revision brief file (REVISION_BRIEF.md) does not exist; the ID mapping used is the "Revision mapping" section of `AUDIT.md`.
  - `source/` contains no PDF or `.aux`, so the PDF numbering after Prop 4.3 is inferred from the shared counter and is unverified for the revised manuscript.
- Compiler-only observations (Examples 4.13 and 4.16, θ∈[0,1] at :143) are marked as such and are not audited findings.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`, `verification/audits/rev1/` (pre-revision T02 files)
- `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md` (compiler's working drafts)
- `verification/report/work/factcheck.md` (independent fact-check report); `verification/report/work/AUTHOR_REPORT_v1.md` (first draft)
- `verification/report_archive/20261013-113005/` (stale pre-revision report, for comparison only)

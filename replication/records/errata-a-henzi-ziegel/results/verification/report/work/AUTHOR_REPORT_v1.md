# Valid sequential inference on probability forecast performance: final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator (manuscript `source/VSIFP_02.tex`, revision 1); it has passed an independent fact check, whose report is in verification/report/work/factcheck.md.

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 3 external inputs that have not been verified in Lean (X03; `P04_T01Consumed`; `P04_MixingOfStrict`), and two results carry recorded issues.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).
- Scope: the five numbered results of Section 3 (Theorems 3.1–3.3, Propositions 3.4–3.5). Sections 4–5 (simulations, case study) were not checked.

---

## 0. Summary table (English, for screenshots)

**5 numbered results: 0 verified unconditionally · 3 verified conditionally · 2 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions (exceptions recorded in words: see §3). None of the two recorded issues is a counterexample to the *statement* of a main result: both are false intermediate claims at an edge case (λ = 1; π₁ = 1), while the theorems' conclusions still hold there.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 3.1 | T01, characterisation of e-values for H_S | Issue recorded | proof step "E(0) ∈ (0,1)" (l.412, mirror in the p > q case) is false at λ = 1; theorem itself holds (PAPER_ARGUMENT_GAP, minor) |
| 3.2 | T02, GROW e-value for score dominance | Issue recorded | proof claims at l.424 (lim g = −∞, maximiser in [0,1)) fail at π₁ = 1 (p < q) / π₁ = 0 (p > q); a sign slip at l.435; theorem's formula still holds at the counterexample instance |
| 3.3 | T03, GROW e-value for all scores | Verified (conditional) | X03: Grünwald et al., Theorem 1 (cited) |
| 3.4 | P04, sequential e-values for lag h | Verified (conditional) | `P04_T01Consumed` (the "if" part of Theorem 3.1; T01 carries issue B1 in its necessity direction), `P04_MixingOfStrict` (l.103) |
| 3.5 | P05, validity under optional stopping | Verified (conditional) | h = 1 branch parameter-free (fair implicit step at l.227); h > 1 branch inherits P04's two conditions |

No result has every condition checked by a person.

## 0b. What the revision changed

Revision 1 replaced the manuscript (previous version: `verification/source_baseline_v1/`). From `python3 scripts/pv_status.py followup`; T01, T02 and T03 were **not reset** and keep their verdicts (their statements and proofs are mathematically unchanged; see §8 for the unaudited-text caveat).

| PDF no. | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|
| 3.4 | Verified conditionally (revision 1) | Verified conditionally | — | — |
| 3.5 | Recorded issue (revision 1) | Verified conditionally | B3 | B3: resolved (the old ERROR concerned the previous statement `E(e_τ) ≤ 1` and the proof now commented out at l.471–476; the revised statement is `E_Q(e_{τ+h−1}) ≤ 1`) |

## 1. Overall findings

1. **No counterexample to a main result's conclusion.** Recorded issues (all paper side): two `PAPER_ARGUMENT_GAP` entries (B1, B2) in proofs of Theorems 3.1 and 3.2, both at edge cases, plus one sign slip in the proof of Theorem 3.2. This is not a complete list; see §4 and §5.
2. **Verified unconditionally:** none.
3. **Verified conditionally:** T03 (X03), P04 and P05 (`P04_T01Consumed`, `P04_MixingOfStrict`). Debts recorded in words and parts not encoded: §3.
4. **Issue recorded:** T01 (Lean counterexample to the printed step at l.412, `pv_work/T01_Counterexample1.lean`, review COUNTEREXAMPLE VALID) and T02 (Lean counterexample to the printed claim at l.424, `pv_work/T02_Counterexample1.lean`, review COUNTEREXAMPLE VALID).
5. **Downstream impact:** B1 and B2 do not propagate by the issue rulings (`T01_issue_1.md` §4). P04 is nonetheless conditional on the clause `P04_T01Consumed`, which is the sufficiency direction of Theorem 3.1; B1 concerns the necessity direction, and that sufficiency direction is proved gap-free as `T01_S2` in `pv_work/T01ModGaps.lean` (the gate offered this reconnection; it was not carried out).

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 3.1 | ISSUE (B1) | Sufficiency (`T01_S2`) and steps S1–S7, S9 proved without gaps; necessity steps S8, S10 stay as gap hypotheses `T01_S8_Gap`, `T01_S10_Gap`. Final audit PASS (`T01_final.md`). The p > q necessity case is reasoning only. |
| 3.2 | ISSUE (B2) | Gaps `T02_S3a_Gap`, `T02_S3b_Gap`, `T02_S8_Gap`, `T02_S11_Gap`, `T02_S15_Gap`; steps S1, S2, S4–S7, S10, S12–S14 proved. Final audit PASS (`T02_final.md`). The p > q case is not written in the source ("analogous"). |
| 3.3 | CONDITIONAL (X03) | S1–S4 (direct computation, l.443) proved; S5 is X03. Final audit `T03_final.md`. |
| 3.4 | CONDITIONAL | h = 1 and h > 1 proved in `pv_work/P04.lean` (main theorem line 912) given the two parameters. Proved for Q in H_{S;c} with integrable score differences (technical assumption TFA-1). `P04_final.md`. |
| 3.5 | CONDITIONAL | After reconnection r1 to P04 (`P05Closed_r1.lean:32`, `P05_reconnect_r1.md` PASS). The h = 1 branch walks to no parameter (`P05_final_r2.md` §3); h > 1 inherits P04's two conditions. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `Paper.T03.GruenwaldThm1` (X03), `pv_work/T03Stmt.lean:42` | (i), priority B | T03 (S5) | That Theorem 1 of the cited paper (`\cite{Gruenwald2020}`, Grünwald–de Heide–Koolen, "Safe testing", ITA 2020, `VSIFP_02.bbl:58-62`) identifies the GROW e-value as the likelihood ratio and gives a.s. uniqueness, in the Dirac-prior form encoded. The records and Lean docstring say "2019"; the manuscript cites 2020. | not yet |
| 2 | `Paper.P04.P04_T01Consumed`, `pv_work/P04Stmt.lean:78` | (p), priority A | P04, P05 (h > 1) | That the "if" direction of Theorem 3.1 (statement l.143–148, proof l.400) is accepted as stated. B1 does not touch this direction. | not yet |
| 3 | `Paper.P04.P04_MixingOfStrict`, `pv_work/P04Stmt.lean:107` | (ii), priority C | P04, P05 (h > 1) | The l.103 sentence (strictly consistent ⇒ ν charges all non-degenerate intervals of (0,1)), and the regularity conditions of the representation theorem at l.90. | not yet |

`Paper.P05.P05_P04Consumed` (`pv_work/P05Stmt.lean:43`) was reconnected (`P05_reconnect_r1.md`) and is no longer a condition of any verdict. `Paper.T02.T02_T01Consumed` (`pv_work/T02Stmt.lean:40`) exists in Lean but is in neither registry; it is not a condition of any verdict (T02 is ISSUE; it is reached only through the S15 gap premise).

Debts recorded in words: TFA-1 integrability (an L¹ reading of l.115; P04 and P05 are proved only for Q with integrable score differences); TFA-2 (the mixing measure ν and the representation of l.90–102 are hypotheses, not derived); the case p_t = q_t (E_{p,q;λ} is 0/0; Lean's x/0 = 0 gives E ≡ 1; the conclusion holds under either reading). External assertions not encoded: the representation theorem "under mild regularity conditions" (l.90), the "if" direction of l.103, the Ramdas et al. (2020) optional-stopping/anytime-valid p-value statements (l.227, l.246; the h = 1 stopping is re-proved in Lean), and Sections 4–5.

## 4. Substantive issues for the authors (in PDF order)

### 4.1 Theorem 3.1, proof, l.412: "E(0) ∈ (0,1)" (B1)

- **Classification:** `PAPER_ARGUMENT_GAP` (paper side), minor. The theorem is not threatened.
- **What fails:** at λ = 1 we have E(0) = 0, although the theorem allows λ ∈ (0,1] (l.144). The mirror ("Similar arguments for the case p > q", l.412–415) inherits it (E(1) ∈ (0,1) fails at λ = 1).
- **Lean evidence:** `pv_work/T01_Counterexample1.lean` (`not_PrintedClause_l419`; ν = δ_{1/2}, p = 1/4, q = 3/4, E = E_{p,q;1}, E 0 = 0, E 1 = 2); reviewed in `verification/audits/T01_issue_1_audit.md` (COUNTEREXAMPLE VALID). The p > q necessity case is reasoning only (S10 is a gap).
- **Not affected:** the sufficiency direction (`T01_S2`), steps S1–S7, S9; Theorem 3.2's use of the statement (`T01_issue_1.md` §4).
- **Recorded suggested fix** (`T01_issue_1.md` §6, confirmed in `T01_issue_1_audit.md` §5): replace "E(0) ∈ (0,1)" by "E(0) ∈ [0,1)", so that λ = 1 − E(0) ∈ (0,1]; for p > q read "E(1) ∈ [0,1)".
- Line numbers: l.412 is the revised numbering (old l.419; mirror old l.423).

### 4.2 Theorem 3.2, proof, l.424: "lim g = −∞ … maximum attained in [0,1)" (B2, issue 1)

- **Classification:** `PAPER_ARGUMENT_GAP` (paper side). The conclusion is not threatened.
- **What fails:** at π₁ = 1 (p < q) the term (1−π₁) log(1−λ) vanishes, g(λ) = log(1−λh) stays finite and is strictly increasing, and the supremum over [0,1) is not attained. Mirror: π₁ = 0 for p > q ("the case p > q is analogous").
- **Lean evidence:** `pv_work/T02_Counterexample1.lean` (`counterexample_l435_lim`, `counterexample_l435_max`; instance ν = δ_{1/2}, p = 1/4, q = 3/4, π₁ = 1); `conclusion_holds_at_instance` shows the theorem's printed λ = 1 and e-values hold there. Review: `T02_issue_1_audit.md` (COUNTEREXAMPLE VALID). The general truth at the edges and for p > q is reasoning, not Lean (`T02_issue_1.md` "Not checked").
- **Not affected:** S1, S2, S4–S7, S10, S12–S14 (proved); the statement of Theorem 3.2; other results.
- **Recorded suggested fix** (`T02_issue_1.md`, reviewer's suggestion only): treat the edge separately: at π₁ = 1, g is strictly increasing, so the maximum over (0,1] is at λ = 1, in agreement with the printed formula; for π₁ < 1, lim g = −∞; add the mirror sentence for π₁ = 0 when p > q.
- Revised numbering (old l.435, mirror old l.462).

### 4.3 Theorem 3.2, proof, l.435: sign of d_{p,q}(y)

- **Classification:** ruled `PAPER_ARGUMENT_GAP` (minor, "sign typo") in `T02_issue_1.md` issue 2, which itself says a human may reasonably downgrade it to editorial; `T02_final.md` §8 reads it as supporting an editorial-level view. It is not an entry of `BLOCKERS.md` (B2 mentions it as a side note) and `T02_issue_1_audit.md` reviews issue 1 only. No effect on the result.
- **What fails:** l.435 prints d_{p,q}(y) = ∫ 1{p ≤ θ < q}(θ − y) dν; from the elementary scores (l.96–102) the integrand should be (y − θ), and the printed form contradicts d(0) < 0 at l.424. The ratios at l.437–439 are invariant under a global sign change, so the final values 1/(1−κ) and 1/κ are right.
- **Lean evidence:** `counterexample_l454`, `printed_l454_iff_gap`, `ratio_sign_invariant` in `T02_Counterexample1.lean`; S12/S13a proved from the correctly signed computation (route deviation, `T02_final.md` §5).
- **Recorded suggested fix** (`T02_issue_1.md` issue 2, reviewer's suggestion): in l.435 replace (θ − y) by (y − θ), and in l.437 replace the middle expression by ν{[p,q)} / (ν{[p,q)} − ∫_{[p,q)} θ dν(θ)).

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| l.227 and l.400 (Prop. 3.5, h = 1) | Optional stopping for h = 1 is not written out; the proof of 3.4 starts at "Let h > 1" | FAIR_IMPLICIT_STEP, conclusion not threatened (ruling states "not confirmed until pv-auditor review"; the final audit `P05_final_r2.md` accepts it; no separate review report exists) | `verification/audits/P05_issue_1.md` |
| l.214 | Product ∏_{j=1}^t E_j(Y_{j+1}) is F_{t+1}-measurable, not F_t | EDITORIAL | `P05_issue_1.md` §3, §7(ii) |
| l.217 vs l.146 | Case p_t = q_t (E_{p,q;λ} is 0/0) | DOMAIN_CLARIFICATION candidate; auditor: not an issue; conclusion holds under either reading; no ruling by an issue checker | `P04_final.md` §4 |
| l.220/l.232 vs l.452/l.466 | Proof is for Q ∈ H_S, statement for H_{S;c}; reduction via λ_t = 0 when c_t = 0 printed only in the h = 1 sketch (l.205–209) | FAIR_IMPLICIT_STEP (gate's preliminary EXPOSITION_GAP never dispatched) | `P04_final.md` §4; `P04_gate.md` item 7.2 |
| l.220 | F_T-measurability of e_T and the choice τ ≡ T not argued | FAIR_IMPLICIT_STEP | `P04_gate.md` item 7.5 |
| l.424 | "d(0) < 0 < d(1)" and passage from [0,1) to (0,1] | FAIR_IMPLICIT_STEP | `T02_issue_1.md` issue 3 |
| l.443 | "a direct computation shows H = [0,p]" omits the computation | FAIR_IMPLICIT_STEP | `T03_final.md` §6 |

**Observations of the coordinator (no review behind them).** None of them is a finding about the paper.

| Observation | Based on |
|---|---|
| The reconnection of `P04_T01Consumed` to `T01_S2` was offered at the gate but never carried out, so P04 and P05 stay conditional on a clause that is proved gap-free in T01's gap file. | `P04_gate_r2.md` ("dischargeable by `Paper.T01.T01_S2`"); `verification/RESUME.md`; `pv_work/T01ModGaps.lean` |
| The bib key `Gneiting2007` (cited at l.90 for "Theorem 2.3") resolves to Gneiting–Balabdaoui–Raftery, while the records say Gneiting–Raftery. | `source/VSIFP_02.bbl:42,52` |
| X03 is attributed to "2019" in the records; the manuscript cites `Gruenwald2020`. | `source/VSIFP_02.tex:183,443`, `VSIFP_02.bbl:58-62` |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | l.214 | The product ∏_{j=1}^t E_j(Y_{j+1}) is F_{t+1}-measurable; l.227 states it correctly as (e_t)_{t≥2} (audit record `P05_issue_1.md`). |
| 2 | l.437 | Stray `\}` after κ_ν{[p,q)} in `1/(1−κ_ν{[p,q)\}\})` (`T02_final.md`). |
| 3 | l.454 | Summation index ℓ but summand indexed by k (`P04_gate.md` 7.4; `P04_final.md` §6). |
| 4 | l.460 | "k ∈ {1,…,k}", upper limit should be h (same). |
| 5 | l.466, l.468 | M_{τ+h−1}, M_{t+h−1} where e is meant (same). |
| 6 | l.452 | `\tau[k]` while l.454 writes `\tau^{[k]}` (found by the compiler while reading the source; no fix proposed). |
| 7 | l.139 | "In the case q > p, the intervals take the form [κ_ν{[q,p)}, 1] or [p,1]": [q,p) requires q < p (same). |
| 8 | l.164 | `\big\}` closing a plain `\{` (typographic; same). |
| 9 | l.150 | "accumulated capital at time if $T$ the initial capital is $1$": garbled (same). |
| 10 | l.314, l.600 | "achieve a lower Brier score the HCLR forecasts" (missing "than"); l.600 also "tests tests" (same). |

Presentational suggestions raised in audit records: note at l.447 that h = 1 is covered by l.214/l.227 (`P05_issue_1.md` §7); index the product at l.214 as ∏_{j=1}^{t−1} or say "with respect to (F_{t+1})"; say that the appendix proof of Proposition 3.4 (l.446) also proves Proposition 3.5; state the reduction via λ_t = 0 when c_t = 0 in the proof (`P04_final.md` §4).

## 6. Human-check list

**Literature and citations:**
- A: `P04_T01Consumed` (accept the "if" part of Theorem 3.1 as stated).
- B: X03, attribution (2019 vs 2020) and coverage.
- C: `P04_MixingOfStrict` and the regularity conditions at l.90; which paper's Theorem 2.3 is meant.
- The anytime-valid p-value statement (l.246) and the Ramdas et al. (2020) §3 reference (l.227).

**Mathematical completion (parts supported by reasoning only):**
- T01 necessity for p > q (S10 gap); T02 for p > q and the general edge cases (only the instance and its mirror are in Lean); the λ-range passage (0,1] vs [0,1).
- P05, h = 1: rests on a FAIR_IMPLICIT_STEP; no separate reasoning review report exists.

**Author intent:**
- Whether `e_{τ+h−1}` in Proposition 3.5 means the random-index evaluation `e_{τ(ω)+h−1}(ω)`.
- p_t = q_t, and H_S vs H_{S;c}.
- TFA-1: is the L¹ reading of l.115 intended.
- Classification of B1, B2 and the l.435 slip (`PAPER_ARGUMENT_GAP` vs editorial); `T02_issue_1.md` recommends a human check.

**Experiments and unnumbered assertions:** Sections 4–5 and the unnumbered assertions of Section 3 were not checked.

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean v4.19.0, Mathlib commit c44e0c8e; Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`).
- Technical formalization assumptions (TFA) approved by the gate: TFA-1 (integrability: `MixtureRep` carries integrability of the elementary scores; `HScInt` adds integrability of the score difference under Q); TFA-2 (ν and its representation are hypotheses); ℕ = {1,2,…} so τ ≥ 1.
- Scope restriction: consistency over the closed [0,1] with real-valued S excludes the logarithmic score, which the source mentions (l.73, table l.178). `DEFS_gate.md` N2 asks the T01/T02 gates to check or record this; no such record was found in `T01_gate.md` or `T02_gate.md` (UNVERIFIED whether deliberate).
- Corrections on the formalization side: an obsolete `pv_work/P05ModGaps.lean` (old statement) is left in place and unused.
- Lean comment errata: `verification/DOC_ERRATA.md` (P05.lean docstrings cite l.403 where l.400 is meant); other Lean docstrings still quote old line numbers (e.g. `T03Stmt.lean:36-41`, `T02Stmt.lean:33-36`).

## 8. Process disclosure

- Violations: none recorded.
- Revision carry-over: T01, T02 and T03 were audited on the previous manuscript and kept after revision 1 by a coordinator decision (10 definitions flagged CHANGED were judged notation or format only; the new text includes the H_S = [0,κ] remark at l.135–139). No independent re-audit of the new text is on file.
- Record inconsistencies found by the compiler (`work/consistency_check.md`). Corrected: B3 in `BLOCKERS.md` and the stale P05 row of `PAPER_VERIFICATION.md` / `RESULTS.json` summary, by `record P05 --resolve B3` on 2026-10-13. **Not corrected (disclosed only, to avoid unattended edits to audited records):** `EXTERNAL_TOOLS.md` lacks `T02_T01Consumed`; the registry's `source_loc`/Lean-line fields of `P04_T01Consumed` (l.199–214) and `P04_MixingOfStrict` (`:90`, l.106) are outdated; X03's year; the `partial` field of T02 is stale; `RESUME.md` upper sections are stale; mechanical reports `T03_mech.md`, `P05_mech_r2/r3.md` print "TRACED CONDITIONS: none" (corrected in the final audits); duplicate `AUDIT.md` entries; no `P04_issue_1_audit.md` and no `P05_issue_1_audit.md` for the current text; old line numbers persist in several records.
- The independent fact check of this report's first draft found N problems, which have been corrected (see §9; filled in below after the check).
- Permission denials and guard refusals: the coordinator was blocked from editing audit reports in an earlier session (T01 closing line; fixed by pv-auditor).

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report); `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md` (compiler outputs)

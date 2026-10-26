# The oracle risk of linear shrinkage: final report of the faithful LaTeX → Lean check

2026-10-12, summary by the coordinator; fact-checked independently (verification/report/work/factcheck.md); the corrections it required have been applied.

- **This report is not a claim that the whole paper is fully verified.** The paper still depends on 1 external input (`T01_L02Consumed`) that has not been verified in Lean, and one lemma has a recorded issue.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (check the external inputs one by one).

---

## 0. Summary table (English, for screenshots)

**4 numbered results: 2 verified unconditionally · 1 verified conditionally · 1 with recorded issues · 0 unfinished.**

"Conditionally verified" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions. The recorded issue is not a counterexample to any numbered statement: it is two false assertions inside the proof of Lemma 2.2 (main.tex:54-55), whose conclusion is true.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| Lemma 2.1 | Completing the square | Verified unconditionally | none |
| Lemma 2.2 | Oracle risk ≤ min{θ², σ²} | Issue recorded | B1, PAPER_ARGUMENT_GAP at main.tex:54-55 (conclusion true) |
| Theorem 2.3 | Oracle factor is optimal | Verified conditionally | `T01_L02Consumed` (Lemma 2.2's conclusion, used for clause 3) |
| Corollary 2.4 | Oracle beats one half | Verified unconditionally | none for the statement (the remark at main.tex:75-76 uses Lemma 2.2 and is not covered; see §2) |

No result has a condition checked by a person yet.

## 1. Overall findings

1. No counterexample to any numbered result. One issue is recorded, on the paper side (PAPER_ARGUMENT_GAP); this is not a complete list of observations, see §4–§5.
2. Verified unconditionally: Lemma 2.1 and Corollary 2.4 (main claim R(c*) ≤ R(1/2), main.tex:74, uses only Lemma 2.1).
3. Verified conditionally: Theorem 2.3, on Lemma 2.2's conclusion (clause 3, "ρ ≤ min{R(0),R(1)}"). Clauses 1–2 (lower bound and equality case, main.tex:59) use no parameter. No provenance debts recorded in words.
4. Issue: Lemma 2.2, with Lean counterexamples to the two printed inequalities (`pv_work/L02_Counterexample1.lean`).
5. Downstream: the issue does not change the truth of Lemma 2.2's conclusion, so the content of Theorem 2.3 and Corollary 2.4 is not threatened (`L02_issue_1.md` §5, `L02_issue_1_audit.md` §4), but Theorem 2.3's clause 3 is formally conditional on that conclusion because the printed proof of the lemma cannot be followed.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| Lemma 2.1 | UNCONDITIONAL | Identity R(c) − ρ = (θ²+σ²)(c − c*)² verified with only the standing assumption (main.tex:25). `pv_work/L01.lean`. |
| Lemma 2.2 | ISSUE (B1) | ρ = ½·HM verified (main.tex:53); the step "HM ≤ the smaller, so ρ ≤ ½ min" (main.tex:54-55) is false; the last step ½ min ≤ min is fine. Conclusion true (Lean-proved separately). |
| Theorem 2.3 | CONDITIONAL | Clauses 1–2 unconditional; clause 3 uses `T01_L02Consumed`. L02 is ISSUE, so no reconnection unless a revision resolves B1. |
| Corollary 2.4 | UNCONDITIONAL | Main claim uses Lemma 2.1 only. The second proof sentence (main.tex:75-76) is an extra remark that uses Lemma 2.2 (obligation `C01_S4`, parameter `C01_L02Consumed`, not a condition of the statement); that sentence is not covered by the verdict and inherits B1. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted in the source but not proved; (iii) never stated in the source; (iv) a clause of one of the source's own lemmas whose proof has an issue; (v) a standard fact with no interface in mathlib; (p) a predecessor clause not yet reconnected. Gap hypotheses do not count as external inputs; they are listed under the corresponding issue in §4.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `T01_L02Consumed` (`pv_work/T01Stmt.lean:20`) | (iv) (predecessor L02, issue B1; gated as (p)), priority A | T01 step S5, clause `le_min` | Lemma 2.2's conclusion is true (Lean-proved independently in a gate probe), but its printed proof is wrong; accept the statement or check a corrected proof | not yet |

Remark-only parameter (not a condition and not a provenance debt of C01): `C01_L02Consumed` (`pv_work/C01Stmt.lean:15`), used only by `C01_S4` (`pv_work/C01.lean:35`), the remark at main.tex:75-76 (`C01_final.md` §4); C01's verdict does not depend on it. External assertions not encoded: none.

## 4. Substantive issues for the authors (in PDF order)

### 4.1 Lemma 2.2, main.tex:54-55 (B1) — PAPER_ARGUMENT_GAP, paper side

- **Source sentence**: "The harmonic mean of two positive numbers is at most the smaller of them, so ρ ≤ ½ min{θ², σ²} ≤ min{θ², σ²}."
- **What fails**: (A) "harmonic mean ≤ the smaller" is false: a = 1, b = 4 gives 2ab/(a+b) = 8/5 > 1; in fact HM ≥ min always. (B) "ρ ≤ ½ min{θ², σ²}" is false whenever θ² ≠ σ²: θ = 1, σ = 2 gives ρ = 4/5 > 1/2. The lemma's conclusion (main.tex:49) is true.
- **Lean evidence**: `pv_work/L02_Counterexample1.lean`; gaps `L02_S2_Gap`, `L02_S3_Gap` in `pv_work/L02ModGaps.lean`; rulings `verification/audits/L02_issue_1.md` (PAPER_ARGUMENT_GAP, does not threaten the conclusion), `L02_issue_1_audit.md` (COUNTEREXAMPLE VALID), `L02_final.md`. The classification as PAPER_ARGUMENT_GAP rather than ERROR rests on the reviewers' judgment that the conclusion is true.
- **Not affected**: the conclusion of Lemma 2.2; Lemma 2.1; Theorem 2.3 clauses 1–2; Corollary 2.4's main claim.
- **Recorded suggestion** (`L02_issue_1.md` §7, `L02_issue_1_audit.md` §5; suggestion only, Lean-checked as `fix_harmonicMean_le_two_min`, `fix_chain`): replace main.tex:54-55 by "The harmonic mean of two positive numbers is at most twice the smaller of them, so ρ ≤ min{θ², σ²}."

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| main.tex:75 | R(c*) = ρ credited to Lemma 2.2 | FAIR_IMPLICIT_STEP / editorial: follows from Lemma 2.1 at c = c* | `verification/audits/C01_gate.md` item 7; `C01_final.md` §8 |
| main.tex:64-65 | "θ²+σ²>0" derived from σ>0 (main.tex:25) | FAIR_IMPLICIT_STEP | `T01_final.md` §6 (line 70) |
| main.tex:44-45 | division by θ²+σ² needs θ²+σ² ≠ 0 | FAIR_IMPLICIT_STEP | `L01_final.md` §5 |

Other FAIR_IMPLICIT_STEPs filled in Lean (no action needed): T01 (c−c*)²=0 ⇒ c=c*; C01 S1 and S2; L02 θ²,σ²>0 and min ≥ 0. The table lists only the source-visible boundary cases.

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| The second sentence of Corollary 2.4's proof (main.tex:75-76) is not needed for the corollary; R(c*)=ρ follows from Lemma 2.1 at c=c*. The audits record no wording suggestion. | `C01_final.md` §8 |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | main.tex:75 | "R(c*) = ρ" credited to Lemma 2.2; it follows from Lemma 2.1 (at c = c*) |

Fair implicit steps (main.tex:44-45, `L01_final.md:51`; main.tex:64-65, `T01_final.md:70`) need no author action and are not listed as slips.

## 6. Human-check list

**Literature and citations**: none (the paper cites no external results).
**Mathematical completion (parts supported by reasoning only)**: `T01_L02Consumed` (accept Lemma 2.2's true conclusion or check a corrected proof); the classification of B1 as PAPER_ARGUMENT_GAP rather than ERROR.
**Mathematical completion (addition)**: the ruling recommends a human note that the proof prints a false inequality (B) (`L02_issue_1.md:72`); the faithfulness of `L02.Conclusion` and the other Lean statements rests on gate review, not on Lean evidence.
**Author intent**: that the suggested fix of B1 ("at most twice the smaller") matches what the authors meant; whether the remark at main.tex:75-76 is regarded as part of Corollary 2.4's claim (if so, it inherits B1).
**Experiments and unnumbered assertions**: the statistical interpretation of R(c) (main.tex:29) is not formalized; the formula is taken as the definition (`DEFS_gate.md` item 2).

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean 4.19.0, Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json`). Mathlib modules compiled on this machine: 6305 of 6305 (`scripts/pv_lean.sh packages`).
- Technical formalization assumptions: the standing assumption (main.tex:25) is encoded as the hypothesis structure `Setting θ σ` (`pv_work/Defs.lean:7`); statements are over ℝ.
- Lean comment errata: `verification/DOC_ERRATA.md` (the docstring of `T01_L02Consumed` cites main.tex:66-67; the use is 65-66). Cosmetic: duplicate-namespace linter warning for `Paper.L01.L01`.

## 8. Process disclosure

- Violations: none recorded.
- Coordinator/record errors found at report time and corrected: `PAPER_VERIFICATION.md` rows for L01, L02, T01, C01 were too thin (T01 named no condition); `DOC_ERRATA.md` was empty despite a known slip; `EXTERNAL_TOOLS.md` candidate table was stale; `C01_L02Consumed` was not mentioned in the registry. Minor, not corrected: `AUDIT.md:11,40,49` and `RESULTS.json:96` give `pv_work/L02ModGaps.lean:1` for `L02_mod_gaps` (actually line 25); `AUDIT.md` has no entry for `L02_issue_1_audit.md` and `RESULTS.json` L02 `evidence.issues` omits it; C01's `models_used` lists only sonnet although its gate and audit were run on opus; `RESULTS.json` T01/C01 have no `upstream_issues` field; the source has 78 lines, while some records say 79.
- `C01_mech.md` has a header timestamp (22:28) earlier than its actual run, and the mechanical script hung about 15 minutes and was rerun by hand (`C01_final.md` §1).
- An independent fact-check of the first draft found 16 problems (1 Major, 5 Moderate, 10 Minor), which have been corrected (first draft: `verification/report/work/AUTHOR_REPORT_v1.md`).
- Permission denials and guard refusals: not counted in this unattended run.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)
- `verification/report/work/consistency_check.md`, `author_notes.md`, `external_tools.md` (compiler output)

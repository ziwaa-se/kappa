# Three facts about the empirical distribution function: final report of the faithful LaTeX → Lean check

2026-10-13, summary by the coordinator; it is submitted to an independent fact check, whose report is in verification/report/work/factcheck.md.

- **This report is not a claim that the whole paper is fully verified.** Two of the three results still depend on 3 external inputs (cited theorems) that have not been verified in Lean.
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` → `EXTERNAL_TOOLS_WORKSHEET.md`.

---

## 0. Summary table

**3 numbered results: 1 verified unconditionally · 2 verified conditionally · 0 with recorded issues · 0 unfinished.**

"Conditionally verified" means the paper's own proof was checked step by step in Lean, but cited or unproved inputs remain. Those inputs are explicit Lean parameters, never hidden assumptions (no exceptions recorded in words). No issue is recorded, so there is no counterexample to any result.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| Lemma 2.1 | L01: EDF is nondecreasing, n F_n(t) an integer in 0..n | Verified unconditionally | none |
| Proposition 2.2 | P01: sup\|F_n − F\| → 0 a.s. (Glivenko–Cantelli) | Verified conditionally | `GlivenkoCantelli` |
| Theorem 2.3 | T01: Kolmogorov–Smirnov limit law | Verified conditionally | `DonskerUniformSup` (convergence clause), `KolmogorovFormula` (cdf clause) |

No condition has been checked by a person yet.

## 1. Overall findings

1. No counterexample and no paper-side issue is recorded (`verification/BLOCKERS.md` has no entries).
2. Unconditional: Lemma 2.1.
3. Conditional: Proposition 2.2 (on Glivenko–Cantelli) and Theorem 2.3 (on Donsker's principle and Kolmogorov's formula). All three are cited results (type (i)); none is encoded as an axiom.
4. **Plain statement for P01:** the Glivenko–Cantelli parameter equals P01's own conclusion (goal-shaped, VERDICTS §4.2). The source proof of Proposition 2.2 is the bare citation (main.tex:50), so the Lean check shows only that the printed proposition is an instance of the encoded theorem (P01_final §6). Likewise `KolmogorovFormula` equals T01's cdf clause, because the source proves that clause by citation only.
5. The one candidate gap, the silent reduction of a continuous F to uniform samples (main.tex:60-62), was ruled a fair implicit step (`T01_issue_1.md`) and is proved in Lean (T01_S2–S4). Measurability of D_n (T01_S1) is also proved. These do not count as paper issues.
6. No result depends on another (`depends_on` empty), so nothing propagates.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| Lemma 2.1 (L01) | Verified unconditionally | Proved along the printed route (`pv_work/L01.lean:33 Paper.L01.L01_main`); gate and final audit PASS (`L01_gate.md`, `L01_final.md`). |
| Proposition 2.2 (P01) | Verified conditionally | `Paper.P01.P01_main` (`pv_work/P01.lean:18`) takes `GlivenkoCantelli`; gate and final audit PASS (`P01_gate.md`, `P01_final.md`). |
| Theorem 2.3 (T01) | Verified conditionally | `Paper.T01.T01` (`pv_work/T01.lean:436`), steps S1–S6 all proved, no gap hypothesis; takes `DonskerUniformSup` and `KolmogorovFormula`. Gate PASS; the first proof session stopped at S1 (an unused formalization-side obligation, `T01_final.md`, UNFINISHED), the second session proved it; final audit r2 PASS (`T01_final_r2.md`). |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

Provenance types: (i) explicitly cited in the source; (ii) asserted but not proved; (iii) never stated; (iv) a clause of the source's own lemma whose proof has an issue; (v) standard fact with no mathlib interface; (p) predecessor clause not reconnected. Gap hypotheses are not external inputs; there are none.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person (who, date, how) |
|---|---|---|---|---|---|
| 1 | `GlivenkoCantelli` (`pv_work/P01Stmt.lean:26`) | (i), main.tex:50, no `\cite` | P01, step S1 | The encoding equals the classical Glivenko–Cantelli theorem; attribution is by name only. | not yet |
| 2 | `DonskerUniformSup` (`pv_work/T01Stmt.lean:60`) | (i), `\cite{donsker}`, main.tex:61 | T01, step S5, convergence clause | That Donsker 1952 gives √n·D_n → sup\|B\| for iid uniform samples, including the sup-functional step. | not yet |
| 3 | `KolmogorovFormula` (`pv_work/T01Stmt.lean:69`) | (i), `\cite{kolmogorov}`, main.tex:62 | T01, step S6, cdf clause | The formula K(z) and its z>0 domain; whether this form is Kolmogorov's (1933) or the Doob/Donsker form. | not yet |

Debts recorded in words: none. External assertions not encoded: none. The truth of the cited theorems was not checked (no network).

## 4. Substantive issues for the authors

None. No ERROR, PAPER_ARGUMENT_GAP, PAPER_ASSUMPTION_GAP, EXPOSITION_GAP or DOMAIN_CLARIFICATION is confirmed.

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| main.tex:60-62 | Is the reduction from continuous F to uniform samples, and the measurability of D_n, an unjustified step? | FAIR_IMPLICIT_STEP; not a paper issue; proved in Lean | `verification/audits/T01_issue_1.md`; confirmed `T01_final.md` §5, `T01_final_r2.md` §3 |
| main.tex:50 | Is a goal-shaped parameter acceptable for P01? | Accepted by gate and auditor, because the source proof is the bare citation | `verification/audits/P01_gate.md`, `P01_final.md` |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| The ruling on the reduction recalls that Donsker 1952 and Kolmogorov 1933 treat the uniform case; this was not checked against the literature. A question for the authors: is the cited principle meant for the uniform or the general-F case? | `T01_issue_1.md` §3, §8 ("recollection, not checked here") |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | main.tex:50 | "This is the Glivenko–Cantelli theorem." has no `\cite`; the bibliography (main.tex:65-74) has only donsker and kolmogorov (P01_gate items 6–7). |
| 2 | main.tex:55-56 | "Brownian bridge" is used without definition; the standard meaning is unique (T01_gate §7). |
| 3 | main.tex:62 | "The form of K is due to Kolmogorov": per the gate's recollection (not checked), Kolmogorov 1933 gives the limit of P(√n D_n ≤ z); the sup-of-bridge law is the Doob/Donsker formulation. Attribution nuance (T01_gate §6–7). |
| 4 | main.tex:61 | Suggestion only (reviewer's wording, not used in any verification, `T01_issue_1.md` §7): state the reduction in one sentence, e.g. "Since F is continuous, F(X_i) are iid uniform on [0,1] and D_n equals a.s. the uniform-sample statistic." |
| 5 | main.tex:29-31, 54-55 | The source does not say that "distribution function" means P(X_1 ≤ t), that the X_i are real random variables on a probability space, or that D_n is measurable (all standard; DEFS_gate item 4, `T01_issue_1.md` §6). |

## 6. Human-check list

**Literature and citations**: `GlivenkoCantelli` (priority B), `KolmogorovFormula` (B), `DonskerUniformSup` (D); see §3 and the worksheet. There are no priority A, A′, C or E items.
**Mathematical completion (reasoning only, no Lean evidence)**: that `IsBrownianBridge` as encoded is the standard Brownian bridge and that one exists in the encoded sense (so the universally quantified clauses are not vacuous), `T01_gate` items 3–4; that `ConvInDist` is standard weak convergence and `Omega : Type` is harmless (`T01_gate` items 1, 4).
**Author intent**: whether the cited Donsker principle is meant in the uniform or the general-F form (§4.x).
**Experiments and unnumbered assertions**: none.

## 7. Limits on the formalization side (not paper issues)

- External parameters are still unverified, so full verification of the whole paper is not claimed.
- Lean environment: Lean `leanprover/lean4:v4.19.0` (`lean-toolchain`); Mathlib commit not recorded in the project files (the shared `lean-env` is outside the project); `scripts/pv_lean.sh packages`: mathlib modules compiled: 6305 of 6305, so "not in Mathlib" searches covered all of it.
- `Omega : Type` (universe 0) in T01, and `n = 0` junk values for D_n in Lean, are outside the source's n ≥ 1; harmless per the gates.
- Lean comment errata: `verification/DOC_ERRATA.md` (no entries recorded).

## 8. Process disclosure

- Violations: none recorded.
- Coordinator errors found and corrected: this report's compilation step found three stale records, now corrected: the EXTERNAL_TOOLS registry still said "T01_S1 unproved" (regenerated); an AUDIT.md T01 entry cites the superseded `T01_final.md` and a gap that no longer exists (correction note appended); the P01 row of PAPER_VERIFICATION.md omitted the instantiation caveat (added).
- The first proof session of T01 stopped at S1 (budget); the second session proved it.
- Independent fact check of the first draft: see the end of this section after it returns.
- Permission denials during the run: not tabulated.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report)

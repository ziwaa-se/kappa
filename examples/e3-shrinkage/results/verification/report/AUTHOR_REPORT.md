# The oracle risk of linear shrinkage: final report of the faithful LaTeX → Lean check (revision 2)

2026-10-13, summary by the coordinator; it was independently fact-checked (`verification/report/work/factcheck.md`) and the corrections listed there have been applied.

- **Scope of the claim.** All four numbered results are verified unconditionally in Lean against `source/main.tex` (revision 2), with no external parameters. This holds for the Lean encodings of the definitions D01-D04 (`pv_work/Defs.lean`), which a person should compare with the paper (see `FILES_TO_CHECK.md` §3).
- **For per-result details, `verification/PAPER_VERIFICATION.md` takes precedence.**
- **Reading order:** this report → `FILES_TO_CHECK.md` (where to check) → `EXTERNAL_TOOLS_WORKSHEET.md` (empty: no external inputs).

---

## 0. Summary table (English, for screenshots)

**4 numbered results: 4 verified unconditionally · 0 verified conditionally · 0 with recorded issues · 0 unfinished.**

"Verified conditionally" means that the paper's own proof was checked step by step in Lean, but some cited or unproved inputs remain as explicit Lean parameters. No result is in this class.

| PDF no. | Result | Verdict | Remaining conditions / issue |
|---|---|---|---|
| 2.1 | Lemma (completing the square) | Verified unconditionally | none |
| 2.2 | Lemma (ρ ≤ min{θ², σ²}) | Verified unconditionally | none (the issue B1 of revision 1 is resolved by the new proof) |
| 2.3 | Theorem (oracle factor is optimal) | Verified unconditionally | none |
| 2.4 | Corollary (oracle beats one half) | Verified unconditionally | none; one editorial slip at main.tex:80 (§5) |

## 0b. What the revision changed

From `python3 scripts/pv_status.py followup`. Results that were not reset keep their verdicts; here L01 and L02 were reset by the revision, and T01 and C01 were reset by the cascade (L02's gated statement changed) and went through gate, proof and final audit again.

| PDF no. | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|
| 2.1 | Verified unconditionally (revision 2 start) | Verified unconditionally | none | none |
| 2.2 | Issue recorded | Verified unconditionally | B1 | B1: resolved (the proof was rewritten at main.tex:58-61) |
| 2.3 | Verified conditionally (on the Lemma 2.2 clause) | Verified unconditionally | none | none |
| 2.4 | Verified unconditionally | Verified unconditionally | none | none |

## 1. Overall findings

1. There is no counterexample to any result and no open substantive issue in the current manuscript.
2. All four results are verified unconditionally (§2).
3. None is conditional; the registry of external inputs is empty (§3).
4. No result has a recorded issue. Issue B1 (revision 1, Lemma 2.2: proof step "harmonic mean ≤ the smaller") concerned the old proof; its conclusion was true, and the rewritten proof is correct (`verification/audits/L02_final.md` §8).
5. Downstream: Theorem 2.3 and Corollary 2.4 were re-verified against the now-verified Lemmas 2.1 and 2.2, which they import directly (the Corollary's main route needs only Lemma 2.1).

This is not a claim beyond what the Lean encodings state.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.1 | UNCONDITIONAL | Hypothesis only `Setting θ σ` (main.tex:25). Gate PASS, final audit PASS (`verification/audits/L01_gate.md`, `verification/audits/L01_final.md`). |
| 2.2 | UNCONDITIONAL | Revised proof "ρ < θ², ρ < σ²" is correct. The "in the same way ρ < σ²" step uses θ² > 0 from main.tex:25 (fair implicit step). `verification/audits/L02_final.md`. |
| 2.3 | UNCONDITIONAL | Three clauses (lower bound, equality iff c = c*, ρ ≤ min{R(0),R(1)}); θ²+σ² > 0 (from main.tex:25) and the zero-product step are fair implicit steps; R(0) = θ², R(1) = σ² are printed at main.tex:70 and proved by direct computation. `verification/audits/T01_final.md`. |
| 2.4 | UNCONDITIONAL | R(c*) ≤ R(1/2) from Lemma 2.1 (steps S1, S2); Lemma 2.2 is used only for the remark at main.tex:80 (S4). Editorial slip at main.tex:80 (§5). `verification/audits/C01_final.md`. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

**None.** No result uses a visible parameter. The earlier registry entry `T01_L02Consumed` (a predecessor clause of Lemma 2.2) and the debt `C01_L02Consumed` were removed during revision 2 because T01 and C01 now import L01 and L02 directly (`verification/audits/T01_final.md` §4; `AUDIT.md` C01 cascade entry of 2026-10-13 01:22 and `verification/audits/C01_final.md` §3-4: no consumed clauses). No external assertion is left unencoded.

| # | Lean parameter | Type | Used by | What a person should check | Checked by a person |
|---|---|---|---|---|---|
| – | none | – | – | – | – |

The standing assumption main.tex:25 ("Throughout, θ ≠ 0 and σ > 0") is encoded as `Paper.Setting`; it is the paper's own global setting, not an external input.

## 4. Substantive issues for the authors

None in the current revision.

### 4.x Boundary cases ruled by the reviewers, and observations of the coordinator

| Source location | Question | Ruling | Ruled by (report path) |
|---|---|---|---|
| main.tex:60 | "in the same way ρ < σ²" needs θ² > 0, which the text does not restate | FAIR_IMPLICIT_STEP (θ ≠ 0 from main.tex:25) | `verification/audits/L02_final.md` |
| main.tex:69-70 | θ²+σ² > 0 derived from main.tex:25, and (c−c*)² = 0 ⇒ c = c* | FAIR_IMPLICIT_STEP, proved in Lean | `verification/audits/T01_final.md` §6 |
| main.tex:79 | R(c*) = ρ used before it is stated in the next sentence | FAIR_IMPLICIT_STEP | `verification/audits/C01_final.md` §6 |
| main.tex:80 | R(c*) = ρ credited to Lemma 2.2 | EDITORIAL (§5) | `verification/audits/C01_final.md` §8 |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| The B1 suggestion recorded in `verification/BLOCKERS.md` (from the old `L02_issue_1.md`) is superseded by the rewritten proof and should not be passed on. | `verification/BLOCKERS.md` (B1 RESOLVED), `verification/audits/rev2/L02_issue_1.md` |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | main.tex:80 | "By Lemma 2.2, moreover, R(c*) = ρ ≤ min{θ², σ²}": the equality R(c*) = ρ is not Lemma 2.2 (lem:min); it follows from Lemma 2.1 at c = c* (as main.tex:34 says). The corollary is unaffected. (`verification/audits/C01_final.md` §8, `verification/audits/C01_gate.md`) |

## 6. Human-check list

**Literature and citations**: none (the paper cites nothing).
**Mathematical completion (parts supported by reasoning only)**: the attribution at main.tex:80 (§5, item 1) is a reading of the printed text; Lean proves R(c*) = ρ as step S3 of C01.
**Author intent**: none open.
**Experiments and unnumbered assertions**: main.tex:34 (new in revision 2) asserts that c* gives the oracle risk; its content R(c*) = ρ is proved in Lean as `Paper.C01.C01_S3`, from Lemma 2.1 at c = c*.

## 7. Limits on the formalization side (not paper issues)

- No external parameters remain. This is still a statement about the Lean encodings (D01-D04 in `pv_work/Defs.lean`, gated in `verification/audits/DEFS_gate.md`); a person should compare them with main.tex:25-33.
- Lean environment: Lean 4.19.0 (`lean-toolchain`), Mathlib commit c44e0c8ee63ca166450922a373c7409c5d26b00b (`RESULTS.json`). `scripts/pv_lean.sh packages`: mathlib modules compiled: 6305 of 6305, so "not in Mathlib" searches covered all of Mathlib (none were needed).
- Technical formalization assumptions approved by the gate: none recorded.
- Scope restriction: real-valued θ, σ with `Setting` as hypothesis.
- Lean comment errata: `verification/DOC_ERRATA.md` (stale docstring line numbers in `L01Stmt.lean`; an obsolete row about the removed `T01_L02Consumed`).

## 8. Process disclosure

- Violations: none recorded.
- Coordinator corrections made at report time: the stale registry entry `T01_L02Consumed` in `RESULTS.json` and the stale debt row in `EXTERNAL_TOOLS.md` were removed (both contradicted the final audits); the settlement paragraph in `EXTERNAL_TOOLS.md` was corrected, its debt row was replaced by a note, and `DOC_ERRATA.md` row 1 was marked obsolete and row 2 added.
- Records still stale, reported but not edited: `RESULTS.json` `baseline_before` of T01 and C01 points to a directory source_baseline_v2 that does not exist; `BLOCKERS.md` B1 evidence paths now live under `verification/audits/rev2/` and `pv_work/superseded/rev2/`; `RESULTS.json` `run_scope` is `["C01"]` and `models_used` is `["sonnet"]` although gates and audits ran on Opus; the candidate table in `EXTERNAL_TOOLS.md` uses old line numbers; the `PAPER_VERIFICATION.md` C01 row is thin; `BLOCKERS.md` B1 also cites a sentence (main.tex:54-55) that no longer exists. `RESUME.md` was updated at this milestone (see `consistency_check.md`).
- The independent fact check of this report's first draft found 14 problems (1 Major, 4 Moderate, 9 Minor); they were corrected as listed in `factcheck.md`.
- Permission denials and guard refusals: not tabulated in this run.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report), `verification/report/work/consistency_check.md`

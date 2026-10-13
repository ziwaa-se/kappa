# The oracle risk of linear shrinkage: final report of the faithful LaTeX → Lean check (revision 2)

2026-10-13, summary by the coordinator; it has passed an independent fact check, whose report is in `verification/report/work/factcheck.md`.

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

From `python3 scripts/pv_status.py followup`. Results that were not reset keep their verdicts; here L01 and L02 were reset and T01 and C01 were re-checked as dependents.

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
4. No result has a recorded issue. Issue B1 (revision 1, Lemma 2.2: proof step "harmonic mean ≤ the smaller") concerned the old proof; its conclusion was true, and the rewritten proof is correct (`audits/L02_final.md` §8).
5. Downstream: Theorem 2.3 and Corollary 2.4 were re-verified against the now-verified Lemmas 2.1 and 2.2, which they import directly.

This is not a claim beyond what the Lean encodings state.

## 2. Verdict for each result

| PDF | Verdict | Key points |
|---|---|---|
| 2.1 | UNCONDITIONAL | Hypothesis only `Setting θ σ` (main.tex:25). Gate PASS, final audit PASS (`audits/L01_gate.md`, `audits/L01_final.md`). |
| 2.2 | UNCONDITIONAL | Revised proof "ρ < θ², ρ < σ²" is correct. The "in the same way ρ < σ²" step uses θ² > 0 from main.tex:25 (fair implicit step). `audits/L02_final.md`. |
| 2.3 | UNCONDITIONAL | Three clauses (lower bound, equality iff c = c*, ρ ≤ min{R(0),R(1)}); R(0) = θ², R(1) = σ² and θ²+σ² > 0 proved inside Lean as fair implicit steps. `audits/T01_final.md`. |
| 2.4 | UNCONDITIONAL | R(c*) ≤ R(1/2) using Lemmas 2.1 and 2.2 directly. Editorial slip at main.tex:80 (§5). `audits/C01_final.md`. |

## 3. All external dependencies

> Human-check worksheet: `EXTERNAL_TOOLS_WORKSHEET.md`

**None.** No result uses a visible parameter. The earlier registry entry `T01_L02Consumed` (a predecessor clause of Lemma 2.2) and the debt `C01_L02Consumed` were removed during revision 2 because T01 and C01 now import L01 and L02 directly (`audits/T01_final.md` §4, `audits/C01_final.md` §3-4). No external assertion is left unencoded.

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
| main.tex:70 | θ²+σ² > 0, R(0) = θ², R(1) = σ², zero-product step | fair implicit steps, proved in Lean | `verification/audits/T01_final.md` |
| main.tex:80 | R(c*) = ρ credited to Lemma 2.2 | EDITORIAL / FAIR_IMPLICIT_STEP (§5) | `verification/audits/C01_final.md` |

**Observations of the coordinator (no review behind them).**

| Observation | Based on |
|---|---|
| The B1 suggestion recorded in `verification/BLOCKERS.md` (from the old `L02_issue_1.md`) is superseded by the rewritten proof and should not be passed on. | `verification/BLOCKERS.md` (B1 RESOLVED), `verification/audits/rev2/L02_issue_1.md` |

## 5. Editorial typos and wording suggestions

| # | Location | Content |
|---|---|---|
| 1 | main.tex:80 | "By Lemma 2.2, moreover, R(c*) = ρ ≤ min{θ², σ²}": the equality R(c*) = ρ is not Lemma 2.2 (lem:min); it follows from Lemma 2.1 at c = c* (as main.tex:34 says). The corollary is unaffected. (`audits/C01_final.md` §8, `audits/C01_gate.md`) |
| 2 | main.tex:79-80 | The first sentence of the proof of Corollary 2.4 uses R(c*) = ρ before the second sentence states it. Recorded as a fair implicit step, not a request. (`audits/C01_final.md` §6) |

## 6. Human-check list

**Literature and citations**: none (the paper cites nothing).
**Mathematical completion (parts supported by reasoning only)**: the attribution at main.tex:80 (§5, item 1) is a reading of the printed text; Lean proves R(c*) = ρ as step S3 of C01.
**Author intent**: none open.
**Experiments and unnumbered assertions**: none recorded.

## 7. Limits on the formalization side (not paper issues)

- No external parameters remain. This is still a statement about the Lean encodings (D01-D04 in `pv_work/Defs.lean`, gated in `audits/DEFS_gate.md`); a person should compare them with main.tex:25-33.
- Lean environment: Lean and Mathlib versions are those of the linked `lean-env`; the Lean version string was not printed by any kit command available in this run (UNVERIFIED here). `scripts/pv_lean.sh packages`: mathlib modules compiled: 6305 of 6305, so "not in Mathlib" searches covered all of Mathlib (none were needed).
- Technical formalization assumptions approved by the gate: none recorded.
- Scope restriction: real-valued θ, σ with `Setting` as hypothesis.
- Lean comment errata: `verification/DOC_ERRATA.md` (stale docstring line numbers in `L01Stmt.lean`; an obsolete row about the removed `T01_L02Consumed`).

## 8. Process disclosure

- Violations: none recorded.
- Coordinator corrections made at report time: the stale registry entry `T01_L02Consumed` in `RESULTS.json` and the stale debt row in `EXTERNAL_TOOLS.md` were removed (both contradicted the final audits); `DOC_ERRATA.md` row 2 was added.
- Records still stale, reported but not edited: `RESULTS.json` `baseline_before` of T01 and C01 points to the missing `verification/source_baseline_v2`; `BLOCKERS.md` B1 evidence paths now live under `verification/audits/rev2/` and `pv_work/superseded/rev2/`; the human-check list and "Next steps" in `RESUME.md` predate the resolution of B1 (updated in RESUME at this milestone).
- The independent fact check of this report's first draft found FACTCHECK_N problems, which have been corrected.
- Permission denials and guard refusals: not tabulated in this run.

## 9. Evidence entry points

- `verification/PAPER_VERIFICATION.md`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`
- `verification/report/work/factcheck.md` (independent fact-check report), `verification/report/work/consistency_check.md`

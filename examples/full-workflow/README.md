# Full-workflow example: every verdict, a revision and a human check

A two-page note with three numbered results, taken through the kit's whole workflow: the first check, a corrected version of the paper, a condition checked by a person, and the final report. Everything here is the **real output of one test run** of v1.3 (2026-09-30, Sonnet coordinator, prompts sent verbatim from [docs/GUIDE_EN.md](../../docs/GUIDE_EN.md) §8). Local paths were replaced by placeholders, an unused field (`summary_zh`) was dropped from `results/RESULTS.json`, and one aside in `results/audits/L01_gate.md` that referred to an unrelated earlier project was replaced by `[…]`; nothing else was edited.

For a shorter example that you can run in about 20 minutes, see [two-lemmas-demo](../two-lemmas-demo/).

## What it shows

| State | Where it appears in this run |
|---|---|
| **Verified unconditionally** | Lemma 2.1, and the corrected Lemma 2.3 |
| **Verified conditionally** | Proposition 2.2: it relies on Nesbitt's inequality, which the paper cites. The citation becomes an explicit Lean hypothesis |
| **Issue recorded (`ERROR`)** | Lemma 2.3 as first submitted: false for every $x < -1$. A Lean counterexample at $x = -2$ was independently reviewed |
| **Unfinished** | Proposition 2.2 while the first check was still in progress; Lemma 2.3 after the revision reset it |
| **Re-checked after a revision** | The authors corrected Lemma 2.3. Only that lemma was re-checked, and it is now verified unconditionally; issue B01 is marked resolved |
| **Condition checked by a person** | A reader's check of Nesbitt's inequality is recorded. Proposition 2.2 **stays conditional** |

The progress table at each of these moments is in [TIMELINE.md](TIMELINE.md).

## The paper

[`paper/main.tex`](paper/main.tex) ([PDF](paper/main.pdf)), the same paper as [`bench/paper`](../../bench/paper/):

- **Lemma 2.1.** $ab \le \frac{a^2+b^2}{2}$ for all real $a, b$, with equality iff $a = b$.
- **Proposition 2.2.** For $x, y, z > 0$, $\frac{x}{y+z}+\frac{y}{z+x}+\frac{z}{x+y} \ge \frac{3(xy+yz+zx)}{2(x^2+y^2+z^2)}$. The proof cites Nesbitt's inequality (the left side is at least $3/2$) and uses Lemma 2.1.
- **Lemma 2.3 (planted error).** "For every real number $x \neq -1$, $\frac{x^2}{1+x} \ge x-1$", proved by "multiplying both sides by $1+x$". This silently assumes $1+x > 0$.

The authors' correction, [`paper-revised/main.tex`](paper-revised/main.tex) ([PDF](paper-revised/main.pdf)):

```diff
-For every real number $x \neq -1$ we have
+For every real number $x > -1$ we have
 ...
-Multiplying both sides by $1+x$, the claim is equivalent to
-$x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
+Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality, so the claim
+is equivalent to $x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
```

## The four steps

Each step was a new Claude Code session in the paper's project folder.

| Step | What was done | Outcome | Time | Cost* |
|---|---|---|---:|---:|
| 1 | Prompt 8.1: set up, check every result, write the report | 2.1 verified unconditionally; 2.2 verified conditionally; 2.3 issue recorded (`ERROR`) | 57 min | $21.20 |
| 2 | The revised files were put into `source/`, then prompt 8.3 | `/pv-revise` found that only Lemma 2.3 changed and reset only it. The lemma was re-checked and is now verified unconditionally; B01 resolved | 17 min | $5.06 |
| 3 | Prompt 8.4: the reader checked `P01_NesbittInequality` against Nesbitt (1903) and the standard proof by the rearrangement inequality | Recorded with `pv_status.py human-check`; 2.2 stays conditional | < 1 min | $0.15 |
| 4 | Prompt 8.5: the report | New report with "What the revision changed" (§0b) and a "Checked by a person" column; fact-checked | ≈ 20 min | $7.29 |

\* List-price estimates of the tokens used; the run was billed to a Claude plan. Total: $33.70.

## Where to look

| To see | Open |
|---|---|
| The final report | [results/report/AUTHOR_REPORT.md](results/report/AUTHOR_REPORT.md): §0 summary, §0b what the revision changed, §3 external inputs with who checked them |
| The report before the revision | [before-revision/report/AUTHOR_REPORT.md](before-revision/report/AUTHOR_REPORT.md): §4.1 the issue in Lemma 2.3 |
| How the issue was confirmed | [before-revision/audits/L02_issue_1.md](before-revision/audits/L02_issue_1.md) (ruling), [L02_issue_1_audit.md](before-revision/audits/L02_issue_1_audit.md) (independent review), [L02_Counterexample1.lean](before-revision/lean/L02_Counterexample1.lean) |
| How the correction was verified | [results/audits/L02_final.md](results/audits/L02_final.md), [results/BLOCKERS.md](results/BLOCKERS.md) (B01 `RESOLVED`), [results/RESULTS.json](results/RESULTS.json) (L02's `history` keeps the old verdict) |
| The condition of Proposition 2.2 | [results/lean/P01Stmt.lean](results/lean/P01Stmt.lean) (`NesbittInequality`) and [results/lean/P01.lean](results/lean/P01.lean) (`P01_main`) |
| The person's check | [results/report/EXTERNAL_TOOLS_WORKSHEET.md](results/report/EXTERNAL_TOOLS_WORKSHEET.md), and `human_checked` in [results/RESULTS.json](results/RESULTS.json) |
| What the fact-check corrected | [results/report/factcheck_of_first_draft.md](results/report/factcheck_of_first_draft.md) |

The key Lean statements:

```lean
-- Proposition 2.2: the cited result is an explicit hypothesis, never an axiom
def NesbittInequality : Prop :=
  ∀ x y z : ℝ, 0 < x → 0 < y → 0 < z →
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2

theorem P01_main (hN : NesbittInequality) (x y z : ℝ)
    (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) : P01Conclusion x y z

-- Lemma 2.3 as first printed, and its machine-checked refutation
def PrintedClause : Prop := ∀ x : ℝ, x ≠ -1 → x ^ 2 / (1 + x) ≥ x - 1

theorem counterexample : ¬ PrintedClause := by
  intro h
  have h2 := h (-2) witness_satisfies_printed_hypothesis
  norm_num at h2

-- Lemma 2.3 as revised: proved along the paper's route, no extra hypothesis
theorem L02_main (x : ℝ) (hx : x > -1) : x ^ 2 / (1 + x) ≥ x - 1
```

## How the folders map to a project

The reports cite paths inside the project folder. In this example:

| In the reports | Here |
|---|---|
| `source/` | `paper/` (first version) and `paper-revised/` (second version) |
| `pv_work/*.lean` | `results/lean/`; the superseded Lemma 2.3 files are in `before-revision/lean/` |
| `verification/audits/` | `results/audits/`; the issue files are in `before-revision/audits/` |
| `verification/report/` | `results/report/` and `before-revision/report/` |
| `verification/*.md`, `RESULTS.json` | `results/` and `before-revision/` |

Probes, logs, drafts and working notes are left out.

## Notes on this run

- **No result ended unfinished.** A result ends unfinished only when the kit stops for a reason that is not the paper's fault. The reasons are:
  - `TRANSLATION_BLOCKED`: a formalization obstacle;
  - `BUDGET_EXHAUSTED`: no progress within the attempt limits;
  - `GATE_FAILED`: the statement failed the gate twice;
  - `AUDIT_FAILED`: the proof failed the final audit twice;
  - `ISSUE_UNCONFIRMED`: a suspected issue that two reviews did not confirm.

  Unfinished is never counted as an error in the paper. The two unfinished states above were intermediate.
- **The human check was simulated.** The test prompt stated that a reader had checked the citation. The record (who, when, against what) is exactly what the kit stores for a real check.
- **`L02_mech.md` ends with `MECH CHECKS: FAIL (probe)`.** This was a false alarm of the mechanical-check script on a statement file that declares nothing. The final audit identified it, completed the check by hand, and did not count it ([L02_final.md](results/audits/L02_final.md) §1). The script was fixed afterwards (see [CHANGELOG](../../CHANGELOG.md)).
- **The report mentions a kit upgrade at 20:57 ("1.3 -> 1.3").** Between steps 3 and 4, the project was brought up to date with `install.sh --upgrade` to fix the wording of the report prompt; see [bench/results/WORKFLOW_TEST.md](../../bench/results/WORKFLOW_TEST.md).

## Run it yourself

With the guided setup (README, *Quick start*), add: *"I want to run a paper: call it fullworkflow. The files are in tex-proof-check-kit/examples/full-workflow/paper."*
- Before step 2, replace the files in the project's `source/` with those in `paper-revised/`.
- Then send the prompts of guide §8.3, §8.4 and §8.5.

Expect about 1.5 hours and $35 at list price. Verdicts should match; times, costs and the wording of the reports vary between runs.

# Example: two lemmas, one correct and one wrong

A one-page paper made for trying the kit: [`paper/demo.tex`](paper/demo.tex) ([PDF](paper/demo.pdf)).

> **Lemma 1.** For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$.
> *Proof.* We have $a^2 + b^2 - 2ab = (a-b)^2 \ge 0$.
>
> **Lemma 2.** For every real number $x$ we have $x^2 \ge x$.
> *Proof.* We have $x^2 - x = x(x-1)$. The two factors $x$ and $x-1$ always have the same sign, so their product is nonnegative, and hence $x^2 \ge x$.

Lemma 2 has a planted error: for $0 < x < 1$ the two factors have opposite signs, and the lemma is false.

## What the kit produced

This is the real output of one run (2026-10-01, Sonnet main session, roles on their default models), copied into [`results/`](results/). Local paths were removed, and one aside in `results/audits/L02_gate.md` that referred to an unrelated earlier project was replaced by `[…]`; nothing else was edited.

**Progress table** ([`results/report/progress_table.md`](results/report/progress_table.md)):

| No. | Verdict | Summary |
|---|---|---|
| Lemma 1 | **Verified unconditionally** | Both steps of the paper's proof hold; no external input |
| Lemma 2 | **Issue recorded** (`ERROR`) | False on 0 < x < 1, witness x = 1/2; independently reviewed Lean counterexample; does not affect Lemma 1 |

**Lemma 1, proved along the paper's route** ([`results/lean/L01.lean`](results/lean/L01.lean)). Each step of the paper is one Lean obligation, and the main theorem is assembled from them:

```lean
theorem L01_S1 (a b : ℝ) : a ^ 2 + b ^ 2 - 2 * a * b = (a - b) ^ 2 := by ring
theorem L01_S2 (a b : ℝ) : (a - b) ^ 2 ≥ 0 := by exact sq_nonneg (a - b)
theorem L01_main (a b : ℝ) : a ^ 2 + b ^ 2 ≥ 2 * a * b := by
  have h1 := L01_S1 a b
  have h2 := L01_S2 a b
  ...
```

**Lemma 2, refuted in Lean** ([`results/lean/L02_Counterexample1.lean`](results/lean/L02_Counterexample1.lean)). The printed statement is encoded word for word, then refuted:

```lean
def PrintedLemma2 : Prop := ∀ x : ℝ, x ^ 2 ≥ x

theorem not_printedLemma2 : ¬ PrintedLemma2 := by
  intro h
  have h2 := h (1 / 2 : ℝ)
  norm_num at h2
```

The same file also proves:
- that the encoding is exactly the gated statement (`printedLemma2_eq_gated_statement … := rfl`);
- that the false step is "the two factors always have the same sign";
- the exact failure region (`x ^ 2 < x ↔ 0 < x ∧ x < 1`);
- that the authors' obvious fix, "$x \le 0$ or $x \ge 1$", makes the lemma true. This is a suggestion only; it does not enter any verdict.

An independent auditor then reviewed the counterexample ([`results/audits/L02_issue_1_audit.md`](results/audits/L02_issue_1_audit.md), last line `COUNTEREXAMPLE VALID`).

**The report** ([`results/report/AUTHOR_REPORT.md`](results/report/AUTHOR_REPORT.md)) has a summary table at the top, then each verdict, the issue with its exact location, and what a person still has to check. Two details from this run:
- **The fact-check caught the report itself.** An independent fact-check of the first draft found a fix suggestion that no audit record supports: the coordinator had added "restate it for integers". The final report labels that suggestion an unverified remark ([`results/report/factcheck_of_first_draft.md`](results/report/factcheck_of_first_draft.md)).
- **The auditor did not trust a tool blindly.** The audit script reported one false failure on Lemma 1: it could not fingerprint an intentionally empty statement file. The auditor recognised this, redid that check by hand, and recorded a fix for the kit ([`results/audits/L01_final.md`](results/audits/L01_final.md)). The fix is in the current version.

## Time and cost of this run

| | Time | Cost (list-price estimate) |
|---|---:|---:|
| Both verdicts | ≈ 22 min | ≈ $9 |
| Plus the report (compilation and fact-check) | 39 min in total | $13.79 in total |

A second run with kit v1.5.0 on 2026-10-30 (unattended driver with `--report`; models `claude-sonnet-5-5` and `claude-opus-5-5`) gave the same two verdicts, report included, in 17 minutes for $4.05 at list prices. The files in `results/` are from the first run.

Two lemmas take this long because every result passes through separate, independent roles: drafting, gate, proving and final audit, each a fresh agent. That fixed cost is the price of the independent checks. On real papers the proving dominates.

## Run it yourself

**Guided.** In the folder that contains the kit (see the main [README](../../README.md)), start a new Claude chat and send:

```
Read kappa/CLAUDE_START_HERE.md and follow it. I want to run the demo paper: call it demo. The files are in kappa/examples/two-lemmas-demo/paper.
```

Then follow Claude's instructions: open `papers/demo-check`, start a new chat, choose Sonnet, and paste `START_PROMPT.txt`. For a shorter run without the report, paste [`DEMO_PROMPT_no_report.txt`](DEMO_PROMPT_no_report.txt) instead.

**By hand.** Install a project with `install.sh` ([docs/QUICKSTART.md](../../docs/QUICKSTART.md)), copy `paper/*` into its `source/`, and send the start prompt of [docs/GUIDE_EN.md](../../docs/GUIDE_EN.md) section 8.1 with `source/demo.tex`.

**Then the correction.** [`paper-corrected/`](paper-corrected/) restricts Lemma 2 to "$x \le 0$ or $x \ge 1$" and fixes its proof. Replace the files in `source/` with it and send the revision prompt (GUIDE section 8.3). Only Lemma 2 is re-checked; it should become "verified unconditionally", and the earlier issue is then marked resolved. The same flow was tested on another paper (re-checking one lemma took about $5); this exact correction was not run.



## Files

| Path | Content |
|---|---|
| `paper/` | the demo paper: `.tex`, `.pdf`, `.aux` |
| `paper-corrected/` | the corrected version, for trying a revision |
| `DEMO_PROMPT_no_report.txt` | the start prompt without the report step |
| `results/report/` | the final report, files-to-check index, external-input worksheet, fact-check of the first draft, progress table |
| `results/lean/` | the statement files, Lemma 1's proof, Lemma 2's draft and counterexample |
| `results/audits/` | gate reports, final audit of Lemma 1, mechanical checks, issue ruling and its independent review |
| `results/BLOCKERS.md`, `results/PAPER_VERIFICATION.md` | the issue record and the checklist |

Paths inside these files refer to the project they were produced in (`source/`, `pv_work/`, `verification/`).

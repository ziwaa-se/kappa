# Check summary: Variance bounds for proportions and sums

Made by KAPPA 1.5.0 on 2026-10-30 20:13 from this project's records (`verification/RESULTS.json`, `verification/BLOCKERS.md`), with fixed wording and without a language model. It is a short account of the check for readers who did not run it; `AUTHOR_REPORT.md` is the full one.

## What was checked

- **Paper:** Variance bounds for proportions and sums (`source/main.tex`).
- **Numbered results:** 6 (3 lemmas, 3 propositions).
- **Proof assistant:** Lean v4.19.0.
- **How:** the proof of each result was translated into Lean 4 along the paper's own argument. Before any proving, an independent agent compared each Lean statement with the paper; after it, another agent audited the finished proof, and a script checked that it compiles with no `sorry` and only Lean's three standard axioms. Cited or unproved inputs became named hypotheses, never hidden axioms.

## Verdicts

**3 verified unconditionally · 0 verified conditionally · 3 with an issue recorded · 0 unfinished.**

| No. | Result | Verdict | Conditions, issues, or where it stopped |
|---|---|---|---|
| 2.1 | Lemma (L01): quarter bound | Verified (unconditional) | Lemma 2.1 verified unconditionally. |
| 2.2 | Lemma (L02): positivity of variance | Issue recorded | Lemma 2.2 proved for I=(0,1); I open/closed not stated and the lemma is false on [0,1] at p=0,1 (DOMAIN_CLARIFICATION). |
| 2.3 | Proposition (P01): midpoint concavity of sqrt | Verified (unconditional) | Proposition 2.3 verified unconditionally (I read as [0,1]; concavity of sqrt(p(1-p)) derived from mathlib). |
| 2.4 | Lemma (L03): linear bound | Issue recorded | Lemma 2.4 is false as printed (n=1, p=1/10); step main.tex:70 does not follow from Lemma 2.1 (ERROR). |
| 2.5 | Proposition (P02): uniform bound in n | Verified (unconditional) | Proposition 2.5 verified unconditionally (C=1/4 via Lemma 2.1). |
| 2.6 | Proposition (P03): sample variance of sum | Issue recorded | Proposition 2.6: proof step main.tex:86 is false (missing cross term); conclusion not refuted (PAPER_ARGUMENT_GAP). |

*Verified unconditionally*: the paper's proof of the whole statement compiles in Lean with no unproved input. *Verified conditionally*: it compiles, but assumes the conditions listed below. *Issue recorded*: an independently confirmed problem in the result's own statement or proof. *Unfinished*: not decided; never counted as an error in the paper.

## Issues

| Issue | Result | Class | Status | In one sentence |
|---|---|---|---|---|
| B1 | 2.2 (L02) | DOMAIN_CLARIFICATION | open | the source never says whether the unit interval I is open or closed; Lemma 2.2 is true (and Lean-proved) on (0,1) and false at p=0 and p=1 on [0,1]. |
| B2 | 2.6 (P03) | PAPER_ARGUMENT_GAP | open | the proof's first step "s²(x+y) = s²(x) + s²(y)" omits the cross term 2·cov(x,y) and is false for every m ≥ 2; the printed proposition is not refuted. |
| B3 | 2.4 (L03) | ERROR | open | Lemma 2.4 (V_n(p) ≤ p/(4n) for p ∈ I) is false as printed; the proof's step does not follow from Lemma 2.1, which gives only V_n(p) ≤ 1/(4n). |

- `ERROR`: the printed statement is false: a counterexample satisfies all its hypotheses.
- `PAPER_ARGUMENT_GAP`: the justification given for a step does not hold; the conclusion may still be true.
- `DOMAIN_CLARIFICATION`: the domain or object is ambiguous, and the conclusion depends on the reading.

## Conditions

No verdict depends on a condition.

## What was not checked

- **The conditions** above: they are assumed, not proved.
- **Whether each Lean statement says what the paper says, and whether the basic definitions match the paper.** Independent agents compared them, but a person should read them; `FILES_TO_CHECK.md` lists where they are.
- **Claims without a number** (remarks, statements in the text): the check covers numbered results only; `verification/INVENTORY.md` lists the unnumbered claims it found.
- **Anything outside the proofs:** motivation, simulations, data analyses, and whether the results are new or important.

## Where the evidence is

- `verification/report/VERIFICATION_GRAPH.html`: the verification graph: every result, its verdict and dependencies, in a browser.
- `verification/report/AUTHOR_REPORT.md`: the full report: each verdict, the issues with their locations and the suggested fixes from the audits, and the human-check list.
- `verification/report/FILES_TO_CHECK.md`: for each result: place in the paper, Lean theorem, audit report.
- `verification/report/EXTERNAL_TOOLS_WORKSHEET.md`: every condition with its exact Lean text, by risk.
- `verification/BLOCKERS.md`: the complete issue records, with the evidence.
- `pv_work/`: the Lean files.

Anyone can rebuild the Lean files and rerun the mechanical audit without a language model, with the kit's `examples/tools/replay.py`.

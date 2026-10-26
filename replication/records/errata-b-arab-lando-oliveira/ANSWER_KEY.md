# Errata case B — Arab, Lando and Oliveira, "Convex combinations of random variables stochastically dominate the parent for a new class of heavy tailed distributions": answer key

Written before the run from the corrigendum (Electron. Commun. Probab. 31 (2026), article 35; `correction/corrigendum.pdf`).
The run checks arXiv v2 (2411.14926v2, before the correction; CC BY 4.0), the whole paper, blind.

The corrigendum: "The original paper contains an error in the argument of the second part of the proof of Theorem 3.1,
the main result in the paper." In the induction step, after a chain of inequalities that is still correct, the proof
argues that the large parenthesis $\bar F_X(x) - \bar F_X(x/\theta_n) - \bar F_X(x/(1-\theta_n))$ is negative by
subadditivity and concludes $P(\theta_1X_1+\dots+\theta_nX_n > x) \ge \bar F_X(x/\theta_n) + \bar F_X(x/(1-\theta_n))$;
that conclusion would need the parenthesis to be positive, so the step is invalid. The statement of Theorem 3.1 is
true; the corrigendum gives a new induction step.

| No. | Result | Expected | Basis | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| **Thm 3.1** | **$X$ InvSub ⇒ $X \le_{st} \theta_1X_1+\dots+\theta_nX_n$** | **ISSUE, `PAPER_ARGUMENT_GAP`** (induction step) | the corrigendum; the base case $n = 2$ is correct | the issue found with the class `PAPER_ASSUMPTION_GAP`, counted as found with another class | `ERROR` (the statement is true); a verified verdict |
| Prop 3.3 | $X$ InvSub ⇒ $\mathbb{E}X = \infty$ | CONDITIONAL, on the clause of Theorem 3.1 (provenance (iv)) | "immediate" from Theorem 3.1 and Proposition 3.2 | — | UNCONDITIONAL |
| Thm 4.2 | adapted from Chen et al. (2024) | CONDITIONAL (cited, (i), or through Theorem 3.1, (iv)) | a cited result, adapted | — | an issue, unless confirmed by hand |
| Lemma 2.3, Prop 2.5, Thm 2.8, Prop 3.2, Prop 4.6, Thm 4.8, Lemma 4.10, Thm 4.12, Section 5 results | — | verified (unconditional, or conditional on cited results) | no known error | — | an issue, unless checked by hand and confirmed (then it is a new finding) |
| Prop 4.3, Thm 4.11, Thm 4.15 | statements of results of other papers | CONDITIONAL on the cited result, or not registered as results of this paper | cited without proof | — | — |

What counts as finding the published error: an issue on Theorem 3.1 located in the induction step.

Contamination: the paper (2025) and the corrigendum (2026) postdate the models' training data.

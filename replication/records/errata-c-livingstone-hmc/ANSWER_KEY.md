# Errata case C — Livingstone, Betancourt, Byrne and Girolami, "On the geometric ergodicity of Hamiltonian Monte Carlo": answer key

Written before the run from the authors' corrigendum, Appendix D of arXiv v5 (1601.08057v5, 8 September 2026;
`arxiv-v5/source/corrigendum_arxiv.tex`). The run checks arXiv v4 (1601.08057v4, the published Bernoulli version,
before the correction), blind.

**Scope (chosen by us, stated in the setup prompt and in the paper):** Theorem 2.2, Corollary 2.3 part (ii), Theorem
5.14 and Lemmas 5.15–5.17. Corollary 2.3 part (i) (the positive results) is outside the scope. Other results of the
paper that these proofs use (Theorem 5.18, Propositions on rejection probabilities and tightness) are inputs of
provenance (ii), not checked. The scope contains results without known errors, so it does not point at the error.

| No. | Result | Expected | Basis | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| Lemma 5.15 | $\lVert x_\varepsilon\rVert > 2\lVert x_0\rVert$ for large $\lVert x_0\rVert$, under (17) | verified | no known error | — | an issue, unless confirmed by hand |
| **Lemma 5.16** | **$\lVert x_{L\varepsilon}\rVert \ge 2^L \lVert x_0\rVert$, stated under (17) alone** | **ISSUE, `PAPER_ASSUMPTION_GAP`** | the proof invokes condition (18), which the lemma does not assume (the corrigendum: "Lemma 5.16 is stated under condition (17) alone, but its proof invokes condition (18)"); the statement is true, with a different proof | `PAPER_ARGUMENT_GAP`; UNFINISHED with the missing hypothesis named | `ERROR`; a verified verdict that silently adds (18) |
| Lemma 5.17 | acceptance probability tends to 0, under (17)–(19) | verified (possibly conditional) | no known error (a symbol slip, $\delta_L$ for $\gamma_L$, is editorial) | an editorial note | an issue, unless confirmed by hand |
| Theorem 5.14 | (17)–(19) imply HMC is not geometrically ergodic | CONDITIONAL: on the clause of Lemma 5.16 (provenance (iv)) and on the cited/stated result on rejection probabilities (ii) | its proof uses Lemma 5.16 | the same with geometric ergodicity encoded as an explicit parameter | UNCONDITIONAL; ISSUE |
| Theorem 2.2 | (i) light tails, (ii) heavy tails: not geometrically ergodic | CONDITIONAL: part (i) through Theorem 5.14, part (ii) through Theorem 5.18 (input (ii)) | an overview result proved by the later theorems | UNFINISHED if the kit finds no proof of its own and says so | ISSUE |
| **Corollary 2.3 (ii)** | **not geometrically ergodic for $\beta < 1$ or $\beta > 2$** | **ISSUE, `PAPER_ARGUMENT_GAP`, for $2 < \beta < 1 + \log_2 3$** | the proof is "a direct consequence of Theorem 2.2", but condition (18) of Theorem 2.2(i) fails for $\mathcal{E}(\beta,\alpha)$ when $2 < \beta < 1 + \log_2 3 \approx 2.585$: for $\lvert y\rvert = 2\lvert x\rvert$ the gradient ratio is $2^{\beta-1} < 3$. The statement is true (the corrigendum proves it with a corrected condition), so it is not an `ERROR`. A Lean refutation of (18) at, e.g., $\beta = 5/2$ is welcome evidence | the issue found with the range stated more loosely (e.g. "for some $\beta > 2$") | a verified verdict for the whole part (ii) |

What counts as finding the published error: an issue on Corollary 2.3(ii) that names the failure of condition (18)
for some $\beta$ in $(2, 1+\log_2 3)$. Finding the gap in Lemma 5.16 is the second, minor correction.

Contamination: the paper is from 2019, but the corrigendum is from September 2026, after the models' training data.

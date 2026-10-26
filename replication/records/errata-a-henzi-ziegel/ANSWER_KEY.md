# Errata case A — Henzi and Ziegel, "Valid sequential inference on probability forecast performance": answer key

Written before the run from the published correction (Biometrika 109(4), 1181–1182; open access, CC BY; its content
as summarised in `../CANDIDATES.md`, to be re-read in full from `correction/correction.pdf` before scoring) and from
arXiv v3 (2103.08402v3, after the correction). The run checks arXiv v2 (2103.08402v2, before the correction), the
whole paper, blind: no correction, no answer key and no network in the run folder.

Numbering: arXiv v2 numbers results by section; the journal's Proposition 2 is v2's Proposition 3.5.

| No. (v2) | Result | Expected | Basis | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| Thm 3.1 | characterisation of e-values for $H_S$ with a consistent scoring function | verified (unconditional or conditional on cited representation results) | no known error | — | an issue, unless checked by hand and confirmed |
| Thm 3.2 | the GROW choice of $\lambda$ and the GROW e-value | verified (unconditional or conditional) | no known error | — | an issue, unless confirmed by hand |
| Thm 3.3 | GROW e-value for $H$ (all scores) is the likelihood ratio | CONDITIONAL on Grünwald et al., Theorem 1 (cited, provenance (i)) | the proof applies a cited theorem | verified, if the cited theorem is not needed after all (then explain) | an issue, unless confirmed by hand |
| Prop 3.4 | the averaged lag-$h$ products $e_T$ are e-values | verified | true: along each residue class the products have conditional expectation at most one | — | an issue |
| **Prop 3.5** | **$\mathbb{E}(e_\tau) \le 1$ for every a.s. finite stopping time $\tau$** | **ISSUE, `ERROR`** | false for $h > 1$: the correction gives a counterexample with $h = 2$ and proves the bound only for $e$ at time $\tau + h - 1$; the printed argument ("directly follows from the fact that the $\lambda_t$ can be any adapted sequence") does not give it, as the paper's own following paragraph half-admits | `PAPER_ARGUMENT_GAP` counts as **found** but with the weaker class (the kit saw that the argument fails without refuting the claim); report it as such | a verified verdict; an issue only for $h = 1$ |

Unnumbered claims: the anytime-valid p-value $\min(1, \inf_s 1/e_s)$ is valid only for $h = 1$ (also corrected). The kit
lists unnumbered claims separately; finding this one is a bonus, not part of the score.

Contamination: the paper (2021) and the correction (2022) are older than the models' training data may be; a
correct finding is reported together with this caveat.

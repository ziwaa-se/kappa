# E2 "Variance bounds for proportions and sums": answer key

Written before the run, kept outside the run folder, never copied into it.

The setting calls $I$ "the unit interval" without saying whether its endpoints belong to it. Every result except 2.2
holds under both readings, $[0,1]$ and $(0,1)$.

| No. | Result | Expected verdict | Expected classification / inputs | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| 2.1 | $p(1-p) = \frac14 - (p-\frac12)^2$, so $V_n(p) \le \frac1{4n}$ | UNCONDITIONAL | — | — | anything else |
| 2.2 | $V_n(p) > 0$ for $p \in I$ | ISSUE, `DOMAIN_CLARIFICATION` | true for $I = (0,1)$, false at $p \in \{0, 1\}$ for $I = [0,1]$; the report should give both readings | ISSUE `ERROR` with the counterexample $p = 0$, provided the report states the reading $[0,1]$ and that the result holds for $(0,1)$; a gate decision that fixes $I = (0,1)$ globally and records it, followed by UNCONDITIONAL, provided the reading is reported prominently | UNCONDITIONAL with no mention of the reading |
| 2.3 | midpoint concavity of $\sqrt{V_n}$ on $I$ | CONDITIONAL | one input of provenance (ii): the concavity of $p \mapsto \sqrt{p(1-p)}$ on $I$, asserted ("well known") but not proved by the paper | the same input labelled (v) if the kit finds no Mathlib interface and says so | UNCONDITIONAL (the kit must not supply the proof the paper omits); an issue |
| 2.4 | $V_n(p) \le \frac{p}{4n}$ for $p \in I$ | ISSUE, `ERROR` | false under both readings: $p = \frac12$ gives $\frac1{4n} > \frac1{8n}$; Lemma 2.1 bounds $p(1-p)$ by $\frac14$, not by $\frac p4$. A Lean counterexample is expected | — | a verified verdict |
| 2.5 | there is $C$ with $V_n(p) \le C/n$ for all $n \ge 1$, $p \in \mathbb{R}$ | UNCONDITIONAL | the constant does not depend on $n$; a draft with $\forall n\, \exists C$ is unfaithful (`ENCODING_ERROR`) and the gate should reject it if it occurs | — | a verified statement with the quantifiers in the wrong order |
| 2.6 | $s^2(x+y) \le 2s^2(x) + 2s^2(y)$ | ISSUE, `PAPER_ASSUMPTION_GAP` or `PAPER_ARGUMENT_GAP` | the first equality needs the sample covariance of $x$ and $y$ to vanish, which is not assumed (counterexample to the step: $x = y = (1,-1)$, where $s^2(x+y) = 8 \ne 4$). The conclusion is true, since $(a+b)^2 \le 2a^2 + 2b^2$ termwise. Both classes describe this defect (a missing hypothesis for the step; a false intermediate assertion); either is a correct answer | — | `ERROR` (the printed conclusion is true); a verified verdict |

Dependencies: 2.4 and 2.5 use 2.1.

Not covered by this paper, although the design first assigned it here: an input of provenance (iii). Every fact the
proofs use silently is derivable here, so the kit should treat such steps as fair implicit steps, not as inputs.

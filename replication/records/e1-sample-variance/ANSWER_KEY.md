# E1 "Elementary bounds on the sample variance": answer key

Written before the run, kept outside the run folder, and never copied into it. The run is scored against it
afterwards; every difference is reported.

Notation: $s^2 = \frac{1}{n-1}\sum_i (x_i-\bar x)^2$ for $n \ge 2$, $s = \sqrt{s^2}$.

| No. | Result | Expected verdict | Expected classification / inputs | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| 2.1 | $\sum_i (x_i-\bar x) = 0$ | UNCONDITIONAL | — | — | anything else |
| 2.2 | $\sum_i (x_i-\bar x)^2 = \sum_i x_i^2 - n\bar x^2$ | UNCONDITIONAL | the computation "expanding the square" is a `FAIR_IMPLICIT_STEP`, not an issue | — | an issue |
| 2.3 | $a \le x_i \le b \Rightarrow s^2 \le \frac{n}{n-1}\frac{(b-a)^2}{4}$ | CONDITIONAL | one external input, provenance (i): Popoviciu's inequality on variances, cited, not proved in the paper | — | UNCONDITIONAL (the kit must not prove a cited result itself); an issue |
| 2.4 | Samuelson: $\lvert x_i-\bar x\rvert \le \frac{n-1}{\sqrt n}\, s$ | ISSUE, `EXPOSITION_GAP` | the proof divides by $s$; the case $s = 0$ is not covered. The statement is true in that case (all $x_j = \bar x$, both sides 0), so it is not an `ERROR` | UNCONDITIONAL, if the kit fills in the case $s = 0$ as a `FAIR_IMPLICIT_STEP` and says so | `ERROR`; any claim that the inequality is false |
| 2.5 | $s^2 \le \frac1n\sum_i x_i^2$ | ISSUE, `ERROR` | false: $x = (1,-1)$ gives $s^2 = 2 > 1 = \frac1n\sum_i x_i^2$. The proof divides $(n-1)s^2 \le \sum_i x_i^2$ by $n$ instead of $n-1$. A Lean counterexample is expected | — | a verified verdict |
| 2.6 | $\lvert x_i\rvert \le 1 \Rightarrow s^2 \le 2$ | CONDITIONAL | the statement is true ($s^2 \le \frac{n}{n-1} \le 2$), but the paper's proof uses Lemma 2.5, which is false: a condition of provenance (iv) on the clause of 2.5 it uses, with 2.5's issue as an upstream issue | — | UNCONDITIONAL (would mean a proof by another route, which the kit must not supply); ISSUE (the result's own statement and proof step are fine apart from the cited lemma) |

Dependencies: 2.4 uses 2.1; 2.5 uses 2.2; 2.6 uses 2.5.

Shared definitions (for `source_defs`): the sample mean (Definition 1.1), the sample variance and standard deviation
(Definition 1.2).

Things the run may show but the key does not require: a gate rejecting a draft (e.g. a drafted 2.4 that assumes
$s > 0$, which would hide the gap); predecessor clauses (p) and reconnection if results are drafted in parallel.

# E3 "The oracle risk of linear shrinkage": answer key (two rounds)

Written before the runs, kept outside the run folder, never copied into it.

Setting: $\theta \ne 0$, $\sigma > 0$; $R(c) = c^2\sigma^2 + (1-c)^2\theta^2$, $c^\ast = \theta^2/(\theta^2+\sigma^2)$,
$\rho = \theta^2\sigma^2/(\theta^2+\sigma^2)$ (Definition 1.1: three objects, so three definition IDs).

## Round 1: the original version (`paper/`)

| No. | Result | Expected verdict | Expected classification / inputs | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| 2.1 | $R(c) - \rho = (\theta^2+\sigma^2)(c-c^\ast)^2$ | UNCONDITIONAL | — | — | anything else |
| 2.2 | $\rho \le \min\{\theta^2,\sigma^2\}$ | ISSUE, `PAPER_ARGUMENT_GAP` | the proof claims that the harmonic mean of two positive numbers is at most the smaller one, which is false (the harmonic mean lies between them; e.g. $\theta^2 = 1$, $\sigma^2 = 3$ gives harmonic mean $3/2 > 1$), and its intermediate bound $\rho \le \frac12\min\{\theta^2,\sigma^2\}$ is false for the same values ($\rho = 3/4$). The conclusion is true ($\rho = \theta^2 \cdot \frac{\sigma^2}{\theta^2+\sigma^2} < \theta^2$, and symmetrically). A Lean refutation of the intermediate step is welcome evidence | — | `ERROR` (the printed conclusion is true); a verified verdict |
| 2.3 | $R(c) \ge \rho$ with equality iff $c = c^\ast$; $\rho \le \min\{R(0),R(1)\}$ | CONDITIONAL | the first clause is unconditional; the second uses Lemma 2.2, so the result is conditional on a (iv) clause of 2.2 (predecessor 2.2), with 2.2's issue as an upstream issue | — | UNCONDITIONAL (a different proof of the second clause); ISSUE |
| 2.4 | $R(c^\ast) \le R(1/2)$ | UNCONDITIONAL | the proof's second sentence cites Lemma 2.2, but the conclusion does not need it: an input for 2.2's clause, if drafted, is unused ("formal only", mechanical item 11) and is not a condition | CONDITIONAL on the 2.2 clause only if the report states that the clause is unused and why it was kept | ISSUE |

Dependencies: 2.3 and 2.4 use 2.1 and 2.2.

## Round 2: the revised version (`paper-revised/`, through `/pv-revise`)

Changes: the proof of 2.1 is rewritten (same statement); the proof of 2.2 is corrected (same statement); a sentence is
added inside Definition 1.1, after the definition of $\rho$, which shifts the lines but changes no definition.

| What | Expected |
|---|---|
| `defs-changed` | all three definitions `UNCHANGED` (at shifted lines); no result is case (c) |
| Reset by `/pv-revise` | 2.1 and 2.2 only (case (b)); 2.3 and 2.4 marked re-check pending, verdicts kept for now |
| Cascade decision | after the re-gates of 2.1 and 2.2: statements unchanged, so 2.3 and 2.4 get `recheck: rebuild`, not a reset |
| 2.1 | UNCONDITIONAL again |
| 2.2 | UNCONDITIONAL; its round-1 issue resolved with `record --resolve`, citing the new final audit |
| 2.3 | rebuild and mechanical re-check pass; then the (iv) clause of 2.2 is reconnected (`pv_status.py reconnect` lists it), so 2.3 becomes UNCONDITIONAL |
| 2.4 | rebuild and mechanical re-check pass; UNCONDITIONAL |
| `followup` | 2.2: Issue → Verified unconditionally (issue resolved); 2.3: Verified conditionally → Verified unconditionally |

Not acceptable in round 2: resetting 2.3 or 2.4 although the re-gated statements of 2.1 and 2.2 are unchanged
(that was the v1.3 behaviour); keeping 2.3 conditional on 2.2 after 2.2 is verified.

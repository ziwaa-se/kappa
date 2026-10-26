# Hand checks of findings that differ from the answer keys (E1–E4)

## E1 2.6 (release run): ISSUE PAPER_ARGUMENT_GAP instead of CONDITIONAL (iv) — the kit's reading is defensible

The key said the corollary's own proof step is fine apart from the cited lemma, so ISSUE is not acceptable. The
proof reads "By Lemma 2.5, $s^2 \le \frac1n\sum x_i^2 \le 1 \le 2$". The kit's issue B02 points out that the chain
asserts $s^2 \le 1$, which is false under the corollary's own hypotheses ($n = 2$, $x = (1,-1)$: $s^2 = 2$), and
that no repair of Lemma 2.5 alone makes the printed chain true: the corrected lemma gives $s^2 \le \frac{1}{n-1}\sum
x_i^2 \le \frac{n}{n-1}$, a different chain. On inspection this is correct, and the key's justification was too
generous. The score stays "differs" (keys are not changed after a run); the paper reports the disagreement and this
check. The pilot run (pre-release workspace) gave the key's answer, CONDITIONAL (iv): a borderline classification
that varies between runs.

## E2 2.3: UNCONDITIONAL instead of CONDITIONAL (ii) — the kit's rules allow both; we prefer the key

The kit's rules allowed both readings; version 1.3.2 keeps an explicitly asserted fact as an input.

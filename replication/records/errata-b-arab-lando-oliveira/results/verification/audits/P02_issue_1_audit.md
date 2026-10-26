# P02 issue 1: reasoning review of the ruling `verification/audits/P02_issue_1.md`

- Reviewer: pv-auditor (claude-opus-5-5), Mon Oct 12 22:24:27 EDT 2026
- Mode: reasoning review. The ruling is reasoning-only; its one Lean probe, `sqrt_strict_jensen_n`, is a positive side remark and is not needed for this review.
- Source read directly: `source/SuperParetoPaper-v12.tex` :88-107, :186-266, :269-273, :277, :323-325. I also searched for every use of `eq:main-st`.

## 1. Step-by-step check of the ruling

| Ruling claim | Check | Result |
|---|---|---|
| Quotes :95-99, :261-264, :266 | They match the source verbatim | OK |
| :266 gives no reduction argument for n -> 2 | Correct. Only the sentence "It is enough to prove the case $n=2$" appears | OK |
| R1: the $n$-fold dominance gives no two-fold dominance for the *same fixed instance*; grouping into $\theta_1X_1+(1-\theta_1)Z$ fails because $Z$ is not a copy of $X$ | Correct, and correctly marked as open, not refuted | OK |
| R2: steps (a)-(c) do not depend on $n$, and (d) is $n$-term strict Jensen on $\{\neg(X_1=\cdots=X_n)\}$ | Correct by inspection of :266 | OK |
| Not `ERROR`: the conclusion is true for all $n$ | Agreed for $X\ge0$. Signed $X$ falls under the separate nonnegativity issue, which the ruling keeps separate | OK |
| P03 is not affected, because Thm 3.1 (:188) gives eq:main-st for every $n$, including $n=2$ (:217) | Correct. P03 (:269) needs only one two-term instance | OK |
| "Why not DOMAIN_CLARIFICATION: both readings give the same result" | **Incomplete.** See §2. The readings R1 and R2 are readings of the *proof*. The ruling never considers the second reading of the *hypothesis* "If (eq:main-st) holds" at :263 | **Not OK** |

## 2. The missed reading: "(eq:main-st) holds" as a property of $X$

The paper uses "(eq:main-st) holds" in two ways:

- **As a property of $X$**, meaning for every $n$ and all weights: :103 ("(eq:main-st) holds if $X$ is ... super-Pareto"), :105, :107, :188 (Thm 3.1, "If $X$ is ITS, then the stochastic dominance (eq:main-st) holds", proved by induction on $n$, :191, :219), :277 ("families of distributions implying (eq:main-st)"), :323.
- **For one fixed instance** ($n$ and weights fixed): :102 ("if $\Mexp X<\infty$ and at least two coefficients are strictly positive, (eq:main-st) does not hold") and :217 / :219 ("holds for $n=2$", "holds whenever considering $n-1$ random variables").

At :263 the hypothesis "If (eq:main-st) holds" therefore has two readings:

- **(H-inst), fixed instance.** Here $X_1,\dots,X_n$ and $\theta_1,\dots,\theta_n$ are those fixed in the statement. This is the reading the gate encoded (`StDom` for the given `Xs`, `θ`). It is the more literal reading, because the statement fixes $n$ and $\theta_i$. Under it, the ruling's analysis holds: no reduction is given, and the cases $n\ge3$ are not covered.
- **(H-prop), property of $X$.** This is the paper's dominant usage, including in Thm 3.1, the result that Prop 3.2 is combined with at :269. Under it, the reduction at :266 is immediate and is a `FAIR_IMPLICIT_STEP`:
  1. The hypothesis contains the two-term instance for any $\theta\in(0,1)$.
  2. $\Prob(X_1=\cdots=X_n)<1$ for i.i.d. copies forces $X$ not to be a.s. constant.
  3. Then the given $X_1,X_2$ are independent copies of $X$ with $\Prob(X_1\ne X_2)>0$. Indeed, $\Prob(X_1=X_2)=1$ for independent copies would force $X$ to be a.s. constant. Also $n\ge2$ is forced, since for $n\le1$ the event $\{X_1=\cdots=X_n\}$ is the whole space.

  That is exactly what "It is enough to prove the case $n=2$" asserts. Under (H-prop) the sentence is justified, and there is no gap of any kind for $n\ge3$. The weights $\theta_i$ in the statement are then idle.

So whether the paper has a gap at :266 depends on which reading of :263 is meant, and the source supports both. This is the situation `DOMAIN_CLARIFICATION` is for. The ruling's stated reason for excluding it ("both readings give the same, true, mathematical result") concerns R1 versus R2. It does not address (H-inst) versus (H-prop).

Under (H-inst), the choice between `EXPOSITION_GAP` (the ruling's choice, reading :266 as "the general case is analogous") and `PAPER_ARGUMENT_GAP` (reading "enough" as an asserted reduction that is never supplied) is borderline. The ruling's choice is defensible, and it flags this point for a human check. I do not object to that sub-choice.

## 3. Conclusion threat and scope

- The conclusion is not threatened. Under either reading, Prop 3.2 is true for nonnegative $X$. Under (H-prop) the hypothesis is stronger and the statement weaker. I confirm `THREATENS CONCLUSION: no` and "not `ERROR`".
- I confirm that P03 is unaffected by this issue under both readings. Under (H-inst), P03 uses the two-term instance from Thm 3.1. Under (H-prop), it uses the full property from Thm 3.1.
- Scope of the ruling: under (H-inst), it correctly limits the affected part to $n\ge3$.
- Encoding: the gate's (H-inst) encoding is literal and legitimate (not an `ENCODING_ERROR`). The issue record should still say that under (H-prop), S1 would be a fair one-step reduction, not a gap. This affects how the authors' text is judged: "the paper omits $n\ge3$" holds only under (H-inst).

## 4. Suggested fix

The ruling's fix ("the general case is identical, with ... strict Jensen on $\{X_1=\cdots=X_n\}^c$") works for (H-inst). I checked it: steps (a)-(c) do not depend on $n$, and (d) holds on an event of positive probability. The nonnegativity issue must still be fixed separately. A second minimal fix would remove the ambiguity instead: state the hypothesis as "(eq:main-st) holds for $n=2$ and some $\theta\in(0,1)$", or "for all $n$ and weights". That would make the first sentence of :266 correct, or unnecessary. Either fix suffices. Both are reviewer suggestions, not evidence.

## 5. Finding

- Confirmed: no `ERROR`; the conclusion is not threatened; P03 is not affected; S1 should not be closed under the gated (H-inst) encoding; the fix is sufficient under (H-inst).
- Not confirmed: the classification as stated. The ruling's claim that "the reduction is unsupported" holds only under the fixed-instance reading of :263. Under the paper's dominant property reading (:103-107, :188, :277, :323), the reduction is a fair implicit step. The correct classification is `DOMAIN_CLARIFICATION`: the meaning of "(eq:main-st) holds" at :263 is ambiguous. Under the gated (H-inst) reading it amounts to an `EXPOSITION_GAP` for $n\ge3$, and under (H-prop) it is no gap.
- Records to update: the issue record for P02 issue 1 should be reclassified with both readings stated, and a human check should be requested on which reading the authors intend.

REVIEW: NOT CONFIRMED

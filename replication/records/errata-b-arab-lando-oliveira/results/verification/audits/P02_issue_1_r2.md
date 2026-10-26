# P02 issue 1, second ruling (r2): "It is enough to prove the case n=2" (source :266)

- Checker: pv-issue-checker (claude-opus-5-5), Mon Oct 12 22:25:19 EDT 2026
- Supersedes the classification in `verification/audits/P02_issue_1.md` (r1). The r1 analysis of the proof readings R1/R2, its probe, the scope and the P03 conclusion are kept unless stated otherwise below.
- Responds to `verification/audits/P02_issue_1_audit.md` (REVIEW: NOT CONFIRMED).
- Status: reasoning only (plus the r1 positive probe). **Not confirmed** until a new pv-auditor reasoning review passes.

## 1. The objection, checked against the source

The auditor says r1 considered two readings of the *proof* (R1 reduction / R2 "n=2 is representative") but not two readings of the *hypothesis* "If (eq:main-st) holds" at :263. I re-read the source myself.

**The phrase is used as a property of $X$, for all $n$ and all weights:**
- :103 "(eq:main-st) holds if $X$ is an increasing convex transformation of a Pareto ..."
- :105 "a new family ... for which (eq:main-st) is verified"
- :107 "we show that (eq:main-st) holds under the subadditivity ..."
- :188 Thm 3.1 "If $X$ is ITS, then the stochastic dominance (eq:main-st) holds", proved by induction over all $n$ (:191, :219)
- :277 "families of distributions implying (eq:main-st)"
- :323 "Theorem 3.1 implies (eq:main-st)"

**The phrase is used for one fixed instance ($n$ and $\theta_i$ fixed):**
- :102 "if $\Mexp X<\infty$ and at least two coefficients are strictly positive, (eq:main-st) does not hold". This is the informal fixed-instance version of Prop 3.2 itself.
- :217 "(eq:main-st) holds for $n=2$", and :219 "holds whenever considering $n-1$ random variables".

Prop 3.2 (:263) first fixes $X_1,\ldots,X_n$ and $\theta_1,\ldots,\theta_n>0$, then says "If (eq:main-st) holds". The literal reading is fixed-instance, supported by :102. The paper's dominant usage, including in Thm 3.1, which Prop 3.2 is combined with at :269, is the property reading. **The objection is correct.** The source supports both readings, and r1's reason for excluding `DOMAIN_CLARIFICATION` ("both readings give the same result") addressed only R1/R2, not this question.

## 2. Both readings and the result under each

**(H-inst), fixed instance.** This is the gated encoding: `StDom μ X (∑ θ i * Xs i)` for the given `Xs`, `θ`.
- :266 gives no reduction of the fixed $n$-instance to a two-term instance. The grouping $\theta_1X_1+(1-\theta_1)Z$ fails because $Z$ is not a copy of $X$ (r1 §2).
- The cases $n\ge3$ are not covered by the written proof. The :266 argument carries over verbatim: steps (a) to (c) are independent of $n$, and (d) is $n$-term strict Jensen on $\{X_1=\cdots=X_n\}^c$. The r1 probe `sqrt_strict_jensen_n` (EXIT=0, standard axioms) supports the pointwise form of (d).
- Under this reading the issue is `EXPOSITION_GAP` for $n\ge3$, as in r1. A literal-reduction reading of "enough" would make it `PAPER_ARGUMENT_GAP` instead. The auditor accepts this sub-choice as defensible.
- Result: true for $X\ge0$ (signed $X$ is the separate nonnegativity issue).

**(H-prop), property of $X$**, meaning $X\leqst\sum\theta_i'X_i'$ for every $n'$, all weights and i.i.d. copies. Then "enough to prove $n=2$" is a fair one-step reduction:
1. The hypothesis contains the instance $n'=2$, $\theta\in(0,1)$ (e.g. $1/2$), with the given $X_1,X_2$ as the copies. They exist because $n\ge2$ is forced: for $n\le1$ the event $\{X_1=\cdots=X_n\}$ is the whole space, so its probability is 1, not $<1$.
2. $\Prob(X_1=\cdots=X_n)<1$ for i.i.d. copies implies $X$ is not a.s. constant. If $X=c$ a.s., all $X_i=c$ a.s. and the event has probability 1.
3. For independent copies $X_1,X_2$ of a non-constant $X$, $\Prob(X_1\ne X_2)>0$. If $\Prob(X_1=X_2)=1$, then for every $t$, $0=\Prob(X_1\le t<X_2)=F(t)(1-F(t))$. So $F$ takes only the values 0 and 1, and $X$ is a.s. constant.

So the $n=2$ hypotheses of :266 hold. Under this reading there is no gap, and the $\theta_i$ in the statement are idle. Result: true for $X\ge0$, since the hypothesis is stronger than under (H-inst). Steps 1 to 3 are **reasoning, not checked in Lean**.

## 3. Classification: `DOMAIN_CLARIFICATION`

- The question is what "(eq:main-st) holds" means at :263. Whether there is a gap at :266 depends entirely on that reading: an `EXPOSITION_GAP` for $n\ge3$ under (H-inst), a `FAIR_IMPLICIT_STEP` under (H-prop). The source supports both readings (§1). This is exactly the situation of VERDICTS §2 `DOMAIN_CLARIFICATION`. Minimum evidence: both readings, and whether the result holds under each. Both are given in §2, and the result holds under each.
- **Why not `EXPOSITION_GAP` alone:** that classification assumes (H-inst), and the source does not settle that (H-inst) is meant. Calling it an omitted range would overstate the case against the authors if (H-prop) is intended.
- **Why not `FAIR_IMPLICIT_STEP` alone:** it assumes (H-prop), which the literal statement does not support: the statement fixes $n$ and $\theta_i$, and :102 states the fixed-instance version.
- **Why not `ENCODING_ERROR`:** the gate's (H-inst) encoding is the literal reading and is legitimate. It is not our representation that creates the gap.
- **Why not `ERROR`:** the result is true under both readings.

## 4. Consequences for the verification

- **P02 under the gated (H-inst) encoding:** S1 stays a recorded gap (`P02_S1_Gap`). The prover must not close it by re-running the argument for $n$ terms. Switching the encoding to (H-prop) would be a statement change. That needs the coordinator and a new gate, and is not decided here. Under (H-prop), S1 would follow from §2 steps 1 to 3 along the source's route.
- **Threat to the conclusion:** no, under either reading.
- **Affected:** only the $n\ge3$ part of P02, and only under (H-inst).
- **Unaffected:**
  - the $n=2$ part of P02 (S2 to S6);
  - P03 (prop:mean-fsub, :269-273) under both readings: it uses either the two-term instance or the full property, both supplied by Thm 3.1 (:188, :217);
  - all other results (prop:inf-mean is referenced only at :262 and :269).
- The separate nonnegativity issue (gate item 7.2) is unchanged by this ruling.
- **Human check needed:** which reading of :263 the authors intend.

## 5. Suggestion to the authors (minimal; reviewer suggestions, not in the source, not used in any verification)

Either of these suffices:
- (i) Fix the reading in the statement: "If $X\leqst\theta_1X_1+\cdots+\theta_nX_n$" for the given weights (H-inst), and replace the first sentence of :266 with "We give the proof for $n=2$; the general case is identical, with $Y=\sum\theta_iX_i$ and strict Jensen on $\{X_1=\cdots=X_n\}^c$". The auditor checked that this suffices under (H-inst).
- (ii) State that (eq:main-st) holds for all $n$ and weights, or for $n=2$ and some $\theta\in(0,1)$. Then the first sentence of :266 is justified by §2 steps 1 to 3.

Nonnegativity of $X$ must still be addressed separately.

## 6. Not checked

- §2 steps 1 to 3 (H-prop) in Lean: reasoning only.
- The instance-level question whether an $n$-fold dominance implies a two-fold one (r1 §7): still open, and not needed for this ruling.
- The authors' intent (human check).

ISSUE VERDICT: DOMAIN_CLARIFICATION
THREATENS CONCLUSION: no

# P02 issue 1, second ruling (r2): reasoning review

- Reviewer: pv-auditor (claude-opus-5-5), 2026-10-12
- Mode: reasoning review of `verification/audits/P02_issue_1_r2.md` (ISSUE VERDICT: DOMAIN_CLARIFICATION, reasoning only).
- Source read directly: `source/SuperParetoPaper-v12.tex` :88-107, :109-138 (Def 2.1 stochastic order, Def ITS, Lemma eq:sub-1x), :184-273. I also searched for every occurrence of `eq:main-st`. Classification criteria: `verification/rules/VERDICTS.md` §2.1-2.2 (:71-88).

## 1. Step-by-step check of r2

| r2 claim | Check against the source | Result |
|---|---|---|
| §1 property-of-X usages: :103, :105, :107, :188, :277, :323 | All verified. Thm 3.1 (:188) states the relation with no quantifier over $n,\theta$ and proves it by induction over all $n$ (:191, :219) | OK |
| §1 fixed-instance usages: :102, :217, :219 | Verified. The ruling could also cite the defining passage :95-98, which introduces (eq:main-st) for *given* $n$, copies and weights. That strengthens (H-inst) as the literal reading, and r2 already treats it as the literal one | OK (minor omission) |
| §1 :263 fixes $X_1..X_n$, $\theta_i>0$ before "If (eq:main-st) holds" | Verified verbatim | OK |
| §2 (H-inst): :266 gives no reduction from $n$ to 2; the grouping fails because $Z$ is not a copy of $X$ | Correct. Only the sentence "It is enough to prove the case $n=2$" appears | OK |
| §2 (H-inst): the argument works for $n$ terms: (a)-(c) independent of $n$, (d) strict Jensen on $\{X_1=\cdots=X_n\}^c$ | I checked it. Equal finite means plus $\leqst$ give equality in law. $\sqrt{\cdot}$ is strictly concave on $[0,\infty)$, all $\theta_i>0$, and the event has positive probability by the printed hypothesis. Integrability follows from $\Mexp X<\infty$. True for $X\ge0$ | OK |
| §2 (H-prop) step 1: the property contains the $n'=2$ instance with the given $X_1,X_2$; $n\ge2$ forced | Correct. $\leqst$ depends only on laws (:119), so any copies may be used. For $n\le1$ the event $\{X_1=\cdots=X_n\}$ is $\Omega$ | OK |
| §2 step 2: the probability $<1$ for i.i.d. copies means $X$ is not a.s. constant | Correct (contrapositive) | OK |
| §2 step 3: independent copies of a non-constant $X$ satisfy $\Prob(X_1\ne X_2)>0$, via $\Prob(X_1\le t<X_2)=F(t)(1-F(t))$ | Correct. The event lies in $\{X_1\ne X_2\}$. If it is null for all $t$, then $F$ takes only the values 0 and 1, so $X$ is a.s. constant | OK (reasoning, not checked in Lean, as labelled) |
| §2: under (H-prop), the first sentence of :266 is a `FAIR_IMPLICIT_STEP`, and the $\theta_i$ are idle | Agreed. Steps 1-3 are routine and match what :266 asserts ("independent, same distribution, $\Prob(X_1\ne X_2)>0$") | OK |
| §2: the result is true under both readings, for $X\ge0$ | Agreed. Under (H-prop) the hypothesis is stronger | OK |

## 2. Classification

- VERDICTS §2.1 `DOMAIN_CLARIFICATION`: "The domain or object is ambiguous, and the conclusion depends on the reading". Minimum evidence: "both readings and whether the result holds under each".
- Here the ambiguous object is the hypothesis "(eq:main-st) holds" at :263. Its definition at :95 is instance-level, but the paper's predominant later use is a property of $X$ (§1). Both readings are textually supported.
- The printed conclusion ("$X$ has infinite mean") is true under both readings. What depends on the reading is whether :266 is justified: a gap for $n\ge3$ under (H-inst), and a fair one-step reduction under (H-prop).
- r2 says "This is exactly the situation of DOMAIN_CLARIFICATION". That is slightly loose against the table's wording "the conclusion depends on the reading": here it is the soundness of the written proof, not the truth of the conclusion, that depends on the reading. Even so, I judge `DOMAIN_CLARIFICATION` the correct primary class, for three reasons:
  - `EXPOSITION_GAP` alone would presuppose (H-inst) and would overstate the case against the authors under the property reading. That conflicts with the fidelity rule that our representation choices must not manufacture a paper error.
  - `FAIR_IMPLICIT_STEP` alone would presuppose (H-prop), which the literal statement and :95/:102 do not support.
  - The minimum evidence (both readings, and the result under each) is supplied.
- The r2 exclusions of `ENCODING_ERROR` (the gate's literal encoding is legitimate) and `ERROR` (true under both readings) are correct.
- The sub-choice under (H-inst), `EXPOSITION_GAP` versus `PAPER_ARGUMENT_GAP`, is flagged in r2 as borderline. I accept that.

## 3. Scope and downstream

| Claim | Check | Result |
|---|---|---|
| Affected: only $n\ge3$ of P02, only under (H-inst) | Correct. $n=2$ is the written case | OK |
| S1 stays a recorded gap; the prover must not re-run the argument for $n$ terms; a switch to (H-prop) is a statement change requiring a new gate | Consistent with POLICY §1 fidelity | OK |
| P03 (:269-273) unaffected under both readings | Correct. P03 needs one two-term instance, which Thm 3.1 (:217) gives, or the full property. Side check: P03 also needs $\Prob(X_1\ne X_2)>0$, i.e. $X$ not constant. Def ITS (:124) requires $F_X(0)=0$, and a constant $c>0$ violates (eq:sub-1x) (take $x$ just below $c$, $\theta=1/2$: $1+1\not\le 0+1$). So the ITS class has no constants, and no issue arises | OK |
| Other results unaffected (prop:inf-mean cited only at :262, :269) | Verified by search | OK |
| THREATENS CONCLUSION: no | Agreed | OK |

## 4. Suggested fixes (reviewer suggestions, not evidence)

- (i) Make the statement instance-level and say that the general case is identical: sufficient under (H-inst), as checked in §1 row 5.
- (ii) Assume (eq:main-st) for all $n$ and weights, or for $n=2$ and some $\theta\in(0,1)$: sufficient, by r2 §2 steps 1-3, which I checked.
- Both leave the nonnegativity issue (gate item 7.2) to be fixed separately, as r2 says.

## 5. Finding

- r2 answers my earlier objection (`P02_issue_1_audit.md` §2) correctly and completely.
- Both readings are stated, with the result under each. The reasoning steps are correct. The scope is stated neither too broadly nor too narrowly. A human check of the authors' intended reading is requested.
- Minor remarks, not affecting the ruling:
  - (a) Cite :95-98 as the defining instance-level passage.
  - (b) "exactly the situation" should say that the soundness of :266, not the truth of the conclusion, depends on the reading.

REVIEW: CONFIRMED

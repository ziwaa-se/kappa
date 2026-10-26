# P02 issue 1: "It is enough to prove the case n=2" (source :266)

- Checker: pv-issue-checker (claude-opus-5-5), Mon Oct 12 22:22:54 EDT 2026
- Reported by: pv-prover (`pv_work/notes/P02_prover_notes.md`, stopped obligation S1 = `P02_S1_Gap` in `pv_work/P02ModGaps.lean`); gate `verification/audits/P02_gate.md` item 7.3.
- Status: ruling by reasoning plus one positive Lean probe. **Not confirmed** until pv-auditor reasoning review passes.

## 1. Source text (read directly)

- :95-99 (eq:main-st): "given $n$ i.i.d. copies of $X$, say $X_1,\ldots,X_n$, and weights $\theta_1,\ldots,\theta_n\geq0$ such that $\theta_1+\cdots+\theta_n=1$, we have $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$."
- :261-264 Proposition 3.2: "Let $X_1,\ldots,X_n$ be independent random variables such that $\Prob(X_1=\cdots=X_n)<1$, and $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$. If (eq:main-st) holds, then $X$ has infinite mean."
- :266 proof, first sentence: "It is enough to prove the case $n=2$." The rest of :266 treats only $Y=\theta X_1+(1-\theta)X_2$ with $\Prob(X_1\ne X_2)>0$. No reduction argument, reference, or remark ("the general case is analogous") is given.
- Context: :102 and :260 the authors state the finite-mean facts for general $n$ (equal means; convex order "by using repeatedly the definition of convexity"), but neither passage is a reduction of $n$ to $2$.
- :219 (proof of Theorem 3.1) uses induction $n-1\Rightarrow n$ for the ITS dominance; it goes the other way and does not apply to Prop 3.2.

## 2. What is consumed

S1 (`P02_S1`, gated vh): from `TwoCase` (Prop 3.2 at $n=2$, all $\theta\in(0,1)$, all $X$) derive Prop 3.2 for arbitrary $n$, $\theta_i>0$, i.i.d. copies, $\Prob(X_1=\cdots=X_n)<1$, $X\leqst\sum\theta_iX_i$.

Two readings of "it is enough":

- **R1 (literal reduction).** Under the $n$-hypotheses produce an instance of the $n=2$ hypotheses, i.e. $X\leqst\theta X_1'+(1-\theta)X_2'$ with $X_1',X_2'$ i.i.d. copies of $X$, $\Prob(X_1'\ne X_2')>0$. The source gives no such construction, and the obvious grouping $\sum\theta_iX_i=\theta_1X_1+(1-\theta_1)Z$, $Z=\sum_{i\ge2}\frac{\theta_i}{1-\theta_1}X_i$, fails: $Z$ is not a copy of $X$ (for finite-mean nondegenerate $X$, $Z$ has the same mean and strictly smaller convex order, :260). Nothing in the paper shows that the $n$-fold dominance implies a two-fold dominance for the same $X$. Whether that instance-level implication holds is open here: **reasoning, not checked in Lean** (I neither proved nor refuted it; a refutation would need an infinite-mean $X$ that satisfies the $n$-fold dominance but not the two-fold one, which is out of scope).
- **R2 ("n=2 is representative").** The :266 argument is written for $n=2$ and is supposed to carry over with $n$ terms. Step by step, with $Y=\sum\theta_iX_i$:
  (a) $\Mexp Y=\Mexp X$ (linearity, as in S2);
  (b) dominance plus equal finite means gives equal laws (the S3 argument does not use the form of $Y$);
  (c) $\Var\sqrt X=\Var\sqrt Y$, hence $\Mexp\sqrt X=\Mexp\sqrt Y$ (S4a/S4b do not use the form of $Y$);
  (d) strict Jensen with $n$ terms: $\sqrt{\sum\theta_ix_i}>\sum\theta_i\sqrt{x_i}$ whenever $\theta_i>0$ and the $x_i\ge0$ are not all equal, which holds on the event $\{\neg(X_1=\cdots=X_n)\}$. That event has positive probability exactly by the printed hypothesis $\Prob(X_1=\cdots=X_n)<1$.
  The only part that changes is (d). Its pointwise form is a direct instance of mathlib `StrictConcaveOn.lt_map_sum` (probe below). Integrating needs the same tools as S5, with $n$ terms in place of 2.

Is the claim true as reduced? As a logical implication, `TwoCase → P02(n)` is true, because P02(n) itself is true for every $n$ (by the R2 argument for $X\ge0$; the gate's item 1 sketch covers real $X$). So this is **not an `ERROR`**. No counterexample exists to the printed Prop 3.2 coming from this sentence. The only problem is that the source's proof does not cover $n\ge3$.

## 3. Classification: `EXPOSITION_GAP`

- **What is not covered:** every $n\ge3$ of Prop 3.2 (:263 states general $n$; :266 proves only $n=2$). The case $n=2$ cannot absorb them: an $n$-term combination of copies of $X$ is not a two-term combination of copies of $X$, and there are no constants or monotonicity to exploit. The uncovered cases need their own (verbatim-analogous) argument.
- **Why not `PAPER_ARGUMENT_GAP`:** the source does not give a faulty argument for $n\ge3$. It gives none and only signals the omission with a WLOG remark. Read as "the general case is identical" (R2), the omitted cases follow along the printed route, and the authors' own general-$n$ remarks (:102, :260) support this reading. Read literally (R1), "enough" would claim a reduction that the paper does not supply. If the authors really meant R1, the class would become `PAPER_ARGUMENT_GAP`. I rule R2 as the fair reading. **Human check suggested** on which reading the authors intended.
- **Why not `FAIR_IMPLICIT_STEP`:** this is not a single routine step that can be filled in on the written route. A faithful Lean proof of $n\ge3$ must re-run the whole :266 argument with different objects: an $n$-fold independent family, an $n$-term Jensen inequality, and the event "not all equal" instead of $X_1\ne X_2$. The proof as stated (S1: deduce from the $n=2$ case) cannot be completed from the source. That is a whole uncovered case, not a skipped line. The gate (item 5, S1) also correctly forbade proving S1 by redoing the argument for general $n$. This ruling keeps that ban: the prover must not close S1. S1 stays a recorded gap.
- **Why not `ENCODING_ERROR`:** `TwoCase` is a faithful encoding of the $n=2$ case with the printed hypotheses (gate item 6), and `P02_S1` encodes the source's reduction claim. The stop is caused by the source, not by our representation choices.
- **Why not `DOMAIN_CLARIFICATION`:** both readings give the same, true, mathematical result. Only the written justification differs.

## 4. Does it threaten the conclusion?

- **P02 itself:** no. The conclusion is true for all $n$, and the omitted cases follow the printed route with $n$ terms (reasoning, not checked in Lean beyond the pointwise probe). P02 cannot be `UNCONDITIONAL` from the source as written: the general-$n$ statement rests on the gap S1. This is independent of the separate nonnegativity issue (prover note 2 / gate 7.2), which affects the $n=2$ case too.
- **Downstream:**
  - **P03 (Prop 3.3, prop:mean-fsub, :270-273) is not affected.** It is "immediate" from Theorem 3.1 and Prop 3.2 (:269). Theorem 3.1 gives (eq:main-st) for every $n$, including $n=2$ (shown explicitly at :217). So P03 needs only the $n=2$ instance of Prop 3.2 (e.g. $\theta=1/2$), which is the case :266 actually proves. P03 may still be affected by other P02 issues (nonnegativity; nondegeneracy $\Prob(X_1\ne X_2)>0$), but not by this one.
  - There are no other uses of prop:inf-mean (grep of labels: only :262 and :269).
- **Affected:** only the $n\ge3$ part of P02 (the `P02_main` route through S1 / `P02_S1_Gap`).
- **Unaffected:** the $n=2$ part of P02 (S2 to S6); P03 as far as this issue goes; all other results.

## 5. Evidence

- Positive probe (supports "routine extension", not used in any verification): `pv_work/probes/issue/P02/issue_P02_njensen.lean`, theorem `Paper.P02.Issue1.sqrt_strict_jensen_n` (pointwise $n$-term strict Jensen for $\sqrt{\cdot}$, $\theta_i>0$, $\sum\theta_i=1$, $x_i\ge0$ not all equal), proved by `Real.strictConcaveOn_sqrt.lt_map_sum`.
  - `scripts/pv_lean.sh probe pv_work/probes/issue/P02/issue_P02_njensen.lean` -> `RESULT issue_P02_njensen mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/issue_P02_njensen_2.log`.
  - `#pv_walk_decl`: "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false". `#print axioms` gives the same.
  - The first run (log `_1`) failed only because `#pv_axioms` expects a module name; this was fixed by using `#pv_walk_decl`. It was not a mathematical failure.
- No counterexample was constructed (none exists to the printed clause; see §2).
- Reasoning, not checked in Lean: the absence of a reduction under R1; the step-by-step transfer (a) to (c) under R2 (by inspection: S2/S3/S4a/S4b as gated do not use the two-term form of $Y$ except to define it); the downstream scope for P03.

## 6. Suggestion to the authors (minimal)

Replace "It is enough to prove the case $n=2$." with "We give the proof for $n=2$; the general case is identical, with $Y=\theta_1X_1+\cdots+\theta_nX_n$ and the strict Jensen inequality holding on the event $\{X_1=\cdots=X_n\}^c$, which has positive probability." Alternatively, write the proof directly for general $n$. This is my own suggestion, constructed by the reviewer and not in the source; it is a suggestion only and is not used in any verification. Check that it suffices: steps (a) to (c) are independent of $n$, and (d) is the probe lemma integrated over an event of positive probability. The nonnegativity issue (separate) must still be fixed for the whole argument.

## 7. Not checked

- Whether the $n$-fold dominance for an infinite-mean $X$ implies a two-fold dominance (the R1 instance-level implication). This is irrelevant to the classification under R2 but would decide R1 vs. a stronger claim.
- A full Lean proof of the general-$n$ case (deliberately not attempted: it would be a proof route the source does not write out, and the gate forbids it for S1).
- The authors' intended reading (human check).

## Instruction to coordinator / prover

S1 stays a recorded gap (`P02_S1_Gap`); do not close it by re-running the argument for $n$ terms. P02 records this as an issue. P03 does not inherit this issue.

ISSUE VERDICT: EXPOSITION_GAP
THREATENS CONCLUSION: no

# L03 issue 1: ruling (Lemma lem:raw, Lemma 2.5)

Role: pv-issue-checker. This ruling is not confirmed until pv-auditor reviews the counterexample.
Reported by pv-drafter (L03Draft.lean:19-23), pv-gate (L03_gate.md item 7) and pv-prover (L03_prover_notes.md:5-7).

## 1. Source text

- Definition, source/main.tex:33-35: "For $n \ge 2$, the sample variance of $x$ is $s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar x)^2$".
- Mean, main.tex:29: $\bar x = \frac{1}{n}\sum x_i$.
- Lemma lem:raw, main.tex:85-87: "Suppose that $n \ge 2$. Then $s^2 \le \frac{1}{n} \sum_{i=1}^n x_i^2$."
- Proof, main.tex:90: "By Lemma lem:shortcut, $(n-1) s^2 = \sum x_i^2 - n \bar x^2 \le \sum x_i^2$."
- Proof, main.tex:91: "Dividing by $n$ gives the claim."
- Cited result lem:shortcut, main.tex:51: $\sum (x_i-\bar x)^2 = \sum x_i^2 - n\bar x^2$ (L02, already verified).

## 2. Consumed instance

The lemma is stated for every $n \ge 2$ and every $x \in \mathbb{R}^n$, with $s^2$ normalised by $1/(n-1)$. No restriction appears in the source. Its only downstream consumer is Corollary cor:unit (C01, main.tex:99), which applies the lemma to samples with $|x_i| \le 1$.

## 3. What fails

- The line at main.tex:90 is correct; it is proved in Lean as L03_S1 and L03_S2 in L03ModGaps.lean.
- At main.tex:91, dividing $(n-1)s^2 \le \sum x_i^2$ by $n$ gives $\frac{n-1}{n} s^2 \le \frac1n \sum x_i^2$. That is weaker than the claim, because $\frac{n-1}{n} < 1$. Dividing by $n-1$ gives $s^2 \le \frac{1}{n-1}\sum x_i^2$, which is also not the claim.
- The printed conclusion at :86 is itself false. Take $n=2$ and $x=(1,-1)$. Then $\bar x = 0$, $s^2 = 2$ and $\frac1n\sum x_i^2 = 1$, but $2 \not\le 1$.
- More generally, the claim fails for **every** $n \ge 2$ (reasoning, not checked in Lean). For any $x$ with $\bar x = 0$ and $x \ne 0$, $s^2 = \frac{1}{n-1}\sum x_i^2 > \frac1n\sum x_i^2$.

## 4. Classification: ERROR

- The printed conclusion is false under the source's own definition (:35), on an instance that satisfies every printed hypothesis. The Lean counterexample is in §6. That meets the definition of `ERROR`.
- Not `PAPER_ARGUMENT_GAP` alone. The step at :91 is also unsupported, but a gap label would allow the conclusion to be true, and it is not. The step defect is part of this ERROR, not a separate issue.
- Not `PAPER_ASSUMPTION_GAP`. No natural extra hypothesis rescues the lemma: the counterexample family (any nonzero centred sample) covers every $n$.
- Not `DOMAIN_CLARIFICATION`. One reading would take $s^2$ as the population variance $\frac1n\sum(x_i-\bar x)^2$, which would make the lemma true. But :35 explicitly fixes the $1/(n-1)$ normalisation, and the proof at :90 itself uses $(n-1)s^2$. So the source admits no second reading.
- Not `ENCODING_ERROR`:
  - `sampleVar` (Defs.lean:24-25) is literally $\frac{1}{(n:\mathbb R)-1}\sum (x_i-\bar x)^2$.
  - The instance has $n=2$, so neither the real cast nor division by zero plays a role.
  - The arithmetic ($\bar x=0$, $s^2=2$, right-hand side $=1$) can be checked by hand.

## 5. Threat to the conclusion

- L03's final conclusion: **yes**, it is false. L03 cannot be verified.
- Downstream C01 (Corollary cor:unit, main.tex:94-100): its proof at :99 reads "By Lemma lem:raw, $s^2 \le \frac1n\sum x_i^2 \le 1 \le 2$".
  - It invokes the false lemma, even in the restricted form it consumes (|x_i| ≤ 1). That form is also refuted in Lean (`counterexample_consumed`).
  - The intermediate claim $s^2 \le 1$ is false at the same instance (`x0_C01_intermediate_fails`).
  - C01's own printed conclusion $s^2 \le 2$ holds at this instance, with equality (`x0_C01_conclusion_holds`).
  - Whether C01's conclusion holds in general is for C01's own ruling. A possible route (constructed by the reviewer, not in the source, suggestion only, not used in any verification): $s^2 \le \frac{1}{n-1}\sum x_i^2 \le \frac{n}{n-1} \le 2$.
  - Expected classification of C01: its printed proof relies on a false lemma and a false intermediate step, which suggests `PAPER_ARGUMENT_GAP` for C01. The conclusion is not shown false here. C01 needs its own ruling.
- Unaffected:
  - L01 (lem:centred), L02 (lem:shortcut), P01 (prop:popoviciu), P02 (prop:samuelson).
  - None of these cites lem:raw (INVENTORY.md dependency table).
  - Steps S1 and S2 of L03 (main.tex:90) are correct and proved.

## 6. Evidence (Lean)

- File: `pv_work/L03_Counterexample1.lean`. It imports `L03Stmt`, so it is checked against the gated `Paper.L03.Conclusion`.
  - `PrintedClause := ∀ {n} (_hn : 2 ≤ n) (x : Sample n), Conclusion x`. This is the full closure of the gated `L03_main`. The hash check gives vh=3472474048, equal to the gate th of `Paper.L03.L03_main` (L03_gate.md:79). `Conclusion` gives th=3418533756 and vh=556412300, both equal to the gate values.
  - `counterexample : ¬ PrintedClause`, witnessed by `x0 = ![1,-1]`.
  - `ConsumedByC01` (adds |x_i| ≤ 1, so it is weaker), `consumed_of_printed`, and `counterexample_consumed : ¬ ConsumedByC01`.
  - `x0_var : sampleVar x0 = 2`, `x0_rhs : … = 1`, `x0_bounded`.
  - `step91_premise_holds`: the premise produced at :90 holds at x0, so the :91 step goes from a true premise to a false conclusion.
  - `x0_C01_intermediate_fails`, `x0_C01_conclusion_holds`.
- Build: `scripts/pv_lean.sh build L03_Counterexample1` printed `RESULT … mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`. Log: `pv_work/logs/L03_Counterexample1_1.log`. The olean was produced.
- Axiom probe: `pv_work/probes/issue/L03/issue_L03_axioms.lean` ran with exit=0. Log: `pv_work/logs/issue_L03_axioms_1.log`.
  - `#pv_axioms`: ALL STANDARD (17 declarations).
  - `#pv_walk`: the closure contains only propext, Classical.choice and Quot.sound, and sorryAx is not reached.
  - The probe checks `PrintedClause = (∀ {n} (hn : 2 ≤ n) (x), Conclusion x)` by `rfl`.
- Review points (VERIFICATION_METHODS §5):
  1. `PrintedClause` has exactly the printed premise ($n \ge 2$) and the printed conclusion. It is not stronger than the source.
  2. x0 satisfies $n=2\ge2$, and the source places no restriction on $x$.
  3. No definition in the source excludes x0.

## 7. Suggestion to the authors (minimal)

- Replace the claim at :86 with $s^2 \le \frac{1}{n-1}\sum_{i=1}^n x_i^2$, and "Dividing by $n$" at :91 with "Dividing by $n-1$". This follows directly from :90 because $n-1>0$, so it is just the printed line 90 divided by $n-1$.
- Alternatively, keep $\frac1n$ and state the lemma for $\frac{n-1}{n}s^2$, which is the population variance.
- Corollary cor:unit's proof (:99) must then be adjusted. With the first fix it reads $s^2 \le \frac{1}{n-1}\sum x_i^2 \le \frac{n}{n-1} \le 2$. This is constructed by the reviewer, not in the source, suggestion only, and not used in any verification.
- Both fixes have been checked by hand; the corrected L03 is not checked in Lean.

## 8. Not checked

- The general family (every $n\ge2$) is reasoning only, not checked in Lean. The Lean evidence covers $n=2$, which is enough to refute the printed universal clause.
- The truth of C01's conclusion in general is not ruled on here.
- Human check: recommended only as a confirmation that $s^2$ at :35 is intended with $1/(n-1)$. The source is explicit, so the ruling does not depend on it.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes

# C01 issue 1: ruling (Corollary cor:unit, Corollary 2.6)

- Role: pv-issue-checker (Opus). Date from `date`: Tue Oct 13 01:04:48 EDT 2026.
- Status: **not confirmed** until pv-auditor reviews it in counterexample-review mode.
- Reported by: pv-gate (C01_gate.md item 7) and pv-auditor (C01_final.md §6-§7). L03_issue_1.md §5 also flagged it.
- Probe location: `pv_work/probes/issue/C01/` (my role card's probe path, the same as the earlier L03 and P02 issue probes). The coordinator's task named `pv_work/probes/issue-checker/C01/`, but my rule card allows writes only under `probes/issue/<ID>/`.

## 1. Source text (read directly)

- main.tex:26: "Throughout, $n \ge 1$ is an integer and $x = (x_1,\dots,x_n) \in \mathbb{R}^n$."
- main.tex:33-35: "For $n \ge 2$, the sample variance of $x$ is $s^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i-\bar x)^2$".
- Cited result, Lemma lem:raw, main.tex:85-86: "Suppose that $n \ge 2$. Then $s^2 \le \frac{1}{n}\sum_{i=1}^n x_i^2$." Its printed clause is false (L03 issue 1 = B01, ERROR, COUNTEREXAMPLE VALID per L03_issue_1_audit.md).
- Corollary cor:unit, main.tex:95: "Suppose that $n \ge 2$ and that $|x_i| \le 1$ for $i = 1,\dots,n$. Then $s^2 \le 2$."
- Proof, main.tex:99: "By Lemma~\ref{lem:raw}, $s^2 \le \frac{1}{n}\sum_{i=1}^n x_i^2 \le 1 \le 2$."

## 2. What is consumed and what the proof commits to

- The chain at :99 is applied to the corollary's own sample, so $n \ge 2$ and $|x_i| \le 1$.
- Links 1 and 2 together assert the intermediate bound **$s^2 \le 1$ for every sample satisfying the corollary's hypotheses**. Link 3 then gives $s^2 \le 2$.
- Status of each link (C01.lean, C01_final.md §5):
  - Link 1 ("by lem:raw") is a faithful instance of the false clause B01. Even the restricted form actually consumed, with $|x_i| \le 1$, is false (`Paper.L03.counterexample_consumed`).
  - Link 2, $\frac1n\sum x_i^2 \le 1$, is valid (`C01_S2`; a fair implicit step).
  - Link 3, $1 \le 2$, is valid.
- The intermediate $s^2 \le 1$ is **false under C01's own printed hypotheses**. Take $n=2$, $x=(1,-1)$: then $|x_i| \le 1$, $\bar x=0$ and $s^2 = 2$. More generally, for every even $n$, the sample $x_i = (-1)^i$ gives $s^2 = n/(n-1) > 1$ (reasoning, not checked in Lean; the Lean evidence covers $n=2$).

## 3. Classification: PAPER_ARGUMENT_GAP (C01's own, separate from B01)

### 3.1 Why this is C01's own issue and not only the inherited B01

VERDICTS §1.3 says that an issue in a predecessor does not make this result ISSUE. In that case the result is made conditional on the predecessor's exact consumed clause. That rule presupposes that the result's own argument is sound **modulo** the predecessor clause, so that a revision fixing the predecessor can later be reconnected (VERDICTS §4.1 row (iv); PIPELINE stage 6b). Here that presupposition fails:

1. **C01's printed proof itself asserts a false statement under C01's own hypotheses.** The statement is $s^2 \le 1$ for all $n \ge 2$ with $|x_i| \le 1$. This is C01's own text at :99, not text of lem:raw. Lean: `intermediate_false : ¬ PrintedIntermediate`.
2. **No true premise can support the printed chain.** Lean: `no_true_premise_supports_chain (Q) (hQ : Q → PrintedIntermediate) : ¬ Q`. Consequently, no correction of lem:raw, and no true statement of any kind, can make :99 valid as printed. The (iv) parameter `C01_L03Consumed` could never be reconnected, whatever revision is made to L03.
3. **The natural repair of L03 does not repair C01.** L03_issue_1.md §7 suggests $s^2 \le \frac{1}{n-1}\sum x_i^2$. With that repair, link 2 of :99 becomes $\frac{1}{n-1}\sum x_i^2 \le 1$, which fails at $x_0$ (Lean: `repaired_L03_second_link_fails`). So the authors must change C01's chain itself, not only lem:raw.

The defect is therefore located in C01's argument: its strategy of bounding $s^2$ by $1$ is unsound. B01 is located in lem:raw's statement and its step at :91. The two issues have different fixes, so recording both does not double-count one defect.

Counter-position, stated fairly: every link that C01 adds (links 2 and 3) is individually valid, and the false intermediate is the image of B01 at the consumed instance. On that reading, C01 would remain CONDITIONAL with `upstream_issues: B01` only. I reject this reading. The CONDITIONAL record would mean that C01's proof is a sound deduction awaiting a sound predecessor, and points 1-3 show that no sound predecessor can exist for this chain. Whether the kit's policy wants this case recorded as a separate issue is a policy question, so a human check is flagged in §8.

### 3.2 Why it is not a neighbouring class

- **Not ERROR.** The printed conclusion $s^2 \le 2$ is not shown false. At $x_0$ it holds with equality (`x0_conclusion_holds`). In general it appears true. Reasoning, not checked in Lean, constructed by the reviewer, not in the source, not used in any verification: by lem:shortcut (:51, verified as L02), $(n-1)s^2 = \sum x_i^2 - n\bar x^2 \le n$, so $s^2 \le n/(n-1) \le 2$ for $n \ge 2$.
- **Not EXPOSITION_GAP.** No range or case is left out. The justification fails as an argument, for every $n=2$ instance and for all even $n$, so this is not something the constants could absorb.
- **Not PAPER_ASSUMPTION_GAP.** The conclusion appears to hold under the printed hypotheses. What fails is the argument, not a missing hypothesis.
- **Not FAIR_IMPLICIT_STEP.** The intermediate is false, so no routine filling exists.
- **Not DOMAIN_CLARIFICATION.** The definition at :35 fixes $1/(n-1)$, and no second reading is available (see L03_issue_1.md §4).
- **Not ENCODING_ERROR.** `sampleVar` is literally $\frac{1}{(n:\mathbb R)-1}\sum(x_i-\bar x)^2$ (DEFS_gate PASS). The instance has $n=2$, and the arithmetic ($s^2=2$) can be checked by hand.

## 4. Threat to the conclusion

- **C01's final conclusion: not threatened.** $s^2 \le 2$ appears true (reasoning above, not checked in Lean), and it holds at the counterexample instance. What fails is the printed proof: C01 cannot be verified through its printed route.
- **Downstream:** none. Corollary cor:unit is the last numbered result, and no result cites it (INVENTORY dependency table).
- **Unaffected:**
  - L01 (lem:centred), L02 (lem:shortcut), P01 (prop:popoviciu) and P02 (prop:samuelson).
  - C01's links 2 and 3 (`C01_S2`, `C01_S3`), which remain valid.
  - L03's own ruling (B01), which is unchanged by this ruling.
- **Effect on C01's verdict if confirmed:** ISSUE, with this issue in `issues` and L03 issue 1 (B01) still in `upstream_issues`. Clauses still verified: none unconditionally. The deduction :99 from the printed lem:raw remains a correct implication from a refuted premise (C01_final.md §6).

## 5. Evidence (Lean)

- File: `pv_work/probes/issue/C01/issue_C01_intermediate.lean`. It imports `C01`, `L03_Counterexample1` and `PVTools`.
  - `PrintedIntermediate := ∀ {n} (_ : 2 ≤ n) (x : Sample n), (∀ i, |x i| ≤ 1) → sampleVar x ≤ 1`. This is the printed intermediate under exactly the printed hypotheses of :95: no fewer premises and no stronger conclusion. A probe `rfl` example confirms its unfolded shape.
  - `chain_yields_intermediate (hL : C01_L03Consumed) : PrintedIntermediate`, built from the audited `C01_S1` and `C01_S2`. This is the scope lemma (in the style of `consumed_of_printed`): it shows that the intermediate is exactly what the printed chain commits to.
  - `x0_hyps`: $x_0 = (1,-1)$ satisfies $2 \le 2$ and $|x_i| \le 1$.
  - `intermediate_false : ¬ PrintedIntermediate`: the counterexample.
  - `no_true_premise_supports_chain`: independence from any repair of the predecessor.
  - `x0_conclusion_holds : Conclusion x0`: the corollary's conclusion is not refuted at $x_0$.
  - `repaired_L03_second_link_fails`: the reviewer-suggested repair of L03 does not rescue link 2.
- Compilation: `scripts/pv_lean.sh probe pv_work/probes/issue/C01/issue_C01_intermediate.lean` printed `RESULT issue_C01_intermediate mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`. Log: `pv_work/logs/issue_C01_intermediate_1.log`.
- Axiom check: `#pv_walk_decl` was run on all five theorems (log lines 1-67). In every case the closure axioms are `[propext, Classical.choice, Quot.sound]` and sorryAx is not reached.
  - `intermediate_false` reaches only Defs, L03_Counterexample1 and the current file (log:16-29).
  - `chain_yields_intermediate` reaches `C01_L03Consumed` only via `C01_S1`, as intended (log:7).
- Type hashes (log:68-75): `PrintedIntermediate` th=3944470172, vh=3136068422. `C01.Conclusion` reached with th=3418533756 and vh=1612149043, equal to the gate values (C01_gate.md:86).
- Review points (VERIFICATION_METHODS §5):
  - (1) The clause is not stronger than the printed text: it carries the printed hypotheses and the printed intermediate.
  - (2) $x_0$ satisfies every printed hypothesis of :95.
  - (3) No source definition excludes $x_0$.

## 6. Suggestion to the authors (minimal)

- Replace the chain at :99 with one that does not pass through $s^2 \le 1$. If lem:raw is corrected to $s^2 \le \frac{1}{n-1}\sum x_i^2$ (L03_issue_1.md §7), the chain becomes: "By Lemma lem:raw, $s^2 \le \frac{1}{n-1}\sum x_i^2 \le \frac{n}{n-1} \le 2$."
  - Constructed by the reviewer, not in the source, suggestion only, not used in any verification.
  - Checked by hand: $\sum x_i^2 \le n$ because $|x_i| \le 1$, and $n/(n-1) \le 2$ is equivalent to $n \ge 2$.
- Alternatively, keep the conclusion and remove the intermediate "$\le 1$".

## 7. Not checked

- The general family (all even $n$) is reasoning only. The Lean evidence is the $n=2$ instance, which is enough to refute the universal intermediate.
- The truth of C01's conclusion in general is reasoning only and is not checked in Lean.
- The suggested chain in §6 is not checked in Lean.

## 8. Human check

Recommended, on the policy point only: confirm that a false intermediate in this result's own proof text, which no repair of the predecessor can support, is to be recorded as this result's own issue rather than absorbed into `upstream_issues` (VERDICTS §1.3). The mathematics, namely that $s^2 \le 1$ fails at $x=(1,-1)$, does not depend on this check.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no

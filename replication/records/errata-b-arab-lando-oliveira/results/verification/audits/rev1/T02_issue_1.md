# T02 issue 1 (suspected issue B): the final step of the induction step, source :256

- Checker: pv-issue-checker (claude-opus-5-5). Started Tue Oct 13 01:26:18 EDT 2026 (from `date`).
- Raised by: pv-gate (`verification/audits/T02_gate.md` row S10b and item B; `T02_gate_r2.md`); pv-prover (`pv_work/notes/T02_prover_notes.md` item 3; `pv_work/T02ModGaps.lean`, `T02_S10b_Gap`).
- Status: ruling written Tue Oct 13 01:30:12 EDT 2026 (from `date`). **Not yet confirmed**: this needs pv-auditor counterexample review.

## 1. What the source says

`source/SuperParetoPaper-v12.tex:247-254` (end of the induction step of Theorem 3.1, thm:main, :186-189):

> P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x/θₙ) + ∫₀^{x/θₙ} F̄((x−θₙt)/(1−θₙ)) F(dt)
>   ≥ F̄(x/θₙ) + F̄(x/(1−θₙ))F(x) + F̄(x)(F(x/θₙ)−F(x))
>   ≥ F̄(x/θₙ) + F̄(x/(1−θₙ)) + F̄(x)(F̄(x) − F̄(x/θₙ) − F̄(x/(1−θₙ))).

`source/SuperParetoPaper-v12.tex:256`, verbatim:

> Finally, noting that the subadditivity assumption implies that the large parenthesis is negative, it follows that  $\Prob\left(\theta_1 X_1+\cdots+\theta_n X_n > x\right)\geq \Fbar_X(\tfrac{x}{\theta_n})+\Fbar_X(\tfrac{x}{1-\theta_n}) \geq\Fbar_X(x)$, using (\ref{eq:sub-1x}) written in terms of the survival function, thus concluding the proof.

Cited condition (eq:sub-1x), `:132-133` (Lemma 2.3, lem:ITS-carac):
`F_X(x/θ) + F_X(x/(1−θ)) ≤ F_X(x) + 1` for all `x ≥ 0`, `θ ∈ (0,1)`; in survival form
`F̄(x) ≤ F̄(x/θ) + F̄(x/(1−θ))`.
Definitions used: `F̄_X = 1 − F_X` (:113); ITS requires `F_X(0)=0` (Def 2.2, :122-125);
stochastic dominance (:115-118); (eq:main-st) (:95-98).

Notation below: `a = F̄(x)`, `b = F̄(x/θₙ)`, `d = F̄(x/(1−θₙ))`, `P = P(θ₁X₁+⋯+θₙXₙ > x)`.
Line :254 is `P ≥ b + d + a(a − b − d)`. (eq:sub-1x) is `a − b − d ≤ 0`.

## 2. What is consumed

The sentence at :256 makes two claims and the proof uses both of them:
1. `P ≥ b + d` (the intermediate claim), justified by "the large parenthesis is negative";
2. `b + d ≥ a` ((eq:sub-1x) in survival form; project obligation `T02_S11`, proved in `T02ModGaps`).

The induction step consumes only the combination `P ≥ a = F̄(x)`, for every `x ≥ 0` (:191; the
step at :219 does not restrict `x`), where `n ≥ 3` i.i.d. copies of an ITS `X` are used, with weights
`θᵢ > 0` summing to 1 and the induction hypothesis in force.
Draft obligation `T02_S10b` (`pv_work/T02Draft.lean:172-176`) encodes claim 1 as the algebraic step
`b + d ≤ b + d + a(a − b − d)`. That encoding is faithful to the printed justification. It is not
an encoding error, because the step needs `a(a − b − d) ≥ 0` and the source supplies `a ≥ 0`,
`a − b − d ≤ 0`, which give the opposite sign.

## 3. Analysis

**(i) The printed inference is invalid.** From `P ≥ b + d + a(a−b−d)` and `a(a−b−d) ≤ 0`, dropping
the nonpositive term gives a quantity *at least* as large as the bound. So it does not give a lower
bound for `P`. Lean: `not_printedInference` (numbers `P = 3/4`, `a = b = d = 1/2`).

**(ii) The intermediate claim itself is false, not merely unjustified.**
- At `x = 0`, for EVERY instance: ITS gives `F_X(0)=0`, so `b = d = F̄(0) = 1` and `b + d = 2 > 1 ≥ P`.
  Lean: `intermediate_fails_at_zero`. Its only hypothesis is `IsInvSub` (it uses `F(0)=0`).
- At `x = 1/2 > 0`: take X ~ Pareto(1) (ITS per the source :279, and proved in Lean as `isInvSub_P`),
  three i.i.d. copies, and `θ = (1/3, 1/3, 1/3)`. Then `b = F̄(3/2) = 2/3` and `d = F̄(3/4) = 1`,
  so `b + d = 5/3 > 1 ≥ P`.
- More generally (reasoning, not checked in Lean): because `F` is right-continuous with `F(0)=0`,
  `b + d → 2` as `x ↓ 0`. So for every ITS law and every `θₙ`, the claim fails for all small `x > 0`.

**(iii) The final inequality of :256 still follows from the source's own line :254.** Note that
`b + d + a(a−b−d) − a = (1 − a)(b + d − a)`. This is ≥ 0 because `a ≤ 1` and, by (eq:sub-1x), `b + d ≥ a`.
Lean: `final_of_254`. *This rearrangement was constructed by the reviewer. It is not in the source; it is a suggestion only and is not used in any verification.*

## 4. Classification

**PAPER_ARGUMENT_GAP.** The source gives a justification ("the parenthesis is negative, it follows
that…") that does not yield the stated intermediate inequality. In fact that inequality is false. The
conclusion the step is meant to deliver (`P ≥ F̄(x)`) is not refuted, and it follows from the
preceding printed line by a different (one-line) argument.
- Not `ERROR`. `ERROR` would mean the printed *conclusion* of Theorem 3.1 is false. What is false here is an
  intermediate claim inside the proof, and the theorem's conclusion is not refuted by this issue.
  The coordinator may want to note the stronger fact in the record: "intermediate claim false",
  not just "unjustified".
- Not `FAIR_IMPLICIT_STEP`. The printed route passes through a false statement with an explicitly
  wrong reason. The correct route is a different factorisation that the source does not give. A
  reader would have to discard the printed sentence, not fill it in.
- Not `EXPOSITION_GAP`. No range or case is missing; the justification itself fails (LESSONS: a failing
  justification is not an exposition gap).
- Not `ENCODING_ERROR`. `T02_S10b` and `PrintedIntermediate` encode the printed sentence. The failure at
  `x = 0` and at Pareto `x = 1/2` is genuine and does not come from any representation choice
  (`0/θ = 0` agrees with real arithmetic; `F̄ = 1 − cdf` as at :113).

## 5. Does it threaten the conclusion?

- Theorem 3.1 (T02): **not threatened by this issue**. By (iii), `P ≥ F̄(x)` follows from :254 together with
  (eq:sub-1x). The other open T02 items are unrelated to this ruling: S5/S6a (strict versus non-strict
  inequalities and atoms at :222-223), zero weights (issue C), and the external parameter `T02_L01Consumed`.
- Downstream: P03 (Prop 3.3, prop:mean-fsub, :270-273) uses T02 only through its conclusion, so it
  is **unaffected** by this issue. The parts of T02 that do not depend on this issue are also
  **unaffected**: S1-S4 (the `n = 2` case), S6b, S7, S8, S9, S10a, S11.
- Formalization consequence (for the coordinator, not a paper issue): `T02_S10b_Gap` in
  `pv_work/T02ModGaps.lean` is the ∀-closure of a statement false in general. Reasoning, not checked
  in Lean: it fails at `ν` = Pareto(1), `x = 1/2`, `θ = 1/3`, where `a = 1`, `b = 2/3`, `d = 1`, so
  `a(a−b−d) = −2/3 < 0`; this needs `SubCond μP`, which the source asserts at :279. So
  `T02_main_mod_gaps` has a hypothesis that is (very likely) refutable. Do not cite it as meaningful
  conditional evidence for the S10b link; the gap should instead be stated as the consumed clause
  `P ≥ F̄(x)` at that point.

## 6. Evidence

- File: `pv_work/T02_Counterexample1.lean`, sha256
  `774d14b5c8f0d4a6db3b72b1b86ea529f34e7b45f880caca6ddaea914ac63a15`.
  - `scripts/pv_lean.sh check T02_Counterexample1`: `exit=0 errors=0 sorry_warnings=0
    nonstandard_axiom_lines=0`, log `pv_work/logs/T02_Counterexample1_3.log`.
  - `scripts/pv_lean.sh build T02_Counterexample1`: `exit=0 errors=0 sorry_warnings=0`, olean written,
    log `pv_work/logs/T02_Counterexample1_4.log`.
- Axiom and usage probe: `pv_work/probes/issue/T02/issue_T02_1_axioms.lean` (`scripts/pv_lean.sh probe`,
  exit 0, log `pv_work/logs/issue_T02_1_axioms_1.log`):
  - `#pv_axioms T02_Counterexample1: ALL STANDARD (30 declarations checked)`
    ([propext, Classical.choice, Quot.sound]).
  - `#pv_hyp_usage not_printedIntermediate`: `hL01` USED and `h` USED.
- Declarations:
  - `PrintedIntermediate` encodes the claim of :256 together with **all** premises of the
    induction step: `IIDCopies`, `IsInvSub (μ.map X)`, `n+1 ≥ 3` copies, `θᵢ > 0`, `∑θᵢ = 1`, the
    induction hypothesis (as in `T02_S7`), and `x ≥ 0`. It contains no extra conclusion and drops no premise.
  - `not_printedIntermediate (hL01 : T02_L01Consumed) : ¬ PrintedIntermediate`. The witness is
    Pareto(1) on `Fin 3 → ℝ` with `Measure.pi`, `θ ≡ 1/3`, `x = 1/2`.
    - The premises are discharged as follows: `isInvSub_P` (unconditional); `iid3` (via
      `iIndepFun_iff_map_fun_eq_pi_map`).
    - The induction-hypothesis premise is discharged by the project's `T02_S4`, which carries the
      external parameter `T02_L01Consumed`. That is why the refutation of the full printed clause is
      conditional on the same parameter T02 already uses.
    - The failure itself does not use the induction hypothesis: `intermediate_fails_at_zero` is
      unconditional and holds for every instance.
  - `not_printedInference` covers the algebraic inference (unconditional).
  - `final_of_254` is the positive scope lemma (unconditional; reviewer-constructed).
  - `second_half_true` is the scope lemma: the second inequality of :256 (`b + d ≥ a`) holds; it reuses `T02_S11`.

## 7. Suggestion to the authors (minimal)

Replace the first inequality of :256 with the factorisation. The lower bound at :254 minus `F̄(x)`
equals `(1 − F̄(x))(F̄(x/θₙ) + F̄(x/(1−θₙ)) − F̄(x))`, which is ≥ 0 by (eq:sub-1x). Hence
`P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x)`. Also delete the claim `P(…) ≥ F̄(x/θₙ) + F̄(x/(1−θₙ))`, which is false
(e.g. at `x = 0`). *This suggestion was constructed by the reviewer and is not in the source. It is a suggestion only and is not used in any verification.*
Its sufficiency for this sentence is checked in Lean (`final_of_254`). It does not address the separate
S5/S6a or zero-weight items.

## 8. Not checked

- The general small-`x > 0` failure for every ITS law (reasoning only).
- The refutability of `T02_S10b_Gap` (reasoning only; it needs `SubCond μP`).
- Whether Theorem 3.1 holds overall. That depends on the other T02 items and on `T02_L01Consumed`,
  which are outside this ruling.
- Human check: optional. The arithmetic is elementary and machine-checked.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no

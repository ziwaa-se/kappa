import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# L02 — issue 1: counterexample to printed Lemma 2

Written by `pv-issue-checker`, independently of `pv-drafter` and `pv-gate` (their probes were read,
but every statement below was re-derived and re-compiled here; nothing is imported from
`pv_work/probes/gate/L02/`).

Source text being refuted, `source/demo.tex:20-22`:

> \begin{lemma}\label{lem:xsquare}
> For every real number $x$ we have $x^2 \ge x$.
> \end{lemma}

Source proof, `source/demo.tex:24-27`:

> We have $x^2 - x = x(x-1)$. The two factors $x$ and $x-1$ always have the same
> sign, so their product is nonnegative, and hence $x^2 \ge x$.

The manuscript (`source/demo.tex:1-29`) states no convention, no definition and no standing
hypothesis restricting `x`; lines 12-18 are the unrelated Lemma 1. So the printed hypothesis set of
Lemma 2 is exactly "`x` is a real number", and the witness `x = 1/2` satisfies it.

This file contains **no** repair of the source statement. The `suggested_*` lemmas at the end are
the reviewer's own construction, recorded only as a suggestion to the authors; they are not used by
any verification of L02.
-/

namespace Paper.L02.Counterexample1

/-! ## 1. The printed clauses, encoded verbatim -/

/-- The printed conclusion of Lemma 2, `source/demo.tex:21`, encoded verbatim:
"For every real number $x$ we have $x^2 \ge x$."

Hypotheses printed: only the typing/quantification `x : ℝ`. Nothing is added and nothing is
dropped; in particular no range restriction on `x` is inserted. The `vh` of this `def` must equal
the `th=1900454330` recorded for `Paper.L02.L02` in the gate snapshot
(`verification/audits/L02_gate.md` §13), which pins this encoding to the gated statement. -/
def PrintedLemma2 : Prop := ∀ x : ℝ, x ^ 2 ≥ x

/-- The operative assertion of the printed proof step, `source/demo.tex:25-26`:
"… so their product is nonnegative", said of the factors `x` and `x-1` for every real `x`
("always", line 25). The `vh` of this `def` must equal the `th=422374504` recorded for
`Paper.L02.L02_S2` in the gate snapshot. -/
def PrintedProductStep : Prop := ∀ x : ℝ, 0 ≤ x * (x - 1)

/-- The printed *justification* of that step, `source/demo.tex:25-26`:
"The two factors $x$ and $x-1$ always have the same sign." Encoded as "both are nonnegative, or
both are nonpositive", which is the weakest reasonable reading of "same sign" (it even counts `0`
as agreeing in sign with everything, so it is weaker than, not stronger than, the printed claim). -/
def PrintedSameSign : Prop := ∀ x : ℝ, (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0)

/-- The printed algebraic identity, `source/demo.tex:25`: "We have $x^2 - x = x(x-1)$." -/
def PrintedIdentity : Prop := ∀ x : ℝ, x ^ 2 - x = x * (x - 1)

/-! ## 2. The witness satisfies every printed hypothesis

The only printed hypothesis is "`x` is a real number". The witness is the real number `1/2`;
being a real number is a typing fact, recorded here so that the reviewer can see there is no
propositional hypothesis left unchecked. -/

/-- The witness is an honest real number, and it is strictly between the two points where the
printed claim turns around. No printed definition or convention of the source excludes it. -/
theorem witness_in_range : (0 : ℝ) < 1 / 2 ∧ (1 / 2 : ℝ) < 1 := by norm_num

/-! ## 3. The refutations -/

/-- At the witness the printed inequality fails: `(1/2)^2 = 1/4 < 1/2`. -/
theorem printed_fails_at_half : ¬ ((1 / 2 : ℝ) ^ 2 ≥ (1 / 2 : ℝ)) := by norm_num

/-- **Main counterexample**: the printed conclusion of Lemma 2 is false. -/
theorem not_printedLemma2 : ¬ PrintedLemma2 := by
  intro h
  have h2 := h (1 / 2 : ℝ)
  norm_num at h2

/-- The printed proof step ("their product is nonnegative") is false, same witness. -/
theorem not_printedProductStep : ¬ PrintedProductStep := by
  intro h
  have h2 := h (1 / 2 : ℝ)
  norm_num at h2

/-- The printed justification ("the two factors always have the same sign") is false: at the
witness the factors are `1/2 > 0` and `-1/2 < 0`, of opposite sign. -/
theorem not_printedSameSign : ¬ PrintedSameSign := by
  intro h
  rcases h (1 / 2 : ℝ) with ⟨_, hb⟩ | ⟨ha, _⟩
  · norm_num at hb
  · norm_num at ha

/-! ## 4. Scope of the refutation (`consumed_of_printed`-style lemmas)

These lemmas show that what is refuted is exactly what the source's proof route asserts and
consumes, neither more nor less. -/

/-- The printed algebraic identity is **true**: the failure is not in the algebra. -/
theorem printedIdentity_true : PrintedIdentity := by
  intro x; ring

/-- The printed justification would, if true, give the printed product step: so refuting the
product step refutes the justification's conclusion, and the justification is the only support the
source offers. -/
theorem printedSameSign_implies_printedProductStep :
    PrintedSameSign → PrintedProductStep := by
  intro h x
  rcases h x with ⟨ha, hb⟩ | ⟨ha, hb⟩
  · exact mul_nonneg ha hb
  · nlinarith [mul_nonneg (neg_nonneg.mpr ha) (neg_nonneg.mpr hb)]

/-- The printed product step would, if true, give the printed lemma (this is the source's own
"and hence $x^2 \ge x$", `source/demo.tex:26`). Hence `not_printedLemma2` refutes the printed
conclusion itself, not merely the step. -/
theorem printedProductStep_implies_printedLemma2 :
    PrintedProductStep → PrintedLemma2 := by
  intro h x
  have h1 : x ^ 2 - x = x * (x - 1) := by ring
  have h2 := h x
  linarith

/-- The printed clause is exactly the type of the gated main theorem
`Paper.L02.L02 (x : ℝ) : x ^ 2 ≥ x` (`pv_work/L02Draft.lean:57`), up to generalising its explicit
binder. Checked by `rfl`, and additionally by the type-hash comparison described in the docstring
of `PrintedLemma2`. -/
theorem printedLemma2_eq_gated_statement : PrintedLemma2 = (∀ x : ℝ, x ^ 2 ≥ x) := rfl

/-- The printed step clause is exactly the type of the gated obligation
`Paper.L02.L02_S2 (x : ℝ) : 0 ≤ x * (x - 1)` (`pv_work/L02Draft.lean:49`). -/
theorem printedProductStep_eq_gated_S2 :
    PrintedProductStep = (∀ x : ℝ, 0 ≤ x * (x - 1)) := rfl

/-! ## 5. Sharpness: where the printed claim fails, and where it survives

Not part of the refutation; recorded so that the scope is stated neither too broadly nor too
narrowly. -/

/-- The printed inequality fails **exactly** on the open interval `(0,1)`. -/
theorem failure_region (x : ℝ) : x ^ 2 < x ↔ (0 < x ∧ x < 1) := by
  constructor
  · intro h
    have hx : 0 < x := by nlinarith [sq_nonneg x]
    exact ⟨hx, by nlinarith⟩
  · rintro ⟨h0, h1⟩
    nlinarith

/-! ## 6. Suggestion to the authors

**Constructed by the reviewer, not in the source, suggestion only, not used in any verification.**
The minimal change is to restrict the quantifier to `x ≤ 0 ∨ 1 ≤ x` (equivalently: to the
complement of `(0,1)`). The two lemmas below check that this really does suffice — both for the
printed conclusion and for the printed justification, so that the proof sentence of
`source/demo.tex:25-26` becomes correct as written under the restriction. -/

/-- Under the suggested restriction the printed conclusion holds. -/
theorem suggested_restriction_gives_conclusion (x : ℝ) (hx : x ≤ 0 ∨ 1 ≤ x) : x ^ 2 ≥ x := by
  rcases hx with h | h
  · nlinarith
  · nlinarith

/-- Under the suggested restriction the printed justification ("the two factors have the same
sign") is also correct, so the source's one-sentence proof survives verbatim. -/
theorem suggested_restriction_gives_same_sign (x : ℝ) (hx : x ≤ 0 ∨ 1 ≤ x) :
    (0 ≤ x ∧ 0 ≤ x - 1) ∨ (x ≤ 0 ∧ x - 1 ≤ 0) := by
  rcases hx with h | h
  · exact Or.inr ⟨h, by linarith⟩
  · exact Or.inl ⟨by linarith, by linarith⟩

end Paper.L02.Counterexample1

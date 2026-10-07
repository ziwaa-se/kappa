import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity

/-!
# L02 — counterexample to the printed Lemma `lem:quot` (suspected issue 1)

Written by `pv-issue-checker`.  This file is **evidence about the source**, not a
proof of any paper result; it is not imported by `pv_work/L02.lean` and does not
repair anything.

Source under check, `source/main.tex:71-76` (statement, verbatim):

```
\begin{lemma}\label{lem:quot}
For every real number $x \neq -1$ we have
\[
  \frac{x^2}{1+x} \ge x - 1 .
\]
\end{lemma}
```

Source proof, `source/main.tex:78-81` (verbatim):

```
\begin{proof}
Multiplying both sides by $1+x$, the claim is equivalent to
$x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
\end{proof}
```

Conventions used: `source/main.tex:28-29` ("$\R$ denotes the real numbers"); the
lemma says "for every real number", so the domain is all of `ℝ` minus `{-1}`.
The Remark at `source/main.tex:83-85` ("Lemma~\ref{lem:quot} is used in the
companion paper only for $x \ge 0$") carries no `\label`, is not referenced by
the lemma, and is therefore **not** one of the lemma's hypotheses; it is encoded
below only as the separate `ConsumedClause`, to delimit the scope of the
refutation.

Imports: the narrow tactic modules `Mathlib.Tactic.Linarith`, `.Ring`,
`.FieldSimp`, `.Positivity` (not the umbrella `Mathlib.Tactic`), because this
package directory is linked and only partially built (see
`pv_work/notes/L02_draft_notes.md` §8); their availability was checked by
`pv_work/probes/issue/L02/issue_L02_tactics.lean`.
-/

namespace Paper.L02.Issue1

/-! ## 1. The printed clause, encoded word for word -/

/-- The clause printed at `source/main.tex:71-76`, encoded verbatim:
"For every real number `x ≠ -1` we have `x² / (1 + x) ≥ x - 1`".
No premise is dropped and the conclusion is not strengthened: the only printed
hypothesis is `x ≠ -1`, and it is present. -/
def PrintedClause : Prop := ∀ x : ℝ, x ≠ -1 → x ^ 2 / (1 + x) ≥ x - 1

/-- The witness `x = -2` satisfies the single printed hypothesis `x ≠ -1`. -/
theorem witness_satisfies_printed_hypothesis : (-2 : ℝ) ≠ -1 := by norm_num

/-- At the witness the two printed sides have the values computed in the report:
`x² / (1 + x) = 4 / (-1) = -4`. -/
theorem witness_lhs : ((-2 : ℝ)) ^ 2 / (1 + (-2 : ℝ)) = -4 := by norm_num

/-- At the witness, `x - 1 = -3`. -/
theorem witness_rhs : ((-2 : ℝ)) - 1 = -3 := by norm_num

/-- The denominator does not vanish at the witness, so the Lean division is the
honest quotient there (no junk value is involved). -/
theorem witness_denom : (1 : ℝ) + (-2 : ℝ) ≠ 0 := by norm_num

/-- **Counterexample.** The printed clause of `source/main.tex:71-76` is false:
at `x = -2` (which satisfies the printed hypothesis `x ≠ -1`) the claim reads
`-4 ≥ -3`. -/
theorem counterexample : ¬ PrintedClause := by
  intro h
  have h2 := h (-2) witness_satisfies_printed_hypothesis
  norm_num at h2

/-! ## 2. The printed justification, and where it breaks -/

/-- The algebraic fact the source calls "obvious" at `source/main.tex:80`:
`x² ≥ (x-1)(x+1) = x² - 1`.  It is **true**, for every real `x`. -/
def PrintedObviousFact : Prop := ∀ x : ℝ, x ^ 2 ≥ (x - 1) * (x + 1)

theorem printed_obvious_fact_holds : PrintedObviousFact := by
  intro x; nlinarith [sq_nonneg x]

/-- The equivalence asserted at `source/main.tex:79-80` ("Multiplying both sides
by `1+x`, the claim is equivalent to …"), encoded over the printed domain. -/
def PrintedEquivalenceStep : Prop :=
  ∀ x : ℝ, x ≠ -1 → (x ^ 2 / (1 + x) ≥ x - 1 ↔ x ^ 2 ≥ (x - 1) * (x + 1))

/-- The printed equivalence step is false at `x = -2`: its right side holds
(`4 ≥ 3`) while its left side fails (`-4 ≥ -3`). -/
theorem equivalence_step_false : ¬ PrintedEquivalenceStep := by
  intro h
  have h2 := (h (-2) witness_satisfies_printed_hypothesis).mpr (by norm_num)
  norm_num at h2

/-- Even the single direction the source's argument actually consumes — from the
"obvious" algebraic inequality back to the claim — fails, so the failure is not
an artefact of reading "is equivalent to" as a biconditional. -/
def PrintedStepUsedDirection : Prop :=
  ∀ x : ℝ, x ≠ -1 → x ^ 2 ≥ (x - 1) * (x + 1) → x ^ 2 / (1 + x) ≥ x - 1

theorem used_direction_false : ¬ PrintedStepUsedDirection := by
  intro h
  have h2 := h (-2) witness_satisfies_printed_hypothesis (by norm_num)
  norm_num at h2

/-! ## 3. Exact scope of the failure -/

/-- Exact decomposition of the printed left-hand side, valid whenever the
denominator is nonzero.  (Used only to delimit the scope below.) -/
theorem quot_identity (x : ℝ) (h : 1 + x ≠ 0) :
    x ^ 2 / (1 + x) = (x - 1) + 1 / (1 + x) := by
  field_simp
  ring

/-- The printed clause restricted to `x > -1` (equivalently `1 + x > 0`, the
sign condition the printed multiplication step needs but does not state). -/
def RestrictedClause : Prop := ∀ x : ℝ, -1 < x → x ^ 2 / (1 + x) ≥ x - 1

/-- On `x > -1` the printed inequality is **true**: this is the largest part of
the printed domain on which it holds. -/
theorem restricted_clause_holds : RestrictedClause := by
  intro x hx
  have hpos : (0 : ℝ) < 1 + x := by linarith
  have hne : (1 : ℝ) + x ≠ 0 := ne_of_gt hpos
  have hid := quot_identity x hne
  have hinv : (0 : ℝ) < 1 / (1 + x) := by positivity
  rw [hid]
  linarith

/-- And the printed inequality fails at **every** `x < -1`, not just at `x = -2`:
the refutation covers exactly the part `x < -1` of the printed domain. -/
theorem fails_on_whole_lower_branch (x : ℝ) (hx : x < -1) :
    ¬ (x ^ 2 / (1 + x) ≥ x - 1) := by
  have hneg : (1 : ℝ) + x < 0 := by linarith
  have hne : (1 : ℝ) + x ≠ 0 := ne_of_lt hneg
  have hid := quot_identity x hne
  have hinv : 1 / (1 + x) < 0 := by
    exact div_neg_of_pos_of_neg one_pos hneg
  rw [hid]
  intro hcon
  linarith

/-- The printed equivalence step of `source/main.tex:79-80`, with the domain
narrowed to `x > -1`.  Checking that this *is* valid is what shows the suggested
minimal fix (replace `x \neq -1` by `x > -1`) repairs the printed one-sentence
proof as well as the printed statement. -/
def RestrictedEquivalenceStep : Prop :=
  ∀ x : ℝ, -1 < x → (x ^ 2 / (1 + x) ≥ x - 1 ↔ x ^ 2 ≥ (x - 1) * (x + 1))

theorem restricted_equivalence_step_holds : RestrictedEquivalenceStep := by
  intro x hx
  exact iff_of_true (restricted_clause_holds x hx) (printed_obvious_fact_holds x)

/-! ## 4. Scope of the refutation (`consumed_of_printed`) -/

/-- The use recorded in the Remark at `source/main.tex:83-85`: the clause with
the domain narrowed to `x ≥ 0`.  This is **not** part of the printed lemma; it is
stated here only to show what the counterexample does and does not touch. -/
def ConsumedClause : Prop := ∀ x : ℝ, 0 ≤ x → x ^ 2 / (1 + x) ≥ x - 1

/-- The printed clause implies the narrowed clause the Remark describes, so the
refutation above really is a refutation of something at least as strong as what
a consumer would take from the lemma. -/
theorem consumed_of_printed : PrintedClause → ConsumedClause := by
  intro h x hx
  exact h x (by intro hEq; rw [hEq] at hx; norm_num at hx)

/-- The narrowed clause is nevertheless **true** on its own: the counterexample
does not touch the `x ≥ 0` range, hence it does not affect the companion paper's
use described at `source/main.tex:83-85`. -/
theorem consumed_clause_holds : ConsumedClause := by
  intro x hx
  exact restricted_clause_holds x (by linarith)

end Paper.L02.Issue1

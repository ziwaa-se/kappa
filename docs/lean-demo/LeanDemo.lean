import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Data.Real.Basic

/-! # A five-minute tour of Lean 4 + Mathlib -/

/-! ## 1. Lean checks computations -/
example : 2 + 2 = 4 := rfl

/-! ## 2. A hand-written proof: 2ab ≤ a² + b² for real a, b

Paper proof: (a − b)² ≥ 0, and (a − b)² = a² − 2ab + b². Rearrange. -/
theorem two_mul_le_sq_add_sq (a b : ℝ) : 2 * a * b ≤ a ^ 2 + b ^ 2 := by
  have h1 : 0 ≤ (a - b) ^ 2 := sq_nonneg (a - b)        -- a square is nonnegative
  have h2 : (a - b) ^ 2 = a ^ 2 - 2 * a * b + b ^ 2 := by ring  -- expand
  linarith                                               -- rearrange

/-! ## 3. Induction: 1 + 3 + 5 + ⋯ + (2n − 1) = n² -/
open Finset in
theorem sum_first_odds (n : ℕ) : ∑ i ∈ range n, (2 * i + 1) = n ^ 2 := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [sum_range_succ, ih]   -- split off the last term, use the induction hypothesis
    ring                      -- k² + (2k + 1) = (k + 1)²

/-! ## 4. A cited result we do not prove: a *visible* hypothesis

Papers often say "by [Book, Thm 3]". We do not re-prove the book; we state exactly what
is used and make it an explicit assumption. The theorem is then *conditional* on it. -/
def CitedFact : Prop := ∀ n : ℕ, n ≤ n ^ 2

theorem uses_cited_fact (h : CitedFact) (n : ℕ) : n < n ^ 2 + 1 := by
  have := h n
  omega

/-! ## 5. What exactly does a proof rely on? -/
#print axioms two_mul_le_sq_add_sq   -- only Lean's three standard axioms
#print axioms uses_cited_fact        -- standard axioms again, but `CitedFact` is still an explicit hypothesis

import Mathlib.Tactic.Linarith
import Mathlib.Data.Real.Basic

-- A false claim: Lean refuses it (there is no proof), and says what it could not show.
theorem wrong (a b : ℝ) : 2 * a * b ≤ a ^ 2 := by
  have h1 : 0 ≤ (a - b) ^ 2 := sq_nonneg (a - b)
  linarith

-- An unfinished proof: `sorry` is accepted only with a warning, and it is tracked.
theorem unfinished (n : ℕ) : n ≤ n ^ 2 := by
  sorry

#print axioms unfinished

import P01Stmt

namespace Paper.P01

/-- S1. source/main.tex:66-67: "Popoviciu's inequality on variances states that
(1/n) ∑ (x_i - x̄)² ≤ (b-a)²/4 whenever x_1..x_n lie in [a,b]."
Role: the cited external input, applied to the given sample.  Uses: `Popoviciu` (type (i)). -/
theorem P01_S1 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) (hP : Popoviciu) :
    (1 /(n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4 := by
  sorry

/-- S2. source/main.tex:68: "Multiplying both sides by n/(n-1) gives the claim."
Role: converts the 1/n-normalised bound into the bound on s² (n ≥ 2 so n/(n-1) > 0).
Uses: S1. -/
theorem P01_S2 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (h : (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4) :
    sampleVar x ≤ (n : ℝ) / ((n : ℝ) - 1) * ((b - a) ^ 2 / 4) := by
  sorry

/-- Proposition prop:popoviciu (source/main.tex:58-63): n ≥ 2, a ≤ x_i ≤ b for all i,
then s² ≤ n/(n-1) · (b-a)²/4. -/
theorem P01 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) (hP : Popoviciu) :
    sampleVar x ≤ (n : ℝ) / ((n : ℝ) - 1) * ((b - a) ^ 2 / 4) := by
  have h1 := P01_S1 n hn a b x hx hP
  exact P01_S2 n hn a b x h1

end Paper.P01

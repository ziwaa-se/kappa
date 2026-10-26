import L02Stmt

namespace Paper.L02

/-- S1. source/main.tex:55 "Expanding the square". -/
theorem L02_S1 {n : ℕ} (x : Sample n) :
    ∑ i, (x i - sampleMean x) ^ 2
      = ∑ i, (x i) ^ 2 - 2 * sampleMean x * ∑ i, x i + (n : ℝ) * (sampleMean x) ^ 2 := by
  have h : ∀ i, (x i - sampleMean x) ^ 2
      = (x i) ^ 2 - 2 * sampleMean x * x i + (sampleMean x) ^ 2 := fun i => by ring
  simp only [h]
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  simp

/-- S2. source/main.tex:55 "using `∑ x_i = n x̄`". -/
theorem L02_S2 {n : ℕ} (hn : 1 ≤ n) (x : Sample n) :
    ∑ i, x i = (n : ℝ) * sampleMean x := by
  have : (n : ℝ) ≠ 0 := by positivity
  unfold sampleMean
  field_simp

/-- Main statement, main.tex:50-52; S3 assembly at main.tex:55. -/
theorem L02_main {n : ℕ} (hn : 1 ≤ n) (x : Sample n) : Conclusion x := by
  unfold Conclusion
  rw [L02_S1 x, L02_S2 hn x]
  ring

end Paper.L02

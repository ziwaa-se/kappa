import L01Stmt

namespace Paper.L01

/-- source/main.tex:47 first equality: `∑ (x_i - x̄) = ∑ x_i - n x̄`.
Role: split the sum (linearity, constant summed n times). Uses no earlier step. -/
theorem L01_S1 (n : ℕ) (hn : 1 ≤ n) (x : Sample n) :
    ∑ i, (x i - sampleMean x) = (∑ i, x i) - (n : ℝ) * sampleMean x := by
  sorry

/-- source/main.tex:47 second equality: `∑ x_i - n x̄ = 0`, "by the definition of x̄".
Role: uses x̄ = (1/n)∑ x_i and n ≠ 0. Uses no earlier step. -/
theorem L01_S2 (n : ℕ) (hn : 1 ≤ n) (x : Sample n) :
    (∑ i, x i) - (n : ℝ) * sampleMean x = 0 := by
  sorry

/-- source/main.tex:42-44 Lemma lem:centred. Assembled from S1, S2. -/
theorem L01_main (n : ℕ) (hn : 1 ≤ n) (x : Sample n) : Conclusion x := by
  sorry

end Paper.L01

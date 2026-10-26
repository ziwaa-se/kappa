import L02Stmt

namespace Paper.L02

/-- S1. source/main.tex:55 "Expanding the square": for every `i`,
`(x_i - x̄)^2 = x_i^2 - 2 x̄ x_i + x̄^2`, hence summing,
`∑ (x_i - x̄)^2 = ∑ x_i^2 - 2 x̄ ∑ x_i + n x̄^2`.
Role: first half of the proof. Uses nothing else. -/
theorem L02_S1 {n : ℕ} (x : Sample n) :
    ∑ i, (x i - sampleMean x) ^ 2
      = ∑ i, (x i) ^ 2 - 2 * sampleMean x * ∑ i, x i + (n : ℝ) * (sampleMean x) ^ 2 := by
  sorry

/-- S2. source/main.tex:55 "using `∑ x_i = n x̄`" (follows from Definition def:mean,
main.tex:29, needs `n ≥ 1` as in main.tex:26). Uses no earlier step. -/
theorem L02_S2 {n : ℕ} (hn : 1 ≤ n) (x : Sample n) :
    ∑ i, x i = (n : ℝ) * sampleMean x := by
  sorry

/-- Main statement, main.tex:50-52 (with the global hypothesis `n ≥ 1`, main.tex:26).
S3 (assembly, main.tex:55 "we obtain the claim"): from S1 and S2,
`∑ x_i^2 - 2 n x̄^2 + n x̄^2 = ∑ x_i^2 - n x̄^2`. -/
theorem L02_main {n : ℕ} (hn : 1 ≤ n) (x : Sample n) : Conclusion x := by
  sorry

end Paper.L02

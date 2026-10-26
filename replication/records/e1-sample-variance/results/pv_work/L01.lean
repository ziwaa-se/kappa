import L01Stmt

namespace Paper.L01

/-- source/main.tex:47 first equality: `∑ (x_i - x̄) = ∑ x_i - n x̄`. -/
theorem L01_S1 (n : ℕ) (hn : 1 ≤ n) (x : Sample n) :
    ∑ i, (x i - sampleMean x) = (∑ i, x i) - (n : ℝ) * sampleMean x := by
  rw [Finset.sum_sub_distrib]
  simp

/-- source/main.tex:47 second equality: by the definition of x̄. -/
theorem L01_S2 (n : ℕ) (hn : 1 ≤ n) (x : Sample n) :
    (∑ i, x i) - (n : ℝ) * sampleMean x = 0 := by
  have hn' : (n : ℝ) ≠ 0 := by
    have : 0 < n := hn
    exact_mod_cast this.ne'
  unfold sampleMean
  field_simp

/-- source/main.tex:42-44 Lemma lem:centred. Assembled from S1, S2. -/
theorem L01_main (n : ℕ) (hn : 1 ≤ n) (x : Sample n) : Conclusion x := by
  unfold Conclusion
  rw [L01_S1 n hn x]
  exact L01_S2 n hn x

end Paper.L01

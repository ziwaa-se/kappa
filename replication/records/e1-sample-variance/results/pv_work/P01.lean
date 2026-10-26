import P01Stmt

namespace Paper.P01

/-- S1. source/main.tex:66-67: apply the cited Popoviciu inequality. -/
theorem P01_S1 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) (hP : Popoviciu) :
    (1 /(n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4 :=
  hP n a b x (by omega) hx

/-- S2. source/main.tex:68: multiply by n/(n-1) > 0. -/
theorem P01_S2 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (h : (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4) :
    sampleVar x ≤ (n : ℝ) / ((n : ℝ) - 1) * ((b - a) ^ 2 / 4) := by
  have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hpos : 0 < (n : ℝ) / ((n : ℝ) - 1) := div_pos (by linarith) (by linarith)
  have := mul_le_mul_of_nonneg_left h hpos.le
  have hne : (n : ℝ) ≠ 0 := by linarith
  have hne1 : (n : ℝ) - 1 ≠ 0 := by linarith
  have e : (n : ℝ) / ((n : ℝ) - 1) * ((1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2)
      = sampleVar x := by
    unfold sampleVar
    field_simp
    ring
  rw [e] at this
  exact this

/-- Proposition prop:popoviciu (source/main.tex:58-63). -/
theorem P01 (n : ℕ) (hn : 2 ≤ n) (a b : ℝ) (x : Sample n)
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) (hP : Popoviciu) :
    sampleVar x ≤ (n : ℝ) / ((n : ℝ) - 1) * ((b - a) ^ 2 / 4) := by
  have h1 := P01_S1 n hn a b x hx hP
  exact P01_S2 n hn a b x h1

end Paper.P01

import L03Stmt
import L02

namespace Paper.L03

/-- S1. source/main.tex:90 "By Lemma lem:shortcut, `(n-1) s^2 = ∑ x_i^2 - n x̄^2`". -/
theorem L03_S1 {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    ((n : ℝ) - 1) * sampleVar x = ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2 := by
  have h := Paper.L02.L02_main (by omega : 1 ≤ n) x
  unfold Paper.L02.Conclusion at h
  have hn' : ((n : ℝ) - 1) ≠ 0 := by
    have : (2 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  unfold sampleVar
  rw [← h]
  field_simp

/-- S2. source/main.tex:90 "`∑ x_i^2 - n x̄^2 ≤ ∑ x_i^2`" (since `n x̄^2 ≥ 0`). -/
theorem L03_S2 {n : ℕ} (x : Sample n) :
    ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2 ≤ ∑ i, (x i) ^ 2 := by
  have : 0 ≤ (n : ℝ) * (sampleMean x) ^ 2 := by positivity
  linarith

/-- S3. source/main.tex:91 "Dividing by `n` gives the claim." Stopped: false as stated
(gate probe), kept as `sorry`. -/
theorem L03_S3 {n : ℕ} (hn : 2 ≤ n) (x : Sample n)
    (h : ((n : ℝ) - 1) * sampleVar x ≤ ∑ i, (x i) ^ 2) :
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 := by
  sorry

/-- Main statement, main.tex:85-87 (with `n ≥ 2`). Assembly: S1, S2 give the hypothesis of S3. -/
theorem L03_main {n : ℕ} (hn : 2 ≤ n) (x : Sample n) : Conclusion x := by
  have h1 := L03_S1 hn x
  have h2 := L03_S2 x
  exact L03_S3 hn x (by linarith)

end Paper.L03

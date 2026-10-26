import L03Stmt
import L02

namespace Paper.L03

/-- source/main.tex:90 "By Lemma lem:shortcut, `(n-1) s^2 = ∑ x_i^2 - n x̄^2`". -/
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

/-- S2. source/main.tex:90. -/
theorem L03_S2 {n : ℕ} (x : Sample n) :
    ∑ i, (x i) ^ 2 - (n : ℝ) * (sampleMean x) ^ 2 ≤ ∑ i, (x i) ^ 2 := by
  have : 0 ≤ (n : ℝ) * (sampleMean x) ^ 2 := by positivity
  linarith

/-- S3 (stopped, main.tex:91) as a gap. -/
def L03_S3_Gap : Prop :=
  ∀ {n : ℕ} (hn : 2 ≤ n) (x : Sample n)
    (h : ((n : ℝ) - 1) * sampleVar x ≤ ∑ i, (x i) ^ 2),
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2

theorem L03_main_mod_gaps (hGap_3 : L03_S3_Gap) {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    Conclusion x := by
  have h1 := L03_S1 hn x
  have h2 := L03_S2 x
  exact hGap_3 hn x (by linarith)

end Paper.L03

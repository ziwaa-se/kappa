import C01Stmt

namespace Paper.C01

/-- S1. source/main.tex:99 "By Lemma lem:raw, `s^2 ≤ (1/n) ∑ x_i^2`". -/
theorem C01_S1 (hL : C01_L03Consumed) {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    sampleVar x ≤ (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 :=
  hL n x hn

/-- S2. source/main.tex:99 "`(1/n) ∑ x_i^2 ≤ 1`" (implicit: each `x_i^2 ≤ 1`). -/
theorem C01_S2 {n : ℕ} (hn : 2 ≤ n) (x : Sample n) (hx : ∀ i, |x i| ≤ 1) :
    (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 ≤ 1 := by
  have hpos : (0 : ℝ) < n := by exact_mod_cast (by omega : 0 < n)
  have hsum : ∑ i, (x i) ^ 2 ≤ (n : ℝ) := by
    calc ∑ i, (x i) ^ 2 ≤ ∑ _i : Fin n, (1 : ℝ) :=
          Finset.sum_le_sum (fun i _ => (sq_le_one_iff_abs_le_one _).2 (hx i))
      _ = n := by simp
  calc (1 / (n : ℝ)) * ∑ i, (x i) ^ 2 ≤ (1 / (n : ℝ)) * n :=
        mul_le_mul_of_nonneg_left hsum (by positivity)
    _ = 1 := by field_simp

/-- S3. source/main.tex:99 "`1 ≤ 2`". -/
theorem C01_S3 : (1 : ℝ) ≤ 2 := by norm_num

/-- Main statement, main.tex:94-96. Assembly: S1, S2, S3 chained. -/
theorem C01_main (hL : C01_L03Consumed) {n : ℕ} (hn : 2 ≤ n) (x : Sample n)
    (hx : ∀ i, |x i| ≤ 1) : Conclusion x :=
  (C01_S1 hL hn x).trans ((C01_S2 hn x hx).trans C01_S3)

end Paper.C01

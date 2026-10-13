import P02Stmt
import L01

namespace Paper.P02

private lemma var_nonneg {n : ℕ} (hn : 2 ≤ n) (x : Sample n) : 0 ≤ sampleVar x := by
  unfold sampleVar
  have : (2:ℝ) ≤ n := by exact_mod_cast hn
  apply mul_nonneg
  · apply one_div_nonneg.mpr; linarith
  · exact Finset.sum_nonneg (fun i _ => sq_nonneg _)

private lemma std_sq {n : ℕ} (hn : 2 ≤ n) (x : Sample n) : sampleStd x ^ 2 = sampleVar x := by
  unfold sampleStd
  exact Real.sq_sqrt (var_nonneg hn x)

private lemma sum_sq_eq {n : ℕ} (hn : 2 ≤ n) (x : Sample n) :
    ∑ i, (x i - sampleMean x) ^ 2 = ((n:ℝ) - 1) * sampleVar x := by
  have : (n:ℝ) - 1 ≠ 0 := by
    have : (2:ℝ) ≤ n := by exact_mod_cast hn
    linarith
  unfold sampleVar
  field_simp

/-- source/main.tex:76 "By Lemma 2.1, ∑_j z_j = 0". -/
theorem P02_S1 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) : ∑ j, z x j = 0 := by
  unfold z
  rw [← Finset.sum_div]
  have := Paper.L01.L01_main n (by omega) x
  unfold Paper.L01.Conclusion at this
  rw [this]; simp

/-- source/main.tex:76-77 -/
theorem P02_S2 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) :
    ∑ j, (z x j) ^ 2 = (n : ℝ) - 1 := by
  have h2 := std_sq hn x
  have hv : sampleVar x ≠ 0 := by rw [← h2]; exact pow_ne_zero 2 hs
  unfold z
  simp_rw [div_pow]
  rw [← Finset.sum_div, sum_sq_eq hn x, ← h2]
  rw [h2]
  field_simp

/-- source/main.tex:77 -/
theorem P02_S3 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (i : Fin n) :
    z x i = - ∑ j ∈ Finset.univ.erase i, z x j := by
  have h := P02_S1 n hn x
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)] at h
  linarith

/-- source/main.tex:77-80 -/
theorem P02_S4 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (i : Fin n) :
    (z x i) ^ 2 ≤ ((n : ℝ) - 1) * ∑ j ∈ Finset.univ.erase i, (z x j) ^ 2 := by
  have hc : ((Finset.univ.erase i).card : ℝ) = (n:ℝ) - 1 := by
    rw [Finset.card_erase_of_mem (Finset.mem_univ i)]
    simp
    rw [Nat.cast_sub (by omega)]; simp
  have := sq_sum_le_card_mul_sum_sq (s := Finset.univ.erase i) (f := fun j => z x j)
  rw [hc] at this
  rw [P02_S3 n hn x i, neg_sq]
  exact this

/-- source/main.tex:80 -/
theorem P02_S5 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    ((n : ℝ) - 1) * ∑ j ∈ Finset.univ.erase i, (z x j) ^ 2
      = ((n : ℝ) - 1) * ((n : ℝ) - 1 - (z x i) ^ 2) := by
  have h := P02_S2 n hn x hs
  rw [← Finset.add_sum_erase _ _ (Finset.mem_univ i)] at h
  congr 1
  linarith

/-- source/main.tex:82 -/
theorem P02_S6 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    (n : ℝ) * (z x i) ^ 2 ≤ ((n : ℝ) - 1) ^ 2 := by
  have h4 := P02_S4 n hn x i
  rw [P02_S5 n hn x hs i] at h4
  nlinarith

/-- source/main.tex:82 -/
theorem P02_S7 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    |z x i| ≤ ((n : ℝ) - 1) / Real.sqrt (n : ℝ) := by
  have h6 := P02_S6 n hn x hs i
  have hn2 : (2:ℝ) ≤ n := by exact_mod_cast hn
  have hp : 0 < Real.sqrt (n:ℝ) := Real.sqrt_pos.mpr (by linarith)
  rw [le_div_iff₀ hp]
  have hsq : (Real.sqrt (n:ℝ)) ^ 2 = n := Real.sq_sqrt (by linarith)
  apply le_of_sq_le_sq _ (by linarith)
  calc (|z x i| * Real.sqrt n) ^ 2 = (n:ℝ) * (z x i)^2 := by
        rw [mul_pow, sq_abs, hsq]; ring
    _ ≤ _ := h6

/-- source/main.tex:82 -/
theorem P02_S8 (n : ℕ) (hn : 2 ≤ n) (x : Sample n) (hs : sampleStd x ≠ 0) (i : Fin n) :
    |x i - sampleMean x| ≤ ((n : ℝ) - 1) / Real.sqrt (n : ℝ) * sampleStd x := by
  have h7 := P02_S7 n hn x hs i
  have hs0 : 0 ≤ sampleStd x := Real.sqrt_nonneg _
  have : x i - sampleMean x = z x i * sampleStd x := by
    unfold z; field_simp
  rw [this, abs_mul, abs_of_nonneg hs0]
  exact mul_le_mul_of_nonneg_right h7 hs0

/-- Gap: the case s = 0, untreated in source/main.tex:76 (division by s). -/
def P02_S0_Gap : Prop :=
  ∀ (n : ℕ), 2 ≤ n → ∀ (x : Sample n), sampleStd x = 0 → Conclusion x

/-- source/main.tex:71-73, modulo the untreated case s = 0. -/
theorem P02_main_mod_gaps (hGap_0 : P02_S0_Gap) (n : ℕ) (hn : 2 ≤ n) (x : Sample n) :
    Conclusion x := by
  by_cases hs : sampleStd x = 0
  · exact hGap_0 n hn x hs
  · intro i; exact P02_S8 n hn x hs i

end Paper.P02

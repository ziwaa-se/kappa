import Mathlib

open Finset BigOperators

namespace SampleVariance

/-- Definition 1.1: sample mean. -/
noncomputable def mean {n : ℕ} (x : Fin n → ℝ) : ℝ := (∑ i, x i) / n

/-- Definition 1.2: sample variance (used for `n ≥ 2`). -/
noncomputable def var {n : ℕ} (x : Fin n → ℝ) : ℝ :=
  (∑ i, (x i - mean x) ^ 2) / ((n : ℝ) - 1)

/-- Sample standard deviation. -/
noncomputable def sd {n : ℕ} (x : Fin n → ℝ) : ℝ := Real.sqrt (var x)

lemma sum_eq_n_mul_mean {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) :
    ∑ i, x i = n * mean x := by
  have : (n : ℝ) ≠ 0 := by positivity
  unfold mean; field_simp

/-- Lemma 2.1. -/
theorem lemma_2_1 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) :
    ∑ i, (x i - mean x) = 0 := by
  rw [Finset.sum_sub_distrib, sum_eq_n_mul_mean hn x]
  simp

/-- Lemma 2.2. -/
theorem lemma_2_2 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) :
    ∑ i, (x i - mean x) ^ 2 = ∑ i, x i ^ 2 - n * mean x ^ 2 := by
  have h : ∀ i, (x i - mean x) ^ 2 = x i ^ 2 - 2 * mean x * x i + mean x ^ 2 := by
    intro i; ring
  simp only [h, Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum,
    sum_eq_n_mul_mean hn x]
  simp; ring

/-- Shifted version of Lemma 2.2: the sum of squares about any `c`. -/
lemma sum_sq_shift {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) (c : ℝ) :
    ∑ i, (x i - mean x) ^ 2 = ∑ i, (x i - c) ^ 2 - n * (mean x - c) ^ 2 := by
  have h : ∀ i, (x i - c) ^ 2 = (x i - mean x) ^ 2 + 2 * (mean x - c) * (x i - mean x)
      + (mean x - c) ^ 2 := by
    intro i; ring
  simp only [h, Finset.sum_add_distrib, ← Finset.mul_sum, lemma_2_1 hn x]
  simp

/-- Proposition 2.3 (Popoviciu-type bound), proved from scratch. -/
theorem proposition_2_3 {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) (a b : ℝ)
    (hx : ∀ i, a ≤ x i ∧ x i ≤ b) :
    var x ≤ (n : ℝ) / (n - 1) * ((b - a) ^ 2 / 4) := by
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have hpos : (0 : ℝ) < n - 1 := by linarith
  have key : ∑ i, (x i - mean x) ^ 2 ≤ n * ((b - a) ^ 2 / 4) := by
    rw [sum_sq_shift (by omega) x ((a + b) / 2)]
    have h1 : ∑ i, (x i - (a + b) / 2) ^ 2 ≤ ∑ _i : Fin n, (b - a) ^ 2 / 4 := by
      apply Finset.sum_le_sum
      intro i _
      obtain ⟨h1, h2⟩ := hx i
      nlinarith
    simp at h1
    have : 0 ≤ (n : ℝ) * (mean x - (a + b) / 2) ^ 2 := by positivity
    linarith
  unfold var
  rw [div_le_iff₀ hpos]
  calc ∑ i, (x i - mean x) ^ 2 ≤ n * ((b - a) ^ 2 / 4) := key
    _ = (n : ℝ) / (n - 1) * ((b - a) ^ 2 / 4) * (n - 1) := by field_simp; ring

lemma sum_sq_dev_eq {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) :
    ∑ i, (x i - mean x) ^ 2 = ((n : ℝ) - 1) * var x := by
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have : (n : ℝ) - 1 ≠ 0 := by linarith
  unfold var; field_simp

lemma var_nonneg {n : ℕ} (x : Fin n → ℝ) (hn : 2 ≤ n) : 0 ≤ var x := by
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  unfold var
  apply div_nonneg (Finset.sum_nonneg (fun i _ => sq_nonneg _)); linarith

/-- Proposition 2.4 (Samuelson's inequality). The proof avoids dividing by `s`,
so it also covers the case `s = 0` which the paper's proof omits. -/
theorem proposition_2_4 {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) (i : Fin n) :
    |x i - mean x| ≤ ((n : ℝ) - 1) / Real.sqrt n * sd x := by
  set d : Fin n → ℝ := fun j => x j - mean x with hd
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have hsum : ∑ j, d j = 0 := lemma_2_1 (by omega) x
  have hsq : ∑ j, d j ^ 2 = ((n : ℝ) - 1) * var x := sum_sq_dev_eq hn x
  -- split off index i
  have hs1 : d i + ∑ j ∈ univ.erase i, d j = 0 := by
    rw [Finset.add_sum_erase _ _ (Finset.mem_univ i)]; exact hsum
  have hs2 : d i ^ 2 + ∑ j ∈ univ.erase i, d j ^ 2 = ((n : ℝ) - 1) * var x := by
    rw [Finset.add_sum_erase _ (fun j => d j ^ 2) (Finset.mem_univ i)]; exact hsq
  -- Cauchy–Schwarz on the remaining n-1 terms
  have hcs : (∑ j ∈ univ.erase i, d j) ^ 2 ≤ (univ.erase i).card * ∑ j ∈ univ.erase i, d j ^ 2 :=
    sq_sum_le_card_mul_sum_sq
  have hcard : ((univ.erase i).card : ℝ) = n - 1 := by
    rw [Finset.card_erase_of_mem (Finset.mem_univ i), Finset.card_univ, Fintype.card_fin]
    push_cast [show 1 ≤ n by omega]; ring
  rw [hcard] at hcs
  have hdi : d i = -∑ j ∈ univ.erase i, d j := by linarith
  have hmain : (n : ℝ) * d i ^ 2 ≤ ((n : ℝ) - 1) ^ 2 * var x := by
    have : d i ^ 2 ≤ ((n : ℝ) - 1) * (((n : ℝ) - 1) * var x - d i ^ 2) := by
      rw [hdi, neg_sq]; rw [hdi, neg_sq] at hs2; nlinarith
    nlinarith
  -- conclude
  have hv := var_nonneg x hn
  have hsqrtn : 0 < Real.sqrt n := Real.sqrt_pos.mpr (by linarith)
  have hsd : sd x ^ 2 = var x := Real.sq_sqrt hv
  have hR : 0 ≤ ((n : ℝ) - 1) / Real.sqrt n * sd x := by
    apply mul_nonneg (div_nonneg (by linarith) hsqrtn.le) (Real.sqrt_nonneg _)
  apply abs_le_of_sq_le_sq' _ hR |>.elim (fun h1 h2 => abs_le.mpr ⟨h1, h2⟩)
  rw [mul_pow, div_pow, Real.sq_sqrt (by linarith), hsd]
  rw [div_mul_eq_mul_div, le_div_iff₀ (by linarith)]
  show d i ^ 2 * n ≤ _
  linarith

/-- Lemma 2.5 is FALSE: counterexample n = 2, x = (1, -1). -/
theorem lemma_2_5_false :
    ¬ (∀ (n : ℕ), 2 ≤ n → ∀ x : Fin n → ℝ, var x ≤ (1 / (n : ℝ)) * ∑ i, x i ^ 2) := by
  intro h
  have := h 2 le_rfl ![1, -1]
  simp [var, mean, Fin.sum_univ_two] at this
  norm_num at this

/-- The correct version of Lemma 2.5: divide by `n - 1`, not `n`. -/
theorem lemma_2_5_corrected {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) :
    var x ≤ (1 / ((n : ℝ) - 1)) * ∑ i, x i ^ 2 := by
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have h := lemma_2_2 (by omega) x
  have : 0 ≤ (n : ℝ) * mean x ^ 2 := by positivity
  unfold var
  rw [one_div_mul_eq_div]
  apply div_le_div_of_nonneg_right _ (by linarith)
  linarith

/-- The intermediate claim `s² ≤ 1` in the proof of Corollary 2.6 is false. -/
theorem corollary_2_6_proof_step_false :
    ¬ (∀ (n : ℕ), 2 ≤ n → ∀ x : Fin n → ℝ, (∀ i, |x i| ≤ 1) → var x ≤ 1) := by
  intro h
  have := h 2 le_rfl ![1, -1] (by intro i; fin_cases i <;> simp)
  simp [var, mean, Fin.sum_univ_two] at this
  norm_num at this

/-- Corollary 2.6 is TRUE (proved via the corrected Lemma 2.5). The bound is sharp. -/
theorem corollary_2_6 {n : ℕ} (hn : 2 ≤ n) (x : Fin n → ℝ) (hx : ∀ i, |x i| ≤ 1) :
    var x ≤ 2 := by
  have hn1 : (1 : ℝ) < n := by exact_mod_cast hn
  have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have h := lemma_2_5_corrected hn x
  have hsum : ∑ i, x i ^ 2 ≤ n := by
    calc ∑ i, x i ^ 2 ≤ ∑ _i : Fin n, (1 : ℝ) := by
          apply Finset.sum_le_sum; intro i _
          have := hx i
          have : x i ^ 2 = |x i| ^ 2 := (sq_abs _).symm
          nlinarith [abs_nonneg (x i)]
      _ = n := by simp
  have hpos : (0 : ℝ) < n - 1 := by linarith
  calc var x ≤ 1 / ((n : ℝ) - 1) * ∑ i, x i ^ 2 := h
    _ ≤ 1 / ((n : ℝ) - 1) * n := by
        apply mul_le_mul_of_nonneg_left hsum; positivity
    _ ≤ 2 := by rw [one_div_mul_eq_div, div_le_iff₀ hpos]; linarith

/-- Sharpness of Corollary 2.6: equality at n = 2, x = (1, -1). -/
example : var (![1, -1] : Fin 2 → ℝ) = 2 := by
  simp [var, mean, Fin.sum_univ_two]; norm_num

end SampleVariance

import Mathlib

open Finset

/-- Core of Lemma 5.15 (with the corrected constant):
if (ε²/2)‖∇U(x₀)‖ ≥ 4‖x₀‖ and ε‖p₀‖ ≤ ‖x₀‖/2, then ‖x_ε‖ > 2‖x₀‖. -/
theorem lemma_5_15_core {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (x₀ g p : E) (ε : ℝ) (hε : 0 < ε) (hx : 0 < ‖x₀‖)
    (hg : 4 * ‖x₀‖ ≤ ε ^ 2 / 2 * ‖g‖) (hp : ε * ‖p‖ ≤ ‖x₀‖ / 2) :
    2 * ‖x₀‖ < ‖x₀ - (ε ^ 2 / 2) • g + ε • p‖ := by
  set v := x₀ - (ε ^ 2 / 2) • g + ε • p with hv
  have key : (ε ^ 2 / 2) • g = x₀ + ε • p - v := by rw [hv]; abel
  have h1 : ‖(ε ^ 2 / 2) • g‖ ≤ ‖x₀‖ + ‖ε • p‖ + ‖v‖ := by
    rw [key]
    calc ‖x₀ + ε • p - v‖ ≤ ‖x₀ + ε • p‖ + ‖v‖ := norm_sub_le _ _
      _ ≤ ‖x₀‖ + ‖ε • p‖ + ‖v‖ := by gcongr; exact norm_add_le _ _
  rw [norm_smul, norm_smul, Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ ε ^ 2 / 2),
    Real.norm_of_nonneg hε.le] at h1
  linarith

/-- γ_L in Lemma 5.17: 1 - 2 Σ_{i=1}^L 3^{-i} = 3^{-L} > 0. -/
theorem gamma_L (L : ℕ) :
    1 - 2 * ∑ i ∈ Icc 1 L, ((1:ℝ) / 3) ^ i = ((1:ℝ) / 3) ^ L := by
  induction L with
  | zero => simp
  | succ n ih =>
    rw [sum_Icc_succ_top (by omega), pow_succ]
    linarith

/-- Squaring step of Lemma 5.17, with A = εγ_L‖∇U(x_{Lε})‖/2, P = ‖p₀‖, q = ‖p_{Lε}‖. -/
theorem lemma_5_17_square (P q A : ℝ) (hA : 0 ≤ A - P) (hq : A - P ≤ q) :
    P ^ 2 - q ^ 2 ≤ 2 * A * (P - A / 2) := by
  nlinarith [mul_nonneg (sub_nonneg.2 hq) (add_nonneg (le_trans hA hq) hA)]

/-- 2^{3/2} < 3. -/
theorem two_rpow_three_halves_lt_three : (2:ℝ) ^ ((3:ℝ) / 2) < 3 := by
  have h0 : (0:ℝ) ≤ 2 ^ ((3:ℝ) / 2) := Real.rpow_nonneg (by norm_num) _
  have hsq : ((2:ℝ) ^ ((3:ℝ) / 2)) ^ (2:ℕ) = 8 := by
    rw [← Real.rpow_natCast, ← Real.rpow_mul (by norm_num),
      show (3:ℝ) / 2 * ((2:ℕ):ℝ) = ((3:ℕ):ℝ) by norm_num, Real.rpow_natCast]
    norm_num
  nlinarith [hsq]

/-- Counterexample: for U(x) = α|x|^{5/2} (β = 5/2 > 2), U'(x) ∝ x^{3/2} on x > 0,
and condition (5.oscillations) fails for every C. So Cor 2.3(ii) for β = 5/2
is not a direct consequence of Theorem 2.2(i) as stated. -/
theorem oscillations_fails_beta_five_halves (C : ℝ) :
    ∃ x y : ℝ, 0 < x ∧ C ≤ 2 * x ∧ 2 * x ≤ y ∧
      y ^ ((3:ℝ) / 2) < 3 * x ^ ((3:ℝ) / 2) := by
  have hx : 0 < max C 1 := lt_max_of_lt_right one_pos
  refine ⟨max C 1, 2 * max C 1, hx, ?_, le_rfl, ?_⟩
  · have := le_max_left C 1; linarith
  · rw [Real.mul_rpow (by norm_num) hx.le]
    have hp : 0 < (max C 1) ^ ((3:ℝ) / 2) := Real.rpow_pos_of_pos hx _
    nlinarith [two_rpow_three_halves_lt_three]

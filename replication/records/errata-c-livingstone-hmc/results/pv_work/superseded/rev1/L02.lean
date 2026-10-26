import L02Stmt

open Paper.Defs

namespace Paper.L02

/-! ## Private technical helpers (unfolding of `leapfrogStep`, norm and filter conversions).
No mathematical content beyond the source's formulas. -/

private lemma xLF_zero {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 0 = x0 := rfl

private lemma xLF_one {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 1 = x0 + eps • p0 - (eps ^ 2 / 2) • gU x0 := by
  simp only [xLF, leapfrogState, leapfrogStep]
  module

private lemma xLF_rec {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (n : ℕ) :
    xLF gU eps x0 p0 (n + 2) = (2 : ℝ) • xLF gU eps x0 p0 (n + 1) - xLF gU eps x0 p0 n
      - eps ^ 2 • gU (xLF gU eps x0 p0 (n + 1)) := by
  simp only [xLF, leapfrogState, leapfrogStep]
  module

private lemma xLF_diff {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (n : ℕ) :
    xLF gU eps x0 p0 (n + 1) - xLF gU eps x0 p0 n = eps • p0 - (eps ^ 2 / 2) • gU x0
      - eps ^ 2 • ∑ j ∈ Finset.Ico 1 (n + 1), gU (xLF gU eps x0 p0 j) := by
  induction n with
  | zero =>
    rw [xLF_one, xLF_zero]
    simp only [Finset.Ico_self, Finset.sum_empty, smul_zero, sub_zero]
    module
  | succ n ih =>
    rw [Finset.sum_Ico_succ_top (by omega : 1 ≤ n + 1)]
    have h := xLF_rec gU eps x0 p0 n
    rw [smul_add]
    linear_combination (norm := module) ih + h

private lemma hbig {d : ℕ} {gU : E d → E d} (hexp : HypExplode gU) (M : ℝ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → M * ‖x‖ ≤ ‖gU x‖ := by
  have h := hexp.eventually (Filter.eventually_ge_atTop M)
  rw [Filter.eventually_comap, Filter.eventually_atTop] at h
  obtain ⟨N, hN⟩ := h
  refine ⟨max N 0, fun x hx => ?_⟩
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have := hN _ (le_of_lt (lt_of_le_of_lt (le_max_left _ _) hx)) x rfl
  rwa [le_div_iff₀ hx0] at this

private lemma ple {d : ℕ} (x0 p0 : E d) (δ : ℝ) (hδ : δ < 1) (h1 : 1 ≤ ‖x0‖)
    (hp : ‖p0‖ ≤ ‖x0‖ ^ δ) : ‖p0‖ ≤ ‖x0‖ := by
  refine hp.trans ?_
  calc ‖x0‖ ^ δ ≤ ‖x0‖ ^ (1 : ℝ) := Real.rpow_le_rpow_of_exponent_le h1 hδ.le
    _ = ‖x0‖ := Real.rpow_one _

private lemma norm5 {d : ℕ} (a b c e f : E d) :
    ‖a + b - c - e - f‖ ≤ ‖a‖ + ‖b‖ + ‖c‖ + ‖e‖ + ‖f‖ := by
  have h1 := norm_sub_le (a + b - c - e) f
  have h2 := norm_sub_le (a + b - c) e
  have h3 := norm_sub_le (a + b) c
  have h4 := norm_add_le a b
  linarith

/-- first-step bound `ε²‖∇U(x_0)‖ ≤ 2‖x_ε‖ + 2‖x_0‖ + 2ε‖p_0‖` (TEX:890 / 914). -/
private lemma x1_bound {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) :
    eps ^ 2 * ‖gU x0‖ ≤ 2 * ‖xLF gU eps x0 p0 1‖ + 2 * ‖x0‖ + 2 * eps * ‖p0‖ := by
  have h1 : (eps ^ 2 / 2) • gU x0 = x0 + eps • p0 - xLF gU eps x0 p0 1 := by
    rw [xLF_one]; module
  have h2 : ‖(eps ^ 2 / 2) • gU x0‖ ≤ ‖x0‖ + eps * ‖p0‖ + ‖xLF gU eps x0 p0 1‖ := by
    rw [h1]
    have h3 := norm_sub_le (x0 + eps • p0) (xLF gU eps x0 p0 1)
    have h4 := norm_add_le x0 (eps • p0)
    rw [norm_smul, Real.norm_of_nonneg heps.le] at h4
    linarith
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at h2
  linarith

/-- the general step bound, from `x_{m+1} - x_m` (the one-step identity obtained from S1'). -/
private lemma step_bound {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (m : ℕ) (hm : 1 ≤ m) :
    eps ^ 2 * ‖gU (xLF gU eps x0 p0 m)‖ ≤ ‖xLF gU eps x0 p0 (m + 1)‖ + ‖xLF gU eps x0 p0 m‖
      + eps * ‖p0‖ + (eps ^ 2 / 2) * ‖gU x0‖
      + eps ^ 2 * ∑ j ∈ Finset.Ico 1 m, ‖gU (xLF gU eps x0 p0 j)‖ := by
  have h := xLF_diff gU eps x0 p0 m
  rw [Finset.sum_Ico_succ_top hm] at h
  have e : eps ^ 2 • gU (xLF gU eps x0 p0 m) = xLF gU eps x0 p0 m + eps • p0
      - (eps ^ 2 / 2) • gU x0 - eps ^ 2 • ∑ j ∈ Finset.Ico 1 m, gU (xLF gU eps x0 p0 j)
      - xLF gU eps x0 p0 (m + 1) := by
    rw [smul_add] at h
    linear_combination (norm := module) h
  have hn := norm5 (xLF gU eps x0 p0 m) (eps • p0) ((eps ^ 2 / 2) • gU x0)
    (eps ^ 2 • ∑ j ∈ Finset.Ico 1 m, gU (xLF gU eps x0 p0 j)) (xLF gU eps x0 p0 (m + 1))
  rw [← e] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity), norm_smul,
    Real.norm_of_nonneg heps.le, norm_smul, Real.norm_of_nonneg (by positivity),
    norm_smul, Real.norm_of_nonneg (by positivity)] at hn
  have hs := norm_sum_le (Finset.Ico 1 m) (fun j => gU (xLF gU eps x0 p0 j))
  have : eps ^ 2 * ‖∑ j ∈ Finset.Ico 1 m, gU (xLF gU eps x0 p0 j)‖
      ≤ eps ^ 2 * ∑ j ∈ Finset.Ico 1 m, ‖gU (xLF gU eps x0 p0 j)‖ :=
    mul_le_mul_of_nonneg_left hs (by positivity)
  linarith

private lemma seq_mono (n : ℕ → ℝ) (m : ℕ) (hn : ∀ j, 0 ≤ n j)
    (h : ∀ j, 1 ≤ j → j ≤ m → 2 * n (j - 1) ≤ n j) : ∀ k, k ≤ m → n 0 ≤ n k := by
  intro k
  induction k with
  | zero => intro _; exact le_rfl
  | succ k ih =>
    intro hk
    have h1 := h (k + 1) (by omega) hk
    simp only [Nat.add_sub_cancel] at h1
    have := ih (by omega)
    linarith [hn k]

private lemma seq_sum (g : ℕ → ℝ) (m : ℕ) (hg : ∀ j, 0 ≤ g j)
    (h : ∀ j, 1 ≤ j → j ≤ m → 3 * g (j - 1) ≤ g j) :
    ∀ k, 1 ≤ k → k ≤ m → g 0 + ∑ j ∈ Finset.Ico 1 k, g j ≤ g k / 2 := by
  intro k hk
  induction k, hk using Nat.le_induction with
  | base =>
    intro hm
    have h1 := h 1 le_rfl hm
    simp only [Nat.sub_self, Finset.Ico_self, Finset.sum_empty, add_zero] at h1 ⊢
    linarith [hg 0]
  | succ k hk ih =>
    intro hm
    rw [Finset.sum_Ico_succ_top hk]
    have h1 := ih (by omega)
    have h2 := h (k + 1) (by omega) hm
    simp only [Nat.add_sub_cancel] at h2
    linarith [hg k]

/-! ## Step obligations -/

/-- S1 (TEX:906): `x_{2ε} = x_ε - ε²∇U(x_ε) - (ε²/2)∇U(x_0) + ε p_0`.  Unfolding `leapfrogStep` twice. -/
theorem L02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 2 = xLF gU eps x0 p0 1 - eps ^ 2 • gU (xLF gU eps x0 p0 1)
      - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  have h := xLF_rec gU eps x0 p0 0
  have h1 := xLF_one gU eps x0 p0
  simp only [zero_add] at h
  rw [xLF_zero] at h
  rw [h, h1]
  module

/-- S1' (eqn:mprop, TEX:364), derivable by induction from `leapfrogStep`. -/
theorem L02_S1_general {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (L : ℕ) :
    xLF gU eps x0 p0 L = x0 - ((L : ℝ) * eps ^ 2 / 2) • gU x0
      - eps ^ 2 • ∑ i ∈ Finset.Ico 1 L, ((L : ℝ) - i) • gU (xLF gU eps x0 p0 i)
      + ((L : ℝ) * eps) • p0 := by
  induction L with
  | zero => simp [xLF_zero]
  | succ L ih =>
    have h := xLF_diff gU eps x0 p0 L
    rcases Nat.eq_zero_or_pos L with rfl | hL
    · rw [xLF_one]
      simp only [Finset.Ico_self, Finset.sum_empty, smul_zero, Nat.cast_zero, zero_add,
        Nat.cast_one]
      module
    · rw [Finset.sum_Ico_succ_top (by omega : 1 ≤ L)] at h
      have hs : ∑ i ∈ Finset.Ico 1 (L + 1), (((L + 1 : ℕ) : ℝ) - i) • gU (xLF gU eps x0 p0 i)
          = ∑ i ∈ Finset.Ico 1 L, ((L : ℝ) - i) • gU (xLF gU eps x0 p0 i)
            + ∑ i ∈ Finset.Ico 1 L, gU (xLF gU eps x0 p0 i) + gU (xLF gU eps x0 p0 L) := by
        rw [Finset.sum_Ico_succ_top (by omega : 1 ≤ L), ← Finset.sum_add_distrib]
        have : ∀ i ∈ Finset.Ico 1 L, (((L + 1 : ℕ) : ℝ) - i) • gU (xLF gU eps x0 p0 i)
            = ((L : ℝ) - i) • gU (xLF gU eps x0 p0 i) + gU (xLF gU eps x0 p0 i) := by
          intro i _
          push_cast
          module
        rw [Finset.sum_congr rfl this]
        push_cast
        simp
      rw [hs]
      rw [smul_add] at h
      push_cast
      linear_combination (norm := module) ih + h

/-- S2 (TEX:909-911). -/
theorem L02_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : xLF gU eps x0 p0 1 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 1‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 1‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 1‖) ≤
      ‖xLF gU eps x0 p0 2‖ / ‖xLF gU eps x0 p0 1‖ := by
  have hpos : 0 < ‖xLF gU eps x0 p0 1‖ := norm_pos_iff.mpr hx
  have e : eps ^ 2 • gU (xLF gU eps x0 p0 1) = xLF gU eps x0 p0 1 + eps • p0
      - (eps ^ 2 / 2) • gU x0 - xLF gU eps x0 p0 2 := by
    rw [L02_S1]; module
  have hn := norm_sub_le (xLF gU eps x0 p0 1 + eps • p0 - (eps ^ 2 / 2) • gU x0)
    (xLF gU eps x0 p0 2)
  have hn2 := norm_sub_le (xLF gU eps x0 p0 1 + eps • p0) ((eps ^ 2 / 2) • gU x0)
  have hn3 := norm_add_le (xLF gU eps x0 p0 1) (eps • p0)
  rw [← e] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn2
  rw [norm_smul, Real.norm_of_nonneg heps.le] at hn3
  have g1 := norm_nonneg (gU (xLF gU eps x0 p0 1))
  rw [le_div_iff₀ hpos]
  have e2 : ((eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 1‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 1‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 1‖)) * ‖xLF gU eps x0 p0 1‖
      = (eps ^ 2 / 2) * ‖gU (xLF gU eps x0 p0 1)‖ - (eps ^ 2 / 2) * ‖gU x0‖
        - ‖xLF gU eps x0 p0 1‖ - eps * ‖p0‖ := by
    field_simp
    ring
  rw [e2]
  nlinarith [sq_nonneg eps]

/-- S3 (TEX:913-916). -/
theorem L02_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU)
    (δ δ' : ℝ) (hδ : δ < 1) (hδ' : 0 < δ') :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (eps ^ 2 * ‖gU x0‖ - 2 * ‖x0‖ - 2 * eps * ‖p0‖) / (eps ^ 2 * ‖gU x0‖) ≤
        2 * ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU x0‖) ∧
      1 - δ' ≤ (eps ^ 2 * ‖gU x0‖ - 2 * ‖x0‖ - 2 * eps * ‖p0‖) / (eps ^ 2 * ‖gU x0‖) := by
  obtain ⟨R, hR⟩ := hbig hexp ((2 + 2 * eps) / (δ' * eps ^ 2))
  refine ⟨max R 1, fun x0 p0 hx hp => ?_⟩
  have hx1 : 1 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hxR : R < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hpn := ple x0 p0 δ hδ hx1.le hp
  have hg := hR x0 hxR
  have hM : 0 < (2 + 2 * eps) / (δ' * eps ^ 2) := by positivity
  have hgpos : 0 < ‖gU x0‖ := lt_of_lt_of_le (by positivity) hg
  have hA : 0 < eps ^ 2 * ‖gU x0‖ := by positivity
  have hb := x1_bound gU eps heps x0 p0
  constructor
  · apply div_le_div_of_nonneg_right _ hA.le
    linarith
  · rw [le_div_iff₀ hA]
    have h1 : (2 + 2 * eps) * ‖x0‖ ≤ δ' * (eps ^ 2 * ‖gU x0‖) := by
      rw [div_mul_eq_mul_div, div_le_iff₀ (by positivity)] at hg
      nlinarith
    nlinarith [mul_le_mul_of_nonneg_left hpn heps.le]

/-- S4 (TEX:912). -/
theorem L02_S4 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖xLF gU eps x0 p0 1‖ ≤ ‖xLF gU eps x0 p0 2‖ := by
  obtain ⟨η3, h3⟩ := L02_S3 gU eps heps hexp δ (1 / 2) hδ (by norm_num)
  obtain ⟨η1, h1⟩ := hL01 δ hδ
  obtain ⟨R, hR⟩ := hbig hexp (2 * (5 + eps) / eps ^ 2)
  refine ⟨max (max η3 η1) (max R 1), fun x0 p0 hx hp => ?_⟩
  have hx3 : η3 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
  have hx1 : η1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
  have hxR : R < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_right _ _)) hx
  have hx1' : 1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_right _ _)) hx
  have hpn := ple x0 p0 δ hδ hx1'.le hp
  have hL := h1 x0 p0 hx1 hp
  have hn1pos : 0 < ‖xLF gU eps x0 p0 1‖ := by linarith
  have hx1ne : xLF gU eps x0 p0 1 ≠ 0 := norm_pos_iff.mp hn1pos
  obtain ⟨s3a, s3b⟩ := h3 x0 p0 hx3 hp
  have hmid : 1 / 2 ≤ 2 * ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU x0‖) := by linarith
  have hA : 0 < eps ^ 2 * ‖gU x0‖ := by
    rcases (by positivity : (0 : ℝ) ≤ eps ^ 2 * ‖gU x0‖).lt_or_eq with h | h
    · exact h
    · exfalso; rw [← h, div_zero] at hmid; linarith
  rw [le_div_iff₀ hA] at hmid
  have hg1 := hR (xLF gU eps x0 p0 1) (by linarith)
  have hS2 := L02_S2 gU eps heps x0 p0 hx1ne
  set n1 := ‖xLF gU eps x0 p0 1‖ with hn1
  have hM : 2 * (5 + eps) / eps ^ 2 ≤ ‖gU (xLF gU eps x0 p0 1)‖ / n1 := by
    rw [le_div_iff₀ hn1pos]; exact hg1
  have t1 : 5 + eps ≤ (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 1)‖ / n1) := by
    have := mul_le_mul_of_nonneg_left hM (by positivity : (0 : ℝ) ≤ eps ^ 2 / 2)
    have e : eps ^ 2 / 2 * (2 * (5 + eps) / eps ^ 2) = 5 + eps := by field_simp; ring
    linarith
  have t2 : (eps ^ 2 / 2) * (‖gU x0‖ / n1) ≤ 2 := by
    rw [show (eps ^ 2 / 2) * (‖gU x0‖ / n1) = (eps ^ 2 * ‖gU x0‖) / (2 * n1) by
      field_simp, div_le_iff₀ (by positivity)]
    linarith
  have t3 : eps * (‖p0‖ / n1) ≤ eps := by
    have : ‖p0‖ / n1 ≤ 1 := by
      rw [div_le_one hn1pos]; linarith
    nlinarith
  have : 2 ≤ ‖xLF gU eps x0 p0 2‖ / n1 := by linarith
  rwa [le_div_iff₀ hn1pos] at this

/-- S5 (TEX:919-921). -/
theorem L02_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : xLF gU eps x0 p0 2 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 2)‖ / ‖xLF gU eps x0 p0 2‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 2‖)
      - eps ^ 2 * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 2‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 2‖) ≤
      ‖xLF gU eps x0 p0 3‖ / ‖xLF gU eps x0 p0 2‖ := by
  have hpos : 0 < ‖xLF gU eps x0 p0 2‖ := norm_pos_iff.mpr hx
  have hsb := step_bound gU eps heps x0 p0 2 (by norm_num)
  have hsum : ∑ j ∈ Finset.Ico 1 2, ‖gU (xLF gU eps x0 p0 j)‖ = ‖gU (xLF gU eps x0 p0 1)‖ := by
    rw [show (2 : ℕ) = 1 + 1 from rfl, Finset.sum_Ico_succ_top le_rfl]
    simp
  rw [hsum] at hsb
  have g2 := norm_nonneg (gU (xLF gU eps x0 p0 2))
  rw [le_div_iff₀ hpos]
  have e2 : ((eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 2)‖ / ‖xLF gU eps x0 p0 2‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 2‖)
      - eps ^ 2 * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 2‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 2‖)) * ‖xLF gU eps x0 p0 2‖
      = (eps ^ 2 / 2) * ‖gU (xLF gU eps x0 p0 2)‖ - (eps ^ 2 / 2) * ‖gU x0‖
        - eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖
        - ‖xLF gU eps x0 p0 2‖ - eps * ‖p0‖ := by
    field_simp
    ring
  rw [e2]
  nlinarith [sq_nonneg eps]

/-- S6 (TEX:922-925). -/
theorem L02_S6 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ δ' : ℝ) (hδ : δ < 1) (hδ' : 0 < δ') :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 / eps ^ 2) * (‖xLF gU eps x0 p0 1‖ / ‖gU x0‖) ≤
        (2 / eps ^ 2) * (‖xLF gU eps x0 p0 2‖ / ‖gU x0‖) ∧
      1 - δ' ≤ (2 / eps ^ 2) * (‖xLF gU eps x0 p0 1‖ / ‖gU x0‖) := by
  obtain ⟨η3, h3⟩ := L02_S3 gU eps heps hexp δ δ' hδ hδ'
  obtain ⟨η4, h4⟩ := L02_S4 gU eps hL01 heps hexp δ hδ
  refine ⟨max η3 η4, fun x0 p0 hx hp => ?_⟩
  have hx3 : η3 < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx4 : η4 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  obtain ⟨s3a, s3b⟩ := h3 x0 p0 hx3 hp
  have s4 := h4 x0 p0 hx4 hp
  constructor
  · apply mul_le_mul_of_nonneg_left _ (by positivity)
    apply div_le_div_of_nonneg_right _ (norm_nonneg _)
    linarith [norm_nonneg (xLF gU eps x0 p0 1)]
  · rw [div_mul_div_comm]
    linarith

/-- S7 (TEX:927-929). -/
theorem L02_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hg : gU (xLF gU eps x0 p0 1) ≠ 0) :
    1 - ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖gU x0‖ / (2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖p0‖ / (eps * ‖gU (xLF gU eps x0 p0 1)‖) ≤
      ‖xLF gU eps x0 p0 2‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖) := by
  have hgpos : 0 < ‖gU (xLF gU eps x0 p0 1)‖ := norm_pos_iff.mpr hg
  have hA : 0 < eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖ := by positivity
  have e : eps ^ 2 • gU (xLF gU eps x0 p0 1) = xLF gU eps x0 p0 1 + eps • p0
      - (eps ^ 2 / 2) • gU x0 - xLF gU eps x0 p0 2 := by
    rw [L02_S1]; module
  have hn := norm_sub_le (xLF gU eps x0 p0 1 + eps • p0 - (eps ^ 2 / 2) • gU x0)
    (xLF gU eps x0 p0 2)
  have hn2 := norm_sub_le (xLF gU eps x0 p0 1 + eps • p0) ((eps ^ 2 / 2) • gU x0)
  have hn3 := norm_add_le (xLF gU eps x0 p0 1) (eps • p0)
  rw [← e] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn2
  rw [norm_smul, Real.norm_of_nonneg heps.le] at hn3
  rw [le_div_iff₀ hA]
  have e2 : (1 - ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖gU x0‖ / (2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖p0‖ / (eps * ‖gU (xLF gU eps x0 p0 1)‖)) * (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖)
      = eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖ - ‖xLF gU eps x0 p0 1‖
        - (eps ^ 2 / 2) * ‖gU x0‖ - eps * ‖p0‖ := by
    field_simp
    ring
  rw [e2]
  linarith

/-- S8a (TEX:930, first sentence). -/
theorem L02_S8a {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ ζ : ℝ) (hδ : δ < 1) (hζ : 0 < ζ) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖) < ζ ∧
      ‖p0‖ / (eps * ‖gU (xLF gU eps x0 p0 1)‖) < ζ := by
  obtain ⟨η1, h1⟩ := hL01 δ hδ
  obtain ⟨R, hR⟩ := hbig hexp (2 / (eps ^ 2 * ζ) + 2 / (eps * ζ))
  refine ⟨max (max η1 R) 1, fun x0 p0 hx hp => ?_⟩
  have hx1 : η1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
  have hxR : R < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
  have hx1' : 1 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hpn := ple x0 p0 δ hδ hx1'.le hp
  have hL := h1 x0 p0 hx1 hp
  have hn1pos : 0 < ‖xLF gU eps x0 p0 1‖ := by linarith
  have hg := hR (xLF gU eps x0 p0 1) (by linarith)
  have hM1 : 0 < 2 / (eps ^ 2 * ζ) := by positivity
  have hM2 : 0 < 2 / (eps * ζ) := by positivity
  have hgpos : 0 < ‖gU (xLF gU eps x0 p0 1)‖ := by
    have : 0 < (2 / (eps ^ 2 * ζ) + 2 / (eps * ζ)) * ‖xLF gU eps x0 p0 1‖ := by positivity
    linarith
  set g1 := ‖gU (xLF gU eps x0 p0 1)‖
  set n1 := ‖xLF gU eps x0 p0 1‖
  have k1 : eps ^ 2 * ζ * (2 / (eps ^ 2 * ζ)) = 2 := by field_simp
  have k2 : eps * ζ * (2 / (eps * ζ)) = 2 := by field_simp
  constructor
  · rw [div_lt_iff₀ (by positivity)]
    have : eps ^ 2 * ζ * ((2 / (eps ^ 2 * ζ) + 2 / (eps * ζ)) * n1) ≤ eps ^ 2 * ζ * g1 :=
      mul_le_mul_of_nonneg_left hg (by positivity)
    nlinarith [mul_pos (by positivity : 0 < eps ^ 2 * ζ) (mul_pos hM2 hn1pos)]
  · rw [div_lt_iff₀ (by positivity)]
    have : eps * ζ * ((2 / (eps ^ 2 * ζ) + 2 / (eps * ζ)) * n1) ≤ eps * ζ * g1 :=
      mul_le_mul_of_nonneg_left hg (by positivity)
    nlinarith [mul_pos (by positivity : 0 < eps * ζ) (mul_pos hM1 hn1pos)]

/-- S8b (TEX:930-933), uses (18) (as the printed route does). -/
theorem L02_S8b {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖gU x0‖ / (2 * ‖gU (xLF gU eps x0 p0 1)‖) ≤ 1 / 6 := by
  obtain ⟨η1, h1⟩ := hL01 δ hδ
  obtain ⟨C, hC⟩ := hosc
  refine ⟨max η1 (C / 2), fun x0 p0 hx hp => ?_⟩
  have hx1 : η1 < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hxC : C / 2 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hL := h1 x0 p0 hx1 hp
  have h3 := hC x0 (xLF gU eps x0 p0 1) hL.le (by linarith)
  have g0 := norm_nonneg (gU x0)
  rcases (norm_nonneg (gU (xLF gU eps x0 p0 1))).lt_or_eq with h | h
  · rw [div_le_iff₀ (by positivity)]
    linarith
  · rw [← h] at h3 ⊢
    simp only [mul_zero, div_zero]
    norm_num

/-- S9 (TEX:934). -/
theorem L02_S9 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖xLF gU eps x0 p0 2‖ ≤ ‖xLF gU eps x0 p0 3‖ := by
  obtain ⟨η4, h4⟩ := L02_S4 gU eps hL01 heps hexp δ hδ
  obtain ⟨η6, h6⟩ := L02_S6 gU eps hL01 heps hexp δ (1 / 2) hδ (by norm_num)
  obtain ⟨η8a, h8a⟩ := L02_S8a gU eps hL01 heps hexp δ (1 / 6) hδ (by norm_num)
  obtain ⟨η8b, h8b⟩ := L02_S8b gU eps hL01 heps hosc δ hδ
  obtain ⟨η1, h1⟩ := hL01 δ hδ
  obtain ⟨R, hR⟩ := hbig hexp (2 * (7 + eps) / eps ^ 2)
  refine ⟨max (max (max η4 η6) (max η8a η8b)) (max (max η1 R) 1), fun x0 p0 hx hp => ?_⟩
  have hx4 : η4 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_left _ _) (le_max_left _ _))
    (le_max_left _ _)) hx
  have hx6 : η6 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_right _ _) (le_max_left _ _))
    (le_max_left _ _)) hx
  have hx8a : η8a < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_left _ _)
    (le_max_right _ _)) (le_max_left _ _)) hx
  have hx8b : η8b < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_right _ _)
    (le_max_right _ _)) (le_max_left _ _)) hx
  have hx1 : η1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_left _ _) (le_max_left _ _))
    (le_max_right _ _)) hx
  have hxR : R < ‖x0‖ := lt_of_le_of_lt (le_trans (le_trans (le_max_right _ _) (le_max_left _ _))
    (le_max_right _ _)) hx
  have hx1' : 1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_right _ _)) hx
  have hpn := ple x0 p0 δ hδ hx1'.le hp
  have hL := h1 x0 p0 hx1 hp
  have s4 := h4 x0 p0 hx4 hp
  have hn1pos : 0 < ‖xLF gU eps x0 p0 1‖ := by linarith
  have hn2pos : 0 < ‖xLF gU eps x0 p0 2‖ := by linarith
  have hx2ne : xLF gU eps x0 p0 2 ≠ 0 := norm_pos_iff.mp hn2pos
  have hg1 := hR (xLF gU eps x0 p0 1) (by linarith)
  have hg2 := hR (xLF gU eps x0 p0 2) (by linarith)
  have hM : 0 < 2 * (7 + eps) / eps ^ 2 := by positivity
  have hg1pos : 0 < ‖gU (xLF gU eps x0 p0 1)‖ := by
    have : 0 < (2 * (7 + eps) / eps ^ 2) * ‖xLF gU eps x0 p0 1‖ := by positivity
    linarith
  have hg1ne : gU (xLF gU eps x0 p0 1) ≠ 0 := norm_pos_iff.mp hg1pos
  have hS5 := L02_S5 gU eps heps x0 p0 hx2ne
  have hS7 := L02_S7 gU eps heps x0 p0 hg1ne
  obtain ⟨s6a, s6b⟩ := h6 x0 p0 hx6 hp
  obtain ⟨s8a1, s8a2⟩ := h8a x0 p0 hx8a hp
  have s8b := h8b x0 p0 hx8b hp
  set n2 := ‖xLF gU eps x0 p0 2‖ with hn2
  set g1 := ‖gU (xLF gU eps x0 p0 1)‖ with hg1d
  set g0 := ‖gU x0‖ with hg0d
  -- first term
  have hM2 : 2 * (7 + eps) / eps ^ 2 ≤ ‖gU (xLF gU eps x0 p0 2)‖ / n2 := by
    rw [le_div_iff₀ hn2pos]; exact hg2
  have t1 : 7 + eps ≤ (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 2)‖ / n2) := by
    have := mul_le_mul_of_nonneg_left hM2 (by positivity : (0 : ℝ) ≤ eps ^ 2 / 2)
    have e : eps ^ 2 / 2 * (2 * (7 + eps) / eps ^ 2) = 7 + eps := by field_simp; ring
    linarith
  -- second term (S6, (22) of the source)
  have hmid : 1 / 2 ≤ 2 * n2 / (eps ^ 2 * g0) := by
    rw [div_mul_div_comm (2 : ℝ) (eps ^ 2) n2 g0] at s6a
    rw [div_mul_div_comm] at s6a s6b
    linarith
  have hA0 : 0 < eps ^ 2 * g0 := by
    rcases (by positivity : (0 : ℝ) ≤ eps ^ 2 * g0).lt_or_eq with h | h
    · exact h
    · exfalso; rw [← h, div_zero] at hmid; linarith
  rw [le_div_iff₀ hA0] at hmid
  have t2 : (eps ^ 2 / 2) * (g0 / n2) ≤ 2 := by
    rw [show (eps ^ 2 / 2) * (g0 / n2) = (eps ^ 2 * g0) / (2 * n2) by field_simp,
      div_le_iff₀ (by positivity)]
    linarith
  -- third term (S7, S8a, S8b)
  have hmid3 : 1 / 2 ≤ n2 / (eps ^ 2 * g1) := by linarith
  have hA1 : 0 < eps ^ 2 * g1 := by positivity
  rw [le_div_iff₀ hA1] at hmid3
  have t3 : eps ^ 2 * (g1 / n2) ≤ 2 := by
    rw [← mul_div_assoc, div_le_iff₀ hn2pos]
    linarith
  have t4 : eps * (‖p0‖ / n2) ≤ eps := by
    have : ‖p0‖ / n2 ≤ 1 := by
      rw [div_le_one hn2pos]; linarith
    nlinarith
  have : 2 ≤ ‖xLF gU eps x0 p0 3‖ / n2 := by linarith
  rwa [le_div_iff₀ hn2pos] at this

/-- General step used for `i ≥ 4` ("entirely analogous", TEX:934): induction on the number of steps,
via the one-step identity from S1', (18) on consecutive pairs and (17) at `x_{(i-1)ε}`. -/
private lemma gen {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∀ m : ℕ, ∃ η : ℝ, 1 ≤ η ∧ ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, 1 ≤ i → i ≤ m →
        2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  intro m
  induction m with
  | zero => exact ⟨1, le_rfl, fun _ _ _ _ i h1 h2 => by omega⟩
  | succ m ih =>
    obtain ⟨η, hη1, hη⟩ := ih
    obtain ⟨C, hC⟩ := hosc
    obtain ⟨R, hR⟩ := hbig hexp (2 * (3 + eps) / eps ^ 2)
    obtain ⟨ηL, hL⟩ := hL01 δ hδ
    refine ⟨max (max η R) (max (C / 2) ηL), le_trans hη1 (le_trans (le_max_left _ _)
      (le_max_left _ _)), fun x0 p0 hx hp i hi1 hi2 => ?_⟩
    have hxη : η < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
    have hxR : R < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
    have hxC : C / 2 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_right _ _)) hx
    have hxL : ηL < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_right _ _)) hx
    have hx1 : 1 ≤ ‖x0‖ := le_trans hη1 hxη.le
    have hpn := ple x0 p0 δ hδ hx1 hp
    by_cases him : i = m + 1
    · subst him
      simp only [Nat.add_sub_cancel]
      by_cases hm0 : m = 0
      · subst hm0
        exact (hL x0 p0 hxL hp).le
      · have hm1 : 1 ≤ m := by omega
        have hchain : ∀ j, 1 ≤ j → j ≤ m →
            2 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖ :=
          fun j h1 h2 => hη x0 p0 hxη hp j h1 h2
        have hmono := seq_mono (fun j => ‖xLF gU eps x0 p0 j‖) m (fun j => norm_nonneg _)
          hchain
        have h3 : ∀ j, 1 ≤ j → j ≤ m →
            3 * ‖gU (xLF gU eps x0 p0 (j - 1))‖ ≤ ‖gU (xLF gU eps x0 p0 j)‖ := by
          intro j h1 h2
          refine hC _ _ (hchain j h1 h2) ?_
          have := hmono (j - 1) (by omega)
          simp only [xLF_zero] at this
          linarith
        have hs := seq_sum (fun j => ‖gU (xLF gU eps x0 p0 j)‖) m (fun j => norm_nonneg _) h3 m hm1
          le_rfl
        simp only at hs
        rw [xLF_zero] at hs
        have hnm : ‖x0‖ ≤ ‖xLF gU eps x0 p0 m‖ := by
          have := hmono m le_rfl
          simpa [xLF_zero] using this
        have hgm := hR (xLF gU eps x0 p0 m) (by linarith)
        have sb := step_bound gU eps heps x0 p0 m hm1
        have key : (3 + eps) * ‖xLF gU eps x0 p0 m‖
            ≤ eps ^ 2 / 2 * ‖gU (xLF gU eps x0 p0 m)‖ := by
          have := mul_le_mul_of_nonneg_left hgm (by positivity : (0 : ℝ) ≤ eps ^ 2 / 2)
          have e : eps ^ 2 / 2 * (2 * (3 + eps) / eps ^ 2) = 3 + eps := by field_simp; ring
          calc (3 + eps) * ‖xLF gU eps x0 p0 m‖
              = eps ^ 2 / 2 * (2 * (3 + eps) / eps ^ 2) * ‖xLF gU eps x0 p0 m‖ := by rw [e]
            _ = eps ^ 2 / 2 * (2 * (3 + eps) / eps ^ 2 * ‖xLF gU eps x0 p0 m‖) := by ring
            _ ≤ _ := this
        have hs2 := mul_le_mul_of_nonneg_left hs (by positivity : (0 : ℝ) ≤ eps ^ 2)
        have hp2 : eps * ‖p0‖ ≤ eps * ‖xLF gU eps x0 p0 m‖ :=
          mul_le_mul_of_nonneg_left (by linarith) heps.le
        have g0 := norm_nonneg (gU x0)
        nlinarith
    · have hi : i ≤ m := by omega
      exact hη x0 p0 hxη hp i hi1 hi

/-- S10 (TEX:934). -/
theorem L02_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (hosc : HypOscillations gU) (L : ℕ)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, 1 ≤ i → i ≤ L →
        2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  obtain ⟨ηg, -, hg⟩ := gen gU eps hL01 heps hexp hosc δ hδ L
  obtain ⟨η4, h4⟩ := L02_S4 gU eps hL01 heps hexp δ hδ
  obtain ⟨η9, h9⟩ := L02_S9 gU eps hL01 heps hexp hosc δ hδ
  obtain ⟨η1, h1⟩ := hL01 δ hδ
  refine ⟨max (max ηg η4) (max η9 η1), fun x0 p0 hx hp i hi1 hiL => ?_⟩
  have hxg : ηg < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
  have hx4 : η4 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
  have hx9 : η9 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_right _ _)) hx
  have hx1 : η1 < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_right _ _)) hx
  rcases (by omega : i = 1 ∨ i = 2 ∨ i = 3 ∨ 4 ≤ i) with rfl | rfl | rfl | h
  · show 2 * ‖x0‖ ≤ ‖xLF gU eps x0 p0 1‖
    exact (h1 x0 p0 hx1 hp).le
  · exact h4 x0 p0 hx4 hp
  · exact h9 x0 p0 hx9 hp
  · exact hg x0 p0 hxg hp i hi1 hiL

/-- S11 (TEX:934), telescoping. -/
theorem L02_S11 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (δ : ℝ) (hδ : δ < 1) (η : ℝ)
    (h10 : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  intro x0 p0 hx hp
  have : ∀ k, k ≤ L → (2 : ℝ) ^ k * ‖x0‖ ≤ ‖xLF gU eps x0 p0 k‖ := by
    intro k
    induction k with
    | zero => intro _; simp [xLF_zero]
    | succ k ih =>
      intro hk
      have h1 := h10 x0 p0 hx hp (k + 1) (by omega) hk
      simp only [Nat.add_sub_cancel] at h1
      have := ih (by omega)
      rw [pow_succ]
      linarith
  exact this L le_rfl

/-! ## Main theorems -/

/-- Auxiliary variant with (18): Assembly S10 + S11. -/
theorem L02_main_fixedDelta_osc {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) : ConclFixedDelta gU eps L := by
  intro δ hδ
  obtain ⟨η, hη⟩ := L02_S10 gU eps hL01 heps hexp hosc L δ hδ
  exact ⟨η, L02_S11 gU eps L δ hδ η hη⟩

/-- Verdict-bearing form (hypothesis (17) only, as printed).  STOPPED: the printed route needs (18)
at TEX:930 (S8b), which is not a hypothesis of the lemma; see the notes. -/
theorem L02_main_fixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : ConclFixedDelta gU eps L := by
  sorry

/-- Uniform-in-`δ` reading of the printed statement; not verdict-bearing.  STOPPED, as above. -/
theorem L02_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : Concl gU eps L := by
  sorry

end Paper.L02

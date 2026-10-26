import L03Stmt

open Filter Topology
open Paper.Defs

namespace Paper.L03

/-- Technical: one-step unfolding of the leapfrog momentum (TEX:331-335). -/
private theorem pLF_succ {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (n : ℕ) :
    pLF gU eps x0 p0 (n + 1) = pLF gU eps x0 p0 n - (eps / 2) • gU (xLF gU eps x0 p0 n)
      - (eps / 2) • gU (xLF gU eps x0 p0 (n + 1)) := by
  simp only [pLF, xLF, leapfrogState, leapfrogStep]

/-- Technical: geometric sum `2 Σ_{i=1}^L (1/3)^i = 1 - (1/3)^L` (S5 algebra). -/
private theorem geom_third (L : ℕ) :
    2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i = 1 - (1 / 3 : ℝ) ^ L := by
  induction L with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_Icc_succ_top (by omega), mul_add, ih, pow_succ]
    ring

/-- Technical: eventually-statement for `tailMomFilter`. -/
private theorem ev_tail (d : ℕ) (δ η : ℝ) :
    ∀ᶠ q in tailMomFilter d δ, η < ‖q.1‖ ∧ ‖q.2‖ ≤ ‖q.1‖ ^ δ := by
  unfold tailMomFilter
  rw [eventually_inf_principal]
  have h : ∀ᶠ q : E d × E d in comap (fun q : E d × E d => ‖q.1‖) atTop, η < ‖q.1‖ :=
    (eventually_gt_atTop η).comap _
  filter_upwards [h] with q hq hq2
  exact ⟨hq, hq2⟩

/-- S1 (TEX:947-950). -/
theorem L03_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d) :
    accProb U gU eps L x0 p0 =
      min 1 (Real.exp (U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2
        - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2)) := by
  unfold accProb piDens
  congr 1
  rw [← Real.exp_sub, ← Real.exp_add]
  congr 1
  ring

/-- S2 (TEX:371-373 / used at TEX:953). -/
theorem L03_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (L : ℕ) (hL : 1 ≤ L) :
    pLF gU eps x0 p0 L = p0 - (eps / 2) • gU x0
      - eps • ∑ i ∈ Finset.Ico 1 L, gU (xLF gU eps x0 p0 i)
      - (eps / 2) • gU (xLF gU eps x0 p0 L) := by
  induction L, hL using Nat.le_induction with
  | base =>
    have := pLF_succ gU eps x0 p0 0
    simp only [zero_add] at this
    have h0 : pLF gU eps x0 p0 0 = p0 := rfl
    have h0' : xLF gU eps x0 p0 0 = x0 := rfl
    rw [h0, h0'] at this
    simpa using this
  | succ n hn ih =>
    rw [pLF_succ, ih, Finset.sum_Ico_succ_top hn]
    simp only [smul_add, smul_sub]
    have : (eps / 2) • gU (xLF gU eps x0 p0 n) + (eps / 2) • gU (xLF gU eps x0 p0 n) =
        eps • gU (xLF gU eps x0 p0 n) := by
      rw [← add_smul]; congr 1; ring
    rw [sub_eq_add_neg, sub_eq_add_neg, sub_eq_add_neg, sub_eq_add_neg, sub_eq_add_neg,
      sub_eq_add_neg, sub_eq_add_neg]
    simp only [neg_add, ← sub_eq_add_neg]
    abel_nf
    rw [← this]
    abel

/-- S3 (TEX:953, first line). -/
theorem L03_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) (L : ℕ)
    (hL : 1 ≤ L) :
    (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
      - eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖
      - (eps / 2) * ‖gU x0‖ - ‖p0‖ ≤ ‖pLF gU eps x0 p0 L‖ := by
  have h2 := L03_S2 gU eps x0 p0 L hL
  set S := ∑ i ∈ Finset.Ico 1 L, gU (xLF gU eps x0 p0 i) with hS
  have e : (eps / 2) • gU (xLF gU eps x0 p0 L) =
      p0 - (eps / 2) • gU x0 - eps • S - pLF gU eps x0 p0 L := by
    rw [h2]; abel
  have hn : ‖(eps / 2) • gU (xLF gU eps x0 p0 L)‖ ≤
      ‖p0‖ + ‖(eps / 2) • gU x0‖ + ‖eps • S‖ + ‖pLF gU eps x0 p0 L‖ := by
    rw [e]
    calc _ ≤ ‖p0 - (eps / 2) • gU x0 - eps • S‖ + ‖pLF gU eps x0 p0 L‖ := norm_sub_le _ _
      _ ≤ ‖p0 - (eps / 2) • gU x0‖ + ‖eps • S‖ + ‖pLF gU eps x0 p0 L‖ := by
          gcongr; exact norm_sub_le _ _
      _ ≤ ‖p0‖ + ‖(eps / 2) • gU x0‖ + ‖eps • S‖ + ‖pLF gU eps x0 p0 L‖ := by
          gcongr; exact norm_sub_le _ _
  have hS' : ‖eps • S‖ ≤ eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖ := by
    rw [norm_smul, Real.norm_of_nonneg heps.le]
    gcongr
    exact norm_sum_le _ _
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at hn
  linarith

/-- S4a (TEX:954, (18) iterated on consecutive pairs). -/
theorem L03_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, i ≤ L →
        ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖ := by
  obtain ⟨C, hC⟩ := hosc
  obtain ⟨ηb, hb⟩ := hL02.2 δ hδ
  refine ⟨max ηb (C / 2), fun x0 p0 hx hp i hi => ?_⟩
  have hx1 : ηb < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : C / 2 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hb' := hb x0 p0 hx1 hp
  -- monotonicity of ‖x_j‖
  have mono : ∀ j, j ≤ L → ‖x0‖ ≤ ‖xLF gU eps x0 p0 j‖ := by
    intro j
    induction j with
    | zero => intro _; simp [xLF, leapfrogState]
    | succ n ih =>
      intro hj
      have h1 := hb' (n + 1) (by omega) hj
      simp only [Nat.add_sub_cancel] at h1
      have := ih (by omega)
      have := norm_nonneg (xLF gU eps x0 p0 n)
      have := norm_nonneg x0
      linarith
  have step : ∀ j, j < L → 3 * ‖gU (xLF gU eps x0 p0 j)‖ ≤ ‖gU (xLF gU eps x0 p0 (j + 1))‖ := by
    intro j hj
    apply hC
    · have h1 := hb' (j + 1) (by omega) (by omega)
      simpa using h1
    · have := mono j hj.le
      linarith
  have key : ∀ k, k ≤ L → ‖gU (xLF gU eps x0 p0 (L - k))‖ ≤
      (1 / 3 : ℝ) ^ k * ‖gU (xLF gU eps x0 p0 L)‖ := by
    intro k
    induction k with
    | zero => intro _; simp
    | succ k ih =>
      intro hk
      have h1 := step (L - (k + 1)) (by omega)
      have e : L - (k + 1) + 1 = L - k := by omega
      rw [e] at h1
      have h2 := ih (by omega)
      rw [pow_succ]
      nlinarith
  have := key (L - i) (by omega)
  have e : L - (L - i) = i := by omega
  rwa [e] at this

/-- S4b (TEX:954, second line). -/
theorem L03_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (δ : ℝ) (hδ : δ < 1) (η : ℝ)
    (h4a : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → ∀ i : ℕ, i ≤ L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖) :
    ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖ + (eps / 2) * ‖gU x0‖ ≤
        eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * ‖gU (xLF gU eps x0 p0 L)‖ := by
  intro x0 p0 hx hp
  set G := ‖gU (xLF gU eps x0 p0 L)‖ with hG
  have hG0 : 0 ≤ G := norm_nonneg _
  have h1 : ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖ ≤
      ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ (L - i) * G := by
    apply Finset.sum_le_sum
    intro i hi
    rw [Finset.mem_Ico] at hi
    exact h4a x0 p0 hx hp i (by omega)
  have h2 : ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ (L - i) = ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ i := by
    apply Finset.sum_nbij' (fun i => L - i) (fun i => L - i)
    · intro i hi; rw [Finset.mem_Ico] at hi ⊢; omega
    · intro i hi; rw [Finset.mem_Ico] at hi ⊢; omega
    · intro i hi; rw [Finset.mem_Ico] at hi; omega
    · intro i hi; rw [Finset.mem_Ico] at hi; omega
    · intro i hi; rfl
  have h3 : ‖gU x0‖ ≤ (1 / 3 : ℝ) ^ L * G := by
    have := h4a x0 p0 hx hp 0 (Nat.zero_le _)
    simpa [xLF, leapfrogState] using this
  have h4 : ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i =
      ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ i + (1 / 3 : ℝ) ^ L := by
    have : Finset.Icc 1 L = Finset.Ico 1 (L + 1) := rfl
    rw [this, Finset.sum_Ico_succ_top hL]
  rw [← Finset.sum_mul, h4]
  rw [← Finset.sum_mul, h2] at h1
  have h5 : (0 : ℝ) ≤ (1 / 3 : ℝ) ^ L * G := by positivity
  nlinarith [mul_le_mul_of_nonneg_left h1 heps.le, mul_le_mul_of_nonneg_left h3 heps.le]

/-- S5 (TEX:955, 957). -/
theorem L03_S5 (L : ℕ) (eps G : ℝ) :
    0 < 1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i ∧
    (eps / 2) * G - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * G =
      (eps / 2) * (1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i) * G := by
  constructor
  · rw [geom_third]; simp
  · rw [← Finset.sum_mul]; ring

/-- S6 (TEX:957-959, squaring). -/
theorem L03_S6 (a b P : ℝ) (hb : 0 ≤ b) (hba : b ≤ a) (hP : a - b ≤ P) : (a - b) ^ 2 ≤ P ^ 2 := by
  exact pow_le_pow_left₀ (by linarith) hP 2

/-- S7 (TEX:960). -/
theorem L03_S7 (eps γ G b : ℝ) :
    (eps * γ / 2 * G - b) ^ 2 = eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b := by
  ring

/-- S8 (TEX:962-965). -/
theorem L03_S8 (eps γ G b P : ℝ)
    (h : eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2) :
    b ^ 2 - P ^ 2 ≤ eps * γ * G * (b - eps * γ / 4 * G) := by
  nlinarith [h]

/-- S9 (TEX:966-969). -/
theorem L03_S9 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1)
    (M : ℝ) (hM : 1 ≤ M) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      M * ‖xLF gU eps x0 p0 L‖ ≤ (eps * (1 / 3 : ℝ) ^ L / 4) * ‖gU (xLF gU eps x0 p0 L)‖ ∧
      (2 : ℝ) ^ L * ‖x0‖ ≤ M * ‖xLF gU eps x0 p0 L‖ := by
  obtain ⟨ηa, ha⟩ := hL02.1 δ hδ
  have hpos : 0 < eps * (1 / 3 : ℝ) ^ L / 4 := by positivity
  set K : ℝ := 4 * M / (eps * (1 / 3 : ℝ) ^ L) with hK
  have hev := hexp.eventually_ge_atTop K
  rw [Filter.eventually_comap] at hev
  obtain ⟨R, hR⟩ := Filter.eventually_atTop.1 hev
  refine ⟨max ηa (max R 0), fun x0 p0 hx hp => ?_⟩
  have hx1 : ηa < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : R < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_right _ _)) hx
  have hx3 : 0 < ‖x0‖ := lt_of_le_of_lt ((le_max_right _ _).trans (le_max_right _ _)) hx
  have hxL := ha x0 p0 hx1 hp
  have h1 : (1 : ℝ) ≤ 2 ^ L := one_le_pow₀ (by norm_num)
  have hxL' : ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by nlinarith
  have hpos' : 0 < ‖xLF gU eps x0 p0 L‖ := lt_of_lt_of_le hx3 hxL'
  refine ⟨?_, ?_⟩
  · have h := hR ‖xLF gU eps x0 p0 L‖ (by linarith) (xLF gU eps x0 p0 L) rfl
    have h' := (le_div_iff₀ hpos').1 h
    rw [hK, div_mul_eq_mul_div, div_le_iff₀ (by positivity)] at h'
    linarith
  · have := norm_nonneg (xLF gU eps x0 p0 L)
    nlinarith

/-- S10 (TEX:969-970). -/
theorem L03_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (hosc : HypOscillations gU)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2 := by
  obtain ⟨η9, h9⟩ := L03_S9 gU eps heps L hL02 hexp δ hδ 1 le_rfl
  obtain ⟨η4, h4⟩ := L03_S4a gU eps L hL02 hosc δ hδ
  have h4b := L03_S4b gU eps heps L hL δ hδ η4 h4
  refine ⟨max η9 (max η4 1), fun x0 p0 hx hp => ?_⟩
  have hx9 : η9 < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx4 : η4 < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_right _ _)) hx
  have hx1 : 1 < ‖x0‖ := lt_of_le_of_lt ((le_max_right _ _).trans (le_max_right _ _)) hx
  obtain ⟨h9a, h9b⟩ := h9 x0 p0 hx9 hp
  have hb4 := h4b x0 p0 hx4 hp
  have hs3 := L03_S3 gU eps heps x0 p0 L hL
  obtain ⟨hγ, hid⟩ := L03_S5 L eps ‖gU (xLF gU eps x0 p0 L)‖
  have hg := geom_third L
  set G := ‖gU (xLF gU eps x0 p0 L)‖ with hG
  set γ : ℝ := (1 / 3 : ℝ) ^ L with hγdef
  have hγ' : 1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i = γ := by rw [hg]; ring
  rw [hγ'] at hid
  -- ‖p_{Lε}‖ ≥ a - b
  have hP : eps * γ / 2 * G - ‖p0‖ ≤ ‖pLF gU eps x0 p0 L‖ := by
    have : eps * γ / 2 * G = (eps / 2) * γ * G := by ring
    rw [this, ← hid]
    linarith
  have h2L : (2 : ℝ) ≤ 2 ^ L := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ L := pow_le_pow_right₀ (by norm_num) hL
  have hT : 2 * ‖x0‖ ≤ eps * γ / 4 * G := by
    have : eps * γ / 4 = eps * (1 / 3 : ℝ) ^ L / 4 := rfl
    rw [this]
    nlinarith [norm_nonneg x0]
  have hb1 : ‖p0‖ ≤ ‖x0‖ := by
    calc ‖p0‖ ≤ ‖x0‖ ^ δ := hp
      _ ≤ ‖x0‖ ^ (1 : ℝ) := Real.rpow_le_rpow_of_exponent_le hx1.le hδ.le
      _ = ‖x0‖ := Real.rpow_one _
  have hb0 : 0 ≤ ‖p0‖ := norm_nonneg _
  have hba : ‖p0‖ ≤ eps * γ / 2 * G := by linarith
  have h6 := L03_S6 (eps * γ / 2 * G) ‖p0‖ ‖pLF gU eps x0 p0 L‖ hb0 hba hP
  rw [L03_S7] at h6
  have h8 := L03_S8 eps γ G ‖p0‖ ‖pLF gU eps x0 p0 L‖ (by linarith)
  -- T := eps γ G / 4
  set T := eps * γ / 4 * G with hTdef
  have e1 : eps * γ * G = 4 * T := by rw [hTdef]; ring
  rw [e1] at h8
  have hx0 := norm_nonneg x0
  have hT0 : 0 ≤ T := by linarith
  nlinarith [mul_nonneg hT0 (sub_nonneg.2 hT), mul_nonneg hT0 (sub_nonneg.2 hb1),
    mul_nonneg hx0 (sub_nonneg.2 hT)]

/-- S11 (TEX:970, first half). -/
theorem L03_S11 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc2 : HypOscillation2 U L) (δ : ℝ) (hδ : δ < 1)
    (η : ℝ)
    (h10 : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2) :
    Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2 - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)
      (tailMomFilter d δ) atBot := by
  obtain ⟨ηa, ha⟩ := hL02.1 δ hδ
  have hφ : Tendsto (fun q : E d × E d => (q.1, xLF gU eps q.1 q.2 L)) (tailMomFilter d δ)
      (comap (fun q : E d × E d => ‖q.1‖) atTop ⊓
        𝓟 {q : E d × E d | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}) := by
    apply tendsto_inf.2
    constructor
    · rw [tendsto_comap_iff]
      exact (tendsto_comap (f := fun q : E d × E d => ‖q.1‖) (x := atTop)).mono_left inf_le_left
    · rw [tendsto_principal]
      filter_upwards [ev_tail d δ ηa] with q hq
      exact ha q.1 q.2 hq.1 hq.2
  have hg := hosc2.comp hφ
  refine tendsto_atBot_mono' _ ?_ hg
  filter_upwards [ev_tail d δ η] with q hq
  have := h10 q.1 q.2 hq.1 hq.2
  simp only [Function.comp]
  nlinarith

/-- S12 (TEX:970, second half). -/
theorem L03_S12 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (h : Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2 - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)
      (tailMomFilter d δ) atBot) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  have h1 := Real.tendsto_exp_atBot.comp h
  have h2 := (tendsto_const_nhds (x := (1 : ℝ))).min h1
  simp only [min_self, min_eq_right, zero_le_one] at h2
  have e : (fun q : E d × E d => accProb U gU eps L q.1 q.2) = fun q =>
      min 1 (Real.exp (U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2
        - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)) := funext fun q => L03_S1 U gU eps L q.1 q.2
  rw [e]
  simpa using h2

/-- Main theorem, Lemma 5.17 (TEX:939-944). -/
theorem L03_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L)
    (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  obtain ⟨η, h10⟩ := L03_S10 gU eps heps L hL hL02 hexp hosc δ hδ
  exact L03_S12 U gU eps L δ (L03_S11 U gU eps L hL02 hosc2 δ hδ η h10)

end Paper.L03

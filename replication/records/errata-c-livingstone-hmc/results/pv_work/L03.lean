import L03Stmt

open Filter Topology
open Paper.Defs

namespace Paper.L03

/-- Technical: one-step unfolding of the leapfrog momentum (TEX:331-335). -/
private theorem pLF_succ {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (n : ℕ) :
    pLF gU eps x0 p0 (n + 1) = pLF gU eps x0 p0 n - (eps / 2) • gU (xLF gU eps x0 p0 n)
      - (eps / 2) • gU (xLF gU eps x0 p0 (n + 1)) := by
  simp only [pLF, xLF, leapfrogState, leapfrogStep]

/-- Technical: geometric sum `2 Σ_{i=1}^L (1/3)^i = 1 - (1/3)^L`. -/
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

/-- Technical: unpacking (17) into a threshold form. -/
private theorem explode_thresh {d : ℕ} (gU : E d → E d) (hexp : HypExplode gU) (K : ℝ) :
    ∃ R : ℝ, 0 ≤ R ∧ ∀ y : E d, R < ‖y‖ → K * ‖y‖ ≤ ‖gU y‖ := by
  have hev := hexp.eventually_ge_atTop K
  rw [Filter.eventually_comap] at hev
  obtain ⟨R, hR⟩ := Filter.eventually_atTop.1 hev
  refine ⟨max R 0, le_max_right _ _, fun y hy => ?_⟩
  have hy1 : R < ‖y‖ := lt_of_le_of_lt (le_max_left _ _) hy
  have hy0 : 0 < ‖y‖ := lt_of_le_of_lt (le_max_right _ _) hy
  have h := hR ‖y‖ hy1.le y rfl
  exact (le_div_iff₀ hy0).1 h

/-- Technical common core of S7 and S10: uses (17) and L02 (`‖x_L‖ ≥ 3^L‖x_0‖`). -/
private theorem core {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1)
    (c : ℝ) (hc : 0 < c) :
    ∃ η : ℝ, 1 ≤ η ∧ ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖x0‖ ≤ c * ‖gU (xLF gU eps x0 p0 L)‖ ∧ ‖p0‖ ≤ ‖x0‖ := by
  obtain ⟨ηa, ha⟩ := hL02 δ hδ
  obtain ⟨R, hR0, hR⟩ := explode_thresh gU hexp (2 / c)
  refine ⟨max ηa (max R 1), le_trans (le_max_right _ _) (le_max_right _ _), fun x0 p0 hx hp => ?_⟩
  have hx1 : ηa < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : R < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_right _ _)) hx
  have hx3 : 1 < ‖x0‖ := lt_of_le_of_lt ((le_max_right _ _).trans (le_max_right _ _)) hx
  have hxL := (ha x0 p0 hx1 hp).2
  have h1 : (1 : ℝ) ≤ 3 ^ L := one_le_pow₀ (by norm_num)
  have hxL' : ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by nlinarith
  have h := hR (xLF gU eps x0 p0 L) (by linarith)
  refine ⟨?_, ?_⟩
  · have e : c * (2 / c * ‖xLF gU eps x0 p0 L‖) = 2 * ‖xLF gU eps x0 p0 L‖ := by
      field_simp
    have := mul_le_mul_of_nonneg_left h hc.le
    rw [e] at this
    linarith
  · calc ‖p0‖ ≤ ‖x0‖ ^ δ := hp
      _ ≤ ‖x0‖ ^ (1 : ℝ) := Real.rpow_le_rpow_of_exponent_le hx3.le hδ.le
      _ = ‖x0‖ := Real.rpow_one _

/-- S1 (TEX:1019-1022). -/
theorem L03_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d) :
    accProb U gU eps L x0 p0 =
      min 1 (Real.exp (U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2
        - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2)) := by
  unfold accProb piDens
  congr 1
  rw [← Real.exp_sub, ← Real.exp_add]
  congr 1
  ring

/-- S2 (eqn:mprop2, TEX:371-373; used at TEX:1030-1036). -/
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

/-- S3 (TEX:1030-1036, first inequality). -/
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

/-- S4a (TEX:1023-1024): from L02 (stepwise bound and `‖x_{iε}‖ ≥ ‖x_0‖`). -/
theorem L03_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (δ : ℝ) (hδ : δ < 1) (C : ℝ) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, i < L →
        3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ ∧ C ≤ 3 * ‖xLF gU eps x0 p0 i‖ := by
  obtain ⟨ηb, hb⟩ := hL02 δ hδ
  refine ⟨max ηb (C / 3), fun x0 p0 hx hp i hi => ?_⟩
  have hx1 : ηb < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : C / 3 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hb' := (hb x0 p0 hx1 hp).1
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
  refine ⟨?_, ?_⟩
  · have h1 := hb' (i + 1) (by omega) (by omega)
    simpa using h1
  · have := mono i hi.le
    linarith

/-- S4b (TEX:1025-1029, eqn:gradgeometric): (18) applied along consecutive pairs, iterated. -/
theorem L03_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (C : ℝ)
    (hosc : ∀ x y : E d, 3 * ‖x‖ ≤ ‖y‖ → C ≤ 3 * ‖x‖ → 3 * ‖gU x‖ ≤ ‖gU y‖)
    (x0 p0 : E d)
    (h : ∀ i : ℕ, i < L →
      3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ ∧ C ≤ 3 * ‖xLF gU eps x0 p0 i‖) :
    ∀ i : ℕ, i < L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖ := by
  have step : ∀ j, j < L → 3 * ‖gU (xLF gU eps x0 p0 j)‖ ≤ ‖gU (xLF gU eps x0 p0 (j + 1))‖ :=
    fun j hj => hosc _ _ (h j hj).1 (h j hj).2
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
  intro i hi
  have := key (L - i) (by omega)
  have e : L - (L - i) = i := by omega
  rwa [e] at this

/-- S5 (TEX:1036-1040): reindexing `i ↦ L-i`, absorbing the `x_0` term into the `i = L` term. -/
theorem L03_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (x0 p0 : E d)
    (h : ∀ i : ℕ, i < L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖) :
    (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
        - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * ‖gU (xLF gU eps x0 p0 L)‖ - ‖p0‖ ≤
      (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
        - eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖
        - (eps / 2) * ‖gU x0‖ - ‖p0‖ := by
  set G := ‖gU (xLF gU eps x0 p0 L)‖ with hG
  have hG0 : 0 ≤ G := norm_nonneg _
  have h1 : ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖ ≤
      ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ (L - i) * G := by
    apply Finset.sum_le_sum
    intro i hi
    rw [Finset.mem_Ico] at hi
    exact h i (by omega)
  have h2 : ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ (L - i) =
      ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ i := by
    apply Finset.sum_nbij' (fun i => L - i) (fun i => L - i)
    · intro i hi; rw [Finset.mem_Ico] at hi ⊢; omega
    · intro i hi; rw [Finset.mem_Ico] at hi ⊢; omega
    · intro i hi; rw [Finset.mem_Ico] at hi; omega
    · intro i hi; rw [Finset.mem_Ico] at hi; omega
    · intro i hi; rfl
  have h3 : ‖gU x0‖ ≤ (1 / 3 : ℝ) ^ L * G := by
    have := h 0 (by omega)
    simpa [xLF, leapfrogState] using this
  have h4 : ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i =
      ∑ i ∈ Finset.Ico 1 L, (1 / 3 : ℝ) ^ i + (1 / 3 : ℝ) ^ L := by
    have : Finset.Icc 1 L = Finset.Ico 1 (L + 1) := rfl
    rw [this, Finset.sum_Ico_succ_top hL]
  rw [← Finset.sum_mul, h4]
  rw [← Finset.sum_mul, h2] at h1
  have h5 : (0 : ℝ) ≤ (1 / 3 : ℝ) ^ L * G := by positivity
  nlinarith [mul_le_mul_of_nonneg_left h1 heps.le, mul_le_mul_of_nonneg_left h3 heps.le]

/-- S6 (TEX:1041-1047). -/
theorem L03_S6 (L : ℕ) (eps G : ℝ) :
    1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i = (1 / 3 : ℝ) ^ L ∧
    (eps / 2) * G - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * G =
      eps / (2 * 3 ^ L) * G := by
  have hg := geom_third L
  constructor
  · linarith
  · rw [← Finset.sum_mul]
    have hs : ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i = (1 - (1 / 3 : ℝ) ^ L) / 2 := by
      linarith
    rw [hs, one_div, inv_pow]
    field_simp
    ring

/-- S7 (TEX:1049-1051). -/
theorem L03_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      0 < eps * (1 / 3 : ℝ) ^ L / 2 * ‖gU (xLF gU eps x0 p0 L)‖ - ‖p0‖ := by
  obtain ⟨η, hη1, h⟩ := core gU eps L hL02 hexp δ hδ (eps * (1 / 3 : ℝ) ^ L / 2) (by positivity)
  refine ⟨η, fun x0 p0 hx hp => ?_⟩
  obtain ⟨h1, h2⟩ := h x0 p0 hx hp
  have : 0 < ‖x0‖ := by linarith
  linarith

/-- S8 (TEX:1052-1065). -/
theorem L03_S8 (eps γ G b P : ℝ) (hpos : 0 < eps * γ / 2 * G - b)
    (hP : eps * γ / 2 * G - b ≤ P) :
    eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2 := by
  have := pow_le_pow_left₀ hpos.le hP 2
  nlinarith [this]

/-- S9 (TEX:1066-1075). -/
theorem L03_S9 (eps γ G b P : ℝ)
    (h : eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2) :
    b ^ 2 - P ^ 2 ≤ eps * γ * G * (b - eps * γ / 4 * G) := by
  nlinarith [h]

/-- S10 (TEX:1076-1083). -/
theorem L03_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖x0‖ ≤ eps * (1 / 3 : ℝ) ^ L / 4 * ‖gU (xLF gU eps x0 p0 L)‖ ∧ ‖p0‖ ≤ ‖x0‖ := by
  obtain ⟨η, _, h⟩ := core gU eps L hL02 hexp δ hδ (eps * (1 / 3 : ℝ) ^ L / 4) (by positivity)
  exact ⟨η, h⟩

/-- S11 (TEX:1084-1085). -/
theorem L03_S11 (eps γ G b a : ℝ) (heps : 0 < eps) (hγ : 0 < γ)
    (h1 : 2 * a ≤ eps * γ / 4 * G) (h2 : b ≤ a) (ha : 0 ≤ a) :
    eps * γ * G * (b - eps * γ / 4 * G) ≤ -a ^ 2 := by
  set c := eps * γ / 4 * G with hc
  have e : eps * γ * G = 4 * c := by rw [hc]; ring
  rw [e]
  have hc0 : 0 ≤ c := by linarith
  nlinarith [mul_nonneg hc0 (sub_nonneg.2 h2), mul_nonneg hc0 (sub_nonneg.2 h1),
    mul_nonneg (sub_nonneg.2 h1) (by linarith : (0 : ℝ) ≤ c + 2 * a)]

/-- S12 (TEX:1086-1091). -/
theorem L03_S12 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d)
    (h : ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2) :
    U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2 - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2 ≤
      U x0 - U (xLF gU eps x0 p0 L) - (1 / 2) * ‖x0‖ ^ 2 := by
  linarith

/-- S13 (TEX:1092-1093). -/
theorem L03_S13 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc2 : HypOscillation2 U L) (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) - (1 / 2) * ‖q.1‖ ^ 2)
      (tailMomFilter d δ) atBot := by
  obtain ⟨ηa, ha⟩ := hL02 δ hδ
  have hφ : Tendsto (fun q : E d × E d => (q.1, xLF gU eps q.1 q.2 L)) (tailMomFilter d δ)
      (comap (fun q : E d × E d => ‖q.1‖) atTop ⊓
        𝓟 {q : E d × E d | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}) := by
    apply tendsto_inf.2
    constructor
    · rw [tendsto_comap_iff]
      exact (tendsto_comap (f := fun q : E d × E d => ‖q.1‖) (x := atTop)).mono_left inf_le_left
    · rw [tendsto_principal]
      filter_upwards [ev_tail d δ ηa] with q hq
      have h3 := (ha q.1 q.2 hq.1 hq.2).2
      have h23 : (2 : ℝ) ^ L ≤ 3 ^ L := pow_le_pow_left₀ (by norm_num) (by norm_num) L
      have := norm_nonneg q.1
      show (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖xLF gU eps q.1 q.2 L‖
      nlinarith
  exact hosc2.comp hφ

/-- S14 (TEX:1093-1095). -/
theorem L03_S14 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (hbound : ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2)
    (h13 : Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) - (1 / 2) * ‖q.1‖ ^ 2)
      (tailMomFilter d δ) atBot) :
    Concl U gU eps L δ := by
  obtain ⟨η, hη⟩ := hbound
  have h : Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2
        - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2) (tailMomFilter d δ) atBot := by
    refine tendsto_atBot_mono' _ ?_ h13
    filter_upwards [ev_tail d δ η] with q hq
    exact L03_S12 U gU eps L q.1 q.2 (hη q.1 q.2 hq.1 hq.2)
  have h1 := Real.tendsto_exp_atBot.comp h
  have h2 := (tendsto_const_nhds (x := (1 : ℝ))).min h1
  simp only [min_self, min_eq_right, zero_le_one] at h2
  have e : (fun q : E d × E d => accProb U gU eps L q.1 q.2) = fun q =>
      min 1 (Real.exp (U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2
        - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)) :=
    funext fun q => L03_S1 U gU eps L q.1 q.2
  unfold Concl
  rw [e]
  simpa using h2

/-- Main theorem, Lemma 5.17 (TEX:1011-1016). -/
theorem L03_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ∀ δ : ℝ, δ < 1 → Concl U gU eps L δ := by
  intro δ hδ
  obtain ⟨C, hC⟩ := hosc
  obtain ⟨η4, h4⟩ := L03_S4a gU eps L hL02 δ hδ C
  obtain ⟨η7, h7⟩ := L03_S7 gU eps heps L hL02 hexp δ hδ
  obtain ⟨η10, h10⟩ := L03_S10 gU eps heps L hL02 hexp δ hδ
  have hbound : ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2 := by
    refine ⟨max η4 (max η7 η10), fun x0 p0 hx hp => ?_⟩
    have hx4 : η4 < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
    have hx7 : η7 < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_right _ _)) hx
    have hx10 : η10 < ‖x0‖ := lt_of_le_of_lt ((le_max_right _ _).trans (le_max_right _ _)) hx
    have hgeo := L03_S4b gU eps L C hC x0 p0 (h4 x0 p0 hx4 hp)
    have hs3 := L03_S3 gU eps heps x0 p0 L hL
    have hs5 := L03_S5 gU eps heps L hL x0 p0 hgeo
    obtain ⟨_, hs6⟩ := L03_S6 L eps ‖gU (xLF gU eps x0 p0 L)‖
    have hγ : eps / (2 * 3 ^ L) = eps * (1 / 3 : ℝ) ^ L / 2 := by
      rw [one_div, inv_pow]; field_simp; left; ring
    rw [hγ] at hs6
    have hpos := h7 x0 p0 hx7 hp
    obtain ⟨hT, hb1⟩ := h10 x0 p0 hx10 hp
    have hP : eps * (1 / 3 : ℝ) ^ L / 2 * ‖gU (xLF gU eps x0 p0 L)‖ - ‖p0‖ ≤
        ‖pLF gU eps x0 p0 L‖ := by linarith
    have h8 := L03_S8 eps ((1 / 3 : ℝ) ^ L) ‖gU (xLF gU eps x0 p0 L)‖ ‖p0‖
      ‖pLF gU eps x0 p0 L‖ hpos hP
    have h9 := L03_S9 eps ((1 / 3 : ℝ) ^ L) ‖gU (xLF gU eps x0 p0 L)‖ ‖p0‖
      ‖pLF gU eps x0 p0 L‖ h8
    have h11 := L03_S11 eps ((1 / 3 : ℝ) ^ L) ‖gU (xLF gU eps x0 p0 L)‖ ‖p0‖ ‖x0‖ heps
      (by positivity) hT hb1 (norm_nonneg _)
    linarith
  exact L03_S14 U gU eps L δ hbound (L03_S13 U gU eps L hL02 hosc2 δ hδ)

end Paper.L03

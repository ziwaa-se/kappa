import L02Stmt

open Paper.Defs

namespace Paper.L02

/-- S1 (TEX:969-975, eqn:recurrence). Unfold `leapfrogStep` twice. -/
theorem L02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) (hi : 1 ≤ i) :
    xLF gU eps x0 p0 (i + 1) =
      (2 : ℝ) • xLF gU eps x0 p0 i - xLF gU eps x0 p0 (i - 1)
        - eps ^ 2 • gU (xLF gU eps x0 p0 i) := by
  obtain ⟨k, rfl⟩ : ∃ k, i = k + 1 := ⟨i - 1, by omega⟩
  simp only [xLF, leapfrogState, leapfrogStep, Nat.add_sub_cancel]
  module

/-- S2 (TEX:976-981, eqn:gradthreshold): from (17), with `ε > 0`. -/
theorem L02_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU) :
    ∃ R : ℝ, ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖) := by
  have hev := hexp.eventually_ge_atTop (16 / (3 * eps ^ 2))
  rw [Filter.eventually_comap, Filter.eventually_atTop] at hev
  obtain ⟨R, hR⟩ := hev
  refine ⟨R, fun x hx => ?_⟩
  have h := hR ‖x‖ hx x rfl
  have hpos : 0 < eps ^ 2 := by positivity
  rw [div_le_iff₀ (by positivity)] at h
  nlinarith

/-- S3 (TEX:982-983): case `i = 1` from the consumed clause (Lemma `lem:xelower`). -/
theorem L02_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      3 * ‖xLF gU eps x0 p0 0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  obtain ⟨η, hη⟩ := hL01 δ hδ
  refine ⟨η, fun x0 p0 h1 h2 => ?_⟩
  have := hη x0 p0 h1 h2
  have h0 : xLF gU eps x0 p0 0 = x0 := rfl
  rw [h0]
  exact this.le

/-- S4a (TEX:984-993, first inequality): norm of S1, triangle inequality, divide by `‖x_i‖`. -/
theorem L02_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) (hi : 1 ≤ i)
    (hx : 0 < ‖xLF gU eps x0 p0 i‖) :
    eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2
        - ‖xLF gU eps x0 p0 (i - 1)‖ / ‖xLF gU eps x0 p0 i‖ ≤
      ‖xLF gU eps x0 p0 (i + 1)‖ / ‖xLF gU eps x0 p0 i‖ := by
  set a := ‖xLF gU eps x0 p0 i‖ with ha
  have h1 := L02_S1 gU eps x0 p0 i hi
  have h2 : eps ^ 2 • gU (xLF gU eps x0 p0 i) =
      (2 : ℝ) • xLF gU eps x0 p0 i - xLF gU eps x0 p0 (i - 1) - xLF gU eps x0 p0 (i + 1) := by
    rw [h1]; abel
  have h3 : eps ^ 2 * ‖gU (xLF gU eps x0 p0 i)‖ ≤
      2 * a + ‖xLF gU eps x0 p0 (i - 1)‖ + ‖xLF gU eps x0 p0 (i + 1)‖ := by
    have : ‖eps ^ 2 • gU (xLF gU eps x0 p0 i)‖ = eps ^ 2 * ‖gU (xLF gU eps x0 p0 i)‖ := by
      rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
    rw [← this, h2]
    calc _ ≤ ‖(2 : ℝ) • xLF gU eps x0 p0 i - xLF gU eps x0 p0 (i - 1)‖
            + ‖xLF gU eps x0 p0 (i + 1)‖ := norm_sub_le _ _
      _ ≤ ‖(2 : ℝ) • xLF gU eps x0 p0 i‖ + ‖xLF gU eps x0 p0 (i - 1)‖
            + ‖xLF gU eps x0 p0 (i + 1)‖ := by gcongr; exact norm_sub_le _ _
      _ = _ := by rw [norm_smul]; simp [ha]
  have e : eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / a) - 2 - ‖xLF gU eps x0 p0 (i - 1)‖ / a =
      (eps ^ 2 * ‖gU (xLF gU eps x0 p0 i)‖ - 2 * a - ‖xLF gU eps x0 p0 (i - 1)‖) / a := by
    field_simp
    ring
  rw [e]
  apply div_le_div_of_nonneg_right _ hx.le
  linarith

/-- S4b (TEX:993-996, second inequality): `‖x_{i-1}‖/‖x_i‖ ≤ 1/3`. -/
theorem L02_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ)
    (hx : 0 < ‖xLF gU eps x0 p0 i‖)
    (hind : 3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2 - 1 / 3 ≤
      eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2
        - ‖xLF gU eps x0 p0 (i - 1)‖ / ‖xLF gU eps x0 p0 i‖ := by
  have : ‖xLF gU eps x0 p0 (i - 1)‖ / ‖xLF gU eps x0 p0 i‖ ≤ 1 / 3 := by
    rw [div_le_iff₀ hx]; linarith
  linarith

/-- S5 (TEX:998-999): the preceding steps of the induction give `‖x_0‖ ≤ ‖x_i‖`. -/
theorem L02_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ)
    (h : ∀ j : ℕ, 1 ≤ j → j ≤ i →
      3 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖) :
    ‖x0‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  induction i with
  | zero => exact le_refl _
  | succ n ih =>
    have ih' := ih (fun j h1 h2 => h j h1 (by omega))
    have := h (n + 1) (by omega) le_rfl
    simp only [Nat.add_sub_cancel] at this
    have := norm_nonneg (xLF gU eps x0 p0 n)
    linarith [h (n + 1) (by omega) le_rfl, show (n + 1 - 1) = n from rfl]

/-- S6 (TEX:1000-1004): inductive step. -/
theorem L02_S6 {d : ℕ} (gU : E d → E d) (eps : ℝ) (R : ℝ)
    (hR : ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖))
    (x0 p0 : E d) (hx0 : 0 < ‖x0‖) (hRx : R ≤ ‖x0‖) (i : ℕ) (hi : 1 ≤ i)
    (h : ∀ j : ℕ, 1 ≤ j → j ≤ i →
      3 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖) :
    3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ := by
  have h5 := L02_S5 gU eps x0 p0 i h
  have hx : 0 < ‖xLF gU eps x0 p0 i‖ := lt_of_lt_of_le hx0 h5
  have hg := hR _ (le_trans hRx h5)
  have a := L02_S4a gU eps x0 p0 i hi hx
  have b := L02_S4b gU eps x0 p0 i hx (h i hi le_rfl)
  have : 3 ≤ ‖xLF gU eps x0 p0 (i + 1)‖ / ‖xLF gU eps x0 p0 i‖ := by linarith
  rw [le_div_iff₀ hx] at this
  linarith

/-- S7 (TEX:1005): induction over `i = 1,…,L`. -/
theorem L02_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (R : ℝ)
    (hR : ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖))
    (x0 p0 : E d) (hx0 : 0 < ‖x0‖) (hRx : R ≤ ‖x0‖)
    (hbase : 3 * ‖xLF gU eps x0 p0 0‖ ≤ ‖xLF gU eps x0 p0 1‖) :
    ∀ i : ℕ, 1 ≤ i → i ≤ L → 3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  have Q : ∀ n : ℕ, ∀ j : ℕ, 1 ≤ j → j ≤ n → j ≤ L →
      3 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖ := by
    intro n
    induction n with
    | zero => intro j h1 h2; omega
    | succ n ih =>
      intro j h1 h2 h3
      rcases Nat.lt_or_ge j (n + 1) with hj | hj
      · exact ih j h1 (by omega) h3
      · have hjn : j = n + 1 := by omega
        subst hjn
        rcases Nat.eq_zero_or_pos n with hn | hn
        · subst hn; simpa using hbase
        · have := L02_S6 gU eps R hR x0 p0 hx0 hRx n hn
            (fun k hk1 hk2 => ih k hk1 hk2 (by omega))
          simpa using this
  intro i h1 h2
  exact Q i i h1 le_rfl h2

/-- S8 (TEX:1005-1006): telescoping. -/
theorem L02_S8 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d)
    (h : ∀ i : ℕ, 1 ≤ i → i ≤ L →
      3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    (3 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  induction L with
  | zero => simp [xLF, leapfrogState]
  | succ n ih =>
    have ih' := ih (fun i h1 h2 => h i h1 (by omega))
    have := h (n + 1) (by omega) le_rfl
    simp only [Nat.add_sub_cancel] at this
    rw [pow_succ]
    linarith

/-- Main theorem, Lemma 5.16 (TEX:960-966), assembled as in the source proof (TEX:982-1006). -/
theorem L02_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : ∀ δ : ℝ, δ < 1 → Concl gU eps L δ := by
  intro δ hδ
  obtain ⟨R, hR⟩ := L02_S2 gU eps heps hexp
  obtain ⟨η, hη⟩ := L02_S3 gU eps hL01 δ hδ
  refine ⟨max (max η R) 0, fun x0 p0 h1 h2 => ?_⟩
  have hη' : η < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_left _ _)) h1
  have hRx : R ≤ ‖x0‖ :=
    ((le_max_right _ _).trans (le_max_left _ _)).trans h1.le
  have hx0 : 0 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) h1
  have hbase := hη x0 p0 hη' h2
  have hs := L02_S7 gU eps L R hR x0 p0 hx0 hRx hbase
  exact ⟨hs, L02_S8 gU eps L x0 p0 hs⟩

end Paper.L02

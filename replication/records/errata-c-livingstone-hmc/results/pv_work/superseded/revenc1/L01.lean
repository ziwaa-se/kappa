import L01Stmt

open Paper.Defs

namespace Paper.L01

/-- S1 (TEX:890, first equality). -/
theorem L01_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 1 = x0 - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  simp only [xLF, leapfrogState, leapfrogStep]
  module

/-- S2 (TEX:890, inequality): reverse triangle inequality. -/
theorem L01_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) :
    (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  rw [L01_S1]
  have h1 : (eps ^ 2 / 2) • gU x0 = x0 + eps • p0 - (x0 - (eps ^ 2 / 2) • gU x0 + eps • p0) := by
    module
  have h2 : ‖(eps ^ 2 / 2) • gU x0‖ ≤ ‖x0‖ + eps * ‖p0‖ + ‖x0 - (eps ^ 2 / 2) • gU x0 + eps • p0‖ := by
    have h3 := norm_sub_le (x0 + eps • p0) (x0 - (eps ^ 2 / 2) • gU x0 + eps • p0)
    rw [← h1] at h3
    have := norm_add_le x0 (eps • p0)
    rw [norm_smul, Real.norm_of_nonneg heps.le] at this
    linarith
  rw [norm_smul, Real.norm_of_nonneg (by positivity)] at h2
  linarith

/-- S3 (TEX:893-895, display (20)). -/
theorem L01_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : x0 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖) ≤
      ‖xLF gU eps x0 p0 1‖ / ‖x0‖ := by
  have hpos : 0 < ‖x0‖ := norm_pos_iff.mpr hx
  have := L01_S2 gU eps heps x0 p0
  rw [le_div_iff₀ hpos]
  have e : ((eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖)) * ‖x0‖
      = (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ := by
    field_simp
    ring
  rw [e]; exact this

/-- S4 (TEX:896, first clause), via (17). -/
theorem L01_S4 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU)
    (B : ℝ) : ∃ η₁ : ℝ, ∀ x0 : E d, η₁ < ‖x0‖ → B < (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) := by
  have h := hexp.eventually (Filter.eventually_gt_atTop (2 * B / eps ^ 2))
  rw [Filter.eventually_comap, Filter.eventually_atTop] at h
  obtain ⟨N, hN⟩ := h
  refine ⟨N, fun x0 hx => ?_⟩
  have := hN _ hx.le x0 rfl
  have hp : 0 < eps ^ 2 := by positivity
  rw [div_lt_iff₀ hp] at this
  linarith

/-- S5 (TEX:896, second clause). -/
theorem L01_S5 {d : ℕ} (eps δ ζ : ℝ) (heps : 0 < eps) (hδ : δ < 1) (hζ : 0 < ζ) :
    ∃ η₂ : ℝ, ∀ x0 p0 : E d, η₂ < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → eps * (‖p0‖ / ‖x0‖) < ζ := by
  have ht : Filter.Tendsto (fun r : ℝ => r ^ (δ - 1)) Filter.atTop (nhds 0) := by
    have := tendsto_rpow_neg_atTop (show 0 < 1 - δ by linarith)
    refine this.congr (fun r => ?_)
    ring_nf
  have h := ht.eventually (gt_mem_nhds (show (0:ℝ) < ζ / eps by positivity))
  rw [Filter.eventually_atTop] at h
  obtain ⟨N, hN⟩ := h
  refine ⟨max N 1, fun x0 p0 hx hp => ?_⟩
  have hx1 : N < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : 1 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hpos : 0 < ‖x0‖ := by linarith
  have h1 := hN _ hx1.le
  have h2 : ‖p0‖ / ‖x0‖ ≤ ‖x0‖ ^ (δ - 1) := by
    rw [Real.rpow_sub hpos, Real.rpow_one]
    exact div_le_div_of_nonneg_right hp hpos.le
  rw [lt_div_iff₀ heps] at h1
  nlinarith

/-- Main theorem, literal uniform-in-δ reading: not obtained along the printed route (stopped). -/
theorem L01_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps)
    (hexp : HypExplode gU) : Concl gU eps := by
  sorry

/-- Fixed-δ reading: S1-S3, S4 (B = 4), S5 (ζ = 1). -/
theorem L01_main_fixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps)
    (hexp : HypExplode gU) : ConclFixedDelta gU eps := by
  intro δ hδ
  obtain ⟨η₁, h1⟩ := L01_S4 gU eps heps hexp 4
  obtain ⟨η₂, h2⟩ := L01_S5 (d := d) eps δ 1 heps hδ one_pos
  refine ⟨max (max η₁ η₂) 1, fun x0 p0 hx hp => ?_⟩
  have hx1 : η₁ < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
  have hx2 : η₂ < ‖x0‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
  have hx3 : 1 < ‖x0‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hpos : 0 < ‖x0‖ := by linarith
  have hx0 : x0 ≠ 0 := norm_pos_iff.mp hpos
  have a := L01_S3 gU eps heps x0 p0 hx0
  have b := h1 x0 hx1
  have c := h2 x0 p0 hx2 hp
  rw [le_div_iff₀ hpos] at a
  nlinarith

end Paper.L01

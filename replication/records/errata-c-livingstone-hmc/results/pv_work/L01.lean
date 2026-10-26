import L01Stmt

open Paper.Defs
open Filter

namespace Paper.L01

/-- S1. TEX:951. -/
theorem L01_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 1 = x0 - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  simp only [xLF, leapfrogState, leapfrogStep]
  module

/-- S2. TEX:951 (reverse triangle inequality). -/
theorem L01_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) :
    (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  rw [L01_S1]
  have h1 : ‖(eps ^ 2 / 2) • gU x0‖ = (eps ^ 2 / 2) * ‖gU x0‖ := by
    rw [norm_smul, Real.norm_of_nonneg (by positivity)]
  have h2 : ‖eps • p0‖ = eps * ‖p0‖ := by
    rw [norm_smul, Real.norm_of_nonneg heps.le]
  have h3 : (eps ^ 2 / 2) • gU x0 = (x0 + eps • p0) - (x0 - (eps ^ 2 / 2) • gU x0 + eps • p0) := by
    module
  have h4 : ‖(eps ^ 2 / 2) • gU x0‖ ≤ ‖x0 + eps • p0‖ + ‖x0 - (eps ^ 2 / 2) • gU x0 + eps • p0‖ := by
    conv_lhs => rw [h3]
    exact norm_sub_le _ _
  have h5 := norm_add_le x0 (eps • p0)
  linarith

/-- S3. TEX:955. -/
theorem L01_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : x0 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖) ≤ ‖xLF gU eps x0 p0 1‖ / ‖x0‖ := by
  have hn : 0 < ‖x0‖ := norm_pos_iff.mpr hx
  have := L01_S2 gU eps heps x0 p0
  rw [le_div_iff₀ hn]
  have e : ((eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖)) * ‖x0‖
      = (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ := by
    field_simp
    ring
  rw [e]; exact this

/-- S4. TEX:957 (tends to zero). -/
theorem L01_S4 (eps δ : ℝ) (heps : 0 < eps) (hδ : δ < 1) :
    ∀ c : ℝ, 0 < c → ∃ R : ℝ, ∀ r : ℝ, R < r → 0 < r → eps * r ^ (δ - 1) < c := by
  intro c hc
  have ht : Tendsto (fun r : ℝ => r ^ (δ - 1)) atTop (nhds 0) := by
    have := tendsto_rpow_neg_atTop (y := 1 - δ) (by linarith)
    simpa using this
  have ht2 : Tendsto (fun r : ℝ => eps * r ^ (δ - 1)) atTop (nhds (eps * 0)) := ht.const_mul eps
  rw [mul_zero] at ht2
  obtain ⟨R, hR⟩ := eventually_atTop.mp (ht2.eventually (gt_mem_nhds hc))
  exact ⟨R, fun r hr _ => hR r hr.le⟩

/-- S5. TEX:957 (first term, by (17)). -/
theorem L01_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (h : HypExplode gU) :
    ∀ B : ℝ, ∃ R : ℝ, ∀ x0 : E d, R < ‖x0‖ → B < (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) := by
  intro B
  have h2 := h.const_mul_atTop (show 0 < eps ^ 2 / 2 by positivity)
  have h3 := h2.eventually (eventually_gt_atTop B)
  rw [eventually_comap] at h3
  obtain ⟨R, hR⟩ := eventually_atTop.mp h3
  exact ⟨R, fun x0 hx => hR ‖x0‖ hx.le x0 rfl⟩

/-- S6. TEX:957 "Hence ... larger than 3". -/
theorem L01_S6 {d : ℕ} (gU : E d → E d) (eps δ : ℝ) (heps : 0 < eps) (hδ : δ < 1)
    (h : HypExplode gU) : Concl gU eps δ := by
  obtain ⟨R5, h5⟩ := L01_S5 gU eps heps h 5
  obtain ⟨R4, h4⟩ := L01_S4 eps δ heps hδ 1 one_pos
  refine ⟨max R5 (max R4 0), fun x0 p0 hη hp => ?_⟩
  have hR5 : R5 < ‖x0‖ := lt_of_le_of_lt (le_max_left _ _) hη
  have hR4 : R4 < ‖x0‖ := lt_of_le_of_lt ((le_max_left _ _).trans (le_max_right _ _)) hη
  have hpos : 0 < ‖x0‖ := lt_of_le_of_lt ((le_max_right _ _).trans (le_max_right _ _)) hη
  have hx : x0 ≠ 0 := norm_pos_iff.mp hpos
  have s3 := L01_S3 gU eps heps x0 p0 hx
  have a5 := h5 x0 hR5
  have a4 := h4 ‖x0‖ hR4 hpos
  have hb : ‖p0‖ / ‖x0‖ ≤ ‖x0‖ ^ (δ - 1) := by
    rw [Real.rpow_sub_one hpos.ne', div_le_div_iff_of_pos_right hpos]
    exact hp
  have : 3 < ‖xLF gU eps x0 p0 1‖ / ‖x0‖ := by
    have := mul_le_mul_of_nonneg_left hb heps.le
    linarith
  rw [lt_div_iff₀ hpos] at this
  linarith

/-- Main theorem, Lemma 5.15. -/
theorem L01_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps)
    (h : HypExplode gU) : ∀ δ : ℝ, δ < 1 → Concl gU eps δ := by
  intro δ hδ
  exact L01_S6 gU eps δ heps hδ h

end Paper.L01

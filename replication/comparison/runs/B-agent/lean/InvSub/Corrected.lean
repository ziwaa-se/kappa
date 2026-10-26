import Mathlib

/-!
# Corrected versions of Theorem 2.8 and Theorem 4.8

* Theorem 2.8 holds once `h > 0` on `(0,∞)` is added (this is exactly what is needed for
  `F_{h(X)}(0) = 0`; star-shapedness + positivity then make `h` increasing).
* Theorem 4.8 holds for `X = h(Y)`, `F_Y(x) = x/(1+x)`, `h` convex with `h(0) = 0` and
  `h > 0` on `(0,∞)`, i.e. super-Pareto variables with `ess inf X = 0` and no atom at `0`.
-/

open MeasureTheory ProbabilityTheory Set Filter Topology

noncomputable section

def InvSub (μ : Measure ℝ) : Prop :=
  cdf μ 0 = 0 ∧ ∀ x y : ℝ, 0 < x → 0 < y →
    1 - cdf μ (1 / (x + y)) ≤ (1 - cdf μ (1 / x)) + (1 - cdf μ (1 / y))

def Cond23 (F : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, 0 < θ → θ < 1 → F (x / θ) + F (x / (1 - θ)) ≤ F x + 1

theorem subadd_iff_cond23 (F : ℝ → ℝ) (h0 : F 0 ≤ 1) :
    (∀ x y : ℝ, 0 < x → 0 < y → 1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y)))
      ↔ Cond23 F := by
  constructor
  · intro h x hx θ hθ0 hθ1
    rcases hx.eq_or_lt with rfl | hx
    · simp; linarith
    have h1 : 0 < θ / x := by positivity
    have h2 : 0 < (1 - θ) / x := by apply div_pos <;> linarith
    have := h (θ / x) ((1 - θ) / x) h1 h2
    have e1 : 1 / (θ / x + (1 - θ) / x) = x := by field_simp
    have e2 : 1 / (θ / x) = x / θ := by field_simp
    have e3 : 1 / ((1 - θ) / x) = x / (1 - θ) := by field_simp
    rw [e1, e2, e3] at this
    linarith
  · intro h x y hx hy
    have hs : 0 < x + y := by linarith
    have hθ0 : 0 < x / (x + y) := by positivity
    have hθ1 : x / (x + y) < 1 := by rw [div_lt_one hs]; linarith
    have := h (1 / (x + y)) (by positivity) (x / (x + y)) hθ0 hθ1
    have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
    have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
      have : 1 - x / (x + y) = y / (x + y) := by field_simp
      rw [this]; field_simp
    rw [e1, e2] at this
    linarith

lemma cond23_measure (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : Cond23 (cdf μ))
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (h0 : 0 < θ) (h1 : θ < 1) :
    μ (Iic (x / θ)) + μ (Iic (x / (1 - θ))) ≤ μ (Iic x) + 1 := by
  have := h x hx θ h0 h1
  simp only [cdf_eq_real, measureReal_def] at this
  rw [← ENNReal.toReal_le_toReal (by finiteness) (by finiteness), ENNReal.toReal_add
    (by finiteness) (by finiteness), ENNReal.toReal_add (by finiteness) (by finiteness)]
  simpa using this

/-- **Theorem 2.8, corrected**: add `h > 0` on `(0,∞)`. -/
theorem theorem_2_8_corrected (μ : Measure ℝ) [IsProbabilityMeasure μ] (hμ : InvSub μ)
    (h : ℝ → ℝ) (hc : Continuous h) (h0 : h 0 = 0) (hpos : ∀ s, 0 < s → 0 < h s)
    (hstar : MonotoneOn (fun s => h s / s) (Ioi 0)) :
    haveI := isProbabilityMeasure_map (μ := μ) hc.measurable.aemeasurable
    InvSub (μ.map h) := by
  haveI := isProbabilityMeasure_map (μ := μ) hc.measurable.aemeasurable
  have hF0 := hμ.1
  have h23 : Cond23 (cdf μ) := (subadd_iff_cond23 _ (by rw [hF0]; norm_num)).1 hμ.2
  have hμ0 : μ (Iic 0) = 0 := by
    rw [cdf_eq_real, measureReal_def, ENNReal.toReal_eq_zero_iff] at hF0
    exact hF0.resolve_right (measure_ne_top _ _)
  have hcdf : ∀ u, cdf (μ.map h) u = (μ (h ⁻¹' Iic u)).toReal := by
    intro u
    rw [cdf_eq_real, measureReal_def, Measure.map_apply hc.measurable measurableSet_Iic]
  -- `h` is monotone on `[0,∞)`
  have hmono : MonotoneOn h (Ici 0) := by
    intro s hs t ht hst
    simp only [mem_Ici] at hs ht
    rcases hs.eq_or_lt with rfl | hs'
    · rw [h0]; rcases ht.eq_or_lt with rfl | ht'
      · rw [h0]
      · exact (hpos t ht').le
    have ht' : 0 < t := lt_of_lt_of_le hs' hst
    have := hstar (show s ∈ Ioi 0 from hs') (show t ∈ Ioi 0 from ht') hst
    simp only at this
    rw [div_le_div_iff₀ hs' ht'] at this
    have := hpos s hs'
    nlinarith
  -- `h` is unbounded: `h s ≥ s h(1)` for `s ≥ 1`
  have hgrow : ∀ s, 1 ≤ s → s * h 1 ≤ h s := by
    intro s hs
    have := hstar (mem_Ioi.2 one_pos) (show s ∈ Ioi 0 from by
      simp only [mem_Ioi]; linarith) hs
    simp only [div_one] at this
    rw [le_div_iff₀ (by linarith)] at this
    linarith
  refine ⟨?_, (subadd_iff_cond23 _ ?_).2 ?_⟩
  · rw [hcdf, ENNReal.toReal_eq_zero_iff]; left
    refine measure_mono_null (fun s hs => ?_) hμ0
    simp only [mem_preimage, mem_Iic] at hs ⊢
    by_contra! hneg
    linarith [hpos s hneg]
  · rw [hcdf]; exact ENNReal.toReal_le_of_le_ofReal zero_le_one (by simpa using prob_le_one)
  intro u hu θ hθ0 hθ1
  have h1θ : 0 < 1 - θ := by linarith
  set S := {s : ℝ | 0 ≤ s ∧ h s ≤ u}
  have hS0 : (0:ℝ) ∈ S := ⟨le_rfl, by rw [h0]; exact hu⟩
  have h1pos := hpos 1 one_pos
  have hSbdd : BddAbove S := by
    refine ⟨max 1 (u / h 1 + 1), fun s ⟨hs0, hsu⟩ => ?_⟩
    by_contra! hlt
    have hs1 : 1 ≤ s := le_trans (le_max_left _ _) hlt.le
    have := hgrow s hs1
    have : u / h 1 + 1 < s := lt_of_le_of_lt (le_max_right _ _) hlt
    have : u < s * h 1 := by
      rw [div_add_one h1pos.ne', div_lt_iff₀ h1pos] at this; nlinarith
    linarith
  have hSclosed : IsClosed S :=
    (isClosed_le continuous_const continuous_id).inter (isClosed_le hc continuous_const)
  set w := sSup S
  have hwS : w ∈ S := hSclosed.csSup_mem ⟨0, hS0⟩ hSbdd
  have hw0 : 0 ≤ w := hwS.1
  -- `{X ≤ w} ⊆ {h(X) ≤ u} ∪ {X < 0}`
  have hA : Iic w ⊆ h ⁻¹' Iic u ∪ Iio 0 := by
    intro s hs
    simp only [mem_Iic] at hs
    by_cases hs0 : 0 ≤ s
    · left; simp only [mem_preimage, mem_Iic]
      exact (hmono hs0 hw0 hs).trans hwS.2
    · right; simpa using hs0
  -- `{h(X) ≤ u/ϑ} ⊆ {X ≤ w/ϑ}` for `ϑ ∈ (0,1)`
  have hB : ∀ ϑ : ℝ, 0 < ϑ → ϑ < 1 → h ⁻¹' Iic (u / ϑ) ⊆ Iic (w / ϑ) := by
    intro ϑ hϑ0 hϑ1 s hs
    simp only [mem_preimage, mem_Iic] at hs ⊢
    by_contra! hlt
    have hws : w < ϑ * s := by rwa [div_lt_iff₀' hϑ0] at hlt
    have hs0 : 0 < s := by
      have : 0 ≤ w / ϑ := div_nonneg hw0 hϑ0.le
      linarith
    have hϑs : 0 < ϑ * s := mul_pos hϑ0 hs0
    have hnot : ϑ * s ∉ S := fun hm => absurd (le_csSup hSbdd hm) (not_le.2 hws)
    have hgt : u < h (ϑ * s) := by
      by_contra! hle; exact hnot ⟨hϑs.le, hle⟩
    have := hstar (show ϑ * s ∈ Ioi 0 from hϑs) (show s ∈ Ioi 0 from hs0)
      (by nlinarith)
    simp only at this
    rw [div_le_div_iff₀ hϑs hs0] at this
    have hhs : h s * ϑ ≤ u := by rwa [le_div_iff₀ hϑ0] at hs
    nlinarith
  have hμ0' : μ (Iio 0) = 0 :=
    le_antisymm ((measure_mono Iio_subset_Iic_self).trans hμ0.le) (zero_le _)
  have key : μ (h ⁻¹' Iic (u / θ)) + μ (h ⁻¹' Iic (u / (1 - θ))) ≤ μ (h ⁻¹' Iic u) + 1 := by
    calc μ (h ⁻¹' Iic (u / θ)) + μ (h ⁻¹' Iic (u / (1 - θ)))
        ≤ μ (Iic (w / θ)) + μ (Iic (w / (1 - θ))) := by
          have e : u / (1 - θ) = u / (1 - θ) := rfl
          gcongr
          · exact hB θ hθ0 hθ1
          · exact hB (1 - θ) h1θ (by linarith)
      _ ≤ μ (Iic w) + 1 := cond23_measure μ h23 w hw0 θ hθ0 hθ1
      _ ≤ μ (h ⁻¹' Iic u ∪ Iio 0) + 1 := by gcongr
      _ ≤ μ (h ⁻¹' Iic u) + μ (Iio 0) + 1 := by gcongr; exact measure_union_le _ _
      _ = μ (h ⁻¹' Iic u) + 1 := by rw [hμ0', add_zero]
  rw [hcdf, hcdf, hcdf]
  rw [← ENNReal.toReal_le_toReal (by finiteness) (by finiteness), ENNReal.toReal_add
    (by finiteness) (by finiteness), ENNReal.toReal_add (by finiteness) (by finiteness)] at key
  simpa using key

/-! ## Corrected Theorem 4.8 -/

lemma max0_nonneg (x : ℝ) : 0 ≤ max x 0 := le_max_right _ _

/-- `F_Y(x) = x/(1+x)` for `x ≥ 0` (i.e. `Y = Z - 1`, `Z ~ Pareto(1)`). -/
def lomaxF : StieltjesFunction where
  toFun x := max x 0 / (max x 0 + 1)
  mono' a b hab := by
    simp only
    have ha := max0_nonneg a
    have hb := max0_nonneg b
    have : max a 0 ≤ max b 0 := max_le_max hab le_rfl
    rw [div_le_div_iff₀ (by linarith) (by linarith)]
    nlinarith
  right_continuous' x := by
    have : Continuous fun x : ℝ => max x 0 / (max x 0 + 1) :=
      (continuous_id.max continuous_const).div ((continuous_id.max continuous_const).add
        continuous_const) fun x => by have := max0_nonneg x; positivity
    exact this.continuousAt.continuousWithinAt

lemma lomaxF_atBot : Tendsto lomaxF atBot (𝓝 0) := by
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [eventually_le_atBot 0] with x hx
  show (0:ℝ) = max x 0 / (max x 0 + 1)
  simp [max_eq_right hx]

lemma lomaxF_atTop : Tendsto lomaxF atTop (𝓝 1) := by
  have e : ∀ᶠ x in atTop, 1 - (x + 1)⁻¹ = lomaxF x := by
    filter_upwards [eventually_ge_atTop 0] with x hx
    show 1 - (x + 1)⁻¹ = max x 0 / (max x 0 + 1)
    rw [max_eq_left hx]; field_simp
  refine Tendsto.congr' e ?_
  have : Tendsto (fun x : ℝ => x + 1) atTop atTop := tendsto_atTop_add_const_right _ 1 tendsto_id
  simpa using (tendsto_inv_atTop_zero.comp this).const_sub (1 : ℝ)

def lomaxμ : Measure ℝ := lomaxF.measure

instance : IsProbabilityMeasure lomaxμ := lomaxF.isProbabilityMeasure lomaxF_atBot lomaxF_atTop

lemma cdf_lomaxμ (x : ℝ) : cdf lomaxμ x = max x 0 / (max x 0 + 1) := by
  rw [lomaxμ, cdf_measure_stieltjesFunction lomaxF lomaxF_atBot lomaxF_atTop]; rfl

theorem lomax_invSub : InvSub lomaxμ := by
  refine ⟨by simp [cdf_lomaxμ], fun x y hx hy => ?_⟩
  have e : ∀ t : ℝ, 0 < t → 1 - cdf lomaxμ (1 / t) = t / (1 + t) := by
    intro t ht
    rw [cdf_lomaxμ, max_eq_left (by positivity)]
    field_simp
  rw [e x hx, e y hy, e (x + y) (by linarith)]
  rw [div_add_div _ _ (by linarith) (by linarith), div_le_div_iff₀ (by linarith) (by positivity)]
  nlinarith [mul_pos hx hy, mul_pos (mul_pos hx hy) (add_pos hx hy)]

/-- A convex function with `h 0 = 0` is star-shaped. -/
lemma star_of_convex (h : ℝ → ℝ) (hconv : ConvexOn ℝ (Ici 0) h) (h0 : h 0 = 0) :
    MonotoneOn (fun s => h s / s) (Ioi 0) := by
  intro s hs t ht hst
  simp only [mem_Ioi] at hs ht
  have := hconv.secant_mono (a := 0) (x := s) (y := t) (mem_Ici.2 le_rfl) (mem_Ici.2 hs.le)
    (mem_Ici.2 ht.le) hs.ne' ht.ne' hst
  simpa [h0] using this

/-- **Theorem 4.8, corrected**: if `X = h(Y)` with `Y ~ F_Y(x) = x/(1+x)` (equivalently
`X = g(Z)`, `g(z) = h(z-1)` convex increasing, `Z ~ Pareto(1)`), `h` continuous, convex on
`[0,∞)`, `h(0) = 0` and `h > 0` on `(0,∞)`, then `X` is InvSub. -/
theorem theorem_4_8_corrected (h : ℝ → ℝ) (hc : Continuous h) (hconv : ConvexOn ℝ (Ici 0) h)
    (h0 : h 0 = 0) (hpos : ∀ s, 0 < s → 0 < h s) :
    haveI := isProbabilityMeasure_map (μ := lomaxμ) hc.measurable.aemeasurable
    InvSub (lomaxμ.map h) :=
  theorem_2_8_corrected lomaxμ lomax_invSub h hc h0 hpos (star_of_convex h hconv h0)

end

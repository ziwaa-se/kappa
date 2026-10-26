import P01Stmt

open MeasureTheory ProbabilityTheory Set

namespace Paper.P01

/-- S1. Source :124 / :153 (implicit: Def 2.2 requires `F_X(0)=0`).
"We say that a random variable X such that F_X(0)=0 is InvSub".
Role: first component of `InvSub`; follows from nonnegativity and the density (no atom at 0).
Uses: nothing else. -/
theorem P01_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hnn : μ (Iio 0) = 0)
    (f : ℝ → ENNReal) (hdens : μ = volume.withDensity f) : F μ 0 = 0 := by
  unfold F
  rw [cdf_eq_real]
  have h0 : μ {0} = 0 := by
    rw [hdens, withDensity_apply _ (measurableSet_singleton 0)]; simp
  have hsub : Iic (0:ℝ) ⊆ Iio 0 ∪ {0} := fun x hx => by
    rcases lt_or_eq_of_le (mem_Iic.1 hx) with h | h
    · exact Or.inl h
    · exact Or.inr h
  have : μ (Iic 0) = 0 := measure_mono_null hsub (measure_union_null hnn h0)
  simp [Measure.real, this]

/-- S2. Source :153 (implicit, never stated): the density `f` is the a.e. derivative of `F_X`,
so `F_X` is differentiable with derivative `f` at almost every `u`. Needed for "the derivative of ...".
Uses: nothing. -/
theorem P01_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f) :
    ∀ᵐ u ∂(volume : Measure ℝ), HasDerivAt (F μ) (f u).toReal u := by
  have h1 := (cdf μ).ae_hasDerivAt
  rw [measure_cdf] at h1
  have h2 := Measure.rnDeriv_withDensity (volume : Measure ℝ) hf
  rw [← hdens] at h2
  filter_upwards [h1, h2] with u hu h2u
  unfold F
  rw [← h2u]
  exact hu

/-- S3. Source :153: "the derivative of `(1/x)(1-F_X(1/x))` has the same sign as
`(1/x) f_X(1/x) + F_X(1/x) - 1`." Precisely: where `F` has derivative `d` at `1/x`,
`g(x)=(1/x)(1-F(1/x))` has derivative `x⁻² * ((1/x) d + F(1/x) - 1)` at `x>0`.
Uses: nothing. -/
theorem P01_S3 (μ : Measure ℝ) (x d : ℝ) (hx : 0 < x) (hd : HasDerivAt (F μ) d (1 / x)) :
    HasDerivAt (fun t => (1 / t) * (1 - F μ (1 / t)))
      ((x ^ 2)⁻¹ * ((1 / x) * d + F μ (1 / x) - 1)) x := by
  have h1 : HasDerivAt (fun t : ℝ => 1 / t) (-(x ^ 2)⁻¹) x := by
    simpa [one_div] using hasDerivAt_inv hx.ne'
  have h2 : HasDerivAt (fun t => F μ (1 / t)) (d * (-(x ^ 2)⁻¹)) x :=
    HasDerivAt.comp x hd h1
  have h3 := h1.mul (h2.const_sub 1)
  convert h3 using 1
  field_simp
  ring

/-- helper (technical conversion): `Fbar = μ (Ioi t)` as a real number. -/
private theorem Fbar_eq (μ : Measure ℝ) [IsProbabilityMeasure μ] (t : ℝ) :
    Fbar μ t = (μ (Ioi t)).toReal := by
  unfold Fbar F
  rw [cdf_eq_real, ← compl_Iic, ← Measure.real, measureReal_compl measurableSet_Iic]
  simp

/-- helper: core a.e. pointwise inequality `y f(y) ≤ Fbar(y)` (hazard bound, with the
`Fbar = 0` case handled by S2 and a local maximum of `F`; implicit step D2 of the gate). -/
private theorem ae_haz (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    ∀ᵐ y ∂(volume : Measure ℝ), 0 < y → y * (f y).toReal ≤ Fbar μ y := by
  filter_upwards [P01_S2 μ f hf hdens] with y hy hy0
  by_cases h : Fbar μ y = 0
  · have hF : F μ y = 1 := by unfold Fbar at h; linarith
    have hmax : IsLocalMax (F μ) y :=
      Filter.Eventually.of_forall (fun z => by
        show F μ z ≤ F μ y
        rw [hF]; exact cdf_le_one μ z)
    have := hmax.hasDerivAt_eq_zero hy
    rw [this, h]; simp
  · have hpos : 0 < Fbar μ y :=
      lt_of_le_of_ne (by unfold Fbar F; linarith [cdf_le_one μ y]) (Ne.symm h)
    have := hhaz y hy0
    unfold hazard at this
    rw [div_le_div_iff₀ hpos hy0] at this
    linarith

/-- S4. Source :153: "which, according to the assumption, is easily seen to be negative"
(the hypothesis gives only `≤ 0`). A.e. version in the density context: on `{Fbar > 0}` it is
the hazard bound; on `{Fbar = 0}`, `f = 0` a.e. since `μ` puts no mass there (implicit step D2).
Uses: hypothesis `hhaz`, `hdens`. -/
theorem P01_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    ∀ᵐ x ∂(volume : Measure ℝ), 0 < x →
      (1 / x) * (f (1 / x)).toReal + F μ (1 / x) - 1 ≤ 0 := by
  have hae := ae_haz μ f hf hdens hhaz
  rw [ae_iff] at hae ⊢
  have himg : volume ((fun y : ℝ => 1 / y) ''
      ({y : ℝ | ¬ (0 < y → y * (f y).toReal ≤ Fbar μ y)} ∩ Ioi 0)) = 0 := by
    refine addHaar_image_eq_zero_of_differentiableOn_of_addHaar_eq_zero volume ?_ ?_
    · intro y hy
      exact ((differentiableAt_const (1:ℝ)).div differentiableAt_id
        (ne_of_gt hy.2)).differentiableWithinAt
    · exact measure_mono_null inter_subset_left hae
  refine measure_mono_null ?_ himg
  intro x hx
  simp only [mem_setOf_eq, _root_.not_imp, not_le] at hx
  obtain ⟨hx0, hxb⟩ := hx
  refine ⟨1 / x, ⟨?_, ?_⟩, by simp⟩
  · simp only [mem_setOf_eq, _root_.not_imp, not_le]
    refine ⟨by positivity, ?_⟩
    unfold Fbar
    linarith
  · exact show (0:ℝ) < 1 / x by positivity

/-- helper: ENNReal pointwise identity behind the integrated form of
`φ(b) - φ(a) = ∫_a^b (Fbar - y f)`, `φ(y) = y Fbar(y)`. -/
private theorem hpt_id (a b : ℝ) (ha : 0 < a) (hab : a < b) (t : ℝ) :
    ENNReal.ofReal a * (Ioi a).indicator 1 t + volume (Ioc a b ∩ Iio t)
      = ENNReal.ofReal b * (Ioi b).indicator 1 t
        + (Ioc a b).indicator (fun t => ENNReal.ofReal t) t := by
  rcases le_or_gt t a with h1 | h1
  · have e : Ioc a b ∩ Iio t = ∅ := by
      ext y; simp only [mem_inter_iff, mem_Ioc, mem_Iio, mem_empty_iff_false, iff_false]
      rintro ⟨⟨hy1, _⟩, hy3⟩; linarith
    have m1 : t ∉ Ioi a := by simp [h1]
    have m2 : t ∉ Ioi b := by simp; linarith
    have m3 : t ∉ Ioc a b := by simp [h1]
    rw [e, indicator_of_not_mem m1, indicator_of_not_mem m2, indicator_of_not_mem m3]
    simp
  rcases le_or_gt t b with h2 | h2
  · have e : Ioc a b ∩ Iio t = Ioo a t := by
      ext y; simp only [mem_inter_iff, mem_Ioc, mem_Iio, mem_Ioo]
      constructor
      · rintro ⟨⟨hy1, _⟩, hy3⟩; exact ⟨hy1, hy3⟩
      · rintro ⟨hy1, hy3⟩; exact ⟨⟨hy1, by linarith⟩, hy3⟩
    have m1 : t ∈ Ioi a := h1
    have m2 : t ∉ Ioi b := by simp [h2]
    have m3 : t ∈ Ioc a b := ⟨h1, h2⟩
    rw [e, indicator_of_mem m1, indicator_of_not_mem m2, indicator_of_mem m3, Real.volume_Ioo]
    simp only [Pi.one_apply, mul_one, mul_zero, zero_add]
    rw [← ENNReal.ofReal_add ha.le (by linarith)]
    congr 1; ring
  · have e : Ioc a b ∩ Iio t = Ioc a b := by
      ext y; simp only [mem_inter_iff, mem_Ioc, mem_Iio]
      constructor
      · rintro ⟨h, _⟩; exact h
      · rintro ⟨hy1, hy2⟩; exact ⟨⟨hy1, hy2⟩, by linarith⟩
    have m1 : t ∈ Ioi a := by simp; linarith
    have m2 : t ∈ Ioi b := h2
    have m3 : t ∉ Ioc a b := fun h => absurd h.2 (not_le.2 h2)
    rw [e, indicator_of_mem m1, indicator_of_mem m2, indicator_of_not_mem m3, Real.volume_Ioc]
    simp only [Pi.one_apply, mul_one, add_zero]
    rw [← ENNReal.ofReal_add ha.le (by linarith)]
    congr 1; ring

/-- helper: Tonelli swap. -/
private theorem tonelli_id (μ : Measure ℝ) [IsProbabilityMeasure μ] (a b : ℝ) :
    ∫⁻ t, volume (Ioc a b ∩ Iio t) ∂μ = ∫⁻ y in Ioc a b, μ (Ioi y) ∂volume := by
  set E : Set (ℝ × ℝ) := {p | p.2 ∈ Ioc a b ∧ p.2 < p.1} with hEdef
  have hE : MeasurableSet E :=
    (measurableSet_Ioc.preimage measurable_snd).inter
      (measurableSet_lt measurable_snd measurable_fst)
  have h1 : (μ.prod volume) E = ∫⁻ t, volume (Ioc a b ∩ Iio t) ∂μ := by
    rw [Measure.prod_apply hE]
    refine lintegral_congr (fun t => ?_)
    congr 1
  have h2 : (μ.prod volume) E = ∫⁻ y in Ioc a b, μ (Ioi y) ∂volume := by
    rw [Measure.prod_apply_symm hE, ← lintegral_indicator measurableSet_Ioc]
    refine lintegral_congr (fun y => ?_)
    by_cases hy : y ∈ Ioc a b
    · rw [indicator_of_mem hy]
      congr 1
      ext t
      simp only [mem_preimage, E, mem_setOf_eq, mem_Ioi]
      exact ⟨fun h => h.2, fun h => ⟨hy, h⟩⟩
    · rw [indicator_of_not_mem hy]
      have : (fun x : ℝ => (x, y)) ⁻¹' E = ∅ := by
        ext t
        simp only [mem_preimage, E, mem_setOf_eq, mem_empty_iff_false, iff_false]
        exact fun h => hy h.1
      rw [this]; simp
  rw [← h1, h2]

/-- helper: a.e. pointwise bound in `ℝ≥0∞`. -/
private theorem ae_haz_ennreal (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    ∀ᵐ t ∂(volume : Measure ℝ), 0 < t → f t * ENNReal.ofReal t ≤ μ (Ioi t) := by
  have hfin : ∫⁻ x, f x ∂volume ≠ ⊤ := by
    have : μ univ = ∫⁻ x, f x ∂volume := by
      rw [hdens, withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ]
    rw [← this]; simp
  filter_upwards [ae_haz μ f hf hdens hhaz, ae_lt_top hf hfin] with t h1 h2 ht
  have h1 := h1 ht
  rw [Fbar_eq] at h1
  have e : f t * ENNReal.ofReal t = ENNReal.ofReal (t * (f t).toReal) := by
    rw [ENNReal.ofReal_mul ht.le, ENNReal.ofReal_toReal h2.ne, mul_comm]
  rw [e]
  calc ENNReal.ofReal (t * (f t).toReal) ≤ ENNReal.ofReal ((μ (Ioi t)).toReal) :=
        ENNReal.ofReal_le_ofReal h1
    _ = μ (Ioi t) := ENNReal.ofReal_toReal (measure_ne_top _ _)

/-- helper: the integrated form (FTC) of the derivative computation. -/
private theorem key (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) (a b : ℝ) (ha : 0 < a) (hab : a < b) :
    a * Fbar μ a ≤ b * Fbar μ b := by
  have hint := lintegral_congr (μ := μ) (hpt_id a b ha hab)
  have hanti : Antitone (fun y : ℝ => μ (Ioi y)) :=
    fun x y hxy => measure_mono (Ioi_subset_Ioi hxy)
  have hmeas_anti : Measurable (fun y : ℝ => μ (Ioi y)) := hanti.measurable
  have hL : ∫⁻ t, (ENNReal.ofReal a * (Ioi a).indicator 1 t + volume (Ioc a b ∩ Iio t)) ∂μ
      = ENNReal.ofReal a * μ (Ioi a) + ∫⁻ y in Ioc a b, μ (Ioi y) ∂volume := by
    rw [lintegral_add_left (measurable_const.mul (measurable_one.indicator measurableSet_Ioi)),
      lintegral_const_mul _ (measurable_one.indicator measurableSet_Ioi),
      lintegral_indicator_one measurableSet_Ioi, tonelli_id]
  have hR : ∫⁻ t, (ENNReal.ofReal b * (Ioi b).indicator 1 t
        + (Ioc a b).indicator (fun t => ENNReal.ofReal t) t) ∂μ
      = ENNReal.ofReal b * μ (Ioi b) + ∫⁻ t in Ioc a b, ENNReal.ofReal t ∂μ := by
    rw [lintegral_add_left (measurable_const.mul (measurable_one.indicator measurableSet_Ioi)),
      lintegral_const_mul _ (measurable_one.indicator measurableSet_Ioi),
      lintegral_indicator_one measurableSet_Ioi,
      lintegral_indicator measurableSet_Ioc]
  rw [hL, hR] at hint
  have hJ : ∫⁻ t in Ioc a b, ENNReal.ofReal t ∂μ ≤ ∫⁻ y in Ioc a b, μ (Ioi y) ∂volume := by
    have e : ∫⁻ t in Ioc a b, ENNReal.ofReal t ∂μ
        = ∫⁻ t in Ioc a b, (f * ENNReal.ofReal) t ∂volume := by
      rw [hdens]
      exact setLIntegral_withDensity_eq_setLIntegral_mul volume hf
        ENNReal.measurable_ofReal measurableSet_Ioc
    rw [e]
    refine setLIntegral_mono_ae hmeas_anti.aemeasurable ?_
    filter_upwards [ae_haz_ennreal μ f hf hdens hhaz] with t ht htm
    have := ht (ha.trans htm.1)
    simpa [Pi.mul_apply, mul_comm] using this
  have hIfin : ∫⁻ y in Ioc a b, μ (Ioi y) ∂volume ≠ ⊤ := by
    refine ne_top_of_le_ne_top (b := ∫⁻ y in Ioc a b, (1 : ENNReal) ∂volume) ?_ ?_
    · simp
    · exact setLIntegral_mono_ae aemeasurable_const (ae_of_all _ (fun y _ => prob_le_one))
  have hle : ENNReal.ofReal a * μ (Ioi a) ≤ ENNReal.ofReal b * μ (Ioi b) := by
    refine ENNReal.le_of_add_le_add_right hIfin ?_
    rw [hint]
    exact add_le_add_left hJ _
  have conv : ∀ c : ℝ, 0 ≤ c →
      ENNReal.ofReal (c * Fbar μ c) = ENNReal.ofReal c * μ (Ioi c) := by
    intro c hc
    rw [ENNReal.ofReal_mul hc, Fbar_eq, ENNReal.ofReal_toReal (measure_ne_top _ _)]
  have hb : 0 ≤ b := by linarith
  have nb : 0 ≤ b * Fbar μ b := by rw [Fbar_eq]; positivity
  rw [← ENNReal.ofReal_le_ofReal_iff nb, conv a ha.le, conv b hb]
  exact hle

/-- S5. Source :153: "It follows that `1-F_X(1/x)` is anti-star-shaped": `x ↦ (1/x)(1-F_X(1/x))`
is non-increasing on `(0,∞)`. (Passing from a.e. nonpositive derivative to monotonicity is not
written in the source.) Uses: S2, S3, S4. -/
theorem P01_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    AntitoneOn (fun x => invDist μ x / x) (Ioi 0) := by
  have e : ∀ x : ℝ, invDist μ x / x = (1 / x) * Fbar μ (1 / x) := by
    intro x; unfold invDist Fbar; ring
  intro x1 hx1 x2 hx2 hxy
  have hx1 : 0 < x1 := hx1
  simp only [e]
  rcases eq_or_lt_of_le hxy with h | h
  · rw [h]
  · exact key μ f hf hdens hhaz (1 / x2) (1 / x1) (by have : 0 < x2 := hx2; positivity)
      (one_div_lt_one_div_of_lt hx1 h)

/-- S6. Source :153: "as it vanishes at zero": `1 - F_X(1/x) → 0` as `x → 0+`, i.e. `F_X(∞)=1`;
justifies that the extension `vExt` with `vExt 0 = 0` is anti-star-shaped on `[0,∞)`.
Uses: S5. -/
theorem P01_S6 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h5 : AntitoneOn (fun x => invDist μ x / x) (Ioi 0)) :
    AntiStarShaped (vExt μ) := by
  refine ⟨by simp [vExt], ?_⟩
  intro x hx y hy hxy
  have hx' : x ≠ 0 := ne_of_gt hx
  have hy' : y ≠ 0 := ne_of_gt hy
  simpa [vExt, hx', hy'] using h5 hx hy hxy

/-- S7. Source :153: "therefore, it is subadditive". Standard
anti-star-shaped ⇒ subadditive argument, proved in place. -/
theorem P01_S7 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h6 : AntiStarShaped (vExt μ)) : SubadditiveOnPos (invDist μ) := by
  intro x y hx hy
  have hxy : 0 < x + y := add_pos hx hy
  have h1 := h6.2 (mem_Ioi.2 hx) (mem_Ioi.2 hxy) (by linarith)
  have h2 := h6.2 (mem_Ioi.2 hy) (mem_Ioi.2 hxy) (by linarith)
  have e : ∀ z : ℝ, 0 < z → vExt μ z = invDist μ z := fun z hz => by simp [vExt, hz.ne']
  simp only [e x hx, e y hy, e _ hxy] at h1 h2
  rw [div_le_div_iff₀ hxy hx] at h1
  rw [div_le_div_iff₀ hxy hy] at h2
  nlinarith

/-- Main theorem. Source :148-151 (Proposition 2.5): "Assume the nonnegative random variable `X`
has density `f_X` such that its hazard rate `r_X(x) = f_X(x)/Fbar_X(x) ≤ 1/x`, for `x>0`.
Then `X` is InvSub."  `X` is represented by its law `μ` (probability measure, no mass on `(-∞,0)`),
density `f` w.r.t. Lebesgue measure. -/
theorem P01_main
    (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hnn : μ (Iio 0) = 0)
    (f : ℝ → ENNReal) (hf : Measurable f) (hdens : μ = volume.withDensity f)
    (hhaz : ∀ x : ℝ, 0 < x → hazard μ f x ≤ 1 / x) :
    InvSub μ :=
  ⟨P01_S1 μ hnn f hdens, P01_S7 μ (P01_S6 μ (P01_S5 μ f hf hdens hhaz))⟩

end Paper.P01

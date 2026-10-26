import T02Stmt

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-! Technical helpers (types / measurability / domain facts derived from the hypotheses). -/

private lemma gU_meas {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hgrad : IsGradField U gU) :
    Measurable gU := by
  have : gU = gradient U := funext fun x => (hgrad x).gradient.symm
  rw [this]
  unfold gradient
  exact (LinearIsometryEquiv.continuous _).measurable.comp (measurable_fderiv ℝ U)

private lemma step_meas {d : ℕ} (gU : E d → E d) (hg : Measurable gU) (eps : ℝ) :
    Measurable (leapfrogStep gU eps) := by
  unfold leapfrogStep
  fun_prop

private lemma lf_meas {d : ℕ} (gU : E d → E d) (hg : Measurable gU) (eps : ℝ) (x0 : E d) (n : ℕ) :
    Measurable (fun p : E d => leapfrogState gU eps x0 p n) := by
  induction n with
  | zero => exact measurable_const.prodMk measurable_id
  | succ n ih => exact (step_meas gU hg eps).comp ih

private lemma acc_meas {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hgrad : IsGradField U gU) (eps : ℝ)
    (L : ℕ) (x : E d) : Measurable (fun p : E d => accProb U gU eps L x p) := by
  have hg := gU_meas U gU hgrad
  have h1 : Measurable (fun p : E d => xLF gU eps x p L) :=
    measurable_fst.comp (lf_meas gU hg eps x L)
  have h2 : Measurable (fun p : E d => pLF gU eps x p L) :=
    measurable_snd.comp (lf_meas gU hg eps x L)
  have hP : Measurable (piDens U) := (by
    have hU : Continuous U :=
      continuous_iff_continuousAt.2 fun x => (hgrad x).hasFDerivAt.continuousAt
    unfold piDens; fun_prop : Continuous (piDens U)).measurable
  unfold accProb
  exact measurable_const.min ((((hP.comp h1).div_const _).mul
    (Real.measurable_exp.comp (by fun_prop))))

private lemma acc_nonneg {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x p : E d) :
    0 ≤ accProb U gU eps L x p := by
  unfold accProb piDens
  exact le_min zero_le_one (by positivity)

private lemma acc_le_one {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x p : E d) :
    accProb U gU eps L x p ≤ 1 := min_le_left _ _

private lemma intg01 {d : ℕ} (μ : Measure (E d)) [IsProbabilityMeasure μ] (f : E d → ℝ)
    (hm : Measurable f) (h0 : ∀ p, 0 ≤ f p) (h1 : ∀ p, f p ≤ 1) : Integrable f μ :=
  Integrable.mono' (integrable_const (1 : ℝ)) hm.aestronglyMeasurable
    (ae_of_all _ fun p => by rw [Real.norm_eq_abs, abs_of_nonneg (h0 p)]; exact h1 p)

/-- `0 ≤ ∫ α ≤ 1` for the Gaussian measure (a probability measure by `GaussFacts` (a)). -/
private lemma J01 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (x : E d) :
    0 ≤ ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∧
      ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ≤ 1 := by
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  refine ⟨integral_nonneg (acc_nonneg U gU eps L x), ?_⟩
  calc ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d)
      ≤ ∫ p : E d, (1 : ℝ) ∂(gaussMeas d) :=
        integral_mono_of_nonneg (ae_of_all _ (acc_nonneg U gU eps L x)) (integrable_const _)
          (ae_of_all _ (acc_le_one U gU eps L x))
    _ = 1 := by simp

private lemma tail_ne_zero {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (R : ℝ) :
    targetMeas U {x : E d | R < ‖x‖} ≠ 0 := by
  have hU : Continuous U :=
    continuous_iff_continuousAt.2 fun x => (hgrad x).hasFDerivAt.continuousAt
  have hfm : Measurable (fun x : E d => ENNReal.ofReal (piDens U x)) :=
    (Continuous.measurable (by unfold piDens; fun_prop)).ennreal_ofReal
  have hA : IsOpen {x : E d | R < ‖x‖} := isOpen_lt continuous_const continuous_norm
  have hne : ({x : E d | R < ‖x‖}).Nonempty := by
    refine ⟨EuclideanSpace.single ⟨0, hd⟩ (|R| + 1), ?_⟩
    simp only [Set.mem_setOf_eq, EuclideanSpace.norm_single, Real.norm_eq_abs]
    rw [abs_of_nonneg (by positivity)]
    linarith [le_abs_self R]
  have hvol : volume {x : E d | R < ‖x‖} ≠ 0 := (hA.measure_pos _ hne).ne'
  have hwd : (volume.withDensity (fun x : E d => ENNReal.ofReal (piDens U x)))
      {x : E d | R < ‖x‖} ≠ 0 := by
    rw [withDensity_apply _ hA.measurableSet]
    intro h0
    rw [lintegral_eq_zero_iff hfm] at h0
    have h1 : ∀ᵐ x ∂(volume.restrict {x : E d | R < ‖x‖}), False := h0.mono (fun x hx => by
      have : ENNReal.ofReal (piDens U x) = 0 := hx
      rw [ENNReal.ofReal_eq_zero] at this
      exact absurd this (not_le.2 (Real.exp_pos _)))
    have h2 := ae_eq_bot.1 (Filter.eventually_false_iff_eq_bot.1 h1)
    apply hvol
    simpa using congrArg (fun μ : Measure (E d) => μ Set.univ) h2
  have hc0 : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) ≠ 0 := by
    intro h0
    apply hwd
    refine le_antisymm ?_ bot_le
    calc (volume.withDensity (fun x : E d => ENNReal.ofReal (piDens U x)))
          {x : E d | R < ‖x‖}
        ≤ (volume.withDensity (fun x : E d => ENNReal.ofReal (piDens U x))) Set.univ :=
          measure_mono (Set.subset_univ _)
      _ = 0 := by rw [withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ]; exact h0
  unfold targetMeas
  rw [Measure.smul_apply, smul_eq_mul]
  exact mul_ne_zero (ENNReal.inv_ne_zero.2 hπ.ne) hwd

/-- Technical: `esssup_π r = 1` from `r ≤ 1` and `r → 1` along `‖x‖ → ∞` (used by S8 and SR5). -/
private lemma essSup_one_of {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hd : 0 < d)
    (hgrad : IsGradField U gU) (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (r : E d → ℝ)
    (h6 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ r x)
    (hle : ∀ x : E d, r x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (r x)) (targetMeas U) = 1 := by
  apply le_antisymm
  · exact essSup_le_of_ae_le _ (Filter.Eventually.of_forall fun x =>
      ENNReal.ofReal_le_one.2 (hle x))
  · by_contra hlt
    push_neg at hlt
    set s := essSup (fun x : E d => ENNReal.ofReal (r x)) (targetMeas U) with hs
    have hsne : s ≠ ⊤ := hlt.ne_top
    have s1 : s.toReal < 1 := by
      have := (ENNReal.toReal_lt_toReal hsne ENNReal.one_ne_top).2 hlt
      simpa using this
    have hκ : 0 < (1 - s.toReal) / 2 := by linarith
    obtain ⟨R, hR⟩ := h6 _ hκ
    have hae := ae_le_essSup (μ := targetMeas U)
      (f := fun x : E d => ENNReal.ofReal (r x))
    have hnot : ∀ᵐ x ∂(targetMeas U), x ∉ {x : E d | R < ‖x‖} := hae.mono (fun x hx hxT => by
      have h1 : ENNReal.ofReal (1 - (1 - s.toReal) / 2) ≤ s :=
        (ENNReal.ofReal_le_ofReal (hR x hxT)).trans hx
      have h2 : ENNReal.ofReal (1 - (1 - s.toReal) / 2) ≤ ENNReal.ofReal s.toReal := by
        rw [ENNReal.ofReal_toReal hsne]; exact h1
      rw [ENNReal.ofReal_le_ofReal_iff ENNReal.toReal_nonneg] at h2
      linarith)
    exact tail_ne_zero U gU hd hgrad hπ R (measure_zero_iff_ae_nmem.2 hnot)

/-- Technical: the one-step kernel evaluated on a measurable set, as a lintegral. -/
private lemma step_apply {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hgrad : IsGradField U gU) (x : E d) (A : Set (E d)) (hA : MeasurableSet A) :
    hmcStep U gU eps L x A = ∫⁻ p, ENNReal.ofReal
      (accProb U gU eps L x p * A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L) +
        (1 - accProb U gU eps L x p) * A.indicator (fun _ => (1 : ℝ)) x) ∂(gaussMeas d) := by
  have hα := acc_meas U gU hgrad eps L x
  have hg := gU_meas U gU hgrad
  have hxL : Measurable (fun p : E d => xLF gU eps x p L) :=
    measurable_fst.comp (lf_meas gU hg eps x L)
  have hα1 := acc_le_one U gU eps L x
  have hα0 := acc_nonneg U gU eps L x
  set G : E d → ℝ := A.indicator (fun _ => (1 : ℝ)) with hG
  have hG0 : ∀ y, 0 ≤ G y := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hGe : ∀ y, A.indicator (fun _ => (1 : ENNReal)) y = ENNReal.ofReal (G y) := fun y => by
    by_cases hy : y ∈ A <;> simp [hG, hy]
  let κf : E d → Measure (E d) := fun p =>
    ENNReal.ofReal (accProb U gU eps L x p) • Measure.dirac (xLF gU eps x p L) +
    ENNReal.ofReal (1 - accProb U gU eps L x p) • Measure.dirac x
  have hκ : ∀ B : Set (E d), MeasurableSet B → ∀ p, κf p B =
      ENNReal.ofReal (accProb U gU eps L x p) * B.indicator (fun _ => (1 : ENNReal)) (xLF gU eps x p L) +
      ENNReal.ofReal (1 - accProb U gU eps L x p) * B.indicator (fun _ => (1 : ENNReal)) x := by
    intro B hB p
    simp only [κf, Measure.add_apply, Measure.smul_apply, smul_eq_mul, Measure.dirac_apply' _ hB]
    rfl
  have hκm : Measurable κf := by
    refine Measure.measurable_of_measurable_coe _ (fun B hB => ?_)
    simp_rw [hκ B hB]
    exact ((ENNReal.measurable_ofReal.comp hα).mul ((measurable_const.indicator hB).comp hxL)).add
      ((ENNReal.measurable_ofReal.comp (measurable_const.sub hα)).mul measurable_const)
  unfold hmcStep
  rw [Measure.bind_apply hA hκm.aemeasurable]
  refine lintegral_congr fun p => ?_
  show κf p A = _
  rw [hκ A hA p, hGe, hGe, ENNReal.ofReal_add (mul_nonneg (hα0 p) (hG0 _))
    (mul_nonneg (sub_nonneg.2 (hα1 p)) (hG0 _)), ENNReal.ofReal_mul (hα0 p),
    ENNReal.ofReal_mul (sub_nonneg.2 (hα1 p))]

/-- Technical: the one-step kernel has mass `≤ 1` on every measurable set. -/
private lemma step_le_one {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (x : E d) (A : Set (E d)) (hA : MeasurableSet A) :
    hmcStep U gU eps L x A ≤ 1 := by
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  rw [step_apply U gU eps L hgrad x A hA]
  calc _ ≤ ∫⁻ p : E d, 1 ∂(gaussMeas d) := by
        refine lintegral_mono fun p => ?_
        rw [← ENNReal.ofReal_one]
        refine ENNReal.ofReal_le_ofReal ?_
        have h0 := acc_nonneg U gU eps L x p
        have h1 := acc_le_one U gU eps L x p
        by_cases a : xLF gU eps x p L ∈ A <;> by_cases b : x ∈ A <;> simp [a, b] <;> linarith
    _ = 1 := by simp

/-! ### Proof of Theorem 5.14 (TEX:911-932) -/

/-- S1 (TEX:911-916): uniform form of the limit of Lemma 5.17 (`hL03`), unfolding the `Tendsto` along
`tailMomFilter`. -/
theorem T02_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL03 : T02_L03Consumed U gU eps L) (δ : ℝ) (hδ : δ < 1) (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → accProb U gU eps L x0 p0 ≤ κ := by
  -- TEX:911-915: "From Lemma arate_0", the `Tendsto` in `hL03 δ hδ`.
  have hev : ∀ᶠ q in tailMomFilter d δ, accProb U gU eps L q.1 q.2 < κ :=
    (hL03 δ hδ).eventually (Iio_mem_nhds hκ)
  rw [tailMomFilter, Filter.eventually_inf_principal, Filter.eventually_comap,
    Filter.eventually_atTop] at hev
  obtain ⟨R, hR⟩ := hev
  exact ⟨R, fun x0 p0 hx hp => (hR ‖x0‖ hx.le (x0, p0) rfl hp).le⟩

/-- S2 (TEX:917-921): Gaussian tail, from `GaussFacts` (b). -/
theorem T02_S2 {d : ℕ} (hE6 : GaussFacts) (δ : ℝ) (hδ : 0 < δ) :
    Tendsto (fun x : E d => (gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖})
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  have h1 : Tendsto (fun x : E d => (gaussMeas d) {p : E d | ‖p‖ ≤ ‖x‖ ^ δ})
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 1) :=
    ((hE6 d).2 δ hδ).comp tendsto_comap
  have h2 := ENNReal.Tendsto.sub (tendsto_const_nhds (x := (1 : ENNReal))) h1 (Or.inl ENNReal.one_ne_top)
  simp only [tsub_self] at h2
  refine h2.congr (fun x => ?_)
  have hS : MeasurableSet {p : E d | ‖p‖ ≤ ‖x‖ ^ δ} :=
    measurableSet_le continuous_norm.measurable measurable_const
  have : {p : E d | ‖x‖ ^ δ < ‖p‖} = {p : E d | ‖p‖ ≤ ‖x‖ ^ δ}ᶜ := by
    ext p; simp
  rw [this, prob_compl_eq_one_sub hS]

/-- S3 (TEX:922-925): `1 - r(x_0) = ∫ α μ_G(dp_0)`, by the definition of `rejProb`. -/
theorem T02_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    1 - rejProb U gU eps L x = ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) := by
  unfold rejProb; ring

/-- S4 (TEX:926-931): `∫ α dμ_G ≤ κ + μ_G(‖p_0‖ > ‖x_0‖^δ)`. -/
theorem T02_S4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (x : E d) (δ κ : ℝ)
    (h : ∀ p : E d, ‖p‖ ≤ ‖x‖ ^ δ → accProb U gU eps L x p ≤ κ) :
    ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ≤
      κ + ((gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖}).toReal := by
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  set S : Set (E d) := {p : E d | ‖x‖ ^ δ < ‖p‖} with hS
  have hSm : MeasurableSet S := measurableSet_lt measurable_const continuous_norm.measurable
  have hκ0 : 0 ≤ κ := by
    have := h 0 (by simpa using Real.rpow_nonneg (norm_nonneg x) δ)
    exact (acc_nonneg U gU eps L x 0).trans this
  have hint : Integrable (fun p : E d => κ + S.indicator (fun _ => (1 : ℝ)) p) (gaussMeas d) :=
    (integrable_const _).add ((integrable_const (1 : ℝ)).indicator hSm)
  have hle : ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ≤
      ∫ p : E d, (κ + S.indicator (fun _ => (1 : ℝ)) p) ∂(gaussMeas d) := by
    apply integral_mono_of_nonneg (ae_of_all _ (acc_nonneg U gU eps L x)) hint
    refine ae_of_all _ (fun p => ?_)
    by_cases hp : p ∈ S
    · have := acc_le_one U gU eps L x p
      simp [hp]; linarith
    · have hp' : ‖p‖ ≤ ‖x‖ ^ δ := not_lt.1 hp
      have := h p hp'
      simp [hp]; linarith
  refine hle.trans (le_of_eq ?_)
  rw [integral_add (integrable_const _) ((integrable_const (1 : ℝ)).indicator hSm),
    integral_const, integral_indicator hSm]
  simp [Measure.real]

/-- S5 (TEX:932): from S1-S4, `r(x) → 1`, in the form `1 - κ ≤ r(x)` for `‖x‖` large. -/
theorem T02_S5 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (δ : ℝ) (hδ0 : 0 < δ) (hδ : δ < 1)
    (hS1 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      accProb U gU eps L x0 p0 ≤ κ)
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x := by
  have hκ2 : 0 < κ / 2 := by linarith
  obtain ⟨R1, hR1⟩ := hS1 (κ / 2) hκ2
  have hT : ∀ᶠ x in comap (fun x : E d => ‖x‖) atTop,
      (gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖} < ENNReal.ofReal (κ / 2) :=
    (T02_S2 hE6 δ hδ0).eventually (Iio_mem_nhds (ENNReal.ofReal_pos.2 hκ2))
  rw [Filter.eventually_comap, Filter.eventually_atTop] at hT
  obtain ⟨R2, hR2⟩ := hT
  refine ⟨max R1 R2, fun x hx => ?_⟩
  have hx1 : R1 < ‖x‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : R2 ≤ ‖x‖ := (le_max_right _ _).trans hx.le
  have ht : ((gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖}).toReal ≤ κ / 2 :=
    ENNReal.toReal_le_of_le_ofReal hκ2.le (hR2 ‖x‖ hx2 x rfl).le
  have h4 := T02_S4 U gU eps L hE6 x δ (κ / 2) (fun p hp => hR1 x p hx1 hp)
  have h3 := T02_S3 U gU eps L x
  linarith

/-- S6 (not printed; the MH-type form of the HMC kernel, eqn:mhtype TEX:274-279). -/
theorem T02_S6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (x : E d) (A : Set (E d)) (hA : MeasurableSet A) :
    (hmcStep U gU eps L x A).toReal =
      (∫ p : E d, accProb U gU eps L x p * A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L)
          ∂(gaussMeas d)) +
        rejProb U gU eps L x * A.indicator (fun _ => (1 : ℝ)) x := by
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  have hα := acc_meas U gU hgrad eps L x
  have hg := gU_meas U gU hgrad
  have hxL : Measurable (fun p : E d => xLF gU eps x p L) :=
    measurable_fst.comp (lf_meas gU hg eps x L)
  have hα1 := acc_le_one U gU eps L x
  have hα0 := acc_nonneg U gU eps L x
  set G : E d → ℝ := A.indicator (fun _ => (1 : ℝ)) with hG
  have hGm : Measurable G := measurable_const.indicator hA
  have hG0 : ∀ y, 0 ≤ G y := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hG1 : ∀ y, G y ≤ 1 := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hu : Integrable (fun p : E d => accProb U gU eps L x p * G (xLF gU eps x p L)) (gaussMeas d) :=
    intg01 _ _ (hα.mul (hGm.comp hxL)) (fun p => mul_nonneg (hα0 p) (hG0 _))
      (fun p => mul_le_one₀ (hα1 p) (hG0 _) (hG1 _))
  have hv : Integrable (fun p : E d => (1 - accProb U gU eps L x p) * G x) (gaussMeas d) :=
    ((integrable_const (1 : ℝ)).sub (intg01 _ _ hα hα0 hα1)).mul_const _
  have hnn : ∀ p, 0 ≤ accProb U gU eps L x p * G (xLF gU eps x p L) +
      (1 - accProb U gU eps L x p) * G x := fun p =>
    add_nonneg (mul_nonneg (hα0 p) (hG0 _)) (mul_nonneg (sub_nonneg.2 (hα1 p)) (hG0 _))
  have hsum : Integrable (fun p : E d => accProb U gU eps L x p * G (xLF gU eps x p L) +
      (1 - accProb U gU eps L x p) * G x) (gaussMeas d) := hu.add hv
  rw [step_apply U gU eps L hgrad x A hA,
    ← ofReal_integral_eq_lintegral_ofReal hsum (ae_of_all _ hnn),
    ENNReal.toReal_ofReal (integral_nonneg hnn), integral_add hu hv, integral_mul_const,
    integral_sub (integrable_const _) (intg01 _ _ hα hα0 hα1)]
  simp [rejProb]

/-- S7 (not printed): `r ≤ 1`, as `α ≥ 0`. -/
theorem T02_S7 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    rejProb U gU eps L x ≤ 1 := by
  have h : 0 ≤ ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) :=
    integral_nonneg (acc_nonneg U gU eps L x)
  unfold rejProb
  linarith

/-- S8 (not printed): `esssup_π r = 1`. -/
theorem T02_S8 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hd : 0 < d)
    (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h5 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x)
    (hle : ∀ x : E d, rejProb U gU eps L x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 :=
  essSup_one_of U gU hd hgrad hπ _ h5 hle

/-- S9 (TEX:932): Proposition 3.5 (`hE1`). -/
theorem T02_S9 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE1 : Prop35)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps) (hL : 1 ≤ L)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1) :
    ¬ GeomErgodic U gU eps L :=
  hE1 d U gU eps L hd hgrad hπ heps hL hess

/-- Main theorem (TEX:895-932), fixed `L`. -/
theorem T02_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL03 : T02_L03Consumed U gU eps L) (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ¬ GeomErgodic U gU eps L := by
  -- TEX:911: fix `δ = 1/2 < 1`.
  have hS1 := fun κ hκ => T02_S1 U gU eps L hL03 (1 / 2) (by norm_num) κ hκ
  have h5 := fun κ hκ => T02_S5 U gU eps L hE6 (1 / 2) (by norm_num) (by norm_num) hS1 κ hκ
  exact T02_S9 U gU eps L hE1 hd hgrad hπ heps hL
    (T02_S8 U gU eps L hd hgrad hπ h5 (T02_S7 U gU eps L))

/-! ### Random number of leapfrog steps, TEX:934-940 -/

/-- SR1 (TEX:936-938): for fixed `L = l`, `∫ α dμ_G → 0` (S1, S5 as in S5). -/
theorem T02_SR1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (l : ℕ) (hE6 : GaussFacts)
    (hL03 : T02_L03Consumed U gU eps l) :
    Tendsto (fun x : E d => ∫ p : E d, accProb U gU eps l x p ∂(gaussMeas d))
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  have hS1 := fun κ hκ => T02_S1 U gU eps l hL03 (1 / 2) (by norm_num) κ hκ
  have h5 := fun κ hκ => T02_S5 U gU eps l hE6 (1 / 2) (by norm_num) (by norm_num) hS1 κ hκ
  rw [tendsto_order]
  refine ⟨fun a ha => Eventually.of_forall fun x => lt_of_lt_of_le ha (J01 U gU eps l hE6 x).1,
    fun a ha => ?_⟩
  · obtain ⟨R, hR⟩ := h5 (a / 2) (by linarith)
    rw [Filter.eventually_comap, Filter.eventually_atTop]
    refine ⟨R + 1, fun b hb x hx => ?_⟩
    have := hR x (by rw [hx]; linarith)
    have h3 := T02_S3 U gU eps l x
    linarith

/-- SR2 (TEX:938-940): dominated convergence on `ℕ`. -/
theorem T02_SR2 {d : ℕ} (Lmeas : Measure ℕ) (hP : IsProbabilityMeasure Lmeas) (f : ℕ → E d → ℝ)
    (h0 : ∀ l x, 0 ≤ f l x) (h1 : ∀ l x, f l x ≤ 1)
    (hlim : ∀ l : ℕ, Lmeas {l} ≠ 0 →
      Tendsto (f l) (comap (fun x : E d => ‖x‖) atTop) (𝓝 0)) :
    Tendsto (fun x : E d => ∫ l : ℕ, f l x ∂Lmeas) (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  have := tendsto_integral_filter_of_dominated_convergence (μ := Lmeas)
    (l := comap (fun x : E d => ‖x‖) atTop) (F := fun x l => f l x) (f := fun _ => (0 : ℝ))
    (fun _ => (1 : ℝ))
    (Eventually.of_forall fun x => (Measurable.of_discrete (f := fun l : ℕ => f l x)).aestronglyMeasurable)
    (Eventually.of_forall fun x => ae_of_all _ fun l => by
      rw [Real.norm_eq_abs, abs_of_nonneg (h0 l x)]; exact h1 l x)
    (integrable_const _)
    (ae_iff_of_countable.2 fun l hl => hlim l hl)
  simpa using this

/-- SR3 (not printed): `r → 1`. -/
theorem T02_SR3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE6 : GaussFacts) (hA1 : A1Law gU eps Lmeas)
    (hlim : Tendsto (fun x : E d => ∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∂Lmeas)
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProbRand U gU eps Lmeas x := by
  have hev := hlim.eventually (Iio_mem_nhds hκ)
  rw [Filter.eventually_comap, Filter.eventually_atTop] at hev
  obtain ⟨R, hR⟩ := hev
  refine ⟨R, fun x hx => ?_⟩
  have := hR ‖x‖ hx.le x rfl
  unfold rejProbRand
  simp only [Set.mem_Iio] at this
  linarith

/-- SR4 (not printed): MH-type form of the random-`L` kernel. -/
theorem T02_SR4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (hA1 : A1Law gU eps Lmeas) (x : E d)
    (A : Set (E d)) (hA : MeasurableSet A) :
    (hmcStepRand U gU eps Lmeas x A).toReal =
      (∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p *
          A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L) ∂(gaussMeas d) ∂Lmeas) +
        rejProbRand U gU eps Lmeas x * A.indicator (fun _ => (1 : ℝ)) x := by
  haveI : IsProbabilityMeasure Lmeas := hA1.1
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  set G : E d → ℝ := A.indicator (fun _ => (1 : ℝ)) with hG
  have hG0 : ∀ y, 0 ≤ G y := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hG1 : ∀ y, G y ≤ 1 := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hg := gU_meas U gU hgrad
  have hI01 : ∀ L : ℕ, 0 ≤ ∫ p : E d, accProb U gU eps L x p * G (xLF gU eps x p L) ∂(gaussMeas d) ∧
      ∫ p : E d, accProb U gU eps L x p * G (xLF gU eps x p L) ∂(gaussMeas d) ≤ 1 := by
    intro L
    refine ⟨integral_nonneg fun p => mul_nonneg (acc_nonneg U gU eps L x p) (hG0 _), ?_⟩
    calc _ ≤ ∫ p : E d, (1 : ℝ) ∂(gaussMeas d) :=
          integral_mono_of_nonneg (ae_of_all _ fun p => mul_nonneg (acc_nonneg U gU eps L x p) (hG0 _))
            (integrable_const _)
            (ae_of_all _ fun p => mul_le_one₀ (acc_le_one U gU eps L x p) (hG0 _) (hG1 _))
      _ = 1 := by simp
  have hbd : ∀ (g : ℕ → ℝ), (∀ L, |g L| ≤ 1) → Integrable g Lmeas := fun g hgb =>
    Integrable.mono' (integrable_const (1 : ℝ)) (Measurable.of_discrete (f := g)).aestronglyMeasurable
      (ae_of_all _ fun L => by rw [Real.norm_eq_abs]; exact hgb L)
  have hkm : Measurable (fun L : ℕ => hmcStep U gU eps L x) := Measurable.of_discrete
  have hfin : ∀ L : ℕ, hmcStep U gU eps L x A < ⊤ := fun L =>
    (step_le_one U gU eps L hE6 hgrad x A hA).trans_lt ENNReal.one_lt_top
  have h1 : (hmcStepRand U gU eps Lmeas x A).toReal =
      ∫ L : ℕ, (hmcStep U gU eps L x A).toReal ∂Lmeas := by
    unfold hmcStepRand
    rw [Measure.bind_apply hA hkm.aemeasurable,
      integral_toReal ((Measurable.of_discrete (f := fun L : ℕ => hmcStep U gU eps L x A)).aemeasurable)
        (ae_of_all _ hfin)]
  have hJ : ∀ L : ℕ, |rejProb U gU eps L x| ≤ 1 := fun L => by
    have := J01 U gU eps L hE6 x
    unfold rejProb
    rw [abs_le]; constructor <;> linarith [this.1, this.2]
  rw [h1]
  simp_rw [T02_S6 U gU eps _ hE6 hgrad x A hA]
  have hi1 : Integrable (fun L : ℕ => ∫ p : E d, accProb U gU eps L x p * G (xLF gU eps x p L)
      ∂(gaussMeas d)) Lmeas :=
    hbd _ fun L => by rw [abs_of_nonneg (hI01 L).1]; exact (hI01 L).2
  have hi2 : Integrable (fun L : ℕ => rejProb U gU eps L x * G x) Lmeas :=
    hbd _ fun L => by
      rw [abs_mul, abs_of_nonneg (hG0 x)]
      exact mul_le_one₀ (hJ L) (hG0 x) (hG1 x)
  have hi3 : Integrable (fun L : ℕ => rejProb U gU eps L x) Lmeas := hbd _ hJ
  rw [integral_add hi1 hi2, integral_mul_const]
  congr 2
  unfold rejProbRand rejProb
  have hJi : Integrable (fun L : ℕ => ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d)) Lmeas :=
    hbd _ fun L => by
      rw [abs_of_nonneg (J01 U gU eps L hE6 x).1]; exact (J01 U gU eps L hE6 x).2
  rw [integral_sub (integrable_const _) hJi]
  simp

/-- SR5 (not printed). -/
theorem T02_SR5 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hd : 0 < d) (hgrad : IsGradField U gU) (hA1 : A1Law gU eps Lmeas)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h3 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProbRand U gU eps Lmeas x)
    (hle : ∀ x : E d, rejProbRand U gU eps Lmeas x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1 :=
  essSup_one_of U gU hd hgrad hπ _ h3 hle

/-- SR5' : `rejProbRand ≤ 1`. -/
theorem T02_SR5' {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hA1 : A1Law gU eps Lmeas) (x : E d) :
    rejProbRand U gU eps Lmeas x ≤ 1 := by
  have h : 0 ≤ ∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∂Lmeas :=
    integral_nonneg fun L => integral_nonneg (acc_nonneg U gU eps L x)
  unfold rejProbRand
  linarith

/-- SR6 (TEX:936): Prop. 3.5 for the random-`L` kernel. -/
theorem T02_SR6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE1 : Prop35Rand) (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps)
    (hA1 : A1Law gU eps Lmeas)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1) :
    ¬ GeomErgodicRand U gU eps Lmeas :=
  hE1 d U gU eps Lmeas hd hgrad hπ heps hA1 hess

/-- Random-`L` claim (TEX:934-940). -/
theorem T02_main_randL {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hL03 : ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → T02_L03Consumed U gU eps l)
    (hE1 : Prop35Rand) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hA1 : A1Law gU eps Lmeas)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU)
    (hosc2 : ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → HypOscillation2 U l) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  have hlim : Tendsto (fun x : E d => ∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∂Lmeas)
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
    refine T02_SR2 Lmeas hA1.1 (fun L x => ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d))
      (fun l x => (J01 U gU eps l hE6 x).1) (fun l x => (J01 U gU eps l hE6 x).2) ?_
    intro l hl
    have hl1 : 1 ≤ l := by
      rcases Nat.eq_zero_or_pos l with h | h
      · exact absurd (h ▸ hA1.2.1) hl
      · exact h
    exact T02_SR1 U gU eps l hE6 (hL03 l hl1 hl)
  exact T02_SR6 U gU eps Lmeas hE1 hd hgrad hπ heps hA1
    (T02_SR5 U gU eps Lmeas hd hgrad hA1 hπ (T02_SR3 U gU eps Lmeas hE6 hA1 hlim)
      (T02_SR5' U gU eps Lmeas hA1))

end Paper.T02

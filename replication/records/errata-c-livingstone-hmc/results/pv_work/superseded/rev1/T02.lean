import T02Stmt
import L03

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-- S1 (TEX:879, "Lemmas lem:xelower and lem:xlower below establish that in this case
`‖x_{Lε}‖ ≥ 2^L‖x_0‖`"): for each `δ < 1`, large `‖x_0‖` and `‖p_0‖ ≤ ‖x_0‖^δ`.  This is part (a) of the
consumed clause (L01 + L02).  Uses `hL02`. -/
theorem T02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (hL02 : T02_L02Consumed gU eps L)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  -- TEX:879: part (a) of the consumed clause (Lemmas xelower/xlower).
  exact hL02.1 δ hδ

/-- S2 (TEX:879, "Lemma lem:arate_0 shows that this will result in `α(x_0,x_{Lε})` tending to zero as
`‖x_0‖ → ∞` provided `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ<1`"): Lemma 5.17 (L03) applied with a fixed `δ < 1`.
Uses `hL02`, (17), (18), (19), L03 main theorem. -/
theorem T02_S2 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : T02_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L)
    (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  -- TEX:879 "Lemma arate_0 shows ...": L03_main (T02_L02Consumed unfolds to L03_L02Consumed).
  exact Paper.L03.L03_main U gU eps L (by unfold T02_L02Consumed at hL02; exact hL02) heps hL hexp
    hosc hosc2 δ hδ

/-- S3 (TEX:879, implicit translation of the limit in S2): uniform form.  For every `κ > 0` there is `R`
with `α(x_0,x_{Lε}) ≤ κ` whenever `‖x_0‖ > R` and `‖p_0‖ ≤ ‖x_0‖^δ`.  Uses S2. -/
theorem T02_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (h : Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → accProb U gU eps L x0 p0 ≤ κ := by
  -- TEX:879 (implicit): unfold the limit along `tailMomFilter`.
  have hev : ∀ᶠ q in tailMomFilter d δ, accProb U gU eps L q.1 q.2 < κ :=
    h.eventually (Iio_mem_nhds hκ)
  rw [tailMomFilter, Filter.eventually_inf_principal, Filter.eventually_comap,
    Filter.eventually_atTop] at hev
  obtain ⟨R, hR⟩ := hev
  refine ⟨R, fun x0 p0 hx hp => ?_⟩
  exact (hR ‖x0‖ hx.le (x0, p0) rfl hp).le

/-- Technical helper: `gU` is measurable (it is the gradient of the differentiable `U`). -/
private lemma gU_meas {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hgrad : IsGradField U gU) :
    Measurable gU := by
  have : gU = gradient U := funext fun x => (hgrad x).gradient.symm
  rw [this]
  unfold gradient
  exact (LinearIsometryEquiv.continuous _).measurable.comp (measurable_fderiv ℝ U)

/-- Technical helper: one leapfrog step is measurable. -/
private lemma step_meas {d : ℕ} (gU : E d → E d) (hg : Measurable gU) (eps : ℝ) :
    Measurable (leapfrogStep gU eps) := by
  unfold leapfrogStep
  fun_prop

/-- Technical helper: the leapfrog trajectory is measurable in `p_0`. -/
private lemma lf_meas {d : ℕ} (gU : E d → E d) (hg : Measurable gU) (eps : ℝ) (x0 : E d) (n : ℕ) :
    Measurable (fun p : E d => leapfrogState gU eps x0 p n) := by
  induction n with
  | zero => exact measurable_const.prodMk measurable_id
  | succ n ih => exact (step_meas gU hg eps).comp ih

/-- Technical helper: the acceptance probability is measurable in `p_0`. -/
private lemma acc_meas {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (hgrad : IsGradField U gU) (eps : ℝ)
    (L : ℕ) (x : E d) : Measurable (fun p : E d => accProb U gU eps L x p) := by
  have hg := gU_meas U gU hgrad
  have hU : Continuous U :=
    continuous_iff_continuousAt.2 fun x => (hgrad x).hasFDerivAt.continuousAt
  have h1 : Measurable (fun p : E d => xLF gU eps x p L) :=
    measurable_fst.comp (lf_meas gU hg eps x L)
  have h2 : Measurable (fun p : E d => pLF gU eps x p L) :=
    measurable_snd.comp (lf_meas gU hg eps x L)
  have hP : Measurable (piDens U) := (by unfold piDens; fun_prop : Continuous (piDens U)).measurable
  unfold accProb
  exact measurable_const.min ((((hP.comp h1).div_const _).mul
    (Real.measurable_exp.comp (by fun_prop))))

/-- Technical helper: `α ≥ 0`. -/
private lemma acc_nonneg {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x p : E d) :
    0 ≤ accProb U gU eps L x p := by
  unfold accProb piDens
  exact le_min zero_le_one (by positivity)

/-- Technical helper: a measurable function with values in `[0,1]` is integrable for a probability measure. -/
private lemma intg01 {d : ℕ} (μ : Measure (E d)) [IsProbabilityMeasure μ] (f : E d → ℝ)
    (hm : Measurable f) (h0 : ∀ p, 0 ≤ f p) (h1 : ∀ p, f p ≤ 1) : Integrable f μ :=
  Integrable.mono' (integrable_const (1 : ℝ)) hm.aestronglyMeasurable
    (ae_of_all _ fun p => by rw [Real.norm_eq_abs, abs_of_nonneg (h0 p)]; exact h1 p)

/-- S4 (TEX:274-279 eqn:mhtype, used implicitly when "allowing Proposition prop:supr to be envoked",
TEX:879): the HMC kernel is of Metropolis-Hastings type, `P(x,A) = ∫ α 1_A(x_{Lε}) dμ^G + r(x) 1_A(x)`
with `r(x) = 1 - ∫ α dμ^G` (`rejProb`).  Derivable from the definitions of `hmcStep`, `rejProb` (and
`GaussFacts` (a)); no external input beyond `hE6`.  Not printed in the source. -/
theorem T02_S4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
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
  have hα1 : ∀ p, accProb U gU eps L x p ≤ 1 := fun p => min_le_left _ _
  have hα0 := acc_nonneg U gU eps L x
  set G : E d → ℝ := A.indicator (fun _ => (1 : ℝ)) with hG
  have hGm : Measurable G := measurable_const.indicator hA
  have hG0 : ∀ y, 0 ≤ G y := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
  have hG1 : ∀ y, G y ≤ 1 := fun y => by by_cases hy : y ∈ A <;> simp [hG, hy]
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
  have h1 : hmcStep U gU eps L x A = ∫⁻ p, ENNReal.ofReal
      (accProb U gU eps L x p * G (xLF gU eps x p L) + (1 - accProb U gU eps L x p) * G x)
      ∂(gaussMeas d) := by
    unfold hmcStep
    rw [Measure.bind_apply hA hκm.aemeasurable]
    refine lintegral_congr fun p => ?_
    show κf p A = _
    rw [hκ A hA p, hGe, hGe, ENNReal.ofReal_add (mul_nonneg (hα0 p) (hG0 _))
      (mul_nonneg (sub_nonneg.2 (hα1 p)) (hG0 _)), ENNReal.ofReal_mul (hα0 p),
      ENNReal.ofReal_mul (sub_nonneg.2 (hα1 p))]
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
  rw [h1, ← ofReal_integral_eq_lintegral_ofReal hsum (ae_of_all _ hnn),
    ENNReal.toReal_ofReal (integral_nonneg hnn), integral_add hu hv, integral_mul_const,
    integral_sub (integrable_const _) (intg01 _ _ hα hα0 hα1)]
  simp [rejProb]

/-- S5 (TEX:879, "To conclude we simply note that `P(‖p_0‖ ≤ ‖x_0‖^δ) → 1` as `‖x_0‖ → ∞`"): the
Gaussian tail fact (E6), here as a consequence of `GaussFacts`.  Uses `hE6`. -/
theorem T02_S5 (hE6 : GaussFacts) (d : ℕ) (δ : ℝ) (hδ : 0 < δ) :
    Tendsto (fun R : ℝ => (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ}) atTop (𝓝 1) := by
  -- TEX:879 "we simply note": E6 (b).
  exact (hE6 d).2 δ hδ

/-- S6 (TEX:879, X1 part 1): `r(x) → 1` as `‖x‖ → ∞`: since `r(x) = 1 - E[α] ≥ 1 - κ - P(‖p_0‖ > ‖x‖^δ)`
(`α ≤ κ` on `‖p_0‖ ≤ ‖x‖^δ` by S3, `α ≤ 1` elsewhere).  Not printed explicitly (INVENTORY X1).
Uses S3, S5, `GaussFacts`. -/
theorem T02_S6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (hgrad : IsGradField U gU) (δ : ℝ) (hδ0 : 0 < δ) (hδ : δ < 1)
    (h : Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x := by
  -- TEX:879: `r = 1 - ∫ α ≥ 1 - κ/2 - P(‖p_0‖ > ‖x‖^δ)`.
  suffices key : ∀ κ : ℝ, 0 < κ → κ ≤ 1 → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x by
    obtain ⟨R, hR⟩ := key (min κ 1) (lt_min hκ one_pos) (min_le_right _ _)
    exact ⟨R, fun x hx => by linarith [min_le_left κ 1, hR x hx]⟩
  clear hκ κ
  intro κ hκ hκ1
  haveI : IsProbabilityMeasure (gaussMeas d) := (hE6 d).1
  have hκ2 : 0 < κ / 2 := by linarith
  obtain ⟨R1, hR1⟩ := T02_S3 U gU eps L δ h (κ / 2) hκ2
  have hT : ∀ᶠ R : ℝ in atTop,
      ENNReal.ofReal (1 - κ / 2) < (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ} :=
    (T02_S5 hE6 d δ hδ0).eventually (lt_mem_nhds (by
      rw [← ENNReal.ofReal_one]
      exact (ENNReal.ofReal_lt_ofReal_iff (by norm_num)).2 (by linarith)))
  obtain ⟨R2, hR2⟩ := Filter.eventually_atTop.1 hT
  refine ⟨max R1 R2, fun x hx => ?_⟩
  have hx1 : R1 < ‖x‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx2 : R2 ≤ ‖x‖ := (le_max_right _ _).trans hx.le
  set S : Set (E d) := {p : E d | ‖p‖ ≤ ‖x‖ ^ δ} with hS
  have hSm : MeasurableSet S := measurableSet_le continuous_norm.measurable measurable_const
  have hμS := hR2 ‖x‖ hx2
  rw [← hS] at hμS
  have hSreal : 1 - κ / 2 < (gaussMeas d).real S := by
    have := (ENNReal.ofReal_lt_iff_lt_toReal (by linarith [hκ2]) (measure_ne_top _ _)).1 hμS
    simpa [Measure.real] using this
  have hint : Integrable (fun p : E d => κ / 2 + Sᶜ.indicator (fun _ => (1 : ℝ)) p)
      (gaussMeas d) :=
    (integrable_const _).add ((integrable_const (1 : ℝ)).indicator hSm.compl)
  have hle : ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ≤
      ∫ p : E d, (κ / 2 + Sᶜ.indicator (fun _ => (1 : ℝ)) p) ∂(gaussMeas d) := by
    apply integral_mono_of_nonneg
    · exact Filter.Eventually.of_forall (fun p => by
        unfold accProb piDens
        exact le_min zero_le_one (by positivity))
    · exact hint
    · refine Filter.Eventually.of_forall (fun p => ?_)
      by_cases hp : p ∈ S
      · have := hR1 x p hx1 hp
        simp [hp]; linarith
      · have h1 : accProb U gU eps L x p ≤ 1 := min_le_left _ _
        simp [hp]; linarith
  have hval : ∫ p : E d, (κ / 2 + Sᶜ.indicator (fun _ => (1 : ℝ)) p) ∂(gaussMeas d) =
      κ / 2 + (1 - (gaussMeas d).real S) := by
    rw [integral_add (integrable_const _) ((integrable_const (1 : ℝ)).indicator hSm.compl),
      integral_const, integral_indicator hSm.compl]
    have hc := measureReal_add_measureReal_compl (μ := gaussMeas d) hSm
    simp at hc ⊢
    linarith
  unfold rejProb
  linarith

/-- Technical helper (domain fact derived from `hgrad`, `hπ`, `0 < d`): `π{‖x‖ > R} ≠ 0`. -/
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

/-- S7 (TEX:879 "allowing Proposition prop:supr", X1 part 2): `esssup r(x) = 1` w.r.t. `π`.  Needs `r ≤ 1`,
S6, and that `π{‖x‖ > R} > 0` for every `R` (positive density, `d ≥ 1`, finite normaliser).  Not printed
in the source. -/
theorem T02_S7 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hd : 0 < d)
    (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h6 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x)
    (hle : ∀ x : E d, rejProb U gU eps L x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 := by
  apply le_antisymm
  · exact essSup_le_of_ae_le _ (Filter.Eventually.of_forall fun x =>
      ENNReal.ofReal_le_one.2 (hle x))
  · by_contra hlt
    push_neg at hlt
    set s := essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) with hs
    have hsne : s ≠ ⊤ := hlt.ne_top
    have s1 : s.toReal < 1 := by
      have := (ENNReal.toReal_lt_toReal hsne ENNReal.one_ne_top).2 hlt
      simpa using this
    have hκ : 0 < (1 - s.toReal) / 2 := by linarith
    obtain ⟨R, hR⟩ := h6 _ hκ
    have hae := ae_le_essSup (μ := targetMeas U)
      (f := fun x : E d => ENNReal.ofReal (rejProb U gU eps L x))
    have hnot : ∀ᵐ x ∂(targetMeas U), x ∉ {x : E d | R < ‖x‖} := hae.mono (fun x hx hxT => by
      have h1 : ENNReal.ofReal (1 - (1 - s.toReal) / 2) ≤ s :=
        (ENNReal.ofReal_le_ofReal (hR x hxT)).trans hx
      have h2 : ENNReal.ofReal (1 - (1 - s.toReal) / 2) ≤ ENNReal.ofReal s.toReal := by
        rw [ENNReal.ofReal_toReal hsne]; exact h1
      rw [ENNReal.ofReal_le_ofReal_iff ENNReal.toReal_nonneg] at h2
      linarith)
    exact tail_ne_zero U gU hd hgrad hπ R (measure_zero_iff_ae_nmem.2 hnot)

/-- S7' (the bound `r(x) ≤ 1` used in S7: `∫ α dμ^G ≥ 0`, as `α ≥ 0`; needs the integral to be taken
of a nonnegative function). -/
theorem T02_S7' {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    rejProb U gU eps L x ≤ 1 := by
  have h : 0 ≤ ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) :=
    integral_nonneg (fun p => by
      unfold accProb piDens
      exact le_min zero_le_one (by positivity))
  unfold rejProb
  linarith

/-- S8 (TEX:879, "allowing Proposition prop:supr to be envoked ... establishing the result"):
`esssup r = 1` and `hE1` give failure of geometric ergodicity.  Uses `hE1`, S7. -/
theorem T02_S8 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE1 : Prop35)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps) (hL : 1 ≤ L)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1) :
    ¬ GeomErgodic U gU eps L := by
  -- TEX:879: Proposition 3.5 (E1) applied to the HMC kernel.
  exact hE1 d U gU eps L hd hgrad hπ heps hL hess

/-- Main theorem, Theorem 5.14 (TEX:863-877): if (17) `‖∇U‖/‖x‖ → ∞`, (18) `‖y‖ ≥ 2‖x‖ ≥ C ⇒
‖∇U(y)‖ ≥ 3‖∇U(x)‖`, (19) `lim (U(x) - U(y) - ‖x‖²/2) = -∞` over `‖x‖ → ∞, ‖y‖ ≥ 2^L‖x‖`, then HMC with
fixed integration time `T = Lε` does not produce a geometrically ergodic chain "for any choice `T>0`"
(here: for every `ε > 0` and every `L ≥ 1`, with the same `L` in (19), N3).
Parameters, in order: `hL02` consumed clause of L02 (provenance (p); `T02_L02Consumed` of `T02Stmt`, same content as
`Paper.L03.L03_L02Consumed`: its part (a) is the sentence "`‖x_{Lε}‖ ≥ 2^L‖x_0‖`" used at TEX:879, both parts are needed by
L03); `hE1` Prop. 3.5 (provenance (i)); `hE6` Gaussian facts (provenance (v)).
Standing conventions made explicit (candidate TFAs, see notes): `0 < d` (TFA-2), `IsGradField U gU`
(`∇U` exists, TEX:320), `∫⁻ e^{-U} < ∞` (`π` a probability density), `ε > 0`, `1 ≤ L` (TFA-1). -/
theorem T02_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : T02_L02Consumed gU eps L) (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L) :
    ¬ GeomErgodic U gU eps L := by
  -- TEX:879: fix `δ = 1/2 < 1`; S2 (Lemma 5.17) gives `α → 0` on the region; S6, S7', S7, S8 conclude.
  have h2 := T02_S2 U gU eps L hL02 heps hL hexp hosc hosc2 (1/2) (by norm_num)
  have h6 := fun κ hκ => T02_S6 U gU eps L hE6 hgrad (1/2) (by norm_num) (by norm_num) h2 κ hκ
  exact T02_S8 U gU eps L hE1 hd hgrad hπ heps hL
    (T02_S7 U gU eps L hd hgrad hπ h6 (T02_S7' U gU eps L))

end Paper.T02

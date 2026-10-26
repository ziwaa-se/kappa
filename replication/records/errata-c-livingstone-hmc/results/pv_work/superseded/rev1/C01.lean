import C01Stmt

/-!
# C01 = Corollary 2.3 (crly:expfam), part (ii) only: proof (rev. 1, session 1)

Source: TEX:804-836.  All obligations are proved along the source route; the passage to random `𝔏`
(TEX:834-836) is not encoded (scope of the statement).
-/

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02
open Paper.T01

namespace Paper.C01

/-! ### Private technical helpers (conversions only) -/

private lemma rpow_sq_aux (r β : ℝ) (hr : 0 < r) : (r ^ 2) ^ (β / 2 - 1) = r ^ (β - 2) := by
  rw [← Real.rpow_natCast, ← Real.rpow_mul hr.le]
  congr 1
  push_cast
  ring

/-- gradient of `k + α‖y‖^β` at `x ≠ 0`, as a vector in `E 1` (technical: differentiation). -/
private lemma grad_vec_aux (β α k M : ℝ) (U : E 1 → ℝ) (g x : E 1)
    (hU : ∀ y : E 1, M < ‖y‖ → U y = k + α * ‖y‖ ^ β)
    (hg : HasGradientAt U g x) (hx : M < ‖x‖) (hx0 : 0 < ‖x‖) :
    g = (α * β * ‖x‖ ^ (β - 2)) • x := by
  have h1 : HasFDerivAt (fun y : E 1 => ‖y‖ ^ 2) (2 • innerSL ℝ x) x :=
    (hasStrictFDerivAt_norm_sq x).hasFDerivAt
  have h2 := h1.rpow_const (p := β / 2) (Or.inl (by positivity))
  have h3 : HasFDerivAt (fun y : E 1 => k + α * ‖y‖ ^ β)
      (α • ((β / 2 * (‖x‖ ^ 2) ^ (β / 2 - 1)) • (2 • innerSL ℝ x))) x := by
    have h2' : HasFDerivAt (fun y : E 1 => ‖y‖ ^ β)
        ((β / 2 * (‖x‖ ^ 2) ^ (β / 2 - 1)) • (2 • innerSL ℝ x)) x := by
      refine h2.congr_of_eventuallyEq (Filter.Eventually.of_forall fun y => ?_)
      simp only
      rw [← Real.rpow_natCast, ← Real.rpow_mul (norm_nonneg _)]
      congr 1
      push_cast
      ring
    exact (h2'.const_mul α).const_add k
  have h4 : HasFDerivAt U (α • ((β / 2 * (‖x‖ ^ 2) ^ (β / 2 - 1)) • (2 • innerSL ℝ x))) x := by
    refine h3.congr_of_eventuallyEq ?_
    have : {y : E 1 | M < ‖y‖} ∈ 𝓝 x := (isOpen_lt continuous_const continuous_norm).mem_nhds hx
    filter_upwards [this] with y hy using hU y hy
  have h5 := HasFDerivAt.unique (show HasFDerivAt U _ x from hg) h4
  have h9 : g = (α * (β / 2 * ‖x‖ ^ (β - 2)) * 2) • x := by
    apply (InnerProductSpace.toDual ℝ (E 1)).injective
    ext y
    have := congrArg (fun T : E 1 →L[ℝ] ℝ => T y) h5
    simp only [rpow_sq_aux _ _ hx0] at this
    simp only [InnerProductSpace.toDual_apply] at this ⊢
    rw [this]
    simp [real_inner_smul_left, innerSL_apply]
    ring
  rw [h9]
  congr 1
  ring

/-- From `InExpFam` (TEX:223-226): `U = k + α‖y‖^β` outside a ball (`π = c e^{-α|x|^β}`). -/
private lemma expfam_U (β α : ℝ) (U : E 1 → ℝ) (hU : InExpFam β α U) :
    ∃ k M : ℝ, 0 ≤ M ∧ ∀ y : E 1, M < ‖y‖ → U y = k + α * ‖y‖ ^ β := by
  obtain ⟨hα, hβ, -, M, c, hc, hform⟩ := hU
  refine ⟨-Real.log c, max M 0, le_max_right _ _, fun y hy => ?_⟩
  have h := congrArg Real.log (hform y (lt_of_le_of_lt (le_max_left _ _) hy))
  rw [piDens, Real.log_exp, Real.log_mul hc.ne' (Real.exp_pos _).ne', Real.log_exp] at h
  linarith

private lemma expfam_grad (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) :
    ∃ k M : ℝ, 0 ≤ M ∧ (∀ y : E 1, M < ‖y‖ → U y = k + α * ‖y‖ ^ β) ∧
      ∀ x : E 1, M < ‖x‖ → gU x = (α * β * ‖x‖ ^ (β - 2)) • x := by
  obtain ⟨k, M, hM, hk⟩ := expfam_U β α U hU
  exact ⟨k, M, hM, hk, fun x hx => grad_vec_aux β α k M U (gU x) x hk (hgrad x) hx
    (lt_of_le_of_lt hM hx)⟩

private lemma norm1 (x : E 1) : ‖x‖ = |x 0| := by
  simp [EuclideanSpace.norm_eq, Real.sqrt_sq_eq_abs]

private lemma nz_of_pos (x : E 1) (hx0 : 0 < ‖x‖) : x 0 ≠ 0 := by
  intro h
  have : ‖x‖ = 0 := by rw [norm1 x, h]; simp
  linarith

/-- `‖∇U(x)‖ = αβ‖x‖^{β-1}` in the tail, from the vector formula. -/
private lemma tail_norm_of_vec (β α M : ℝ) (hα : 0 < α) (hβ : 0 < β) (hM : 0 ≤ M) (gU : E 1 → E 1)
    (hg : ∀ x : E 1, M < ‖x‖ → gU x = (α * β * ‖x‖ ^ (β - 2)) • x) :
    ∀ x : E 1, M < ‖x‖ → ‖gU x‖ = α * β * ‖x‖ ^ (β - 1) := by
  intro x hx
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt hM hx
  rw [hg x hx, norm_smul, Real.norm_eq_abs,
    abs_of_pos (mul_pos (mul_pos hα hβ) (Real.rpow_pos_of_pos hx0 _)),
    show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one hx0.ne']
  ring

/-- `‖∇U(x)‖ = αβ‖x‖^{β-1}` in the tail from `TailGrad`. -/
private lemma tail_norm_of_tg (β α M : ℝ) (hα : 0 < α) (hβ : 0 < β) {gU : E 1 → E 1}
    (hG : TailGrad β α M gU) :
    ∀ x : E 1, max M 0 < ‖x‖ → ‖gU x‖ = α * β * ‖x‖ ^ (β - 1) := by
  intro x hx
  have hxM : M < ‖x‖ := lt_of_le_of_lt (le_max_left _ _) hx
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt (le_max_right _ _) hx
  have hn := norm1 x
  have hxz : x 0 ≠ 0 := nz_of_pos x hx0
  rw [norm1 (gU x), hG x hxM, abs_mul, abs_mul, abs_of_pos (mul_pos hα hβ),
    abs_of_pos (Real.rpow_pos_of_pos (abs_pos.2 hxz) _), ← hn]
  have : |Real.sign (x 0)| = 1 := by
    rcases lt_or_gt_of_ne hxz with h | h
    · rw [Real.sign_of_neg h]; simp
    · rw [Real.sign_of_pos h]; simp
  rw [this]
  ring

/-- finiteness of the normalising constant, derived from `InExpFam` (needed since S1b has no `hπ`). -/
private lemma expfam_fin {β α : ℝ} {U : E 1 → ℝ} (hE : InExpFam β α U) :
    (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤ := by
  obtain ⟨hα, hβ, hpi, M, c, hc, hform⟩ := hE
  -- (1+r)^2 e^{-α r^β} is eventually ≤ 4
  have hT : Tendsto (fun r : ℝ => (r ^ β) ^ (2 / β) * Real.exp (-α * (r ^ β))) atTop (𝓝 0) :=
    (tendsto_rpow_mul_exp_neg_mul_atTop_nhds_zero (2 / β) α hα).comp (tendsto_rpow_atTop hβ)
  have hT' : Tendsto (fun r : ℝ => r ^ 2 * Real.exp (-α * (r ^ β))) atTop (𝓝 0) := by
    refine hT.congr' ?_
    filter_upwards [eventually_ge_atTop (0 : ℝ)] with r hr
    rw [← Real.rpow_mul hr, mul_div_cancel₀ _ hβ.ne', Real.rpow_two]
  obtain ⟨R1, hR1⟩ := eventually_atTop.1 ((tendsto_order.1 hT').2 1 one_pos)
  set R2 := max (max M 0) (max R1 1) with hR2
  have hcont : Continuous (fun x : E 1 => piDens U x * (1 + ‖x‖) ^ 2) := by
    have := hpi.continuous
    fun_prop
  obtain ⟨B, hB⟩ := (isCompact_closedBall (0 : E 1) R2).exists_bound_of_continuousOn
    hcont.continuousOn
  have hK : ∀ x : E 1, piDens U x * (1 + ‖x‖) ^ 2 ≤ max B (4 * c) := by
    intro x
    by_cases hx : R2 < ‖x‖
    · have hxM : M < ‖x‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
      have hxR1 : R1 ≤ ‖x‖ := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hx.le
      have hx1 : 1 ≤ ‖x‖ := le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hx.le
      have h1 := hR1 ‖x‖ hxR1
      rw [hform x hxM]
      have h2 : (1 + ‖x‖) ^ 2 ≤ 4 * ‖x‖ ^ 2 := by nlinarith
      have h3 := Real.exp_pos (-α * ‖x‖ ^ β)
      refine le_trans ?_ (le_max_right _ _)
      calc c * Real.exp (-α * ‖x‖ ^ β) * (1 + ‖x‖) ^ 2
          ≤ c * Real.exp (-α * ‖x‖ ^ β) * (4 * ‖x‖ ^ 2) :=
            mul_le_mul_of_nonneg_left h2 (by positivity)
        _ = 4 * c * (‖x‖ ^ 2 * Real.exp (-α * ‖x‖ ^ β)) := by ring
        _ ≤ 4 * c * 1 := mul_le_mul_of_nonneg_left h1.le (by positivity)
        _ = 4 * c := by ring
    · have := hB x (mem_closedBall_zero_iff.2 (not_lt.1 hx))
      rw [Real.norm_eq_abs] at this
      exact le_trans (le_trans (le_abs_self _) this) (le_max_left _ _)
  have hbd : ∀ x : E 1, ENNReal.ofReal (piDens U x) ≤
      ENNReal.ofReal (max B (4 * c)) * ENNReal.ofReal ((1 + ‖x‖) ^ (-(2 : ℝ))) := by
    intro x
    rw [← ENNReal.ofReal_mul (le_trans (by positivity : 0 ≤ 4 * c) (le_max_right _ _))]
    apply ENNReal.ofReal_le_ofReal
    have hp : 0 < (1 + ‖x‖) := by positivity
    rw [Real.rpow_neg hp.le, Real.rpow_two]
    rw [← div_eq_mul_inv, le_div_iff₀ (by positivity)]
    exact hK x
  have hfin := finite_integral_one_add_norm (E := E 1) (μ := volume) (r := 2) (by simp)
  calc (∫⁻ x : E 1, ENNReal.ofReal (piDens U x))
      ≤ ∫⁻ x : E 1, ENNReal.ofReal (max B (4 * c)) * ENNReal.ofReal ((1 + ‖x‖) ^ (-(2 : ℝ))) :=
        lintegral_mono hbd
    _ = ENNReal.ofReal (max B (4 * c)) * ∫⁻ x : E 1, ENNReal.ofReal ((1 + ‖x‖) ^ (-(2 : ℝ))) :=
        lintegral_const_mul' _ _ ENNReal.ofReal_ne_top
    _ < ⊤ := ENNReal.mul_lt_top ENNReal.ofReal_lt_top hfin

/-! ### Step obligations -/

/-- S2 (TEX:807-810): tail gradient formula. -/
theorem C01_S2 {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1}
    (hE : InExpFam β α U) (hgrad : IsGradField U gU) :
    ∃ M : ℝ, TailGrad β α M gU := by
  obtain ⟨k, M, hM, -, hg⟩ := expfam_grad β α U gU hE hgrad
  refine ⟨M, fun x hx => ?_⟩
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt hM hx
  have hn := norm1 x
  have hxz : x 0 ≠ 0 := nz_of_pos x hx0
  have e : Real.sign (x 0) * |x 0| = x 0 := by
    rcases lt_or_gt_of_ne hxz with h | h
    · rw [Real.sign_of_neg h, abs_of_neg h]; ring
    · rw [Real.sign_of_pos h, abs_of_pos h]; ring
  have hxr : |x 0| ^ (β - 1) = |x 0| ^ (β - 2) * |x 0| := by
    rw [show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one (abs_ne_zero.2 hxz)]
  rw [hg x hx, hxr, hn]
  simp only [PiLp.smul_apply, smul_eq_mul]
  linear_combination (α * β * |x 0| ^ (β - 2)) * e.symm

/-- S1a (TEX:806): `‖∇U‖ ≤ M'` on all of `X` for `β < 1` (first hypothesis of Thm 2.2(ii)).
Implicit calculus: continuity of `∇U = -π'/π` (π ∈ C¹, π > 0) on the compact part, and the tail formula. -/
theorem C01_S1a {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1}
    (hE : InExpFam β α U) (hgrad : IsGradField U gU) (hβ : β < 1) :
    ∃ M : ℝ, ∀ x : E 1, ‖gU x‖ ≤ M := by
  obtain ⟨k, M, hM, -, hg⟩ := expfam_grad β α U gU hE hgrad
  have hg' := tail_norm_of_vec β α M hE.1 hE.2.1 hM gU hg
  have hpi : ContDiff ℝ 1 (piDens U) := hE.2.2.1
  have hU1 : ContDiff ℝ 1 U := by
    have : ContDiff ℝ 1 (fun x => -Real.log (piDens U x)) :=
      (hpi.log (fun x => (Real.exp_pos _).ne')).neg
    convert this using 1
    funext x
    simp [piDens]
  have hcont : Continuous gU := by
    have : gU = fun x => (InnerProductSpace.toDual ℝ (E 1)).symm (fderiv ℝ U x) := by
      funext x
      exact ((hgrad x).gradient).symm
    rw [this]
    exact (InnerProductSpace.toDual ℝ (E 1)).symm.continuous.comp (hU1.continuous_fderiv le_rfl)
  obtain ⟨C, hC⟩ := (isCompact_closedBall (0 : E 1) (max M 1)).exists_bound_of_continuousOn
    hcont.continuousOn
  refine ⟨max C (α * β), fun x => ?_⟩
  by_cases hx : max M 1 < ‖x‖
  · have hx1 : 1 ≤ ‖x‖ := le_trans (le_max_right _ _) hx.le
    rw [hg' x (lt_of_le_of_lt (le_max_left _ _) hx)]
    refine le_trans ?_ (le_max_right _ _)
    have : ‖x‖ ^ (β - 1) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos hx1 (by linarith)
    have hαβ : 0 < α * β := mul_pos hE.1 hE.2.1
    nlinarith
  · exact le_trans (hC x (by simpa using not_lt.1 hx)) (le_max_left _ _)

/-- S1b (TEX:806): for `β<1`, `E_π[e^{s‖x‖}] = ∞` for every `s>0`. -/
theorem C01_S1b {β α : ℝ} {U : E 1 → ℝ}
    (hE : InExpFam β α U) (hβ : β < 1) :
    ∀ s : ℝ, 0 < s →
      (∫⁻ x : E 1, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) = ⊤ := by
  have hπ := expfam_fin hE
  intro s hs
  obtain ⟨hα, hβ0, hpi, M, c, hc, hform⟩ := hE
  have hpic : Continuous (piDens U) := hpi.continuous
  have hfm : Measurable (fun x : E 1 => ENNReal.ofReal (piDens U x)) :=
    hpic.measurable.ennreal_ofReal
  have hgm : Measurable (fun x : E 1 => ENNReal.ofReal (Real.exp (s * ‖x‖))) :=
    (by fun_prop : Continuous (fun x : E 1 => Real.exp (s * ‖x‖))).measurable.ennreal_ofReal
  have hlim : Tendsto (fun r : ℝ => r ^ (-(1 - β))) atTop (𝓝 0) :=
    tendsto_rpow_neg_atTop (by linarith)
  obtain ⟨R1, hR1⟩ := eventually_atTop.1 ((tendsto_order.1 hlim).2 (s / α) (by positivity))
  set R := max (max M 0) R1 with hR
  have hbound : ∀ x : E 1, R < ‖x‖ →
      ENNReal.ofReal c ≤ ENNReal.ofReal (piDens U x) * ENNReal.ofReal (Real.exp (s * ‖x‖)) := by
    intro x hx
    have hxM : M < ‖x‖ := lt_of_le_of_lt (le_trans (le_max_left _ _) (le_max_left _ _)) hx
    have hx0 : 0 < ‖x‖ := lt_of_le_of_lt (le_trans (le_max_right _ _) (le_max_left _ _)) hx
    have hxR : R1 ≤ ‖x‖ := (le_max_right _ _).trans hx.le
    have h1 := hR1 ‖x‖ hxR
    have h2 : α * ‖x‖ ^ β ≤ s * ‖x‖ := by
      have h3 : ‖x‖ ^ (-(1 - β)) = ‖x‖ ^ β / ‖x‖ := by
        rw [show -(1 - β) = β - 1 by ring, Real.rpow_sub_one hx0.ne']
      rw [h3, lt_div_iff₀ hα, div_mul_eq_mul_div, div_lt_iff₀ hx0] at h1
      nlinarith
    rw [← ENNReal.ofReal_mul (by simpa [piDens] using (Real.exp_pos _).le), hform x hxM]
    apply ENNReal.ofReal_le_ofReal
    have : c ≤ c * Real.exp (-α * ‖x‖ ^ β) * Real.exp (s * ‖x‖) := by
      rw [mul_assoc, ← Real.exp_add]
      have : 0 ≤ -α * ‖x‖ ^ β + s * ‖x‖ := by nlinarith
      nlinarith [Real.one_le_exp this]
    exact this
  have hvol : volume {x : E 1 | R < ‖x‖} = ⊤ := by
    have hcl : MeasurableSet (Metric.closedBall (0 : E 1) R) := measurableSet_closedBall
    have h := measure_add_measure_compl hcl (μ := volume)
    rw [measure_univ_of_isAddLeftInvariant (volume : Measure (E 1))] at h
    have hfin : volume (Metric.closedBall (0 : E 1) R) < ⊤ := measure_closedBall_lt_top
    have hc2 : (Metric.closedBall (0 : E 1) R)ᶜ = {x : E 1 | R < ‖x‖} := by
      ext x; simp [not_le]
    rw [hc2] at h
    exact (ENNReal.add_eq_top.1 h).resolve_left hfin.ne
  have hA : MeasurableSet {x : E 1 | R < ‖x‖} := measurableSet_lt measurable_const measurable_norm
  have hZ : (∫⁻ x : E 1, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(volume.withDensity
      (fun x : E 1 => ENNReal.ofReal (piDens U x)))) = ⊤ := by
    rw [lintegral_withDensity_eq_lintegral_mul₀ hfm.aemeasurable hgm.aemeasurable]
    rw [eq_top_iff]
    calc (⊤ : ENNReal) = ENNReal.ofReal c * volume {x : E 1 | R < ‖x‖} := by
          rw [hvol, ENNReal.mul_top (by simpa using hc)]
      _ = ∫⁻ x, {x : E 1 | R < ‖x‖}.indicator (fun _ => ENNReal.ofReal c) x := by
          rw [lintegral_indicator_const hA]
      _ ≤ _ := by
          apply lintegral_mono
          intro x
          by_cases hx : R < ‖x‖
          · simp only [Set.indicator_of_mem (show x ∈ {x : E 1 | R < ‖x‖} from hx)]
            exact hbound x hx
          · simp [Set.indicator_of_not_mem (show x ∉ {x : E 1 | R < ‖x‖} from hx)]
  unfold targetMeas
  rw [lintegral_smul_measure, hZ, smul_eq_mul, ENNReal.mul_top]
  exact ENNReal.inv_ne_zero.2 hπ.ne

/-- S1c (TEX:806): `β<1`, Thm 2.2(ii) (consumed clause (b)) applied with S1a, S1b. -/
theorem C01_S1c {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (hβ : β < 1) :
    ¬ GeomErgodic U gU eps L :=
  hT01.2 U gU eps L hgrad hπ heps hL ⟨C01_S1a hE hgrad hβ, C01_S1b hE hβ⟩

/-- S3 (TEX:811-816): (17) for `β>2`. -/
theorem C01_S3 {β α M : ℝ} {gU : E 1 → E 1}
    (hα : 0 < α) (hβ : 2 < β) (hG : TailGrad β α M gU) :
    HypExplode gU := by
  have hαβ : 0 < α * β := mul_pos hα (by linarith)
  have h1 : Tendsto (fun r : ℝ => α * β * r ^ (β - 2)) atTop atTop :=
    (tendsto_rpow_atTop (by linarith)).const_mul_atTop hαβ
  have h2 : Tendsto (fun x : E 1 => α * β * ‖x‖ ^ (β - 2)) (comap (fun x : E 1 => ‖x‖) atTop) atTop :=
    h1.comp tendsto_comap
  refine h2.congr' ?_
  filter_upwards [tendsto_comap.eventually (eventually_gt_atTop (max M 0))] with x hx
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt (le_max_right _ _) hx
  rw [tail_norm_of_tg β α M hα (by linarith) hG x hx, mul_div_assoc]
  congr 1
  rw [show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one hx0.ne']
  field_simp

/-- S4 (TEX:817-824): (18), revised form, for `β>2`. -/
theorem C01_S4 {β α M : ℝ} {gU : E 1 → E 1}
    (hα : 0 < α) (hβ : 2 < β) (hG : TailGrad β α M gU) :
    HypOscillations3 gU := by
  refine ⟨3 * max M 0 + 1, fun x y hxy hC => ?_⟩
  have hxM : max M 0 < ‖x‖ := by linarith
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt (le_max_right _ _) hxM
  have hyM : max M 0 < ‖y‖ := by
    have := le_max_right M 0
    linarith
  rw [tail_norm_of_tg β α M hα (by linarith) hG x hxM,
    tail_norm_of_tg β α M hα (by linarith) hG y hyM]
  have hαβ : 0 < α * β := mul_pos hα (by linarith)
  have h1 : (3 * ‖x‖) ^ (β - 1) ≤ ‖y‖ ^ (β - 1) :=
    Real.rpow_le_rpow (by positivity) hxy (by linarith)
  rw [Real.mul_rpow (by norm_num) hx0.le] at h1
  have h2 : (3 : ℝ) ^ (1 : ℝ) ≤ 3 ^ (β - 1) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  rw [Real.rpow_one] at h2
  have h3 : 0 < ‖x‖ ^ (β - 1) := Real.rpow_pos_of_pos hx0 _
  have h4 : 3 * ‖x‖ ^ (β - 1) ≤ 3 ^ (β - 1) * ‖x‖ ^ (β - 1) := mul_le_mul_of_nonneg_right h2 h3.le
  nlinarith [mul_le_mul_of_nonneg_left (h4.trans h1) hαβ.le]

/-- S5a (TEX:825-833). -/
theorem C01_S5a {β α : ℝ} {U : E 1 → ℝ} (hE : InExpFam β α U) (hβ : 2 < β) (L : ℕ) (hL : 1 ≤ L) :
    ∃ R : ℝ, ∀ x y : E 1, R < ‖x‖ → (2 : ℝ) ^ L * ‖x‖ ≤ ‖y‖ →
      U x - U y - (1 / 2) * ‖x‖ ^ 2 ≤
        -α * (((2 : ℝ) ^ L) ^ β - 1) * ‖x‖ ^ β - (1 / 2) * ‖x‖ ^ 2 := by
  obtain ⟨k, M, hM, hk⟩ := expfam_U β α U hE
  refine ⟨M, fun x y hx hxy => ?_⟩
  have hx0 : 0 ≤ ‖x‖ := norm_nonneg _
  have h2L : (1 : ℝ) ≤ 2 ^ L := one_le_pow₀ (by norm_num)
  have hy : M < ‖y‖ := by nlinarith
  rw [hk x hx, hk y hy]
  have h4 : ((2 : ℝ) ^ L * ‖x‖) ^ β ≤ ‖y‖ ^ β := Real.rpow_le_rpow (by positivity) hxy (by linarith)
  rw [Real.mul_rpow (by positivity) hx0] at h4
  have := mul_le_mul_of_nonneg_left h4 hE.1.le
  nlinarith

/-- S5b (TEX:832-834): (19) for each fixed `L`. -/
theorem C01_S5b {β α : ℝ} {U : E 1 → ℝ} (hE : InExpFam β α U) (hβ : 2 < β) (L : ℕ) (hL : 1 ≤ L) :
    HypOscillation2 U L := by
  obtain ⟨R, hR⟩ := C01_S5a hE hβ L hL
  have hα := hE.1
  have h2L : (2 : ℝ) ≤ 2 ^ L :=
    calc (2:ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ L := pow_le_pow_right₀ (by norm_num) hL
  have hκ : 0 < α * (((2 : ℝ) ^ L) ^ β - 1) := by
    apply mul_pos hα
    have : (1:ℝ) < ((2 : ℝ) ^ L) ^ β := Real.one_lt_rpow (by linarith) (by linarith)
    linarith
  have h1 : Tendsto (fun q : E 1 × E 1 => -(α * (((2 : ℝ) ^ L) ^ β - 1)) * ‖q.1‖ ^ β)
      (comap (fun q : E 1 × E 1 => ‖q.1‖) atTop ⊓
        𝓟 {q : E 1 × E 1 | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}) atBot := by
    have h0 : Tendsto (fun r : ℝ => -(α * (((2 : ℝ) ^ L) ^ β - 1)) * r ^ β) atTop atBot :=
      (tendsto_rpow_atTop (by linarith)).const_mul_atTop_of_neg (by linarith)
    exact h0.comp (tendsto_comap.mono_left inf_le_left)
  refine tendsto_atBot_mono' _ ?_ h1
  have hev : ∀ᶠ q : E 1 × E 1 in (comap (fun q : E 1 × E 1 => ‖q.1‖) atTop ⊓
        𝓟 {q : E 1 × E 1 | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}), R < ‖q.1‖ ∧ (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖ := by
    apply Filter.Eventually.and
    · exact (tendsto_comap.mono_left inf_le_left).eventually (eventually_gt_atTop R)
    · exact Filter.mem_inf_of_right (Filter.mem_principal_self _)
  filter_upwards [hev] with q ⟨h1, h2⟩
  have := hR q.1 q.2 h1 h2
  have h5 : 0 ≤ ‖q.1‖ ^ 2 := by positivity
  nlinarith

/-- S6 (TEX:834): thm:light for fixed `L` (consumed clause (a)) with S3, S4, S5b. -/
theorem C01_S6 {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (hβ : 2 < β) :
    ¬ GeomErgodic U gU eps L := by
  obtain ⟨M, hM⟩ := C01_S2 hE hgrad
  exact hT01.1 U gU eps L hgrad hπ heps hL (C01_S3 hE.1 hβ hM) (C01_S4 hE.1 hβ hM)
    (C01_S5b hE hβ L hL)

/-- Main theorem, Corollary 2.3 part (ii) (TEX:806, 834). -/
theorem C01_main {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    C01Concl β U gU eps L := by
  refine ⟨fun hβ => ?_⟩
  rcases hβ with hβ | hβ
  · exact C01_S1c hT01 hE hgrad hπ heps hL hβ
  · exact C01_S6 hT01 hE hgrad hπ heps hL hβ

end Paper.C01

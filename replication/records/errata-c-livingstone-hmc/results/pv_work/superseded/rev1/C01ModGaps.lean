import C01Stmt
import T01

/-!
# C01 = Corollary 2.3 (crly:expfam), part (ii) only: proof modulo gaps (session 1)

Source: TEX:804-806.  S2 is stopped (gate: false as stated for `2 < β < log₂ 6`): it is the def
`C01_S2_Gap`; the main theorem is `C01_main_mod_gaps` with the premise `hGap_2`.
-/

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02
open Paper.T01

namespace Paper.C01

private lemma rpow_sq_aux (r β : ℝ) (hr : 0 < r) : (r ^ 2) ^ (β / 2 - 1) = r ^ (β - 2) := by
  rw [← Real.rpow_natCast, ← Real.rpow_mul hr.le]
  congr 1
  push_cast
  ring

private lemma grad_norm_aux (β α k M : ℝ) (U : E 1 → ℝ) (g x : E 1)
    (hU : ∀ y : E 1, M < ‖y‖ → U y = k + α * ‖y‖ ^ β)
    (hg : HasGradientAt U g x) (hx : M < ‖x‖) (hx0 : 0 < ‖x‖) :
    ‖g‖ = |α * β| * ‖x‖ ^ (β - 1) := by
  have h1 : HasFDerivAt (fun y : E 1 => ‖y‖ ^ 2) (2 • innerSL ℝ x) x :=
    (hasStrictFDerivAt_norm_sq x).hasFDerivAt
  have h2 := h1.rpow_const (p := β / 2) (Or.inl (by positivity))
  have h3 : HasFDerivAt (fun y : E 1 => k + α * ‖y‖ ^ β)
      (α • ((β / 2 * (‖x‖ ^ 2) ^ (β / 2 - 1)) • (2 • innerSL ℝ x))) x := by
    have h2' : HasFDerivAt (fun y : E 1 => ‖y‖ ^ β) ((β / 2 * (‖x‖ ^ 2) ^ (β / 2 - 1)) • (2 • innerSL ℝ x)) x := by
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
  have hxr : ‖x‖ ^ (β - 1) = ‖x‖ ^ (β - 2) * ‖x‖ := by
    rw [show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one hx0.ne']
  rw [h9, norm_smul, hxr, Real.norm_eq_abs, abs_mul, abs_mul, abs_mul,
    abs_of_pos (Real.rpow_pos_of_pos hx0 _)]
  rw [abs_div, abs_mul]
  norm_num
  ring

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
      ∀ x : E 1, M < ‖x‖ → ‖gU x‖ = α * β * ‖x‖ ^ (β - 1) := by
  obtain ⟨k, M, hM, hk⟩ := expfam_U β α U hU
  refine ⟨k, M, hM, hk, fun x hx => ?_⟩
  have h := grad_norm_aux β α k M U (gU x) x hk (hgrad x) hx (lt_of_le_of_lt hM hx)
  rw [h, abs_of_pos (mul_pos hU.1 hU.2.1)]

theorem C01_S1 (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : 2 < β) : HypExplode gU := by
  obtain ⟨k, M, hM, -, hg⟩ := expfam_grad β α U gU hU hgrad
  have hαβ : 0 < α * β := mul_pos hU.1 hU.2.1
  have h1 : Tendsto (fun r : ℝ => α * β * r ^ (β - 2)) atTop atTop :=
    (tendsto_rpow_atTop (by linarith)).const_mul_atTop hαβ
  have h2 : Tendsto (fun x : E 1 => α * β * ‖x‖ ^ (β - 2)) (comap (fun x : E 1 => ‖x‖) atTop) atTop :=
    h1.comp tendsto_comap
  refine h2.congr' ?_
  filter_upwards [tendsto_comap.eventually (eventually_gt_atTop M)] with x hx
  have hx0 : 0 < ‖x‖ := lt_of_le_of_lt hM hx
  rw [hg x hx, mul_div_assoc]
  congr 1
  rw [show β - 1 = (β - 2) + 1 by ring, Real.rpow_add_one hx0.ne']
  field_simp

/-- S2 stopped: the full ∀-closure of the type of `C01_S2` in `C01.lean`
(false as stated for `2 < β < log₂ 6`, gate ruling; not proved, not altered). -/
def C01_S2_Gap : Prop :=
  ∀ (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1), InExpFam β α U →
    IsGradField U gU → 2 < β → HypOscillations gU

theorem C01_S3 (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (L : ℕ) (hU : InExpFam β α U)
    (hL : 1 ≤ L) (hβ : 2 < β) : HypOscillation2 U L := by
  obtain ⟨k, M, hM, hk⟩ := expfam_U β α U hU
  have hα := hU.1
  have hκ : 0 < α * (2 ^ β - 1) := by
    apply mul_pos hα
    have : (1:ℝ) < 2 ^ β := Real.one_lt_rpow (by norm_num) (by linarith)
    linarith
  have h1 : Tendsto (fun q : E 1 × E 1 => -(α * (2 ^ β - 1)) * ‖q.1‖ ^ β)
      (comap (fun q : E 1 × E 1 => ‖q.1‖) atTop ⊓
        𝓟 {q : E 1 × E 1 | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}) atBot := by
    have h0 : Tendsto (fun r : ℝ => -(α * (2 ^ β - 1)) * r ^ β) atTop atBot :=
      (tendsto_rpow_atTop (by linarith)).const_mul_atTop_of_neg (by linarith)
    exact h0.comp (tendsto_comap.mono_left inf_le_left)
  refine tendsto_atBot_mono' _ ?_ h1
  have hev : ∀ᶠ q : E 1 × E 1 in (comap (fun q : E 1 × E 1 => ‖q.1‖) atTop ⊓
        𝓟 {q : E 1 × E 1 | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖}), M < ‖q.1‖ ∧ (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖ := by
    apply Filter.Eventually.and
    · exact (tendsto_comap.mono_left inf_le_left).eventually (eventually_gt_atTop M)
    · exact Filter.mem_inf_of_right (Filter.mem_principal_self _)
  filter_upwards [hev] with q ⟨h1, h2⟩
  have hr0 : 0 ≤ ‖q.1‖ := norm_nonneg _
  have h2' : 2 * ‖q.1‖ ≤ ‖q.2‖ := by
    have : (2:ℝ) ≤ 2 ^ L := by
      calc (2:ℝ) = 2 ^ 1 := by norm_num
        _ ≤ 2 ^ L := pow_le_pow_right₀ (by norm_num) hL
    nlinarith
  have h3 : M < ‖q.2‖ := by nlinarith
  rw [hk _ h1, hk _ h3]
  have h4 : (2 * ‖q.1‖) ^ β ≤ ‖q.2‖ ^ β := Real.rpow_le_rpow (by positivity) h2' (by linarith)
  rw [Real.mul_rpow (by norm_num) hr0] at h4
  have h5 : 0 ≤ ‖q.1‖ ^ 2 := by positivity
  nlinarith [mul_le_mul_of_nonneg_left h4 hα.le]

theorem C01_S4 (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (hU : InExpFam β α U)
    (hgrad : IsGradField U gU) (hβ : β < 1) : ∃ M : ℝ, ∀ x : E 1, ‖gU x‖ ≤ M := by
  obtain ⟨k, M, hM, -, hg⟩ := expfam_grad β α U gU hU hgrad
  have hpi : ContDiff ℝ 1 (piDens U) := hU.2.2.1
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
    rw [hg x (lt_of_le_of_lt (le_max_left _ _) hx)]
    refine le_trans ?_ (le_max_right _ _)
    have : ‖x‖ ^ (β - 1) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos hx1 (by linarith)
    have hαβ : 0 < α * β := mul_pos hU.1 hU.2.1
    nlinarith
  · exact le_trans (hC x (by simpa using not_lt.1 hx)) (le_max_left _ _)

theorem C01_S5 (β α : ℝ) (U : E 1 → ℝ) (hU : InExpFam β α U)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤) (hβ : β < 1) :
    ∀ s : ℝ, 0 < s → (∫⁻ x : E 1, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) = ⊤ := by
  intro s hs
  obtain ⟨hα, hβ0, hpi, M, c, hc, hform⟩ := hU
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

/-- Main theorem modulo the gap `C01_S2_Gap` (gap-dependent: uses `hGap_2` in place of `C01_S2`). -/
theorem C01_main_mod_gaps (hGap_2 : C01_S2_Gap)
    (β α : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ)
    (hL02 : HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L)
    (hE1 : Prop35) (hE6 : GaussFacts) (hE3 : Thm518)
    (hU : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    C01Concl β U gU eps L := by
  refine ⟨fun hβ => ?_⟩
  have hT := T01_main U gU eps L hL02 hE1 hE6 hE3 (by norm_num) hgrad hπ heps hL
  rcases hβ with hβ | hβ
  · exact hT.partII ⟨C01_S4 β α U gU hU hgrad hβ, C01_S5 β α U hU hπ hβ⟩
  · exact hT.partI ⟨C01_S1 β α U gU hU hgrad hβ, hGap_2 β α U gU hU hgrad hβ,
      C01_S3 β α U gU L hU hL hβ⟩

end Paper.C01

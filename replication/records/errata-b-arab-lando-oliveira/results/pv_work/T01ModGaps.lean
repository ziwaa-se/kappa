import T01Stmt

namespace Paper.T01

open MeasureTheory ProbabilityTheory
open Paper.L01

/-- Gap for S0 (F:180 "As every function considered is increasing"; false as stated). -/
def T01_S0_Gap : Prop :=
  ∀ (h : ℝ → ℝ), Continuous h → StarShaped h → MonotoneOn h (Set.Ici 0)

/-- technical: `F μ = μ.real (Iic ·)`. -/
private lemma F_eq (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) :
    F μ x = μ.real (Set.Iic x) := by
  unfold F; exact cdf_eq_real μ x

/-- technical: no mass on `(-∞,0]` from `F μ 0 = 0`. -/
private lemma real_Iic_zero (μ : Measure ℝ) [IsProbabilityMeasure μ] (hX : IsInvSub μ) :
    μ.real (Set.Iic 0) = 0 := by
  have := hX.1; rwa [F_eq] at this

/-- technical: the sublevel set of a star-shaped function is downward closed in `[0,∞)`
(star-shapedness F:111). -/
private lemma sub_down (h : ℝ → ℝ) (hs : StarShaped h) (x : ℝ) (hx : 0 ≤ x) {y z : ℝ}
    (hy : 0 ≤ y) (hyz : y ≤ z) (hz : h z ≤ x) : h y ≤ x := by
  rcases hy.eq_or_lt with rfl | hy'
  · rw [hs.1]; exact hx
  · have hz' : 0 < z := lt_of_lt_of_le hy' hyz
    have hm := hs.2 hy' hz' hyz
    simp only at hm
    rw [div_le_div_iff₀ hy' hz'] at hm
    by_cases hhz : 0 ≤ h z
    · have : h y * z ≤ h z * z := le_trans hm (mul_le_mul_of_nonneg_left hyz hhz)
      have := le_of_mul_le_mul_right this hz'
      linarith
    · push_neg at hhz
      have : h z * y ≤ 0 := mul_nonpos_of_nonpos_of_nonneg hhz.le hy
      have : h y * z ≤ 0 := le_trans hm this
      have : h y ≤ 0 := by
        by_contra hc; push_neg at hc; nlinarith
      linarith

/-- technical: the sublevel set equals `[0, ginv h x]` when bounded. -/
private lemma sub_eq (h : ℝ → ℝ) (hc : Continuous h) (hs : StarShaped h) (x : ℝ) (hx : 0 ≤ x)
    (hbdd : BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x}) :
    {y : ℝ | 0 ≤ y ∧ h y ≤ x} = Set.Icc 0 (ginv h x) := by
  have hne : ({y : ℝ | 0 ≤ y ∧ h y ≤ x}).Nonempty := ⟨0, le_refl _, by rw [hs.1]; exact hx⟩
  have hcl : IsClosed {y : ℝ | 0 ≤ y ∧ h y ≤ x} :=
    (isClosed_Ici (a := (0:ℝ))).inter (isClosed_le hc continuous_const)
  have hmem : ginv h x ∈ {y : ℝ | 0 ≤ y ∧ h y ≤ x} := hcl.csSup_mem hne hbdd
  ext y
  constructor
  · intro hy; exact ⟨hy.1, le_csSup hbdd hy⟩
  · intro hy
    exact ⟨hy.1, sub_down h hs x hx hy.1 hy.2 hmem.2⟩

/-- S1 (F:174 "as h is continuous, F_{h(X)}(x)=F_X(h^{-1}(x))"), for `x ≥ 0`. -/
theorem T01_S1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (hc : Continuous h)
    (hs : StarShaped h) (hX : IsInvSub μ) (x : ℝ) (hx : 0 ≤ x)
    (hbdd : BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x}) :
    F (μ.map h) x = F μ (ginv h x) := by
  haveI : IsProbabilityMeasure (μ.map h) :=
    isProbabilityMeasure_map hc.measurable.aemeasurable
  have hseq := sub_eq h hc hs x hx hbdd
  have hr : 0 ≤ ginv h x := by
    have : (0:ℝ) ∈ Set.Icc 0 (ginv h x) := by
      rw [← hseq]; exact ⟨le_refl _, by rw [hs.1]; exact hx⟩
    exact this.2
  have h0 := real_Iic_zero μ hX
  rw [F_eq, F_eq, Measure.real, Measure.real, Measure.map_apply hc.measurable measurableSet_Iic]
  congr 1
  have hI0 : μ (Set.Iio 0) = 0 := by
    have : μ (Set.Iic 0) = 0 := by
      have h1 := h0; rw [Measure.real] at h1
      exact (ENNReal.toReal_eq_zero_iff _).1 h1 |>.resolve_right (measure_ne_top _ _)
    exact measure_mono_null Set.Iio_subset_Iic_self this
  have h1 : μ (h ⁻¹' Set.Iic x) = μ (h ⁻¹' Set.Iic x ∩ Set.Ici 0) := by
    apply le_antisymm
    · calc μ (h ⁻¹' Set.Iic x) ≤ μ (h ⁻¹' Set.Iic x ∩ Set.Ici 0 ∪ Set.Iio 0) := by
            apply measure_mono
            intro y hy
            rcases le_or_gt 0 y with h' | h'
            · exact Or.inl ⟨hy, h'⟩
            · exact Or.inr h'
        _ ≤ μ (h ⁻¹' Set.Iic x ∩ Set.Ici 0) + μ (Set.Iio 0) := measure_union_le _ _
        _ = _ := by rw [hI0, add_zero]
    · exact measure_mono Set.inter_subset_left
  have h2 : μ (Set.Iic (ginv h x)) = μ (Set.Iic (ginv h x) ∩ Set.Ici 0) := by
    apply le_antisymm
    · calc μ (Set.Iic (ginv h x)) ≤ μ (Set.Iic (ginv h x) ∩ Set.Ici 0 ∪ Set.Iio 0) := by
            apply measure_mono
            intro y hy
            rcases le_or_gt 0 y with h' | h'
            · exact Or.inl ⟨hy, h'⟩
            · exact Or.inr h'
        _ ≤ μ (Set.Iic (ginv h x) ∩ Set.Ici 0) + μ (Set.Iio 0) := measure_union_le _ _
        _ = _ := by rw [hI0, add_zero]
    · exact measure_mono Set.inter_subset_left
  rw [h1, h2]
  congr 1
  ext y
  have := Set.ext_iff.1 hseq y
  simp only [Set.mem_setOf_eq, Set.mem_Icc] at this
  simp only [Set.mem_inter_iff, Set.mem_preimage, Set.mem_Iic, Set.mem_Ici]
  constructor
  · rintro ⟨a, b⟩; exact ⟨(this.1 ⟨b, a⟩).2, b⟩
  · rintro ⟨a, b⟩; exact ⟨(this.2 ⟨b, a⟩).2, b⟩

/-- Gap for S2 (`F_{h(X)}(0) = 0`; not in source; false as stated). -/
def T01_S2_Gap : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ), Continuous h → StarShaped h →
    IsInvSub μ → F (μ.map h) 0 = 0

/-- S3 (F:174, Lemma 4.1 of ineq-order2024). -/
theorem T01_S3 (hX02 : T01_X02Tool) (h : ℝ → ℝ) (hc : Continuous h) (hs : StarShaped h)
    (hm : MonotoneOn h (Set.Ici 0)) : AntiStarShaped (ginv h) :=
  hX02 h hc hs hm

/-- S4 (F:174). -/
theorem T01_S4 (h : ℝ → ℝ) (hanti : AntiStarShaped (ginv h)) (x θ : ℝ) (hx : 0 < x)
    (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    ginv h (x / θ) ≤ ginv h x / θ ∧ ginv h (x / (1 - θ)) ≤ ginv h x / (1 - θ) := by
  have key : ∀ t : ℝ, 0 < t → t ≤ 1 → ginv h (x / t) ≤ ginv h x / t := by
    intro t ht ht1
    have hxt : x ≤ x / t := by
      rw [le_div_iff₀ ht]; nlinarith
    have hxt0 : 0 < x / t := lt_of_lt_of_le hx hxt
    have := hanti hx hxt0 hxt
    simp only at this
    rw [div_le_div_iff₀ hxt0 hx] at this
    have h3 : ginv h x / t * x = ginv h x * (x / t) := by ring
    have : ginv h (x / t) * x ≤ ginv h x / t * x := by rw [h3]; exact this
    exact le_of_mul_le_mul_right this hx
  exact ⟨key θ hθ.1 hθ.2.le, key (1 - θ) (by linarith [hθ.2]) (by linarith [hθ.1])⟩

/-- S5 (F:177-178). -/
theorem T01_S5 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (x θ : ℝ)
    (hθ : θ ∈ Set.Ioo (0:ℝ) 1)
    (h4 : ginv h (x / θ) ≤ ginv h x / θ ∧ ginv h (x / (1 - θ)) ≤ ginv h x / (1 - θ)) :
    F μ (ginv h (x / θ)) + F μ (ginv h (x / (1 - θ)))
      ≤ F μ (ginv h x / θ) + F μ (ginv h x / (1 - θ)) :=
  add_le_add (monotone_cdf μ h4.1) (monotone_cdf μ h4.2)

/-- S6 (F:178). -/
theorem T01_S6 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hsub : SubCond μ) (y θ : ℝ)
    (hy : 0 ≤ y) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F μ (y / θ) + F μ (y / (1 - θ)) ≤ F μ y + 1 := hsub y hy θ hθ

/-- technical (FAIR_IMPLICIT_STEP, the premise `hbdd` of S1 in assembly): if the sublevel set
were unbounded, star-shapedness gives `h ≤ 0` on `[0,∞)`, so `F_{h(X)}(0) = 1`, contradicting S2. -/
private lemma bdd_of_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ)
    (hc : Continuous h) (hs : StarShaped h) (hX : IsInvSub μ)
    (h2 : F (μ.map h) 0 = 0) (x : ℝ) (hx : 0 ≤ x) :
    BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x} := by
  by_contra hnb
  haveI : IsProbabilityMeasure (μ.map h) :=
    isProbabilityMeasure_map hc.measurable.aemeasurable
  have hnle : ∀ y : ℝ, 0 < y → h y ≤ 0 := by
    intro y hy
    by_contra hpos
    push_neg at hpos
    set c := h y / y with hcdef
    have hcpos : 0 < c := div_pos hpos hy
    rw [not_bddAbove_iff] at hnb
    obtain ⟨z, ⟨hz0, hzx⟩, hzgt⟩ := hnb (max y (x / c))
    have hyz : y < z := lt_of_le_of_lt (le_max_left _ _) hzgt
    have hxz : x / c < z := lt_of_le_of_lt (le_max_right _ _) hzgt
    have hz' : 0 < z := lt_trans hy hyz
    have hm := hs.2 hy hz' hyz.le
    simp only at hm
    have h5 : h z / z ≤ x / z := div_le_div_of_nonneg_right hzx hz'.le
    have h6 : x / z < c := by
      rw [div_lt_iff₀ hz']
      rw [div_lt_iff₀ hcpos] at hxz
      linarith
    linarith
  have hpos0 := real_Iic_zero μ hX
  have hsub : Set.Ioi (0:ℝ) ⊆ h ⁻¹' Set.Iic 0 := fun y hy => hnle y hy
  have hge : 1 ≤ F (μ.map h) 0 := by
    rw [F_eq, Measure.real, Measure.map_apply hc.measurable measurableSet_Iic]
    have hcompl : μ.real (Set.Ioi 0) = 1 := by
      have := measureReal_add_measureReal_compl (μ := μ) (measurableSet_Iic (a := (0:ℝ)))
      rw [Set.compl_Iic, hpos0] at this
      simpa using this
    have hle : μ (Set.Ioi 0) ≤ μ (h ⁻¹' Set.Iic 0) := measure_mono hsub
    have : μ.real (Set.Ioi 0) ≤ (μ (h ⁻¹' Set.Iic 0)).toReal :=
      ENNReal.toReal_mono (measure_ne_top _ _) hle
    linarith
  linarith

/-- Theorem 2.8 modulo the gaps S0 and S2. -/
theorem T01_main_mod_gaps (hGap_0 : T01_S0_Gap) (hGap_2 : T01_S2_Gap)
    (hL01 : T01_L01Consumed) (hX02 : T01_X02Tool)
    (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ) (hc : Continuous h)
    (hs : StarShaped h) (hX : IsInvSub μ) : IsInvSub (μ.map h) := by
  haveI : IsProbabilityMeasure (μ.map h) :=
    isProbabilityMeasure_map hc.measurable.aemeasurable
  have h2 := hGap_2 μ h hc hs hX                          -- F:180 (silent), S2
  have hm := hGap_0 h hc hs                               -- F:180 "increasing", S0
  have hanti := T01_S3 hX02 h hc hs hm                    -- F:174, S3
  have hbdd := bdd_of_S2 μ h hc hs hX h2
  have hsubX : SubCond μ := (hL01 μ inferInstance).1 hX   -- L01 (→) for X
  refine (hL01 (μ.map h) inferInstance).2 h2 ?_            -- F:180 L01 (←)
  intro x hx θ hθ
  have hθ0 := hθ.1
  have hθ1 : 0 < 1 - θ := by linarith [hθ.2]
  rcases hx.eq_or_lt with hx0 | hxpos
  · subst hx0
    rw [zero_div, zero_div, h2]; norm_num
  · have hxθ : 0 ≤ x / θ := div_nonneg hx hθ0.le
    have hxθ' : 0 ≤ x / (1 - θ) := div_nonneg hx hθ1.le
    rw [T01_S1 μ h hc hs hX (x / θ) hxθ (hbdd _ hxθ),
      T01_S1 μ h hc hs hX (x / (1 - θ)) hxθ' (hbdd _ hxθ'),
      T01_S1 μ h hc hs hX x hx (hbdd x hx)]               -- F:174, S1
    have h4 := T01_S4 h hanti x θ hxpos hθ                -- F:174, S4
    have h5 := T01_S5 μ h x θ hθ h4                       -- F:177-178, S5
    have hy : 0 ≤ ginv h x := by
      have := le_csSup (hbdd x hx) (show (0:ℝ) ∈ {y : ℝ | 0 ≤ y ∧ h y ≤ x} from
        ⟨le_refl _, by rw [hs.1]; exact hx⟩)
      exact this
    have h6 := T01_S6 μ hsubX (ginv h x) θ hy hθ          -- F:178, S6
    linarith

end Paper.T01

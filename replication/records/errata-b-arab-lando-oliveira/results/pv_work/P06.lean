import P06Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P06

/-- Support lemma (F:445, quantile of Pareto): for `p < 1`, `1/(1-p)` is the greatest element
of `{x | paretoCdf x ≤ p}`. -/
private lemma pareto_greatest (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    IsGreatest {x : ℝ | paretoCdf x ≤ p} (1 / (1 - p)) := by
  have h1p : 0 < 1 - p := by linarith
  have hge : 1 ≤ 1 / (1 - p) := by
    rw [le_div_iff₀ h1p]; linarith
  constructor
  · show paretoCdf (1 / (1 - p)) ≤ p
    unfold paretoCdf
    rw [if_pos hge]
    have : 1 / (1 / (1 - p)) = 1 - p := by field_simp
    rw [this]; linarith
  · intro x hx
    have hx' : paretoCdf x ≤ p := hx
    unfold paretoCdf at hx'
    by_cases h : 1 ≤ x
    · rw [if_pos h] at hx'
      have hxpos : 0 < x := by linarith
      have : 1 - p ≤ 1 / x := by linarith
      rw [le_div_iff₀ hxpos] at this
      rw [le_div_iff₀ h1p]; nlinarith
    · push_neg at h
      linarith

theorem P06_S1 (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p < 1) :
    genInv paretoCdf p = ((1 / (1 - p) : ℝ) : EReal) := by
  have hg := pareto_greatest p hp0 hp1
  unfold genInv
  apply IsGreatest.csSup_eq
  constructor
  · exact ⟨_, hg.1, rfl⟩
  · rintro _ ⟨x, hx, rfl⟩
    exact EReal.coe_le_coe_iff.mpr (hg.2 hx)

theorem P06_S1' (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    recipE (genInv paretoCdf p) = ((1 - p : ℝ) : EReal) := by
  rcases lt_or_eq_of_le hp1 with h | h
  · rw [P06_S1 p hp0 h]
    have h1p : 0 < 1 - p := by linarith
    have hne : (1 / (1 - p) : ℝ) ≠ 0 := by positivity
    have e : recipE ((1 / (1 - p) : ℝ) : EReal) = ((1 / (1 / (1 - p)) : ℝ) : EReal) := by
      show (if (1 / (1 - p) : ℝ) = 0 then (⊤ : EReal) else ((1 / (1 / (1 - p)) : ℝ) : EReal)) = _
      rw [if_neg hne]
    rw [e]
    congr 1
    field_simp
  · subst h
    have : genInv paretoCdf 1 = ⊤ := by
      refine not_not.mp (fun hne => ?_)
      have hlt : genInv paretoCdf 1 < ⊤ := lt_top_iff_ne_top.mpr hne
      obtain ⟨r, hr1, _⟩ := EReal.lt_iff_exists_real_btwn.mp hlt
      have hmem : ((max r 1 : ℝ) : EReal) ≤ genInv paretoCdf 1 := by
        unfold genInv
        apply le_sSup
        refine ⟨max r 1, ?_, rfl⟩
        show paretoCdf (max r 1) ≤ 1
        unfold paretoCdf
        have h1 : 1 ≤ max r 1 := le_max_right _ _
        rw [if_pos h1]
        have : 0 ≤ 1 / max r 1 := by positivity
        linarith
      have h2 : ((max r 1 : ℝ) : EReal) < ((r : ℝ) : EReal) := lt_of_le_of_lt hmem hr1
      have h3 := EReal.coe_lt_coe_iff.mp h2
      exact absurd h3 (not_lt.mpr (le_max_left _ _))
    rw [this]
    simp [recipE]

private lemma leftLim_mem (μ : Measure ℝ) [IsProbabilityMeasure μ] (t : ℝ) :
    0 ≤ Function.leftLim (ProbabilityTheory.cdf μ) t ∧
      Function.leftLim (ProbabilityTheory.cdf μ) t ≤ 1 := by
  have hm := ProbabilityTheory.monotone_cdf μ
  constructor
  · exact le_trans (ProbabilityTheory.cdf_nonneg μ (t - 1)) (hm.le_leftLim (by linarith))
  · exact le_trans (hm.leftLim_le le_rfl) (ProbabilityTheory.cdf_le_one μ t)

/-- S2. Source F:445 (unfolding Def 5.1 with S1'). -/
theorem P06_S2 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    isbOrder (ProbabilityTheory.cdf μ) paretoCdf ↔
      SubadditiveOn
        (fun x : ℝ => 1 - Function.leftLim (ProbabilityTheory.cdf μ) (1 / x)) (Set.Ioi 0) := by
  have key : ∀ x : ℝ, recipE (genInv paretoCdf (Function.leftLim (ProbabilityTheory.cdf μ) (1 / x)))
      = ((1 - Function.leftLim (ProbabilityTheory.cdf μ) (1 / x) : ℝ) : EReal) := fun x =>
    P06_S1' _ (leftLim_mem μ _).1 (leftLim_mem μ _).2
  unfold isbOrder SubadditiveOn
  simp only [key]
  constructor
  · intro h x hx y hy
    have := h x hx y hy
    rw [← EReal.coe_add, EReal.coe_le_coe_iff] at this
    exact this
  · intro h x hx y hy
    have := h x hx y hy
    rw [← EReal.coe_add, EReal.coe_le_coe_iff]
    exact this

/-- Left-limit approximation: `leftLim F (1/z) - ε < F t` for some `0 < t < 1/z`. -/
private lemma approx_left {F : ℝ → ℝ} (hm : Monotone F) {z : ℝ} (hz : 0 < z) {ε : ℝ}
    (hε : 0 < ε) : ∃ t, 0 < t ∧ t < 1 / z ∧ Function.leftLim F (1 / z) - ε < F t := by
  have h1 := (hm.tendsto_leftLim (1 / z)).eventually_const_lt
    (show Function.leftLim F (1 / z) - ε < Function.leftLim F (1 / z) by linarith)
  have h2 : Set.Ioo 0 (1 / z) ∈ nhdsWithin (1 / z) (Set.Iio (1 / z)) :=
    Ioo_mem_nhdsLT (by positivity)
  obtain ⟨t, ht1, ht2⟩ := (h1.and (Filter.mem_of_superset h2 (fun _ h => h))).exists
  exact ⟨t, ht2.1, ht2.2, ht1⟩

private lemma s3_ab {F : ℝ → ℝ} (hm : Monotone F)
    (hA : ∀ x ∈ Set.Ioi (0:ℝ), ∀ y ∈ Set.Ioi (0:ℝ),
      1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y))) :
    ∀ x ∈ Set.Ioi (0:ℝ), ∀ y ∈ Set.Ioi (0:ℝ),
      1 - Function.leftLim F (1 / (x + y)) ≤
        (1 - Function.leftLim F (1 / x)) + (1 - Function.leftLim F (1 / y)) := by
  intro x hx y hy
  have hx : 0 < x := hx
  have hy : 0 < y := hy
  by_contra hcon
  push_neg at hcon
  set δ := (1 - Function.leftLim F (1 / (x + y))) -
    ((1 - Function.leftLim F (1 / x)) + (1 - Function.leftLim F (1 / y))) with hδ
  have hδpos : 0 < δ := by rw [hδ]; linarith
  obtain ⟨t1, ht1p, ht1, ht1F⟩ := approx_left hm hx (show 0 < δ / 3 by linarith)
  obtain ⟨t2, ht2p, ht2, ht2F⟩ := approx_left hm hy (show 0 < δ / 3 by linarith)
  have hx1 : x < 1 / t1 := by
    rw [lt_div_iff₀ ht1p]; rw [lt_div_iff₀ hx] at ht1; linarith
  have hy1 : y < 1 / t2 := by
    rw [lt_div_iff₀ ht2p]; rw [lt_div_iff₀ hy] at ht2; linarith
  have h := hA (1 / t1) (by simp [ht1p]) (1 / t2) (by simp [ht2p])
  rw [one_div_one_div, one_div_one_div] at h
  have hle : F (1 / (1 / t1 + 1 / t2)) ≤ Function.leftLim F (1 / (x + y)) :=
    hm.le_leftLim (one_div_lt_one_div_of_lt (by positivity) (by linarith))
  linarith

private lemma s3_ba {F : ℝ → ℝ} (hm : Monotone F)
    (hrc : ∀ a, ContinuousWithinAt F (Set.Ici a) a)
    (hB : ∀ x ∈ Set.Ioi (0:ℝ), ∀ y ∈ Set.Ioi (0:ℝ),
      1 - Function.leftLim F (1 / (x + y)) ≤
        (1 - Function.leftLim F (1 / x)) + (1 - Function.leftLim F (1 / y))) :
    ∀ x ∈ Set.Ioi (0:ℝ), ∀ y ∈ Set.Ioi (0:ℝ),
      1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y)) := by
  intro x hx y hy
  have hx : 0 < x := hx
  have hy : 0 < y := hy
  by_contra hcon
  push_neg at hcon
  have hxy : 0 < x + y := by linarith
  set a := 1 / (x + y) with ha
  have hapos : 0 < a := by positivity
  have hc : F a < F (1 / x) + F (1 / y) - 1 := by linarith
  -- right-continuity at `a`
  have hr : Filter.Tendsto F (nhdsWithin a (Set.Ioi a)) (nhds (F a)) :=
    (hrc a).mono Set.Ioi_subset_Ici_self
  have h1 := hr.eventually_lt_const hc
  have h2 : Set.Ioo a (a + 1) ∈ nhdsWithin a (Set.Ioi a) := Ioo_mem_nhdsGT (by linarith)
  obtain ⟨s, hsF, hs⟩ := (h1.and (Filter.mem_of_superset h2 (fun _ h => h))).exists
  have has : a < s := hs.1
  have hspos : 0 < s := lt_trans hapos has
  set u := 1 / s with hu
  have hupos : 0 < u := by positivity
  have hu_lt : u < x + y := by
    have : 1 / s < 1 / a := one_div_lt_one_div_of_lt hapos has
    rw [ha, one_div_one_div] at this; exact this
  set lam := (1 + u / (x + y)) / 2 with hlam
  have hq : u / (x + y) < 1 := by rw [div_lt_one hxy]; exact hu_lt
  have hq0 : 0 < u / (x + y) := by positivity
  have hlam0 : 0 < lam := by rw [hlam]; linarith
  have hlam1 : lam < 1 := by rw [hlam]; linarith
  have hlamu : u < lam * (x + y) := by
    have : u / (x + y) < lam := by rw [hlam]; linarith
    rwa [div_lt_iff₀ hxy] at this
  have hx' : 0 < lam * x := by positivity
  have hy' : 0 < lam * y := by positivity
  have h := hB (lam * x) hx' (lam * y) hy'
  have e : lam * x + lam * y = lam * (x + y) := by ring
  rw [e] at h
  have hb1 : 1 / (lam * (x + y)) < s := by
    have := one_div_lt_one_div_of_lt hupos hlamu
    rw [hu, one_div_one_div] at this; exact this
  have hb2 : F (1 / (lam * (x + y))) ≤ F s := hm hb1.le
  have hb3 : Function.leftLim F (1 / (lam * (x + y))) ≤ F (1 / (lam * (x + y))) :=
    hm.leftLim_le le_rfl
  have hb4 : F (1 / x) ≤ Function.leftLim F (1 / (lam * x)) :=
    hm.le_leftLim (one_div_lt_one_div_of_lt (by positivity) (by nlinarith))
  have hb5 : F (1 / y) ≤ Function.leftLim F (1 / (lam * y)) :=
    hm.le_leftLim (one_div_lt_one_div_of_lt (by positivity) (by nlinarith))
  linarith

/-- S3. Source F:445, passage from `F⁻` to `F_X` (not justified in the source; the equivalence
is proved via one-sided limits, see notes). -/
theorem P06_S3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    SubadditiveOn
        (fun x : ℝ => 1 - Function.leftLim (ProbabilityTheory.cdf μ) (1 / x)) (Set.Ioi 0) ↔
      SubadditiveOn (fun x : ℝ => 1 - ProbabilityTheory.cdf μ (1 / x)) (Set.Ioi 0) := by
  have hm := ProbabilityTheory.monotone_cdf μ
  have hrc : ∀ a, ContinuousWithinAt (ProbabilityTheory.cdf μ) (Set.Ici a) a :=
    fun a => (ProbabilityTheory.cdf μ).right_continuous a
  constructor
  · intro h
    exact s3_ba hm hrc h
  · intro h
    exact s3_ab hm h

/-- S4. Source F:445 / Def 2.2 with `F_X(0)=0`. -/
theorem P06_S4 (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h0 : ProbabilityTheory.cdf μ 0 = 0) :
    IsInvSub μ ↔
      SubadditiveOn (fun x : ℝ => 1 - ProbabilityTheory.cdf μ (1 / x)) (Set.Ioi 0) :=
  ⟨fun h => h.2, fun h => ⟨h0, h⟩⟩

/-- Proposition 5.3 (source F:440-443, label cor:fsub). -/
theorem P06_main (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (h0 : ProbabilityTheory.cdf μ 0 = 0) :
    IsInvSub μ ↔ isbOrder (ProbabilityTheory.cdf μ) paretoCdf := by
  rw [P06_S4 μ h0, P06_S2 μ, P06_S3 μ]

end Paper.P06

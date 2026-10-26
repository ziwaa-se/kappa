import T01ModGaps

/-!
# T01 issue 1: counterexample to Theorem 2.8 (thm:inclusion) as printed

Source: `source/SuperParetoPaper-v12.tex:169-172` ("Let X be ITS and h a continuous
star-shaped function. Then h(X) is ITS."), read with Def 2.2 (`:122-124`, ITS requires
`F_X(0) = 0`) and the star-shaped definition (`:111`).

Instance:
* `X` with cdf `F_X(x) = x/(1+x)` for `x ≥ 0`, `0` for `x < 0` (the law of `Y` at `:337`).
  It is ITS: `F_X(0) = 0` and `1 - F_X(1/x) = x/(1+x)` is subadditive on `(0,∞)`.
* `h(x) = max (x - 1) 0`: continuous, `h 0 = 0`, `h x / x` non-decreasing on `(0,∞)`;
  `h` is moreover increasing and convex (so the separate issue S0 plays no role).
* `F_{h(X)}(0) = P(X ≤ 1) = 1/2 ≠ 0`, so `h(X)` is not ITS.
-/

namespace Paper.T01.Issue1

open MeasureTheory ProbabilityTheory Filter Topology Set
open Paper.L01 Paper.T01

/-- Theorem 2.8 as printed (F:169-172), encoded over the gate-approved `StarShaped`
(F:111) and `IsInvSub` (Def 2.2, F:124). `h : ℝ → ℝ` continuous on all of `ℝ` is a
stronger hypothesis than continuity on `[0,∞)`, so this clause is weaker than printed. -/
def PrintedThm28 : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : ℝ → ℝ),
    IsInvSub μ → Continuous h → StarShaped h → IsInvSub (μ.map h)

/-! ## The law of `X` -/

/-- `F_X(x) = x⁺/(1+x⁺)`. -/
noncomputable def g0 (x : ℝ) : ℝ := max x 0 / (1 + max x 0)

lemma g0_of_nonneg {x : ℝ} (hx : 0 ≤ x) : g0 x = x / (1 + x) := by
  simp [g0, max_eq_left hx]

lemma g0_of_nonpos {x : ℝ} (hx : x ≤ 0) : g0 x = 0 := by
  simp [g0, max_eq_right hx]

lemma g0_mono : Monotone g0 := by
  intro a b hab
  unfold g0
  have ha : 0 ≤ max a 0 := le_max_right _ _
  have hab' : max a 0 ≤ max b 0 := max_le_max hab le_rfl
  rw [div_le_div_iff₀ (by linarith) (by linarith)]
  nlinarith

lemma g0_cont : Continuous g0 := by
  unfold g0
  exact (continuous_id.max continuous_const).div
    (continuous_const.add (continuous_id.max continuous_const))
    (fun x => ne_of_gt (by linarith [le_max_right x (0:ℝ)]))

/-- `g0` as a Stieltjes function. -/
noncomputable def gS : StieltjesFunction where
  toFun := g0
  mono' := g0_mono
  right_continuous' := fun x => g0_cont.continuousWithinAt

lemma gS_atBot : Tendsto gS atBot (𝓝 0) := by
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [eventually_le_atBot (0:ℝ)] with x hx
  exact (g0_of_nonpos hx).symm

lemma gS_atTop : Tendsto gS atTop (𝓝 1) := by
  have h1 : Tendsto (fun x : ℝ => 1 - (1 + x)⁻¹) atTop (𝓝 1) := by
    have : Tendsto (fun x : ℝ => (1 + x)⁻¹) atTop (𝓝 0) :=
      tendsto_inv_atTop_zero.comp (tendsto_atTop_add_const_left _ _ tendsto_id)
    simpa using (tendsto_const_nhds (x := (1:ℝ))).sub this
  refine h1.congr' ?_
  filter_upwards [eventually_ge_atTop (0:ℝ)] with x hx
  show 1 - (1 + x)⁻¹ = g0 x
  rw [g0_of_nonneg hx]
  field_simp
  try ring

/-- The law of `X`. -/
noncomputable def μ0 : Measure ℝ := gS.measure

instance μ0_prob : IsProbabilityMeasure μ0 :=
  StieltjesFunction.isProbabilityMeasure gS gS_atBot gS_atTop

lemma F_μ0 (x : ℝ) : F μ0 x = g0 x := by
  unfold F μ0
  rw [cdf_measure_stieltjesFunction gS gS_atBot gS_atTop]
  rfl

lemma μ0_real_Iic (x : ℝ) : μ0.real (Set.Iic x) = g0 x := by
  rw [← F_μ0]; unfold F; exact (cdf_eq_real μ0 x).symm

/-- `X` satisfies the printed hypothesis "X is ITS" (Def 2.2, F:124). -/
lemma isInvSub_μ0 : IsInvSub μ0 := by
  refine ⟨by rw [F_μ0, g0_of_nonpos le_rfl], ?_⟩
  have key : ∀ x : ℝ, 0 < x → invDist (F μ0) x = x / (1 + x) := by
    intro x hx
    simp only [invDist, F_μ0]
    rw [g0_of_nonneg (one_div_pos.mpr hx).le]
    have hx0 : x ≠ 0 := hx.ne'
    have h1x : 1 + x ≠ 0 := by linarith
    have h1x' : x + 1 ≠ 0 := by linarith
    field_simp
    try ring_nf
    try simp
  intro x hx y hy
  have hx' : (0:ℝ) < x := hx
  have hy' : (0:ℝ) < y := hy
  rw [key x hx', key y hy', key (x + y) (add_pos hx' hy')]
  have e : (x + y) / (1 + (x + y)) = x / (1 + (x + y)) + y / (1 + (x + y)) := by ring
  rw [e]
  apply add_le_add
  · exact div_le_div_of_nonneg_left hx'.le (by linarith) (by linarith)
  · exact div_le_div_of_nonneg_left hy'.le (by linarith) (by linarith)

/-! ## The function `h` -/

/-- `h(x) = max (x - 1) 0`. -/
def h0 (x : ℝ) : ℝ := max (x - 1) 0

lemma h0_cont : Continuous h0 :=
  (continuous_id.sub continuous_const).max continuous_const

/-- `h0` is star-shaped in the sense of F:111. -/
lemma h0_star : StarShaped h0 := by
  refine ⟨by norm_num [h0], ?_⟩
  intro a ha b hb hab
  have ha' : (0:ℝ) < a := ha
  have hb' : (0:ℝ) < b := hb
  simp only [h0]
  rcases le_or_gt a 1 with ha1 | ha1
  · rw [max_eq_right (by linarith), zero_div]
    exact div_nonneg (le_max_right _ _) hb'.le
  · rw [max_eq_left (by linarith), max_eq_left (by linarith),
      div_le_div_iff₀ ha' hb']
    nlinarith

/-- Extra (not a printed hypothesis): `h0` is also increasing on `[0,∞)`, so the
counterexample does not depend on the separate monotonicity issue S0. -/
lemma h0_mono : Monotone h0 := fun a b hab => max_le_max (by linarith) le_rfl

/-- Extra: `h0` is convex. -/
lemma h0_convex : ConvexOn ℝ Set.univ h0 :=
  ((convexOn_id convex_univ).sub (concaveOn_const _ convex_univ)).sup
    (convexOn_const _ convex_univ)

lemma h0_preimage_Iic {x : ℝ} (hx : 0 ≤ x) : h0 ⁻¹' Set.Iic x = Set.Iic (x + 1) := by
  ext y
  simp only [Set.mem_preimage, Set.mem_Iic, h0, max_le_iff]
  constructor
  · rintro ⟨h1, _⟩; linarith
  · intro h1; exact ⟨by linarith, hx⟩

instance map_prob : IsProbabilityMeasure (μ0.map h0) :=
  isProbabilityMeasure_map h0_cont.measurable.aemeasurable

lemma F_map (x : ℝ) (hx : 0 ≤ x) : F (μ0.map h0) x = g0 (x + 1) := by
  unfold F
  rw [cdf_eq_real, map_measureReal_apply h0_cont.measurable measurableSet_Iic,
    h0_preimage_Iic hx, μ0_real_Iic]

/-- `F_{h(X)}(0) = 1/2`. -/
lemma F_map_zero : F (μ0.map h0) 0 = 1 / 2 := by
  rw [F_map 0 le_rfl, zero_add, g0_of_nonneg zero_le_one]
  norm_num

lemma not_isInvSub_map : ¬ IsInvSub (μ0.map h0) := by
  intro hI
  have h1 := hI.1
  rw [F_map_zero] at h1
  norm_num at h1

/-- Theorem 2.8 as printed is false. -/
theorem T01_counterexample : ¬ PrintedThm28 := by
  intro hP
  exact not_isInvSub_map (hP μ0 h0 isInvSub_μ0 h0_cont h0_star)

/-- Obligation S2 (`T01_S2_Gap`, the step silently consumed at F:180) is false. -/
theorem not_T01_S2_Gap : ¬ T01_S2_Gap := by
  intro hG
  have h1 := hG μ0 h0 h0_cont h0_star isInvSub_μ0
  rw [F_map_zero] at h1
  norm_num at h1

/-- Scope (consumed_of_printed): the printed theorem implies the silently consumed S2,
so S2 is exactly a consequence of the printed clause (refuting S2 refutes the theorem). -/
theorem S2_of_printed (hP : PrintedThm28) : T01_S2_Gap := by
  intro μ _ h hc hs hX
  exact (hP μ h hX hc hs).1

/-- Scope: the failure lies only in the `F(0)=0` conjunct of Def 2.2. The subadditivity
part does hold for `h(X)`: `1 - F_{h(X)}(1/x) = x/(1+2x)` on `(0,∞)`. -/
lemma subadditive_map : SubadditiveOn (invDist (F (μ0.map h0))) (Set.Ioi 0) := by
  have key : ∀ x : ℝ, 0 < x → invDist (F (μ0.map h0)) x = x / (1 + 2 * x) := by
    intro x hx
    simp only [invDist]
    rw [F_map _ (one_div_pos.mpr hx).le,
      g0_of_nonneg (by linarith [(one_div_pos.mpr hx).le])]
    have hx0 : x ≠ 0 := hx.ne'
    have h1x : 1 + 2 * x ≠ 0 := by linarith
    have h1x' : 2 * x + 1 ≠ 0 := by linarith
    field_simp
    try ring_nf
    try simp
  intro x hx y hy
  have hx' : (0:ℝ) < x := hx
  have hy' : (0:ℝ) < y := hy
  rw [key x hx', key y hy', key (x + y) (add_pos hx' hy')]
  have e : (x + y) / (1 + 2 * (x + y)) = x / (1 + 2 * (x + y)) + y / (1 + 2 * (x + y)) := by
    ring
  rw [e]
  apply add_le_add
  · exact div_le_div_of_nonneg_left hx'.le (by linarith) (by linarith)
  · exact div_le_div_of_nonneg_left hy'.le (by linarith) (by linarith)

end Paper.T01.Issue1

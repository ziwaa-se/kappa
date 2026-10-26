import Mathlib

/-!
# Counterexamples: Theorem 2.8, Theorem 4.8, the last step of the proof of Theorem 3.1,
# and Examples 4.13 / 4.16

We build the Pareto(1) law `𝒫(x) = 1 - 1/x` (`x ≥ 1`) as a Stieltjes measure and use it to
construct the counterexamples.
-/

open MeasureTheory ProbabilityTheory Set Filter Topology

noncomputable section

def InvSub (μ : Measure ℝ) : Prop :=
  cdf μ 0 = 0 ∧ ∀ x y : ℝ, 0 < x → 0 < y →
    1 - cdf μ (1 / (x + y)) ≤ (1 - cdf μ (1 / x)) + (1 - cdf μ (1 / y))

def Cond23 (F : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, 0 < θ → θ < 1 → F (x / θ) + F (x / (1 - θ)) ≤ F x + 1

/-- InvSub implies (2.3) (one direction of Lemma 2.3, re-proved here to keep the file
self-contained). -/
lemma InvSub.cond23 {μ : Measure ℝ} (h : InvSub μ) : Cond23 (cdf μ) := by
  intro x hx θ hθ0 hθ1
  rcases hx.eq_or_lt with rfl | hx
  · simp [h.1]
  have h1 : 0 < θ / x := by positivity
  have h2 : 0 < (1 - θ) / x := by apply div_pos <;> linarith
  have := h.2 (θ / x) ((1 - θ) / x) h1 h2
  have e1 : 1 / (θ / x + (1 - θ) / x) = x := by field_simp
  have e2 : 1 / (θ / x) = x / θ := by field_simp
  have e3 : 1 / ((1 - θ) / x) = x / (1 - θ) := by field_simp
  rw [e1, e2, e3] at this
  linarith

/-! ## The Pareto(1) distribution -/

lemma max_one_pos (x : ℝ) : 0 < max x 1 := lt_of_lt_of_le one_pos (le_max_right _ _)

/-- CDF of the Pareto(1) law: `𝒫(x) = 1 - 1/x` for `x ≥ 1`, `0` for `x ≤ 1`. -/
def paretoF : StieltjesFunction where
  toFun x := 1 - (max x 1)⁻¹
  mono' a b hab := by
    simp only
    have := inv_anti₀ (max_one_pos a) (max_le_max hab le_rfl)
    linarith
  right_continuous' x := by
    have : Continuous fun x : ℝ => 1 - (max x 1)⁻¹ :=
      continuous_const.sub ((continuous_id.max continuous_const).inv₀ fun x => (max_one_pos x).ne')
    exact this.continuousAt.continuousWithinAt

lemma paretoF_apply (x : ℝ) : paretoF x = 1 - (max x 1)⁻¹ := rfl

lemma paretoF_atBot : Tendsto paretoF atBot (𝓝 0) := by
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [eventually_le_atBot 1] with x hx
  simp [paretoF_apply, max_eq_right hx]

lemma paretoF_atTop : Tendsto paretoF atTop (𝓝 1) := by
  have h1 : Tendsto (fun x : ℝ => max x 1) atTop atTop :=
    tendsto_atTop_mono (fun x => le_max_left x 1) tendsto_id
  have := (tendsto_inv_atTop_zero.comp h1).const_sub (1 : ℝ)
  simpa [paretoF_apply, Function.comp_def] using this

/-- The law of a Pareto(1) random variable `Z`. -/
def paretoμ : Measure ℝ := paretoF.measure

instance : IsProbabilityMeasure paretoμ := paretoF.isProbabilityMeasure paretoF_atBot paretoF_atTop

lemma cdf_paretoμ (x : ℝ) : cdf paretoμ x = 1 - (max x 1)⁻¹ := by
  rw [paretoμ, cdf_measure_stieltjesFunction paretoF paretoF_atBot paretoF_atTop]; rfl

lemma inv_max_inv_one {t : ℝ} (ht : 0 < t) : (max (1 / t) 1)⁻¹ = min t 1 := by
  rcases le_total t 1 with h | h
  · have : 1 ≤ 1 / t := by rw [le_div_iff₀ ht]; linarith
    rw [max_eq_left this, min_eq_left h]; field_simp
  · have : 1 / t ≤ 1 := by rw [div_le_iff₀ ht]; linarith
    rw [max_eq_right this, min_eq_right h, inv_one]

/-- The Pareto(1) law is InvSub (claimed at the start of Section 4 of the paper): here
`1 - 𝒫(1/x) = min(x, 1)`. -/
theorem pareto_invSub : InvSub paretoμ := by
  refine ⟨by simp [cdf_paretoμ], fun x y hx hy => ?_⟩
  simp only [cdf_paretoμ, sub_sub_cancel]
  rw [inv_max_inv_one (by linarith), inv_max_inv_one hx, inv_max_inv_one hy]
  rcases le_total x 1 with h1 | h1 <;> rcases le_total y 1 with h2 | h2 <;>
    simp [min_def] <;> split_ifs <;> linarith

/-! ## Theorem 2.8 is false: star-shaped transformations need not preserve InvSub -/

/-- `h(x) = max(x - 2, 0)`: continuous, `h 0 = 0`, `h(x)/x` increasing on `(0,∞)`;
it is moreover increasing, convex and nonconstant. -/
def hcut (x : ℝ) : ℝ := max (x - 2) 0

lemma hcut_continuous : Continuous hcut := (continuous_id.sub continuous_const).max continuous_const

lemma hcut_zero : hcut 0 = 0 := by simp [hcut]

lemma hcut_starShaped : MonotoneOn (fun x => hcut x / x) (Ioi 0) := by
  intro a ha b hb hab
  simp only [mem_Ioi] at ha hb
  simp only [hcut]
  rw [div_le_div_iff₀ ha hb]
  rcases le_total a 2 with h | h
  · rw [max_eq_right (by linarith)]; simp; positivity
  · rw [max_eq_left (by linarith), max_eq_left (by linarith)]; nlinarith

lemma hcut_monotone : Monotone hcut := fun a b h => max_le_max (by linarith) le_rfl

lemma hcut_convex : ConvexOn ℝ univ hcut :=
  ((convexOn_id convex_univ).sub (concaveOn_const 2 convex_univ)).sup (convexOn_const 0 convex_univ)

lemma cdf_map_hcut_zero :
    haveI : IsProbabilityMeasure (paretoμ.map hcut) :=
      isProbabilityMeasure_map hcut_continuous.measurable.aemeasurable
    cdf (paretoμ.map hcut) 0 = 1 / 2 := by
  haveI : IsProbabilityMeasure (paretoμ.map hcut) :=
    isProbabilityMeasure_map hcut_continuous.measurable.aemeasurable
  rw [cdf_eq_real, measureReal_def, Measure.map_apply hcut_continuous.measurable measurableSet_Iic]
  have : hcut ⁻¹' Iic 0 = Iic 2 := by ext x; simp [hcut]
  rw [this, ← measureReal_def, ← cdf_eq_real, cdf_paretoμ]
  norm_num [max_eq_left (by norm_num : (1:ℝ) ≤ 2)]

/-- **Counterexample to Theorem 2.8.** `Z ~ Pareto(1)` is InvSub, `h = hcut` is continuous and
star-shaped, but `h(Z)` is not InvSub because `P(h(Z) ≤ 0) = 1/2 ≠ 0`. -/
theorem theorem_2_8_false :
    InvSub paretoμ ∧ Continuous hcut ∧ hcut 0 = 0 ∧ MonotoneOn (fun x => hcut x / x) (Ioi 0) ∧
      ¬ InvSub (paretoμ.map hcut) := by
  refine ⟨pareto_invSub, hcut_continuous, hcut_zero, hcut_starShaped, ?_⟩
  rintro ⟨h0, -⟩
  rw [cdf_map_hcut_zero] at h0
  norm_num at h0

/-! ## Theorem 4.8 is false: a nonnegative super-Pareto variable which is not InvSub -/

/-- Definition 4.1: `ν` is the law of `h(Z)`, `Z ~ Pareto(1)`, `h` increasing, convex,
nonconstant (we even require convexity on all of `ℝ`, which only makes the class smaller). -/
def SuperPareto (ν : Measure ℝ) : Prop :=
  ∃ h : ℝ → ℝ, Measurable h ∧ Monotone h ∧ ConvexOn ℝ univ h ∧ (∃ a b, h a ≠ h b) ∧
    ν = paretoμ.map h

lemma meas_add_one : Measurable (fun z : ℝ => z + 1) := by fun_prop

/-- The law of `X = Z + 1`. -/
def shiftμ : Measure ℝ := paretoμ.map (fun z => z + 1)

instance : IsProbabilityMeasure shiftμ :=
  isProbabilityMeasure_map meas_add_one.aemeasurable

lemma cdf_shiftμ (x : ℝ) : cdf shiftμ x = 1 - (max (x - 1) 1)⁻¹ := by
  rw [cdf_eq_real, measureReal_def, shiftμ,
    Measure.map_apply meas_add_one measurableSet_Iic]
  have : (fun z : ℝ => z + 1) ⁻¹' Iic x = Iic (x - 1) := by
    ext z; simp
  rw [this, ← measureReal_def, ← cdf_eq_real, cdf_paretoμ]

/-- **Counterexample to Theorem 4.8.** `X = Z + 1` is super-Pareto, nonnegative (indeed
`P(X ≤ 0) = 0`), but violates (2.3) at `x = 5/2`, `θ = 1/2`, hence is not InvSub. -/
theorem theorem_4_8_false :
    SuperPareto shiftμ ∧ shiftμ (Iio 0) = 0 ∧ cdf shiftμ 0 = 0 ∧
      ¬ Cond23 (cdf shiftμ) ∧ ¬ InvSub shiftμ := by
  have hnot : ¬ Cond23 (cdf shiftμ) := by
    intro h
    have := h (5 / 2) (by norm_num) (1 / 2) (by norm_num) (by norm_num)
    simp only [cdf_shiftμ] at this
    norm_num [max_def] at this
  refine ⟨⟨fun z => z + 1, meas_add_one, fun a b h => by simpa using h,
      (convexOn_id convex_univ).add_const 1, ⟨0, 1, by norm_num⟩, rfl⟩, ?_, ?_, hnot,
      fun h => hnot h.cond23⟩
  · rw [shiftμ, Measure.map_apply meas_add_one measurableSet_Iio]
    have : (fun z : ℝ => z + 1) ⁻¹' Iio 0 ⊆ Iic 1 := by
      intro z hz; simp at hz; simp; linarith
    refine le_antisymm ((measure_mono this).trans (le_of_eq ?_)) (zero_le _)
    rw [paretoμ, paretoF.measure_Iic paretoF_atBot]; simp [paretoF_apply]
  · rw [cdf_shiftμ]; norm_num [max_def]

/-- Second counterexample to Theorem 4.8 (with an atom): `max(Z - 2, 0)` is a nonnegative
super-Pareto variable with `P(X ≤ 0) = 1/2`, so it is not InvSub. -/
theorem theorem_4_8_false' :
    SuperPareto (paretoμ.map hcut) ∧ paretoμ.map hcut (Iio 0) = 0 ∧
      ¬ InvSub (paretoμ.map hcut) := by
  refine ⟨⟨hcut, hcut_continuous.measurable, hcut_monotone, hcut_convex,
    ⟨0, 3, by norm_num [hcut]⟩, rfl⟩, ?_, theorem_2_8_false.2.2.2.2⟩
  rw [Measure.map_apply hcut_continuous.measurable measurableSet_Iio]
  have : hcut ⁻¹' Iio 0 = ∅ := by ext x; simp [hcut]
  simp [this]

/-! ## The last inequality in the proof of Theorem 3.1 is false

The proof concludes `P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x/θₙ) + F̄(x/(1-θₙ))`. For the InvSub law Pareto(1),
`x = 3/5`, `θₙ = 1/2`, the right-hand side equals `5/3 > 1`, so this cannot hold for any
probability. -/
theorem thm_3_1_proof_last_step_false :
    InvSub paretoμ ∧ (1 - cdf paretoμ ((3/5) / (1/2))) + (1 - cdf paretoμ ((3/5) / (1 - 1/2))) > 1 := by
  refine ⟨pareto_invSub, ?_⟩
  simp only [cdf_paretoμ]
  norm_num [max_def]

/-! ## Examples 4.13 and 4.16 do not define distribution functions -/

/-- Example 4.13 with `a = 1/2` at `x = 1`: the proposed "CDF" exceeds `1`. -/
theorem example_4_13_not_cdf :
    (1/2 : ℝ) ^ (-(1:ℝ) / 1) * (1 + 1 / (Real.exp (2 * 1) - 1)) > 1 := by
  have he : 1 < Real.exp 2 := by
    have := Real.add_one_lt_exp (by norm_num : (2:ℝ) ≠ 0); linarith
  have h2 : (1/2 : ℝ) ^ (-(1:ℝ) / 1) = 2 := by
    rw [neg_div, div_one, Real.rpow_neg_one]; norm_num
  rw [h2]
  have : 0 < 1 / (Real.exp (2 * 1) - 1) := by norm_num
  linarith

/-- Example 4.16 at `x = 1`: `V(1) = e^{-1}(1 + e) = 1 + e^{-1} > 1`. -/
theorem example_4_16_not_cdf :
    Real.exp (-1 / Real.sqrt 1) * (1 + Real.exp (2 * 1 - 1)) > 1 := by
  simp only [Real.sqrt_one, div_one]
  norm_num
  rw [mul_add, mul_one, ← Real.exp_add]
  norm_num; exact Real.exp_pos _

end

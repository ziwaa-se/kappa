import T02Stmt

open MeasureTheory ProbabilityTheory Paper.L01

namespace Paper.T02

/-! ### Private technical helpers (cdf facts, integrability); no mathematical content beyond
standard facts about `cdf` and finite measures. -/

private lemma F_mono (ν : Measure ℝ) : Monotone (F ν) := monotone_cdf ν
private lemma F_nonneg (ν : Measure ℝ) (x : ℝ) : 0 ≤ F ν x := cdf_nonneg ν x
private lemma F_le_one (ν : Measure ℝ) (x : ℝ) : F ν x ≤ 1 := cdf_le_one ν x
private lemma F_meas (ν : Measure ℝ) : Measurable (F ν) := (F_mono ν).measurable
private lemma Fbar_nonneg (ν : Measure ℝ) (x : ℝ) : 0 ≤ Fbar ν x := by
  unfold Fbar; linarith [F_le_one ν x]
private lemma Fbar_le_one (ν : Measure ℝ) (x : ℝ) : Fbar ν x ≤ 1 := by
  unfold Fbar; linarith [F_nonneg ν x]
private lemma Fbar_anti (ν : Measure ℝ) : Antitone (Fbar ν) := by
  intro a b hab; unfold Fbar; linarith [F_mono ν hab]
private lemma Fbar_meas (ν : Measure ℝ) : Measurable (Fbar ν) := by
  unfold Fbar; exact measurable_const.sub (F_meas ν)

private lemma F_eq_real (ν : Measure ℝ) [IsProbabilityMeasure ν] (x : ℝ) :
    F ν x = ν.real (Set.Iic x) := cdf_eq_real ν x

private lemma real_Ioc (ν : Measure ℝ) [IsProbabilityMeasure ν] {a b : ℝ} (h : a ≤ b) :
    ν.real (Set.Ioc a b) = F ν b - F ν a := by
  rw [F_eq_real, F_eq_real, ← Set.Iic_diff_Iic, measureReal_diff' measurableSet_Iic,
    Set.union_eq_left.2 (Set.Iic_subset_Iic.2 h)]

private lemma real_Icc_le (ν : Measure ℝ) [IsProbabilityMeasure ν] (x : ℝ) :
    ν.real (Set.Icc 0 x) ≤ F ν x := by
  rw [F_eq_real]; exact measureReal_mono (fun t ht => ht.2)

private lemma real_Icc_eq (ν : Measure ℝ) [IsProbabilityMeasure ν] (h0 : F ν 0 = 0) {x : ℝ}
    (hx : 0 ≤ x) : ν.real (Set.Icc 0 x) = F ν x := by
  apply le_antisymm (real_Icc_le ν x)
  have : Set.Iic x ⊆ Set.Iic 0 ∪ Set.Icc 0 x := by
    intro t ht
    by_cases h : t ≤ 0
    · exact Or.inl h
    · exact Or.inr ⟨(not_le.1 h).le, ht⟩
  calc F ν x = ν.real (Set.Iic x) := F_eq_real ν x
    _ ≤ ν.real (Set.Iic 0 ∪ Set.Icc 0 x) := measureReal_mono this
    _ ≤ ν.real (Set.Iic 0) + ν.real (Set.Icc 0 x) := measureReal_union_le _ _
    _ = ν.real (Set.Icc 0 x) := by rw [← F_eq_real, h0, zero_add]

private lemma integrable_bdd (ν : Measure ℝ) [IsProbabilityMeasure ν] {g : ℝ → ℝ}
    (hg : Measurable g) (hb : ∀ t, |g t| ≤ 1) : Integrable g ν :=
  Integrable.mono' (integrable_const (1:ℝ)) hg.aestronglyMeasurable
    (ae_of_all _ (fun t => by simpa [Real.norm_eq_abs] using hb t))

private lemma F_aff_meas (ν : Measure ℝ) (x θ : ℝ) :
    Measurable (fun t => F ν ((x - θ * t) / (1 - θ))) :=
  (F_meas ν).comp (by fun_prop)

private lemma Fbar_aff_meas (ν : Measure ℝ) (x θ : ℝ) :
    Measurable (fun t => Fbar ν ((x - θ * t) / (1 - θ))) :=
  (Fbar_meas ν).comp (by fun_prop)

private lemma F_abs_le (ν : Measure ℝ) (y : ℝ) : |F ν y| ≤ 1 := by
  rw [abs_of_nonneg (F_nonneg ν y)]; exact F_le_one ν y

private lemma Fbar_abs_le (ν : Measure ℝ) (y : ℝ) : |Fbar ν y| ≤ 1 := by
  rw [abs_of_nonneg (Fbar_nonneg ν y)]; exact Fbar_le_one ν y

/-- survival function of the law: `P(x < X) = F̄_X(x)` (definition :113). -/
private lemma prob_gt_eq_Fbar {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (X : Ω → ℝ) (hX : Measurable X) (x : ℝ) :
    (μ {ω | x < X ω}).toReal = Fbar (μ.map X) x := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hX.aemeasurable
  have h1 : {ω | x < X ω} = X ⁻¹' (Set.Iic x)ᶜ := by ext ω; simp
  rw [h1, ← Measure.map_apply hX measurableSet_Iic.compl, ← measureReal_def,
    measureReal_compl measurableSet_Iic, ← F_eq_real]
  simp [Fbar]

/-- `F_X(0)=0` and `Z ~ X` give `Z ≥ 0` a.s. (the "nonnegative random variables" of :191). -/
private lemma ae_nonneg_of_ident {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (X Z : Ω → ℝ) (hX : Measurable X) (hZ : Measurable Z)
    (h : IdentDistrib Z X μ μ) (h0 : F (μ.map X) 0 = 0) : ∀ᵐ ω ∂μ, 0 ≤ Z ω := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hX.aemeasurable
  rw [ae_iff]
  have h1 : (μ.map X) (Set.Iic 0) = 0 := by
    have := ofReal_cdf (μ.map X) 0
    rw [← this]
    have h0' : cdf (μ.map X) 0 = 0 := h0
    rw [h0']; simp
  have h2 : μ (Z ⁻¹' Set.Iic 0) = 0 := by
    rw [← Measure.map_apply hZ measurableSet_Iic, h.map_eq]; exact h1
  refine measure_mono_null ?_ h2
  intro ω hω
  simp only [Set.mem_setOf_eq, not_le] at hω
  exact hω.le

private lemma stdom_neg {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (X Y : Ω → ℝ) (hY : ∀ᵐ ω ∂μ, 0 ≤ Y ω) {x : ℝ} (hx : x < 0) :
    μ {ω | x < X ω} ≤ μ {ω | x < Y ω} := by
  have h : {ω | x < Y ω} =ᵐ[μ] (Set.univ : Set Ω) := by
    rw [ae_eq_univ]
    refine measure_mono_null ?_ (ae_iff.1 hY)
    intro ω hω
    simp only [Set.mem_compl_iff, Set.mem_setOf_eq, not_lt] at hω
    simp only [Set.mem_setOf_eq, not_le]
    linarith
  rw [measure_congr h]
  exact measure_mono (Set.subset_univ _)

private lemma toReal_le_one' {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (s : Set Ω) : (μ s).toReal ≤ 1 := by
  have := ENNReal.toReal_mono (by simp) (prob_le_one (μ := μ) (s := s))
  simpa using this

/-- weights positive with sum 1 and at least one other index: last weight `< 1`. -/
private lemma last_lt_one {n : ℕ} (θ : Fin (n + 1) → ℝ) (hn : 1 ≤ n) (hθ : ∀ i, 0 < θ i)
    (hsum : ∑ i, θ i = 1) : θ (Fin.last n) < 1 := by
  rw [Fin.sum_univ_castSucc] at hsum
  have : 0 < ∑ i : Fin n, θ i.castSucc :=
    Finset.sum_pos (fun i _ => hθ _) ⟨⟨0, by omega⟩, Finset.mem_univ _⟩
  linarith

/-- measurability in `t` of the conditional probabilities (technical, for integrals). -/
private lemma meas_cond {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Z : Ω → ℝ) (hZ : Measurable Z) (x θ c : ℝ) :
    Measurable fun t : ℝ => (μ {ω | (x - θ * t) / c ≤ Z ω / c}).toReal := by
  have hs : MeasurableSet {p : ℝ × Ω | (x - θ * p.1) / c ≤ Z p.2 / c} :=
    measurableSet_le (by fun_prop) ((hZ.comp measurable_snd).div_const c)
  exact (measurable_measure_prodMk_left hs).ennreal_toReal

/-! ### n = 2 case (source :191-217) -/

/-- S1.  Source :191-194: "Conditioning, using the independence of the random variables, and
remembering they are nonnegative, it is easily seen that, for every `x ≥ 0` and `θ ∈ (0,1)`,
`P(θX₁+(1-θ)X₂ > x) = 1 - ∫_0^{x/θ} F_X((x-θt)/(1-θ)) F_X(dt)`."
Role: integral formula for `n=2` (INVENTORY X05, X10).  Nonnegativity is not a printed hypothesis;
it is the consequence `F_X(0)=0` of InvSub (Def 2.2).  `∫_0^{x/θ}` is read as the closed interval
`[0, x/θ]` w.r.t. the law `F_X(dt) = μ.map X` (atoms at the endpoints would matter; the integrand
vanishes at `t = x/θ` because `F_X(0)=0`).  Uses: nothing (external standard fact, X05;
here a step obligation: provable by independence + Fubini). -/
theorem T02_S1 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hind : IndepFun X₁ X₂ μ) (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hits : IsInvSub (μ.map X)) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    (μ {ω | x < θ * X₁ ω + (1 - θ) * X₂ ω}).toReal
      = 1 - ∫ t in Set.Icc 0 (x / θ), F (μ.map X) ((x - θ * t) / (1 - θ)) ∂(μ.map X) := by
  obtain ⟨hθ0, hθ1⟩ := hθ
  have h1θ : 0 < 1 - θ := by linarith
  set ν := μ.map X with hν
  haveI : IsProbabilityMeasure ν := isProbabilityMeasure_map hX.aemeasurable
  have h0 : F ν 0 = 0 := hits.1
  have hint := integrable_bdd ν (F_aff_meas ν x θ) (fun t => F_abs_le ν _)
  -- source :191 "conditioning, using the independence": the law of (X₁,X₂) is ν ⊗ ν
  have hjoint : μ.map (fun ω => (X₁ ω, X₂ ω)) = ν.prod ν := by
    rw [(indepFun_iff_map_prod_eq_prod_map_map hX₁.aemeasurable hX₂.aemeasurable).1 hind,
      h1.map_eq, h2.map_eq]
  set S : Set (ℝ × ℝ) := {p | θ * p.1 + (1 - θ) * p.2 ≤ x} with hS
  have hSm : MeasurableSet S :=
    measurableSet_le (by fun_prop) measurable_const
  have key : μ {ω | θ * X₁ ω + (1 - θ) * X₂ ω ≤ x}
      = ENNReal.ofReal (∫ a, F ν ((x - θ * a) / (1 - θ)) ∂ν) := by
    rw [ofReal_integral_eq_lintegral_ofReal hint (ae_of_all _ (fun a => F_nonneg ν _))]
    have e : {ω | θ * X₁ ω + (1 - θ) * X₂ ω ≤ x} = (fun ω => (X₁ ω, X₂ ω)) ⁻¹' S := rfl
    rw [e, ← Measure.map_apply (hX₁.prodMk hX₂) hSm, hjoint, Measure.prod_apply hSm]
    refine lintegral_congr (fun a => ?_)
    show ν _ = ENNReal.ofReal (cdf ν ((x - θ * a) / (1 - θ)))
    rw [ofReal_cdf ν]
    congr 1
    ext b
    simp only [Set.mem_preimage, hS, Set.mem_setOf_eq, Set.mem_Iic]
    rw [le_div_iff₀ h1θ]
    constructor <;> intro h <;> nlinarith
  -- restrict the integral to [0, x/θ]: integrand vanishes above x/θ, law has no mass below 0
  have hrestr : ∫ t in Set.Icc 0 (x / θ), F ν ((x - θ * t) / (1 - θ)) ∂ν
      = ∫ a, F ν ((x - θ * a) / (1 - θ)) ∂ν := by
    apply setIntegral_eq_integral_of_ae_compl_eq_zero
    have hneg : ∀ᵐ t ∂ν, 0 ≤ t := by
      rw [ae_iff]
      have : ν (Set.Iic 0) = 0 := by
        rw [← ofReal_cdf ν 0]; have h0' : cdf ν 0 = 0 := h0
        rw [h0']; simp
      refine measure_mono_null ?_ this
      intro t ht; simp only [Set.mem_setOf_eq, not_le] at ht; exact ht.le
    filter_upwards [hneg] with t ht htc
    have htc' : x / θ < t := lt_of_not_ge fun hle => htc ⟨ht, hle⟩
    have : (x - θ * t) / (1 - θ) ≤ 0 := by
      apply div_nonpos_of_nonpos_of_nonneg _ h1θ.le
      have := (div_lt_iff₀ hθ0).1 htc'
      linarith
    have := F_mono ν this
    rw [h0] at this
    exact le_antisymm this (F_nonneg ν _)
  have hmeas : MeasurableSet {ω | θ * X₁ ω + (1 - θ) * X₂ ω ≤ x} :=
    measurableSet_le (by fun_prop) measurable_const
  have hcompl : {ω | x < θ * X₁ ω + (1 - θ) * X₂ ω} = {ω | θ * X₁ ω + (1 - θ) * X₂ ω ≤ x}ᶜ := by
    ext ω; simp
  rw [hcompl, ← measureReal_def, measureReal_compl hmeas]
  simp only [measureReal_def, measure_univ, ENNReal.toReal_one]
  rw [key, hrestr, ENNReal.toReal_ofReal (integral_nonneg (fun a => F_nonneg ν _))]

/-- S2.  Source :195-198: "To find an upper bound for the integral, we consider the
decomposition described in Figure 1, from which follows easily that
`∫_0^{x/θ} F_X((x-θt)/(1-θ)) F_X(dt) ≤ F_X(x/(1-θ))F_X(x) + F_X(x)(F_X(x/θ) - F_X(x))`."
Role: split `[0,x/θ]` into `[0,x]` (integrand `≤ F_X(x/(1-θ))`, mass `F_X(x)`, uses `F_X(0)=0`)
and `(x,x/θ]` (integrand `≤ F_X(x)`, mass `F_X(x/θ)-F_X(x)`).  Uses: nothing. -/
theorem T02_S2 (ν : Measure ℝ) [IsProbabilityMeasure ν] (h0 : F ν 0 = 0)
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    ∫ t in Set.Icc 0 (x / θ), F ν ((x - θ * t) / (1 - θ)) ∂ν
      ≤ F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) := by
  obtain ⟨hθ0, hθ1⟩ := hθ
  have h1θ : 0 < 1 - θ := by linarith
  have hxc : x ≤ x / θ := by
    rw [le_div_iff₀ hθ0]; nlinarith
  have hint := integrable_bdd ν (F_aff_meas ν x θ) (fun t => F_abs_le ν _)
  -- source :196-198 (Figure 1): split [0,x/θ] = [0,x] ∪ (x,x/θ]
  rw [← Set.Icc_union_Ioc_eq_Icc hx hxc,
    setIntegral_union (Set.disjoint_left.2 fun t h1 h2 => absurd h2.1 (not_lt.2 h1.2)) measurableSet_Ioc hint.integrableOn
      hint.integrableOn]
  have hA : ∫ t in Set.Icc 0 x, F ν ((x - θ * t) / (1 - θ)) ∂ν
      ≤ ∫ t in Set.Icc 0 x, F ν (x / (1 - θ)) ∂ν := by
    apply setIntegral_mono_on hint.integrableOn (integrableOn_const.2 (Or.inr (measure_lt_top _ _)))
      measurableSet_Icc
    intro t ht
    apply F_mono
    rw [div_le_div_iff_of_pos_right h1θ]
    nlinarith [ht.1]
  have hB : ∫ t in Set.Ioc x (x / θ), F ν ((x - θ * t) / (1 - θ)) ∂ν
      ≤ ∫ t in Set.Ioc x (x / θ), F ν x ∂ν := by
    apply setIntegral_mono_on hint.integrableOn (integrableOn_const.2 (Or.inr (measure_lt_top _ _)))
      measurableSet_Ioc
    intro t ht
    apply F_mono
    rw [div_le_iff₀ h1θ]
    nlinarith [ht.1]
  rw [setIntegral_const] at hA hB
  simp only [smul_eq_mul] at hA hB
  rw [real_Ioc ν hxc] at hB
  have := real_Icc_le ν x
  have h2 := F_nonneg ν (x / (1 - θ))
  nlinarith [mul_le_mul_of_nonneg_right this h2]

/-- S3.  Source :198-201: "`≤ F_X(x)`, using (eq:sub-1x) for the last inequality."
Role: `F(x)(F(x/(1-θ)) + F(x/θ) - F(x)) ≤ F(x)` from (eq:sub-1x) and `F(x) ≥ 0`.
Uses: `T02_L01Consumed` (to get (eq:sub-1x) from InvSub). -/
theorem T02_S3 (hL01 : T02_L01Consumed) (ν : Measure ℝ) [IsProbabilityMeasure ν]
    (hits : IsInvSub ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    F ν (x / (1 - θ)) * F ν x + F ν x * (F ν (x / θ) - F ν x) ≤ F ν x := by
  have hs := hL01 ν hits x hx θ hθ
  have := F_nonneg ν x
  nlinarith [mul_le_mul_of_nonneg_left hs this]

/-- S4.  Source :217: "So, it follows that `P(θX₁+(1-θ)X₂ > x) ≥ 1 - F_X(x) = P(X > x)`, so
(eq:main-st) holds for `n=2`."
Role: combine S1-S3 for `x ≥ 0`.  The source treats only `x ≥ 0` (:191); Definition 2.1 requires
all real `x` (the case `x < 0` is not written; gate point).  Weights `θ ∈ (0,1)` only (`θ₁,θ₂>0`).
Uses: S1, S2, S3. -/
theorem T02_S4 (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X X₁ X₂ : Ω → ℝ) (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hind : IndepFun X₁ X₂ μ) (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hits : IsInvSub (μ.map X)) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) := by
  intro x
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hX.aemeasurable
  by_cases hx : 0 ≤ x
  · have hY : Measurable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) := by fun_prop
    rw [← ENNReal.toReal_le_toReal (measure_ne_top _ _) (measure_ne_top _ _),
      prob_gt_eq_Fbar μ X hX x, T02_S1 μ X X₁ X₂ hX hX₁ hX₂ hind h1 h2 hits x hx θ hθ]
    have e2 := T02_S2 (μ.map X) hits.1 x hx θ hθ
    have e3 := T02_S3 hL01 (μ.map X) hits x hx θ hθ
    unfold Fbar
    linarith
  · have hx' : x < 0 := not_le.1 hx
    apply stdom_neg μ X _ _ hx'
    have a1 := ae_nonneg_of_ident μ X X₁ hX hX₁ h1 hits.1
    have a2 := ae_nonneg_of_ident μ X X₂ hX hX₂ h2 hits.1
    filter_upwards [a1, a2] with ω b1 b2
    have := hθ.1.le
    have := (sub_pos.2 hθ.2).le
    positivity

/-! ### Induction step (source :219-256) -/

section InductionStep

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X : Ω → ℝ) {n : ℕ} (Xs : Fin (n + 1) → Ω → ℝ) (θ : Fin (n + 1) → ℝ)

/-- S5 (STOPPED, gap).  Source :219-222: "Given `θ₁,…,θₙ > 0` with `∑ θᵢ = 1`,
`P(θ₁X₁+⋯+θₙXₙ > x) = P(Xₙ ≥ x/θₙ) + P(θ₁X₁+⋯+θₙXₙ ≥ x, Xₙ ≤ x/θₙ)`."
The events `{Xₙ ≥ c}` and `{Xₙ ≤ c}` overlap on `{Xₙ = c}`; false with an atom at `c`.
Full ∀-closure of the type of `T02_S5`. -/
def T02_S5_Gap : Prop :=
  ∀ {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) {n : ℕ} (Xs : Fin (n + 1) → Ω → ℝ) (θ : Fin (n + 1) → ℝ)
    (_hiid : IIDCopies μ X Xs) (_hits : IsInvSub (μ.map X))
    (_hθ : ∀ i, 0 < θ i) (_hsum : ∑ i, θ i = 1) (x : ℝ) (_hx : 0 ≤ x),
    (μ {ω | x < ∑ i, θ i * Xs i ω}).toReal
      = (μ {ω | x / θ (Fin.last n) ≤ Xs (Fin.last n) ω}).toReal
        + (μ {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θ (Fin.last n)}).toReal

/-- S6a (STOPPED, gap).  Source :223: first term `= F̄_X(x/θₙ)`, i.e. `P(Xₙ ≥ x/θₙ) = F̄_X(x/θₙ)`.
Fails if `X` has an atom at `c`.  Full ∀-closure of the type of `T02_S6a`. -/
def T02_S6a_Gap : Prop :=
  ∀ {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) {n : ℕ} (Xs : Fin (n + 1) → Ω → ℝ) (θ : Fin (n + 1) → ℝ)
    (_hiid : IIDCopies μ X Xs) (_hits : IsInvSub (μ.map X))
    (_hθ : ∀ i, 0 < θ i) (x : ℝ) (_hx : 0 ≤ x),
    (μ {ω | x / θ (Fin.last n) ≤ Xs (Fin.last n) ω}).toReal
      = Fbar (μ.map X) (x / θ (Fin.last n))

/-- S6b.  Source :223-224: "`P(θ₁X₁+⋯+θₙXₙ ≥ x, Xₙ ≤ x/θₙ) = ∫_0^{x/θₙ}
P((θ₁X₁+⋯+θ_{n-1}X_{n-1})/(1-θₙ) ≥ (x-θₙt)/(1-θₙ)) F_X(dt)`."
Conditioning on `Xₙ = t` using independence of `Xₙ` from the others (same justification as S1,
INVENTORY X05).  `∫_0^{x/θₙ}` read as the closed interval `[0,x/θₙ]`.  Uses: nothing.
The binder `hn : 2 ≤ n` is the source's induction range (:219, step for `n ≥ 3` variables;
here `n + 1` copies); at `n = 0` the statement is false (gate amendment 1). -/
theorem T02_S6b (hn : 2 ≤ n) (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1) (x : ℝ) (hx : 0 ≤ x) :
    (μ {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θ (Fin.last n)}).toReal
      = ∫ t in Set.Icc 0 (x / θ (Fin.last n)),
          (μ {ω | (x - θ (Fin.last n) * t) / (1 - θ (Fin.last n))
              ≤ (∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last n))}).toReal
          ∂(μ.map X) := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hiid.meas.aemeasurable
  set ν := μ.map X with hν
  set θn := θ (Fin.last n) with hθn
  have hθn0 : 0 < θn := hθ _
  have hθn1 : θn < 1 := last_lt_one θ (by omega) hθ hsum
  have h1θ : 0 < 1 - θn := by linarith
  set c := x / θn with hc
  set R : Ω → ℝ := fun ω => ∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω with hR
  have hRm : Measurable R :=
    Finset.measurable_sum _ (fun i _ => (hiid.measXs _).const_mul _)
  have hXlm : Measurable (Xs (Fin.last n)) := hiid.measXs _
  -- independence of `Xₙ` and `θ₁X₁+⋯+θ_{n-1}X_{n-1}` (source :223 "using independence")
  have hindf : iIndepFun (fun i ω => θ i * Xs i ω) μ :=
    hiid.indep.comp (fun i (z : ℝ) => θ i * z) (fun i => measurable_const.mul measurable_id)
  have hind0 : IndepFun (∑ j ∈ Finset.univ.erase (Fin.last n), (fun ω => θ j * Xs j ω))
      (fun ω => θ (Fin.last n) * Xs (Fin.last n) ω) μ :=
    hindf.indepFun_finset_sum_of_not_mem
      (fun i => measurable_const.mul (hiid.measXs i)) (Finset.not_mem_erase _ _)
  have hsumR : (∑ j ∈ Finset.univ.erase (Fin.last n), (fun ω => θ j * Xs j ω)) = R := by
    ext ω
    have e1 : ∑ i, θ i * Xs i ω = ∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω
        + θ (Fin.last n) * Xs (Fin.last n) ω := Fin.sum_univ_castSucc (fun i => θ i * Xs i ω)
    have e2 : θ (Fin.last n) * Xs (Fin.last n) ω
        + ∑ j ∈ Finset.univ.erase (Fin.last n), θ j * Xs j ω = ∑ i, θ i * Xs i ω :=
      Finset.add_sum_erase Finset.univ (fun i => θ i * Xs i ω) (Finset.mem_univ (Fin.last n))
    rw [Finset.sum_apply]
    simp only [hR]
    linarith
  rw [hsumR] at hind0
  have hindep : IndepFun (Xs (Fin.last n)) R μ := by
    have h := hind0.comp (φ := id) (ψ := fun z : ℝ => θn⁻¹ * z) measurable_id
      (measurable_const.mul measurable_id)
    have e : ((fun z : ℝ => θn⁻¹ * z) ∘ fun ω => θn * Xs (Fin.last n) ω) = Xs (Fin.last n) := by
      ext ω; simp only [Function.comp_apply]; field_simp
    rw [e] at h
    exact h.symm
  set ρ := μ.map R with hρ
  haveI : IsProbabilityMeasure ρ := isProbabilityMeasure_map hRm.aemeasurable
  have hjoint : μ.map (fun ω => (Xs (Fin.last n) ω, R ω)) = ν.prod ρ := by
    rw [(indepFun_iff_map_prod_eq_prod_map_map hXlm.aemeasurable hRm.aemeasurable).1 hindep,
      (hiid.ident _).map_eq]
  set T : Set (ℝ × ℝ) := {p | x ≤ p.2 + θn * p.1 ∧ p.1 ≤ c} with hT
  have hTm : MeasurableSet T := by
    have h1 : MeasurableSet {p : ℝ × ℝ | x ≤ p.2 + θn * p.1} :=
      measurableSet_le measurable_const (by fun_prop)
    have h2 : MeasurableSet {p : ℝ × ℝ | p.1 ≤ c} :=
      measurableSet_le measurable_fst measurable_const
    exact h1.inter h2
  have hev : {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θn}
      = (fun ω => (Xs (Fin.last n) ω, R ω)) ⁻¹' T := by
    ext ω
    simp only [Set.mem_setOf_eq, Set.mem_preimage, hT]
    rw [Fin.sum_univ_castSucc]
  have h1 : μ {ω | x ≤ ∑ i, θ i * Xs i ω ∧ Xs (Fin.last n) ω ≤ x / θn}
      = ∫⁻ t, ρ (Prod.mk t ⁻¹' T) ∂ν := by
    rw [hev, ← Measure.map_apply (hXlm.prodMk hRm) hTm, hjoint, Measure.prod_apply hTm]
  have h2 : ∀ t, ρ (Prod.mk t ⁻¹' T)
      = Set.indicator (Set.Iic c) (fun t => ρ (Set.Ici (x - θn * t))) t := by
    intro t
    by_cases ht : t ≤ c
    · rw [Set.indicator_of_mem (show t ∈ Set.Iic c from ht)]
      congr 1
      ext r
      simp only [Set.mem_preimage, Set.mem_setOf_eq, Set.mem_Ici, hT]
      constructor
      · rintro ⟨h, _⟩; linarith
      · intro h; exact ⟨by linarith, ht⟩
    · rw [Set.indicator_of_not_mem (show t ∉ Set.Iic c from ht)]
      have : Prod.mk t ⁻¹' T = ∅ := by
        ext r; simp [hT, ht]
      rw [this]; simp
  have hneg : ∀ᵐ t ∂ν, 0 ≤ t := by
    rw [ae_iff]
    have : ν (Set.Iic 0) = 0 := by
      rw [← ofReal_cdf ν 0]; have h0' : cdf ν 0 = 0 := hits.1
      rw [h0']; simp
    refine measure_mono_null ?_ this
    intro t ht; simp only [Set.mem_setOf_eq, not_le] at ht; exact ht.le
  have h3 : ∫⁻ t, ρ (Prod.mk t ⁻¹' T) ∂ν
      = ∫⁻ t in Set.Icc 0 c, ρ (Set.Ici (x - θn * t)) ∂ν := by
    rw [← lintegral_indicator measurableSet_Icc]
    refine lintegral_congr_ae ?_
    filter_upwards [hneg] with t ht
    rw [h2 t]
    by_cases htc : t ≤ c
    · rw [Set.indicator_of_mem (show t ∈ Set.Iic c from htc),
        Set.indicator_of_mem (show t ∈ Set.Icc 0 c from ⟨ht, htc⟩)]
    · rw [Set.indicator_of_not_mem (show t ∉ Set.Iic c from htc),
        Set.indicator_of_not_mem (show t ∉ Set.Icc 0 c from fun h => htc h.2)]
  have hgm : Measurable fun t : ℝ => ρ (Set.Ici (x - θn * t)) := by
    have hs : MeasurableSet {p : ℝ × ℝ | x - θn * p.1 ≤ p.2} :=
      measurableSet_le (by fun_prop) measurable_snd
    exact measurable_measure_prodMk_left hs
  rw [h1, h3, ← integral_toReal hgm.aemeasurable (ae_of_all _ (fun t => measure_lt_top _ _))]
  refine setIntegral_congr_fun measurableSet_Icc (fun t _ => ?_)
  rw [hρ, Measure.map_apply hRm measurableSet_Ici]
  congr 2
  ext ω
  simp only [Set.mem_preimage, Set.mem_Ici, Set.mem_setOf_eq]
  rw [div_le_div_iff_of_pos_right h1θ]

/-- S7.  Source :224-225: "`≥ F̄_X(x/θₙ) + ∫_0^{x/θₙ} F̄_X((x-θₙt)/(1-θₙ)) F_X(dt)`, using the
induction hypothesis."  The induction hypothesis is (eq:main-st) for the `n` copies
`X₁,…,X_{n}` (here `Fin n`) with the normalised weights `θᵢ/(1-θₙ)` (:219 "(eq:main-st) holds
whenever considering `n-1` random variables"; the normalisation is implicit).  Role: the
integrand bound `P(Y ≥ y) ≥ P(Y > y) ≥ F̄_X(y)` and monotonicity of the integral.
Uses: the induction hypothesis `hIH`. -/
theorem T02_S7 (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X))
    (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hIH : StDom μ X (fun ω => ∑ i : Fin n, (θ i.castSucc / (1 - θ (Fin.last n))) * Xs i.castSucc ω))
    (x : ℝ) (hx : 0 ≤ x) :
    ∫ t in Set.Icc 0 (x / θ (Fin.last n)), Fbar (μ.map X) ((x - θ (Fin.last n) * t) / (1 - θ (Fin.last n)))
        ∂(μ.map X)
      ≤ ∫ t in Set.Icc 0 (x / θ (Fin.last n)),
          (μ {ω | (x - θ (Fin.last n) * t) / (1 - θ (Fin.last n))
              ≤ (∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω) / (1 - θ (Fin.last n))}).toReal
          ∂(μ.map X) := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hiid.meas.aemeasurable
  set θn := θ (Fin.last n) with hθn
  set R : Ω → ℝ := fun ω => ∑ i : Fin n, θ i.castSucc * Xs i.castSucc ω with hR
  have hRm : Measurable R :=
    Finset.measurable_sum _ (fun i _ => (hiid.measXs _).const_mul _)
  have hg := meas_cond μ R hRm x θn (1 - θn)
  have hint1 := integrable_bdd (μ.map X) (Fbar_aff_meas (μ.map X) x θn)
    (fun t => Fbar_abs_le _ _)
  have hint2 : Integrable (fun t : ℝ => (μ {ω | (x - θn * t) / (1 - θn) ≤ R ω / (1 - θn)}).toReal)
      (μ.map X) :=
    integrable_bdd (μ.map X) hg (fun t => by
      rw [abs_of_nonneg ENNReal.toReal_nonneg]; exact toReal_le_one' μ _)
  apply setIntegral_mono_on hint1.integrableOn hint2.integrableOn measurableSet_Icc
  intro t _
  -- source :225 "using the induction hypothesis": P(X>y) ≤ P(Y>y) ≤ P(Y≥y)
  have hY : ∀ ω, ∑ i : Fin n, (θ i.castSucc / (1 - θn)) * Xs i.castSucc ω = R ω / (1 - θn) := by
    intro ω
    simp only [hR, Finset.sum_div]
    exact Finset.sum_congr rfl (fun i _ => by ring)
  set y := (x - θn * t) / (1 - θn) with hy
  have h1 := hIH y
  rw [← ENNReal.toReal_le_toReal (measure_ne_top _ _) (measure_ne_top _ _),
    prob_gt_eq_Fbar μ X hiid.meas y] at h1
  refine h1.trans (ENNReal.toReal_mono (measure_ne_top _ _) (measure_mono ?_))
  intro ω hω
  simp only [Set.mem_setOf_eq] at hω ⊢
  rw [hY ω] at hω
  exact hω.le

end InductionStep

/-! ### Figure 2 decomposition and the final estimates (source :246-256) -/

section Estimates

variable (ν : Measure ℝ) [IsProbabilityMeasure ν]

/-- S8.  Source :246-252: "using the decomposition depicted in Figure 2, from which follows that
`∫_0^{x/θₙ} F̄_X((x-θₙt)/(1-θₙ)) F_X(dt) ≥ F̄_X(x/(1-θₙ))F_X(x) + F̄_X(x)(F_X(x/θₙ)-F_X(x))`."
(`θ` stands for `θₙ ∈ (0,1)`.)  Role: lower bound, mirror of S2 (uses `F_X(0)=0`). Uses: nothing. -/
theorem T02_S8 (h0 : F ν 0 = 0) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν (x / (1 - θ)) * F ν x + Fbar ν x * (F ν (x / θ) - F ν x)
      ≤ ∫ t in Set.Icc 0 (x / θ), Fbar ν ((x - θ * t) / (1 - θ)) ∂ν := by
  obtain ⟨hθ0, hθ1⟩ := hθ
  have h1θ : 0 < 1 - θ := by linarith
  have hxc : x ≤ x / θ := by
    rw [le_div_iff₀ hθ0]; nlinarith
  have hint := integrable_bdd ν (Fbar_aff_meas ν x θ) (fun t => Fbar_abs_le ν _)
  -- source :247-252 (Figure 2): split [0,x/θ] = [0,x] ∪ (x,x/θ]
  rw [← Set.Icc_union_Ioc_eq_Icc hx hxc,
    setIntegral_union (Set.disjoint_left.2 fun t h1 h2 => absurd h2.1 (not_lt.2 h1.2))
      measurableSet_Ioc hint.integrableOn hint.integrableOn]
  have hA : ∫ t in Set.Icc 0 x, Fbar ν (x / (1 - θ)) ∂ν
      ≤ ∫ t in Set.Icc 0 x, Fbar ν ((x - θ * t) / (1 - θ)) ∂ν := by
    apply setIntegral_mono_on (integrableOn_const.2 (Or.inr (measure_lt_top _ _)))
      hint.integrableOn measurableSet_Icc
    intro t ht
    apply Fbar_anti
    rw [div_le_div_iff_of_pos_right h1θ]
    nlinarith [ht.1]
  have hB : ∫ t in Set.Ioc x (x / θ), Fbar ν x ∂ν
      ≤ ∫ t in Set.Ioc x (x / θ), Fbar ν ((x - θ * t) / (1 - θ)) ∂ν := by
    apply setIntegral_mono_on (integrableOn_const.2 (Or.inr (measure_lt_top _ _)))
      hint.integrableOn measurableSet_Ioc
    intro t ht
    apply Fbar_anti
    rw [div_le_iff₀ h1θ]
    nlinarith [ht.1]
  rw [setIntegral_const] at hA hB
  simp only [smul_eq_mul] at hA hB
  rw [real_Ioc ν hxc] at hB
  rw [real_Icc_eq ν h0 hx] at hA
  linarith

/-- S9.  Source :252-254, third line: the algebraic rewriting
`F̄(x/θ) + F̄(x/(1-θ))F(x) + F̄(x)(F(x/θ)-F(x)) ≥ F̄(x/θ) + F̄(x/(1-θ))
 + F̄(x)(F̄(x) - F̄(x/θ) - F̄(x/(1-θ)))` (with `F = 1 - F̄`; it is an equality).  Uses: nothing. -/
theorem T02_S9 (x : ℝ) (θ : ℝ) :
    Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) + Fbar ν x * (Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ)))
      ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) * F ν x + Fbar ν x * (F ν (x / θ) - F ν x) := by
  unfold Fbar
  nlinarith

/-- S10a.  Source :256: "(eq:sub-1x) written in terms of the survival function":
`F̄(x) ≤ F̄(x/θ) + F̄(x/(1-θ))`, i.e. the large parenthesis
`F̄(x) - F̄(x/θ) - F̄(x/(1-θ))` is `≤ 0` ("negative").  Uses: (eq:sub-1x) (`SubCond`, obtained
from InvSub through `T02_L01Consumed` in the assembly). -/
theorem T02_S10a (hsub : SubCond ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ)) ≤ 0 := by
  have := hsub x hx θ hθ
  unfold Fbar
  linarith

/-- S10b (STOPPED, gap).  Source :256: "Finally, noting that the subadditivity assumption implies
that the large parenthesis is negative, it follows that
`P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄_X(x/θₙ) + F̄_X(x/(1-θₙ))`."  Dropping the nonpositive term
`F̄(x)·(parenthesis)` gives an upper, not a lower, bound.  Full ∀-closure of the type of
`T02_S10b` (`ν` and its instance are the section variables). -/
def T02_S10b_Gap : Prop :=
  ∀ (ν : Measure ℝ) [IsProbabilityMeasure ν] (_hsub : SubCond ν) (x : ℝ) (_hx : 0 ≤ x) (θ : ℝ)
    (_hθ : θ ∈ Set.Ioo (0:ℝ) 1),
    Fbar ν (x / θ) + Fbar ν (x / (1 - θ))
      ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ))
        + Fbar ν x * (Fbar ν x - Fbar ν (x / θ) - Fbar ν (x / (1 - θ)))

/-- S11.  Source :256: "`≥ F̄_X(x/θₙ) + F̄_X(x/(1-θₙ)) ≥ F̄_X(x)`, using (eq:sub-1x) written in
terms of the survival function."  The last inequality (same content as S10a).  Uses: SubCond. -/
theorem T02_S11 (hsub : SubCond ν) (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (hθ : θ ∈ Set.Ioo (0:ℝ) 1) :
    Fbar ν x ≤ Fbar ν (x / θ) + Fbar ν (x / (1 - θ)) := by
  have := T02_S10a ν hsub x hx θ hθ
  linarith

end Estimates

/-! ### Assembly of the main theorem modulo gaps (source :186-189, :219-256) -/

/-- Non-numbered gap (EXPOSITION_GAP candidate): the proof (:219) treats weights `θᵢ > 0` only,
whereas the theorem (:95, :186) allows `θᵢ ≥ 0`; the reduction of zero weights to fewer variables
is not written in the source.  `T02_PosVersion` is the strictly positive weight case. -/
def T02_PosVersion : Prop :=
  ∀ {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ), IIDCopies μ X Xs → IsInvSub (μ.map X) →
    ∀ θ : Fin n → ℝ, (∀ i, 0 < θ i) → ∑ i, θ i = 1 →
      StDom μ X (fun ω => ∑ i, θ i * Xs i ω)

def T02_ZeroWeights_Gap : Prop :=
  T02_PosVersion →
  ∀ {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ), IIDCopies μ X Xs → IsInvSub (μ.map X) →
    ∀ θ : Fin n → ℝ, (∀ i, 0 ≤ θ i) → ∑ i, θ i = 1 →
      StDom μ X (fun ω => ∑ i, θ i * Xs i ω)

/-- Induction step of the source (:219-256) with `n + 1` copies, `n ≥ 2`. -/
private theorem pos_step (hL01 : T02_L01Consumed) (hG5 : T02_S5_Gap) (hG6a : T02_S6a_Gap)
    (hG10b : T02_S10b_Gap)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) {n : ℕ} (hn : 2 ≤ n) (Xs : Fin (n + 1) → Ω → ℝ) (θ : Fin (n + 1) → ℝ)
    (hiid : IIDCopies μ X Xs) (hits : IsInvSub (μ.map X)) (hθ : ∀ i, 0 < θ i)
    (hsum : ∑ i, θ i = 1)
    (hIH : StDom μ X (fun ω => ∑ i : Fin n, (θ i.castSucc / (1 - θ (Fin.last n))) * Xs i.castSucc ω)) :
    StDom μ X (fun ω => ∑ i, θ i * Xs i ω) := by
  intro x
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hiid.meas.aemeasurable
  by_cases hx : 0 ≤ x
  · have hθn1 := last_lt_one θ (by omega) hθ hsum
    have hθn : θ (Fin.last n) ∈ Set.Ioo (0:ℝ) 1 := ⟨hθ _, hθn1⟩
    have hsub : SubCond (μ.map X) := hL01 _ hits
    have e5 := hG5 μ X Xs θ hiid hits hθ hsum x hx
    have e6a := hG6a μ X Xs θ hiid hits hθ x hx
    have e6b := T02_S6b μ X Xs θ hn hiid hits hθ hsum x hx
    have e7 := T02_S7 μ X Xs θ hiid hits hθ hsum hIH x hx
    have e8 := T02_S8 (μ.map X) hits.1 x hx _ hθn
    have e9 := T02_S9 (μ.map X) x (θ (Fin.last n))
    have e10 := hG10b (μ.map X) hsub x hx _ hθn
    have e11 := T02_S11 (μ.map X) hsub x hx _ hθn
    rw [← ENNReal.toReal_le_toReal (measure_ne_top _ _) (measure_ne_top _ _),
      prob_gt_eq_Fbar μ X hiid.meas x, e5, e6a, e6b]
    linarith
  · have hx' : x < 0 := not_le.1 hx
    apply stdom_neg μ X _ _ hx'
    have hall : ∀ᵐ ω ∂μ, ∀ i, 0 ≤ Xs i ω :=
      ae_all_iff.2 (fun i => ae_nonneg_of_ident μ X (Xs i) hiid.meas (hiid.measXs i)
        (hiid.ident i) hits.1)
    filter_upwards [hall] with ω hω
    exact Finset.sum_nonneg (fun i _ => mul_nonneg (hθ i).le (hω i))

private theorem pos_all (hL01 : T02_L01Consumed) (hG5 : T02_S5_Gap) (hG6a : T02_S6a_Gap)
    (hG10b : T02_S10b_Gap) : T02_PosVersion := by
  intro Ω _ μ _ n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro X Xs hiid hits θ hθ hsum
    obtain rfl | rfl | rfl | hn : n = 0 ∨ n = 1 ∨ n = 2 ∨ 3 ≤ n := by omega
    · simp at hsum
    · -- single copy: `θ₀ = 1`, `Y = X₀ ~ X`
      have hθ0 : θ 0 = 1 := by simpa using hsum
      intro x
      have e : (fun ω => ∑ i, θ i * Xs i ω) = Xs 0 := by
        ext ω; simp [hθ0]
      rw [e]
      exact ((hiid.ident 0).measure_mem_eq (measurableSet_Ioi (a := x))).symm.le
    · -- n = 2 (source :191-217)
      have h1 : θ 0 + θ 1 = 1 := by simpa [Fin.sum_univ_two] using hsum
      have hmem : θ 0 ∈ Set.Ioo (0:ℝ) 1 := ⟨hθ 0, by linarith [hθ 1]⟩
      have h4 := T02_S4 hL01 μ X (Xs 0) (Xs 1) hiid.meas (hiid.measXs 0) (hiid.measXs 1)
        (hiid.indep.indepFun (by decide)) (hiid.ident 0) (hiid.ident 1) hits (θ 0) hmem
      have e : (fun ω => ∑ i, θ i * Xs i ω) = fun ω => θ 0 * Xs 0 ω + (1 - θ 0) * Xs 1 ω := by
        ext ω
        rw [Fin.sum_univ_two]
        have : θ 1 = 1 - θ 0 := by linarith
        rw [this]
      rw [e]
      exact h4
    · obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
      have hm : 2 ≤ m := by omega
      have hθn1 := last_lt_one θ (by omega) hθ hsum
      have h1θ : 0 < 1 - θ (Fin.last m) := by linarith
      have hiid' : IIDCopies μ X (fun i : Fin m => Xs i.castSucc) :=
        ⟨hiid.meas, fun i => hiid.measXs _, hiid.indep.precomp (Fin.castSucc_injective m),
          fun i => hiid.ident _⟩
      have hpos : ∀ i : Fin m, 0 < θ i.castSucc / (1 - θ (Fin.last m)) :=
        fun i => div_pos (hθ _) h1θ
      have hsum' : ∑ i : Fin m, θ i.castSucc / (1 - θ (Fin.last m)) = 1 := by
        rw [← Finset.sum_div]
        have := hsum
        rw [Fin.sum_univ_castSucc] at this
        rw [div_eq_one_iff_eq h1θ.ne']
        linarith
      have hIH := ih m (by omega) X (fun i : Fin m => Xs i.castSucc) hiid' hits
        (fun i : Fin m => θ i.castSucc / (1 - θ (Fin.last m))) hpos hsum'
      exact pos_step hL01 hG5 hG6a hG10b μ X hm Xs θ hiid hits hθ hsum hIH

/-- Theorem 3.1 (thm:main), modulo gaps: the stopped obligations `S5`, `S6a`, `S10b` and the
unwritten zero-weight reduction enter as the premises `hG5`, `hG6a`, `hG10b`, `hZ`. -/
theorem T02_main_mod_gaps (hG5 : T02_S5_Gap) (hG6a : T02_S6a_Gap) (hG10b : T02_S10b_Gap)
    (hZ : T02_ZeroWeights_Gap) (hL01 : T02_L01Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ) (hiid : IIDCopies μ X Xs)
    (hits : IsInvSub (μ.map X))
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 ≤ θ i) (hsum : ∑ i, θ i = 1) :
    StDom μ X (fun ω => ∑ i, θ i * Xs i ω) :=
  hZ (pos_all hL01 hG5 hG6a hG10b) μ X Xs hiid hits θ hθ hsum

end Paper.T02

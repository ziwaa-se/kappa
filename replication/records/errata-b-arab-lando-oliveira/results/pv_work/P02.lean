import P02Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P02

/-- Proposition 3.2 (prop:inf-mean), source :261-264.
"Let `X₁,…,Xₙ` be independent random variables such that `P(X₁=⋯=Xₙ)<1`, and `θ₁,…,θₙ>0`
with `θ₁+⋯+θₙ=1`. If (eq:main-st) holds, then `X` has infinite mean."
Encoding: `X` is not defined in the statement; following (eq:main-st) (:95-98) the `Xᵢ` are
i.i.d. copies of `X` (`IdentDistrib (Xs i) X`). No nonnegativity is assumed (none is printed). -/
theorem P02_main {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ)
    (hX : Measurable X) (hXs : ∀ i, Measurable (Xs i))
    (hindep : iIndepFun Xs μ)
    (hid : ∀ i, IdentDistrib (Xs i) X μ μ)
    (hne : μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1)
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hdom : StDom μ X (fun ω => ∑ i, θ i * Xs i ω)) :
    InfiniteMean μ X := by
  sorry

/-- S1. Source :266 "It is enough to prove the case n=2."  Reduction of general `n` to
`n = 2` (never justified in the source; INVENTORY X09). Uses: nothing (external to the n=2
argument). Role: reduces `P02_main` to `TwoCase`. -/
theorem P02_S1 (h2 : TwoCase) {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] {n : ℕ} (X : Ω → ℝ) (Xs : Fin n → Ω → ℝ)
    (hX : Measurable X) (hXs : ∀ i, Measurable (Xs i))
    (hindep : iIndepFun Xs μ)
    (hid : ∀ i, IdentDistrib (Xs i) X μ μ)
    (hne : μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1)
    (θ : Fin n → ℝ) (hθ : ∀ i, 0 < θ i) (hsum : ∑ i, θ i = 1)
    (hdom : StDom μ X (fun ω => ∑ i, θ i * Xs i ω)) :
    InfiniteMean μ X := by
  sorry

/-- Technical conversion (not in the source): for `Z ≥ 0` integrable, `√Z` is integrable
(`√z ≤ z + 1`). Used in S5 where the source silently integrates `√·`. -/
private theorem sqrt_integrable_aux {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Z : Ω → ℝ) (hZ : Measurable Z) (hnn : ∀ ω, 0 ≤ Z ω)
    (hi : Integrable Z μ) : Integrable (fun ω => Real.sqrt (Z ω)) μ := by
  refine Integrable.mono' (hi.add (integrable_const (1 : ℝ)))
    (Real.continuous_sqrt.measurable.comp hZ).aestronglyMeasurable
    (Filter.Eventually.of_forall fun ω => ?_)
  rw [Real.norm_eq_abs, abs_of_nonneg (Real.sqrt_nonneg _)]
  have h0 := hnn ω
  show Real.sqrt (Z ω) ≤ Z ω + 1
  refine (Real.sqrt_le_iff).2 ⟨by linarith, by nlinarith⟩

section TwoCaseSteps

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
  (X X₁ X₂ : Ω → ℝ) (θ : ℝ)

/-- S2. Source :266 "Moreover, assume E(X) is finite. As then follows that E(Y)=E(X), both
finite". Hypotheses: `X₁, X₂` copies of `X`, `X` integrable.  Uses: nothing. -/
theorem P02_S2 (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hint : Integrable X μ) :
    Integrable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) μ ∧
    ∫ ω, (θ * X₁ ω + (1 - θ) * X₂ ω) ∂μ = ∫ ω, X ω ∂μ := by
  have i1 : Integrable X₁ μ := h1.integrable_iff.2 hint
  have i2 : Integrable X₂ μ := h2.integrable_iff.2 hint
  have e1 : ∫ ω, X₁ ω ∂μ = ∫ ω, X ω ∂μ := h1.integral_eq
  have e2 : ∫ ω, X₂ ω ∂μ = ∫ ω, X ω ∂μ := h2.integral_eq
  refine ⟨(i1.const_mul θ).add (i2.const_mul (1 - θ)), ?_⟩
  rw [integral_add (i1.const_mul θ) (i2.const_mul (1 - θ)), integral_const_mul,
    integral_const_mul, e1, e2]
  ring

/-- S3. Source :266 "this, together with (eq:main-st), implies that X and Y have the same
distribution." (`X ≤st Y`, both integrable, equal means). Uses S2. -/
theorem P02_S3 (Y : Ω → ℝ) (hX : Measurable X) (hY : Measurable Y)
    (hdom : StDom μ X Y) (hXi : Integrable X μ) (hYi : Integrable Y μ)
    (hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ) :
    IdentDistrib X Y μ μ := by
  set A : Set (Ω × ℝ) := {p | X p.1 ≤ p.2 ∧ p.2 < Y p.1} with hA
  set B : Set (Ω × ℝ) := {p | Y p.1 ≤ p.2 ∧ p.2 < X p.1} with hB
  have hAm : MeasurableSet A :=
    (measurableSet_le (hX.comp measurable_fst) measurable_snd).inter
      (measurableSet_lt measurable_snd (hY.comp measurable_fst))
  have hBm : MeasurableSet B :=
    (measurableSet_le (hY.comp measurable_fst) measurable_snd).inter
      (measurableSet_lt measurable_snd (hX.comp measurable_fst))
  have hAl : (μ.prod volume) A = ∫⁻ ω, ENNReal.ofReal (Y ω - X ω) ∂μ := by
    rw [Measure.prod_apply hAm]
    refine lintegral_congr fun ω => ?_
    have : Prod.mk ω ⁻¹' A = Set.Ico (X ω) (Y ω) := by ext x; simp [hA]
    rw [this, Real.volume_Ico]
  have hBl : (μ.prod volume) B = ∫⁻ ω, ENNReal.ofReal (X ω - Y ω) ∂μ := by
    rw [Measure.prod_apply hBm]
    refine lintegral_congr fun ω => ?_
    have : Prod.mk ω ⁻¹' B = Set.Ico (Y ω) (X ω) := by ext x; simp [hB]
    rw [this, Real.volume_Ico]
  have hAx := Measure.prod_apply_symm (μ := μ) (ν := volume) hAm
  have hBx := Measure.prod_apply_symm (μ := μ) (ν := volume) hBm
  have hDi : Integrable (fun ω => Y ω - X ω) μ := hYi.sub hXi
  have h1 : ∫⁻ ω, ENNReal.ofReal (Y ω - X ω) ∂μ ≠ ⊤ := hDi.lintegral_lt_top.ne
  have h2 : ∫⁻ ω, ENNReal.ofReal (X ω - Y ω) ∂μ ≠ ⊤ := by
    have := hDi.neg.lintegral_lt_top
    simpa using this.ne
  have h3 : ∫⁻ ω, ENNReal.ofReal (X ω - Y ω) ∂μ = ∫⁻ ω, ENNReal.ofReal (Y ω - X ω) ∂μ := by
    have e := integral_eq_lintegral_pos_part_sub_lintegral_neg_part hDi
    have e0 : ∫ ω, (Y ω - X ω) ∂μ = 0 := by
      rw [integral_sub hYi hXi, hmean]; ring
    rw [e0] at e
    have e' : (∫⁻ ω, ENNReal.ofReal (-(Y ω - X ω)) ∂μ).toReal
        = (∫⁻ ω, ENNReal.ofReal (Y ω - X ω) ∂μ).toReal := by linarith
    have h2' : ∫⁻ ω, ENNReal.ofReal (-(Y ω - X ω)) ∂μ ≠ ⊤ := by simpa using h2
    have := (ENNReal.toReal_eq_toReal_iff' h2' h1).1 e'
    simpa using this
  -- sections
  have hsec : ∀ x : ℝ, μ {ω | x < Y ω} = μ ((fun ω => (ω, x)) ⁻¹' A) +
        μ ({ω | x < X ω} ∩ {ω | x < Y ω})
      ∧ μ {ω | x < X ω} = μ ((fun ω => (ω, x)) ⁻¹' B) +
        μ ({ω | x < X ω} ∩ {ω | x < Y ω}) := by
    intro x
    have mX : MeasurableSet {ω | x < X ω} := measurableSet_lt measurable_const hX
    have mY : MeasurableSet {ω | x < Y ω} := measurableSet_lt measurable_const hY
    constructor
    · have hd : Disjoint ((fun ω => (ω, x)) ⁻¹' A) ({ω | x < X ω} ∩ {ω | x < Y ω}) := by
        rw [Set.disjoint_left]; rintro ω h ⟨h', _⟩
        simp only [hA, Set.mem_preimage, Set.mem_setOf_eq] at h; exact absurd h.1 (not_le.2 h')
      rw [← measure_union hd (mX.inter mY)]
      congr 1; ext ω
      simp only [hA, Set.mem_setOf_eq, Set.mem_preimage, Set.mem_union, Set.mem_inter_iff]
      constructor
      · intro h; by_cases hx : x < X ω
        · exact Or.inr ⟨hx, h⟩
        · exact Or.inl ⟨not_lt.1 hx, h⟩
      · rintro (h | h)
        · exact h.2
        · exact h.2
    · have hd : Disjoint ((fun ω => (ω, x)) ⁻¹' B) ({ω | x < X ω} ∩ {ω | x < Y ω}) := by
        rw [Set.disjoint_left]; rintro ω h ⟨_, h'⟩
        simp only [hB, Set.mem_preimage, Set.mem_setOf_eq] at h; exact absurd h.1 (not_le.2 h')
      rw [← measure_union hd (mX.inter mY)]
      congr 1; ext ω
      simp only [hB, Set.mem_setOf_eq, Set.mem_preimage, Set.mem_union, Set.mem_inter_iff]
      constructor
      · intro h; by_cases hx : x < Y ω
        · exact Or.inr ⟨h, hx⟩
        · exact Or.inl ⟨not_lt.1 hx, h⟩
      · rintro (h | h)
        · exact h.2
        · exact h.1
  have hle : ∀ x : ℝ, μ ((fun ω => (ω, x)) ⁻¹' B) ≤ μ ((fun ω => (ω, x)) ⁻¹' A) := by
    intro x
    have := hdom x
    rw [(hsec x).1, (hsec x).2] at this
    exact (ENNReal.add_le_add_iff_right (measure_ne_top _ _)).1 this
  have hlint : ∫⁻ x, μ ((fun ω => (ω, x)) ⁻¹' A) ∂volume ≤
      ∫⁻ x, μ ((fun ω => (ω, x)) ⁻¹' B) ∂volume := by
    rw [← hAx, ← hBx, hAl, hBl, h3]
  have hfinB : ∫⁻ x, μ ((fun ω => (ω, x)) ⁻¹' B) ∂volume ≠ ⊤ := by
    rw [← hBx, hBl]; exact h2
  have hae0 := ae_eq_of_ae_le_of_lintegral_le (Filter.Eventually.of_forall hle) hfinB
    (measurable_measure_prodMk_right hAm).aemeasurable hlint
  have hae : ∀ᵐ x ∂(volume : Measure ℝ), μ {ω | x < X ω} = μ {ω | x < Y ω} := by
    filter_upwards [hae0] with x hx
    rw [(hsec x).1, (hsec x).2, hx]
  have hall : ∀ a, μ {ω | a < Y ω} ≤ μ {ω | a < X ω} := by
    intro a
    have key : ∀ k : ℕ, μ {ω | a + 1 / ((k : ℝ) + 1) < Y ω} ≤ μ {ω | a < X ω} := by
      intro k
      have hpos : (0 : ℝ) < 1 / ((k : ℝ) + 1) := by positivity
      obtain ⟨u, hu, hu1, hu2⟩ : ∃ u, μ {ω | u < X ω} = μ {ω | u < Y ω} ∧ a < u ∧
          u < a + 1 / ((k : ℝ) + 1) := by
        by_contra! hcon
        have hz : volume (Set.Ioo a (a + 1 / ((k : ℝ) + 1))) = 0 := by
          refine measure_mono_null ?_ (ae_iff.1 hae)
          intro u hu hu'
          exact absurd hu.2 (not_lt.2 (hcon u hu' hu.1))
        rw [Real.volume_Ioo] at hz
        simp at hz
        linarith
      calc μ {ω | a + 1 / ((k : ℝ) + 1) < Y ω} ≤ μ {ω | u < Y ω} :=
            measure_mono (fun ω hω => lt_trans hu2 hω)
        _ = μ {ω | u < X ω} := hu.symm
        _ ≤ μ {ω | a < X ω} := measure_mono (fun ω hω => lt_trans hu1 hω)
    have hU : {ω | a < Y ω} = ⋃ k : ℕ, {ω | a + 1 / ((k : ℝ) + 1) < Y ω} := by
      ext ω
      simp only [Set.mem_setOf_eq, Set.mem_iUnion]
      constructor
      · intro h
        obtain ⟨n, hn⟩ := exists_nat_one_div_lt (sub_pos.2 h)
        exact ⟨n, by linarith⟩
      · rintro ⟨k, hk⟩
        have : (0 : ℝ) < 1 / ((k : ℝ) + 1) := by positivity
        linarith
    have hmono : Monotone (fun k : ℕ => {ω | a + 1 / ((k : ℝ) + 1) < Y ω}) := by
      intro k m hkm ω hω
      simp only [Set.mem_setOf_eq] at hω ⊢
      have : 1 / ((m : ℝ) + 1) ≤ 1 / ((k : ℝ) + 1) := by
        apply one_div_le_one_div_of_le (by positivity)
        exact_mod_cast Nat.add_le_add_right hkm 1
      linarith
    rw [hU, hmono.measure_iUnion]
    exact iSup_le key
  have hEq : ∀ a, μ {ω | a < X ω} = μ {ω | a < Y ω} := fun a => le_antisymm (hdom a) (hall a)
  refine ⟨hX.aemeasurable, hY.aemeasurable, ?_⟩
  refine Measure.ext_of_Iic _ _ fun a => ?_
  rw [Measure.map_apply hX measurableSet_Iic, Measure.map_apply hY measurableSet_Iic]
  have e1 : X ⁻¹' Set.Iic a = {ω | a < X ω}ᶜ := by ext ω; simp
  have e2 : Y ⁻¹' Set.Iic a = {ω | a < Y ω}ᶜ := by ext ω; simp
  rw [e1, e2, prob_compl_eq_one_sub (measurableSet_lt measurable_const hX),
    prob_compl_eq_one_sub (measurableSet_lt measurable_const hY), hEq a]

/-- S4a. Source :266 "Therefore Var(√X) = Var(√Y)".  Nonnegativity of `X` is NOT printed;
it is assumed here only because `√` is used (a silent assumption, INVENTORY X14/X15).
Uses S3. -/
theorem P02_S4a (Y : Ω → ℝ) (hid : IdentDistrib X Y μ μ) :
    variance (fun ω => Real.sqrt (X ω)) μ = variance (fun ω => Real.sqrt (Y ω)) μ := by
  exact (hid.comp Real.continuous_sqrt.measurable).variance_eq

/-- S4b. Source :266 "implying that E(√X) = E(√Y)".  The step uses `E X = E Y` (S2, premise
`hmean`) and `Var √X = E X - (E√X)²` (for `X ≥ 0` integrable), so `(E√X)² = (E√Y)²` and
`E√· ≥ 0` give the claim (gate: FAIR_IMPLICIT_STEP).  The drafter's earlier suspicion of a gap
is forwarded to pv-issue-checker.  Stated in the context of the proof (all hypotheses of
the case, including dominance and the variance equality), without the equal-distribution
conclusion of S3.  Finite variance of `√X` is not noted in the source. -/
theorem P02_S4b (Y : Ω → ℝ) (hX : Measurable X) (hY : Measurable Y)
    (hnn : ∀ ω, 0 ≤ X ω) (hnnY : ∀ ω, 0 ≤ Y ω)
    (hXi : Integrable X μ) (hYi : Integrable Y μ)
    (hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ)
    (hdom : StDom μ X Y)
    (hvar : variance (fun ω => Real.sqrt (X ω)) μ = variance (fun ω => Real.sqrt (Y ω)) μ) :
    ∫ ω, Real.sqrt (X ω) ∂μ = ∫ ω, Real.sqrt (Y ω) ∂μ := by
  have hv : ∀ Z : Ω → ℝ, Measurable Z → (∀ ω, 0 ≤ Z ω) → Integrable Z μ →
      variance (fun ω => Real.sqrt (Z ω)) μ
        = ∫ ω, Z ω ∂μ - (∫ ω, Real.sqrt (Z ω) ∂μ) ^ 2 := by
    intro Z hZ hZ0 hZi
    have hm : Measurable (fun ω => Real.sqrt (Z ω)) := Real.continuous_sqrt.measurable.comp hZ
    have hsq : (fun ω => Real.sqrt (Z ω)) ^ 2 = Z := by
      ext ω; simp [Real.sq_sqrt (hZ0 ω)]
    have hL : MemLp (fun ω => Real.sqrt (Z ω)) 2 μ := by
      rw [memLp_two_iff_integrable_sq hm.aestronglyMeasurable]
      refine hZi.congr (Filter.Eventually.of_forall fun ω => ?_)
      simp [Real.sq_sqrt (hZ0 ω)]
    rw [variance_def' hL, hsq]
  have hX2 := hv X hX hnn hXi
  have hY2 := hv Y hY hnnY hYi
  have ha : 0 ≤ ∫ ω, Real.sqrt (X ω) ∂μ := integral_nonneg fun ω => Real.sqrt_nonneg _
  have hb : 0 ≤ ∫ ω, Real.sqrt (Y ω) ∂μ := integral_nonneg fun ω => Real.sqrt_nonneg _
  have hsq : (∫ ω, Real.sqrt (X ω) ∂μ) ^ 2 = (∫ ω, Real.sqrt (Y ω) ∂μ) ^ 2 := by
    rw [hX2, hY2, hmean] at hvar
    linarith
  exact (sq_eq_sq₀ ha hb).1 hsq

/-- S5. Source :266 "Jensen's inequality implies E√Y = E√(θX₁+(1-θ)X₂) > θE√X + (1-θ)E√X
= E√X, the inequality being strict because P(X₁≠X₂)>0."  Strict Jensen for the strictly
concave `√`; nonnegativity again silently assumed. -/
theorem P02_S5 (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hnn₁ : ∀ ω, 0 ≤ X₁ ω) (hnn₂ : ∀ ω, 0 ≤ X₂ ω)
    (hX₁i : Integrable X₁ μ) (hX₂i : Integrable X₂ μ)
    (hne : 0 < μ {ω | X₁ ω ≠ X₂ ω}) (hθ0 : 0 < θ) (hθ1 : θ < 1) :
    ∫ ω, Real.sqrt (X ω) ∂μ <
      ∫ ω, Real.sqrt (θ * X₁ ω + (1 - θ) * X₂ ω) ∂μ := by
  have hθ' : 0 < 1 - θ := by linarith
  have hZm : Measurable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) :=
    (hX₁.const_mul θ).add (hX₂.const_mul (1 - θ))
  have hZnn : ∀ ω, 0 ≤ θ * X₁ ω + (1 - θ) * X₂ ω := fun ω =>
    add_nonneg (mul_nonneg hθ0.le (hnn₁ ω)) (mul_nonneg hθ'.le (hnn₂ ω))
  have hZi : Integrable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) μ :=
    (hX₁i.const_mul θ).add (hX₂i.const_mul (1 - θ))
  have s1 := sqrt_integrable_aux μ X₁ hX₁ hnn₁ hX₁i
  have s2 := sqrt_integrable_aux μ X₂ hX₂ hnn₂ hX₂i
  have sZ := sqrt_integrable_aux μ _ hZm hZnn hZi
  have e1 : ∫ ω, Real.sqrt (X₁ ω) ∂μ = ∫ ω, Real.sqrt (X ω) ∂μ :=
    (h1.comp Real.continuous_sqrt.measurable).integral_eq
  have e2 : ∫ ω, Real.sqrt (X₂ ω) ∂μ = ∫ ω, Real.sqrt (X ω) ∂μ :=
    (h2.comp Real.continuous_sqrt.measurable).integral_eq
  -- pointwise strict concavity of √ (Jensen for two points)
  set d : Ω → ℝ := fun ω => Real.sqrt (θ * X₁ ω + (1 - θ) * X₂ ω) -
    (θ * Real.sqrt (X₁ ω) + (1 - θ) * Real.sqrt (X₂ ω)) with hd
  have hdnn : ∀ ω, 0 ≤ d ω := by
    intro ω
    have := Real.strictConcaveOn_sqrt.concaveOn.2 (Set.mem_Ici.2 (hnn₁ ω))
      (Set.mem_Ici.2 (hnn₂ ω)) hθ0.le hθ'.le (by ring)
    simp only [smul_eq_mul] at this
    simp only [hd]; linarith
  have hdpos : ∀ ω, X₁ ω ≠ X₂ ω → 0 < d ω := by
    intro ω hω
    have := Real.strictConcaveOn_sqrt.2 (Set.mem_Ici.2 (hnn₁ ω))
      (Set.mem_Ici.2 (hnn₂ ω)) hω hθ0 hθ' (by ring)
    simp only [smul_eq_mul] at this
    simp only [hd]; linarith
  have hs12 : Integrable (fun ω => θ * Real.sqrt (X₁ ω) + (1 - θ) * Real.sqrt (X₂ ω)) μ :=
    (s1.const_mul θ).add (s2.const_mul (1 - θ))
  have hdi : Integrable d μ := sZ.sub hs12
  have hpos : 0 < ∫ ω, d ω ∂μ := by
    rw [integral_pos_iff_support_of_nonneg_ae (Filter.Eventually.of_forall hdnn) hdi]
    refine lt_of_lt_of_le hne (measure_mono ?_)
    intro ω hω
    exact (hdpos ω hω).ne'
  have hint : ∫ ω, d ω ∂μ = ∫ ω, Real.sqrt (θ * X₁ ω + (1 - θ) * X₂ ω) ∂μ -
      (θ * ∫ ω, Real.sqrt (X ω) ∂μ + (1 - θ) * ∫ ω, Real.sqrt (X ω) ∂μ) := by
    simp only [hd]
    rw [integral_sub sZ hs12,
      integral_add (s1.const_mul θ) (s2.const_mul (1 - θ)), integral_const_mul,
      integral_const_mul, e1, e2]
  rw [hint] at hpos
  nlinarith

/-- S6. Source :266 "But this is not possible": S4b equality contradicts S5, so `E X` is not
finite.  Assembles S2-S5; yields `TwoCase` (with nonnegativity as silently assumed). -/
theorem P02_S6 (hX : Measurable X) (hX₁ : Measurable X₁) (hX₂ : Measurable X₂)
    (hnn : ∀ ω, 0 ≤ X ω) (hnn₁ : ∀ ω, 0 ≤ X₁ ω) (hnn₂ : ∀ ω, 0 ≤ X₂ ω)
    (hind : IndepFun X₁ X₂ μ)
    (h1 : IdentDistrib X₁ X μ μ) (h2 : IdentDistrib X₂ X μ μ)
    (hne : μ {ω | X₁ ω = X₂ ω} < 1) (hθ0 : 0 < θ) (hθ1 : θ < 1)
    (hdom : StDom μ X (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω)) :
    InfiniteMean μ X := by
  intro hint
  have hθ' : 0 < 1 - θ := by linarith
  have hYm : Measurable (fun ω => θ * X₁ ω + (1 - θ) * X₂ ω) :=
    (hX₁.const_mul θ).add (hX₂.const_mul (1 - θ))
  have hYnn : ∀ ω, 0 ≤ θ * X₁ ω + (1 - θ) * X₂ ω := fun ω =>
    add_nonneg (mul_nonneg hθ0.le (hnn₁ ω)) (mul_nonneg hθ'.le (hnn₂ ω))
  -- S2 (:266 "E(Y)=E(X), both finite")
  obtain ⟨hYi, hmean⟩ := P02_S2 μ X X₁ X₂ θ hX hX₁ hX₂ h1 h2 hint
  -- S3 (:266 "X and Y have the same distribution")
  have hidXY := P02_S3 μ X _ hX hYm hdom hint hYi hmean
  -- S4a (:266 "Var √X = Var √Y")
  have hvar := P02_S4a μ X _ hidXY
  -- S4b (:266 "implying E√X = E√Y")
  have heq := P02_S4b μ X _ hX hYm hnn hYnn hint hYi hmean hdom hvar
  -- S5 (:266 Jensen, strict because P(X₁ ≠ X₂) > 0)
  have hmeas : MeasurableSet {ω | X₁ ω = X₂ ω} := measurableSet_eq_fun hX₁ hX₂
  have hne' : 0 < μ {ω | X₁ ω ≠ X₂ ω} := by
    have hc : {ω | X₁ ω ≠ X₂ ω} = {ω | X₁ ω = X₂ ω}ᶜ := by ext ω; simp
    rw [hc, prob_compl_eq_one_sub hmeas]
    exact tsub_pos_of_lt hne
  have h5 := P02_S5 μ X X₁ X₂ θ hX₁ hX₂ h1 h2 hnn₁ hnn₂ (h1.integrable_iff.2 hint)
    (h2.integrable_iff.2 hint) hne' hθ0 hθ1
  exact absurd heq (ne_of_lt h5)

end TwoCaseSteps

end Paper.P02

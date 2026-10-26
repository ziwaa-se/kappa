import T02ModGaps

/-!
# T02 issue ruling (issues 1-3): counterexamples, scope lemmas and positive checks

Source: source/VSIFP_02.tex, proof of Theorem 3.2 (l.429-463).

Instance (the consumed instance named by the coordinator): ν = δ_{1/2} (locally finite Borel
measure on (0,1)), S = ∫ S_θ dν = S_{1/2} (elementary score, l.98-105), p = 1/4, q = 3/4, π₁ = 1;
mirror instance for the case p > q (l.462): p = 3/4, q = 1/4, π₁ = 0.

* Issue 1 (l.435): `PrintedClause_l435_lim`, `PrintedClause_l435_max` refuted at π₁ = 1;
  scope: the limit clause holds at the same S, ν, p, q for every π₁ ∈ [0,1); the theorem's
  conclusion (`Conclusion`) holds at the counterexample instance (positive check).
* Issue 2 (l.454): `PrintedClause_l454` refuted; the correctly signed formula holds at the instance;
  the l.456 / l.460 ratios are invariant under d ↦ -d.
* Issue 3 (l.462): the unprinted analogue of l.435 for p > q fails at π₁ = 0; the theorem's
  conclusion holds at that mirror instance (positive check).
-/

open MeasureTheory Filter Topology

namespace Paper.T02.Issue1

/-! ## Instance -/

noncomputable def ν0 : Measure ℝ := Measure.dirac (1/2 : ℝ)
noncomputable def S0 : ℝ → ℝ → ℝ := fun p y => elemScore (1/2) p y

lemma hcons0 : IsConsistent S0 := by
  intro p hp π hπ
  simp only [expPi, S0, elemScore]
  obtain ⟨hp0, hp1⟩ := hp
  obtain ⟨hπ0, hπ1⟩ := hπ
  split_ifs <;> norm_num at * <;> nlinarith

lemma hrep0 : T01.MixtureRep S0 ν0 := by
  classical
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · simp only [ν0]
    rw [Measure.dirac_apply' _ measurableSet_Ioo.compl]
    apply Set.indicator_of_not_mem
    simp only [Set.mem_compl_iff, Set.mem_Ioo, not_not]
    norm_num
  · intro K _ _
    simp only [ν0]
    exact measure_lt_top _ _
  · intro p _ y _
    refine ⟨?_, ?_⟩
    · exact ((integrable_const (elemScore (1/2) p y)).congr
        (ae_eq_dirac (fun θ => elemScore θ p y)).symm).integrableOn
    · simp only [S0, mixtureScore, ν0]
      rw [setIntegral_dirac]
      rw [if_pos (by norm_num)]

lemma v0p : S0 (1/4) 0 = 0 := by simp [S0, elemScore]; norm_num
lemma v0q : S0 (3/4) 0 = 1/2 := by simp [S0, elemScore]; norm_num
lemma v1p : S0 (1/4) 1 = 1/2 := by simp [S0, elemScore]; norm_num
lemma v1q : S0 (3/4) 1 = 0 := by simp [S0, elemScore]; norm_num

lemma hP : (1/4 : ℝ) ∈ Set.Ioo (0:ℝ) 1 := by norm_num
lemma hQ : (3/4 : ℝ) ∈ Set.Ioo (0:ℝ) 1 := by norm_num
lemma hPQ : (1/4 : ℝ) ≠ 3/4 := by norm_num
lemma hQP : (3/4 : ℝ) ≠ 1/4 := by norm_num
lemma hlt : (1/4 : ℝ) < 3/4 := by norm_num
lemma hnlt : ¬ ((3/4 : ℝ) < 1/4) := by norm_num

lemma hmin : min (1/4 : ℝ) (3/4) = 1/4 := by norm_num
lemma hmax : max (1/4 : ℝ) (3/4) = 3/4 := by norm_num
lemma hmin' : min (3/4 : ℝ) (1/4) = 1/4 := by norm_num
lemma hmax' : max (3/4 : ℝ) (1/4) = 3/4 := by norm_num

lemma mem_half : (1/2 : ℝ) ∈ Set.Ico (1/4 : ℝ) (3/4) := ⟨by norm_num, by norm_num⟩

lemma hν0 : 0 < ν0 (Set.Ico (min (1/4 : ℝ) (3/4)) (max (1/4) (3/4))) := by
  classical
  rw [hmin, hmax]
  simp only [ν0]
  rw [Measure.dirac_apply' _ measurableSet_Ico, Set.indicator_of_mem mem_half]
  simp

lemma hν0' : 0 < ν0 (Set.Ico (min (3/4 : ℝ) (1/4)) (max (3/4) (1/4))) := by
  have h := hν0
  rw [hmin, hmax] at h
  rw [hmin', hmax']; exact h

lemma kappa0 : kappa ν0 (1/4) (3/4) = 1/2 := by
  classical
  simp only [kappa, ν0]
  rw [setIntegral_dirac, if_pos mem_half, Measure.dirac_apply' _ measurableSet_Ico,
    Set.indicator_of_mem mem_half]
  simp

/-- Forward instance (p = 1/4 < q = 3/4): `E_{p,q;λ}(0) = 1 - λ`, `E_{p,q;λ}(1) = 1 + λ`. -/
lemma erepF0 (lam : ℝ) : Erep S0 (1/4) (3/4) lam 0 = 1 - lam := by
  simp only [Erep, if_neg hnlt, v0p, v0q]
  rw [abs_of_neg (by norm_num : (0:ℝ) - 1/2 < 0)]; ring

lemma erepF1 (lam : ℝ) : Erep S0 (1/4) (3/4) lam 1 = 1 + lam := by
  simp only [Erep, if_neg hnlt, v0p, v0q, v1p, v1q]
  rw [abs_of_neg (by norm_num : (0:ℝ) - 1/2 < 0)]; ring

lemma gF (π lam : ℝ) : growthRate S0 (1/4) (3/4) π lam =
    (1 - π) * Real.log (1 - lam) + π * Real.log (1 + lam) := by
  simp only [growthRate, expPi]
  rw [erepF0, erepF1]

lemma gF1 (lam : ℝ) : growthRate S0 (1/4) (3/4) 1 lam = Real.log (1 + lam) := by
  rw [gF]; ring

/-- `π₁ = 1 ∈ [0,1] \ H_S` for the forward instance (`E_1 d = d(1) = 1/2 > 0`). -/
lemma hπF : (1 : ℝ) ∈ Set.Icc (0:ℝ) 1 \ HS S0 (1/4) (3/4) := by
  refine ⟨by norm_num, ?_⟩
  intro h
  have h2 := h.2
  simp only [expPi, v0p, v0q, v1p, v1q] at h2
  norm_num at h2

/-! ## Issue 1: l.435 -/

/-- l.435, limit part, in its context (hypotheses of Theorem 3.1 via l.154, `π₁ ∉ H_S`, case
`p < q`): "lim_{λ→1} g(λ) = -∞", with `g = growthRate` (l.432-433). Only this conjunct of the
sentence is encoded (dropping the conjuncts `d(0)<0<d(1)`, continuity, `g(0)=0` makes the clause
weaker, not stronger). -/
def PrintedClause_l435_lim : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    Tendsto (growthRate S p q π₁) (𝓝[<] 1) atBot

/-- l.435, "so a maximum is attained at some λ ∈ [0,1)". Encoded as "some `l ∈ [0,1)` maximises
`g` over `[0,1)`"; this is implied by the reading "the maximum over `[0,1]` is attained in
`[0,1)`", so it is not stronger than either reading. -/
def PrintedClause_l435_max : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ∃ l ∈ Set.Ico (0:ℝ) 1, ∀ l' ∈ Set.Ico (0:ℝ) 1, growthRate S p q π₁ l' ≤ growthRate S p q π₁ l

/-- Scope: the gated encoding of S3a implies the (weaker) printed limit clause. -/
theorem printed_lim_of_gap : T02_S3a_Gap → PrintedClause_l435_lim := by
  intro h S ν h1 h2 p q h3 h4 h5 h6 π₁ h7 h8
  exact (h S ν h1 h2 p q h3 h4 h5 h6 π₁ h7 h8).2.2

/-- consumed_of_printed: the version consumed downstream (S3b gap, used on the route to S8/S9) is
exactly the printed max clause. -/
theorem consumed_of_printed : PrintedClause_l435_max ↔ T02_S3b_Gap := Iff.rfl

theorem not_lim_at_instance : ¬ Tendsto (growthRate S0 (1/4) (3/4) 1) (𝓝[<] 1) atBot := by
  intro hT
  have h1 := hT.eventually (eventually_le_atBot (-1))
  have h2 : ∀ᶠ x in 𝓝[<] (1:ℝ), x ∈ Set.Ioo (0:ℝ) 1 := Ioo_mem_nhdsLT (by norm_num)
  obtain ⟨x, hx1, hx2⟩ := (h1.and h2).exists
  rw [gF1] at hx1
  have : 0 < Real.log (1 + x) := Real.log_pos (by linarith [hx2.1])
  linarith

theorem counterexample_l435_lim : ¬ PrintedClause_l435_lim := by
  intro H
  exact not_lim_at_instance (H S0 ν0 hcons0 hrep0 _ _ hP hQ hPQ hν0 1 hπF hlt)

theorem counterexample_l435_max : ¬ PrintedClause_l435_max := by
  intro H
  obtain ⟨l, hl, hmx⟩ := H S0 ν0 hcons0 hrep0 _ _ hP hQ hPQ hν0 1 hπF hlt
  have h := hmx ((l + 1) / 2) ⟨by linarith [hl.1], by linarith [hl.2]⟩
  rw [gF1, gF1] at h
  have h' := Real.log_lt_log (by linarith [hl.1])
    (show 1 + l < 1 + (l + 1) / 2 by linarith [hl.2])
  linarith

/-- Scope lemma: at the same S, ν, p, q the printed limit holds for every `π₁ ∈ [0,1)`; the
failure is confined to `π₁ = 1`. -/
theorem lim_holds_below_one (π : ℝ) (hπ : π < 1) :
    Tendsto (growthRate S0 (1/4) (3/4) π) (𝓝[<] 1) atBot := by
  have hfun : growthRate S0 (1/4) (3/4) π =
      fun l => (1 - π) * Real.log (1 - l) + π * Real.log (1 + l) := funext (gF π)
  rw [hfun]
  have h1 : Tendsto (fun l : ℝ => 1 - l) (𝓝[<] 1) (𝓝[>] 0) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · have : Tendsto (fun l : ℝ => 1 - l) (𝓝 1) (𝓝 (1 - 1)) := tendsto_const_nhds.sub tendsto_id
      simpa using this.mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with l hl
      simp only [Set.mem_Ioi, Set.mem_Iio] at *
      linarith
  have h2 : Tendsto (fun l : ℝ => Real.log (1 - l)) (𝓝[<] 1) atBot :=
    Real.tendsto_log_nhdsGT_zero.comp h1
  have h3 : Tendsto (fun l : ℝ => (1 - π) * Real.log (1 - l)) (𝓝[<] 1) atBot :=
    Filter.Tendsto.const_mul_atBot (by linarith) h2
  have h4 : Tendsto (fun l : ℝ => π * Real.log (1 + l)) (𝓝[<] 1) (𝓝 (π * Real.log (1 + 1))) := by
    have hc : Tendsto (fun l : ℝ => 1 + l) (𝓝 1) (𝓝 (1 + 1)) := tendsto_const_nhds.add tendsto_id
    exact ((hc.log (by norm_num)).const_mul π).mono_left nhdsWithin_le_nhds
  exact h3.atBot_add h4

/-- Positive check (does issue 1 threaten the conclusion?): Theorem 3.2's conclusion holds at the
counterexample instance (π₁ = 1, p < q): the printed λ is 1, it is the unique maximiser over
(0,1], and the e-value is the printed `E^{π₁}_{p,q}`. -/
theorem conclusion_holds_at_instance : Conclusion S0 ν0 (1/4) (3/4) 1 := by
  have hgl : growLambda S0 (1/4) (3/4) 1 = 1 := by
    rw [growLambda, if_neg hnlt]; ring
  have hfin : ∀ l : ℝ, 0 < 1 + l → GrowFinite S0 (1/4) (3/4) 1 l := by
    intro l hl
    exact ⟨fun h => absurd rfl h, fun _ => by rw [erepF1]; exact hl⟩
  refine ⟨fun lam => ?_, ?_⟩
  · rw [hgl]
    constructor
    · rintro ⟨hl, _, hmx⟩
      have h1 := hmx 1 ⟨by norm_num, le_rfl⟩ (hfin 1 (by norm_num))
      rw [gF1, gF1] at h1
      have : (1:ℝ) + 1 ≤ 1 + lam :=
        (Real.log_le_log_iff (by norm_num) (by linarith [hl.1])).mp h1
      linarith [hl.2]
    · rintro rfl
      refine ⟨⟨by norm_num, le_rfl⟩, hfin 1 (by norm_num), ?_⟩
      intro l hl _
      rw [gF1, gF1]
      exact Real.log_le_log (by linarith [hl.1]) (by linarith [hl.2])
  · intro y hy
    rw [hgl]
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
    rcases hy with rfl | rfl
    · rw [erepF0]; simp [EGrow]
    · rw [erepF1]
      simp only [EGrow, if_neg (one_ne_zero : (1:ℝ) ≠ 0)]
      rw [hmin, hmax, kappa0]; norm_num

/-! ## Issue 2: l.454 -/

/-- l.454, "d_{p,q}(y) = ∫ 1{p ≤ θ < q}(θ - y) dν(θ)", case p < q, y ∈ {0,1}, in context
(same encoding as the gated S11). -/
def PrintedClause_l454 : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → p < q →
    ∀ (y : ℝ), y ∈ ({0, 1} : Set ℝ) →
    S p y - S q y = ∫ θ in Set.Icc (0:ℝ) 1, (if p ≤ θ ∧ θ < q then θ - y else 0) ∂ν

theorem printed_l454_iff_gap : PrintedClause_l454 ↔ T02_S11_Gap := Iff.rfl

lemma mem_half_Icc : (1/2 : ℝ) ∈ Set.Icc (0:ℝ) 1 := ⟨by norm_num, by norm_num⟩

theorem counterexample_l454 : ¬ PrintedClause_l454 := by
  classical
  intro H
  have h := H S0 ν0 hcons0 hrep0 _ _ hP hQ hPQ hν0 1 hπF hlt 0 (by simp)
  rw [v0p, v0q] at h
  simp only [ν0] at h
  rw [setIntegral_dirac, if_pos mem_half_Icc, if_pos (by norm_num)] at h
  norm_num at h

/-- Positive: the correctly signed formula `d(y) = ∫ 1{p ≤ θ < q}(y - θ) dν` holds at the
instance for y ∈ {0,1}. -/
theorem correct_sign_at_instance (y : ℝ) (hy : y ∈ ({0, 1} : Set ℝ)) :
    S0 (1/4) y - S0 (3/4) y =
      ∫ θ in Set.Icc (0:ℝ) 1, (if (1/4:ℝ) ≤ θ ∧ θ < 3/4 then y - θ else 0) ∂ν0 := by
  classical
  simp only [ν0]
  rw [setIntegral_dirac, if_pos mem_half_Icc, if_pos (by norm_num)]
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
  rcases hy with rfl | rfl
  · rw [v0p, v0q]; try norm_num
  · rw [v1p, v1q]; try norm_num

/-- The two ratios consumed at l.456 and l.460 are invariant under the global sign change
`d ↦ -d` (here `a = d(1), b = d(0)` resp. `a = d(0), b = d(1)`). -/
theorem ratio_sign_invariant (a b : ℝ) : ((-a) - (-b)) / (-a) = (a - b) / a := by
  rw [show (-a) - (-b) = -(a - b) by ring, neg_div_neg_eq]

/-! ## Issue 3: l.462 (mirror case p > q) -/

lemma hc' : (1/4 : ℝ) < 3/4 := by norm_num

lemma erepM0 (lam : ℝ) : Erep S0 (3/4) (1/4) lam 0 = 1 + lam := by
  simp only [Erep, if_pos hc', v0p, v0q, v1p, v1q]
  rw [abs_of_neg (by norm_num : (0:ℝ) - 1/2 < 0)]; ring

lemma erepM1 (lam : ℝ) : Erep S0 (3/4) (1/4) lam 1 = 1 - lam := by
  simp only [Erep, if_pos hc', v1p, v1q]
  rw [abs_of_neg (by norm_num : (0:ℝ) - 1/2 < 0)]; ring

lemma gM0 (lam : ℝ) : growthRate S0 (3/4) (1/4) 0 lam = Real.log (1 + lam) := by
  simp only [growthRate, expPi]
  rw [erepM0, erepM1]; ring

lemma hπM : (0 : ℝ) ∈ Set.Icc (0:ℝ) 1 \ HS S0 (3/4) (1/4) := by
  refine ⟨by norm_num, ?_⟩
  intro h
  have h2 := h.2
  simp only [expPi, v0p, v0q, v1p, v1q] at h2
  norm_num at h2

/-- The analogue of l.435 that l.462 ("The case p > q is analogous") requires; NOT printed. -/
def AnalogueClause_l462_lim : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ (p q : ℝ), p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
    0 < ν (Set.Ico (min p q) (max p q)) →
    ∀ (π₁ : ℝ), π₁ ∈ Set.Icc (0:ℝ) 1 \ HS S p q → q < p →
    Tendsto (growthRate S p q π₁) (𝓝[<] 1) atBot

theorem analogue_l462_fails : ¬ AnalogueClause_l462_lim := by
  intro H
  have hT := H S0 ν0 hcons0 hrep0 _ _ hQ hP hQP hν0' 0 hπM hc'
  have h1 := hT.eventually (eventually_le_atBot (-1))
  have h2 : ∀ᶠ x in 𝓝[<] (1:ℝ), x ∈ Set.Ioo (0:ℝ) 1 := Ioo_mem_nhdsLT (by norm_num)
  obtain ⟨x, hx1, hx2⟩ := (h1.and h2).exists
  rw [gM0] at hx1
  have : 0 < Real.log (1 + x) := Real.log_pos (by linarith [hx2.1])
  linarith

/-- Positive check: the conclusion of Theorem 3.2 holds at the mirror edge (p > q, π₁ = 0). -/
theorem conclusion_holds_at_mirror : Conclusion S0 ν0 (3/4) (1/4) 0 := by
  have hgl : growLambda S0 (3/4) (1/4) 0 = 1 := by
    rw [growLambda, if_pos hc']; ring
  have hfin : ∀ l : ℝ, 0 < 1 + l → GrowFinite S0 (3/4) (1/4) 0 l := by
    intro l hl
    exact ⟨fun _ => by rw [erepM0]; exact hl, fun h => absurd rfl h⟩
  refine ⟨fun lam => ?_, ?_⟩
  · rw [hgl]
    constructor
    · rintro ⟨hl, _, hmx⟩
      have h1 := hmx 1 ⟨by norm_num, le_rfl⟩ (hfin 1 (by norm_num))
      rw [gM0, gM0] at h1
      have : (1:ℝ) + 1 ≤ 1 + lam :=
        (Real.log_le_log_iff (by norm_num) (by linarith [hl.1])).mp h1
      linarith [hl.2]
    · rintro rfl
      refine ⟨⟨by norm_num, le_rfl⟩, hfin 1 (by norm_num), ?_⟩
      intro l hl _
      rw [gM0, gM0]
      exact Real.log_le_log (by linarith [hl.1]) (by linarith [hl.2])
  · intro y hy
    rw [hgl]
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hy
    rcases hy with rfl | rfl
    · rw [erepM0]
      simp only [EGrow, if_pos rfl]
      rw [hmin', hmax', kappa0]; norm_num
    · rw [erepM1]; simp [EGrow]

end Paper.T02.Issue1

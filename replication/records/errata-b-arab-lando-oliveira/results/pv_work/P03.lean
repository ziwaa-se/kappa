import P03Stmt

open MeasureTheory ProbabilityTheory

namespace Paper.P03

/-- Technical: law of the first coordinate copy is `μ.map X` (probability measures). -/
private lemma law_fst {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) :
    (μ.prod μ).map (fun p : Ω × Ω => X p.1) = μ.map X := by
  have : (fun p : Ω × Ω => X p.1) = X ∘ Prod.fst := rfl
  rw [this, ← Measure.map_map hX measurable_fst, Measure.map_fst_prod]
  simp

/-- Technical: law of the second coordinate copy is `μ.map X`. -/
private lemma law_snd {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) :
    (μ.prod μ).map (fun p : Ω × Ω => X p.2) = μ.map X := by
  have : (fun p : Ω × Ω => X p.2) = X ∘ Prod.snd := rfl
  rw [this, ← Measure.map_map hX measurable_snd, Measure.map_snd_prod]
  simp

/-- S1.  Source :269 (silent): copies realised as coordinates on `(Ω×Ω, μ⊗μ)`. -/
theorem P03_S1 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) :
    Paper.T02.IIDCopies (μ.prod μ) (fun p : Ω × Ω => X p.1)
      (fun i : Fin 2 => if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) := by
  have h1 : Measurable (fun p : Ω × Ω => X p.1) := hX.comp measurable_fst
  have h2 : Measurable (fun p : Ω × Ω => X p.2) := hX.comp measurable_snd
  have hm : ∀ i : Fin 2, Measurable
      (if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) := by
    intro i; split_ifs
    · exact h1
    · exact h2
  refine ⟨h1, hm, ?_, ?_⟩
  · rw [iIndepFun_iff_map_fun_eq_pi_map (fun i => (hm i).aemeasurable)]
    symm
    refine Measure.pi_eq (fun s hs => ?_)
    have hmeas : Measurable (fun (p : Ω × Ω) (i : Fin 2) =>
        (if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) p) := by
      refine measurable_pi_lambda _ (fun i => ?_)
      exact hm i
    rw [Measure.map_apply hmeas (MeasurableSet.univ_pi hs)]
    have hpre : (fun (p : Ω × Ω) (i : Fin 2) =>
        (if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) p) ⁻¹'
          (Set.univ.pi s) = (X ⁻¹' s 0) ×ˢ (X ⁻¹' s 1) := by
      ext p
      simp [Fin.forall_fin_two]
    rw [hpre, Measure.prod_prod, Fin.prod_univ_two]
    have e0 : (Measure.map (if (0 : Fin 2) = 0 then (fun p : Ω × Ω => X p.1)
        else (fun p : Ω × Ω => X p.2)) (μ.prod μ)) (s 0) = μ (X ⁻¹' s 0) := by
      simp only [if_true]
      rw [law_fst μ X hX, Measure.map_apply hX (hs 0)]
    have e1 : (Measure.map (if (1 : Fin 2) = 0 then (fun p : Ω × Ω => X p.1)
        else (fun p : Ω × Ω => X p.2)) (μ.prod μ)) (s 1) = μ (X ⁻¹' s 1) := by
      have : ((1 : Fin 2) = 0) = False := by decide
      simp only [this, if_false]
      rw [law_snd μ X hX, Measure.map_apply hX (hs 1)]
    rw [e0, e1]
  · intro i
    refine ⟨(hm i).aemeasurable, h1.aemeasurable, ?_⟩
    by_cases hi : i = 0
    · simp [hi]
    · simp only [hi, if_false]
      rw [law_snd μ X hX, law_fst μ X hX]

open Filter Topology in
/-- Helper for S2 (FAIR_IMPLICIT_STEP fill-in, verification/audits/P03_issue_1.md §6, step 1;
copied from pv_work/probes/issue/P03/P03_issue1_S2fill.lean).  Def 2.2 (:124) at `y = 1/x, 1/x`:
`F(x/2) ≥ 2 F(x) - 1`. -/
private lemma halve (ν : Measure ℝ) (h : Paper.L01.IsInvSub ν) (x : ℝ) (hx : 0 < x) :
    2 * Paper.L01.F ν x - 1 ≤ Paper.L01.F ν (x / 2) := by
  have hp : (1 / x) ∈ Set.Ioi (0:ℝ) := Set.mem_Ioi.2 (by positivity)
  have hs := h.2 (1 / x) hp (1 / x) hp
  unfold Paper.L01.invDist at hs
  have e1 : 1 / (1 / x + 1 / x) = x / 2 := by
    rw [div_add_div_same, one_div_div]; norm_num
  have e2 : 1 / (1 / x) = x := one_div_one_div x
  rw [e1, e2] at hs
  linarith

open Filter Topology in
/-- Helper for S2 (issue ruling §6, step 2): an InvSub law is not degenerate,
some `x` has `0 < F x < 1`. -/
private lemma exists_mid (ν : Measure ℝ) [IsProbabilityMeasure ν] (h : Paper.L01.IsInvSub ν) :
    ∃ x, 0 < Paper.L01.F ν x ∧ Paper.L01.F ν x < 1 := by
  by_contra hcon
  push_neg at hcon
  have ht := ProbabilityTheory.tendsto_cdf_atTop ν
  obtain ⟨x0, hx0⟩ := ((ht.eventually (lt_mem_nhds (show (1/2 : ℝ) < 1 by norm_num))).and
    (eventually_gt_atTop (0 : ℝ))).exists
  have hF1 : ∀ n : ℕ, 1 ≤ Paper.L01.F ν (x0 / 2 ^ n) := by
    intro n
    induction n with
    | zero =>
      simp only [pow_zero, div_one]
      exact hcon x0 (by unfold Paper.L01.F; linarith [hx0.1])
    | succ n ih =>
      have hpos : 0 < x0 / 2 ^ n := by have := hx0.2; positivity
      have := halve ν h _ hpos
      have e : x0 / 2 ^ n / 2 = x0 / 2 ^ (n + 1) := by rw [pow_succ]; ring
      rw [e] at this
      exact hcon _ (by linarith)
  have hrc : ContinuousWithinAt (ProbabilityTheory.cdf ν) (Set.Ici 0) 0 :=
    (ProbabilityTheory.cdf ν).right_continuous 0
  rw [Metric.continuousWithinAt_iff] at hrc
  obtain ⟨δ, hδ, hδ'⟩ := hrc (1/2) (by norm_num)
  obtain ⟨n, hn⟩ := exists_pow_lt_of_lt_one (div_pos hδ hx0.2) (show (1/2 : ℝ) < 1 by norm_num)
  have hy0 : 0 < x0 / 2 ^ n := by have := hx0.2; positivity
  have hyδ : x0 / 2 ^ n < δ := by
    have h2 : (1/2 : ℝ) ^ n = 1 / 2 ^ n := by rw [one_div_pow]
    rw [h2, lt_div_iff₀ hx0.2] at hn
    calc x0 / 2 ^ n = 1 / 2 ^ n * x0 := by ring
      _ < δ := hn
  have := hδ' (x := x0 / 2 ^ n) (Set.mem_Ici.2 hy0.le)
    (by rw [Real.dist_eq, sub_zero, abs_of_pos hy0]; exact hyδ)
  have h0 : ProbabilityTheory.cdf ν 0 = 0 := h.1
  rw [h0, Real.dist_eq, sub_zero] at this
  have := (abs_lt.1 this).2
  have := hF1 n
  unfold Paper.L01.F at this
  linarith

/-- S2.  Source :269 (silent): hypothesis of Prop 3.2 (:263) for the two copies.
FAIR_IMPLICIT_STEP (verification/audits/P03_issue_1.md); filled by the route of §6, step 3. -/
theorem P03_S2 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    (μ.prod μ) {p : Ω × Ω | ∀ i j : Fin 2,
        (if i = 0 then X p.1 else X p.2) = (if j = 0 then X p.1 else X p.2)} < 1 := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hX.aemeasurable
  obtain ⟨x, hx0, hx1⟩ := exists_mid (μ.map X) hits
  set E := {p : Ω × Ω | ∀ i j : Fin 2,
        (if i = 0 then X p.1 else X p.2) = (if j = 0 then X p.1 else X p.2)} with hE
  set A := X ⁻¹' Set.Iic x
  set B := X ⁻¹' Set.Ioi x
  have hA : MeasurableSet A := hX measurableSet_Iic
  have hB : MeasurableSet B := hX measurableSet_Ioi
  have hdisj : Disjoint E (A ×ˢ B) := by
    rw [Set.disjoint_left]
    rintro p hp ⟨ha, hb⟩
    have := hp 0 1
    simp only [if_true, show ((1 : Fin 2) = 0) = False from by decide, if_false] at this
    simp only [A, B, Set.mem_preimage, Set.mem_Iic, Set.mem_Ioi] at ha hb
    linarith
  have hμA : μ A = ENNReal.ofReal (Paper.L01.F (μ.map X) x) := by
    unfold Paper.L01.F
    rw [ProbabilityTheory.ofReal_cdf, Measure.map_apply hX measurableSet_Iic]
  have hμB : μ B = 1 - ENNReal.ofReal (Paper.L01.F (μ.map X) x) := by
    have : B = Aᶜ := by
      simp only [A, B, ← Set.preimage_compl, Set.compl_Iic]
    rw [this, prob_compl_eq_one_sub hA, hμA]
  have hApos : μ A ≠ 0 := by rw [hμA]; exact (ENNReal.ofReal_pos.2 hx0).ne'
  have hBpos : μ B ≠ 0 := by
    rw [hμB]
    refine (tsub_pos_of_lt ?_).ne'
    rw [← ENNReal.ofReal_one]
    exact (ENNReal.ofReal_lt_ofReal_iff one_pos).2 hx1
  have hprod : (μ.prod μ) (A ×ˢ B) ≠ 0 := by
    rw [Measure.prod_prod]; exact mul_ne_zero hApos hBpos
  have hunion : (μ.prod μ) E + (μ.prod μ) (A ×ˢ B) ≤ 1 := by
    rw [← measure_union hdisj (hA.prod hB)]
    exact prob_le_one
  have hEfin : (μ.prod μ) E ≠ ⊤ := measure_ne_top _ _
  calc (μ.prod μ) E < (μ.prod μ) E + (μ.prod μ) (A ×ˢ B) := ENNReal.lt_add_right hEfin hprod
    _ ≤ 1 := hunion

/-- S3.  Source :269 (silent): `F_X(0)=0` gives `X > 0` a.s. -/
theorem P03_S3 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    ∀ᵐ ω ∂μ, 0 < X ω := by
  haveI : IsProbabilityMeasure (μ.map X) := isProbabilityMeasure_map hX.aemeasurable
  have h0 : Paper.L01.F (μ.map X) 0 = 0 := hits.1
  unfold Paper.L01.F at h0
  rw [ProbabilityTheory.cdf_eq_real] at h0
  have h1 : (μ.map X) (Set.Iic 0) = 0 := by
    have := (measureReal_eq_zero_iff (μ := μ.map X) (s := Set.Iic 0)).1 h0
    exact this
  rw [Measure.map_apply hX measurableSet_Iic] at h1
  rw [ae_iff]
  simpa using h1

/-- S4.  Source :269 "As a consequence of Theorem 3.1". -/
theorem P03_S4 (hL01 : Paper.T02.T02_L01Consumed) (hT02 : P03_T02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.T02.StDom (μ.prod μ) (fun p : Ω × Ω => X p.1)
      (fun p => ∑ i : Fin 2, (1 / 2 : ℝ) *
        (if i = 0 then X p.1 else X p.2)) := by
  have h := hT02 hL01 (Ω × Ω) (μ.prod μ) (fun p : Ω × Ω => X p.1) _ (P03_S1 μ X hX)
    (by rw [law_fst μ X hX]; exact hits)
  exact h

/-- S5.  Bridge between the two copies of Definition 2.1 (definitionally equal). -/
theorem P03_S5 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) (X Y : Ω → ℝ) :
    Paper.T02.StDom μ X Y ↔ Paper.P02.StDom μ X Y := Iff.rfl

/-- S6.  Source :269 "and Proposition 3.2".  Uses S1, S2, S4, S5 and `hP02`. -/
theorem P03_S6 (hL01 : Paper.T02.T02_L01Consumed) (hT02 : P03_T02Consumed)
    (hP02 : P03_P02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X) (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.P02.InfiniteMean (μ.prod μ) (fun p : Ω × Ω => X p.1) := by
  have hc := P03_S1 μ X hX
  exact hP02 (Ω × Ω) (μ.prod μ) (fun p : Ω × Ω => X p.1) _ hc.meas hc.measXs hc.indep hc.ident
    (by
      have hset : {ω : Ω × Ω | ∀ i j : Fin 2,
          (if i = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) ω =
          (if j = 0 then (fun p : Ω × Ω => X p.1) else (fun p : Ω × Ω => X p.2)) ω} =
          {p : Ω × Ω | ∀ i j : Fin 2,
            (if i = 0 then X p.1 else X p.2) = (if j = 0 then X p.1 else X p.2)} := by
        ext p
        simp [Fin.forall_fin_two]
      rw [hset]
      exact P03_S2 μ X hX hits) ((P03_S5 _ _ _).1 (P03_S4 hL01 hT02 μ X hX hits))

/-- S7.  Transfer back from the product space (integrability depends only on the law). -/
theorem P03_S7 {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (h : Paper.P02.InfiniteMean (μ.prod μ) (fun p : Ω × Ω => X p.1)) :
    Paper.P02.InfiniteMean μ X := by
  intro hint
  apply h
  have hid : IdentDistrib (fun p : Ω × Ω => X p.1) X (μ.prod μ) μ :=
    ⟨(hX.comp measurable_fst).aemeasurable, hX.aemeasurable, law_fst μ X hX⟩
  exact hid.integrable_iff.2 hint

/-- Proposition 3.3 (prop:mean-fsub), source :270-273; proof :269. -/
theorem P03_main (hL01 : Paper.T02.T02_L01Consumed)
    (hT02 : P03_T02Consumed) (hP02 : P03_P02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.P02.InfiniteMean μ X :=
  P03_S7 μ X hX (P03_S6 hL01 hT02 hP02 μ X hX hits)

end Paper.P03

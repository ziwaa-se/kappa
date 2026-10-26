import P05Stmt

/-!
# P05 mod gaps (source/VSIFP_02.tex:235-240, Proposition 3.5 `prop:stopping`; proof l.473-478)
`P05_Sbridge` is replaced by `P05_Sbridge_Gap`; main theorem renamed `P05_main_mod_gaps`.
-/

open MeasureTheory

universe u

namespace Paper.P05

variable {Ω : Type u} {m0 : MeasurableSpace Ω}

/-- S0 (candidate-TFA bookkeeping, not in the source). -/
theorem P05_S0 (h : ℕ) (Q : Measure Ω) (τ : Ω → ℕ) (hτ1 : ∀ᵐ ω ∂Q, h + 1 ≤ τ ω) (t : ℕ)
    (ht : t ≤ h) : Q {ω | τ ω = t} = 0 := by
  have : ∀ᵐ ω ∂Q, ¬ (τ ω = t) := by
    filter_upwards [hτ1] with ω hω
    omega
  simpa using ae_iff.mp this

/-- Sapp.  (source l.236, l.238 `ℋ_S`; l.116-122.) -/
theorem P05_Sapp (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q) :
    Q ∈ Paper.P04.HScInt S h ℱ Y c p q := by
  obtain ⟨⟨hprob, hcond⟩, hint⟩ := hQ
  refine ⟨⟨hprob, fun t => ?_⟩, hint⟩
  filter_upwards [hcond t] with ω hω
  rcases hset.c_mem t ω with h0 | h1
  · rw [h0]; simp
  · rw [h1]; simpa using hω

/-- Snn.  (source l.226 P04 conclusion; presupposed at l.474-476.) -/
theorem P05_Snn (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t) :
    (∀ ω, 0 ≤ Paper.P04.eT S h Y p q lam t ω) ∧ Integrable (Paper.P04.eT S h Y p q lam t) Q := by
  have hQc := P05_Sapp S h ℱ Y c p q lam hset Q hQ
  obtain ⟨hmeas, h0, h1⟩ := hP04 t ht
  refine ⟨h0, ?_⟩
  have hm : Measurable (Paper.P04.eT S h Y p q lam t) := hmeas.mono (ℱ.le t) le_rfl
  refine ⟨hm.aestronglyMeasurable, ?_⟩
  rw [hasFiniteIntegral_iff_ofReal (Filter.Eventually.of_forall h0)]
  exact lt_of_le_of_lt (h1 Q hQc) ENNReal.one_lt_top

/-- Gap for `P05_Sbridge`: full ∀-closure of its type (stopped: not justified by the source,
l.236 / l.474; P04 gives only `E e_t ≤ 1`). -/
def P05_Sbridge_Gap : Prop :=
  ∀ {Ω : Type u} {m0 : MeasurableSpace Ω} (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (_hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (_hset : Paper.P04.SeqSetting ℱ Y c p q lam) (_hS : IsStrictlyConsistent S) (_hh : 1 ≤ h)
    (Q : Measure Ω) (_hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (_ht : h + 1 ≤ t),
    ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1

/-- S1.  (source l.476, first equality.) -/
theorem P05_S1 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (hτ1 : ∀ᵐ ω ∂Q, h + 1 ≤ τ ω) :
    ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q
      = ∑' t : ℕ, ∫⁻ ω in {ω | τ ω = t}, ENNReal.ofReal (Paper.P04.eT S h Y p q lam t ω) ∂Q := by
  have hmeas : ∀ t : ℕ, MeasurableSet {ω | τ ω = t} := fun t => ℱ.le t _ (hτ.measurableSet_eq t)
  have hdisj : Pairwise (Function.onFun Disjoint fun t : ℕ => {ω | τ ω = t}) := by
    intro a b hab
    refine Set.disjoint_left.mpr fun ω ha hb => hab ?_
    simp only [Set.mem_setOf_eq] at ha hb
    omega
  have hU : (⋃ t : ℕ, {ω | τ ω = t}) = Set.univ := by
    ext ω; simp
  have key := lintegral_iUnion (μ := Q) hmeas hdisj
    (fun ω => ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω))
  rw [hU, Measure.restrict_univ] at key
  rw [key]
  refine tsum_congr fun t => setLIntegral_congr_fun (hmeas t) ?_
  refine Filter.Eventually.of_forall fun ω hω => ?_
  simp only [Set.mem_setOf_eq] at hω
  rw [hω]

/-- S2.  (source l.474 and l.476 second equality.) -/
theorem P05_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t)
    (h0 : ∀ ω, 0 ≤ Paper.P04.eT S h Y p q lam t ω)
    (hint : Integrable (Paper.P04.eT S h Y p q lam t) Q) :
    ∫⁻ ω in {ω | τ ω = t}, ENNReal.ofReal (Paper.P04.eT S h Y p q lam t ω) ∂Q
      = ∫⁻ ω in {ω | τ ω = t},
          ENNReal.ofReal (condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω) ∂Q := by
  haveI : IsProbabilityMeasure Q := hQ.1.1
  have hA : MeasurableSet[ℱ t] {ω | τ ω = t} := hτ.measurableSet_eq_of_countable t
  have hA0 : MeasurableSet {ω | τ ω = t} := ℱ.le t _ hA
  have hce : Integrable (condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t)) Q := integrable_condExp
  have hcn : 0 ≤ᵐ[Q] condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) :=
    condExp_nonneg (Filter.Eventually.of_forall h0)
  have e1 := setIntegral_condExp (ℱ.le t) hint hA
  rw [← ofReal_integral_eq_lintegral_ofReal hint.integrableOn
      (ae_restrict_of_ae (Filter.Eventually.of_forall h0)),
    ← ofReal_integral_eq_lintegral_ofReal hce.integrableOn (ae_restrict_of_ae hcn), e1]

/-- S3.  (source l.476 underbrace and integrated inequality.) -/
theorem P05_S3 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y p q lam : ℕ → Ω → ℝ)
    (τ : Ω → ℕ)
    (Q : Measure Ω) (hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q)
    (t : ℕ) (ht : h + 1 ≤ t)
    (hcb : ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1) :
    ∫⁻ ω in {ω | τ ω = t},
        ENNReal.ofReal (condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω) ∂Q
      ≤ Q {ω | τ ω = t} := by
  calc _ ≤ ∫⁻ _ in {ω | τ ω = t}, (1 : ENNReal) ∂Q := by
        refine lintegral_mono_ae (ae_restrict_of_ae ?_)
        filter_upwards [hcb] with ω hω
        simpa using ENNReal.ofReal_le_ofReal hω
    _ = Q {ω | τ ω = t} := by rw [setLIntegral_const]; simp

/-- S4.  (source l.476 last `≤ 1`.) -/
theorem P05_S4 (Q : Measure Ω) [IsProbabilityMeasure Q] (τ : Ω → ℕ) (hτm : Measurable τ) :
    ∑' t : ℕ, Q {ω | τ ω = t} ≤ 1 := by
  have hmeas : ∀ t : ℕ, MeasurableSet {ω | τ ω = t} := fun t => hτm (measurableSet_singleton t)
  have hdisj : Pairwise (Function.onFun Disjoint fun t : ℕ => {ω | τ ω = t}) := by
    intro a b hab
    refine Set.disjoint_left.mpr fun ω ha hb => hab ?_
    simp only [Set.mem_setOf_eq] at ha hb
    omega
  rw [← measure_iUnion hdisj hmeas]
  exact prob_le_one

/-- Main theorem (l.235-240), modulo the gap `P05_Sbridge_Gap`. -/
theorem P05_main_mod_gaps (hGap_Sbridge : P05_Sbridge_Gap.{u})
    (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (hset : Paper.P04.SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStoppingTime ℱ τ) :
    ∀ Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q,
      (∀ᵐ ω ∂Q, h + 1 ≤ τ ω) →
      ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q ≤ 1 := by
  intro Q hQ hτ1
  haveI : IsProbabilityMeasure Q := hQ.1.1
  rw [P05_S1 S h ℱ Y p q lam τ hτ Q hQ hτ1]
  refine le_trans (ENNReal.tsum_le_tsum fun t => ?_) (P05_S4 Q τ
    (measurable_to_countable' fun t => ℱ.le t _ (hτ.measurableSet_eq_of_countable t)))
  by_cases ht : h + 1 ≤ t
  · obtain ⟨h0, hint⟩ := P05_Snn S h ℱ Y c p q lam hP04 hset Q hQ t ht
    rw [P05_S2 S h ℱ Y p q lam τ hτ Q hQ t ht h0 hint]
    exact P05_S3 S h ℱ Y p q lam τ Q hQ t ht
      (hGap_Sbridge S h ℱ Y c p q lam hP04 hset hS hh Q hQ t ht)
  · have hz := P05_S0 h Q τ hτ1 t (by omega)
    rw [Measure.restrict_eq_zero.mpr hz]
    simp

end Paper.P05

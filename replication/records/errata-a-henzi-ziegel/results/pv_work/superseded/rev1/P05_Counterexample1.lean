import P05Stmt

/-!
# P05 issue 1: counterexample to Proposition 3.5 (source/VSIFP_02.tex:235-240) for lag h = 2

Printed (l.235-240): "Let τ ∈ ℕ be a almost surely finite stopping time. Then under the
assumptions of Lemma prop:combination, E_Q(e_τ) ≤ 1, Q ∈ H_S."  The assumptions of P04 (l.223)
allow any lag h ≥ 1 (l.111).  `e_τ(ω) = e_{τ(ω)}(ω)` (l.233 "T is replaced by a stopping time τ";
l.476 "E(e_τ) = ∑_t E{e_t 1(τ = t)}").

Instance (h = 2): Ω = Bool with Q uniform; ω is a fair coin `b`.
* Y_3 = Y_4 = 1{b}, Y_t = 0 otherwise.  ℱ_t = ⊥ (trivial) for t ≤ 2, ⊤ (= σ(b)) for t ≥ 3.
* Brier score S(p,y) = (y - p)² (l.74, strictly consistent), p_t = 1/4, q_t = 3/4, c_t = 1.
* λ_2 = 1, λ_t = 0 otherwise.  Then E_{p_2,q_2;1}(Y_4) = 2·Y_4 and all other factors are 1, so
  e_3 = 1 and e_T = (1 + 2 Y_4)/2 for T ≥ 4.
* Q ∈ H_S: P(Y_{t+2} = 1 | ℱ_t) = 1/2 for t = 1, 2 (ℱ_t trivial) and 0 for the other t;
  for Brier with p = 1/4, q = 3/4 the score difference is Y_{t+2} - 1/2.
* τ = 3 if b = false, τ = 4 if b = true: a stopping time, since Y_3 = 1{b} is ℱ_3-measurable.
  E_Q e_τ = (1/2)·1 + (1/2)·(3/2) = 5/4 > 1.
The instance also satisfies the consumed clause of P04 (`P05_P04Consumed`), proved below for every
`Q' ∈ ℋ_{S;c}`, so the failure is not a failure of P04.
-/

open MeasureTheory

namespace Paper.P05.Issue1

/-- Printed clause l.235-240, under the assumptions of P04 (l.223), for every lag `h ≥ 1`
(l.111), encoded with exactly the binders of the gated `Paper.P05.P05_main`
(`pv_work/P05Draft.lean`, gate `P05_gate_r2.md`), at `Ω : Type`.  Extra premises (all make the
clause weaker): the consumed P04 clause `hP04`, `τ` finite everywhere, `τ ≥ h+1` a.s. (TFA),
integrability inside `HScInt`. -/
def PrintedClause : Prop :=
  ∀ (Ω : Type) [m0 : MeasurableSpace Ω] (S : ℝ → ℝ → ℝ) (h : ℕ), 1 ≤ h →
  ∀ (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ),
    P05_P04Consumed S h ℱ Y c p q lam →
    Paper.P04.SeqSetting ℱ Y c p q lam → IsStrictlyConsistent S →
  ∀ (τ : Ω → ℕ), IsStoppingTime ℱ τ →
  ∀ Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q,
    (∀ᵐ ω ∂Q, h + 1 ≤ τ ω) →
    ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q ≤ 1

/-! ## The instance -/

/-- Brier score `(y - p)²` (l.74). -/
def S0 : ℝ → ℝ → ℝ := fun p y => (y - p) ^ 2

noncomputable def yb (ω : Bool) : ℝ := if ω = true then 1 else 0

noncomputable def Y0 : ℕ → Bool → ℝ := fun t ω => if t = 3 ∨ t = 4 then yb ω else 0
noncomputable def p0 : ℕ → Bool → ℝ := fun _ _ => 1 / 4
noncomputable def q0 : ℕ → Bool → ℝ := fun _ _ => 3 / 4
noncomputable def c0 : ℕ → Bool → ℝ := fun _ _ => 1
noncomputable def lam0 : ℕ → Bool → ℝ := fun t _ => if t = 2 then 1 else 0

/-- `ℱ_t` trivial for `t ≤ 2`, everything (= σ(b)) for `t ≥ 3`. -/
def F0 : Filtration ℕ (inferInstance : MeasurableSpace Bool) where
  seq t := if t ≤ 2 then ⊥ else ⊤
  mono' := by
    intro i j hij
    dsimp only
    split_ifs with h1 h2 h2
    · exact le_rfl
    · exact bot_le
    · omega
    · exact le_rfl
  le' := by
    intro i
    split_ifs
    · exact bot_le
    · exact le_rfl

lemma F0_bot (t : ℕ) (ht : t ≤ 2) : F0 t = ⊥ := by
  show (if t ≤ 2 then ⊥ else ⊤) = _
  rw [if_pos ht]

lemma F0_top (t : ℕ) (ht : 3 ≤ t) : F0 t = ⊤ := by
  show (if t ≤ 2 then ⊥ else ⊤) = _
  rw [if_neg (by omega)]

/-- Uniform probability on `Bool`. -/
noncomputable def Q0 : Measure Bool := (2⁻¹ : ENNReal) • (Measure.dirac true + Measure.dirac false)

instance : IsProbabilityMeasure Q0 := by
  constructor
  simp only [Q0, Measure.smul_apply, Measure.add_apply, measure_univ, smul_eq_mul]
  rw [one_add_one_eq_two]
  exact ENNReal.inv_mul_cancel (by norm_num) (by norm_num)

lemma lintegral_Q0 (g : Bool → ENNReal) : ∫⁻ ω, g ω ∂Q0 = 2⁻¹ * (g true + g false) := by
  simp only [Q0, lintegral_smul_measure, lintegral_add_measure, lintegral_dirac, smul_eq_mul]

lemma integral_Q0 (f : Bool → ℝ) : ∫ ω, f ω ∂Q0 = (f true + f false) / 2 := by
  have h1 : Integrable f (Measure.dirac true) := Integrable.of_finite
  have h2 : Integrable f (Measure.dirac false) := Integrable.of_finite
  simp only [Q0, integral_smul_measure, integral_add_measure h1 h2, integral_dirac, smul_eq_mul]
  norm_num
  ring

lemma Q0_true : Q0 {true} = 2⁻¹ := by
  simp [Q0, Measure.smul_apply, Measure.add_apply]

/-- The score difference at time `t` is `Y_{t+2} - 1/2` (Brier, p = 1/4, q = 3/4). -/
lemma diff_eq (t : ℕ) (ω : Bool) :
    S0 (p0 t ω) (Y0 (t + 2) ω) - S0 (q0 t ω) (Y0 (t + 2) ω) = Y0 (t + 2) ω - 1 / 2 := by
  simp only [S0, p0, q0]
  ring

lemma Erep_lam0 (y : ℝ) (a b : ℝ) : Paper.Erep S0 a b 0 y = 1 := by
  simp [Paper.Erep]

/-- `E_{1/4,3/4;1}(y) = 2y` on `y ∈ {0,1}`. -/
lemma Erep_one (ω : Bool) : Paper.Erep S0 (1 / 4) (3 / 4) 1 (yb ω) = 2 * yb ω := by
  have hc : ¬ ((3 / 4 : ℝ) < 1 / 4) := by norm_num
  cases ω <;> simp only [Paper.Erep, S0, yb, if_neg hc] <;> norm_num <;>
    rw [abs_of_pos (by norm_num : (0:ℝ) < 1 / 2)] <;> norm_num

lemma factor_eq (l : ℕ) (ω : Bool) :
    Paper.Erep S0 (p0 l ω) (q0 l ω) (lam0 l ω) (Y0 (l + 2) ω)
      = if l = 2 then 2 * yb ω else 1 := by
  by_cases hl : l = 2
  · subst hl
    simp only [p0, q0, lam0, Y0, if_true]
    rw [if_pos (by norm_num)]
    exact Erep_one ω
  · simp only [lam0, if_neg hl]
    exact Erep_lam0 _ _ _

lemma Ik_one (T : ℕ) : 2 ∉ Paper.P04.Ik 2 T 1 := by
  simp only [Paper.P04.Ik, Finset.mem_image, Finset.mem_range, not_exists, not_and]
  intro s _ hs
  omega

lemma Ik_two (T : ℕ) : 2 ∈ Paper.P04.Ik 2 T 2 ↔ 4 ≤ T := by
  simp only [Paper.P04.Ik, Finset.mem_image, Finset.mem_range]
  constructor
  · rintro ⟨s, hs, h2⟩
    omega
  · intro hT
    exact ⟨0, by omega, by omega⟩

lemma prod_eq (s : Finset ℕ) (ω : Bool) :
    ∏ l ∈ s, Paper.Erep S0 (p0 l ω) (q0 l ω) (lam0 l ω) (Y0 (l + 2) ω)
      = if 2 ∈ s then 2 * yb ω else 1 := by
  simp only [factor_eq]
  rw [Finset.prod_ite_eq']

lemma Icc12 : Finset.Icc 1 2 = ({1, 2} : Finset ℕ) := by decide

lemma eT_eq (T : ℕ) (ω : Bool) :
    Paper.P04.eT S0 2 Y0 p0 q0 lam0 T ω
      = (1 / 2) * (1 + if 4 ≤ T then 2 * yb ω else 1) := by
  simp only [Paper.P04.eT, prod_eq, Icc12]
  rw [Finset.sum_pair (by norm_num), if_neg (Ik_one T)]
  by_cases hT : 4 ≤ T
  · rw [if_pos ((Ik_two T).2 hT), if_pos hT]
    norm_num
  · rw [if_neg (fun h => hT ((Ik_two T).1 h)), if_neg hT]
    norm_num

lemma eT_ge4 (T : ℕ) (hT : 4 ≤ T) (ω : Bool) :
    Paper.P04.eT S0 2 Y0 p0 q0 lam0 T ω = 1 + (Y0 (2 + 2) ω - 1 / 2) := by
  rw [eT_eq, if_pos hT]
  simp only [Y0, show (2 + 2 = 4) from rfl]
  rw [if_pos (by norm_num)]
  ring

lemma eT_three (ω : Bool) : Paper.P04.eT S0 2 Y0 p0 q0 lam0 3 ω = 1 := by
  rw [eT_eq, if_neg (by norm_num)]
  norm_num

lemma eT_nonneg (T : ℕ) (ω : Bool) : 0 ≤ Paper.P04.eT S0 2 Y0 p0 q0 lam0 T ω := by
  rw [eT_eq]
  have : 0 ≤ yb ω := by unfold yb; split_ifs <;> norm_num
  split_ifs <;> nlinarith

/-! ## The printed hypotheses hold -/

lemma hS0 : IsStrictlyConsistent S0 := by
  refine ⟨?_, ?_⟩
  · intro p _ π _
    simp only [Paper.expPi, S0]
    nlinarith [sq_nonneg (p - π)]
  · intro p _ π _ h
    simp only [Paper.expPi, S0] at h
    have : (p - π) ^ 2 = 0 := by nlinarith
    have := pow_eq_zero_iff (n := 2) (by norm_num) |>.1 this
    linarith

lemma hset0 : Paper.P04.SeqSetting F0 Y0 c0 p0 q0 lam0 where
  Y_adapted := by
    intro t
    by_cases ht : t = 3 ∨ t = 4
    · rw [F0_top t (by omega)]
      exact measurable_from_top
    · have : Y0 t = fun _ => 0 := by
        funext ω; simp only [Y0, if_neg ht]
      rw [this]
      exact measurable_const
  c_adapted := fun _ => measurable_const
  p_adapted := fun _ => measurable_const
  q_adapted := fun _ => measurable_const
  lam_adapted := fun _ => measurable_const
  Y_mem := by
    intro t ω
    simp only [Y0, yb]
    split_ifs <;> simp
  c_mem := fun _ _ => Or.inr rfl
  p_mem := fun _ _ => ⟨by norm_num [p0], by norm_num [p0]⟩
  q_mem := fun _ _ => ⟨by norm_num [q0], by norm_num [q0]⟩
  lam_mem := by
    intro t ω
    simp only [lam0]
    split_ifs <;> norm_num
  lam_zero := by
    intro t ω h
    simp [c0] at h

/-- For every probability measure on `Bool`, the conditional score-difference at every `t` is
computed: for `t ≤ 2` it is the constant `∫ (Y_{t+2} - 1/2)`, for `t ≥ 3` it is `-1/2`. -/
lemma condExp_diff (Q : Measure Bool) [IsProbabilityMeasure Q] (t : ℕ) :
    condExp (F0 t) Q (fun ω' => S0 (p0 t ω') (Y0 (t + 2) ω') - S0 (q0 t ω') (Y0 (t + 2) ω'))
      = fun _ => if t ≤ 2 then ∫ ω, (Y0 (t + 2) ω - 1 / 2) ∂Q else -1 / 2 := by
  simp only [diff_eq]
  by_cases ht : t ≤ 2
  · rw [F0_bot t ht, condExp_bot, if_pos ht]
  · rw [if_neg ht]
    have hY : (fun ω => Y0 (t + 2) ω - 1 / 2) = fun _ => (-1 / 2 : ℝ) := by
      funext ω
      simp only [Y0, if_neg (show ¬ (t + 2 = 3 ∨ t + 2 = 4) by omega)]
      norm_num
    rw [hY, condExp_const (F0.le t)]

lemma hQ0 : Q0 ∈ Paper.P04.HScInt S0 2 F0 Y0 (fun _ _ => 1) p0 q0 := by
  refine ⟨⟨inferInstance, ?_⟩, fun t => Integrable.of_finite⟩
  intro t
  refine Filter.Eventually.of_forall (fun ω => ?_)
  rw [condExp_diff Q0 t, one_mul]
  split_ifs with ht
  · rw [integral_Q0]
    have h1 : t + 2 = 3 ∨ t + 2 = 4 ∨ ¬ (t + 2 = 3 ∨ t + 2 = 4) := by omega
    rcases h1 with h1 | h1 | h1
    · simp only [Y0, h1, true_or, if_true, yb]; norm_num
    · simp only [Y0, h1, or_true, if_true, yb]; norm_num
    · simp only [Y0, if_neg h1]; norm_num
  · norm_num

/-- The consumed P04 clause holds for this instance, for every `Q' ∈ ℋ_{S;c}` (c ≡ 1). -/
lemma hP040 : P05_P04Consumed S0 2 F0 Y0 c0 p0 q0 lam0 := by
  intro T hT
  refine ⟨?_, ?_, ?_⟩
  · rw [F0_top T hT]
    exact measurable_from_top
  · exact eT_nonneg T
  · intro Q' hQ'
    obtain ⟨⟨hprob, hcond⟩, _⟩ := hQ'
    by_cases h4 : 4 ≤ T
    · have hfun : Paper.P04.eT S0 2 Y0 p0 q0 lam0 T
          = fun ω => 1 + (Y0 (2 + 2) ω - 1 / 2) := funext (eT_ge4 T h4)
      have hc2 := hcond 2
      simp only [c0, one_mul] at hc2
      rw [condExp_diff Q' 2, if_pos le_rfl] at hc2
      have hint : (∫ ω, (Y0 (2 + 2) ω - 1 / 2) ∂Q') ≤ 0 := by
        obtain ⟨ω, hω⟩ := hc2.exists
        exact hω
      rw [hfun, ← ofReal_integral_eq_lintegral_ofReal Integrable.of_finite
        (Filter.Eventually.of_forall (fun ω => by
          have := eT_ge4 T h4 ω ▸ eT_nonneg T ω
          exact this))]
      rw [integral_add (integrable_const _) Integrable.of_finite, integral_const]
      simp only [measureReal_univ_eq_one, smul_eq_mul, one_mul]
      rw [ENNReal.ofReal_le_one]
      linarith
    · have hT3 : T = 3 := by omega
      subst hT3
      simp only [eT_three, ENNReal.ofReal_one, lintegral_const, measure_univ, mul_one]
      exact le_rfl

/-- Stopping time: stop at 3 if `Y_3 = 0`, at 4 if `Y_3 = 1`. -/
def tau0 : Bool → ℕ := fun ω => if ω = true then 4 else 3

lemma htau0 : IsStoppingTime F0 tau0 := by
  intro i
  by_cases hi : i ≤ 2
  · have : {ω | tau0 ω ≤ i} = ∅ := by
      ext ω; simp only [tau0, Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false]
      split_ifs <;> omega
    rw [this]
    exact @MeasurableSet.empty Bool (F0 i)
  · rw [F0_top i (by omega)]
    exact MeasurableSpace.measurableSet_top

lemma htau0_ge : ∀ᵐ ω ∂Q0, 2 + 1 ≤ tau0 ω :=
  Filter.Eventually.of_forall (fun ω => by unfold tau0; split_ifs <;> omega)

/-- `E_Q e_τ = 5/4`. -/
lemma lintegral_stopped :
    ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S0 2 Y0 p0 q0 lam0 (tau0 ω) ω) ∂Q0
      = ENNReal.ofReal (5 / 4) := by
  rw [lintegral_Q0]
  have ht : Paper.P04.eT S0 2 Y0 p0 q0 lam0 (tau0 true) true = 3 / 2 := by
    simp only [tau0, if_true]
    rw [eT_eq, if_pos le_rfl]
    simp [yb]; norm_num
  have hf : Paper.P04.eT S0 2 Y0 p0 q0 lam0 (tau0 false) false = 1 := by
    simp only [tau0]
    exact eT_three false
  rw [ht, hf, ← ENNReal.ofReal_add (by norm_num) (by norm_num)]
  rw [show (2⁻¹ : ENNReal) = ENNReal.ofReal (1 / 2) by
    rw [ENNReal.ofReal_div_of_pos (by norm_num)]; simp]
  rw [← ENNReal.ofReal_mul (by norm_num)]
  norm_num

/-! ## The counterexample -/

theorem not_printed : ¬ PrintedClause := by
  intro H
  have := H Bool S0 2 (by norm_num) F0 Y0 c0 p0 q0 lam0 hP040 hset0 hS0 tau0 htau0 Q0 hQ0
    htau0_ge
  rw [lintegral_stopped, ENNReal.ofReal_le_one] at this
  norm_num at this

/-! ## Scope: the refuted clause is exactly the gated `P05_main` statement (at `Ω : Type`) -/

/-- `PrintedClause` is implied by (indeed is a binder-reordering of) the type of the gated
theorem `Paper.P05.P05_main` specialised to `Ω : Type`; so `not_printed` refutes `P05_main`. -/
theorem printed_of_main_shape
    (Hmain : ∀ (Ω : Type) [m0 : MeasurableSpace Ω] (S : ℝ → ℝ → ℝ) (h : ℕ) (_hh : 1 ≤ h)
      (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
      (_hP04 : P05_P04Consumed S h ℱ Y c p q lam)
      (_hset : Paper.P04.SeqSetting ℱ Y c p q lam) (_hS : IsStrictlyConsistent S)
      (τ : Ω → ℕ) (_hτ : IsStoppingTime ℱ τ),
      ∀ Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q,
        (∀ᵐ ω ∂Q, h + 1 ≤ τ ω) →
        ∫⁻ ω, ENNReal.ofReal (Paper.P04.eT S h Y p q lam (τ ω) ω) ∂Q ≤ 1) :
    PrintedClause :=
  fun Ω _ S h hh ℱ Y c p q lam hP04 hset hS τ hτ => Hmain Ω S h hh ℱ Y c p q lam hP04 hset hS τ hτ

/-! ## Obstruction: the step `P05_Sbridge` (l.474 premise applied to P04's e_t) fails -/

/-- The obligation `Paper.P05.P05_Sbridge` (`pv_work/P05Draft.lean`), as a clause. -/
def SbridgeClause : Prop :=
  ∀ (Ω : Type) [m0 : MeasurableSpace Ω] (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ),
    P05_P04Consumed S h ℱ Y c p q lam →
    Paper.P04.SeqSetting ℱ Y c p q lam → IsStrictlyConsistent S → 1 ≤ h →
  ∀ Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q, ∀ t : ℕ, h + 1 ≤ t →
    ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1

/-- General fact: for P04's `e_t` (ℱ_t-measurable, integrable), `E(e_t | ℱ_t) = e_t`, so the
premise of l.474 says `e_t ≤ 1` a.s. -/
lemma condExp_self_of_P04 {Ω : Type} [m0 : MeasurableSpace Ω] (S : ℝ → ℝ → ℝ) (h : ℕ)
    (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S h ℱ Y c p q lam)
    (Q : Measure Ω) [IsFiniteMeasure Q] (t : ℕ) (ht : h + 1 ≤ t)
    (hint : Integrable (Paper.P04.eT S h Y p q lam t) Q) :
    condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) = Paper.P04.eT S h Y p q lam t :=
  condExp_of_stronglyMeasurable (ℱ.le t) (hP04 t ht).measurable.stronglyMeasurable hint

theorem not_Sbridge : ¬ SbridgeClause := by
  intro H
  have := H Bool S0 2 F0 Y0 c0 p0 q0 lam0 hP040 hset0 hS0 (by norm_num) Q0 hQ0 4 (by norm_num)
  rw [condExp_self_of_P04 S0 2 F0 Y0 c0 p0 q0 lam0 hP040 Q0 4 (by norm_num)
    Integrable.of_finite] at this
  rw [ae_iff] at this
  have hsub : ({true} : Set Bool) ⊆ {ω | ¬ Paper.P04.eT S0 2 Y0 p0 q0 lam0 4 ω ≤ 1} := by
    intro ω hω
    rw [Set.mem_singleton_iff] at hω
    subst hω
    simp only [Set.mem_setOf_eq, not_le]
    rw [eT_eq, if_pos le_rfl]
    simp [yb]; norm_num
  have h0 := measure_mono_null hsub this
  rw [Q0_true] at h0
  norm_num at h0

end Paper.P05.Issue1

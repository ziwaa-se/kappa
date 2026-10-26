import Mathlib

-- Definitions repeated from `InvSub/Basic.lean` so that this file is self-contained.
open MeasureTheory ProbabilityTheory Set

noncomputable section

def InvSub (μ : Measure ℝ) : Prop :=
  cdf μ 0 = 0 ∧ ∀ x y : ℝ, 0 < x → 0 < y →
    1 - cdf μ (1 / (x + y)) ≤ (1 - cdf μ (1 / x)) + (1 - cdf μ (1 / y))

def Cond23 (F : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, 0 ≤ x → ∀ θ : ℝ, 0 < θ → θ < 1 → F (x / θ) + F (x / (1 - θ)) ≤ F x + 1

theorem subadd_iff_cond23 (F : ℝ → ℝ) (h0 : F 0 ≤ 1) :
    (∀ x y : ℝ, 0 < x → 0 < y → 1 - F (1 / (x + y)) ≤ (1 - F (1 / x)) + (1 - F (1 / y)))
      ↔ Cond23 F := by
  constructor
  · intro h x hx θ hθ0 hθ1
    rcases hx.eq_or_lt with rfl | hx
    · simp; linarith
    have h1 : 0 < θ / x := by positivity
    have h2 : 0 < (1 - θ) / x := by apply div_pos <;> linarith
    have := h (θ / x) ((1 - θ) / x) h1 h2
    have e1 : 1 / (θ / x + (1 - θ) / x) = x := by field_simp
    have e2 : 1 / (θ / x) = x / θ := by field_simp
    have e3 : 1 / ((1 - θ) / x) = x / (1 - θ) := by field_simp
    rw [e1, e2, e3] at this
    linarith
  · intro h x y hx hy
    have hs : 0 < x + y := by linarith
    have hθ0 : 0 < x / (x + y) := by positivity
    have hθ1 : x / (x + y) < 1 := by rw [div_lt_one hs]; linarith
    have := h (1 / (x + y)) (by positivity) (x / (x + y)) hθ0 hθ1
    have e1 : 1 / (x + y) / (x / (x + y)) = 1 / x := by field_simp
    have e2 : 1 / (x + y) / (1 - x / (x + y)) = 1 / y := by
      have : 1 - x / (x + y) = y / (x + y) := by field_simp
      rw [this]; field_simp
    rw [e1, e2] at this
    linarith

theorem lemma_2_3 (μ : Measure ℝ) [IsProbabilityMeasure μ] :
    InvSub μ ↔ cdf μ 0 = 0 ∧ Cond23 (cdf μ) := by
  unfold InvSub
  constructor
  · rintro ⟨h0, h⟩
    exact ⟨h0, (subadd_iff_cond23 _ (by rw [h0]; norm_num)).1 h⟩
  · rintro ⟨h0, h⟩
    exact ⟨h0, (subadd_iff_cond23 _ (by rw [h0]; norm_num)).2 h⟩

end

/-!
# Theorem 3.1 (main result): InvSub ⇒ `X ≤st θ₁X₁ + ⋯ + θₙXₙ`

i.i.d. copies `X₁,…,Xₙ` of `X ~ μ` are modelled by the product measure `Measure.pi (fun _ => μ)`.
We prove `P(∑ θᵢ Xᵢ ≤ x) ≤ F_X(x)` for every `x`, equivalently `P(∑ θᵢ Xᵢ > x) ≥ P(X > x)`.

The proof follows the paper's decomposition (Figures 1–2) but with the final estimate corrected:
the paper drops the term `F̄(x)(F̄(x) - F̄(x/θ) - F̄(x/(1-θ)))`, which is `≤ 0`, from a *lower*
bound, which is not allowed.  Here we instead use `F(x)·(b + d) ≤ F(x)` with `b + d ≤ 1`.
-/

open MeasureTheory ProbabilityTheory Set

noncomputable section

/-- (2.3) transported to measures of half-lines. -/
lemma cond23_measure (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : Cond23 (cdf μ))
    (x : ℝ) (hx : 0 ≤ x) (θ : ℝ) (h0 : 0 < θ) (h1 : θ < 1) :
    μ (Iic (x / θ)) + μ (Iic (x / (1 - θ))) ≤ μ (Iic x) + 1 := by
  have := h x hx θ h0 h1
  simp only [cdf_eq_real, measureReal_def] at this
  rw [← ENNReal.toReal_le_toReal (by finiteness) (by finiteness), ENNReal.toReal_add
    (by finiteness) (by finiteness), ENNReal.toReal_add (by finiteness) (by finiteness)]
  simpa using this

/-- Two-variable step (both the case `n = 2` and the induction step of the paper):
if `U ~ μ` is InvSub and `V ~ ν` is independent with `ν ≥st μ`, then
`P(θU + (1-θ)V ≤ x) ≤ F_μ(x)`. -/
theorem key_step (μ ν : Measure ℝ) [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (hμ0 : μ (Iic 0) = 0) (h23 : Cond23 (cdf μ)) (hνμ : ∀ y, ν (Iic y) ≤ μ (Iic y))
    (θ : ℝ) (hθ0 : 0 ≤ θ) (hθ1 : θ < 1) (x : ℝ) :
    (μ.prod ν) {p : ℝ × ℝ | θ * p.1 + (1 - θ) * p.2 ≤ x} ≤ μ (Iic x) := by
  rcases hθ0.eq_or_lt with rfl | hθ0
  · have : {p : ℝ × ℝ | (0:ℝ) * p.1 + (1 - 0) * p.2 ≤ x} = univ ×ˢ Iic x := by
      ext p; simp
    rw [this, Measure.prod_prod, measure_univ, one_mul]
    exact hνμ x
  have h1θ : 0 < 1 - θ := by linarith
  have hsub : {p : ℝ × ℝ | θ * p.1 + (1 - θ) * p.2 ≤ x} ⊆
      ((Iio 0 ×ˢ univ) ∪ (univ ×ˢ Iio 0)) ∪
        ((Iic x ×ˢ Iic (x / (1 - θ))) ∪ (Ioc x (x / θ) ×ˢ Iic x)) := by
    rintro ⟨a, b⟩ hp
    simp only [mem_setOf_eq] at hp
    by_cases ha : a < 0
    · left; left; exact ⟨ha, trivial⟩
    by_cases hb : b < 0
    · left; right; exact ⟨trivial, hb⟩
    push_neg at ha hb
    right
    by_cases hax : a ≤ x
    · left
      refine ⟨hax, ?_⟩
      show b ≤ x / (1 - θ)
      rw [le_div_iff₀ h1θ]; nlinarith
    · right
      push_neg at hax
      refine ⟨⟨hax, ?_⟩, ?_⟩
      · show a ≤ x / θ
        rw [le_div_iff₀ hθ0]; nlinarith
      · show b ≤ x
        nlinarith
  have hν0 : ν (Iio 0) = 0 :=
    le_antisymm ((measure_mono Iio_subset_Iic_self).trans ((hνμ 0).trans hμ0.le)) (zero_le _)
  have hμ0' : μ (Iio 0) = 0 :=
    le_antisymm ((measure_mono Iio_subset_Iic_self).trans hμ0.le) (zero_le _)
  calc (μ.prod ν) {p : ℝ × ℝ | θ * p.1 + (1 - θ) * p.2 ≤ x}
      ≤ (μ.prod ν) (((Iio 0 ×ˢ univ) ∪ (univ ×ˢ Iio 0)) ∪
          ((Iic x ×ˢ Iic (x / (1 - θ))) ∪ (Ioc x (x / θ) ×ˢ Iic x))) := measure_mono hsub
    _ ≤ ((μ.prod ν) (Iio 0 ×ˢ univ) + (μ.prod ν) (univ ×ˢ Iio 0)) +
          ((μ.prod ν) (Iic x ×ˢ Iic (x / (1 - θ))) + (μ.prod ν) (Ioc x (x / θ) ×ˢ Iic x)) :=
        (measure_union_le _ _).trans (add_le_add (measure_union_le _ _) (measure_union_le _ _))
    _ = μ (Iic x) * ν (Iic (x / (1 - θ))) + μ (Ioc x (x / θ)) * ν (Iic x) := by
        simp only [Measure.prod_prod, hν0, hμ0', zero_mul, mul_zero, add_zero, zero_add]
    _ ≤ μ (Iic x) * μ (Iic (x / (1 - θ))) + μ (Ioc x (x / θ)) * μ (Iic x) := by
        gcongr <;> exact hνμ _
    _ = μ (Iic x) * (μ (Iic (x / (1 - θ))) + μ (Ioc x (x / θ))) := by ring
    _ ≤ μ (Iic x) := by
        rcases lt_or_le x 0 with hx | hx
        · have : μ (Iic x) = 0 :=
            le_antisymm ((measure_mono (Iic_subset_Iic.2 hx.le)).trans hμ0.le) (zero_le _)
          rw [this, zero_mul]
        · apply mul_le_of_le_one_right (zero_le _)
          have hxx : x ≤ x / θ := by rw [le_div_iff₀ hθ0]; nlinarith
          have hU : μ (Iic (x / θ)) = μ (Iic x) + μ (Ioc x (x / θ)) := by
            rw [← Iic_union_Ioc_eq_Iic hxx, measure_union (Iic_disjoint_Ioc le_rfl)
              measurableSet_Ioc]
          have h := cond23_measure μ h23 x hx θ hθ0 hθ1
          rw [hU, add_assoc] at h
          have := ENNReal.le_of_add_le_add_left (measure_ne_top μ (Iic x)) h
          rwa [add_comm] at this

/-- **Theorem 3.1** (CDF form): if `X ~ μ` is InvSub, then for i.i.d. copies and convex weights,
`P(θ₁X₁ + ⋯ + θₙXₙ ≤ x) ≤ F_X(x)` for all `x`. -/
theorem theorem_3_1 (μ : Measure ℝ) [IsProbabilityMeasure μ] (hμ : InvSub μ) :
    ∀ (n : ℕ) (θ : Fin n → ℝ), (∀ i, 0 ≤ θ i) → ∑ i, θ i = 1 → ∀ x : ℝ,
      (Measure.pi fun _ : Fin n => μ) {ω | ∑ i, θ i * ω i ≤ x} ≤ μ (Iic x) := by
  obtain ⟨hF0, h23⟩ := (lemma_2_3 μ).1 hμ
  have hμ0 : μ (Iic 0) = 0 := by
    rw [cdf_eq_real, measureReal_def, ENNReal.toReal_eq_zero_iff] at hF0
    exact hF0.resolve_right (measure_ne_top _ _)
  intro n
  induction n with
  | zero => intro θ _ hs; simp at hs
  | succ n ih =>
    intro θ hθ hs x
    set e := MeasurableEquiv.piFinSuccAbove (fun _ : Fin (n + 1) => ℝ) 0
    have hmp := measurePreserving_piFinSuccAbove (fun _ : Fin (n + 1) => μ) 0
    rw [Fin.sum_univ_succ] at hs
    set t := θ 0
    have hrest : ∑ j : Fin n, θ j.succ = 1 - t := by linarith
    have ht1 : t ≤ 1 := by
      have : 0 ≤ ∑ j : Fin n, θ j.succ := Finset.sum_nonneg fun j _ => hθ _
      linarith
    have hset : {ω : Fin (n + 1) → ℝ | ∑ i, θ i * ω i ≤ x} =
        e ⁻¹' {p : ℝ × (Fin n → ℝ) | t * p.1 + ∑ j, θ j.succ * p.2 j ≤ x} := by
      ext ω
      simp [e, Fin.sum_univ_succ, MeasurableEquiv.piFinSuccAbove_apply, Fin.insertNthEquiv,
        t, Fin.tail]
    have hmeasS : ∀ (c : ℝ) (w : Fin n → ℝ),
        MeasurableSet {p : ℝ × (Fin n → ℝ) | c * p.1 + ∑ j, w j * p.2 j ≤ x} := by
      intro c w
      exact measurableSet_le (by fun_prop) measurable_const
    rw [hset, hmp.measure_preimage (hmeasS _ _).nullMeasurableSet]
    rcases ht1.lt_or_eq with ht1 | ht1
    · -- general case `t < 1`: rescale the remaining weights
      have h1t : 0 < 1 - t := by linarith
      set θ' : Fin n → ℝ := fun j => θ j.succ / (1 - t)
      set V : (Fin n → ℝ) → ℝ := fun q => ∑ j, θ' j * q j
      have hV : Measurable V := by fun_prop
      set ν := (Measure.pi fun _ : Fin n => μ).map V
      haveI : IsProbabilityMeasure ν := isProbabilityMeasure_map hV.aemeasurable
      have hνμ : ∀ y, ν (Iic y) ≤ μ (Iic y) := by
        intro y
        rw [Measure.map_apply hV measurableSet_Iic]
        apply ih θ' (fun j => div_nonneg (hθ _) h1t.le)
          (by simp only [θ', ← Finset.sum_div, hrest]; field_simp)
      have hS : {p : ℝ × (Fin n → ℝ) | t * p.1 + ∑ j, θ j.succ * p.2 j ≤ x} =
          (Prod.map id V) ⁻¹' {p : ℝ × ℝ | t * p.1 + (1 - t) * p.2 ≤ x} := by
        ext p
        simp only [mem_setOf_eq, mem_preimage, Prod.map_fst, id, Prod.map_snd, V, θ',
          Finset.mul_sum]
        congr! 2
        apply Finset.sum_congr rfl
        intro j _
        field_simp
      rw [hS, ← Measure.map_apply (measurable_id.prodMap hV)
        (measurableSet_le (by fun_prop) measurable_const), ← Measure.map_prod_map _ _
        measurable_id hV, Measure.map_id]
      exact key_step μ ν hμ0 h23 hνμ t (hθ 0) ht1 x
    · -- degenerate case `t = 1`: all the other weights vanish
      have hz : ∀ j : Fin n, θ j.succ = 0 := by
        have h0 : ∑ j : Fin n, θ j.succ = 0 := by linarith
        intro j
        exact (Finset.sum_eq_zero_iff_of_nonneg fun j _ => hθ _).1 h0 j (Finset.mem_univ _)
      have : {p : ℝ × (Fin n → ℝ) | t * p.1 + ∑ j, θ j.succ * p.2 j ≤ x} = Iic x ×ˢ univ := by
        ext p; simp [hz, ht1]
      rw [this, Measure.prod_prod, measure_univ, mul_one]

/-- **Theorem 3.1** (survival form, as in (1.1)): `P(X > x) ≤ P(θ₁X₁ + ⋯ + θₙXₙ > x)`. -/
theorem theorem_3_1_st (μ : Measure ℝ) [IsProbabilityMeasure μ] (hμ : InvSub μ)
    (n : ℕ) (θ : Fin n → ℝ) (hθ : ∀ i, 0 ≤ θ i) (hs : ∑ i, θ i = 1) (x : ℝ) :
    μ (Ioi x) ≤ (Measure.pi fun _ : Fin n => μ) {ω | x < ∑ i, θ i * ω i} := by
  have h := theorem_3_1 μ hμ n θ hθ hs x
  have hm : MeasurableSet {ω : Fin n → ℝ | ∑ i, θ i * ω i ≤ x} :=
    measurableSet_le (by fun_prop) measurable_const
  have hc : {ω : Fin n → ℝ | x < ∑ i, θ i * ω i} = {ω | ∑ i, θ i * ω i ≤ x}ᶜ := by
    ext; simp
  rw [hc, prob_compl_eq_one_sub hm, ← compl_Iic, prob_compl_eq_one_sub measurableSet_Iic]
  exact tsub_le_tsub_left h 1

end

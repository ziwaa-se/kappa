import Mathlib

/-!
# Proposition 3.3: an InvSub random variable has infinite mean

Direct proof (independent of Theorem 3.1 / Proposition 3.2): subadditivity of
`G(x) = P(X > 1/x)` gives `P(X > c k) ≥ P(X > c)/k`, and the harmonic series diverges.
-/

open MeasureTheory ProbabilityTheory Set Filter Topology

noncomputable section

def InvSub (μ : Measure ℝ) : Prop :=
  cdf μ 0 = 0 ∧ ∀ x y : ℝ, 0 < x → 0 < y →
    1 - cdf μ (1 / (x + y)) ≤ (1 - cdf μ (1 / x)) + (1 - cdf μ (1 / y))

lemma one_sub_cdf (μ : Measure ℝ) [IsProbabilityMeasure μ] (x : ℝ) :
    1 - cdf μ x = μ.real (Ioi x) := by
  rw [cdf_eq_real, ← compl_Iic, measureReal_compl measurableSet_Iic, measureReal_univ_eq_one]

theorem prop_3_3 (μ : Measure ℝ) [IsProbabilityMeasure μ] (h : InvSub μ) :
    ¬ Integrable id μ := by
  intro hint
  obtain ⟨h0, hsub⟩ := h
  set G : ℝ → ℝ := fun x => μ.real (Ioi (1 / x))
  have hG : ∀ x y, 0 < x → 0 < y → G (x + y) ≤ G x + G y := by
    intro x y hx hy
    have := hsub x y hx hy
    simp only [one_sub_cdf] at this
    exact this
  -- `G (k z) ≤ k G z`
  have hGk : ∀ z, 0 < z → ∀ k : ℕ, G ((k + 1) * z) ≤ (k + 1) * G z := by
    intro z hz k
    induction k with
    | zero => simp
    | succ k ih =>
      have := hG ((k + 1) * z) z (by positivity) hz
      push_cast
      calc G ((k + 1 + 1) * z) = G ((k + 1) * z + z) := by ring_nf
        _ ≤ G ((k + 1) * z) + G z := this
        _ ≤ (k + 1) * G z + G z := by linarith
        _ = (k + 1 + 1) * G z := by ring
  -- `X ≥ 0` a.s. and some tail is positive
  have hμ0 : μ (Iic 0) = 0 := by
    rw [cdf_eq_real, measureReal_def, ENNReal.toReal_eq_zero_iff] at h0
    exact h0.resolve_right (measure_ne_top _ _)
  have hnonneg : ∀ᵐ ω ∂μ, 0 ≤ ω := by
    rw [ae_iff]
    refine measure_mono_null (fun ω hω => ?_) hμ0
    simp only [mem_setOf_eq, not_le] at hω
    exact hω.le
  obtain ⟨c, hc, hpos⟩ : ∃ c : ℝ, 0 < c ∧ 0 < μ.real (Ioi c) := by
    by_contra hcon
    push_neg at hcon
    have hz : ∀ n : ℕ, μ (Ioi (1 / ((n : ℝ) + 1))) = 0 := by
      intro n
      have := hcon (1 / ((n : ℝ) + 1)) (by positivity)
      rw [measureReal_def] at this
      have h' : (μ (Ioi (1 / ((n : ℝ) + 1)))).toReal = 0 := le_antisymm this ENNReal.toReal_nonneg
      rw [ENNReal.toReal_eq_zero_iff] at h'
      exact h'.resolve_right (measure_ne_top _ _)
    have hU : Ioi (0 : ℝ) = ⋃ n : ℕ, Ioi (1 / ((n : ℝ) + 1)) := by
      ext ω
      simp only [mem_Ioi, mem_iUnion]
      constructor
      · intro hω
        obtain ⟨n, hn⟩ := exists_nat_one_div_lt hω
        exact ⟨n, hn⟩
      · rintro ⟨n, hn⟩; exact lt_trans (by positivity) hn
    have h1 : μ (Ioi (0 : ℝ)) = 0 := by rw [hU]; exact measure_iUnion_null hz
    have h2 : μ (Iic (0 : ℝ) ∪ Ioi 0) = 0 := measure_union_null hμ0 h1
    rw [Iic_union_Ioi, measure_univ] at h2
    exact one_ne_zero h2
  -- tail bound `P(X > c (k+1)) ≥ P(X > c)/(k+1)`
  have htail : ∀ k : ℕ, μ.real (Ioi c) / (k + 1) ≤ μ.real (Ioi (c * (k + 1))) := by
    intro k
    have := hGk (1 / (c * (k + 1))) (by positivity) k
    have e1 : ((k : ℝ) + 1) * (1 / (c * (k + 1))) = 1 / c := by field_simp; ring
    have e2 : 1 / (1 / (c * ((k : ℝ) + 1))) = c * (k + 1) := by field_simp
    simp only [G, e1, e2, one_div_one_div] at this
    rw [div_le_iff₀ (by positivity)]
    linarith
  -- lower bound for the mean
  have hmean : ∀ N : ℕ, ∑ k ∈ Finset.range N, c * μ.real (Ioi (c * (k + 1))) ≤ ∫ ω, id ω ∂μ := by
    intro N
    have hint' : ∀ k ∈ Finset.range N,
        Integrable ((Ioi (c * ((k : ℝ) + 1))).indicator fun _ => c) μ :=
      fun k _ => (integrable_const c).indicator measurableSet_Ioi
    have : ∫ ω, ∑ k ∈ Finset.range N, (Ioi (c * ((k : ℝ) + 1))).indicator (fun _ => c) ω ∂μ =
        ∑ k ∈ Finset.range N, c * μ.real (Ioi (c * (k + 1))) := by
      rw [integral_finset_sum _ hint']
      refine Finset.sum_congr rfl fun k _ => ?_
      rw [integral_indicator_const _ measurableSet_Ioi, smul_eq_mul, mul_comm]
    rw [← this]
    refine integral_mono_ae (integrable_finset_sum _ hint') hint ?_
    filter_upwards [hnonneg] with ω hω
    simp only [Finset.sum_apply, id, indicator_apply, mem_Ioi]
    rw [Finset.sum_ite, Finset.sum_const_zero, add_zero, Finset.sum_const, nsmul_eq_mul]
    have hcard : (Finset.filter (fun k : ℕ => c * ((k : ℝ) + 1) < ω) (Finset.range N)).card ≤
        ⌊ω / c⌋₊ := by
      calc _ ≤ (Finset.range ⌊ω / c⌋₊).card := by
            apply Finset.card_le_card
            intro k hk
            simp only [Finset.mem_filter, Finset.mem_range] at hk ⊢
            have : ((k + 1 : ℕ) : ℝ) ≤ ω / c := by
              rw [le_div_iff₀ hc]; push_cast; linarith
            have := Nat.le_floor this
            omega
        _ = ⌊ω / c⌋₊ := Finset.card_range _
    have h1 : ((Finset.filter (fun k : ℕ => c * ((k : ℝ) + 1) < ω) (Finset.range N)).card : ℝ)
        ≤ ω / c := (Nat.cast_le.2 hcard).trans (Nat.floor_le (div_nonneg hω hc.le))
    calc _ ≤ ω / c * c := mul_le_mul_of_nonneg_right h1 hc.le
      _ = ω := by field_simp
  -- harmonic series diverges
  have hharm := Real.tendsto_sum_range_one_div_nat_succ_atTop
  obtain ⟨N, hN⟩ := (hharm.eventually_gt_atTop ((∫ ω, id ω ∂μ) / (c * μ.real (Ioi c)))).exists
  have hcm : 0 < c * μ.real (Ioi c) := mul_pos hc hpos
  have : c * μ.real (Ioi c) * ∑ k ∈ Finset.range N, (1 / ((k : ℝ) + 1)) ≤ ∫ ω, id ω ∂μ := by
    refine le_trans ?_ (hmean N)
    rw [Finset.mul_sum]
    refine Finset.sum_le_sum fun k _ => ?_
    have := htail k
    calc c * μ.real (Ioi c) * (1 / ((k : ℝ) + 1)) = c * (μ.real (Ioi c) / (k + 1)) := by ring
      _ ≤ c * μ.real (Ioi (c * (k + 1))) := mul_le_mul_of_nonneg_left this hc.le
  rw [div_lt_iff₀ hcm] at hN
  linarith

end

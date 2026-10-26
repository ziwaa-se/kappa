import Mathlib

open Filter Topology Set

noncomputable section

/-- Quantile grid: for a right-continuous distribution function `F` with left version `Fl`,
and `k ≥ 1`, there are `k` points `q 0, …, q (k-1)` bracketing every `t` up to `1/k`. -/
theorem grid (F Fl : ℝ → ℝ) (hmono : Monotone F) (h0 : ∀ t, 0 ≤ F t) (h1 : ∀ t, F t ≤ 1)
    (hbot : Tendsto F atBot (𝓝 0)) (htop : Tendsto F atTop (𝓝 1))
    (hrc : ∀ x, ContinuousWithinAt F (Ici x) x)
    (hFl : ∀ s c, (∀ t < s, F t ≤ c) → Fl s ≤ c) (k : ℕ) (hk : 1 ≤ k) :
    ∃ q : ℕ → ℝ, ∀ t,
      ((∃ j < k, t < q j ∧ Fl (q j) ≤ F t + 1 / k) ∨ 1 - 1 / k ≤ F t) ∧
      ((∃ j < k, q j ≤ t ∧ F t ≤ F (q j) + 1 / k) ∨ F t ≤ 1 / k) := by
  have hkpos : (0 : ℝ) < k := by exact_mod_cast hk
  let S : ℕ → Set ℝ := fun j => {t | (j : ℝ) / k ≤ F t}
  refine ⟨fun j => sInf (S j), ?_⟩
  -- basic facts for 1 ≤ j < k
  have hne : ∀ j, j < k → (S j).Nonempty := by
    intro j hj
    have : (j : ℝ) / k < 1 := by
      rw [div_lt_one hkpos]; exact_mod_cast hj
    obtain ⟨t, ht⟩ := (htop.eventually (lt_mem_nhds this)).exists
    exact ⟨t, le_of_lt ht⟩
  have hbdd : ∀ j, 1 ≤ j → BddBelow (S j) := by
    intro j hj
    have : (0 : ℝ) < (j : ℝ) / k := div_pos (by exact_mod_cast hj) hkpos
    obtain ⟨a, ha⟩ := Filter.eventually_atBot.1 (hbot.eventually (gt_mem_nhds this))
    refine ⟨a, fun t ht => ?_⟩
    by_contra h
    exact absurd (ha t (le_of_lt (not_le.1 h))) (not_lt.2 ht)
  have Q1 : ∀ j, 1 ≤ j → j < k → (j : ℝ) / k ≤ F (sInf (S j)) := by
    intro j hj1 hjk
    have hT : Tendsto F (𝓝[>] (sInf (S j))) (𝓝 (F (sInf (S j)))) :=
      (hrc _).mono Ioi_subset_Ici_self
    refine ge_of_tendsto hT (eventually_nhdsWithin_of_forall fun t ht => ?_)
    obtain ⟨s, hs, hst⟩ := exists_lt_of_csInf_lt (hne j hjk) ht
    exact le_trans hs (hmono hst.le)
  have Q4 : ∀ j : ℕ, 1 ≤ j → ∀ t : ℝ, (j : ℝ) / k ≤ F t → sInf (S j) ≤ t :=
    fun j hj t ht => csInf_le (hbdd j hj) ht
  have Q2 : ∀ j, 1 ≤ j → j < k → ∀ t, t < sInf (S j) → F t ≤ (j : ℝ) / k := by
    intro j hj1 _ t ht
    by_contra h
    exact absurd (Q4 j hj1 t (le_of_lt (not_le.1 h))) (not_le.2 ht)
  intro t
  set m := ⌊(k : ℝ) * F t⌋₊ with hm
  have hx0 : 0 ≤ (k : ℝ) * F t := mul_nonneg hkpos.le (h0 t)
  have hm1 : (m : ℝ) ≤ k * F t := Nat.floor_le hx0
  have hm2 : (k : ℝ) * F t < m + 1 := Nat.lt_floor_add_one _
  have hFm1 : (m : ℝ) / k ≤ F t := by rw [div_le_iff₀ hkpos]; linarith
  have hFm2 : F t < ((m : ℝ) + 1) / k := by rw [lt_div_iff₀ hkpos]; linarith
  have hdiv : ∀ a : ℝ, (a + 1) / k = a / k + 1 / k := fun a => by ring
  constructor
  · by_cases hmk : k - 1 ≤ m
    · right
      have : ((k : ℝ) - 1) ≤ m := by
        have := (Nat.cast_le (α := ℝ)).2 hmk
        rw [Nat.cast_sub hk] at this; simpa using this
      have : ((k : ℝ) - 1) / k ≤ F t := le_trans (div_le_div_of_nonneg_right this hkpos.le) hFm1
      have e : ((k : ℝ) - 1) / k = 1 - 1 / k := by field_simp
      linarith
    · left
      have hj1 : 1 ≤ m + 1 := by omega
      have hjk : m + 1 < k := by omega
      refine ⟨m + 1, hjk, ?_, ?_⟩
      · by_contra h
        have := le_trans (Q1 (m + 1) hj1 hjk) (hmono (not_lt.1 h))
        push_cast at this
        linarith
      · have := hFl _ _ (Q2 (m + 1) hj1 hjk)
        push_cast at this
        rw [hdiv] at this
        linarith
  · by_cases hk1 : k = 1
    · right
      have : (1 : ℝ) / k = 1 := by rw [hk1]; simp
      rw [this]; exact h1 t
    by_cases hm0 : m = 0
    · right
      rw [hm0] at hFm2; simpa using hFm2.le
    left
    refine ⟨min m (k - 1), by omega, Q4 _ (by omega) t ?_, ?_⟩
    · refine le_trans (div_le_div_of_nonneg_right ?_ hkpos.le) hFm1
      exact_mod_cast min_le_left _ _
    · have hq := Q1 (min m (k - 1)) (by omega) (by omega)
      rcases le_total m (k - 1) with h | h
      · rw [min_eq_left h] at hq ⊢
        rw [hdiv] at hFm2; linarith
      · rw [min_eq_right h] at hq ⊢
        have e : (((k - 1 : ℕ) : ℝ)) / k + 1 / k = 1 := by
          rw [Nat.cast_sub hk]; field_simp
        linarith [h1 t]


open MeasureTheory ProbabilityTheory

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]

open Classical

set_option linter.unusedSectionVars false

/-- Empirical frequency of a set `S` among `X 0 ω, …, X (n-1) ω`. -/
def empS (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (S : Set ℝ) : ℝ :=
  (((Finset.range n).filter (fun i => X i ω ∈ S)).card : ℝ) / n

/-- Strong law applied to indicators. -/
theorem slln_set (X : ℕ → Ω → ℝ) (hX : ∀ i, Measurable (X i))
    (hindep : Pairwise (fun i j => IndepFun (X i) (X j) μ))
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ) (S : Set ℝ) (hS : MeasurableSet S) :
    ∀ᵐ ω ∂μ, Tendsto (fun n => empS X n ω S) atTop (𝓝 ((μ.map (X 0)).real S)) := by
  let g : ℝ → ℝ := S.indicator 1
  have hg : Measurable g := measurable_one.indicator hS
  let Y : ℕ → Ω → ℝ := fun i => g ∘ X i
  have h := strong_law_ae_real Y
    ((integrable_const (1 : ℝ)).indicator (hX 0 hS) |>.congr
      (Eventually.of_forall fun ω => by
        simp only [Y, g, Function.comp, Set.indicator_apply, Set.mem_preimage, Pi.one_apply]))
    (fun i j hij => (hindep hij).comp hg hg)
    (fun i => (hident i).comp hg)
  have hE : μ[Y 0] = (μ.map (X 0)).real S := by
    rw [map_measureReal_apply (hX 0) hS, ← integral_indicator_one ((hX 0) hS)]
    congr 1
  rw [hE] at h
  filter_upwards [h] with ω hω
  convert hω using 2 with n
  simp only [empS, Y, g, Function.comp, Set.indicator_apply, Pi.one_apply]
  rw [Finset.sum_boole]

theorem empS_mono (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) {S T : Set ℝ} (h : S ⊆ T) :
    empS X n ω S ≤ empS X n ω T := by
  unfold empS
  apply div_le_div_of_nonneg_right _ (Nat.cast_nonneg _)
  exact_mod_cast Finset.card_le_card (fun i hi => by
    simp only [Finset.mem_filter] at hi ⊢
    exact ⟨hi.1, h hi.2⟩)

theorem empS_nonneg (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (S : Set ℝ) : 0 ≤ empS X n ω S := by
  unfold empS; positivity

theorem empS_le_one (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (S : Set ℝ) : empS X n ω S ≤ 1 := by
  unfold empS
  rcases Nat.eq_zero_or_pos n with h | h
  · simp [h]
  · rw [div_le_one (by exact_mod_cast h)]
    have := Finset.card_filter_le (Finset.range n) (fun i => X i ω ∈ S)
    simp only [Finset.card_range] at this
    exact_mod_cast this

/-- Left-limit property of the distribution function of a probability measure on `ℝ`. -/
theorem real_Iio_le (ν : Measure ℝ) [IsProbabilityMeasure ν] (s c : ℝ)
    (h : ∀ t < s, cdf ν t ≤ c) : ν.real (Iio s) ≤ c := by
  have hc : 0 ≤ c := le_trans (cdf_nonneg ν (s - 1)) (h _ (by linarith))
  let f : ℕ → Set ℝ := fun n => Iic (s - 1 / ((n : ℝ) + 1))
  have hf : Monotone f := by
    intro a b hab
    apply Iic_subset_Iic.2
    have : (1 : ℝ) / ((b : ℝ) + 1) ≤ 1 / ((a : ℝ) + 1) := by
      apply one_div_le_one_div_of_le (by positivity)
      exact_mod_cast Nat.add_le_add_right hab 1
    linarith
  have hU : (⋃ n, f n) = Iio s := by
    ext x
    simp only [mem_iUnion, mem_Iic, mem_Iio, f]
    constructor
    · rintro ⟨n, hn⟩
      have : (0 : ℝ) < 1 / ((n : ℝ) + 1) := by positivity
      linarith
    · intro hx
      obtain ⟨n, hn⟩ := exists_nat_one_div_lt (sub_pos.2 hx)
      exact ⟨n, by linarith⟩
  have hT := tendsto_measure_iUnion_atTop (μ := ν) hf
  rw [hU] at hT
  have : ν (Iio s) ≤ ENNReal.ofReal c := by
    refine le_of_tendsto' hT fun n => ?_
    show ν (Iic _) ≤ _
    rw [← ofReal_cdf]
    exact ENNReal.ofReal_le_ofReal (h _ (by
      have : (0 : ℝ) < 1 / ((n : ℝ) + 1) := by positivity
      linarith))
  exact ENNReal.toReal_le_of_le_ofReal hc this

/-- **Proposition 2.2 (Glivenko–Cantelli).** For i.i.d. (indeed pairwise independent,
identically distributed) real random variables, `D_n = sup_t |F_n(t) - F(t)| → 0` a.s. -/
theorem glivenko_cantelli (X : ℕ → Ω → ℝ) (hX : ∀ i, Measurable (X i))
    (hindep : Pairwise (fun i j => IndepFun (X i) (X j) μ))
    (hident : ∀ i, IdentDistrib (X i) (X 0) μ μ) :
    ∀ᵐ ω ∂μ, Tendsto
      (fun n : ℕ => ⨆ t : ℝ,
        |(((Finset.range n).filter (fun i => X i ω ≤ t)).card : ℝ) / n - μ.real {ω' | X 0 ω' ≤ t}|)
      atTop (𝓝 0) := by
  let ν : Measure ℝ := μ.map (X 0)
  haveI : IsProbabilityMeasure ν := isProbabilityMeasure_map (hX 0).aemeasurable
  let F : ℝ → ℝ := cdf ν
  let Fl : ℝ → ℝ := fun s => ν.real (Iio s)
  have hFeq : ∀ t, μ.real {ω' | X 0 ω' ≤ t} = F t := by
    intro t
    simp only [F, cdf_eq_real, ν, map_measureReal_apply (hX 0) measurableSet_Iic]
    rfl
  have hgrid : ∀ k : ℕ, ∃ q : ℕ → ℝ, 1 ≤ k → ∀ t,
      ((∃ j < k, t < q j ∧ Fl (q j) ≤ F t + 1 / k) ∨ 1 - 1 / k ≤ F t) ∧
      ((∃ j < k, q j ≤ t ∧ F t ≤ F (q j) + 1 / k) ∨ F t ≤ 1 / k) := by
    intro k
    by_cases hk : 1 ≤ k
    · obtain ⟨q, hq⟩ := grid F Fl (monotone_cdf ν) (cdf_nonneg ν) (cdf_le_one ν)
        (tendsto_cdf_atBot ν) (tendsto_cdf_atTop ν) (cdf ν).right_continuous
        (fun s c h => real_Iio_le ν s c h) k hk
      exact ⟨q, fun _ => hq⟩
    · exact ⟨fun _ => 0, fun h => absurd h hk⟩
  choose q hq using hgrid
  have hgood : ∀ᵐ ω ∂μ, ∀ k j : ℕ,
      Tendsto (fun n => empS X n ω (Iic (q k j))) atTop (𝓝 (F (q k j))) ∧
      Tendsto (fun n => empS X n ω (Iio (q k j))) atTop (𝓝 (Fl (q k j))) := by
    rw [ae_all_iff]; intro k
    rw [ae_all_iff]; intro j
    filter_upwards [slln_set X hX hindep hident _ measurableSet_Iic,
      slln_set X hX hindep hident _ measurableSet_Iio] with ω h1 h2
    refine ⟨?_, h2⟩
    simpa [F, cdf_eq_real] using h1
  filter_upwards [hgood] with ω hω
  have hEq : ∀ n t, (((Finset.range n).filter (fun i => X i ω ≤ t)).card : ℝ) / n
      = empS X n ω (Iic t) := by
    intro n t; simp [empS]
  simp_rw [hEq, hFeq]
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨k, hk⟩ := exists_nat_one_div_lt (half_pos hε)
  set K := k + 1 with hK
  have hK1 : 1 ≤ K := by omega
  have hKε : 1 / (K : ℝ) < ε / 2 := by simpa [hK] using hk
  have hev : ∀ᶠ n in atTop, ∀ j ∈ Finset.range K,
      |empS X n ω (Iic (q K j)) - F (q K j)| < ε / 2 ∧
      |empS X n ω (Iio (q K j)) - Fl (q K j)| < ε / 2 := by
    rw [Finset.eventually_all]
    intro j _
    have a := (Metric.tendsto_atTop.1 (hω K j).1) (ε / 2) (half_pos hε)
    have b := (Metric.tendsto_atTop.1 (hω K j).2) (ε / 2) (half_pos hε)
    obtain ⟨N1, hN1⟩ := a
    obtain ⟨N2, hN2⟩ := b
    rw [Filter.eventually_atTop]
    exact ⟨max N1 N2, fun n hn =>
      ⟨hN1 n (le_of_max_le_left hn), hN2 n (le_of_max_le_right hn)⟩⟩
  obtain ⟨N, hN⟩ := Filter.eventually_atTop.1 hev
  refine ⟨N, fun n hn => ?_⟩
  have hbound : ∀ t, |empS X n ω (Iic t) - F t| ≤ 1 / K + ε / 2 := by
    intro t
    obtain ⟨hU, hL⟩ := hq K hK1 t
    rw [abs_le]
    constructor
    · rcases hL with ⟨j, hj, hqt, hFt⟩ | hFt
      · have h1 := empS_mono X n ω (Iic_subset_Iic.2 hqt)
        have h2 := (abs_lt.1 (hN n hn j (Finset.mem_range.2 hj)).1).1
        linarith
      · have := empS_nonneg X n ω (Iic t)
        have : 0 < ε / 2 := half_pos hε
        linarith
    · rcases hU with ⟨j, hj, htq, hFt⟩ | hFt
      · have h1 := empS_mono X n ω (Iic_subset_Iio.2 htq)
        have h2 := (abs_lt.1 (hN n hn j (Finset.mem_range.2 hj)).2).2
        linarith
      · have := empS_le_one X n ω (Iic t)
        have : 0 < ε / 2 := half_pos hε
        linarith
  rw [Real.dist_eq, sub_zero, abs_of_nonneg (Real.iSup_nonneg fun t => abs_nonneg _)]
  calc (⨆ t, |empS X n ω (Iic t) - F t|) ≤ 1 / K + ε / 2 := ciSup_le hbound
    _ < ε := by linarith

end

#print axioms glivenko_cantelli

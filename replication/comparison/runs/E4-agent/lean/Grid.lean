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

end

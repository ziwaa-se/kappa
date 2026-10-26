import Mathlib

/-! Lemma 2.1: the empirical distribution function is nondecreasing and `n F_n(t) ∈ {0,…,n}`. -/

noncomputable section

/-- Definition 1.1: `F_n(t) = (1/n) #{i : x_i ≤ t}`. -/
def edf {n : ℕ} (x : Fin n → ℝ) (t : ℝ) : ℝ :=
  ((Finset.univ.filter (fun i => x i ≤ t)).card : ℝ) / n

theorem edf_monotone {n : ℕ} (x : Fin n → ℝ) : Monotone (edf x) := by
  intro s t hst
  unfold edf
  apply div_le_div_of_nonneg_right _ (Nat.cast_nonneg _)
  exact_mod_cast Finset.card_le_card (fun i hi => by
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hi ⊢
    exact hi.trans hst)

theorem edf_mul_mem {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) (t : ℝ) :
    ∃ m : ℕ, m ≤ n ∧ (n : ℝ) * edf x t = m := by
  refine ⟨(Finset.univ.filter (fun i => x i ≤ t)).card, ?_, ?_⟩
  · simpa using Finset.card_filter_le (Finset.univ : Finset (Fin n)) (fun i => x i ≤ t)
  · have : (n : ℝ) ≠ 0 := by exact_mod_cast (show n ≠ 0 by omega)
    unfold edf
    field_simp

/-- Lemma 2.1 as stated in the paper. -/
theorem lemma_2_1 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) :
    Monotone (edf x) ∧ ∀ t, ∃ m : ℕ, m ≤ n ∧ (n : ℝ) * edf x t = m :=
  ⟨edf_monotone x, edf_mul_mem hn x⟩

end

#print axioms lemma_2_1

import Mathlib

open Finset

/-- Empirical distribution function of `x : Fin n → ℝ` (Definition 1.1). -/
noncomputable def empCDF {n : ℕ} (x : Fin n → ℝ) (t : ℝ) : ℝ :=
  ((univ.filter fun i => x i ≤ t).card : ℝ) / n

theorem empCDF_mono {n : ℕ} (x : Fin n → ℝ) : Monotone (empCDF x) := by
  intro s t hst
  have h : (univ.filter fun i => x i ≤ s).card ≤ (univ.filter fun i => x i ≤ t).card := by
    apply card_le_card
    intro i hi
    simp only [mem_filter, mem_univ, true_and] at hi ⊢
    exact hi.trans hst
  unfold empCDF
  gcongr

theorem empCDF_values {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) (t : ℝ) :
    ∃ k : ℕ, k ≤ n ∧ (n : ℝ) * empCDF x t = k := by
  refine ⟨(univ.filter fun i => x i ≤ t).card, ?_, ?_⟩
  · simpa using card_filter_le univ (fun i => x i ≤ t)
  · have : (n : ℝ) ≠ 0 := by exact_mod_cast hn.ne'
    unfold empCDF
    field_simp

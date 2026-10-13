import L01Stmt

namespace Paper.L01

open Paper.Defs

/-- S1. source/main.tex:41 -/
theorem L01_S1 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) : Monotone (edf x) := by
  intro s t hst
  unfold edf
  have hpos : (0 : ℝ) ≤ 1 / (n : ℝ) := by positivity
  apply mul_le_mul_of_nonneg_left _ hpos
  -- main.tex:41: every i with x_i ≤ s also satisfies x_i ≤ t
  have hsub : (Finset.univ.filter (fun i : Fin n => x i ≤ s)) ⊆
      (Finset.univ.filter (fun i : Fin n => x i ≤ t)) := by
    intro i hi
    simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hi ⊢
    exact hi.trans hst
  exact_mod_cast Finset.card_le_card hsub

/-- S2. source/main.tex:41-42 -/
theorem L01_S2 {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) (t : ℝ) :
    ∃ k : ℕ, k ∈ Finset.range (n + 1) ∧ (n : ℝ) * edf x t = (k : ℝ) := by
  refine ⟨(Finset.univ.filter (fun i : Fin n => x i ≤ t)).card, ?_, ?_⟩
  · -- counts a subset of {1,…,n}
    have := Finset.card_le_univ (Finset.univ.filter (fun i : Fin n => x i ≤ t))
    simp only [Finset.mem_range, Fintype.card_fin] at this ⊢
    omega
  · unfold edf
    have : (n : ℝ) ≠ 0 := by positivity
    field_simp

theorem L01_main {n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ) : Conclusion x :=
  ⟨L01_S1 hn x, L01_S2 hn x⟩

end Paper.L01

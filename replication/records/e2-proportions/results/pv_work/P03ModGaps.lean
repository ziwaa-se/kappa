import P03Stmt

namespace Paper.P03

open Paper.DEFS

/-- Gap for S1 (main.tex:86), stopped: PAPER_ARGUMENT_GAP. -/
def P03_S1_Gap : Prop :=
  ∀ (m : ℕ) (_hm : 2 ≤ m) (x y : Fin m → ℝ), s2 (x + y) = s2 x + s2 y

private lemma s2_nonneg (m : ℕ) (hm : 2 ≤ m) (u : Fin m → ℝ) : 0 ≤ s2 u := by
  have h2 : (2 : ℝ) ≤ m := by exact_mod_cast hm
  unfold s2
  apply mul_nonneg
  · apply one_div_nonneg.mpr; linarith
  · exact Finset.sum_nonneg (fun i _ => sq_nonneg _)

/-- S2. main.tex:86-87, nonnegativity of both terms. -/
theorem P03_S2 (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 x + s2 y ≤ 2 * s2 x + 2 * s2 y := by
  have hx := s2_nonneg m hm x
  have hy := s2_nonneg m hm y
  linarith

/-- Main theorem, main.tex:81-83, modulo the S1 gap. -/
theorem P03_main_mod_gaps (hGap_1 : P03_S1_Gap) (m : ℕ) (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    P03Concl x y := by
  unfold P03Concl
  rw [hGap_1 m hm x y]
  exact P03_S2 m hm x y

end Paper.P03

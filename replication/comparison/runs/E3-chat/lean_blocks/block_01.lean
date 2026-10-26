import Mathlib

namespace OracleShrinkage

variable (θ σ : ℝ)

def R (c : ℝ) : ℝ := c ^ 2 * σ ^ 2 + (1 - c) ^ 2 * θ ^ 2
noncomputable def cstar : ℝ := θ ^ 2 / (θ ^ 2 + σ ^ 2)
noncomputable def ρ : ℝ := θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2)

lemma denom_pos (hσ : 0 < σ) : 0 < θ ^ 2 + σ ^ 2 := by positivity

/-- Lemma 2.1 -/
lemma square (hσ : 0 < σ) (c : ℝ) :
    R θ σ c - ρ θ σ = (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 := by
  have h := (denom_pos θ σ hσ).ne'
  unfold R ρ cstar
  field_simp
  ring

/-- Lemma 2.2 (statement correct; proof uses ρ = θ²·σ²/(θ²+σ²) ≤ θ², σ²) -/
lemma le_min' (hσ : 0 < σ) : ρ θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  have hd := denom_pos θ σ hσ
  unfold ρ
  apply le_min
  · rw [div_le_iff₀ hd]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg θ) (sq_nonneg θ)]
  · rw [div_le_iff₀ hd]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg σ) (sq_nonneg σ)]

/-- Counterexample to the intermediate claim ρ ≤ ½·min in the paper's proof:
    θ = 1, σ² = 3 (σ = √3). -/
example : ¬ (ρ 1 (Real.sqrt 3) ≤ (1 / 2) * min (1 ^ 2) (Real.sqrt 3 ^ 2)) := by
  have h3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  unfold ρ
  rw [h3]
  norm_num

/-- Theorem 2.3 -/
theorem oracle (hσ : 0 < σ) :
    (∀ c, ρ θ σ ≤ R θ σ c) ∧
    (∀ c, R θ σ c = ρ θ σ ↔ c = cstar θ σ) ∧
    ρ θ σ ≤ min (R θ σ 0) (R θ σ 1) := by
  have hd := denom_pos θ σ hσ
  refine ⟨fun c => ?_, fun c => ?_, ?_⟩
  · have := square θ σ hσ c
    nlinarith [mul_nonneg hd.le (sq_nonneg (c - cstar θ σ))]
  · have := square θ σ hσ c
    constructor
    · intro h
      have h0 : (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 = 0 := by linarith
      rcases mul_eq_zero.mp h0 with h1 | h1
      · exact absurd h1 hd.ne'
      · exact sub_eq_zero.mp (pow_eq_zero_iff (n := 2) (by norm_num) |>.mp h1)
    · intro h; subst h; simp at this; linarith
  · have h0 : R θ σ 0 = θ ^ 2 := by unfold R; ring
    have h1 : R θ σ 1 = σ ^ 2 := by unfold R; ring
    rw [h0, h1]
    exact le_min' θ σ hσ

/-- Corollary 2.4 -/
theorem half (hσ : 0 < σ) : R θ σ (cstar θ σ) ≤ R θ σ (1 / 2) := by
  have h1 := (oracle θ σ hσ).1 (1 / 2)
  have h2 := ((oracle θ σ hσ).2.1 (cstar θ σ)).mpr rfl
  linarith

end OracleShrinkage

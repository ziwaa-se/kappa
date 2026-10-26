import Mathlib

noncomputable section

def R (θ σ c : ℝ) : ℝ := c ^ 2 * σ ^ 2 + (1 - c) ^ 2 * θ ^ 2
def cstar (θ σ : ℝ) : ℝ := θ ^ 2 / (θ ^ 2 + σ ^ 2)
def rho (θ σ : ℝ) : ℝ := θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2)

lemma pos_sum {θ σ : ℝ} (hσ : 0 < σ) : 0 < θ ^ 2 + σ ^ 2 := by positivity

/-- Lemma 2.1 -/
theorem lem_square (θ σ c : ℝ) (hσ : 0 < σ) :
    R θ σ c - rho θ σ = (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 := by
  have h := (pos_sum (θ := θ) hσ).ne'
  unfold R rho cstar
  field_simp
  ring

/-- Lemma 2.2 (statement) -/
theorem lem_min (θ σ : ℝ) (hσ : 0 < σ) :
    rho θ σ ≤ min (θ ^ 2) (σ ^ 2) := by
  have hp := pos_sum (θ := θ) hσ
  unfold rho
  apply le_min
  · rw [div_le_iff₀ hp]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg θ) (sq_nonneg θ)]
  · rw [div_le_iff₀ hp]; nlinarith [sq_nonneg θ, sq_nonneg σ, mul_nonneg (sq_nonneg σ) (sq_nonneg σ)]

/-- Lemma 2.2's proof claims the harmonic mean of two positive numbers is at most
their minimum. False: a = 1, b = 4 gives 8/5 > 1. -/
example : ¬ (∀ a b : ℝ, 0 < a → 0 < b → 2 * a * b / (a + b) ≤ min a b) := by
  intro h
  have := h 1 4 (by norm_num) (by norm_num)
  norm_num at this

/-- Lemma 2.2's proof also claims ρ ≤ ½ min{θ², σ²}. False for θ = 1, σ = 2 (ρ = 4/5). -/
example : ¬ (rho 1 2 ≤ (1 / 2) * min ((1 : ℝ) ^ 2) (2 ^ 2)) := by
  unfold rho; norm_num

/-- The correct bound in the harmonic-mean framing: H ≤ 2 min, i.e. ρ = H/2 ≤ min. -/
example (a b : ℝ) (ha : 0 < a) (hb : 0 < b) : 2 * a * b / (a + b) ≤ 2 * min a b := by
  rw [div_le_iff₀ (by linarith)]
  rcases le_total a b with h | h
  · rw [min_eq_left h]; nlinarith
  · rw [min_eq_right h]; nlinarith

/-- Theorem 2.3 -/
theorem thm_oracle (θ σ : ℝ) (hσ : 0 < σ) :
    (∀ c, rho θ σ ≤ R θ σ c) ∧ (∀ c, R θ σ c = rho θ σ ↔ c = cstar θ σ) ∧
    rho θ σ ≤ min (R θ σ 0) (R θ σ 1) := by
  have hp := pos_sum (θ := θ) hσ
  refine ⟨fun c => ?_, fun c => ?_, ?_⟩
  · have := lem_square θ σ c hσ
    nlinarith [mul_nonneg hp.le (sq_nonneg (c - cstar θ σ))]
  · have := lem_square θ σ c hσ
    constructor
    · intro h
      have : (θ ^ 2 + σ ^ 2) * (c - cstar θ σ) ^ 2 = 0 := by linarith
      rcases mul_eq_zero.1 this with h1 | h1
      · exact absurd h1 hp.ne'
      · exact sub_eq_zero.1 (pow_eq_zero_iff (n := 2) (by norm_num) |>.1 h1)
    · intro h; subst h; simp at this; linarith
  · have h0 : R θ σ 0 = θ ^ 2 := by unfold R; ring
    have h1 : R θ σ 1 = σ ^ 2 := by unfold R; ring
    rw [h0, h1]; exact lem_min θ σ hσ

/-- Corollary 2.4 -/
theorem cor_half (θ σ : ℝ) (hσ : 0 < σ) : R θ σ (cstar θ σ) ≤ R θ σ (1 / 2) :=
  (thm_oracle θ σ hσ).2.1 (cstar θ σ) |>.2 rfl ▸ (thm_oracle θ σ hσ).1 _

end

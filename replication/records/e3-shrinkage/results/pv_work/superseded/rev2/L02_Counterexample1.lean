import L02Stmt

/-!
# L02 issue 1: counterexamples to the intermediate claims printed in the proof of Lemma lem:min

Source: source/main.tex:53-55
"The number ρ is half the harmonic mean 2θ²σ²/(θ²+σ²) of θ² and σ². The harmonic mean of two
positive numbers is at most the smaller of them, so ρ ≤ ½ min{θ², σ²} ≤ min{θ², σ²}."

Written by pv-issue-checker. Not part of any proof of L02.
-/

namespace Paper.L02.Issue1

open Paper Paper.L02

/-- Printed clause A (main.tex:54), verbatim: "The harmonic mean of two positive numbers is at most
the smaller of them." Harmonic mean as printed at main.tex:53: 2ab/(a+b). -/
def PrintedClauseA : Prop :=
  ∀ a b : ℝ, 0 < a → 0 < b → 2 * a * b / (a + b) ≤ min a b

/-- Clause A is literally the gated `HarmonicLeMin` (L02Stmt.lean). -/
theorem printedClauseA_iff : PrintedClauseA ↔ HarmonicLeMin := Iff.rfl

/-- Counterexample to clause A: a = 1, b = 4 (both positive), HM = 8/5 > 1 = min. -/
theorem counterexampleA : ¬ PrintedClauseA := by
  intro h
  have := h 1 4 (by norm_num) (by norm_num)
  norm_num at this

/-- Printed clause B (main.tex:55, first inequality), under the standing assumption main.tex:25
"θ ≠ 0 and σ > 0": ρ ≤ ½ min{θ², σ²}. -/
def PrintedClauseB : Prop :=
  ∀ θ σ : ℝ, Setting θ σ → oracleRisk θ σ ≤ (1 / 2) * min (θ ^ 2) (σ ^ 2)

/-- Counterexample to clause B: θ = 1, σ = 2 satisfy main.tex:25; ρ = 4/5 > 1/2. -/
theorem counterexampleB : ¬ PrintedClauseB := by
  intro h
  have := h 1 2 ⟨by norm_num, by norm_num⟩
  unfold oracleRisk at this
  norm_num at this

/-- Scope: clause B fails at every admissible (θ, σ) with θ² ≠ σ²; it holds only when θ² = σ². -/
theorem clauseB_pointwise_iff (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ ≤ (1 / 2) * min (θ ^ 2) (σ ^ 2) ↔ θ ^ 2 = σ ^ 2 := by
  have ht : 0 < θ ^ 2 := by have := h.theta_ne; positivity
  have hs : 0 < σ ^ 2 := by have := h.sigma_pos; positivity
  unfold oracleRisk
  rw [div_le_iff₀ (by positivity)]
  constructor
  · intro hle
    rcases le_total (θ ^ 2) (σ ^ 2) with hab | hab
    · rw [min_eq_left hab] at hle
      nlinarith
    · rw [min_eq_right hab] at hle
      nlinarith
  · intro heq
    rw [heq, min_self]
    nlinarith

/-- The direction of clause A is reversed: the harmonic mean is at least the smaller number. -/
theorem harmonicMean_ge_min (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    min a b ≤ harmonicMean a b := by
  unfold harmonicMean
  rw [le_div_iff₀ (by positivity)]
  rcases le_total a b with hab | hab
  · rw [min_eq_left hab]; nlinarith
  · rw [min_eq_right hab]; nlinarith

/-- Scope check (consumed_of_printed): the false clause B is strictly stronger than what L02 states
and what downstream results consume (main.tex:66, 75 use only ρ ≤ min{θ², σ²}).
So the refutation of B does not refute the lemma's conclusion. -/
theorem consumed_of_printed (hB : PrintedClauseB) : ∀ θ σ : ℝ, Setting θ σ → Conclusion θ σ := by
  intro θ σ h
  have hm : 0 ≤ min (θ ^ 2) (σ ^ 2) := le_min (sq_nonneg _) (sq_nonneg _)
  have := hB θ σ h
  unfold Conclusion
  linarith

/-- The lemma's printed conclusion (main.tex:49) is true. Sanity check only; NOT the source route,
not used for any verdict on L02. -/
theorem conclusion_true (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ := by
  have ht : 0 < θ ^ 2 := by have := h.theta_ne; positivity
  have hs : 0 < σ ^ 2 := by have := h.sigma_pos; positivity
  unfold Conclusion oracleRisk
  rw [le_min_iff, div_le_iff₀ (by positivity), div_le_iff₀ (by positivity)]
  constructor <;> nlinarith

/-- Check of the suggested fix (constructed by the reviewer, not in the source, suggestion only):
"the harmonic mean of two positive numbers is at most twice the smaller of them". -/
theorem fix_harmonicMean_le_two_min (a b : ℝ) (ha : 0 < a) (hb : 0 < b) :
    harmonicMean a b ≤ 2 * min a b := by
  unfold harmonicMean
  rw [div_le_iff₀ (by positivity)]
  rcases le_total a b with hab | hab
  · rw [min_eq_left hab]; nlinarith
  · rw [min_eq_right hab]; nlinarith

/-- The fixed chain closes: ρ = ½ HM (main.tex:53) and HM ≤ 2 min give ρ ≤ min. -/
theorem fix_chain (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ := by
  have ht : 0 < θ ^ 2 := by have := h.theta_ne; positivity
  have hs : 0 < σ ^ 2 := by have := h.sigma_pos; positivity
  have h1 : oracleRisk θ σ = (1 / 2) * harmonicMean (θ ^ 2) (σ ^ 2) := by
    unfold oracleRisk harmonicMean; ring
  have h2 := fix_harmonicMean_le_two_min (θ ^ 2) (σ ^ 2) ht hs
  unfold Conclusion
  rw [h1]
  linarith

end Paper.L02.Issue1

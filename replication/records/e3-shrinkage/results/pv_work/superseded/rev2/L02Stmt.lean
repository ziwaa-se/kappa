import Defs

namespace Paper.L02

/-- L02 conclusion (source/main.tex:48-50): "ρ ≤ min{θ², σ²}". -/
def Conclusion (θ σ : ℝ) : Prop :=
  oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2)

/-- Harmonic mean of two numbers (source/main.tex:53): "2θ²σ²/(θ²+σ²)" is the harmonic mean
of θ² and σ². Auxiliary notation for the proof steps. -/
noncomputable def harmonicMean (a b : ℝ) : ℝ := 2 * a * b / (a + b)

/-- The source's assertion (main.tex:54), worded as printed: "The harmonic mean of two positive
numbers is at most the smaller of them." Provenance (ii) asserted without proof. Stated exactly
as worded; NOT corrected. Not used as an external hypothesis: it is an obligation S2 in the
draft (no verdict on its truth is made here). -/
def HarmonicLeMin : Prop :=
  ∀ a b : ℝ, 0 < a → 0 < b → harmonicMean a b ≤ min a b

end Paper.L02

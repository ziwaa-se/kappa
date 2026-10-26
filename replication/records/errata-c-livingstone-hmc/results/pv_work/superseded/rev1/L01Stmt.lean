import Defs

/-!
# L01 = Lemma 5.15 (lem:xelower), statement definitions
Source: source/geo_erg_HMC_v3.1.tex:884-886.  No external parameter is needed: the single-step
formula `x_ε = x_0 - (ε²/2)∇U(x_0) + ε p_0` (TEX:890, the case `L = 1` of Prop. 4.2, TEX:364) is
derivable by unfolding `Paper.Defs.leapfrogStep` (see step S1 in the draft), so Prop. 4.2 is NOT
used as an input here.
-/

open Paper.Defs

namespace Paper.L01

/-- Literal reading of TEX:885: `∃ η` such that for all `x_0` with `‖x_0‖ > η` and all `p_0` with
`‖p_0‖ ≤ ‖x_0‖^δ` for some `δ < 1` (the `∃ δ` is inside the "for all", so `η` does not depend on
`δ` or `p_0`; it may depend on `ε`, `gU`, `d`): `‖x_ε‖ > 2‖x_0‖`. -/
def Concl {d : ℕ} (gU : E d → E d) (eps : ℝ) : Prop :=
  ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → (∃ δ : ℝ, δ < 1 ∧ ‖p0‖ ≤ ‖x0‖ ^ δ) →
    2 * ‖x0‖ < ‖xLF gU eps x0 p0 1‖

/-- Alternative (weaker) reading of the quantifier order (N5): `δ < 1` is fixed first and `η` may
depend on `δ`. -/
def ConclFixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) : Prop :=
  ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    2 * ‖x0‖ < ‖xLF gU eps x0 p0 1‖

end Paper.L01

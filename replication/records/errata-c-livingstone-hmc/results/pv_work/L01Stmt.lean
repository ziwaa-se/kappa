import Defs

/-!
# L01 = Lemma 5.15 (lem:xelower), statement definitions (revision 1)
Source: source/geo_erg_HMC_v3.1.tex:945-947 (proof 949-958).  No external parameter: the single-step
formula `x_ε = x_0 - (ε²/2)∇U(x_0) + ε p_0` (TEX:951) is the `L = 1` case of the leapfrog recursion
(TEX:330-336) and is derivable by unfolding `Paper.Defs.leapfrogStep` (step S1 in the draft).
-/

open Paper.Defs

namespace Paper.L01

/-- Conclusion of Lemma 5.15 (TEX:946), "any fixed `δ < 1`" read as: `δ < 1` is fixed first, then
`η` (which may depend on `δ`, `ε`, `∇U`) exists such that for all `‖x_0‖ > η` and all
`‖p_0‖ ≤ ‖x_0‖^δ`, `‖x_ε‖ > 3‖x_0‖`. -/
def Concl {d : ℕ} (gU : E d → E d) (eps δ : ℝ) : Prop :=
  ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    3 * ‖x0‖ < ‖xLF gU eps x0 p0 1‖

end Paper.L01

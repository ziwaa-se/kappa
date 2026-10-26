import L03
import L02Closed_r1

open Paper.Defs

namespace Paper.L03

/-- Predecessor L02 (Lemma 5.16, closed form) discharges the consumed clause of L03. -/
theorem L03_L02Consumed_holds {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps2 : 0 < eps) (hexp2 : HypExplode gU) : L03_L02Consumed gU eps L :=
  Paper.L02.main_closed gU eps L heps1 hexp1 heps2 hexp2

theorem main_closed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps2 : 0 < eps) (hexp2 : HypExplode gU)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ∀ δ : ℝ, δ < 1 → Concl U gU eps L δ :=
  L03_main U gU eps L (L03_L02Consumed_holds gU eps L heps1 hexp1 heps2 hexp2)
    heps hL hexp hosc hosc2

end Paper.L03

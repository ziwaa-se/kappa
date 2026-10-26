import L02
import L01

open Paper.Defs

namespace Paper.L02

/-- Predecessor L01 (Lemma 5.15) discharges the consumed clause of L02. -/
theorem L02_L01Consumed_holds {d : ℕ} (gU : E d → E d) (eps : ℝ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU) : L02_L01Consumed gU eps :=
  Paper.L01.L01_main gU eps heps1 hexp1

theorem main_closed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps : 0 < eps) (hexp : HypExplode gU) :
    ∀ δ : ℝ, δ < 1 → Concl gU eps L δ :=
  L02_main gU eps L (L02_L01Consumed_holds gU eps heps1 hexp1) heps hexp

end Paper.L02

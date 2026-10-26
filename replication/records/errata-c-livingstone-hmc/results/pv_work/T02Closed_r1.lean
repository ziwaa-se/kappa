import T02
import L03Closed_r1

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-- Predecessor L03 (closed form, TEX:1011-1016) discharges `T02_L03Consumed`. -/
theorem T02_L03Consumed_holds {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps2 : 0 < eps) (hexp2 : HypExplode gU)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    T02_L03Consumed U gU eps L :=
  Paper.L03.main_closed U gU eps L heps1 hexp1 heps2 hexp2 heps hL hexp hosc hosc2

theorem main_closed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps2 : 0 < eps) (hexp2 : HypExplode gU)
    (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ¬ GeomErgodic U gU eps L :=
  T02_main U gU eps L
    (T02_L03Consumed_holds U gU eps L heps1 hexp1 heps2 hexp2 heps hL hexp hosc hosc2)
    hE1 hE6 hd hgrad hπ heps hL hexp hosc hosc2

theorem main_randL_closed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (heps1 : 0 < eps) (hexp1 : HypExplode gU)
    (heps2 : 0 < eps) (hexp2 : HypExplode gU)
    (hE1 : Prop35Rand) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hA1 : A1Law gU eps Lmeas)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU)
    (hosc2 : ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → HypOscillation2 U l) :
    ¬ GeomErgodicRand U gU eps Lmeas :=
  T02_main_randL U gU eps Lmeas
    (fun l hl hl0 => T02_L03Consumed_holds U gU eps l heps1 hexp1 heps2 hexp2 heps hl hexp hosc
      (hosc2 l hl hl0))
    hE1 hE6 hd hgrad hπ heps hA1 hexp hosc hosc2

end Paper.T02

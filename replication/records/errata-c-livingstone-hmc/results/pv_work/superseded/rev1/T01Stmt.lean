import Defs
import T02Stmt

/-!
# T01 = Theorem 2.2 (thm:negative), statement definitions
Source: source/geo_erg_HMC_v3.1.tex:208-219 (no own proof).  Part (i) = Thm 5.14 (T02),
part (ii) = Thm 5.18 (thm:heavy, TEX:978-996, external input `Thm518`).
Reused, not redeclared: `GeomErgodic`, `hmcStep`, `targetMeas`, `Prop35`, `GaussFacts`,
`T02_L02Consumed` (all `Paper.T02`), `HypExplode/HypOscillations/HypOscillation2` (`Paper.Defs`).
-/

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- EXTERNAL INPUT E3, provenance (ii) (out-of-scope numbered result Theorem 5.18, thm:heavy,
TEX:978-984; its proof TEX:986-996 uses Proposition 3.6, TEX:307-313, E4, transitive).
"If `‖∇U(x)‖ < M` for all `x`, then a necessary condition for HMC to produce a geometrically ergodic
chain is `∫ e^{s‖x‖} π(dx) < ∞` for some `s>0`."  Specialised to the HMC kernel `hmcStep`, with the
standing conventions as in `Prop35` (`U` differentiable with gradient `gU`, `π` a probability density,
`ε>0`, `L ≥ 1`, `d ≥ 1`), for every such `ε, L` (as T02 reads "for any choice").
Scope: specialised to deterministic `L` (𝔏 = δ_L), a weakening of the printed statement. -/
def Thm518 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodic U gU eps L →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤

/-- Hypothesis (i) of Theorem 2.2: (17) `‖∇U‖/‖x‖ → ∞`, (18), (19) (with the same `L`). -/
def HypPartI {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (L : ℕ) : Prop :=
  HypExplode gU ∧ HypOscillations gU ∧ HypOscillation2 U L

/-- Hypothesis (ii) of Theorem 2.2: `‖∇U‖ ≤ M` for all `x` and `E_π[e^{s‖x‖}] = ∞` for every `s>0`. -/
def HypPartII {d : ℕ} (U : E d → ℝ) (gU : E d → E d) : Prop :=
  (∃ M : ℝ, ∀ x : E d, ‖gU x‖ ≤ M) ∧
  ∀ s : ℝ, 0 < s → (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) = ⊤

/-- Conclusion of Theorem 2.2, separated by clause: each of (i), (ii) implies that HMC does not
produce a geometrically ergodic chain.
Scope: `hmcStep` has a deterministic number `L` of leapfrog steps, i.e. Algorithm 1 with 𝔏 = δ_L only;
the printed statement concerns HMC with L ~ 𝔏 (TEX:342-343); the passage to random 𝔏 (INVENTORY X2)
is not covered. -/
structure T01Concl {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop where
  partI : HypPartI U gU L → ¬ GeomErgodic U gU eps L
  partII : HypPartII U gU → ¬ GeomErgodic U gU eps L

end Paper.T01

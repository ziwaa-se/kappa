import Defs
import T02Stmt
import T01Stmt

/-!
# C01 = Corollary 2.3 (crly:expfam), PART (ii) ONLY: statement definitions (revision 1 re-draft)
Source: source/geo_erg_HMC_v3.1.tex:223-226 (class E(beta,alpha)), 229-239 (statement),
804-836 (proof of part (ii), new argument).  Part (i) (TEX:838-885) is outside the user-set scope:
NOT encoded.
External parameters: none of its own; the predecessor clause `C01_T01Consumed` (provenance (p), T01).
-/

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02
open Paper.T01

namespace Paper.C01

/-- The exponential family class `E(beta,alpha)` (TEX:223-226), in dimension one (`E 1`, `‖x‖ = |x 0|`).
Target represented by the potential `U` with `piDens U = e^{-U}` (positive; "∝" absorbs the constant `c`).
Clauses: `α,β > 0`; `π ∈ C^1`; there are `M < ∞`, `c > 0` with `π(x) = c·exp(-α|x|^β)` for `|x| > M`. -/
def InExpFam (β α : ℝ) (U : E 1 → ℝ) : Prop :=
  0 < α ∧ 0 < β ∧ ContDiff ℝ 1 (piDens U) ∧
    ∃ M c : ℝ, 0 < c ∧ ∀ x : E 1, M < ‖x‖ → piDens U x = c * Real.exp (-α * ‖x‖ ^ β)

/-- Step helper (TEX:807-810): the printed tail gradient `∇U(x) = αβ sgn(x)|x|^{β-1}` for `|x| > M`
(the single component of `gU x`). -/
def TailGrad (β α M : ℝ) (gU : E 1 → E 1) : Prop :=
  ∀ x : E 1, M < ‖x‖ → gU x 0 = α * β * Real.sign (x 0) * |x 0| ^ (β - 1)

/-- Hypothesis (18) in its REVISED form (Theorem 5.14 / thm:light, TEX:900-903): there is a fixed `C < ∞`
such that whenever `‖y‖ ≥ 3‖x‖ ≥ C` then `‖∇U(y)‖ ≥ 3‖∇U(x)‖`.  (`Paper.Defs.HypOscillations` encodes the
PRE-revision form with `2‖x‖`; Defs is frozen, so the revised form is declared here.) -/
def HypOscillations3 {d : ℕ} (gU : E d → E d) : Prop :=
  ∃ C : ℝ, ∀ x y : E d, 3 * ‖x‖ ≤ ‖y‖ → C ≤ 3 * ‖x‖ → 3 * ‖gU x‖ ≤ ‖gU y‖

/-- CONSUMED CLAUSE of predecessor T01 (Theorem 2.2, thm:negative, TEX:208-219), provenance (p),
predecessor T01 (not yet re-proved after the revision).  Content as used at TEX:806 ("part (ii) of Theorem
thm:negative"; "verify the conditions of part (i)") and TEX:834 ("Theorem thm:light applies"; thm:light =
TEX:895-909 is part (i) with (18),(19) the same `L`).  Specialised to `d = 1`, the standing conventions of
T01 (`IsGradField`, `π` integrable, `ε > 0`, `L ≥ 1`), deterministic `L` (𝔏 = δ_L), for every `ε, L`.
Part (i) is in the REVISED form (`HypOscillations3`). -/
def C01_T01Consumed : Prop :=
  (∀ (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ),
    IsGradField U gU → (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypExplode gU → HypOscillations3 gU → HypOscillation2 U L → ¬ GeomErgodic U gU eps L) ∧
  (∀ (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ),
    IsGradField U gU → (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypPartII U gU → ¬ GeomErgodic U gU eps L)

/-- Conclusion of Corollary 2.3, separated by clause; only part (ii) is encoded
(part (i), TEX:234, is not encoded: outside the scope set by the user).
(ii) (TEX:238): if `β < 1` or `β > 2` then HMC does not produce a geometrically ergodic chain.
Scope: `GeomErgodic` is for HMC with a deterministic number `L` of leapfrog steps (𝔏 = δ_L, as in T01/T02);
"under assumption A1" (random 𝔏, TEX:393) is not encoded. -/
structure C01Concl (β : ℝ) (U : E 1 → ℝ) (gU : E 1 → E 1) (eps : ℝ) (L : ℕ) : Prop where
  partII : (β < 1 ∨ 2 < β) → ¬ GeomErgodic U gU eps L

end Paper.C01

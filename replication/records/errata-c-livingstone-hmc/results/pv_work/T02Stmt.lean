import Defs
import L03Stmt

/-!
# T02 = Theorem 5.14 (thm:light), statement definitions (revision 1 re-draft)
Source: source/geo_erg_HMC_v3.1.tex:895-909 (statement), 911-941 (proof).
Revision-1 changes: consumed clause is now `T02_L03Consumed` (L03 conclusion; replaces the stale
`T02_L02Consumed`); added random-`L` definitions (A1, TEX:934-940): `A1Law`, `rejProbRand`,
`hmcStepRand`, `hmcPowRand`, `GeomErgodicRand`, `Prop35Rand`.  All earlier definitions unchanged.
(Original header follows.)

Definitions here: the standard Gaussian `μ^G` (TEX:192-194, D05), the normalised target `π` (TEX:320),
the HMC kernel `P` of Metropolis-Hastings type (TEX:274-279, 338-352, 363-374) with rejection
probability `r(x)`, its `n`-step kernels, total variation distance, geometric ergodicity
(eqn:geoerg, TEX:266-268), and two external inputs:
* `Prop35`   : Proposition 3.5 (TEX:300-303), provenance (ii) per project instruction (INVENTORY.md:28, 179)
  (cited from roberts1996geometric, TEX:298);
* `GaussFacts`: Gaussian facts used silently/"we simply note" (TEX:879), provenance (v).
Consumed clause of L03: `T02_L03Consumed` (provenance (p), predecessor L03).
-/

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-- The standard Gaussian measure `μ^G = N(0, I_d)` on `X = R^d` (TEX:192-194; `p_0 ~ N(0,I)` by the
convention `M = I`, TEX:354-356): Lebesgue measure with density `(2π)^{-d/2} e^{-‖p‖²/2}`.
(mathlib has only the 1-dimensional `gaussianReal`; no multivariate `stdGaussian`: searched
`Mathlib/Probability/Distributions/Gaussian.lean`, grep `stdGaussian` gives no hit.) -/
noncomputable def gaussMeas (d : ℕ) : Measure (E d) :=
  volume.withDensity (fun p : E d =>
    ENNReal.ofReal ((2 * Real.pi) ^ (-(d : ℝ) / 2) * Real.exp (-(‖p‖ ^ 2) / 2)))

/-- The normalised target law `π ∝ e^{-U}` (TEX:320): `π(dx) = e^{-U(x)} dx / Z`. -/
noncomputable def targetMeas {d : ℕ} (U : E d → ℝ) : Measure (E d) :=
  (∫⁻ x : E d, ENNReal.ofReal (piDens U x))⁻¹ •
    volume.withDensity (fun x : E d => ENNReal.ofReal (piDens U x))

/-- Rejection probability `r(x) = 1 - ∫ α(x,y) Q(x,dy)` (TEX:278), with `Q(x,·)` the law of the
proposal `x_{Lε}` for `p_0 ~ μ^G`, so `∫ α(x,y) Q(x,dy) = ∫ α(x, x_{Lε}(x,p)) μ^G(dp)`
(`accProb` of Defs). -/
noncomputable def rejProb {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) : ℝ :=
  1 - ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d)

/-- One step of the HMC kernel `P(x,·)` (Algorithm 1, TEX:338-352): refresh `p_0 ~ μ^G`, run `L`
leapfrog steps, accept `x_{Lε}` with probability `α = accProb`, else stay at `x`.  This equals
`α Q + r δ_x` (eqn:mhtype, TEX:274-279) (step S4 of the draft). -/
noncomputable def hmcStep {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    Measure (E d) :=
  (gaussMeas d).bind (fun p : E d =>
    ENNReal.ofReal (accProb U gU eps L x p) • Measure.dirac (xLF gU eps x p L) +
    ENNReal.ofReal (1 - accProb U gU eps L x p) • Measure.dirac x)

/-- `n`-step kernel `P^n(x,·)`: `P^0(x,·) = δ_x`, `P^{n+1}(x,·) = ∫ P^n(x,dy) P(y,·)`. -/
noncomputable def hmcPow {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    ℕ → Measure (E d)
  | 0 => Measure.dirac x
  | n + 1 => (hmcPow U gU eps L x n).bind (hmcStep U gU eps L)

/-- Total variation distance `‖μ - ν‖_TV = sup_A |μ(A) - ν(A)|` (for probability measures; a constant
factor `2` relative to the `sup_{|f|≤1}` convention is absorbed in `M(x)`, so it does not matter for
geometric ergodicity).  TEX:267 (D13). -/
noncomputable def tvDist {d : ℕ} (μ ν : Measure (E d)) : ENNReal :=
  ⨆ (A : Set (E d)) (_ : MeasurableSet A), ENNReal.ofReal |(μ A).toReal - (ν A).toReal|

/-- Geometric ergodicity (eqn:geoerg, TEX:264-268): `∃ ρ < 1` and a `π`-a.e. finite
`M : X → [0,∞]` with `‖P^n(x,·) - π‖_TV ≤ M(x) ρ^n` (for every `x` and `n`, as printed). -/
def GeomErgodic {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  ∃ ρ : ℝ, 0 ≤ ρ ∧ ρ < 1 ∧ ∃ M : E d → ENNReal, (∀ᵐ x ∂(targetMeas U), M x ≠ ⊤) ∧
    ∀ (x : E d) (n : ℕ),
      tvDist (hmcPow U gU eps L x n) (targetMeas U) ≤ M x * ENNReal.ofReal ρ ^ n

/-- EXTERNAL INPUT E1, provenance (ii) per project instruction (INVENTORY.md:28, 179; out-of-scope
numbered result): Proposition 3.5 (prop:supr, TEX:300-303; cited from
roberts1996geometric, TEX:298): "If `P` is of Metropolis-Hastings type, then (eqn:geoerg) fails to
hold if `esssup r(x) = 1`."  Specialised to the HMC kernel `hmcStep` (which is of MH type, TEX:274-279,
S4), with the standing conventions of the source (`U` differentiable with gradient `gU`, `π` a
probability density, `ε > 0`, `L ≥ 1`, `X = R^d`, `d ≥ 1`); the essential supremum is w.r.t. `π`
(equivalent to Lebesgue measure since `e^{-U} > 0`).  Only a specialisation of the printed statement
(weaker, never stronger). -/
def Prop35 : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 →
    ¬ GeomErgodic U gU eps L

/-- EXTERNAL INPUT E6, provenance (v) (standard fact, "we simply note", TEX:879), together with the
normalisation of `μ^G` (silently used: `p_0 ~ N(0,I)` is a probability law).
(a) `μ^G` is a probability measure;
(b) for every `δ > 0`, `P(‖p_0‖ ≤ R^δ) → 1` as `R → ∞`. -/
def GaussFacts : Prop :=
  ∀ d : ℕ, IsProbabilityMeasure (gaussMeas d) ∧
    ∀ δ : ℝ, 0 < δ →
      Tendsto (fun R : ℝ => (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ}) atTop (𝓝 1)

/-- CONSUMED CLAUSE of predecessor L03 (Lemma 5.17 = `lem:arate_0`, TEX:1011-1016), provenance (p),
predecessor L03.  The conclusion of L03, for every fixed `δ < 1`: `α(x_0,x_{Lε}) → 0` as
`‖x_0‖ → ∞` with `‖p_0‖ ≤ ‖x_0‖^δ` (`Paper.L03.Concl`, located in L03Stmt).  Used at TEX:911-915 ("From
Lemma arate_0").  Applicability: L03's hypotheses are (17), (18) (revised, `3‖x‖`), (19), which are exactly
`hexp`, `hosc`, `hosc2` of `T02_main` (same `U`, `∇U`, `ε`, `L`); L03 additionally needs `ε > 0`, `L ≥ 1`,
available in `T02_main`.  (L03 itself is conditional on `Paper.L03.L03_L02Consumed`; that is inherited
transitively at reconnection and is not a T02 parameter.)  Replaces the stale `T02_L02Consumed`. -/
def T02_L03Consumed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  ∀ δ : ℝ, δ < 1 → Paper.L03.Concl U gU eps L δ

/-! ### Random number of leapfrog steps (proof paragraph TEX:934-940, Assumption A1, TEX:393) -/

/-- Assumption A1 (TEX:393) on the law `𝔏` of the number of leapfrog steps: `P[L=1] > 0`, and for any
fixed `(x_0,p_0)` (and `ε`) there is `s < ∞` (with `s > 0`, gate G-A1; otherwise the clause is vacuous at `s = 0`) with `E_𝔏[e^{s‖x_{Lε}‖}] < ∞`.  Plus the convention that `𝔏` is
a probability law on `L ≥ 1` (candidate TFA, number of leapfrog steps `≥ 1`, TEX:404, 411).  Reading of the
quantifier "for any fixed `(x_0,p_0)` ... there is an `s`": `s` may depend on `(x_0,p_0)` (weaker
hypothesis). -/
def A1Law {d : ℕ} (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) : Prop :=
  IsProbabilityMeasure Lmeas ∧ Lmeas {0} = 0 ∧ Lmeas {1} ≠ 0 ∧
    ∀ x0 p0 : E d, ∃ s : ℝ, 0 < s ∧
      (∫⁻ L : ℕ, ENNReal.ofReal (Real.exp (s * ‖xLF gU eps x0 p0 L‖)) ∂Lmeas) < ⊤

/-- Rejection probability for HMC with `L ~ 𝔏` drawn independently of `(x_0,p_0)`:
`r(x) = 1 - ∫ ∫ α(x, x_{Lε}) μ^G(dp_0) 𝔏(dL)`. -/
noncomputable def rejProbRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (x : E d) : ℝ :=
  1 - ∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∂Lmeas

/-- One step of HMC with a random number of leapfrog steps `L ~ 𝔏` (A1): a mixture of `hmcStep`. -/
noncomputable def hmcStepRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (x : E d) : Measure (E d) :=
  Lmeas.bind (fun L : ℕ => hmcStep U gU eps L x)

/-- `n`-step kernel of the random-`L` chain. -/
noncomputable def hmcPowRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (x : E d) : ℕ → Measure (E d)
  | 0 => Measure.dirac x
  | n + 1 => (hmcPowRand U gU eps Lmeas x n).bind (hmcStepRand U gU eps Lmeas)

/-- Geometric ergodicity (eqn:geoerg) of the random-`L` chain (same form as `GeomErgodic`). -/
def GeomErgodicRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) : Prop :=
  ∃ ρ : ℝ, 0 ≤ ρ ∧ ρ < 1 ∧ ∃ M : E d → ENNReal, (∀ᵐ x ∂(targetMeas U), M x ≠ ⊤) ∧
    ∀ (x : E d) (n : ℕ),
      tvDist (hmcPowRand U gU eps Lmeas x n) (targetMeas U) ≤ M x * ENNReal.ofReal ρ ^ n

/-- EXTERNAL INPUT E1', provenance (ii) as `Prop35` (Proposition 3.5, TEX:300-303), specialised to the
random-`L` HMC kernel `hmcStepRand` (also of MH type, with `Q` the `𝔏`-mixture of proposal laws).  The
source applies Prop. 3.5 to this kernel implicitly (TEX:934-940, "the same conclusion follows");
standing conventions as in `Prop35`, plus `A1Law`. -/
def Prop35Rand : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    A1Law gU eps Lmeas →
    essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1 →
    ¬ GeomErgodicRand U gU eps Lmeas

end Paper.T02

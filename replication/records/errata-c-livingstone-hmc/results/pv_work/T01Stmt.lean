import Defs
import T02Stmt

/-!
# T01 = Theorem 2.2 (thm:negative), statement definitions (revision 1 re-draft)
Source: source/geo_erg_HMC_v3.1.tex:208-219 (no own proof).  Part (i) = Thm 5.14 (T02, TEX:895-941),
part (ii) = Thm 5.18 (thm:heavy, TEX:1103-1109, proof 1111-1121, external input `Thm518`).
Revision-1 changes (only these): `HypPartI` now uses the revised (18) `Paper.L03.HypOscillations3`
(`‖y‖ ≥ 3‖x‖ ≥ C`, TEX:900-903) instead of the stale `Paper.Defs.HypOscillations`; new consumed clause
`T01_T02Consumed` (replaces the stale `T02_L02Consumed` reuse); source line references of `Thm518`
corrected (TEX:1103-1109).  `Thm518`, `HypPartII`, `T01Concl` are unchanged in content.
Reused, not redeclared: `GeomErgodic`, `targetMeas` (`Paper.T02`), `HypExplode`, `HypOscillation2`
(`Paper.Defs`), `HypOscillations3` (`Paper.L03`).
-/

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- EXTERNAL INPUT E3, provenance (ii) (out-of-scope numbered result Theorem 5.18, thm:heavy,
TEX:1103-1109; its proof TEX:1111-1121 uses Proposition 3.6, TEX:307-313, E4, transitive).
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

/-- Hypothesis (i) of Theorem 2.2 (TEX:213): (17) `‖∇U‖/‖x‖ → ∞`, (18) (revised form,
`Paper.L03.HypOscillations3`, TEX:900-903), (19) `eqn:oscillation2` (with the same `L`). -/
def HypPartI {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (L : ℕ) : Prop :=
  HypExplode gU ∧ Paper.L03.HypOscillations3 gU ∧ HypOscillation2 U L

/-- Hypothesis (ii) of Theorem 2.2: `‖∇U‖ ≤ M` for all `x` and `E_π[e^{s‖x‖}] = ∞` for every `s>0`. -/
def HypPartII {d : ℕ} (U : E d → ℝ) (gU : E d → E d) : Prop :=
  (∃ M : ℝ, ∀ x : E d, ‖gU x‖ ≤ M) ∧
  ∀ s : ℝ, 0 < s → (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) = ⊤

/-- CONSUMED CLAUSE of predecessor T02 (Theorem 5.14, thm:light, TEX:895-909, identified with
part (i), TEX:213), provenance (p), predecessor T02 (not yet proved).  Content of `Paper.T02.T02_main`
for the fixed data `U, ∇U, ε, L`: under the standing conventions (`d ≥ 1`, `IsGradField`, `π`
integrable, `ε > 0`, `L ≥ 1`) and (17), (18) revised, (19), the HMC chain with `L` leapfrog steps is
not geometrically ergodic.  T02's own parameters (`T02_L03Consumed`, `Prop35`, `GaussFacts`) are
inherited transitively at reconnection and are not parameters of T01.  Stated as an implication on
`HypPartI`, so it does not constrain bounded gradients (part (ii) is not made vacuous; cf. earlier
ENCODING_ERROR F1, which came from an unconditional L02 clause). -/
def T01_T02Consumed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps → 1 ≤ L →
    HypPartI U gU L → ¬ GeomErgodic U gU eps L

/-- Conclusion of Theorem 2.2, separated by clause: each of (i), (ii) implies that HMC does not
produce a geometrically ergodic chain.
Scope: `hmcStep` has a deterministic number `L` of leapfrog steps, i.e. Algorithm 1 with 𝔏 = δ_L only;
the printed statement concerns HMC with L ~ 𝔏 (TEX:342-343); the passage to random 𝔏 (INVENTORY X2)
is not covered. -/
structure T01Concl {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop where
  partI : HypPartI U gU L → ¬ GeomErgodic U gU eps L
  partII : HypPartII U gU → ¬ GeomErgodic U gU eps L

/-- EXTERNAL INPUT, provenance (ii): Theorem 5.18 (TEX:1103-1109) for HMC with `L ~ 𝔏` (Algorithm 1,
TEX:342-343), standing conventions as in `Thm518`, 𝔏 a probability law on `L ≥ 1`. -/
def Thm518Rand : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    IsProbabilityMeasure Lmeas → Lmeas {0} = 0 →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodicRand U gU eps Lmeas →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤

/-- Hypothesis (i) of Theorem 2.2 for random 𝔏: (17), (18) revised, (19) for every `l` charged by 𝔏. -/
def HypPartIRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (Lmeas : Measure ℕ) : Prop :=
  HypExplode gU ∧ Paper.L03.HypOscillations3 gU ∧
    ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → HypOscillation2 U l

/-- CONSUMED CLAUSE of T02, provenance (p): conclusion of `Paper.T02.T02_main_randL`
(TEX:934-940) for fixed `U, gU, ε, 𝔏`. -/
def T01Rand_T02Consumed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) :
    Prop :=
  0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    A1Law gU eps Lmeas → HypPartIRand U gU Lmeas → ¬ GeomErgodicRand U gU eps Lmeas

/-- Conclusion of Theorem 2.2 for HMC with `L ~ 𝔏`. -/
structure T01ConclRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) :
    Prop where
  partI : HypPartIRand U gU Lmeas → ¬ GeomErgodicRand U gU eps Lmeas
  partII : HypPartII U gU → ¬ GeomErgodicRand U gU eps Lmeas

end Paper.T01

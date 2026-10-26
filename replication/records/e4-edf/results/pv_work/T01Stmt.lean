import Mathlib
import Defs

/-!
# T01 statement definitions (Theorem thm:ks, source/main.tex:53-58)
No sorry, no theorems.
-/

open MeasureTheory Set

namespace Paper.T01

/-- Convergence in distribution (weak convergence of laws), spelled out via bounded
continuous test functions: `Y n → Z` in distribution iff `E f(Y n) → E f(Z)` for all bounded
continuous `f`. The source uses the phrase without definition (main.tex:54-55); this is the
standard definition. (mathlib has no `TendstoInDistribution`; search below in notes.) -/
def ConvInDist {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    (P : Measure Ω) (Y : ℕ → Ω → ℝ) (Q : Measure Ω') (Z : Ω' → ℝ) : Prop :=
  ∀ f : BoundedContinuousFunction ℝ ℝ,
    Filter.Tendsto (fun n => ∫ ω, f (Y n ω) ∂P) Filter.atTop (nhds (∫ ω, f (Z ω) ∂Q))

/-- "Brownian bridge on [0,1]" (main.tex:55-56; NOT defined in the source, standard
meaning, mathlib has none). A process `B : ℝ → Ω' → ℝ` on probability space `(Ω', Q)`:
measurable coordinates, continuous paths on `[0,1]`, centered Gaussian finite-dimensional
laws with covariance `min s t - s t` on `[0,1]` (every linear combination of coordinates is
`N(0, ∑ a_i a_j (min(u_i,u_j) - u_i u_j))`). -/
def IsBrownianBridge {Ω' : Type*} [MeasurableSpace Ω'] (Q : Measure Ω')
    (B : ℝ → Ω' → ℝ) : Prop :=
  (∀ t, Measurable (B t)) ∧
  (∀ ω, ContinuousOn (fun t => B t ω) (Icc (0:ℝ) 1)) ∧
  ∀ (m : ℕ) (u a : Fin m → ℝ), (∀ i, u i ∈ Icc (0:ℝ) 1) →
    Q.map (fun ω => ∑ i, a i * B (u i) ω) =
      ProbabilityTheory.gaussianReal 0
        (Real.toNNReal (∑ i, ∑ j, a i * a j * (min (u i) (u j) - u i * u j)))

/-- `sup_{0 ≤ u ≤ 1} |B(u)|` (main.tex:55). -/
noncomputable def supAbs {Ω' : Type*} (B : ℝ → Ω' → ℝ) (ω : Ω') : ℝ :=
  ⨆ u : Icc (0:ℝ) 1, |B u ω|

/-- Kolmogorov's series (main.tex:57): `1 - 2 ∑_{k≥1} (-1)^(k-1) e^{-2k²z²}`. -/
noncomputable def Kfun (z : ℝ) : ℝ :=
  1 - 2 * ∑' k : ℕ, (-1 : ℝ) ^ k * Real.exp (-2 * ((k + 1 : ℕ) : ℝ) ^ 2 * z ^ 2)

/-- Conclusion of Theorem thm:ks (main.tex:53-58), two clauses, for every Brownian bridge
`B` on every probability space `(Ω', Q)`. -/
structure KSConclusion {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X : ℕ → Ω → ℝ) : Prop where
  /-- main.tex:54-56: `√n D_n → sup|B|` in distribution. -/
  conv : ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ConvInDist P (fun n ω => Real.sqrt n * Paper.Defs.Dn P X n ω) Q (supAbs B)
  /-- main.tex:56-57: `P(sup|B| ≤ z) = K(z)` for `z > 0`. -/
  cdf : ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ∀ z : ℝ, 0 < z → Q.real {ω | supAbs B ω ≤ z} = Kfun z

/-- EXTERNAL (i) Donsker \cite{donsker}, main.tex:61 (+ (ii) the continuous-functional step
main.tex:61-62, folded in; see notes): for iid uniform[0,1] samples `U`,
`√n sup_t |G_n(t) - t| → sup|B|` in distribution. -/
def DonskerUniformSup : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P] (U : ℕ → Ω → ℝ),
    (∀ k, Measurable (U k)) → ProbabilityTheory.iIndepFun U P →
    (∀ k, P.map (U k) = volume.restrict (Icc (0:ℝ) 1)) →
    ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
      (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ConvInDist P (fun n ω => Real.sqrt n * Paper.Defs.Dn P U n ω) Q (supAbs B)

/-- EXTERNAL (i) Kolmogorov \cite{kolmogorov}, main.tex:62: law of `sup|B|`. -/
def KolmogorovFormula : Prop :=
  ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ∀ z : ℝ, 0 < z → Q.real {ω | supAbs B ω ≤ z} = Kfun z

end Paper.T01

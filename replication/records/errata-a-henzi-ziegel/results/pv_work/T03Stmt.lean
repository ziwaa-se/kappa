import Defs

/-!
# T03 (Theorem 3.3, thm:allscores, source/VSIFP_02.tex l.190-198): statement definitions

Imports `Defs` (gated).  `HAll` (D12), `EGrowAll` (D18), `IsEValue` (D13), `expPi` are NOT redeclared.
Declared here (missing from Defs): the notion "GROW e-value" (l.151) and the external input X03.
-/

open MeasureTheory

namespace Paper.T03

/-- Positivity convention making `E_{π₁} log E` finite (`Real.log 0 = 0` must not be used; cf.
`GrowFinite` in Defs): `E(y) > 0` for every `y ∈ {0,1}` of positive `π₁`-probability. -/
def LogFinite (π₁ : ℝ) (E : ℝ → ℝ) : Prop :=
  (π₁ ≠ 1 → 0 < E 0) ∧ (π₁ ≠ 0 → 0 < E 1)

/-- GROW e-value (l.151: "If an e-value maximizes `E_P{log E}` under a measure representing an
alternative hypothesis, it is called growth rate optimal or simply GROW"), for null `H` and
alternative `Y = 1` w.p. `π₁`: `E` is an e-value with null `H` and alternative `{π₁}` (l.142),
has finite log-growth, and maximizes `E_{π₁} log E'` among all e-values `E'` with null `H`
(no alternative required) having finite log-growth. -/
def IsGrowEValue (H : Set ℝ) (π₁ : ℝ) (E : ℝ → ℝ) : Prop :=
  IsEValue E H {π₁} ∧ LogFinite π₁ E ∧
    ∀ E' : ℝ → ℝ, IsEValue E' H ∅ → LogFinite π₁ E' →
      expPi π₁ (fun y => Real.log (E' y)) ≤ expPi π₁ (fun y => Real.log (E y))

/-- "The GROW e-value is given by `E₀`" (definite article, l.191): `E₀` is GROW, and every GROW
e-value agrees with `E₀` at every outcome of positive `π₁`-probability (a GROW e-value is
determined only `π₁`-almost surely; values at outcomes of probability 0 are irrelevant). -/
def GrowIs (H : Set ℝ) (π₁ : ℝ) (E₀ : ℝ → ℝ) : Prop :=
  IsGrowEValue H π₁ E₀ ∧
    ∀ E : ℝ → ℝ, IsGrowEValue H π₁ E → (π₁ ≠ 1 → E 0 = E₀ 0) ∧ (π₁ ≠ 0 → E 1 = E₀ 1)

/-- X03, provenance (i): Grünwald, de Heide, Koolen 2019, Theorem 1, cited at l.188 and l.466
("The result then follows by Theorem 1 of \cite{Gruenwald2019}, with `W_1` being the Dirac measure
of the point `{π₁}`"), specialised to the Bernoulli family and Dirac alternative: if the likelihood
ratio `E = (π₁-likelihood)/(p₀-likelihood)` satisfies `E_π E ≤ 1` for all `π ∈ H` and
`E_π E > 1` for all `π ∈ [0,1] \ H` (exactly the two facts the source verifies at l.466), then it is
the GROW e-value for null `H` against `π₁ ∉ H`. -/
def GruenwaldThm1 : Prop :=
  ∀ (H : Set ℝ) (π₁ p₀ : ℝ), H ⊆ Set.Icc (0:ℝ) 1 → π₁ ∈ Set.Icc (0:ℝ) 1 → π₁ ∉ H →
    p₀ ∈ Set.Ioo (0:ℝ) 1 →
    (∀ π ∈ H, expPi π (EGrowAll p₀ π₁) ≤ 1) →
    (∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ H → 1 < expPi π (EGrowAll p₀ π₁)) →
    GrowIs H π₁ (EGrowAll p₀ π₁)

end Paper.T03

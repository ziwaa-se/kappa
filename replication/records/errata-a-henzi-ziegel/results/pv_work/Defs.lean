import Mathlib

/-!
# Shared one-period definitions (source/VSIFP_02.tex)

Definitions only.  Conventions used throughout:
* A forecast is a real number `p`; an observation is a real `y` (only `y = 0` and `y = 1` matter).
* A scoring function is `S : ℝ → ℝ → ℝ`, `S p y`.
* `ν` is a `Measure ℝ` with `ν ((Set.Ioo 0 1)ᶜ) = 0` (a measure "on (0,1)").
* An e-value `E : ℝ → ℝ` is a function of `y`; only its values at `0, 1` are used.
-/

open MeasureTheory

namespace Paper

/-- Expectation `E_π f(Y)` where `Y = 1` with probability `π` (l.91): `(1-π) f 0 + π f 1`. -/
noncomputable def expPi (π : ℝ) (f : ℝ → ℝ) : ℝ := (1 - π) * f 0 + π * f 1

/-- D01 (l.70-74, eq:scoring).  Consistency: `E_π S(π,Y) ≤ E_π S(p,Y)` for all `p, π ∈ [0,1]`. -/
def IsConsistent (S : ℝ → ℝ → ℝ) : Prop :=
  ∀ p ∈ Set.Icc (0:ℝ) 1, ∀ π ∈ Set.Icc (0:ℝ) 1, expPi π (S π) ≤ expPi π (S p)

/-- D02 (l.74).  Strict consistency: equality `E_π S(π,Y) = E_π S(p,Y)` only for `p = π`. -/
def IsStrictlyConsistent (S : ℝ → ℝ → ℝ) : Prop :=
  IsConsistent S ∧
    ∀ p ∈ Set.Icc (0:ℝ) 1, ∀ π ∈ Set.Icc (0:ℝ) 1, expPi π (S π) = expPi π (S p) → p = π

/-- D04 (l.98-99, eq:elementary).  `S_θ(p,y) = (θ - y)(1{p > θ} - 1{y > θ})`. -/
noncomputable def elemScore (θ p y : ℝ) : ℝ :=
  (θ - y) * ((if θ < p then (1:ℝ) else 0) - (if θ < y then (1:ℝ) else 0))

/-- `ν` is a locally finite Borel measure on `(0,1)` (l.97): carried by `(0,1)` and finite on
compact subsets of `(0,1)` (it may be infinite near 0 and 1, e.g. the logarithmic score). -/
def IsMixingMeasure (ν : Measure ℝ) : Prop :=
  ν ((Set.Ioo (0:ℝ) 1)ᶜ) = 0 ∧ ∀ K : Set ℝ, IsCompact K → K ⊆ Set.Ioo (0:ℝ) 1 → ν K < ⊤

/-- D03 (l.94-96, eq:mixture).  `S(p,y) = ∫_{[0,1]} S_θ(p,y) dν(θ)` (real Bochner integral;
see DEFS_draft_notes, A01). -/
noncomputable def mixtureScore (ν : Measure ℝ) (p y : ℝ) : ℝ :=
  ∫ θ in Set.Icc (0:ℝ) 1, elemScore θ p y ∂ν

/-- D11 (l.139).  `H_S = {π ∈ [0,1] : E_π{S(p,Y) - S(q,Y)} ≤ 0}`. -/
def HS (S : ℝ → ℝ → ℝ) (p q : ℝ) : Set ℝ :=
  {π | π ∈ Set.Icc (0:ℝ) 1 ∧ expPi π (fun y => S p y - S q y) ≤ 0}

/-- D12 (l.140).  `H = {π ∈ [0,1] : sup_{θ∈[0,1]} E_π{S_θ(p,Y) - S_θ(q,Y)} ≤ 0}`,
written as `∀ θ ∈ [0,1], … ≤ 0` (equivalent to the sup bound, the sup of the set being `≤ 0`). -/
def HAll (p q : ℝ) : Set ℝ :=
  {π | π ∈ Set.Icc (0:ℝ) 1 ∧
    ∀ θ ∈ Set.Icc (0:ℝ) 1, expPi π (fun y => elemScore θ p y - elemScore θ q y) ≤ 0}

/-- D13 (l.78, 142).  `E` is an e-value with null hypothesis `H` and alternative `H'`
(sets of probabilities `π ∈ [0,1]` of `Y = 1`): `E ≥ 0` (on `y ∈ {0,1}`), `E_π E ≤ 1` for
`π ∈ H`, `E_π E > 1` for `π ∈ H'`.  (Disjointness of `H, H'` is not part of this predicate.) -/
def IsEValue (E : ℝ → ℝ) (H H' : Set ℝ) : Prop :=
  0 ≤ E 0 ∧ 0 ≤ E 1 ∧ (∀ π ∈ H, expPi π E ≤ 1) ∧ (∀ π ∈ H', 1 < expPi π E)

/-- D14 (l.146-148, eq:representation).
`E_{p,q;λ}(y) = 1 + λ (S(p,y) - S(q,y)) / |S(p,1{p>q}) - S(q,1{p>q})|`. -/
noncomputable def Erep (S : ℝ → ℝ → ℝ) (p q lam y : ℝ) : ℝ :=
  1 + lam * (S p y - S q y) /
    |S p (if q < p then 1 else 0) - S q (if q < p then 1 else 0)|

/-- D16 (l.168-171).  `κ_ν{[a,b)} = ∫_{[a,b)} θ dν(θ) / ν{[a,b)}`
(real division; `ν{[a,b)}` converted by `ENNReal.toReal`). -/
noncomputable def kappa (ν : Measure ℝ) (a b : ℝ) : ℝ :=
  (∫ θ in Set.Ico a b, θ ∂ν) / (ν (Set.Ico a b)).toReal

/-- D15 (l.151, 154).  The expected log growth `E_{π₁} log E_{p,q;λ}` of `Erep`. -/
noncomputable def growthRate (S : ℝ → ℝ → ℝ) (p q π₁ lam : ℝ) : ℝ :=
  expPi π₁ (fun y => Real.log (Erep S p q lam y))

/-- `E_{π₁} log E_{p,q;λ}` is finite, i.e. `E_{p,q;λ}(y) > 0` for each outcome `y` of positive
probability under `π₁`; otherwise the paper's value is `-∞` (`Real.log 0 = 0` must not be used). -/
def GrowFinite (S : ℝ → ℝ → ℝ) (p q π₁ lam : ℝ) : Prop :=
  (π₁ ≠ 1 → 0 < Erep S p q lam 0) ∧ (π₁ ≠ 0 → 0 < Erep S p q lam 1)

/-- D15 (l.151, 154).  `lam ∈ (0,1]` maximizes `λ ↦ E_{π₁} log E_{p,q;λ}` over `λ ∈ (0,1]`,
values `-∞` handled via `GrowFinite` (the family of T01; see ambiguity A09). -/
def IsGrowLambda (S : ℝ → ℝ → ℝ) (p q π₁ lam : ℝ) : Prop :=
  lam ∈ Set.Ioc (0:ℝ) 1 ∧ GrowFinite S p q π₁ lam ∧
    ∀ l ∈ Set.Ioc (0:ℝ) 1, GrowFinite S p q π₁ l →
      growthRate S p q π₁ l ≤ growthRate S p q π₁ lam

/-- D17 (l.163-167).  `E^{π₁}_{p,q}(y)`, with `κ = κ_ν{[min p q, max p q)}`. -/
noncomputable def EGrow (ν : Measure ℝ) (p q π₁ y : ℝ) : ℝ :=
  if y = 0 then (1 - π₁) / (1 - kappa ν (min p q) (max p q))
  else π₁ / kappa ν (min p q) (max p q)

/-- D18 (l.193-196).  `E^{π₁*}_{p,q}(y) = (1-π₁)/(1-p)` for `y = 0`, `π₁/p` for `y = 1`. -/
noncomputable def EGrowAll (p π₁ y : ℝ) : ℝ :=
  if y = 0 then (1 - π₁) / (1 - p) else π₁ / p

end Paper

import Mathlib

namespace Paper.P06

open MeasureTheory ProbabilityTheory

/-- Subadditivity of `v` on the set `S` (source F:111: `v(x+y) ≤ v(x)+v(y)` for all `x,y`
in the domain of `v`).  Generic in the codomain so it can be used for `ℝ` and `EReal`. -/
def SubadditiveOn {α : Type*} [Add α] [LE α] (v : ℝ → α) (S : Set ℝ) : Prop :=
  ∀ x ∈ S, ∀ y ∈ S, v (x + y) ≤ v x + v y

/-- Generalised inverse (source F:111): `v⁻¹(u) = sup {x ∈ ℝ : v x ≤ u}`.
Valued in `EReal` so that the supremum of an empty / unbounded set is `⊥` / `⊤`
(source writes `sup` without restricting to bounded sets; see notes, decision E1). -/
noncomputable def genInv (v : ℝ → ℝ) (u : ℝ) : EReal :=
  sSup ((fun x : ℝ => (x : EReal)) '' {x : ℝ | v x ≤ u})

/-- Reciprocal on `EReal` with the conventions `1/⊤ = 0`, `1/⊥ = 0`, `1/0 = ⊤`
(source F:424 writes `1/F₂⁻¹(·)` without saying what happens at `0`, `±∞`; notes, E2). -/
noncomputable def recipE : EReal → EReal
  | ⊤ => 0
  | ⊥ => 0
  | (r : ℝ) => if r = 0 then ⊤ else ((1 / r : ℝ) : EReal)

/-- Definition 5.1 (source F:422-425): `F₁ ≤_{i-sb} F₂` iff
`x ↦ 1 / F₂⁻¹(F₁⁻(1/x))` is subadditive.  Here `F₁⁻` is the left-continuous version of the cdf
(`Function.leftLim`; source F:113: `F⁻(x)=P(X<x)`), `F₂⁻¹` the generalised inverse (F:111).
The domain of the function is read as `(0,∞)` (where `1/x` is meaningful). -/
noncomputable def isbOrder (F₁ F₂ : ℝ → ℝ) : Prop :=
  SubadditiveOn (fun x : ℝ => recipE (genInv F₂ (Function.leftLim F₁ (1 / x)))) (Set.Ioi 0)

/-- The Pareto cdf with shape 1 (source F:279): `𝒫(x) = 1 - 1/x` for `x ≥ 1`.
Extended by `0` for `x < 1` (the cdf of the law carried by `[1,∞)`; source defines only `x ≥ 1`,
notes decision E3 / inventory A11). -/
noncomputable def paretoCdf (x : ℝ) : ℝ := if 1 ≤ x then 1 - 1 / x else 0

/-- Definition 2.2 (source F:122-125, with F:121): a random variable `X` (given by its law `μ`)
with `F_X(0)=0` is InvSub iff the inverted distribution `F⁻_{1/X}(x) = 1 - F_X(1/x)` is
subadditive (domain read as `(0,∞)`). -/
def IsInvSub (μ : Measure ℝ) : Prop :=
  ProbabilityTheory.cdf μ 0 = 0 ∧
    SubadditiveOn (fun x : ℝ => 1 - ProbabilityTheory.cdf μ (1 / x)) (Set.Ioi 0)

end Paper.P06

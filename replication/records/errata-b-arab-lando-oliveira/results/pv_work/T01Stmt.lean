import L01Stmt

namespace Paper.T01

open MeasureTheory ProbabilityTheory
open Paper.L01

/-- Star-shaped (source F:111): `v(0)=0` and `v(x)/x` increasing (= non-decreasing, F:111),
read on `(0,∞)`. `h` is a function on `ℝ` of which only `[0,∞)` matters. -/
def StarShaped (v : ℝ → ℝ) : Prop :=
  v 0 = 0 ∧ MonotoneOn (fun x => v x / x) (Set.Ioi 0)

/-- Anti-star-shaped (source F:111): `v(x)/x` decreasing (= non-increasing), on `(0,∞)`. -/
def AntiStarShaped (v : ℝ → ℝ) : Prop :=
  AntitoneOn (fun x => v x / x) (Set.Ioi 0)

/-- Generalised inverse (source F:111): `v^{-1}(u) = sup {x : v x ≤ u}`; the sup is taken over
the domain `[0,∞)` of `h` (encoding choice; `sSup` of unbounded set is junk `0` in Lean). -/
noncomputable def ginv (v : ℝ → ℝ) (u : ℝ) : ℝ :=
  sSup {x : ℝ | 0 ≤ x ∧ v x ≤ u}

/-- External input X02. Provenance (i): Lemma 4.1 of \cite{ineq-order2024}, cited at
source/SuperParetoPaper-v12.tex:174 ("Since h is star-shaped, its inverse h^{-1} is
anti-star-shaped"). Specialised to continuous increasing `h` (the generalised inverse of
F:111 is only defined for increasing functions), which is weaker than the source's use. -/
def T01_X02Tool : Prop :=
  ∀ h : ℝ → ℝ, Continuous h → StarShaped h → MonotoneOn h (Set.Ici 0) →
    AntiStarShaped (ginv h)

/-- Consumed clause, provenance (p); counts as (iv) since L01 is ISSUE (upstream issue
L01_issue_1). Location in L01: the "only if" and "if" halves of Lemma 2.3 (F:128-134), the
latter with the added premise `F μ 0 = 0` (Def 2.2, F:124), a specialisation (weaker than L01).
Applicability: `→` is applied to `μ` (X is ITS, satisfied). `←` is applied to `μ.map h` at
F:180, and its premise `F (μ.map h) 0 = 0` is exactly S2, which the source never
establishes (recorded gap). -/
def T01_L01Consumed : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (IsInvSub μ → SubCond μ) ∧ (F μ 0 = 0 → SubCond μ → IsInvSub μ)

end Paper.T01

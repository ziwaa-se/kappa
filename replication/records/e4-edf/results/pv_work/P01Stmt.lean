import Defs

open MeasureTheory Filter Topology ProbabilityTheory

namespace Paper.P01

open Paper.Defs

/-- Conclusion of Proposition `prop:gc` (source/main.tex:46): `D_n → 0` almost surely. -/
def GCConclusion {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ) : Prop :=
  ∀ᵐ ω ∂P, Tendsto (fun n : ℕ => Dn P X n ω) atTop (𝓝 0)

/-- Hypotheses of Proposition `prop:gc` (source/main.tex:45-46): `X_1, X_2, …` are
independent and identically distributed random variables (Lean `X 0` = source `X_1`)
on a probability space. -/
structure IsIIDSeq {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ) : Prop where
  prob : IsProbabilityMeasure P
  meas : ∀ k, Measurable (X k)
  indep : iIndepFun X P
  ident : ∀ k, IdentDistrib (X k) (X 0) P P

/-- EXTERNAL INPUT `GlivenkoCantelli`. Provenance (i): cited by name only in
source/main.tex:50 ("This is the Glivenko--Cantelli theorem."), no `\cite`.
Statement: for every probability space and every iid real sequence, `sup_t |F_n - F| → 0`
almost surely. Mathlib has no Glivenko-Cantelli theorem (grep over Mathlib, see notes). -/
def GlivenkoCantelli.{u} : Prop :=
  ∀ (Ω : Type u) [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ),
    IsIIDSeq P X → GCConclusion P X

end Paper.P01

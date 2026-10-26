import P01Stmt

open MeasureTheory Filter Topology ProbabilityTheory

namespace Paper.P01

open Paper.Defs

/-- S1. source/main.tex:50: "This is the Glivenko--Cantelli theorem."
Role: the entire proof; instantiate the cited theorem at the given iid sequence.
Uses: external input `GlivenkoCantelli`. -/
theorem P01_S1.{u} (hGC : GlivenkoCantelli.{u}) (Ω : Type u) [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (h : IsIIDSeq P X) : GCConclusion P X :=
  hGC Ω P X h

/-- Proposition `prop:gc` (source/main.tex:45-47): if `X_1, X_2, …` are i.i.d.,
then `D_n → 0` almost surely. Proof plan: S1. -/
theorem P01_main.{u} (hGC : GlivenkoCantelli.{u}) (Ω : Type u) [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (h : IsIIDSeq P X) :
    ∀ᵐ ω ∂P, Tendsto (fun n : ℕ => Dn P X n ω) atTop (𝓝 0) :=
  P01_S1 hGC Ω P X h

end Paper.P01

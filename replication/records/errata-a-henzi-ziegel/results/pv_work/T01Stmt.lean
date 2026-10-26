import Defs

/-!
# T01 statement definitions (source/VSIFP_02.tex:144-149, Theorem 3.1 `thm:uniqueness`)
-/

open MeasureTheory

namespace Paper.T01

/-- "ν is the mixing measure of S" (l.94-97, eq:mixture), for the forecasts in `(0,1)` and the
outcomes `y ∈ {0,1}` (the only ones used in Theorem 3.1):
`ν` is a locally finite Borel measure on `(0,1)`, the elementary scores are `ν`-integrable on
`[0,1]` (so that the Bochner integral of `mixtureScore` is the integral of the source and not the
junk value `0`; candidate TFA, encoding of "the integral exists"), and `S p y = ∫ S_θ(p,y) dν`.
Provenance of the existence of such ν for a consistent S: type (i), Gneiting-Raftery 2007
Thm 2.3 (l.93), "under mild regularity conditions"; here it is NOT a parameter, ν is part of the
hypotheses as in the source ("the mixing measure ν of S", l.145). -/
def MixtureRep (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) : Prop :=
  IsMixingMeasure ν ∧
  ∀ p ∈ Set.Ioo (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ),
    IntegrableOn (fun θ => elemScore θ p y) (Set.Icc (0:ℝ) 1) ν ∧
    S p y = mixtureScore ν p y

end Paper.T01

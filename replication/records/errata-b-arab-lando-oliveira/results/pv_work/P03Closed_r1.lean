import P03
import T02

open MeasureTheory ProbabilityTheory

namespace Paper.P03

/-- P03's consumed clause for T02, derived from `T02_main` (n = 2, θ = (1/2, 1/2)). -/
theorem P03_T02Consumed_holds (hL01 : Paper.T02.T02_L01Consumed) : P03_T02Consumed := by
  intro _ Ω _ μ _ X Xs hiid hits
  exact Paper.T02.T02_main hL01 μ X Xs hiid hits (fun _ => 1 / 2)
    (fun _ => by norm_num) (by simp)

theorem main_closed (hL01 : Paper.T02.T02_L01Consumed) (hP02 : P03_P02Consumed)
    {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (hX : Measurable X)
    (hits : Paper.L01.IsInvSub (μ.map X)) :
    Paper.P02.InfiniteMean μ X :=
  P03_main hL01 (P03_T02Consumed_holds hL01) hP02 μ X hX hits

end Paper.P03

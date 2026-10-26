open MeasureTheory ProbabilityTheory Filter Topology

theorem glivenko_cantelli {Ω : Type*} [MeasureSpace Ω] [IsProbabilityMeasure (volume : Measure Ω)]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ i, Measurable (X i))
    (hind : iIndepFun X)                      -- older Mathlib: `iIndepFun (fun _ => inferInstance) X volume`
    (hid : ∀ i, IdentDistrib (X i) (X 0)) :
    ∀ᵐ ω, Tendsto (fun n : ℕ =>
        ⨆ t : ℝ, |empCDF (fun i : Fin (n + 1) => X i ω) t - cdf (volume.map (X 0)) t|)
      atTop (𝓝 0) := by
  sorry

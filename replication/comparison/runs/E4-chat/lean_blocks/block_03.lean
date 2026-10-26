noncomputable def kolmogorovK (z : ℝ) : ℝ :=
  1 - 2 * ∑' k : ℕ, (-1 : ℝ) ^ k * Real.exp (-2 * ((k : ℝ) + 1) ^ 2 * z ^ 2)

theorem kolmogorov_smirnov {Ω : Type*} [MeasureSpace Ω] [IsProbabilityMeasure (volume : Measure Ω)]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ i, Measurable (X i))
    (hind : iIndepFun X) (hid : ∀ i, IdentDistrib (X i) (X 0))
    (hcont : Continuous (cdf (volume.map (X 0)))) (z : ℝ) (hz : 0 < z) :
    Tendsto (fun n : ℕ => (volume {ω | Real.sqrt (n + 1) *
        ⨆ t : ℝ, |empCDF (fun i : Fin (n + 1) => X i ω) t - cdf (volume.map (X 0)) t| ≤ z}).toReal)
      atTop (𝓝 (kolmogorovK z)) := by
  sorry

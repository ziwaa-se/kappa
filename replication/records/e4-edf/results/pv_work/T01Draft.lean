import T01Stmt

open MeasureTheory Set

namespace Paper.T01
open Paper.Defs

/-- Main theorem, main.tex:53-58. -/
theorem T01 (hDon : DonskerUniformSup) (hKol : KolmogorovFormula)
    {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0))
    (hF : Continuous (cdfOf P X)) :
    KSConclusion P X := by
  sorry

/-- S1. Implicit (silent; not in source): `D_n` is measurable, needed for the
distributional statement (main.tex:54-55). Uses nothing. -/
theorem T01_S1 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hmeas : ∀ k, Measurable (X k)) (n : ℕ) : Measurable (Dn P X n) := by
  sorry

/-- S2. Silent reduction (not in source; main.tex:61): `U k = F ∘ X k` are measurable,
independent, uniform on [0,1] when `F` continuous. -/
theorem T01_S2 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    (∀ k, Measurable (fun ω => cdfOf P X (X k ω))) ∧
    ProbabilityTheory.iIndepFun (fun k ω => cdfOf P X (X k ω)) P ∧
    ∀ k, P.map (fun ω => cdfOf P X (X k ω)) = volume.restrict (Icc (0:ℝ) 1) := by
  sorry

/-- S3. Silent reduction (not in source): `D_n(X) = D_n(F ∘ X)` almost surely, for
all `n` simultaneously (continuity of F). -/
theorem T01_S3 {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    ∀ᵐ ω ∂P, ∀ n, Dn P X n ω = Dn P (fun k ω => cdfOf P X (X k ω)) n ω := by
  sorry

/-- S4. Silent standard fact: a.e. equal sequences have the same limit in distribution
(used to transfer S3 + Donsker). -/
theorem T01_S4 {Ω Ω' : Type} [MeasurableSpace Ω] [MeasurableSpace Ω'] (P : Measure Ω)
    (Y Y' : ℕ → Ω → ℝ) (Q : Measure Ω') (Z : Ω' → ℝ)
    (h : ∀ᵐ ω ∂P, ∀ n, Y n ω = Y' n ω) (hc : ConvInDist P Y' Q Z) : ConvInDist P Y Q Z := by
  sorry

/-- S5. main.tex:61-62: Donsker + sup continuous functional, applied to `U = F ∘ X`
(uses DonskerUniformSup, S2, S3, S4). -/
theorem T01_S5 (hDon : DonskerUniformSup)
    {Ω : Type} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ k, Measurable (X k))
    (hind : ProbabilityTheory.iIndepFun X P)
    (hid : ∀ k, P.map (X k) = P.map (X 0)) (hF : Continuous (cdfOf P X)) :
    ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
      (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ConvInDist P (fun n ω => Real.sqrt n * Paper.Defs.Dn P X n ω) Q (supAbs B) := by
  sorry

/-- S6. main.tex:62: Kolmogorov's form of `K` (uses KolmogorovFormula). -/
theorem T01_S6 (hKol : KolmogorovFormula)
    (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ) (hB : IsBrownianBridge Q B) :
    ∀ z : ℝ, 0 < z → Q.real {ω | supAbs B ω ≤ z} = Kfun z := by
  sorry

end Paper.T01

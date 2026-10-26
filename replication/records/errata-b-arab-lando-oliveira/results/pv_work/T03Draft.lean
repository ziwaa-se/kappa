import T03Stmt

namespace Paper.T03

open MeasureTheory

/-- S1 (source :337, "According to Proposition 4.3, X is nonnegative DOR").
Role: first step; converts super-Pareto to the odds-concavity form. Uses external input
`P04_X01Tool` (Prop 4.3, :296-299) and the identity `Λ = 1/Fbar - 1` (:301). -/
theorem T03_S1 (hX01 : Paper.P04.P04_X01Tool) (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hsp : Paper.P04.SuperPareto μ) (hn : Nonneg μ) :
    Nonneg μ ∧ Paper.P04.DOR μ := by sorry

/-- S2 (source :337, "Let Z be such that F_Z = 𝒫 and Y = Z-1, where F_Y(x) = x/(x+1), x ≥ 0").
Role: identifies the cdf of `Y`. Uses nothing earlier. -/
theorem T03_S2 (x : ℝ) (hx : 0 ≤ x) : Paper.L01.F lawY x = x / (x + 1) := by sorry

/-- S3a (source :337, "Given the shift invariance of the convex transform order, X being
super-Pareto is equivalent to X =ᵈ h(Y), where h is increasing convex" (on `[0,∞)`)).
Role: reparametrises the representation `h(Z)` (Def 4.1, :286) as `g(Y) = g(Z-1)`, `g(y)=h(y+1)`.
Uses S1 / Prop 4.3 context and S2. The "shift invariance of ≤_c" is only cited, not proved. -/
theorem T03_S3a (μ : Measure ℝ) [IsProbabilityMeasure μ] (hsp : Paper.P04.SuperPareto μ)
    (hn : Nonneg μ) :
    ∃ g : ℝ → ℝ, MonotoneOn g (Set.Ici 0) ∧ ConvexOn ℝ (Set.Ici 0) g ∧ μ = lawY.map g := by
  sorry

/-- S3b (source :337, "where h is ... and h(0) = 0").
Role: normalisation needed for star-shapedness. The source gives NO justification: the shifted
representation has `g(0) = h(1) = ess inf X`, which is `0` only if `X` has infimum `0`; e.g. `X`
Pareto itself (`g(y)=y+1`) is nonnegative super-Pareto with `g(0)=1`. Recorded, not repaired.
Stated for the `g` of S3a. -/
theorem T03_S3b (μ : Measure ℝ) [IsProbabilityMeasure μ] (hn : Nonneg μ)
    (g : ℝ → ℝ) (hm : MonotoneOn g (Set.Ici 0)) (hc : ConvexOn ℝ (Set.Ici 0) g)
    (hμ : μ = lawY.map g) : g 0 = 0 := by sorry

/-- S3c (source :337, "h is increasing convex and h(0)=0, hence h is star-shaped").
Role: standard fact (convex with `g(0)=0` gives `g(x)/x` increasing on `(0,∞)`); uses S3a, S3b.
Provenance (v) standard fact, implicit. -/
theorem T03_S3c (g : ℝ → ℝ) (hc : ConvexOn ℝ (Set.Ici 0) g) (h0 : g 0 = 0) :
    Paper.T01.StarShaped g := by sorry

/-- S4 (silently needed, :337 "applying Theorem 2.8" requires `h` continuous; the source says
only "increasing convex ... star-shaped"). A convex monotone `g` on `[0,∞)` with `g 0 = 0` is
continuous on `[0,∞)`; the extension `g ∘ max · 0` to `ℝ` is continuous and has the same push
forward of `lawY`, and is still star-shaped. Flagged as (iii)-type implicit step. -/
theorem T03_S4 (g : ℝ → ℝ) (hm : MonotoneOn g (Set.Ici 0)) (hc : ConvexOn ℝ (Set.Ici 0) g)
    (h0 : g 0 = 0) :
    Continuous (fun x => g (max x 0)) ∧ lawY.map (fun x => g (max x 0)) = lawY.map g := by
  sorry

/-- S5 (source :337, "It is straightforward to verify that Y is ITS").
Role: premise of Theorem 2.8. Uses S2 (cdf of `Y`) and Lemma 2.3 / Def 2.2 (:122-134);
`F_Y(0)=0` and `F_Y(x/θ)+F_Y(x/(1-θ)) ≤ F_Y(x)+1`. The source gives no computation
(only the analogous claim about 𝒫 at :279). -/
theorem T03_S5 : Paper.L01.IsInvSub lawY := by sorry

/-- Theorem 4.8 (source :332-335): nonnegative super-Pareto `X` is ITS.
`X` is represented by its law `μ`. Proof plan: S1 (DOR, informational), S3a-S3c, S4 give
`μ = lawY.map g'` with `g'` continuous star-shaped; S5 gives `Y` ITS; the consumed clause
`T03_T01Consumed` (Thm 2.8) yields `IsInvSub (lawY.map g')`. S3b is unjustified in the source. -/
theorem T03_main (hX01 : Paper.P04.P04_X01Tool) (hT01 : T03_T01Consumed)
    (μ : Measure ℝ) [IsProbabilityMeasure μ] (hsp : Paper.P04.SuperPareto μ)
    (hn : Nonneg μ) : Paper.L01.IsInvSub μ := by sorry

end Paper.T03

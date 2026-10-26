import T03Stmt

namespace Paper.T03

/-- S1 (l.466, "A direct computation shows that `H = [0,p]` if `p < q`", also l.201). Step X08:
source gives no computation. Uses nothing. -/
theorem T03_S1 (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (h : p < q) :
    HAll p q = Set.Icc 0 p := by sorry

/-- S2 (l.466, "`H = [p,1]` if `p > q`", also l.201). Step X08. Uses nothing. -/
theorem T03_S2 (p q : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1) (h : q < p) :
    HAll p q = Set.Icc p 1 := by sorry

/-- S3 (l.466, "`E_π{E^{π₁*}_{p,q}(Y)} ≤ 1` for all `π ∈ H`"). Step X08 (the source gives no
computation); uses S1, S2 and `π₁ ∉ H`, `π₁ ∈ [0,1]`. -/
theorem T03_S3 (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    ∀ π ∈ HAll p q, expPi π (EGrowAll p π₁) ≤ 1 := by sorry

/-- S4 (l.466, "`E_π{E^{π₁*}_{p,q}(Y)} > 1` for `π ∉ H`"; `π ∈ [0,1]`). Step X08; uses S1, S2,
`π₁ ∉ H`. -/
theorem T03_S4 (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) (hq : q ∈ Set.Ioo (0:ℝ) 1)
    (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    ∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ HAll p q → 1 < expPi π (EGrowAll p π₁) := by sorry

/-- S5 (l.466, "The result then follows by Theorem 1 of Gruenwald2019, with `W_1` the Dirac measure
at `π₁`"; also l.188). Uses S3, S4 and external input X03 (`GruenwaldThm1`) with `p₀ = p`,
`H = HAll p q` (`HAll ⊆ [0,1]` by definition). -/
theorem T03_S5 (X03 : GruenwaldThm1) (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1)
    (hq : q ∈ Set.Ioo (0:ℝ) 1) (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q)
    (s3 : ∀ π ∈ HAll p q, expPi π (EGrowAll p π₁) ≤ 1)
    (s4 : ∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ HAll p q → 1 < expPi π (EGrowAll p π₁)) :
    GrowIs (HAll p q) π₁ (EGrowAll p π₁) := by sorry

/-- Theorem 3.3 (l.190-198).  `p, q ∈ (0,1)`; alternative: `Y = 1` w.p. `π₁ ∈ [0,1]`, `π₁ ∉ H`.
Conclusion: the GROW e-value with null `H` (= `HAll p q`) against `π₁` is
`E^{π₁*}_{p,q} = EGrowAll p π₁`.  Assembled from S1-S5 (S1, S2 enter via S3, S4). -/
theorem T03_main (X03 : GruenwaldThm1) (p q π₁ : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1)
    (hq : q ∈ Set.Ioo (0:ℝ) 1) (h1 : π₁ ∈ Set.Icc (0:ℝ) 1) (h2 : π₁ ∉ HAll p q) :
    GrowIs (HAll p q) π₁ (EGrowAll p π₁) := by sorry

end Paper.T03

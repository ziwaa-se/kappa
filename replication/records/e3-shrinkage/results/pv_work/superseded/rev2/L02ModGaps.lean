import L02Stmt

namespace Paper.L02

/-- S1. main.tex:53. -/
theorem L02_S1 (θ σ : ℝ) (h : Setting θ σ) :
    oracleRisk θ σ = (1 / 2) * harmonicMean (θ ^ 2) (σ ^ 2) := by
  unfold oracleRisk harmonicMean
  ring

/-- Gap for S2 (main.tex:54). -/
def L02_S2_Gap : Prop := HarmonicLeMin

/-- Gap for S3 (main.tex:54-55). -/
def L02_S3_Gap : Prop :=
  ∀ (θ σ : ℝ) (h : Setting θ σ), oracleRisk θ σ ≤ (1 / 2) * min (θ ^ 2) (σ ^ 2)

/-- S4. main.tex:55. -/
theorem L02_S4 (θ σ : ℝ) (h : Setting θ σ) :
    (1 / 2) * min (θ ^ 2) (σ ^ 2) ≤ min (θ ^ 2) (σ ^ 2) := by
  have : 0 ≤ min (θ ^ 2) (σ ^ 2) := le_min (sq_nonneg _) (sq_nonneg _)
  linarith

/-- L02, main.tex:55, modulo gaps (S3 is used; S2 only enters through S3). -/
theorem L02_mod_gaps (hGap_3 : L02_S3_Gap) (θ σ : ℝ) (h : Setting θ σ) : Conclusion θ σ :=
  le_trans (hGap_3 θ σ h) (L02_S4 θ σ h)

end Paper.L02

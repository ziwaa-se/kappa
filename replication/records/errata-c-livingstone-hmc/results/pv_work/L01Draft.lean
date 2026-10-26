import L01Stmt

open Paper.Defs

namespace Paper.L01

/-- S1. TEX:951: after one leapfrog step, `x_ε = x_0 - (ε²/2)∇U(x_0) + ε p_0`.
Role: unfolds the single step (case `L=1` of the recursion, TEX:330-336).  Uses nothing. -/
theorem L01_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 1 = x0 - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  sorry

/-- S2. TEX:951: `‖x_ε‖ ≥ (ε²/2)‖∇U(x_0)‖ - ‖x_0‖ - ε‖p_0‖` (reverse triangle inequality; `ε>0`
from TEX:336).  Uses S1. -/
theorem L01_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) :
    (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  sorry

/-- S3. TEX:955: for `x_0 ≠ 0`, dividing by `‖x_0‖`:
`‖x_ε‖/‖x_0‖ ≥ (ε²/2)‖∇U(x_0)‖/‖x_0‖ - 1 - ε‖p_0‖/‖x_0‖`.  Uses S2. -/
theorem L01_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : x0 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖) ≤ ‖xLF gU eps x0 p0 1‖ / ‖x0‖ := by
  sorry

/-- S4. TEX:957: "the last term is bounded above by `ε‖x_0‖^{δ-1}` and tends to zero": for fixed
`δ<1`, `ε‖p_0‖/‖x_0‖ ≤ ε‖x_0‖^{δ-1}` when `‖p_0‖ ≤ ‖x_0‖^δ`, `x_0 ≠ 0`; and
`ε‖x_0‖^{δ-1} → 0` as `‖x_0‖ → ∞`.  Stated as: for every `c>0` there is `R` with the bound
`< c` once `‖x_0‖ > R`. -/
theorem L01_S4 (eps δ : ℝ) (heps : 0 < eps) (hδ : δ < 1) :
    ∀ c : ℝ, 0 < c → ∃ R : ℝ, ∀ r : ℝ, R < r → 0 < r → eps * r ^ (δ - 1) < c := by
  sorry

/-- S5. TEX:957: "The first term on the right-hand side tends to infinity by (17)": for `ε>0`,
`HypExplode gU` gives `(ε²/2)‖∇U(x_0)‖/‖x_0‖ → ∞`, i.e. exceeds any bound `B` for large `‖x_0‖`. -/
theorem L01_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (h : HypExplode gU) :
    ∀ B : ℝ, ∃ R : ℝ, ∀ x0 : E d, R < ‖x0‖ → B < (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) := by
  sorry

/-- S6. TEX:957: "Hence the right-hand side is larger than 3 for all sufficiently large `‖x_0‖`",
giving the conclusion.  Uses S3, S4, S5. -/
theorem L01_S6 {d : ℕ} (gU : E d → E d) (eps δ : ℝ) (heps : 0 < eps) (hδ : δ < 1)
    (h : HypExplode gU) : Concl gU eps δ := by
  sorry

/-- Main theorem, Lemma 5.15 (TEX:945-947): if (17) holds, then for any fixed `δ < 1` (and step-size
`ε > 0`, TEX:336) there is `η < ∞` such that for all `‖x_0‖ > η` and `‖p_0‖ ≤ ‖x_0‖^δ`,
`‖x_ε‖ > 3‖x_0‖`.  Assembled from S1-S6. -/
theorem L01_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps)
    (h : HypExplode gU) : ∀ δ : ℝ, δ < 1 → Concl gU eps δ := by
  intro δ hδ
  exact L01_S6 gU eps δ heps hδ h

end Paper.L01

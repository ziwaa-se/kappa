import L01Stmt

open Paper.Defs

namespace Paper.L01

/-- Main theorem, Lemma 5.15 (TEX:884-886): "If (17) holds then there exists an `η<∞` such that for
all `‖x_0‖>η` and any `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ<1`, it holds that `‖x_ε‖>2‖x_0‖`."
Read with `δ < 1` fixed first and `η = η(δ)` (and of `ε`, `gU`, `d`): this is the reading used by the
printed proof (TEX:896 "negligibly small as `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ<1`") and by every consumer
(TEX:879, 916/930, 940).  `ε>0` is explicit (TEX:336).  Type is `ConclFixedDelta` (consumed by L02).
Assembly: S1-S3, S4 (B = 4), S5 (ζ = 1). -/
theorem L01_main_fixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps)
    (hexp : HypExplode gU) : ConclFixedDelta gU eps := by
  sorry

/-- S1 (TEX:890, first equality; case `L=1` of eqn:mprop, TEX:364): after one leapfrog step
`x_ε = x_0 - (ε²/2)∇U(x_0) + ε p_0`.  Derivable by unfolding `leapfrogStep` (no external input).
Role: rewrite `x_ε`.  Uses: nothing. -/
theorem L01_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 1 = x0 - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  sorry

/-- S2 (TEX:890, inequality): `‖x_ε‖ ≥ (ε²/2)‖∇U(x_0)‖ - ‖x_0‖ - ε‖p_0‖` (reverse triangle
inequality; `ε>0`).  Uses S1. -/
theorem L01_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) :
    (eps ^ 2 / 2) * ‖gU x0‖ - ‖x0‖ - eps * ‖p0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  sorry

/-- S3 (TEX:893-895, display (20)): dividing by `‖x_0‖` (for `x_0 ≠ 0`):
`‖x_ε‖/‖x_0‖ ≥ (ε²/2)‖∇U(x_0)‖/‖x_0‖ - 1 - ε‖p_0‖/‖x_0‖`.  Uses S2. -/
theorem L01_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : x0 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) - 1 - eps * (‖p0‖ / ‖x0‖) ≤
      ‖xLF gU eps x0 p0 1‖ / ‖x0‖ := by
  sorry

/-- S4 (TEX:896, first clause): by (17), there is `η₁` with `‖x_0‖>η₁ → (ε²/2)‖∇U(x_0)‖/‖x_0‖`
large.  The source says "larger than `6/ε²`" (N4: the ratio `‖∇U‖/‖x_0‖` larger than `6/ε²` would
make the first term larger than 3; the source wording attaches `6/ε²` to the term itself; the
statement here records only the faithful reading "larger than any prescribed bound `B`", of which
the needed values are instances).  Uses (17) = `HypExplode`. -/
theorem L01_S4 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU)
    (B : ℝ) : ∃ η₁ : ℝ, ∀ x0 : E d, η₁ < ‖x0‖ → B < (eps ^ 2 / 2) * (‖gU x0‖ / ‖x0‖) := by
  sorry

/-- S5 (TEX:896, second clause): the last term `ε‖p_0‖/‖x_0‖` is negligible when
`‖p_0‖ ≤ ‖x_0‖^δ`, `δ<1`: for each fixed `δ<1` and `ζ>0` there is `η₂` such that
`‖x_0‖>η₂` and `‖p_0‖ ≤ ‖x_0‖^δ` give `ε‖p_0‖/‖x_0‖ < ζ`. -/
theorem L01_S5 {d : ℕ} (eps δ ζ : ℝ) (heps : 0 < eps) (hδ : δ < 1) (hζ : 0 < ζ) :
    ∃ η₂ : ℝ, ∀ x0 p0 : E d, η₂ < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → eps * (‖p0‖ / ‖x0‖) < ζ := by
  sorry

end Paper.L01

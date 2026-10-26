import L02Stmt

open Paper.Defs

namespace Paper.L02

/-- Main theorem, Lemma 5.16 (TEX:960-966): if (17) holds, then for any fixed `δ < 1` (and step size
`ε > 0`, TEX:336, fixed number `L` of leapfrog steps) there is `η < ∞` such that for all `‖x_0‖ > η`
and `‖p_0‖ ≤ ‖x_0‖^δ`: `‖x_{iε}‖ ≥ 3‖x_{(i-1)ε}‖` for `i = 1,…,L` and `‖x_{Lε}‖ ≥ 3^L‖x_0‖`.
The first hypothesis is the consumed clause of L01 (provenance (p)).  Only (17) is assumed, as
printed (the revised proof no longer invokes (18)). -/
theorem L02_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : ∀ δ : ℝ, δ < 1 → Concl gU eps L δ := by
  sorry

/-- S1 (TEX:969-975, eqn:recurrence): "For each `i ≥ 1`, eliminating the intermediate half-step
momentum from two successive leapfrog position updates gives the exact recurrence
`x_{(i+1)ε} = 2x_{iε} - x_{(i-1)ε} - ε²∇U(x_{iε})`."  Derivable by unfolding `leapfrogStep`.
Uses nothing. -/
theorem L02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) (hi : 1 ≤ i) :
    xLF gU eps x0 p0 (i + 1) =
      (2 : ℝ) • xLF gU eps x0 p0 i - xLF gU eps x0 p0 (i - 1)
        - eps ^ 2 • gU (xLF gU eps x0 p0 i) := by
  sorry

/-- S2 (TEX:976-981, eqn:gradthreshold): "By (17), there is an `R < ∞` such that
`ε²‖∇U(x)‖/‖x‖ ≥ 16/3` whenever `‖x‖ ≥ R`."  Uses (17) and `ε ≠ 0` (`ε > 0`, TEX:336). -/
theorem L02_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU) :
    ∃ R : ℝ, ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖) := by
  sorry

/-- S3 (TEX:982-983): "Choose `x_0` such that `‖x_0‖ ≥ max(R, η)`, meaning Lemma `lem:xelower` applies
... The case `i = 1` then follows from Lemma `lem:xelower`."  Gives, from the consumed clause of L01
and the fixed `δ < 1`, an `η` with `3‖x_0‖ ≤ ‖x_ε‖` for `‖x_0‖ > η`, `‖p_0‖ ≤ ‖x_0‖^δ`.
Uses L01 (consumed). -/
theorem L02_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      3 * ‖xLF gU eps x0 p0 0‖ ≤ ‖xLF gU eps x0 p0 1‖ := by
  sorry

/-- S4a (TEX:984-993, first inequality): "Taking norms in (recurrence) gives
`‖x_{(i+1)ε}‖/‖x_{iε}‖ ≥ ε²‖∇U(x_{iε})‖/‖x_{iε}‖ - 2 - ‖x_{(i-1)ε}‖/‖x_{iε}‖`."
Norm of S1 and the triangle inequality; needs `‖x_{iε}‖ > 0` (implicit division).  Uses S1. -/
theorem L02_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) (hi : 1 ≤ i)
    (hx : 0 < ‖xLF gU eps x0 p0 i‖) :
    eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2
        - ‖xLF gU eps x0 p0 (i - 1)‖ / ‖xLF gU eps x0 p0 i‖ ≤
      ‖xLF gU eps x0 p0 (i + 1)‖ / ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S4b (TEX:993-996, second inequality): from the induction hypothesis
`‖x_{iε}‖ ≥ 3‖x_{(i-1)ε}‖` (and `‖x_{iε}‖ > 0`): `‖x_{(i-1)ε}‖/‖x_{iε}‖ ≤ 1/3`, hence
`ε²‖∇U(x_{iε})‖/‖x_{iε}‖ - 2 - ‖x_{(i-1)ε}‖/‖x_{iε}‖ ≥ ε²‖∇U(x_{iε})‖/‖x_{iε}‖ - 2 - 1/3`. -/
theorem L02_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ)
    (hx : 0 < ‖xLF gU eps x0 p0 i‖)
    (hind : 3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2 - 1 / 3 ≤
      eps ^ 2 * (‖gU (xLF gU eps x0 p0 i)‖ / ‖xLF gU eps x0 p0 i‖) - 2
        - ‖xLF gU eps x0 p0 (i - 1)‖ / ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S5 (TEX:998-999): "The preceding steps of the induction imply `‖x_{iε}‖ ≥ ‖x_0‖ ≥ R`":
if `‖x_{jε}‖ ≥ 3‖x_{(j-1)ε}‖` for `j = 1,…,i` then `‖x_0‖ ≤ ‖x_{iε}‖`. -/
theorem L02_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ)
    (h : ∀ j : ℕ, 1 ≤ j → j ≤ i →
      3 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖) :
    ‖x0‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S6 (TEX:1000-1004): inductive step.  With `R` as in S2, `‖x_0‖ ≥ R`, `‖x_0‖ > 0` (implicit: the
divisions by `‖x_{iε}‖`), and the stepwise bounds for `j = 1,…,i` (`i ≥ 1`), conclude
`‖x_{(i+1)ε}‖/‖x_{iε}‖ ≥ 16/3 - 7/3 = 3`, i.e. `3‖x_{iε}‖ ≤ ‖x_{(i+1)ε}‖`.
Uses S4a, S4b, S5 and the threshold of S2. -/
theorem L02_S6 {d : ℕ} (gU : E d → E d) (eps : ℝ) (R : ℝ)
    (hR : ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖))
    (x0 p0 : E d) (hx0 : 0 < ‖x0‖) (hRx : R ≤ ‖x0‖) (i : ℕ) (hi : 1 ≤ i)
    (h : ∀ j : ℕ, 1 ≤ j → j ≤ i →
      3 * ‖xLF gU eps x0 p0 (j - 1)‖ ≤ ‖xLF gU eps x0 p0 j‖) :
    3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ := by
  sorry

/-- S7 (TEX:1005, "This proves (eqn:stepwise) by induction"): induction over `i = 1,…,L` from S3
(base) and S6 (step).  For `‖x_0‖ > η` (S3), `‖x_0‖ ≥ R`, `‖x_0‖ > 0`, `‖p_0‖ ≤ ‖x_0‖^δ`:
`3‖x_{(i-1)ε}‖ ≤ ‖x_{iε}‖` for `i = 1,…,L`.  Uses S3, S6. -/
theorem L02_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (R : ℝ)
    (hR : ∀ x : E d, R ≤ ‖x‖ → 16 / 3 ≤ eps ^ 2 * (‖gU x‖ / ‖x‖))
    (x0 p0 : E d) (hx0 : 0 < ‖x0‖) (hRx : R ≤ ‖x0‖)
    (hbase : 3 * ‖xLF gU eps x0 p0 0‖ ≤ ‖xLF gU eps x0 p0 1‖) :
    ∀ i : ℕ, 1 ≤ i → i ≤ L → 3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S8 (TEX:1005-1006): "`‖x_{Lε}‖ ≥ 3^L‖x_0‖` follows immediately" from the stepwise bounds
(telescoping product). -/
theorem L02_S8 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d)
    (h : ∀ i : ℕ, 1 ≤ i → i ≤ L →
      3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    (3 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  sorry

end Paper.L02

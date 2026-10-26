import L01Stmt

/-!
# L02 = Lemma 5.16 (lem:xlower), statement definitions
Source: source/geo_erg_HMC_v3.1.tex:899-901 (statement), 903-935 (proof).

External inputs: none besides the consumed clause `L02_L01Consumed` (provenance (p)).
Prop. 4.2 (eqn:mprop, TEX:361-374) is NOT declared as an input: both the recursion for `x_{iε}`
and eqn:mprop are derivable by unfolding `Paper.Defs.leapfrogStep` (steps S1, S1' in the draft).
-/

open Paper.Defs

namespace Paper.L02

/-- Literal reading of TEX:900 (uniform in `δ`, as in L01 `Concl`): `∃ η` such that for all `x_0` with
`‖x_0‖ > η` and all `p_0` with `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ < 1`: `‖x_{Lε}‖ ≥ 2^L ‖x_0‖`.
`L` (fixed number of leapfrog steps, TEX:330, N8) and `ε` are fixed before `η`. -/
def Concl {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → (∃ δ : ℝ, δ < 1 ∧ ‖p0‖ ≤ ‖x0‖ ^ δ) →
    (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖

/-- Fixed-`δ` reading (N5): `δ < 1` is fixed first and `η` may depend on `δ` (same convention as
`Paper.L01.ConclFixedDelta`, the verdict-bearing reading there). -/
def ConclFixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖

/-- Consumed clause of predecessor L01 (Lemma 5.15, TEX:884-886), provenance (p): the first-step
bound `‖x_ε‖ > 2‖x_0‖` for large `‖x_0‖` and `‖p_0‖ ≤ ‖x_0‖^δ` (fixed-`δ` form, the verdict-bearing
reading of L01).  Used in the proof of L02 at the first step (TEX:930: applying (18) to the pair
`(x_0, x_ε)` needs `‖x_ε‖ ≥ 2‖x_0‖`; and `‖x_ε‖ → ∞`, TEX:922-924).  Located in L01 as
`Paper.L01.ConclFixedDelta gU eps`. -/
def L02_L01Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) : Prop :=
  Paper.L01.ConclFixedDelta gU eps

end Paper.L02

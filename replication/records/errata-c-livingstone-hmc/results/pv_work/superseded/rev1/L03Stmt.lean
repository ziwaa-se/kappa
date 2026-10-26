import L02Stmt

/-!
# L03 = Lemma 5.17 (lem:arate_0), statement definitions
Source: source/geo_erg_HMC_v3.1.tex:939-944 (statement), 946-971 (proof).

External inputs: none besides the consumed clause `L03_L02Consumed` (provenance (p)).
Prop. 4.2 (acceptance formula TEX:366-369, eqn:mprop2 TEX:371-373) is NOT declared as an input:
it is derivable by unfolding `Paper.Defs.accProb`, `piDens`, `leapfrogStep` (steps S1, S2 in the draft).
-/

open Paper.Defs

namespace Paper.L03

/-- Consumed clause of predecessor L02 (Lemma 5.16, TEX:899-901 and its proof 903-935), provenance (p),
in the fixed-`δ` form (verdict-bearing reading of L02).  Two parts:
(a) the printed statement of L02, `‖x_{Lε}‖ ≥ 2^L‖x_0‖` (`Paper.L02.ConclFixedDelta`; used at TEX:968
    and to place `(x_0,x_{Lε})` in the region of (19), TEX:970);
(b) the intermediate bound `‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖` for `1 ≤ i ≤ L`, which L02 PROVES (TEX:934, its
    step `L02_S10`) but does NOT state in its printed statement (INVENTORY X5).  It is needed at
    TEX:953-954, where (18) is applied to the consecutive pairs `(x_{iε}, x_{(i+1)ε})`.
Hypotheses (17) and (18) are available in L03.  Located in L02 as `Paper.L02.ConclFixedDelta` and
`Paper.L02.L02_S10`. -/
def L03_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  Paper.L02.ConclFixedDelta gU eps L ∧
  ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖

end Paper.L03

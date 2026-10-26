import L01Stmt

/-!
# L02 = Lemma 5.16 (lem:xlower), statement definitions (revision 1)
Source: source/geo_erg_HMC_v3.1.tex:960-966 (statement), 968-1007 (proof).

External inputs: none besides the consumed clause `L02_L01Consumed` (provenance (p)), which is
used where the proof says "The case `i=1` then follows from Lemma `lem:xelower`" (TEX:983).
The recurrence (TEX:971-974) is derivable by unfolding `Paper.Defs.leapfrogStep` (step S1 in the draft),
so it is not an external input.  The revised statement does not mention (18)/(19), so no
oscillation hypothesis definition (`HypOscillations3`, `HypOscillation3L`) is needed here; the
stale `Paper.Defs.HypOscillations`/`HypOscillation2` are not used (note for coordinator: a `Defs2`
with the revised (18)/(19) may be wanted; `Paper.C01.HypOscillations3` already exists in C01Stmt).
-/

open Paper.Defs

namespace Paper.L02

/-- Conclusion of Lemma 5.16 (TEX:961-965), "for any fixed `δ < 1`" read as: `δ < 1` is fixed first,
then `η` (may depend on `δ`, `ε`, `L`, `∇U`) exists such that for all `‖x_0‖ > η` and all
`‖p_0‖ ≤ ‖x_0‖^δ`: (a) the stepwise bound (eqn:stepwise, TEX:963) `‖x_{iε}‖ ≥ 3‖x_{(i-1)ε}‖` for
`i = 1,…,L`, and (b) "meaning" `‖x_{Lε}‖ ≥ 3^L ‖x_0‖` (TEX:965).  Same fixed-`δ` convention as
`Paper.L01.Concl`.  `L` (fixed number of leapfrog steps) and `ε` are fixed before `η`. -/
def Concl {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ) : Prop :=
  ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
    (∀ i : ℕ, 1 ≤ i → i ≤ L → 3 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) ∧
    (3 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖

/-- Consumed clause of predecessor L01 (Lemma 5.15, TEX:945-947), provenance (p): for every fixed
`δ < 1`, `‖x_ε‖ > 3‖x_0‖` for `‖x_0‖ > η` and `‖p_0‖ ≤ ‖x_0‖^δ`, i.e. `Paper.L01.Concl gU eps δ`
(L01Stmt.lean) for all `δ < 1`.  Used at TEX:982-983 (case `i = 1`).  Applicability: same `ε`, `∇U`,
and hypothesis (17) (`HypExplode`), which L02 also assumes; L01 is the statement
`∀ δ<1, Concl gU eps δ` under (17) and `ε > 0` (`Paper.L01.L01_main`). -/
def L02_L01Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) : Prop :=
  ∀ δ : ℝ, δ < 1 → Paper.L01.Concl gU eps δ

end Paper.L02

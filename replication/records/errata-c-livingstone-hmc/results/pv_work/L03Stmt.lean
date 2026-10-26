import L02Stmt

/-!
# L03 = Lemma 5.17 (lem:arate_0), statement definitions (revision 1 re-draft)
Source: source/geo_erg_HMC_v3.1.tex:1011-1016 (statement), 1018-1096 (proof).
Hypotheses printed in thm:light, TEX:897-907: (17) `eqn:explode`, (18) `eqn:oscillations` (REVISED: `‖y‖ ≥ 3‖x‖ ≥ C`),
(19) `eqn:oscillation2` (unchanged).

External inputs: none besides the consumed clause `L03_L02Consumed` (provenance (p)).
Prop. 4.2 (acceptance formula TEX:366-369) is NOT an input: it is derivable by unfolding
`Paper.Defs.accProb`, `piDens`, `leapfrogStep` (steps S1, S2 in the draft).
`Paper.Defs.HypOscillations` (frozen) encodes the stale `2‖x‖` form of (18); the revised form is declared
here as `Paper.L03.HypOscillations3` (same content as `Paper.C01.HypOscillations3` in C01Stmt, which is
not imported to avoid its heavy dependencies).
-/

open Filter Topology
open Paper.Defs

namespace Paper.L03

/-- Hypothesis (18) in its REVISED form (`eqn:oscillations`, TEX:900-903): there is a fixed `C < ∞` such
that whenever `‖y‖ ≥ 3‖x‖ ≥ C` then `‖∇U(y)‖ ≥ 3‖∇U(x)‖`. -/
def HypOscillations3 {d : ℕ} (gU : E d → E d) : Prop :=
  ∃ C : ℝ, ∀ x y : E d, 3 * ‖x‖ ≤ ‖y‖ → C ≤ 3 * ‖x‖ → 3 * ‖gU x‖ ≤ ‖gU y‖

/-- Conclusion of Lemma 5.17 (TEX:1014) for a fixed `δ`:
`lim_{‖x_0‖→∞, ‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) = 0`, as a `Tendsto` along `tailMomFilter d δ`
(limit over pairs `(x_0,p_0)` in the region), with `α = accProb` (Prop. 4.2 form, TEX:1021). -/
def Concl {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ) : Prop :=
  Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0)

/-- Consumed clause of predecessor L02 (Lemma 5.16, TEX:960-966; proof 968-1007), provenance (p):
for every fixed `δ < 1`, `Paper.L02.Concl gU eps L δ`, i.e. there is `η` such that for `‖x_0‖ > η` and
`‖p_0‖ ≤ ‖x_0‖^δ`: `‖x_{iε}‖ ≥ 3‖x_{(i-1)ε}‖` (`1 ≤ i ≤ L`, eqn:stepwise) and `‖x_{Lε}‖ ≥ 3^L‖x_0‖`.
Used at TEX:1023-1025 ("Lemma lem:xlower applies", stepwise bound) and TEX:1050, 1076, 1092
(`‖x_{Lε}‖ ≥ 3^L‖x_0‖`).  Located in L02 as `Paper.L02.Concl`.  Applicability: L02 assumes (17) and
`ε > 0`, both available here; `L` and `ε` are the same. -/
def L03_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  ∀ δ : ℝ, δ < 1 → Paper.L02.Concl gU eps L δ

end Paper.L03

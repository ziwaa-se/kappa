import T02Stmt
import L03

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-- Main theorem, Theorem 5.14 (TEX:863-877): if (17) `‖∇U‖/‖x‖ → ∞`, (18) `‖y‖ ≥ 2‖x‖ ≥ C ⇒
‖∇U(y)‖ ≥ 3‖∇U(x)‖`, (19) `lim (U(x) - U(y) - ‖x‖²/2) = -∞` over `‖x‖ → ∞, ‖y‖ ≥ 2^L‖x‖`, then HMC with
fixed integration time `T = Lε` does not produce a geometrically ergodic chain "for any choice `T>0`"
(here: for every `ε > 0` and every `L ≥ 1`, with the same `L` in (19), N3).
Parameters, in order: `hL02` consumed clause of L02 (provenance (p); `T02_L02Consumed` of `T02Stmt`, same content as
`Paper.L03.L03_L02Consumed`: its part (a) is the sentence "`‖x_{Lε}‖ ≥ 2^L‖x_0‖`" used at TEX:879, both parts are needed by
L03); `hE1` Prop. 3.5 (provenance (i)); `hE6` Gaussian facts (provenance (v)).
Standing conventions made explicit (candidate TFAs, see notes): `0 < d` (TFA-2), `IsGradField U gU`
(`∇U` exists, TEX:320), `∫⁻ e^{-U} < ∞` (`π` a probability density), `ε > 0`, `1 ≤ L` (TFA-1). -/
theorem T02_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : T02_L02Consumed gU eps L) (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- S1 (TEX:879, "Lemmas lem:xelower and lem:xlower below establish that in this case
`‖x_{Lε}‖ ≥ 2^L‖x_0‖`"): for each `δ < 1`, large `‖x_0‖` and `‖p_0‖ ≤ ‖x_0‖^δ`.  This is part (a) of the
consumed clause (L01 + L02).  Uses `hL02`. -/
theorem T02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (hL02 : T02_L02Consumed gU eps L)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  sorry

/-- S2 (TEX:879, "Lemma lem:arate_0 shows that this will result in `α(x_0,x_{Lε})` tending to zero as
`‖x_0‖ → ∞` provided `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ<1`"): Lemma 5.17 (L03) applied with a fixed `δ < 1`.
Uses `hL02`, (17), (18), (19), L03 main theorem. -/
theorem T02_S2 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : T02_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L)
    (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  sorry

/-- S3 (TEX:879, implicit translation of the limit in S2): uniform form.  For every `κ > 0` there is `R`
with `α(x_0,x_{Lε}) ≤ κ` whenever `‖x_0‖ > R` and `‖p_0‖ ≤ ‖x_0‖^δ`.  Uses S2. -/
theorem T02_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (h : Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → accProb U gU eps L x0 p0 ≤ κ := by
  sorry

/-- S4 (TEX:274-279 eqn:mhtype, used implicitly when "allowing Proposition prop:supr to be envoked",
TEX:879): the HMC kernel is of Metropolis-Hastings type, `P(x,A) = ∫ α 1_A(x_{Lε}) dμ^G + r(x) 1_A(x)`
with `r(x) = 1 - ∫ α dμ^G` (`rejProb`).  Derivable from the definitions of `hmcStep`, `rejProb` (and
`GaussFacts` (a)); no external input beyond `hE6`.  Not printed in the source. -/
theorem T02_S4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (x : E d) (A : Set (E d)) (hA : MeasurableSet A) :
    (hmcStep U gU eps L x A).toReal =
      (∫ p : E d, accProb U gU eps L x p * A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L)
          ∂(gaussMeas d)) +
        rejProb U gU eps L x * A.indicator (fun _ => (1 : ℝ)) x := by
  sorry

/-- S5 (TEX:879, "To conclude we simply note that `P(‖p_0‖ ≤ ‖x_0‖^δ) → 1` as `‖x_0‖ → ∞`"): the
Gaussian tail fact (E6), here as a consequence of `GaussFacts`.  Uses `hE6`. -/
theorem T02_S5 (hE6 : GaussFacts) (d : ℕ) (δ : ℝ) (hδ : 0 < δ) :
    Tendsto (fun R : ℝ => (gaussMeas d) {p : E d | ‖p‖ ≤ R ^ δ}) atTop (𝓝 1) := by
  sorry

/-- S6 (TEX:879, X1 part 1): `r(x) → 1` as `‖x‖ → ∞`: since `r(x) = 1 - E[α] ≥ 1 - κ - P(‖p_0‖ > ‖x‖^δ)`
(`α ≤ κ` on `‖p_0‖ ≤ ‖x‖^δ` by S3, `α ≤ 1` elsewhere).  Not printed explicitly (INVENTORY X1).
Uses S3, S5, `GaussFacts`. -/
theorem T02_S6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (hgrad : IsGradField U gU) (δ : ℝ) (hδ0 : 0 < δ) (hδ : δ < 1)
    (h : Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x := by
  sorry

/-- S7 (TEX:879 "allowing Proposition prop:supr", X1 part 2): `esssup r(x) = 1` w.r.t. `π`.  Needs `r ≤ 1`,
S6, and that `π{‖x‖ > R} > 0` for every `R` (positive density, `d ≥ 1`, finite normaliser).  Not printed
in the source. -/
theorem T02_S7 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hd : 0 < d)
    (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h6 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x)
    (hle : ∀ x : E d, rejProb U gU eps L x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 := by
  sorry

/-- S7' (the bound `r(x) ≤ 1` used in S7: `∫ α dμ^G ≥ 0`, as `α ≥ 0`; needs the integral to be taken
of a nonnegative function). -/
theorem T02_S7' {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    rejProb U gU eps L x ≤ 1 := by
  sorry

/-- S8 (TEX:879, "allowing Proposition prop:supr to be envoked ... establishing the result"):
`esssup r = 1` and `hE1` give failure of geometric ergodicity.  Uses `hE1`, S7. -/
theorem T02_S8 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE1 : Prop35)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps) (hL : 1 ≤ L)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1) :
    ¬ GeomErgodic U gU eps L := by
  sorry

end Paper.T02

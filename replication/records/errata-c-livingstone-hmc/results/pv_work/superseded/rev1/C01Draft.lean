import C01Stmt

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02
open Paper.T01

namespace Paper.C01

/-- Main theorem, Corollary 2.3 part (ii) (TEX:229-239, proof TEX:804-836): for `E(β,α)`, if `β<1` or
`β>2` then HMC does not produce a geometrically ergodic chain.  Part (i) not encoded.  Standing
conventions as T01 (`IsGradField`, `π` integrable, `ε>0`, `L≥1`), deterministic `L`.  `hT01` is the
consumed clause of T01 (provenance (p)).  Proof plan: assemble S1a-S1c (β<1) and S2-S6 (β>2). -/
theorem C01_main {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    C01Concl β U gU eps L := by
  sorry

/-- S1a (TEX:806-810, 806 "direct consequence of part (ii) of Theorem thm:negative"): for `β<1`, the
hypothesis `‖∇U‖ ≤ M'` for ALL `x`.  The source computes `∇U` only for `|x|>M` (807-810); boundedness on
`|x| ≤ M` is not stated (needs `π ∈ C^1`, `π>0`, compactness).  Role: first hypothesis of Thm 2.2(ii).
Uses S2. -/
theorem C01_S1a {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1}
    (hE : InExpFam β α U) (hgrad : IsGradField U gU) (hβ : β < 1) :
    ∃ M : ℝ, ∀ x : E 1, ‖gU x‖ ≤ M := by
  sorry

/-- S1b (TEX:806): for `β<1`, `E_π[e^{s‖x‖}] = ∞` for every `s>0` (second hypothesis of Thm 2.2(ii)).
NOT justified in the source ("direct consequence"; the computation is never written).  Note: for
`β<1` the tail `exp(-α|x|^β)` is heavier than any exponential, so the claim is expected true. -/
theorem C01_S1b {β α : ℝ} {U : E 1 → ℝ}
    (hE : InExpFam β α U) (hβ : β < 1) :
    ∀ s : ℝ, 0 < s →
      (∫⁻ x : E 1, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) = ⊤ := by
  sorry

/-- S1c (TEX:806): `β<1` gives non-geometric ergodicity by Theorem 2.2(ii) (consumed clause).
Uses S1a, S1b, `hT01`. -/
theorem C01_S1c {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (hβ : β < 1) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- S2 (TEX:807-810): "For some `M<∞`, when `|x|>M` we have by assumption `π(x) ∝ exp(-α|x|^β)`, so
`∇U(x) = αβ sgn(x)|x|^{β-1}`."  Role: tail gradient formula used by S3-S5.  Derivation from the class
definition (TEX:223-226) and `gU` the gradient; the source gives no further detail (fair implicit
calculus step; differentiation on the open set `|x|>M`). -/
theorem C01_S2 {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1}
    (hE : InExpFam β α U) (hgrad : IsGradField U gU) :
    ∃ M : ℝ, TailGrad β α M gU := by
  sorry

/-- S3 (TEX:811-816): for `β>2`, `‖∇U(x)‖/‖x‖ = αβ|x|^{β-2} → ∞`, "which is condition (17)"
(`eqn:explode`).  Uses S2. -/
theorem C01_S3 {β α M : ℝ} {gU : E 1 → E 1}
    (hα : 0 < α) (hβ : 2 < β) (hG : TailGrad β α M gU) :
    HypExplode gU := by
  sorry

/-- S4 (TEX:817-824): "Choose `C>3M`.  If `|y| ≥ 3|x| ≥ C`, then both `x` and `y` are in the tail region and
`‖∇U(y)‖/‖∇U(x)‖ = (|y|/|x|)^{β-1} ≥ 3^{β-1} > 3`, so condition (18) holds for every `β>2`."  The (18)
used is the REVISED one (`HypOscillations3`, TEX:900-903).  Uses S2. -/
theorem C01_S4 {β α M : ℝ} {gU : E 1 → E 1}
    (hα : 0 < α) (hβ : 2 < β) (hG : TailGrad β α M gU) :
    HypOscillations3 gU := by
  sorry

/-- S5a (TEX:825-833): for fixed `L ≥ 1`, if `|y| ≥ 2^L|x|` and `|x|` is sufficiently large, then
`U(x)-U(y)-½|x|² ≤ -α(2^{Lβ}-1)|x|^β - ½|x|²`.  (Here `U x - U y = α|x|^β - α|y|^β` in the tail, using
`piDens U = c e^{-α|·|^β}`.) -/
theorem C01_S5a {β α : ℝ} {U : E 1 → ℝ} (hE : InExpFam β α U) (hβ : 2 < β) (L : ℕ) (hL : 1 ≤ L) :
    ∃ R : ℝ, ∀ x y : E 1, R < ‖x‖ → (2 : ℝ) ^ L * ‖x‖ ≤ ‖y‖ →
      U x - U y - (1 / 2) * ‖x‖ ^ 2 ≤
        -α * (((2 : ℝ) ^ L) ^ β - 1) * ‖x‖ ^ β - (1 / 2) * ‖x‖ ^ 2 := by
  sorry

/-- S5b (TEX:832-834): the upper bound of S5a tends to `-∞`, "meaning condition (19) holds for every fixed
`L`". Uses S5a. -/
theorem C01_S5b {β α : ℝ} {U : E 1 → ℝ} (hE : InExpFam β α U) (hβ : 2 < β) (L : ℕ) (hL : 1 ≤ L) :
    HypOscillation2 U L := by
  sorry

/-- S6 (TEX:834): "Theorem thm:light applies conditional on each fixed `L`": (17), (18), (19) for fixed `L`
give non-geometric ergodicity for that `L` (consumed clause, part (i) of T01).  Uses S3, S4, S5b, `hT01`.
(The following clause "dominated convergence with respect to the position-independent distribution
`𝓛(·)` gives the corresponding result under Assumption A1", TEX:834-836, passes from fixed `L` to random
`𝔏` and is NOT encoded: the project has no random-`𝔏` kernel.) -/
theorem C01_S6 {β α : ℝ} {U : E 1 → ℝ} {gU : E 1 → E 1} {eps : ℝ} {L : ℕ}
    (hT01 : C01_T01Consumed) (hE : InExpFam β α U) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E 1, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (hβ : 2 < β) :
    ¬ GeomErgodic U gU eps L := by
  sorry

end Paper.C01

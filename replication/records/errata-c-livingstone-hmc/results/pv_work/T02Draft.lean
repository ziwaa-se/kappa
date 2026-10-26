import T02Stmt

open MeasureTheory Filter Topology
open Paper.Defs

namespace Paper.T02

/-- Main theorem, Theorem 5.14 (`thm:light`, TEX:895-909), revision 1:
"If (17) `lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞` (TEX:897-899), and there is a fixed `C < ∞` such that whenever
`‖y‖ ≥ 3‖x‖ ≥ C` then (18) `‖∇U(y)‖ ≥ 3‖∇U(x)‖` (TEX:900-903), and (19) `lim_{‖x‖→∞, ‖y‖ ≥ 2^L‖x‖}
(U(x) - U(y) - ‖x‖²/2) = -∞` (TEX:905-907), then the Hamiltonian Monte Carlo method with fixed integration
time `T = Lε` does not produce a geometrically ergodic Markov chain for any choice `T > 0`" (TEX:908).
Encoding: for every `ε > 0` and `L ≥ 1` (so `T = Lε > 0` arbitrary, `L` the same in (19), see notes N3)
the kernel `hmcStep U gU eps L` is not geometrically ergodic (`GeomErgodic`, eqn:geoerg).
(18) is `Paper.L03.HypOscillations3` (revised form; the frozen `Paper.Defs.HypOscillations` is stale).
Parameters: `hL03` consumed clause of L03 (provenance (p), `T02_L03Consumed`, used at TEX:911-915);
`hE1` Prop. 3.5 (provenance (ii)); `hE6` Gaussian facts (provenance (v)).
Standing conventions made explicit (candidate TFAs, see notes): `0 < d`, `IsGradField U gU`, `∫⁻ e^{-U} < ∞`,
`ε > 0`, `1 ≤ L`. -/
theorem T02_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL03 : T02_L03Consumed U gU eps L) (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- S1 (TEX:911-916, "Fix any `δ<1`.  From Lemma lem:arate_0, `sup_{‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) → 0` as
`‖x_0‖ → ∞`"): uniform (sup) form of L03's limit: for each `κ > 0` there is `R` such that `α ≤ κ` whenever
`‖x_0‖ > R`, `‖p_0‖ ≤ ‖x_0‖^δ`.  The source takes any `δ<1`; `δ` is taken in `(0,1)` since S2 needs `δ>0`
(the proof uses one fixed `δ`).  Uses `hL03` (L03 consumed). -/
theorem T02_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL03 : T02_L03Consumed U gU eps L) (δ : ℝ) (hδ : δ < 1) (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → accProb U gU eps L x0 p0 ≤ κ := by
  sorry

/-- S2 (TEX:917-921, "Moreover `μ_G({p_0 : ‖p_0‖ > ‖x_0‖^δ}) → 0`"): the Gaussian tail fact, as
`‖x_0‖ → ∞`.  Uses `GaussFacts` (provenance (v)); `0 < δ`. -/
theorem T02_S2 {d : ℕ} (hE6 : GaussFacts) (δ : ℝ) (hδ : 0 < δ) :
    Tendsto (fun x : E d => (gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖})
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  sorry

/-- S3 (TEX:922-925, "writing `r(x_0) = 1 - ∫ α(x_0,y) Q(x_0,dy)` ... `1 - r(x_0) = ∫ α(x_0,x_{Lε}) μ_G(dp_0)`"):
the change of variables `y = x_{Lε}(x_0,p_0)`, `Q(x_0,·)` = law of `x_{Lε}` under `μ_G`.  In the Lean
encoding `rejProb` is defined directly through `∫ α(x_0,x_{Lε}) dμ_G`, so this is `rfl`-level; recorded as
a step because the source displays it. -/
theorem T02_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    1 - rejProb U gU eps L x = ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) := by
  sorry

/-- S4 (TEX:926-931, the inequality in the display): `∫ α dμ_G ≤ sup_{‖p_0‖≤‖x_0‖^δ} α + μ_G(‖p_0‖>‖x_0‖^δ)`
(uses `α ≤ 1`, `α ≥ 0`, `μ_G` probability).  Here `κ` stands for the sup (any bound on the region).
Uses `GaussFacts` (a) only (probability measure). -/
theorem T02_S4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (x : E d) (δ κ : ℝ)
    (h : ∀ p : E d, ‖p‖ ≤ ‖x‖ ^ δ → accProb U gU eps L x p ≤ κ) :
    ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ≤
      κ + ((gaussMeas d) {p : E d | ‖x‖ ^ δ < ‖p‖}).toReal := by
  sorry

/-- S5 (TEX:932, "This implies that the rejection probability `r(x_0) → 1` as `‖x_0‖ → ∞`"): assembled
from S1-S4 and S2: for every `κ > 0` there is `R` with `1 - κ ≤ r(x)` for `‖x‖ > R`.  Uses S1-S4. -/
theorem T02_S5 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE6 : GaussFacts)
    (δ : ℝ) (hδ0 : 0 < δ) (hδ : δ < 1)
    (hS1 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x0 p0 : E d, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      accProb U gU eps L x0 p0 ≤ κ)
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x := by
  sorry

/-- S6 (not printed; implicit in "Proposition prop:supr then implies", TEX:932): the HMC kernel is of
Metropolis-Hastings type `P(x,A) = ∫ α 1_A(x_{Lε}) dμ_G + r(x) 1_A(x)` (eqn:mhtype, TEX:274-279) with `r`
the rejection probability `rejProb`.  Derivable from the definitions of `hmcStep`, `rejProb`
(and `GaussFacts` (a)).  Needed so that Prop. 3.5 applies. -/
theorem T02_S6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (x : E d) (A : Set (E d)) (hA : MeasurableSet A) :
    (hmcStep U gU eps L x A).toReal =
      (∫ p : E d, accProb U gU eps L x p * A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L)
          ∂(gaussMeas d)) +
        rejProb U gU eps L x * A.indicator (fun _ => (1 : ℝ)) x := by
  sorry

/-- S7 (not printed; the step from `r(x_0) → 1` to the hypothesis `esssup r = 1` of Prop. 3.5, TEX:932):
`r ≤ 1` (as `α ≥ 0`). -/
theorem T02_S7 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x : E d) :
    rejProb U gU eps L x ≤ 1 := by
  sorry

/-- S8 (not printed): `r(x) → 1` as `‖x‖ → ∞` (S5) gives `esssup_π r = 1`: needs `r ≤ 1` (S7) and
`π{‖x‖ > R} > 0` for each `R` (positive density `e^{-U} > 0`, `d ≥ 1`, finite normaliser). -/
theorem T02_S8 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hd : 0 < d)
    (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h5 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProb U gU eps L x)
    (hle : ∀ x : E d, rejProb U gU eps L x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1 := by
  sorry

/-- S9 (TEX:932, "and Proposition prop:supr then implies that the chain is not geometrically ergodic"):
`esssup r = 1` and Prop. 3.5 (`hE1`) give failure of geometric ergodicity. -/
theorem T02_S9 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE1 : Prop35)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps) (hL : 1 ≤ L)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProb U gU eps L x)) (targetMeas U) = 1) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-! ### Random number of leapfrog steps, TEX:934-940 (proof paragraph; the printed theorem is for fixed `L`) -/

/-- Secondary claim (proof paragraph TEX:934-940): "When the number of leapfrog steps is drawn from a
position-independent distribution `𝓛(·)` as in Assumption A1, the same conclusion follows provided the above
argument is applied conditional on each fixed `L`."  Conclusion: the random-`L` chain is not geometrically
ergodic.  Hypotheses: (17), (18), and (19) / L03-clause for each `L` charged by `𝓛` (the source states (19)
for one `L`; see notes N3/suspected issue: reading for each `L` in the support).  Uses all S-steps and SR1-SR6. -/
theorem T02_main_randL {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hL03 : ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → T02_L03Consumed U gU eps l)
    (hE1 : Prop35Rand) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hA1 : A1Law gU eps Lmeas)
    (hexp : HypExplode gU) (hosc : Paper.L03.HypOscillations3 gU)
    (hosc2 : ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → HypOscillation2 U l) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  sorry

/-- SR1 (TEX:936-938, "applied conditional on each fixed `L`. For each fixed `L` the conditional acceptance
probability tends to zero"): `∫ α(x,·) dμ_G → 0` as `‖x‖ → ∞` for the fixed `L = l`.  Same argument as S1-S5
(`1 - r_l(x) → 0`).  Uses `hL03` for `l`, S1, S2, S4, `GaussFacts`. -/
theorem T02_SR1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (l : ℕ) (hE6 : GaussFacts)
    (hL03 : T02_L03Consumed U gU eps l) :
    Tendsto (fun x : E d => ∫ p : E d, accProb U gU eps l x p ∂(gaussMeas d))
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  sorry

/-- SR2 (TEX:938-940, "it is bounded by one. Since the law of `L` does not depend on `x_0`, dominated
convergence with respect to `𝓛(·)` shows that the unconditional acceptance probability also tends to
zero"): generic dominated convergence on `ℕ` for `f_l(x) ∈ [0,1]` with `f_l → 0` for each `l` charged by
`𝓛` (a probability law, A1). -/
theorem T02_SR2 {d : ℕ} (Lmeas : Measure ℕ) (hP : IsProbabilityMeasure Lmeas) (f : ℕ → E d → ℝ)
    (h0 : ∀ l x, 0 ≤ f l x) (h1 : ∀ l x, f l x ≤ 1)
    (hlim : ∀ l : ℕ, Lmeas {l} ≠ 0 →
      Tendsto (f l) (comap (fun x : E d => ‖x‖) atTop) (𝓝 0)) :
    Tendsto (fun x : E d => ∫ l : ℕ, f l x ∂Lmeas) (comap (fun x : E d => ‖x‖) atTop) (𝓝 0) := by
  sorry

/-- SR3 (not printed): hence `r(x) = rejProbRand → 1` as `‖x‖ → ∞` (definition of `rejProbRand`; uses SR1,
SR2 with `f l x = ∫ α dμ_G`, `0 ≤ f ≤ 1` from `α ∈ [0,1]` and `GaussFacts` (a)). -/
theorem T02_SR3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE6 : GaussFacts) (hA1 : A1Law gU eps Lmeas)
    (hlim : Tendsto (fun x : E d => ∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p ∂(gaussMeas d) ∂Lmeas)
      (comap (fun x : E d => ‖x‖) atTop) (𝓝 0))
    (κ : ℝ) (hκ : 0 < κ) :
    ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProbRand U gU eps Lmeas x := by
  sorry

/-- SR4 (not printed, analogue of S6): the random-`L` kernel is of MH type with rejection `rejProbRand`. -/
theorem T02_SR4 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE6 : GaussFacts) (hgrad : IsGradField U gU) (hA1 : A1Law gU eps Lmeas) (x : E d)
    (A : Set (E d)) (hA : MeasurableSet A) :
    (hmcStepRand U gU eps Lmeas x A).toReal =
      (∫ L : ℕ, ∫ p : E d, accProb U gU eps L x p *
          A.indicator (fun _ => (1 : ℝ)) (xLF gU eps x p L) ∂(gaussMeas d) ∂Lmeas) +
        rejProbRand U gU eps Lmeas x * A.indicator (fun _ => (1 : ℝ)) x := by
  sorry

/-- SR5 (not printed, analogue of S7/S8): `rejProbRand ≤ 1` and `r → 1` give `esssup_π rejProbRand = 1`. -/
theorem T02_SR5 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hd : 0 < d) (hgrad : IsGradField U gU) (hA1 : A1Law gU eps Lmeas)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (h3 : ∀ κ : ℝ, 0 < κ → ∃ R : ℝ, ∀ x : E d, R < ‖x‖ → 1 - κ ≤ rejProbRand U gU eps Lmeas x)
    (hle : ∀ x : E d, rejProbRand U gU eps Lmeas x ≤ 1) :
    essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1 := by
  sorry

/-- SR5' : `rejProbRand ≤ 1` (acceptance probabilities are `≥ 0`). -/
theorem T02_SR5' {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hA1 : A1Law gU eps Lmeas) (x : E d) :
    rejProbRand U gU eps Lmeas x ≤ 1 := by
  sorry

/-- SR6 (TEX:936, "the same conclusion follows"): Prop. 3.5 for the random-`L` kernel (`hE1 : Prop35Rand`)
and `esssup r = 1` give `¬ GeomErgodicRand`. -/
theorem T02_SR6 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE1 : Prop35Rand) (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤) (heps : 0 < eps)
    (hA1 : A1Law gU eps Lmeas)
    (hess : essSup (fun x : E d => ENNReal.ofReal (rejProbRand U gU eps Lmeas x)) (targetMeas U) = 1) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  sorry

end Paper.T02

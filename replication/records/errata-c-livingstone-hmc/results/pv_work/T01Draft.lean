import T01Stmt

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- Main theorem, Theorem 2.2 (TEX:208-219, label thm:negative): if (i) or (ii) holds then HMC does not
produce a geometrically ergodic chain.  Clauses are separated in `T01Concl`.  The statement does not
quantify `ε, L`; read as "for every `ε>0`, `L ≥ 1`" (as T02, "for any choice T>0"), with the same `L`
in (19) (candidate TFA, see notes).  (18) is the revised `‖y‖ ≥ 3‖x‖ ≥ C` form (TEX:900-903), inside
`HypPartI`.  Parameters: `hT02` consumed clause of T02 (provenance (p), part (i) = Thm 5.14, as an
implication on `HypPartI`, so part (ii) is not made vacuous), `hE3` Theorem 5.18 (provenance (ii)).
Standing conventions: `0<d`, `IsGradField`, `π` a probability density, `ε>0`, `1 ≤ L`.
Covers 𝔏 = δ_L only (X2). -/
theorem T01_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hT02 : T01_T02Consumed U gU eps L) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    T01Concl U gU eps L := by
  sorry

/-- S1 (TEX:213, part (i)): part (i) is exactly Theorem 5.14 (TEX:895-909, proof 911-941, T02): (17),
(18), (19) give no geometric ergodicity.  The identification is not printed in the source (INVENTORY X3).
Uses `hT02` (consumed clause of T02). -/
theorem T01_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hT02 : T01_T02Consumed U gU eps L)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartI U gU L) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- S2 (TEX:217 vs 1104, implicit): the bound `‖∇U‖ ≤ M` of Thm 2.2(ii) gives `‖∇U‖ < M+1`, the form
required by Theorem 5.18 (`<M`).  Not printed in the source (fair implicit step). -/
theorem T01_S2 {d : ℕ} (gU : E d → E d) (h : ∃ M : ℝ, ∀ x : E d, ‖gU x‖ ≤ M) :
    ∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M := by
  sorry

/-- S3 (TEX:217 with TEX:1103-1109): part (ii) is the contrapositive of Theorem 5.18 (external input
`Thm518`): a geometrically ergodic chain would force `∫ e^{s‖x‖} dπ < ∞` for some `s>0`,
contradicting `E_π[e^{s‖x‖}] = ∞` for all `s>0`.  Identification not printed (X3).  Uses `hE3`, S2. -/
theorem T01_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartII U gU) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- Main theorem, Theorem 2.2 (TEX:208-219) for HMC with `L ~ 𝔏` (Algorithm 1, TEX:342-343), amendment R1.
No `A1Law` binder (Thm 2.2 does not assume A1; TFA rejected by the gate).  NOTE: part (i) for laws 𝔏
that do not satisfy A1 has no justification in the source (the supporting argument TEX:934-940 is "as in
Assumption A1"): the prover stops `partI` there and records it (X2); this must not be rescued by adding
`A1Law` to this theorem.  `hT02R` consumed clause of T02 (`T02_main_randL`, (p)), `hE3R` Thm 5.18 (ii). -/
theorem T01_main_randL {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hT02R : T01Rand_T02Consumed U gU eps Lmeas) (hE3R : Thm518Rand)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hP : IsProbabilityMeasure Lmeas) (h0 : Lmeas {0} = 0) :
    T01ConclRand U gU eps Lmeas := by
  sorry

/-- SR1 (TEX:213 with TEX:934-940): part (i) for random 𝔏 satisfying A1, from the T02 consumed clause.
Identification with Thm 5.14 not printed (X3).  Uses `hT02R`. -/
theorem T01_SR1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hT02R : T01Rand_T02Consumed U gU eps Lmeas)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hA1 : A1Law gU eps Lmeas) (h : HypPartIRand U gU Lmeas) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  sorry

/-- SR3 (TEX:217 with TEX:1103-1109): part (ii) for random 𝔏, contrapositive of `Thm518Rand` with S2
(`T01_S2`).  Identification not printed (X3).  Uses `hE3R`, S2. -/
theorem T01_SR3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE3R : Thm518Rand)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hP : IsProbabilityMeasure Lmeas) (h0 : Lmeas {0} = 0)
    (h : HypPartII U gU) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  sorry

end Paper.T01

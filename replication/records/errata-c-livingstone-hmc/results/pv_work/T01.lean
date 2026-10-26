import T01Stmt

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- S1 (TEX:213, part (i)): part (i) is exactly Theorem 5.14 (TEX:895-909, proof 911-941, T02): (17),
(18), (19) give no geometric ergodicity.  The identification is not printed in the source (INVENTORY X3).
Uses `hT02` (consumed clause of T02). -/
theorem T01_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hT02 : T01_T02Consumed U gU eps L)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartI U gU L) :
    ¬ GeomErgodic U gU eps L := by
  exact hT02 hd hgrad hπ heps hL h

/-- S2 (TEX:217 vs 1104, implicit): the bound `‖∇U‖ ≤ M` of Thm 2.2(ii) gives `‖∇U‖ < M+1`, the form
required by Theorem 5.18 (`<M`).  Not printed in the source (fair implicit step). -/
theorem T01_S2 {d : ℕ} (gU : E d → E d) (h : ∃ M : ℝ, ∀ x : E d, ‖gU x‖ ≤ M) :
    ∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M := by
  obtain ⟨M, hM⟩ := h
  exact ⟨M + 1, fun x => by linarith [hM x]⟩

/-- S3 (TEX:217 with TEX:1103-1109): part (ii) is the contrapositive of Theorem 5.18 (external input
`Thm518`): a geometrically ergodic chain would force `∫ e^{s‖x‖} dπ < ∞` for some `s>0`,
contradicting `E_π[e^{s‖x‖}] = ∞` for all `s>0`.  Identification not printed (X3).  Uses `hE3`, S2. -/
theorem T01_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartII U gU) :
    ¬ GeomErgodic U gU eps L := by
  obtain ⟨hM, hinf⟩ := h
  intro hge
  obtain ⟨s, hs, hfin⟩ := hE3 d U gU eps L hd hgrad hπ heps hL (T01_S2 gU hM) hge
  rw [hinf s hs] at hfin
  exact lt_irrefl _ hfin

/-- Main theorem, Theorem 2.2 (TEX:208-219, label thm:negative).  Part (i) by S1 (TEX:213), part (ii)
by S3 (TEX:217). -/
theorem T01_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hT02 : T01_T02Consumed U gU eps L) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    T01Concl U gU eps L :=
  ⟨fun h => T01_S1 U gU eps L hT02 hd hgrad hπ heps hL h,
   fun h => T01_S3 U gU eps L hE3 hd hgrad hπ heps hL h⟩

/-- SR1 (TEX:213 with TEX:934-940): part (i) for random 𝔏 satisfying A1, from the T02 consumed clause.
Identification with Thm 5.14 not printed (X3).  Uses `hT02R`. -/
theorem T01_SR1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hT02R : T01Rand_T02Consumed U gU eps Lmeas)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hA1 : A1Law gU eps Lmeas) (h : HypPartIRand U gU Lmeas) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  exact hT02R hd hgrad hπ heps hA1 h

/-- SR3 (TEX:217 with TEX:1103-1109): part (ii) for random 𝔏, contrapositive of `Thm518Rand` with S2
(`T01_S2`).  Identification not printed (X3).  Uses `hE3R`, S2. -/
theorem T01_SR3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hE3R : Thm518Rand)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hP : IsProbabilityMeasure Lmeas) (h0 : Lmeas {0} = 0)
    (h : HypPartII U gU) :
    ¬ GeomErgodicRand U gU eps Lmeas := by
  intro hG
  obtain ⟨hM, hinf⟩ := h
  obtain ⟨s, hs, hfin⟩ := hE3R d U gU eps Lmeas hd hgrad hπ heps hP h0 (T01_S2 gU hM) hG
  rw [hinf s hs] at hfin
  exact lt_irrefl _ hfin

-- `T01_main_randL` is intentionally absent here: its `partI` stops (X2, no A1Law premise; see notes),
-- so it lives in `T01ModGaps.lean` as `T01_main_randL_mod_gaps`.

end Paper.T01

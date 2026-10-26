import T01

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- Gap for `T01_main_randL.partI` (stop X2): part (i) of Thm 2.2 for random 𝔏.  The only available
source justification (TEX:934-940, via the consumed clause `T01Rand_T02Consumed`) needs `A1Law`, which
Thm 2.2 does not assume (TEX:209) and which is not a premise of `T01_main_randL`.  This is the full
∀-closure of the `partI` field of `T01_main_randL` over that theorem's binders. -/
def T01_main_randL_partI_Gap : Prop :=
  ∀ {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (_hT02R : T01Rand_T02Consumed U gU eps Lmeas) (_hE3R : Thm518Rand)
    (_hd : 0 < d) (_hgrad : IsGradField U gU)
    (_hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (_heps : 0 < eps) (_hP : IsProbabilityMeasure Lmeas) (_h0 : Lmeas {0} = 0),
    HypPartIRand U gU Lmeas → ¬ GeomErgodicRand U gU eps Lmeas

/-- Main theorem for random 𝔏, modulo the gap for `partI`.  Part (ii) by `T01_SR3`. -/
theorem T01_main_randL_mod_gaps (hGap : T01_main_randL_partI_Gap)
    {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hT02R : T01Rand_T02Consumed U gU eps Lmeas) (hE3R : Thm518Rand)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hP : IsProbabilityMeasure Lmeas) (h0 : Lmeas {0} = 0) :
    T01ConclRand U gU eps Lmeas :=
  ⟨fun h => hGap U gU eps Lmeas hT02R hE3R hd hgrad hπ heps hP h0 h,
   fun h => T01_SR3 U gU eps Lmeas hE3R hd hgrad hπ heps hP h0 h⟩

end Paper.T01

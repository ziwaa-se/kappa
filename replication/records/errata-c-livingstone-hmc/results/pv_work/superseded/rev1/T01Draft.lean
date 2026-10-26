import T01Stmt
import T02

open MeasureTheory Filter Topology
open Paper.Defs
open Paper.T02

namespace Paper.T01

/-- Main theorem, Theorem 2.2 (TEX:208-219, label thm:negative): if (i) or (ii) holds then HMC does not
produce a geometrically ergodic chain.  Clauses are separated in `T01Concl`.  The statement does not
quantify `ε, L`; read as "for every `ε>0`, `L ≥ 1`" (as T02, "for any choice T>0"), with the same `L`
in (19) (candidate TFA, see notes).  Parameters: `hL02` (provenance (p), L02), `hE1` Prop. 3.5,
`hE6` Gaussian facts (these three are those of `T02_main`), `hE3` Theorem 5.18 (provenance (ii)).
ENCODING FIX (final audit F1): `hL02` is only available under the hypotheses (17), (18) of part (i)
(L02 needs them; the clause is false for every bounded gradient), so it is stated as an implication
`HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L`; it is thus only consumed by part (i)
and part (ii) is not made vacuous.  `Prop35` and `GaussFacts` are unconditional true statements about
all `U` / the Gaussian, and are kept as is.
Standing conventions: `0<d`, `IsGradField`, `π` a probability density, `ε>0`, `1 ≤ L`.  Covers 𝔏 = δ_L only (X2). -/
theorem T01_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L)
    (hE1 : Prop35) (hE6 : GaussFacts) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) :
    T01Concl U gU eps L := by
  sorry

/-- S1 (TEX:213, part (i)): part (i) is exactly Theorem 5.14 (TEX:863-877, proved at 879-880, T02):
(17), (18), (19) give no geometric ergodicity.  Uses `T02_main` (with `hL02`, `hE1`, `hE6`). -/
theorem T01_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : T02_L02Consumed gU eps L) (hE1 : Prop35) (hE6 : GaussFacts)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartI U gU L) :
    ¬ GeomErgodic U gU eps L := by
  sorry

/-- S2 (TEX:217 vs 979, implicit): the bound `‖∇U‖ ≤ M` of Thm 2.2(ii) gives `‖∇U‖ < M+1`, the form
required by Theorem 5.18 (`<M`).  Not printed in the source (fair implicit step). -/
theorem T01_S2 {d : ℕ} (gU : E d → E d) (h : ∃ M : ℝ, ∀ x : E d, ‖gU x‖ ≤ M) :
    ∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M := by
  sorry

/-- S3 (TEX:217 with TEX:978-984): part (ii) is the contrapositive of Theorem 5.18 (external input
`Thm518`): a geometrically ergodic chain would force `∫ e^{s‖x‖} dπ < ∞` for some `s>0`,
contradicting `E_π[e^{s‖x‖}] = ∞` for all `s>0`.  Uses `hE3`, S2. -/
theorem T01_S3 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (hE3 : Thm518)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hL : 1 ≤ L) (h : HypPartII U gU) :
    ¬ GeomErgodic U gU eps L := by
  sorry

end Paper.T01

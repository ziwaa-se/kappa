import L03Stmt

open Filter Topology
open Paper.Defs

namespace Paper.L03

/-- Main theorem, Lemma 5.17 (TEX:939-944): "If (17), (18) and (19) hold then for any `δ<1` it holds that
`lim_{‖x_0‖→∞, ‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) = 0`."
Encoding: `δ<1` fixed first (the limit is over the region for that `δ`, N5; `η` of the consumed clause
may depend on `δ`).  The limit is the `Tendsto` along `tailMomFilter d δ` (N3: limit over pairs
`(x_0,p_0)`).  `HypOscillation2 U L` is (19) with the same `L` as the leapfrog length (N3).  `ε>0` and
`L ≥ 1` (`T = Lε > 0`, TEX:876; for `L = 0` we would have `x_{0}=x_0`, `α = 1`, so the statement needs
`L ≥ 1`; candidate TFA-1, see notes).  `∇U` is passed as `gU`; the relation `gU = ∇U` (`IsGradField`) is
not assumed because nothing in the argument uses it (a more general statement).  First argument: consumed
clause of L02 (provenance (p)). -/
theorem L03_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) (hosc2 : HypOscillation2 U L)
    (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  sorry

/-- S1 (TEX:947-950, "Recall that `α = 1 ∧ exp(U(x_0) - U(x_{Lε}) + ½‖p_0‖² - ½‖p_{Lε}‖²)`"):
the acceptance probability of Prop. 4.2 (TEX:366-369) rewritten with `π ∝ e^{-U}`; derivable by unfolding
`accProb`, `piDens` (no external input).  Uses nothing. -/
theorem L03_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d) :
    accProb U gU eps L x0 p0 =
      min 1 (Real.exp (U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2
        - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2)) := by
  sorry

/-- S2 (eqn:mprop2, Prop. 4.2, TEX:371-373, used at TEX:953 first line): for `L ≥ 1`,
`p_{Lε} = p_0 - (ε/2)∇U(x_0) - εΣ_{i=1}^{L-1}∇U(x_{iε}) - (ε/2)∇U(x_{Lε})`.  Derivable by induction from
`leapfrogStep` (Prop. 4.2 is not taken as an external input).  Uses nothing. -/
theorem L03_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (L : ℕ) (hL : 1 ≤ L) :
    pLF gU eps x0 p0 L = p0 - (eps / 2) • gU x0
      - eps • ∑ i ∈ Finset.Ico 1 L, gU (xLF gU eps x0 p0 i)
      - (eps / 2) • gU (xLF gU eps x0 p0 L) := by
  sorry

/-- S3 (TEX:953, first line): triangle inequality on S2,
`‖p_{Lε}‖ ≥ (ε/2)‖∇U(x_{Lε})‖ - εΣ_{i=1}^{L-1}‖∇U(x_{iε})‖ - (ε/2)‖∇U(x_0)‖ - ‖p_0‖`.  Uses S2. -/
theorem L03_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) (L : ℕ)
    (hL : 1 ≤ L) :
    (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
      - eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖
      - (eps / 2) * ‖gU x0‖ - ‖p0‖ ≤ ‖pLF gU eps x0 p0 L‖ := by
  sorry

/-- S4a (TEX:954, "(18) is used for the second line", pointwise form): for `‖x_0‖` large and
`‖p_0‖ ≤ ‖x_0‖^δ`, and `0 ≤ i ≤ L`, `‖∇U(x_{iε})‖ ≤ (1/3)^{L-i} ‖∇U(x_{Lε})‖`.  Obtained by applying (18)
to each consecutive pair `(x_{jε}, x_{(j+1)ε})` (`‖x_{(j+1)ε}‖ ≥ 2‖x_{jε}‖` from the consumed clause (b),
and `2‖x_{jε}‖ ≥ C` since `‖x_{jε}‖ ≥ 2^j‖x_0‖` from (a)) and iterating.  The source does not write
this pointwise bound; its printed form carries `(1/3)^i` against `‖∇U(x_{iε})‖` in the sum (index
reversed, see S4b/notes).  Uses (18), L02. -/
theorem L03_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, i ≤ L →
        ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖ := by
  sorry

/-- S4b (TEX:954, second line): `(ε/2)‖∇U(x_{Lε})‖ - εΣ_{i=1}^{L-1}‖∇U(x_{iε})‖ - (ε/2)‖∇U(x_0)‖ - ‖p_0‖
≥ (ε/2)‖∇U(x_{Lε})‖ - εΣ_{i=1}^{L}(1/3)^i‖∇U(x_{Lε})‖ - ‖p_0‖`, i.e. the sum-of-gradients bound
`εΣ_{i=1}^{L-1}‖∇U(x_{iε})‖ + (ε/2)‖∇U(x_0)‖ ≤ εΣ_{i=1}^{L}(1/3)^i‖∇U(x_{Lε})‖` (the `x_0` term is bounded
by the `i = L` term `(1/3)^L` since `1/2 ≤ 1`).  Uses S4a. -/
theorem L03_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (δ : ℝ) (hδ : δ < 1) (η : ℝ)
    (h4a : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ → ∀ i : ℕ, i ≤ L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖) :
    ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖ + (eps / 2) * ‖gU x0‖ ≤
        eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * ‖gU (xLF gU eps x0 p0 L)‖ := by
  sorry

/-- S5 (TEX:955, equality line, and TEX:957 "bounded below by some fixed constant `γ_L > 0`"): with
`γ_L := 1 - 2Σ_{i=1}^{L}(1/3)^i` one has `γ_L = (1/3)^L > 0`, and
`(ε/2)G - εΣ_{i=1}^{L}(1/3)^i G = (ε/2) γ_L G` for every real `G`.  Pure algebra; uses nothing. -/
theorem L03_S5 (L : ℕ) (eps G : ℝ) :
    0 < 1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i ∧
    (eps / 2) * G - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * G =
      (eps / 2) * (1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i) * G := by
  sorry

/-- S6 (TEX:957-959, squaring): for reals `a, b` with `0 ≤ b ≤ a` (here `a = (εγ_L/2)‖∇U(x_{Lε})‖`,
`b = ‖p_0‖`) and `‖p_{Lε}‖ ≥ a - b`, `‖p_{Lε}‖² ≥ (a-b)²`.  The nonnegativity `b ≤ a` needed for squaring is
not stated in the source (it holds for `‖x_0‖` large, by (17) at `x_{Lε}`; FAIR_IMPLICIT_STEP candidate).
Uses nothing. -/
theorem L03_S6 (a b P : ℝ) (hb : 0 ≤ b) (hba : b ≤ a) (hP : a - b ≤ P) : (a - b) ^ 2 ≤ P ^ 2 := by
  sorry

/-- S7 (TEX:960, expansion): `((εγ_L/2)G - ‖p_0‖)² = (ε²γ_L²/4)G² + ‖p_0‖² - εγ_L G‖p_0‖` (the source writes
`δ_L` for `γ_L` in the last term, a typo; N2).  Pure algebra. -/
theorem L03_S7 (eps γ G b : ℝ) :
    (eps * γ / 2 * G - b) ^ 2 = eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b := by
  sorry

/-- S8 (TEX:962-965): from `P² ≥ (ε²γ²/4)G² + b² - εγ G b` obtain
`b² - P² ≤ εγ G (b - (εγ/4) G)`.  Pure algebra; uses S6, S7. -/
theorem L03_S8 (eps γ G b P : ℝ)
    (h : eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2) :
    b ^ 2 - P ^ 2 ≤ eps * γ * G * (b - eps * γ / 4 * G) := by
  sorry

/-- S9 (TEX:966-969): "for any `M<∞` we can choose an `‖x_0‖` large enough that
`(εγ_L/4)‖∇U(x_{Lε})‖ ≥ M‖x_{Lε}‖ ≥ 2^L‖x_0‖`" (fixed `δ<1`, `‖p_0‖ ≤ ‖x_0‖^δ`).  The first inequality is
(17) at `x_{Lε}` (`‖x_{Lε}‖ → ∞`, from L02(a)).  The second inequality needs `M ≥ 1` (for `M < 1` it can
fail, e.g. `M = 0`); the printed "any `M<∞`" is encoded as `M ≥ 1`, with `γ_L = (1/3)^L` the constant of S5.
Uses (17), L02(a). -/
theorem L03_S9 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1)
    (M : ℝ) (hM : 1 ≤ M) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      M * ‖xLF gU eps x0 p0 L‖ ≤ (eps * (1 / 3 : ℝ) ^ L / 4) * ‖gU (xLF gU eps x0 p0 L)‖ ∧
      (2 : ℝ) ^ L * ‖x0‖ ≤ M * ‖xLF gU eps x0 p0 L‖ := by
  sorry

/-- S10 (TEX:969-970, "then it follows that `‖p_0‖² - ‖p_{Lε}‖² ≤ -‖x_0‖²`"): for `‖x_0‖` large and
`‖p_0‖ ≤ ‖x_0‖^δ`.  Assembles S3-S9 (the source gives no more detail on how `M` is chosen; the argument
needs `M` large, depending on `L`, since `‖p_0‖ ≤ ‖x_0‖^δ` must be dominated by `(εγ_L/4)‖∇U(x_{Lε})‖`).
Uses S3, S4a/b, S5-S9, (17), (18), L02. -/
theorem L03_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (hosc : HypOscillations gU)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2 := by
  sorry

/-- S11 (TEX:970, "simply envoking (19) gives the result", first half): the exponent
`U(x_0) - U(x_{Lε}) + ½‖p_0‖² - ½‖p_{Lε}‖²` tends to `-∞` along `tailMomFilter d δ`.  Uses S10 (so the
exponent is `≤ U(x_0) - U(x_{Lε}) - ½‖x_0‖²`), (19), and L02(a) (so that `(x_0,x_{Lε})` lies in the region
`‖y‖ ≥ 2^L‖x‖` of (19)). -/
theorem L03_S11 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc2 : HypOscillation2 U L) (δ : ℝ) (hδ : δ < 1)
    (η : ℝ)
    (h10 : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2) :
    Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2 - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)
      (tailMomFilter d δ) atBot := by
  sorry

/-- S12 (TEX:970, second half; implicit): if the exponent tends to `-∞` then `1 ∧ exp(·) → 0`, i.e. the
conclusion.  Uses S1, S11. -/
theorem L03_S12 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (h : Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) + (1 / 2) * ‖q.2‖ ^ 2 - (1 / 2) * ‖pLF gU eps q.1 q.2 L‖ ^ 2)
      (tailMomFilter d δ) atBot) :
    Tendsto (fun q : E d × E d => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0) := by
  sorry

end Paper.L03

import L03Stmt

open Filter Topology
open Paper.Defs

namespace Paper.L03

/-- Main theorem, Lemma 5.17 (TEX:1011-1016): "If (17), (18) and (19) hold then for any `δ<1` it holds that
`lim_{‖x_0‖→∞, ‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) = 0`."
Encoding: `δ < 1` fixed (the limit is over the region of that `δ`); `Concl` is the `Tendsto` along
`tailMomFilter d δ`.  `hosc2 : HypOscillation2 U L` is (19) with the same `L` as the leapfrog length.
`hosc` is (18) in the REVISED form (`3‖x‖`).  `ε > 0` (TEX:336) and `L ≥ 1` (candidate TFA-1, see notes).
`gU = ∇U` (`IsGradField`) is not assumed because nothing in the argument uses it.  First argument: the
consumed clause of L02 (provenance (p)). -/
theorem L03_main {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (heps : 0 < eps) (hL : 1 ≤ L)
    (hexp : HypExplode gU) (hosc : HypOscillations3 gU) (hosc2 : HypOscillation2 U L) :
    ∀ δ : ℝ, δ < 1 → Concl U gU eps L δ := by
  sorry

/-- S1 (TEX:1019-1022, "Recall that `α(x_0,x_{Lε}) = 1 ∧ exp(U(x_0) - U(x_{Lε}) + ½‖p_0‖² - ½‖p_{Lε}‖²)`"):
the acceptance probability of Prop. 4.2 rewritten with `π ∝ e^{-U}`; derivable by unfolding `accProb`,
`piDens`.  Uses nothing. -/
theorem L03_S1 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d) :
    accProb U gU eps L x0 p0 =
      min 1 (Real.exp (U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2
        - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2)) := by
  sorry

/-- S2 (eqn:mprop2, Prop. 4.2, TEX:371-373; used at TEX:1030-1036 first line): for `L ≥ 1`,
`p_{Lε} = p_0 - (ε/2)∇U(x_0) - εΣ_{i=1}^{L-1}∇U(x_{iε}) - (ε/2)∇U(x_{Lε})`.  Derivable by induction from
`leapfrogStep` (Prop. 4.2 is not taken as an external input).  Uses nothing. -/
theorem L03_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (L : ℕ) (hL : 1 ≤ L) :
    pLF gU eps x0 p0 L = p0 - (eps / 2) • gU x0
      - eps • ∑ i ∈ Finset.Ico 1 L, gU (xLF gU eps x0 p0 i)
      - (eps / 2) • gU (xLF gU eps x0 p0 L) := by
  sorry

/-- S3 (TEX:1030-1036, first inequality, "the reverse triangle inequality" applied to S2):
`‖p_{Lε}‖ ≥ (ε/2)‖∇U(x_{Lε})‖ - εΣ_{i=1}^{L-1}‖∇U(x_{iε})‖ - (ε/2)‖∇U(x_0)‖ - ‖p_0‖`.  Uses S2. -/
theorem L03_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d) (L : ℕ)
    (hL : 1 ≤ L) :
    (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
      - eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖
      - (eps / 2) * ‖gU x0‖ - ‖p0‖ ≤ ‖pLF gU eps x0 p0 L‖ := by
  sorry

/-- S4a (TEX:1023-1024, "Take `‖x_0‖` sufficiently large that Lemma lem:xlower applies and that
`3‖x_{iε}‖ ≥ C` for `i = 0,…,L-1`"): from the consumed clause of L02 (stepwise bound gives
`‖x_{iε}‖ ≥ ‖x_0‖`) and any fixed `C`, there is `η` such that for `‖x_0‖ > η`, `‖p_0‖ ≤ ‖x_0‖^δ`:
the stepwise bound `3‖x_{iε}‖ ≤ ‖x_{(i+1)ε}‖` (`i < L`) holds and `C ≤ 3‖x_{iε}‖` for `i < L`.
Uses L02 (consumed). -/
theorem L03_S4a {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (δ : ℝ) (hδ : δ < 1) (C : ℝ) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, i < L →
        3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ ∧ C ≤ 3 * ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S4b (TEX:1025-1029, eqn:gradgeometric): "Using (eqn:stepwise) and (18) then gives for
`i ∈ {0,…,L-1}`: `‖∇U(x_{iε})‖ ≤ 3^{-(L-i)}‖∇U(x_{Lε})‖`."  Obtained by applying (18) to each consecutive
pair `(x_{jε}, x_{(j+1)ε})` (hypotheses supplied by S4a's conclusion) and iterating (the induction is not
written in the source).  Here the hypothesis `h` is the pairwise (18)-input (for each `j < L`:
`3‖x_{jε}‖ ≤ ‖x_{(j+1)ε}‖` and `C ≤ 3‖x_{jε}‖`).  Uses (18), S4a. -/
theorem L03_S4b {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) (C : ℝ)
    (hosc : ∀ x y : E d, 3 * ‖x‖ ≤ ‖y‖ → C ≤ 3 * ‖x‖ → 3 * ‖gU x‖ ≤ ‖gU y‖)
    (x0 p0 : E d)
    (h : ∀ i : ℕ, i < L →
      3 * ‖xLF gU eps x0 p0 i‖ ≤ ‖xLF gU eps x0 p0 (i + 1)‖ ∧ C ≤ 3 * ‖xLF gU eps x0 p0 i‖) :
    ∀ i : ℕ, i < L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖ := by
  sorry

/-- S5 (TEX:1030-1040, second inequality): from eqn:gradgeometric,
`(ε/2)G - εΣ_{i=1}^{L-1}‖∇U(x_{iε})‖ - (ε/2)‖∇U(x_0)‖ - ‖p_0‖ ≥ (ε/2)G - εΣ_{i=1}^{L}(1/3)^i G - ‖p_0‖`
with `G = ‖∇U(x_{Lε})‖`.  (The source's `(1/3)^i` pairs with `‖∇U(x_{(L-i)ε})‖`; the `x_0` term `(ε/2)` is
absorbed by the `i = L` term; reindexing is not written in the source.)  Uses S4b. -/
theorem L03_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ) (hL : 1 ≤ L)
    (x0 p0 : E d)
    (h : ∀ i : ℕ, i < L →
      ‖gU (xLF gU eps x0 p0 i)‖ ≤ (1 / 3 : ℝ) ^ (L - i) * ‖gU (xLF gU eps x0 p0 L)‖) :
    (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
        - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * ‖gU (xLF gU eps x0 p0 L)‖ - ‖p0‖ ≤
      (eps / 2) * ‖gU (xLF gU eps x0 p0 L)‖
        - eps * ∑ i ∈ Finset.Ico 1 L, ‖gU (xLF gU eps x0 p0 i)‖
        - (eps / 2) * ‖gU x0‖ - ‖p0‖ := by
  sorry

/-- S6 (TEX:1041-1047, equalities): `(ε/2){1 - 2Σ_{i=1}^{L}(1/3)^i} G = (ε/(2·3^L)) G`, i.e.
`1 - 2Σ_{i=1}^{L}(1/3)^i = 3^{-L}`.  Pure algebra; uses nothing. -/
theorem L03_S6 (L : ℕ) (eps G : ℝ) :
    1 - 2 * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i = (1 / 3 : ℝ) ^ L ∧
    (eps / 2) * G - eps * ∑ i ∈ Finset.Icc 1 L, (1 / 3 : ℝ) ^ i * G =
      eps / (2 * 3 ^ L) * G := by
  sorry

/-- S7 (TEX:1049-1051, "Set `γ_L = 3^{-L}`.  Since (17) holds and `‖x_{Lε}‖ ≥ 3^L‖x_0‖`, for all sufficiently
large `‖x_0‖` the right-hand side above is positive"): with `γ_L = 3^{-L}`,
`(εγ_L/2)‖∇U(x_{Lε})‖ - ‖p_0‖ > 0` for `‖x_0‖ > η`, `‖p_0‖ ≤ ‖x_0‖^δ`.  Uses (17), L02 (consumed). -/
theorem L03_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      0 < eps * (1 / 3 : ℝ) ^ L / 2 * ‖gU (xLF gU eps x0 p0 L)‖ - ‖p0‖ := by
  sorry

/-- S8 (TEX:1052-1065, squaring and expansion): for reals with `0 < a - b` (`a = (εγ_L/2)G`, `b = ‖p_0‖`,
`G = ‖∇U(x_{Lε})‖`, `γ = γ_L`) and `a - b ≤ P` (`P = ‖p_{Lε}‖`):
`P² ≥ (a-b)² = (ε²γ²/4)G² + b² - εγ G b`.  (The source's last term prints `εγ_L ‖∇U‖‖p_0‖`, consistent
with this.)  Uses nothing (S3, S5, S6 supply `a - b ≤ P`). -/
theorem L03_S8 (eps γ G b P : ℝ) (hpos : 0 < eps * γ / 2 * G - b)
    (hP : eps * γ / 2 * G - b ≤ P) :
    eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2 := by
  sorry

/-- S9 (TEX:1066-1075, eqn:kinetic): `‖p_0‖² - ‖p_{Lε}‖² ≤ εγ_L G (‖p_0‖ - (εγ_L/4) G)`.
Pure algebra from S8.  Uses S8. -/
theorem L03_S9 (eps γ G b P : ℝ)
    (h : eps ^ 2 * γ ^ 2 / 4 * G ^ 2 + b ^ 2 - eps * γ * G * b ≤ P ^ 2) :
    b ^ 2 - P ^ 2 ≤ eps * γ * G * (b - eps * γ / 4 * G) := by
  sorry

/-- S10 (TEX:1076-1083): "Again using (17) and `‖x_{Lε}‖ ≥ 3^L‖x_0‖`, uniformly over `‖p_0‖ ≤ ‖x_0‖^δ` we
may take `‖x_0‖` sufficiently large that `(εγ_L/4)‖∇U(x_{Lε})‖ ≥ 2‖x_0‖` and `‖p_0‖ ≤ ‖x_0‖`."
(`‖p_0‖ ≤ ‖x_0‖` uses `‖x_0‖ ≥ 1` and `δ < 1`.)  Uses (17), L02 (consumed). -/
theorem L03_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖x0‖ ≤ eps * (1 / 3 : ℝ) ^ L / 4 * ‖gU (xLF gU eps x0 p0 L)‖ ∧ ‖p0‖ ≤ ‖x0‖ := by
  sorry

/-- S11 (TEX:1084-1085): "The right-hand side of (eqn:kinetic) is then at most `-‖x_0‖²`":
if `2‖x_0‖ ≤ (εγ/4)G`, `‖p_0‖ ≤ ‖x_0‖`, then `εγG(‖p_0‖ - (εγ/4)G) ≤ -‖x_0‖²` (for `ε, γ > 0`; the
source does not note that `G` positive and `‖x_0‖ ≥ 1` or the factor `εγG ≥ 8‖x_0‖` is used: implicit).
Uses S10. -/
theorem L03_S11 (eps γ G b a : ℝ) (heps : 0 < eps) (hγ : 0 < γ)
    (h1 : 2 * a ≤ eps * γ / 4 * G) (h2 : b ≤ a) (ha : 0 ≤ a) :
    eps * γ * G * (b - eps * γ / 4 * G) ≤ -a ^ 2 := by
  sorry

/-- S12 (TEX:1086-1091): the exponent bound
`U(x_0) - U(x_{Lε}) + ½‖p_0‖² - ½‖p_{Lε}‖² ≤ U(x_0) - U(x_{Lε}) - ½‖x_0‖²` whenever
`‖p_0‖² - ‖p_{Lε}‖² ≤ -‖x_0‖²`.  Pure arithmetic.  Uses S11 (via S9). -/
theorem L03_S12 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (x0 p0 : E d)
    (h : ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2) :
    U x0 - U (xLF gU eps x0 p0 L) + (1 / 2) * ‖p0‖ ^ 2 - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2 ≤
      U x0 - U (xLF gU eps x0 p0 L) - (1 / 2) * ‖x0‖ ^ 2 := by
  sorry

/-- S13 (TEX:1092-1093): "Since `‖x_{Lε}‖ ≥ 3^L‖x_0‖ ≥ 2^L‖x_0‖`, the right-hand side tends to `-∞` by (19)":
along `tailMomFilter d δ`, `U(x_0) - U(x_{Lε}) - ½‖x_0‖² → -∞` (the pair `(x_0, x_{Lε})` lies in the
region of (19) by L02, with `3^L ≥ 2^L`).  Uses (19), L02 (consumed). -/
theorem L03_S13 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL02 : L03_L02Consumed gU eps L) (hosc2 : HypOscillation2 U L) (δ : ℝ) (hδ : δ < 1) :
    Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) - (1 / 2) * ‖q.1‖ ^ 2)
      (tailMomFilter d δ) atBot := by
  sorry

/-- S14 (TEX:1093-1095, "This proves `α(x_0,x_{Lε}) → 0` uniformly over `‖p_0‖ ≤ ‖x_0‖^δ`"): assembling
S1, S12, S13 and S9-S11: the exponent is eventually (along `tailMomFilter d δ`) at most the S13 function,
which tends to `-∞`; hence `1 ∧ exp(·) → 0`.  Uses S1, S12, S13 and the eventual bound
`‖p_0‖² - ‖p_{Lε}‖² ≤ -‖x_0‖²` (S3-S11), supplied as hypothesis. -/
theorem L03_S14 {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ) (δ : ℝ)
    (hbound : ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖p0‖ ^ 2 - ‖pLF gU eps x0 p0 L‖ ^ 2 ≤ -‖x0‖ ^ 2)
    (h13 : Tendsto (fun q : E d × E d =>
      U q.1 - U (xLF gU eps q.1 q.2 L) - (1 / 2) * ‖q.1‖ ^ 2)
      (tailMomFilter d δ) atBot) :
    Concl U gU eps L δ := by
  sorry

end Paper.L03

import L02Stmt

open Paper.Defs

namespace Paper.L02

/-- Main theorem, Lemma 5.16 (TEX:899-901), AS PRINTED: "If (17) holds then there exists an `η<∞`
such that for all `‖x_0‖>η` and any `‖p_0‖ ≤ ‖x_0‖^δ` for some `δ<1`, it holds that
`‖x_{Lε}‖ ≥ 2^L‖x_0‖`."  Only (17) is hypothesised, as printed; (18) is NOT assumed here even though
the proof uses it (TEX:930, "Envoking (18)"; INVENTORY X5): see `L02_main_fixedDelta_osc` for the
auxiliary variant and the notes.  `ε>0` explicit (TEX:336).  The first argument is the consumed
clause of L01 (provenance (p)).  Literal uniform-in-`δ` reading (N5), retained as the stronger
reading; NOT verdict-bearing (gate L02). -/
theorem L02_main {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : Concl gU eps L := by
  sorry

/-- Fixed-`δ` reading (N5) of the statement AS PRINTED (hypothesis (17) only): the VERDICT-BEARING
form (gate L02).  Along the source route it stops at S8b (TEX:930 invokes (18), not a hypothesis of
the lemma): record the stop, do not replace the TEX:930 justification. -/
theorem L02_main_fixedDelta {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) : ConclFixedDelta gU eps L := by
  sorry

/-- AUXILIARY, NOT verdict-bearing (gate L02): Lemma 5.16 with hypothesis (18) (`HypOscillations`,
TEX:868-871, a hypothesis of Thm 5.14) added.  `hosc` is NOT a TFA; this records that the printed
proof route (which invokes (18) at TEX:930) establishes the conclusion under (17)+(18).
Assembly: S10 + S11. -/
theorem L02_main_fixedDelta_osc {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (hL01 : L02_L01Consumed gU eps) (heps : 0 < eps)
    (hexp : HypExplode gU) (hosc : HypOscillations gU) : ConclFixedDelta gU eps L := by
  sorry

/-- S1 (TEX:906): `x_{2ε} = x_ε - ε²∇U(x_ε) - (ε²/2)∇U(x_0) + ε p_0`.  Derivable by unfolding
`leapfrogStep` twice (no external input).  Uses nothing. -/
theorem L02_S1 {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    xLF gU eps x0 p0 2 = xLF gU eps x0 p0 1 - eps ^ 2 • gU (xLF gU eps x0 p0 1)
      - (eps ^ 2 / 2) • gU x0 + eps • p0 := by
  sorry

/-- S1' (eqn:mprop, Prop. 4.2, TEX:364), the general-`L` formula, used implicitly for the "entirely
analogous" steps (TEX:934): `x_{Lε} = x_0 - (Lε²/2)∇U(x_0) - ε²Σ_{i=1}^{L-1}(L-i)∇U(x_{iε}) + Lε p_0`.
Derivable by induction from `leapfrogStep` (Prop. 4.2 is not taken as an external input). -/
theorem L02_S1_general {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (L : ℕ) :
    xLF gU eps x0 p0 L = x0 - ((L : ℝ) * eps ^ 2 / 2) • gU x0
      - eps ^ 2 • ∑ i ∈ Finset.Ico 1 L, ((L : ℝ) - i) • gU (xLF gU eps x0 p0 i)
      + ((L : ℝ) * eps) • p0 := by
  sorry

/-- S2 (TEX:909-911): `‖x_{2ε}‖/‖x_ε‖ ≥ (ε²/2)‖∇U(x_ε)‖/‖x_ε‖ - (ε²/2)‖∇U(x_0)‖/‖x_ε‖ - 1
- ε‖p_0‖/‖x_ε‖` (norm of S1, triangle inequality; the printed coefficient `ε²/2` on `∇U(x_ε)` is
weaker than the `ε²` that S1 gives; the printed inequality is true, see notes).  Uses S1. -/
theorem L02_S2 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : xLF gU eps x0 p0 1 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 1‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 1‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 1‖) ≤
      ‖xLF gU eps x0 p0 2‖ / ‖xLF gU eps x0 p0 1‖ := by
  sorry

/-- S3 (TEX:913-916, display (22) `eqn:inter21`): for `δ'>0` (the source's `δ`, N2), and a fixed
`δ<1`, for `‖x_0‖` large and `‖p_0‖ ≤ ‖x_0‖^δ`:
`2‖x_ε‖/(ε²‖∇U(x_0)‖) ≥ (ε²‖∇U(x_0)‖ - 2‖x_0‖ - 2ε‖p_0‖)/(ε²‖∇U(x_0)‖) ≥ 1 - δ'`.
Uses S2-type first-step bound (L01 S2, i.e. the `L=1` case of S1') and (17).  (N6: the numerator
carries the factor 2 consistently, `2‖x_ε‖ ≥ ε²‖∇U‖ - 2‖x_0‖ - 2ε‖p_0‖`.) -/
theorem L02_S3 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (hexp : HypExplode gU)
    (δ δ' : ℝ) (hδ : δ < 1) (hδ' : 0 < δ') :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (eps ^ 2 * ‖gU x0‖ - 2 * ‖x0‖ - 2 * eps * ‖p0‖) / (eps ^ 2 * ‖gU x0‖) ≤
        2 * ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU x0‖) ∧
      1 - δ' ≤ (eps ^ 2 * ‖gU x0‖ - 2 * ‖x0‖ - 2 * eps * ‖p0‖) / (eps ^ 2 * ‖gU x0‖) := by
  sorry

/-- S4 (TEX:912, "Showing the right-hand side is `≥ 2` amounts to upper bounding the middle term"):
`‖x_{2ε}‖ ≥ 2‖x_ε‖` for `‖x_0‖` large (fixed `δ<1`).  The source does not state this conclusion
explicitly and does not explain why the first term `(ε²/2)‖∇U(x_ε)‖/‖x_ε‖` is large (needs (17) at
`x_ε` with `‖x_ε‖→∞`, i.e. L01; silent use, X5).  Uses S2, S3, (17), L01. -/
theorem L02_S4 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖xLF gU eps x0 p0 1‖ ≤ ‖xLF gU eps x0 p0 2‖ := by
  sorry

/-- S5 (TEX:919-921): `‖x_{3ε}‖/‖x_{2ε}‖ ≥ (ε²/2)‖∇U(x_{2ε})‖/‖x_{2ε}‖ - (ε²/2)‖∇U(x_0)‖/‖x_{2ε}‖
- ε²‖∇U(x_ε)‖/‖x_{2ε}‖ - 1 - ε‖p_0‖/‖x_{2ε}‖` (norm of the `i=3` case of S1', triangle inequality;
printed coefficient `ε²/2` on `∇U(x_{2ε})` is weaker than the `ε²` of S1').  Uses S1'. -/
theorem L02_S5 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hx : xLF gU eps x0 p0 2 ≠ 0) :
    (eps ^ 2 / 2) * (‖gU (xLF gU eps x0 p0 2)‖ / ‖xLF gU eps x0 p0 2‖)
      - (eps ^ 2 / 2) * (‖gU x0‖ / ‖xLF gU eps x0 p0 2‖)
      - eps ^ 2 * (‖gU (xLF gU eps x0 p0 1)‖ / ‖xLF gU eps x0 p0 2‖) - 1
      - eps * (‖p0‖ / ‖xLF gU eps x0 p0 2‖) ≤
      ‖xLF gU eps x0 p0 3‖ / ‖xLF gU eps x0 p0 2‖ := by
  sorry

/-- S6 (TEX:922-925): `(2/ε²)‖x_{2ε}‖/‖∇U(x_0)‖ ≥ (2/ε²)‖x_ε‖/‖∇U(x_0)‖ ≥ 1 - δ'`, for `‖x_0‖`
large and `‖p_0‖ ≤ ‖x_0‖^δ`.  Uses S3 (22) and `‖x_{2ε}‖ ≥ ‖x_ε‖` (S4). -/
theorem L02_S6 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ δ' : ℝ) (hδ : δ < 1) (hδ' : 0 < δ') :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 / eps ^ 2) * (‖xLF gU eps x0 p0 1‖ / ‖gU x0‖) ≤
        (2 / eps ^ 2) * (‖xLF gU eps x0 p0 2‖ / ‖gU x0‖) ∧
      1 - δ' ≤ (2 / eps ^ 2) * (‖xLF gU eps x0 p0 1‖ / ‖gU x0‖) := by
  sorry

/-- S7 (TEX:927-929): `‖x_{2ε}‖/(ε²‖∇U(x_ε)‖) ≥ 1 - ‖x_ε‖/(ε²‖∇U(x_ε)‖) - ‖∇U(x_0)‖/(2‖∇U(x_ε)‖)
- ‖p_0‖/(ε‖∇U(x_ε)‖)` (from S1 and the triangle inequality, `∇U(x_ε) ≠ 0`).  Uses S1. -/
theorem L02_S7 {d : ℕ} (gU : E d → E d) (eps : ℝ) (heps : 0 < eps) (x0 p0 : E d)
    (hg : gU (xLF gU eps x0 p0 1) ≠ 0) :
    1 - ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖gU x0‖ / (2 * ‖gU (xLF gU eps x0 p0 1)‖)
      - ‖p0‖ / (eps * ‖gU (xLF gU eps x0 p0 1)‖) ≤
      ‖xLF gU eps x0 p0 2‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖) := by
  sorry

/-- S8a (TEX:930, first sentence): "The second and last terms on the right hand side can be made
arbitrarily small by choosing `‖x_0‖` large enough": for `ζ>0`, `‖x_ε‖/(ε²‖∇U(x_ε)‖)` and
`‖p_0‖/(ε‖∇U(x_ε)‖)` are `< ζ` for `‖x_0‖` large (fixed `δ<1`).  Uses (17) at `x_ε` with
`‖x_ε‖→∞` (L01). -/
theorem L02_S8a {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (δ ζ : ℝ) (hδ : δ < 1) (hζ : 0 < ζ) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖xLF gU eps x0 p0 1‖ / (eps ^ 2 * ‖gU (xLF gU eps x0 p0 1)‖) < ζ ∧
      ‖p0‖ / (eps * ‖gU (xLF gU eps x0 p0 1)‖) < ζ := by
  sorry

/-- S8b (TEX:930-933): "Envoking (18) gives `‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6`" for `‖x_0‖` large.
USES HYPOTHESIS (18) (`HypOscillations`), which is NOT in the printed statement (X5), together with
`‖x_ε‖ ≥ 2‖x_0‖` and `2‖x_0‖ ≥ C` (L01). -/
theorem L02_S8b {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ‖gU x0‖ / (2 * ‖gU (xLF gU eps x0 p0 1)‖) ≤ 1 / 6 := by
  sorry

/-- S9 (TEX:934, "which therefore shows that `‖x_{3ε}‖ ≥ 2‖x_{2ε}‖`"), for `‖x_0‖` large (fixed
`δ<1`).  Assembles S5, S6, S7, S8a, S8b (also needs that the first term of S5,
`(ε²/2)‖∇U(x_{2ε})‖/‖x_{2ε}‖`, is large: (17) at `x_{2ε}` with `‖x_{2ε}‖→∞` (S4); not spelled out in
the source). -/
theorem L02_S9 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (hosc : HypOscillations gU) (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      2 * ‖xLF gU eps x0 p0 2‖ ≤ ‖xLF gU eps x0 p0 3‖ := by
  sorry

/-- S10 (TEX:934, "An entirely analogous argument can be used to show that
`‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖` for any fixed `i`"): for fixed `L` and every `1 ≤ i ≤ L`, for `‖x_0‖`
large.  The source gives no argument for `i ≥ 4` (the general `S1'` has `i-1` gradient terms): the
induction is left to the reader (X5).  Uses S1', (17), (18), L01.
Required route (gate L02): i=1 from hL01, i=2 = S4, i=3 = S9; for i ≥ 4 the pattern of S5–S9 with
i in place of 3: the one-step identity
x_{iε} = x_{(i-1)ε} + εp_0 - (ε²/2)∇U(x_0) - ε²Σ_{j=1}^{i-1}∇U(x_{jε}) (from S1'), middle terms
bounded by lower-bounding their reciprocals as in S6–S8, (18) applied to consecutive pairs
(x_{(j-1)ε}, x_{jε}), and the first term made large by (17) at x_{(i-1)ε}.  A different route is
not the source route. -/
theorem L02_S10 {d : ℕ} (gU : E d → E d) (eps : ℝ) (hL01 : L02_L01Consumed gU eps)
    (heps : 0 < eps) (hexp : HypExplode gU) (hosc : HypOscillations gU) (L : ℕ)
    (δ : ℝ) (hδ : δ < 1) :
    ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, 1 ≤ i → i ≤ L →
        2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖ := by
  sorry

/-- S11 (TEX:934, "establishing the result"): from S10 by telescoping (`‖x_{Lε}‖ ≥ 2^L‖x_0‖`);
this is the fixed-`δ` conclusion with (18).  Uses S10. -/
theorem L02_S11 {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (δ : ℝ) (hδ : δ < 1) (η : ℝ)
    (h10 : ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖) :
    ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
      (2 : ℝ) ^ L * ‖x0‖ ≤ ‖xLF gU eps x0 p0 L‖ := by
  sorry

end Paper.L02

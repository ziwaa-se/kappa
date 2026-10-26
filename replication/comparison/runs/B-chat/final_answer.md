# Review of "Convex combinations of random variables stochastically dominate the parent…"

**Caveat on the Lean code.** I had no Lean toolchain in this session, so the code below has **not been compiled**. It is written against recent Mathlib, but some lemma names change between versions and may need small fixes. The ones I'm least sure of are flagged in comments.

The Lean code only formalizes the deterministic real-analysis core of each result: inequalities, identities, counterexamples and subadditivity arguments. The measure-theoretic layer is described in prose but not formalized. That layer covers Stieltjes integrals, "≤st with equal finite means ⇒ equal in law", and induction over convex combinations.

Numbering assumes the shared `[theorem][section]` counter, so definitions are counted too. Labels are given to avoid ambiguity.

## Summary

| Result | Statement | Proof |
|---|---|---|
| Lemma 2.3 `lem:ITS-carac` | ✅ (needs F(0)=0 in the "if" direction) | ✅ |
| Prop 2.5 `prop:ITS-dens` | ✅ | ✅ (holds more generally) |
| Thm 2.8 `thm:inclusion` | ❌ as stated; ✅ if h(x)>0 for x>0 | inequality ✅; F(0)=0 not checked |
| **Thm 3.1 `thm:main`** | ✅ | ❌ **final step is invalid** (fixable); also an event-decomposition slip |
| Prop 3.2 `prop:inf-mean` | ✅ (should say i.i.d. copies, X ≥ 0) | ✅ but convoluted; "enough to prove n=2" unjustified |
| Prop 3.3 `prop:mean-fsub` | ✅ | ✅ |
| Prop 4.6 `prop:conv` | ✅ | ✅ (sketchy) |
| **Thm 4.8 `cor:inclusion`** | ❌ **FALSE** | ❌ wrong claim h(0)=0 |
| Lemma 4.10 `lem:inv-NWU` | ✅ | ✅ |
| Thm 4.12 `thm:inv-nwu-fsub` | ✅ | ⚠️ wrong justification ("exp is superadditive") |
| Prop 5.2 `cor:invNWU` | ⚠️ needs F(0)=0 | ⚠️ F vs F⁻ mismatch (harmless, but needs a line) |
| Prop 5.3 `cor:fsub` | ✅ | ⚠️ same F vs F⁻ mismatch |

Examples 4.13 (`ex:strange`) and 4.16 (`ex:non-superCauchy`) are **not distribution functions** as written.

## Major issues

### 1. Theorem 4.8 (`cor:inclusion`) is false

**Claim:** every nonnegative super-Pareto X is InvSub.

**Counterexample:** let X = Z + 1 with Z ~ Pareto(1). This is super-Pareto with h(z) = z + 1, it is nonnegative, and F_X(x) = 1 − 1/(x−1) for x ≥ 2.

Apply Lemma 2.3 with x = 4 and θ = ½:

- F(8) + F(8) = 12/7 ≈ 1.714
- F(4) + 1 = 5/3 ≈ 1.667

So inequality (eq:sub-1x) fails and X is not InvSub. The stochastic dominance still holds for this X, via Theorem 4.2.

**What goes wrong in the proof:** writing X = h(Z) = h̃(Y) with Y = Z − 1 gives h̃(0) = h(1) = ess inf X. That is not 0 in general, so h̃ need not be star-shaped.

The InvSub class is not shift-invariant. For the shifted Pareto Z + a with a > 0, the function 1 − F(1/x) equals x/(1−ax) near 0. This is strictly convex, so it is superadditive near 0.

A second failure mode: h may vanish on an interval, e.g. X = max(Z−2, 0). Then F_X(0) > 0, which also violates Definition 2.2.

**Correct statement:** a super-Pareto X with F_X(0) = 0 and ess inf X = 0 is InvSub. Equivalently, X = h(Y) with h convex, h(0) = 0 and h > 0 on (0, ∞).

Consequently, these claims must be weakened:
- the Introduction's "includes … all the other classes";
- the "relatively mild" framing of the abstract with respect to super-Pareto.

### 2. Theorem 3.1 (`thm:main`): the last inequality goes the wrong way

The theorem is true, but the final step of the proof is not.

Set A = F̄(x/θₙ), B = F̄(x/(1−θₙ)) and c = F̄(x). The paper reaches

  P(S > x) ≥ A + B + c(c − A − B).

It then argues that the parenthesis is ≤ 0 and concludes P(S > x) ≥ A + B. A non-positive term makes the right-hand side **≤** A + B, so this does not follow.

The intermediate claim P(S > x) ≥ A + B is in fact false. For the Fréchet distribution with θ = ½ and x = 0.1, we get A + B = 2(1 − e⁻⁵) > 1.

**Fix (one line):**

  A + B + c(c − A − B) = (A + B)(1 − c) + c² ≥ c(1 − c) + c² = c.

This uses A + B ≥ c, which is the InvSub inequality, together with 1 − c ≥ 0.

**Second slip in the same proof.** The decomposition is written as
P(S > x) = P(Xₙ ≥ x/θₙ) + P(S ≥ x, Xₙ ≤ x/θₙ).

This double-counts {Xₙ = x/θₙ} and replaces > by ≥. The correct form is
P(Xₙ > x/θₙ) + ∫_{[0, x/θₙ]} P(S′ > (x − θₙt)/(1 − θₙ)) dF(t),
where S′ is the normalised combination of the first n−1 copies.

This matters for the atomic Example 2.7. With this decomposition, the rest of the argument goes through unchanged.

The n = 2 step and both Figure-based integral bounds are correct.

### 3. Real-valued InvSub laws are continuous, so the "discrete" claim fails

Let g(x) = F̄_X(1/x). If g is increasing and subadditive, then

  0 ≤ g(x+h) − g(x) ≤ g(h).

If X < ∞ a.s., then g(0+) = P(X = ∞) = 0, so g is continuous. Hence **every real-valued InvSub X has a continuous cdf.**

Example 2.7 only works because it puts mass p at +∞, i.e. it is a defective random variable. Moreover, that same example is also super-heavy-tailed: −log F(1/x) = −⌈x⌉ log(1−p), which is subadditive.

So the Introduction's claim that InvSub "seems the only one including some discrete distributions" is incorrect on both counts.

### 4. Examples 4.13 and 4.16 are not distribution functions

**Example 4.13 (`ex:strange`).** For a ∈ (0,1), a^{−1/x} > 1 and 1 + 1/(e^{2x}−1) > 1, so the stated "cdf" exceeds 1 everywhere. For example, R_{1/2}(1) = 2(1 + 1/(e²−1)).

The intended formula is presumably a^{1/x}·e^{2x}/(e^{2x}−1) (or a > 1). For that version I checked two things:
- **Super-heavy-tailed fails, for every a.** With q = e^{−2x}, the θ = ½ condition reduces to q² + q ≤ 1. This fails for small x.
- **InvSub for a = ½.** Hand spot-checks of r(x) ≤ 1/x at x = 1, 2, 3, 5, 10, 20 and x → ∞ are consistent with it. This is not a proof.

**Example 4.16 (`ex:non-superCauchy`).** V(x) = e^{−1/√x}(1 + e^{2x−1}) → ∞ as x → ∞, and V(1) = e⁻¹ + 1 > 1. The intended V must be restated, and the super-Cauchy claim re-checked.

## Result-by-result notes

**Lemma 2.3.** The algebra is correct for x > 0, with x ↦ 1/x and the split a = θ/x, b = (1−θ)/x. The "if" direction needs the standing hypothesis F_X(0) = 0, since (eq:sub-1x) does not imply it.

**Example 2.4 (Fréchet).** The identity and the convexity of Λ are correct. For convexity, Λ′(x) = (t/(2 sinh(t/2)))² with t = 1/x, which is increasing in x.

**Prop 2.5.** Correct. A cleaner, density-free version: if y ↦ y·F̄(y) is increasing on (0, ∞), then X is InvSub. With a density this is exactly r(y) ≤ 1/y. This version is formalized below.

**Example 2.6.** The b ≤ 0.7 bound looks right. By hand, the minimum of 1 + x^b[(1−b)log(1+x) − x/(1+x)] is about 0.015 near x ≈ 8.

However, "b ≥ 0" includes b = 0. Then Λ₀ = log(1+x), which *is* concave (DOR). So the claim "not concave nor convex", repeated in Example 4.7, needs b ∈ (0,1).

**Example 2.7.** Subadditivity is correct, using ⌈x+y⌉ ≤ ⌈x⌉ + ⌈y⌉ and (1−qᵐ)(1−qⁿ) ≥ 0. See issue 3 for the caveats.

**Theorem 2.8.** The inequality chain is correct. The theorem fails as stated in two ways:
- h(x)/x increasing does not make h increasing or nonnegative. For example, h(x) = −x/(1+x) gives h(X) ≤ 0.
- If h vanishes on [0, a], then F_{h(X)}(0) = F_X(a) > 0. For example, X Fréchet and h(x) = (x−1)⁺ give P(h(X) = 0) = e⁻¹.

Adding "h(x) > 0 for x > 0" fixes both, and it makes h strictly increasing.

**Prop 3.2.** It should say "X₁, …, Xₙ i.i.d. copies of a nonnegative, nondegenerate X". Two further points:
- The Var(√X) step is redundant: equality in law gives E√X = E√Y directly.
- Instead of "enough to prove n = 2", use the strict concavity √(Σθᵢxᵢ) ≥ Σθᵢ√xᵢ directly for general n.

**Prop 3.3.** Correct, since InvSub excludes degenerate laws. A direct proof also exists: subadditivity gives F̄(ny) ≥ F̄(y)/n, so the tail is at least C/t and E X = ∞.

**Prop 4.6.** Correct. The proof should say explicitly that 𝒫⁻¹∘F is concave ⇔ F⁻¹∘𝒫 is convex (inverse of an increasing function).

**Lemma 4.10 and Theorem 4.12.** Both are correct. In 4.12, "the exponential is superadditive" is false: e^{0+0} = 1 < 2. The inequality actually used is uv ≥ u + v − 1 for u, v ≤ 1, i.e. (1−u)(1−v) ≥ 0.

**Props 5.2 and 5.3.** Definition 5.1 uses F₁⁻ (left limit), while the proofs use F_X. The results are still correct: for increasing functions, subadditivity passes to both one-sided-limit versions. For example, g⁺(x+y) = lim g(x+y+2h) ≤ g⁺(x) + g⁺(y). This needs one sentence in the proofs.

Prop 5.2 also needs "F_X(0) = 0", as Prop 5.3 has. Otherwise X ≡ 0 satisfies F ≤_{i-sb} ℋ but is not super-heavy-tailed. Transitivity of ≤_{i-sb}, and ℋ ≤_{i-sb} 𝒫 (via 1 − e^{−x} subadditive), are both fine.

**Minor points:**
- **Introduction, absolute continuity.** The claim "super-Pareto implies absolutely continuous" is false: max(Z−2, 0) has an atom at 0.
- **Introduction, finite-mean dominance.** The "only if exactly one coefficient positive" claim needs X nondegenerate.
- **§4.3, which variable.** "T is not super-heavy-tailed" presumably means |T|. That claim is true: −log F_{|T|}(1/x) has second derivative (2/π)² > 0 at 0, so it is superadditive near 0.
- **Typos.**
  - "more variable that" → "than"
  - "more variable then" → "than"
  - "or course" → "of course"
  - "beween" → "between"
  - "subadditive order" (before Prop 5.3) → "inverted-subadditive order"
  - "≥" where "=" is meant in the third display of the proof of Theorem 3.1

## Lean 4 / Mathlib code (uncompiled)

```lean
import Mathlib

open Real

noncomputable section
namespace InvSub

/-- Subadditivity on (0, ∞). -/
def SubaddPos (g : ℝ → ℝ) : Prop :=
  ∀ x y : ℝ, 0 < x → 0 < y → g (x + y) ≤ g x + g y

/-- The inverted function x ↦ 1 - F(1/x). -/
def inv (F : ℝ → ℝ) (x : ℝ) : ℝ := 1 - F (1 / x)

/-! ### Algebraic helpers -/

lemma aux_sum {x θ : ℝ} : θ / x + (1 - θ) / x = 1 / x := by
  rw [div_add_div_same]; congr 1; ring

lemma aux1 {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    1 / (x + y) / (x / (x + y)) = 1 / x := by
  have h1 : x + y ≠ 0 := (add_pos hx hy).ne'
  have h2 : x ≠ 0 := hx.ne'
  field_simp

lemma aux2 {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    1 - x / (x + y) = y / (x + y) := by
  have h1 : x + y ≠ 0 := (add_pos hx hy).ne'
  field_simp <;> ring

lemma aux3 {x y : ℝ} (hx : 0 < x) (hy : 0 < y) :
    1 / (x + y) / (y / (x + y)) = 1 / y := by
  have h1 : x + y ≠ 0 := (add_pos hx hy).ne'
  have h2 : y ≠ 0 := hy.ne'
  field_simp

/-! ### Lemma 2.3 (lem:ITS-carac) -/

theorem lemma_2_3 (F : ℝ → ℝ) :
    SubaddPos (inv F) ↔
      ∀ x θ : ℝ, 0 < x → 0 < θ → θ < 1 →
        F (x / θ) + F (x / (1 - θ)) ≤ F x + 1 := by
  constructor
  · intro h x θ hx hθ hθ1
    have := h (θ / x) ((1 - θ) / x) (div_pos hθ hx) (div_pos (by linarith) hx)
    simp only [inv] at this
    rw [aux_sum, one_div_one_div, one_div_div, one_div_div] at this
    linarith
  · intro h x y hx hy
    simp only [inv]
    have hs : 0 < x + y := add_pos hx hy
    have := h (1 / (x + y)) (x / (x + y)) (one_div_pos.mpr hs) (div_pos hx hs)
      ((div_lt_one hs).mpr (by linarith))
    rw [aux2 hx hy, aux1 hx hy, aux3 hx hy] at this
    linarith

/-! ### Example 2.4 (Fréchet) -/

theorem frechet_identity (x θ : ℝ) :
    1 + exp (-1 / x) - exp (-θ / x) - exp (-(1 - θ) / x)
      = (1 - exp (-θ / x)) * (1 - exp (-(1 - θ) / x)) := by
  have h : exp (-θ / x) * exp (-(1 - θ) / x) = exp (-1 / x) := by
    rw [← exp_add]; congr 1; ring
  linear_combination (-1 : ℝ) * h

theorem frechet_invsub (x θ : ℝ) (hx : 0 < x) (hθ : 0 ≤ θ) (hθ1 : θ ≤ 1) :
    0 ≤ 1 + exp (-1 / x) - exp (-θ / x) - exp (-(1 - θ) / x) := by
  rw [frechet_identity]
  have a : -θ / x ≤ 0 := by
    have := div_nonneg hθ hx.le; rw [neg_div]; linarith
  have b : -(1 - θ) / x ≤ 0 := by
    have := div_nonneg (by linarith : (0:ℝ) ≤ 1 - θ) hx.le; rw [neg_div]; linarith
  have ha := (exp_le_exp.mpr a).trans_eq exp_zero
  have hb := (exp_le_exp.mpr b).trans_eq exp_zero
  exact mul_nonneg (by linarith) (by linarith)

/-! ### Prop 2.5 (prop:ITS-dens), density-free version -/

theorem subadd_of_antitone_div (g : ℝ → ℝ)
    (h : ∀ x y, 0 < x → x ≤ y → g y / y ≤ g x / x) : SubaddPos g := by
  intro x y hx hy
  have hs : 0 < x + y := add_pos hx hy
  have h1 := mul_le_mul_of_nonneg_left (h x (x + y) hx (by linarith)) hx.le
  have h2 := mul_le_mul_of_nonneg_left (h y (x + y) hy (by linarith)) hy.le
  have hs0 : x + y ≠ 0 := hs.ne'
  have hx0 : x ≠ 0 := hx.ne'
  have hy0 : y ≠ 0 := hy.ne'
  have e : g (x + y) = x * (g (x + y) / (x + y)) + y * (g (x + y) / (x + y)) := by
    field_simp <;> ring
  have ex : x * (g x / x) = g x := by field_simp
  have ey : y * (g y / y) = g y := by field_simp
  rw [ex] at h1; rw [ey] at h2
  linarith

/-- If u ↦ u·F̄(u) is increasing on (0,∞) (⇔ hazard r(u) ≤ 1/u with a density),
then X is InvSub. -/
theorem prop_2_5_general (F : ℝ → ℝ)
    (hmono : ∀ u v, 0 < u → u ≤ v → u * (1 - F u) ≤ v * (1 - F v)) :
    SubaddPos (inv F) := by
  apply subadd_of_antitone_div
  intro x y hx hxy
  have hy : 0 < y := lt_of_lt_of_le hx hxy
  have h := hmono (1 / y) (1 / x) (one_div_pos.mpr hy) (one_div_le_one_div_of_le hx hxy)
  simp only [inv]
  have e1 : (1 - F (1 / y)) / y = 1 / y * (1 - F (1 / y)) := by ring
  have e2 : (1 - F (1 / x)) / x = 1 / x * (1 - F (1 / x)) := by ring
  rw [e1, e2]; exact h

/-! ### Example 2.7: 1 - q^⌈x⌉ is subadditive; the example is also super-heavy-tailed -/

theorem geom_invsub (q : ℝ) (hq0 : 0 < q) (hq1 : q ≤ 1) :
    SubaddPos (fun x => 1 - q ^ ⌈x⌉) := by
  intro x y hx hy
  simp only
  -- lemma names: `zpow_le_zpow_right_of_le_one₀`, `zpow_add₀`, `zpow_pos` (recent Mathlib)
  have h1 : q ^ (⌈x⌉ + ⌈y⌉) ≤ q ^ ⌈x + y⌉ :=
    zpow_le_zpow_right_of_le_one₀ hq0 hq1 (Int.ceil_add_le x y)
  rw [zpow_add₀ hq0.ne'] at h1
  have h3 : q ^ ⌈x⌉ ≤ 1 := by
    simpa using zpow_le_zpow_right_of_le_one₀ hq0 hq1 (Int.ceil_nonneg hx.le)
  have h4 : q ^ ⌈y⌉ ≤ 1 := by
    simpa using zpow_le_zpow_right_of_le_one₀ hq0 hq1 (Int.ceil_nonneg hy.le)
  nlinarith [mul_nonneg (sub_nonneg.mpr h3) (sub_nonneg.mpr h4)]

/-- −log F(1/x) = c·⌈x⌉ with c = −log(1−p) ≥ 0 is subadditive:
the discrete example is super-heavy-tailed too. -/
theorem geom_superheavy (c : ℝ) (hc : 0 ≤ c) :
    SubaddPos (fun x => c * (⌈x⌉ : ℝ)) := by
  intro x y _ _
  have h : ((⌈x + y⌉ : ℤ) : ℝ) ≤ (⌈x⌉ : ℝ) + ⌈y⌉ := by exact_mod_cast Int.ceil_add_le x y
  simp only
  nlinarith [mul_le_mul_of_nonneg_left h hc]

/-! ### Issue 3: subadditive + monotone + g(0+)=0 ⇒ continuous (no atoms) -/

theorem continuity_of_subadd (g : ℝ → ℝ) (hg : SubaddPos g) (hmono : Monotone g)
    (h0 : ∀ ε > 0, ∃ δ > 0, ∀ h, 0 < h → h < δ → g h ≤ ε) (x : ℝ) (hx : 0 < x) :
    ∀ ε > 0, ∃ δ > 0, ∀ y, |y - x| < δ → |g y - g x| ≤ ε := by
  intro ε hε
  obtain ⟨δ, hδ, hδε⟩ := h0 ε hε
  refine ⟨min δ x, lt_min hδ hx, fun y hy => ?_⟩
  rw [abs_sub_lt_iff] at hy
  obtain ⟨hy1, hy2⟩ := hy
  have m1 := min_le_left δ x
  have m2 := min_le_right δ x
  rcases lt_trichotomy y x with hlt | heq | hgt
  · have hyp : 0 < y := by linarith
    have key := hg y (x - y) hyp (by linarith)
    rw [show y + (x - y) = x by ring] at key
    have hs := hδε (x - y) (by linarith) (by linarith)
    have hm := hmono hlt.le
    rw [abs_le]; constructor <;> linarith
  · rw [heq, sub_self, abs_zero]; exact hε.le
  · have key := hg x (y - x) hx (by linarith)
    rw [show x + (y - x) = y by ring] at key
    have hs := hδε (y - x) (by linarith) (by linarith)
    have hm := hmono hgt.le
    rw [abs_le]; constructor <;> linarith

/-! ### Theorem 2.8 (thm:inclusion): the inequality part (k = h⁻¹, anti-star-shaped) -/

theorem thm_2_8_ineq (F k : ℝ → ℝ) (hF : Monotone F)
    (hITS : ∀ u θ : ℝ, 0 < u → 0 < θ → θ < 1 → F (u / θ) + F (u / (1 - θ)) ≤ F u + 1)
    (hkpos : ∀ x, 0 < x → 0 < k x)
    (hk : ∀ x θ : ℝ, 0 < x → 0 < θ → θ ≤ 1 → k (x / θ) ≤ k x / θ) :
    ∀ x θ : ℝ, 0 < x → 0 < θ → θ < 1 →
      F (k (x / θ)) + F (k (x / (1 - θ))) ≤ F (k x) + 1 := by
  intro x θ hx hθ hθ1
  have h1 := hF (hk x θ hx hθ hθ1.le)
  have h2 := hF (hk x (1 - θ) hx (by linarith) (by linarith))
  have := hITS (k x) θ (hkpos x hx) hθ hθ1
  linarith
-- NB: F_{h(X)}(0) = F_X(h⁻¹(0)) > 0 if h vanishes on [0,a]; e.g. Fréchet with h = (x-1)⁺
-- gives P(h(X)=0) = e⁻¹ > 0, so Definition 2.2 fails.

/-! ### Theorem 3.1 (thm:main): algebraic cores -/

/-- n = 2 step (correct in the paper). -/
theorem main_n2 (Fx A B : ℝ) (h0 : 0 ≤ Fx) (hITS : A + B ≤ Fx + 1) :
    Fx * B + Fx * (A - Fx) ≤ Fx := by nlinarith

/-- The paper's last step: the bound is ≤ A + B, not ≥. -/
theorem paper_step_wrong_direction (c A B : ℝ) (hc0 : 0 ≤ c) (hITS : c ≤ A + B) :
    A + B + c * (c - A - B) ≤ A + B := by nlinarith

/-- And the claimed P(S > x) ≥ A + B is false: Fréchet, θ = 1/2, x = 0.1 gives A + B > 1. -/
theorem paper_claim_exceeds_one : 1 < 2 * (1 - exp (-5 : ℝ)) := by
  have h1 : (5 : ℝ) + 1 ≤ exp 5 := add_one_le_exp 5
  have h2 : exp (-5 : ℝ) * exp 5 = 1 := by rw [← exp_add]; norm_num
  have h3 := exp_pos (-5 : ℝ)
  have : exp (-5 : ℝ) < 1 / 2 := by nlinarith
  linarith

/-- Correct replacement for the last step. -/
theorem main_step_corrected (c A B : ℝ) (hc1 : c ≤ 1) (hITS : c ≤ A + B) :
    c ≤ A + B + c * (c - A - B) := by nlinarith

/-! ### Prop 3.2 (prop:inf-mean): strict Jensen for √ -/

theorem sqrt_strict_concave (a b θ : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b)
    (hθ0 : 0 < θ) (hθ1 : θ < 1) (hab : a ≠ b) :
    θ * sqrt a + (1 - θ) * sqrt b < sqrt (θ * a + (1 - θ) * b) := by
  have hsa := sqrt_nonneg a
  have hsb := sqrt_nonneg b
  have hsa2 := sq_sqrt ha
  have hsb2 := sq_sqrt hb
  have hne : sqrt a - sqrt b ≠ 0 := by
    intro h; apply hab; rw [← hsa2, ← hsb2, sub_eq_zero.mp h]
  have hpos : 0 < (sqrt a - sqrt b) ^ 2 :=
    lt_of_le_of_ne (sq_nonneg _) (Ne.symm (pow_ne_zero 2 hne))
  have hL : 0 ≤ θ * sqrt a + (1 - θ) * sqrt b :=
    add_nonneg (mul_nonneg hθ0.le hsa) (mul_nonneg (by linarith) hsb)
  have key0 : (θ * sqrt a + (1 - θ) * sqrt b) ^ 2
      < θ * sqrt a ^ 2 + (1 - θ) * sqrt b ^ 2 := by
    nlinarith [mul_pos (mul_pos hθ0 (sub_pos.mpr hθ1)) hpos]
  rw [hsa2, hsb2] at key0
  calc θ * sqrt a + (1 - θ) * sqrt b
      = sqrt ((θ * sqrt a + (1 - θ) * sqrt b) ^ 2) := (sqrt_sq hL).symm
    _ < sqrt (θ * a + (1 - θ) * b) := sqrt_lt_sqrt (sq_nonneg _) key0

/-! ### Prop 3.3 (prop:mean-fsub), direct route: g(n x) ≤ n g(x), i.e. F̄(n y) ≥ F̄(y)/n -/

theorem subadd_nsmul (g : ℝ → ℝ) (hg : SubaddPos g) (x : ℝ) (hx : 0 < x) :
    ∀ n : ℕ, g (((n + 1 : ℕ) : ℝ) * x) ≤ ((n + 1 : ℕ) : ℝ) * g x := by
  intro n
  induction n with
  | zero => simp
  | succ m ih =>
    have hpos : 0 < ((m + 1 : ℕ) : ℝ) * x := mul_pos (by positivity) hx
    have := hg _ _ hpos hx
    rw [show ((m + 1 + 1 : ℕ) : ℝ) * x = ((m + 1 : ℕ) : ℝ) * x + x by push_cast; ring,
        show ((m + 1 + 1 : ℕ) : ℝ) * g x = ((m + 1 : ℕ) : ℝ) * g x + g x by push_cast; ring]
    linarith

/-! ### Prop 4.6 / 5.2 / 5.3: quantile computations -/

theorem pareto_quantile (p : ℝ) : 1 - 1 / (1 / (1 - p)) = p := by
  rw [one_div_one_div]; ring

theorem frechet_quantile (p : ℝ) (hp0 : 0 < p) (hp1 : p < 1) :
    exp (-1 / (-1 / log p)) = p := by
  have hl : log p ≠ 0 := (log_neg hp0 hp1).ne
  rw [show -1 / (-1 / log p) = log p by field_simp]
  exact exp_log hp0

/-- ℋ ≤_{i-sb} 𝒫 : x ↦ 1 - e^{-x} is subadditive. -/
theorem one_sub_exp_subadd : SubaddPos (fun x => 1 - exp (-x)) := by
  intro x y hx hy
  simp only
  have e : exp (-(x + y)) = exp (-x) * exp (-y) := by rw [← exp_add]; congr 1; ring
  have h1 := (exp_le_exp.mpr (by linarith : -x ≤ 0)).trans_eq exp_zero
  have h2 := (exp_le_exp.mpr (by linarith : -y ≤ 0)).trans_eq exp_zero
  rw [e]
  nlinarith [mul_nonneg (sub_nonneg.mpr h1) (sub_nonneg.mpr h2)]

/-! ### Theorem 4.8 (cor:inclusion) is FALSE: X = Z + 1, Z ~ Pareto(1) -/

def Fshift (x : ℝ) : ℝ := if x < 2 then 0 else 1 - 1 / (x - 1)

theorem shifted_pareto_violates :
    ¬ (Fshift (4 / (1 / 2)) + Fshift (4 / (1 - 1 / 2)) ≤ Fshift 4 + 1) := by
  unfold Fshift; norm_num

theorem shifted_pareto_not_invsub : ¬ SubaddPos (inv Fshift) := by
  intro h
  exact shifted_pareto_violates
    ((lemma_2_3 Fshift).mp h 4 (1 / 2) (by norm_num) (by norm_num) (by norm_num))
-- X = h(Z) with h(z) = z + 1 (increasing, convex): super-Pareto and nonnegative.

/-! ### Lemma 4.10 (lem:inv-NWU) -/

theorem lemma_4_10 (F : ℝ → ℝ) (hF : ∀ t, 0 < t → 0 < F t) :
    SubaddPos (fun x => -log (F (1 / x))) ↔
      ∀ x θ : ℝ, 0 < x → 0 < θ → θ < 1 → F (x / θ) * F (x / (1 - θ)) ≤ F x := by
  constructor
  · intro h x θ hx hθ hθ1
    have := h (θ / x) ((1 - θ) / x) (div_pos hθ hx) (div_pos (by linarith) hx)
    dsimp only at this
    rw [aux_sum, one_div_one_div, one_div_div, one_div_div] at this
    have p1 := hF (x / θ) (div_pos hx hθ)
    have p2 := hF (x / (1 - θ)) (div_pos hx (by linarith))
    have p3 := hF x hx
    rw [← log_le_log_iff (mul_pos p1 p2) p3, log_mul p1.ne' p2.ne']
    linarith
  · intro h x y hx hy
    dsimp only
    have hs : 0 < x + y := add_pos hx hy
    have := h (1 / (x + y)) (x / (x + y)) (one_div_pos.mpr hs) (div_pos hx hs)
      ((div_lt_one hs).mpr (by linarith))
    rw [aux2 hx hy, aux1 hx hy, aux3 hx hy] at this
    have p1 := hF (1 / x) (one_div_pos.mpr hx)
    have p2 := hF (1 / y) (one_div_pos.mpr hy)
    have p3 := hF (1 / (x + y)) (one_div_pos.mpr hs)
    have hl := (log_le_log_iff (mul_pos p1 p2) p3).mpr this
    rw [log_mul p1.ne' p2.ne'] at hl
    linarith

/-! ### Theorem 4.12 (thm:inv-nwu-fsub) -/

theorem mul_ge_add_sub_one (u v : ℝ) (hu : u ≤ 1) (hv : v ≤ 1) : u + v - 1 ≤ u * v := by
  nlinarith [mul_nonneg (sub_nonneg.mpr hu) (sub_nonneg.mpr hv)]

/-- The paper's stated justification is false. -/
theorem exp_not_superadditive : ¬ ∀ a b : ℝ, exp a + exp b ≤ exp (a + b) := by
  intro h; have := h 0 0; norm_num at this

theorem thm_4_12 (F : ℝ → ℝ) (hF0 : ∀ t, 0 < t → 0 < F t) (hF1 : ∀ t, F t ≤ 1)
    (h : SubaddPos (fun x => -log (F (1 / x)))) : SubaddPos (inv F) := by
  intro x y hx hy
  have hxy := h x y hx hy
  dsimp only at hxy
  have p1 := hF0 (1 / x) (one_div_pos.mpr hx)
  have p2 := hF0 (1 / y) (one_div_pos.mpr hy)
  have p3 := hF0 (1 / (x + y)) (one_div_pos.mpr (add_pos hx hy))
  have hlog : log (F (1 / x) * F (1 / y)) ≤ log (F (1 / (x + y))) := by
    rw [log_mul p1.ne' p2.ne']; linarith
  have hprod := (log_le_log_iff (mul_pos p1 p2) p3).mp hlog
  have := mul_ge_add_sub_one _ _ (hF1 (1 / x)) (hF1 (1 / y))
  simp only [inv]; linarith

/-! ### Examples 4.13 and 4.16 are not cdfs -/

theorem R_exceeds_one :
    1 < (1 / 2 : ℝ) ^ (-1 / (1 : ℝ)) * (1 + 1 / (exp (2 * 1 : ℝ) - 1)) := by
  have h1 : (1 / 2 : ℝ) ^ (-1 / (1 : ℝ)) = 2 := by
    rw [show (-1 / (1 : ℝ)) = -1 by norm_num, rpow_neg_one]; norm_num
  have h2 : 0 < exp (2 * 1 : ℝ) - 1 := by
    have := add_one_le_exp (2 * 1 : ℝ); linarith
  rw [h1]
  have := one_div_pos.mpr h2
  linarith

theorem V_exceeds_one : 1 < exp (-1 / sqrt 1) * (1 + exp (2 * 1 - 1)) := by
  rw [sqrt_one, mul_add, mul_one]
  have e : exp (-1 / 1 : ℝ) * exp (2 * 1 - 1) = 1 := by rw [← exp_add]; norm_num
  rw [e]
  linarith [exp_pos (-1 / 1 : ℝ)]

end InvSub
```

**Lemma names most likely to need adjusting:** `zpow_le_zpow_right_of_le_one₀`, `zpow_pos`, `log_le_log_iff`, and the `field_simp` closures in `aux1`–`aux3`. Older Mathlib versions use `zpow_pos_of_pos` and different `field_simp` normal forms.

**Not formalized:**
- the Stieltjes-integral bounds behind Figures 1–2;
- the fact that X ≤st Y with E X = E Y < ∞ implies X =ᵈ Y;
- the anti-star-shapedness of h⁻¹;
- the cited Theorems 4.2, 4.11 and 4.15 and Prop 4.3, which are taken from other papers;
- the numerical claims in Example 2.6 (b ≤ 0.7) and the corrected Example 4.13, which I only checked by hand.

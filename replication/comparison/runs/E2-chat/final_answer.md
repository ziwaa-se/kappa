# Review of "Variance bounds for proportions and sums"

## Summary

| Result | Statement | Proof |
|---|---|---|
| Lemma 2.1 (quarter) | ✅ correct | ✅ correct |
| Lemma 2.2 (positive) | ⚠️ depends on what $I$ means | ✅ if $I=(0,1)$ |
| Prop 2.3 (concave) | ✅ correct | ⚠️ valid, but rests on an unproved claim ("well known") |
| Lemma 2.4 (linear) | ❌ **false** | ❌ non sequitur |
| Prop 2.5 (uniform) | ✅ correct | ✅ correct |
| Prop 2.6 (sum) | ✅ correct | ❌ **uses a false identity** |

I have not compiled the Lean code in this session. It targets recent Mathlib. Lemma names such as `Real.sqrt_le_sqrt` and the `gcongr` side-goal handling may need small adjustments depending on your Mathlib version.

## Detailed findings

**Ambiguity of $I$.** The paper never says whether the "unit interval" is $[0,1]$ or $(0,1)$.
- Lemma 2.2 is **false** for $I=[0,1]$, since $V_n(0)=V_n(1)=0$.
- Lemma 2.2 is true for $I=(0,1)$.
- Proposition 2.3 holds on $[0,1]$.

Fix: define $I=(0,1)$ explicitly, or state Lemma 2.2 on $(0,1)$ and the other results on $[0,1]$.

**Proposition 2.3.** The statement is true. However, "it is well known" carries the whole proof. Here is a short self-contained argument. Write $a=p(1-p)$, $b=q(1-q)$ and $m=\frac{p+q}{2}$. Then
$$m(1-m)=\frac{a+b}{2}+\frac{(p-q)^2}{4}.$$
It follows that
$$\Bigl(\tfrac{\sqrt a+\sqrt b}{2}\Bigr)^2 \le \frac{a+b}{2} \le m(1-m).$$
Dividing by $n$ and taking square roots gives the claim. The Lean proof below follows this argument.

**Lemma 2.4 is false.** Counterexample: $n=1$, $p=\tfrac12$. Then $V_1(\tfrac12)=\tfrac14$, but $\tfrac{p}{4n}=\tfrac18$. In general, $p(1-p)\le p/4$ fails for every $p\in(0,\tfrac34)$. The proof's appeal to Lemma 2.1 doesn't work, because $p(1-p)\le\tfrac14$ says nothing about $p/4$. A correct version is $V_n(p)\le p/n$, which holds since $1-p\le 1$.

**Proposition 2.5.** This is fine. Note that for $p\notin[0,1]$, $V_n(p)$ is negative, and the bound still holds trivially.

**Proposition 2.6.** The statement is true, but the proof's identity $s^2(x+y)=s^2(x)+s^2(y)$ is false because it drops the covariance term. Counterexample: $x=y=(0,1)$ gives $s^2(x)=s^2(y)=\tfrac12$, but $s^2(x+y)=s^2((0,2))=2\neq 1$. A correct proof applies $(u+v)^2\le 2u^2+2v^2$ termwise, using $\overline{x+y}=\bar x+\bar y$:
$$\bigl((x_i-\bar x)+(y_i-\bar y)\bigr)^2 \le 2(x_i-\bar x)^2+2(y_i-\bar y)^2.$$
Summing over $i$ and dividing by $m-1>0$ gives the bound.

## Lean 4 / Mathlib code

```lean
import Mathlib

noncomputable def V (n : ℕ) (p : ℝ) : ℝ := p * (1 - p) / n

/-! Lemma 2.1 -/
lemma quarter_identity (p : ℝ) : p * (1 - p) = 1/4 - (p - 1/2) ^ 2 := by ring

lemma quarter (n : ℕ) (p : ℝ) : V n p ≤ 1 / (4 * n) := by
  have h : p * (1 - p) ≤ 1/4 := by nlinarith [sq_nonneg (p - 1/2)]
  calc V n p = p * (1 - p) / n := rfl
    _ ≤ (1/4) / n := by gcongr
    _ = 1 / (4 * n) := by rw [div_div]

/-! Lemma 2.2: true on the open interval, false on the closed one -/
lemma positive (n : ℕ) (hn : 1 ≤ n) (p : ℝ) (hp : p ∈ Set.Ioo (0:ℝ) 1) : 0 < V n p := by
  obtain ⟨h0, h1⟩ := hp
  have hn' : (0:ℝ) < n := by exact_mod_cast hn
  exact div_pos (mul_pos h0 (by linarith)) hn'

example (n : ℕ) : ¬ (0 < V n 0) := by simp [V]   -- counterexample at p = 0 ∈ [0,1]

/-! Proposition 2.3 -/
lemma V_nonneg (n : ℕ) {p : ℝ} (hp : p ∈ Set.Icc (0:ℝ) 1) : 0 ≤ V n p :=
  div_nonneg (mul_nonneg hp.1 (by linarith [hp.2])) (Nat.cast_nonneg n)

lemma concave_mid (n : ℕ) (p q : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) (hq : q ∈ Set.Icc (0:ℝ) 1) :
    (Real.sqrt (V n p) + Real.sqrt (V n q)) / 2 ≤ Real.sqrt (V n ((p + q) / 2)) := by
  set a := Real.sqrt (V n p)
  set b := Real.sqrt (V n q)
  have ha2 : a ^ 2 = V n p := Real.sq_sqrt (V_nonneg n hp)
  have hb2 : b ^ 2 = V n q := Real.sq_sqrt (V_nonneg n hq)
  have ha0 : 0 ≤ a := Real.sqrt_nonneg _
  have hb0 : 0 ≤ b := Real.sqrt_nonneg _
  have hid : V n ((p + q) / 2) = (V n p + V n q) / 2 + (p - q) ^ 2 / 4 / n := by
    unfold V; ring
  have hextra : 0 ≤ (p - q) ^ 2 / 4 / n := by positivity
  have key : ((a + b) / 2) ^ 2 ≤ V n ((p + q) / 2) := by
    rw [hid, ← ha2, ← hb2]
    nlinarith [sq_nonneg (a - b)]
  calc (a + b) / 2 = Real.sqrt (((a + b) / 2) ^ 2) := (Real.sqrt_sq (by positivity)).symm
    _ ≤ Real.sqrt (V n ((p + q) / 2)) := Real.sqrt_le_sqrt key

/-! Lemma 2.4: false as stated -/
example : ¬ ∀ n : ℕ, 1 ≤ n → ∀ p ∈ Set.Icc (0:ℝ) 1, V n p ≤ p / (4 * n) := by
  intro h
  have := h 1 le_rfl (1/2) ⟨by norm_num, by norm_num⟩
  norm_num [V] at this

-- corrected version
lemma linear_fixed (n : ℕ) (p : ℝ) (hp : p ∈ Set.Icc (0:ℝ) 1) : V n p ≤ p / n := by
  unfold V
  gcongr
  nlinarith [hp.1, hp.2, sq_nonneg p]

/-! Proposition 2.5 -/
theorem uniform : ∃ C : ℝ, ∀ n : ℕ, 1 ≤ n → ∀ p : ℝ, V n p ≤ C / n :=
  ⟨1/4, fun n _ p => by
    unfold V; gcongr; nlinarith [sq_nonneg (p - 1/2)]⟩

/-! Proposition 2.6 -/
noncomputable def mean {m : ℕ} (u : Fin m → ℝ) : ℝ := (∑ i, u i) / m
noncomputable def s2 {m : ℕ} (u : Fin m → ℝ) : ℝ :=
  (∑ i, (u i - mean u) ^ 2) / ((m : ℝ) - 1)

lemma mean_add {m : ℕ} (x y : Fin m → ℝ) : mean (x + y) = mean x + mean y := by
  simp only [mean, Pi.add_apply, Finset.sum_add_distrib, add_div]

theorem sum_bound {m : ℕ} (hm : 2 ≤ m) (x y : Fin m → ℝ) :
    s2 (x + y) ≤ 2 * s2 x + 2 * s2 y := by
  have hm' : (0:ℝ) ≤ (m:ℝ) - 1 := by
    have : (2:ℝ) ≤ m := by exact_mod_cast hm
    linarith
  unfold s2
  rw [mean_add, mul_div_assoc', mul_div_assoc', ← add_div]
  gcongr
  rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum
  intro i _
  simp only [Pi.add_apply]
  nlinarith [sq_nonneg ((x i - mean x) - (y i - mean y))]

-- the identity used in the paper's proof is false
example : ¬ ∀ x y : Fin 2 → ℝ, s2 (x + y) = s2 x + s2 y := by
  intro h
  have := h ![0, 1] ![0, 1]
  norm_num [s2, mean, Fin.sum_univ_two] at this
```

## Errors to fix in the paper

1. **Define $I$ precisely.** Lemma 2.2 needs the open interval $(0,1)$.
2. **Lemma 2.4 is false.** Counterexample: $n=1$, $p=\tfrac12$. Replace it with $V_n(p)\le p/n$, which follows from $1-p\le1$.
3. **Proposition 2.6's proof is wrong.** The equality $s^2(x+y)=s^2(x)+s^2(y)$ ignores the covariance term. Replace it with the termwise bound $(u+v)^2\le 2u^2+2v^2$.
4. **Proposition 2.3 (optional).** Replace "well known" with the short midpoint argument given above.

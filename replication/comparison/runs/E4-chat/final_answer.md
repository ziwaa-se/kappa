# Checking the paper's three results

**Summary:** All three results are stated correctly, and both citations are accurate. Lemma 2.1 has a complete proof, and I give Lean code for it below. Proposition 2.2 and Theorem 2.3 are correct classical results, but their proofs are citations. As far as I know, Mathlib has no Glivenko–Cantelli theorem, no Donsker theorem and no Brownian bridge. For those two I give faithful Lean *statements* with `sorry`, not proofs.

I have not compiled the Lean code in this session. Mathlib lemma names change often, so small fixes may be needed.

---

## Lemma 2.1 (monotonicity and step values): correct, proof correct

The proof is complete. `n F_n(t)` is the size of a subset of `{1,…,n}`, so it lies in `{0,…,n}`. Monotonicity follows because the filter set grows with `t`.

```lean
import Mathlib

open Finset

/-- Empirical distribution function of `x : Fin n → ℝ` (Definition 1.1). -/
noncomputable def empCDF {n : ℕ} (x : Fin n → ℝ) (t : ℝ) : ℝ :=
  ((univ.filter fun i => x i ≤ t).card : ℝ) / n

theorem empCDF_mono {n : ℕ} (x : Fin n → ℝ) : Monotone (empCDF x) := by
  intro s t hst
  have h : (univ.filter fun i => x i ≤ s).card ≤ (univ.filter fun i => x i ≤ t).card := by
    apply card_le_card
    intro i hi
    simp only [mem_filter, mem_univ, true_and] at hi ⊢
    exact hi.trans hst
  unfold empCDF
  gcongr

theorem empCDF_values {n : ℕ} (hn : 0 < n) (x : Fin n → ℝ) (t : ℝ) :
    ∃ k : ℕ, k ≤ n ∧ (n : ℝ) * empCDF x t = k := by
  refine ⟨(univ.filter fun i => x i ≤ t).card, ?_, ?_⟩
  · simpa using card_filter_le univ (fun i => x i ≤ t)
  · have : (n : ℝ) ≠ 0 := by exact_mod_cast hn.ne'
    unfold empCDF
    field_simp
```

---

## Proposition 2.2 (Glivenko–Cantelli): statement correct, proof is only a citation

- **The statement is correct.** It needs only i.i.d. samples and no continuity of `F`, which is right.
- **The "proof" names a theorem but gives no reference.** I suggest citing Glivenko (1933) and Cantelli (1933), or a textbook.
- **Optional rigor point:** `D_n` is a supremum over uncountably many `t`. It is measurable because `F_n` and `F` are right-continuous, so the supremum can be taken over the rationals.

Lean statement (proof omitted):

```lean
open MeasureTheory ProbabilityTheory Filter Topology

theorem glivenko_cantelli {Ω : Type*} [MeasureSpace Ω] [IsProbabilityMeasure (volume : Measure Ω)]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ i, Measurable (X i))
    (hind : iIndepFun X)                      -- older Mathlib: `iIndepFun (fun _ => inferInstance) X volume`
    (hid : ∀ i, IdentDistrib (X i) (X 0)) :
    ∀ᵐ ω, Tendsto (fun n : ℕ =>
        ⨆ t : ℝ, |empCDF (fun i : Fin (n + 1) => X i ω) t - cdf (volume.map (X 0)) t|)
      atTop (𝓝 0) := by
  sorry
```

Two notes on this statement:

- **Supremum:** `⨆` over `ℝ` is only meaningful for bounded families. That holds here, since every term is at most 1.
- **Indexing:** sample size `n + 1` avoids the `n = 0` case.

A full formalization is feasible with Mathlib's strong law of large numbers (`ProbabilityTheory.strong_law_ae`). Apply it to the indicators `1{X_i ≤ t}` and `1{X_i < t}` at finitely many quantile points. Then use monotonicity, which is exactly Lemma 2.1, to control the gaps. This is the standard proof.

---

## Theorem 2.3 (Kolmogorov–Smirnov limit): statement correct, proof sketch has gaps

**The statement is correct:**

- The limit `sup |B|` is right for a Brownian bridge `B`.
- The formula `K(z) = 1 − 2 Σ_{k≥1} (−1)^{k−1} e^{−2k²z²}` for `z > 0` is Kolmogorov's distribution.
- Both bibliography entries are accurate: Donsker, *Ann. Math. Statist.* 23 (1952) 277–281; Kolmogorov, *G. Ist. Ital. Attuari* 4 (1933) 83–91.

**Gaps in the proof sketch** (gaps, not errors):

1. **The reduction to the uniform case is missing, and that is where continuity of `F` is used.** Set `U_i = F(X_i)`, which are i.i.d. Uniform(0,1) when `F` is continuous. Then `F_n(t) = G_n(F(t))` almost surely, where `G_n` is the empirical distribution function of the `U_i`. By the intermediate value theorem, `F(ℝ) ⊇ (0,1)`, so `D_n = sup_u |G_n(u) − u|`. Without continuity the limit law changes, so this step should appear.
2. **Donsker's 1952 argument has a known gap.** The empirical process lives in `D[0,1]`, and `D[0,1]` with the sup norm is non-separable, which causes measurability problems. The rigorous versions use the Skorokhod topology (Billingsley) or outer-measure weak convergence (Dudley 1966). `x ↦ sup|x|` is continuous in the Skorokhod topology as well, so the conclusion stands. A citation to Billingsley's *Convergence of Probability Measures* would make the proof sound.

Lean statement in the elementary form, which avoids the Brownian bridge (proof omitted):

```lean
noncomputable def kolmogorovK (z : ℝ) : ℝ :=
  1 - 2 * ∑' k : ℕ, (-1 : ℝ) ^ k * Real.exp (-2 * ((k : ℝ) + 1) ^ 2 * z ^ 2)

theorem kolmogorov_smirnov {Ω : Type*} [MeasureSpace Ω] [IsProbabilityMeasure (volume : Measure Ω)]
    (X : ℕ → Ω → ℝ) (hmeas : ∀ i, Measurable (X i))
    (hind : iIndepFun X) (hid : ∀ i, IdentDistrib (X i) (X 0))
    (hcont : Continuous (cdf (volume.map (X 0)))) (z : ℝ) (hz : 0 < z) :
    Tendsto (fun n : ℕ => (volume {ω | Real.sqrt (n + 1) *
        ⨆ t : ℝ, |empCDF (fun i : Fin (n + 1) => X i ω) t - cdf (volume.map (X 0)) t| ≤ z}).toReal)
      atTop (𝓝 (kolmogorovK z)) := by
  sorry
```

The index shift `k ↦ k + 1` turns `(−1)^{k−1}` into `(−1)^k`. Convergence in distribution is equivalent to convergence of the distribution functions at every point, because `K` is continuous on `(0,∞)` and the limit puts no mass at `z ≤ 0`. So this statement is equivalent to the paper's.

---

## Errors found

None in the mathematics or the citations. Suggested improvements:

- Give an actual reference for Glivenko–Cantelli.
- State the probability-integral-transform reduction in the proof of Theorem 2.3.
- Cite a rigorous modern source for the weak convergence in `D[0,1]`.

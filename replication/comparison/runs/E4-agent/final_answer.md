I've checked all three numbered results. None of them is false, so no counterexample was needed. Lemma 2.1 and Proposition 2.2 are fully proved in Lean. Theorem 2.3 can't be formalized, because this Mathlib has no Brownian motion, Brownian bridge, Skorokhod space or Donsker theorem; I proved only some side facts about K. Every file compiles with `lake env lean` and contains no `sorry`. `#print axioms` shows only the standard `propext`, `Classical.choice` and `Quot.sound`.

## Lemma 2.1 (F_n is nondecreasing, n·F_n(t) ∈ {0,…,n})
**Statement correct, proof correct.** In `Lemma21.lean`, `lemma_2_1` proves that `edf x` is monotone and that for each t there is a natural number m ≤ n with n·F_n(t) = m. The paper's two-line proof is exactly what the Lean proof does: inclusion of the counted sets for monotonicity, and the count is a subset of {1,…,n}.

## Proposition 2.2 (Glivenko–Cantelli: D_n → 0 a.s.)
**Statement correct, proof fully verified in Lean.** The paper's proof is only "This is the Glivenko–Cantelli theorem", which is acceptable as a citation, but nothing is cited for it (see below). `GC.lean` proves it from scratch, using Mathlib's strong law of large numbers. `glivenko_cantelli` states that almost surely ⨆ₜ |#{i<n : Xᵢ ≤ t}/n − P(X₀ ≤ t)| → 0. It only assumes the Xᵢ are measurable, pairwise independent and identically distributed, which is weaker than the paper's i.i.d. hypothesis.

The proof follows the textbook argument:
1. **Grid of quantile points (`grid`).** For each k there are k−1 points qⱼ = inf{t : F(t) ≥ j/k}. These pin every t between two grid points, up to 1/k. This step uses right-continuity of F and the left limits F(q−).
2. **Strong law at grid points (`slln_set`).** Applying the strong law to the indicators 1{Xᵢ ≤ q} and 1{Xᵢ < q} gives almost-sure convergence at the countably many grid points and their left limits.
3. **Assembly.** The bracketing gives sup over t of |F_n − F| ≤ 1/k + ε/2 for large n.

## Theorem 2.3 (√n·D_n → sup|B|, with the Kolmogorov distribution K)
**Statement correct.** The limit law and the formula K(z) = 1 − 2Σ_{k≥1}(−1)^{k−1}e^{−2k²z²} are the standard ones, and the signs are right: by hand, K(1.358) ≈ 0.950, the familiar 5% critical value.

Checked in `Kolmogorov.lean`:
- the series converges absolutely for z > 0 (`summable_kterm`);
- |K(z) − 1| ≤ 2r/(1−r) with r = e^{−2z²} (`K_close_one`);
- K(z) → 1 as z → ∞ (`K_tendsto_one`).

**The proof sketch is acceptable as a citation proof but has gaps:**
1. **Where continuity of F is used is never said.** It is needed to reduce to the uniform case: with Uᵢ = F(Xᵢ), which is Uniform(0,1) only when F is continuous, D_n becomes sup_u |G_n(u) − u|, where G_n is the empirical distribution function of the Uᵢ. Only after this step does the uniform empirical process converge to a Brownian bridge. Without continuity the conclusion is false: for a Bernoulli X₁ the limit is the sup of |B| over a finite set of points, not over [0,1].
2. **Donsker (1952) has a known gap.** In D[0,1] with the sup norm, the empirical process is not Borel measurable. That gap was later repaired by Skorokhod's topology (as in Billingsley) or by Dudley's outer-measure approach. Calling the supremum "a continuous functional" also needs the topology to be specified. Under the Skorokhod topology it is continuous, and that is enough because B has continuous paths. I suggest citing Billingsley or Dudley alongside Donsker.
3. **K is defined only for z > 0.** It should say K(z) = 0 for z ≤ 0.

## Other remarks on the paper
- The bibliography has no entry for Glivenko–Cantelli (Glivenko 1933, Cantelli 1933), although Proposition 2.2 relies on it.
- D_n is a supremum over uncountably many t, and the paper never notes that it is measurable. It is, since |F_n − F| is right-continuous, so the supremum can be taken over the rationals. "Almost surely" is fine either way.

## Summary of verdicts
| Result | Statement | Proof | Lean |
|---|---|---|---|
| Lemma 2.1 | Correct | Correct | Fully proved |
| Proposition 2.2 | Correct | Correct as a citation, but no reference given | Fully proved, under weaker hypotheses (pairwise independence) |
| Theorem 2.3 | Correct | Sketch is acceptable as a citation, but omits the reduction to uniforms and relies on Donsker 1952, which has a measurability gap | Not formalizable here; only the series facts about K are proved |

Files are in `<folder>/`:
- `Lemma21.lean`
- `Grid.lean`
- `GC.lean`
- `Kolmogorov.lean`

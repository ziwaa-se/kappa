I checked all six results. Every statement is true and nothing needed a counterexample. But two proofs have real gaps: Lemma 5.16 uses a hypothesis it doesn't state, and the proof of Corollary 2.3(ii) misses part of the β > 2 range. Both gaps are closed in Lean. The step where Propositions 3.5/3.6 turn the estimates into "not geometrically ergodic" is your own result, used as allowed, not re-proved.

Numbering, from the shared counter: Thm 2.2 = `thm:negative`, Cor 2.3 = `crly:expfam`, Thm 5.14 = `thm:light`, Lemmas 5.15/5.16/5.17 = `lem:xelower`/`lem:xlower`/`lem:arate_0`.

**Lean files** (both pass `lake env lean` with no `sorry`; the main theorems use only the standard axioms `propext`, `Classical.choice`, `Quot.sound`):
- `LightTails.lean`: the leapfrog integrator in any real normed space, Lemmas 5.15–5.17, Theorem 5.14, and the β > 2 case of Cor 2.3(ii).
- `HeavyTails.lean`: Theorem 2.2(ii) (through Thm 5.18's core estimate) and the β < 1 case of Cor 2.3(ii).

## Lemma 5.15 — statement correct, proof correct
Proved as `lemma_5_15`. The paper's wording "first term larger than 6/ε²" really means ‖∇U(x₀)‖/‖x₀‖ > 6/ε²; a slip, not an error.

## Lemma 5.16 — statement correct, proof has a gap
- **The gap:** the lemma assumes only that ‖∇U(x)‖/‖x‖ → ∞, but its proof uses the "oscillations" condition (‖∇U(y)‖ ≥ 3‖∇U(x)‖), in the step "‖∇U(x₀)‖/(2‖∇U(x_ε)‖) ≤ 1/6". That condition is not a hypothesis of the lemma. The step to general i is also only sketched ("entirely analogous").
- **The fix:** leapfrog can be written as x_{(n+2)ε} = 2x_{(n+1)ε} − x_{nε} − ε²∇U(x_{(n+1)ε}) (`two_step`). This gives ‖x_{(n+2)ε}‖ ≥ (ε²K − 3)‖x_{(n+1)ε}‖ using only the growth condition.
- **Proved:** `lemma_5_16`, under the stated hypothesis only. The stronger `lemma_5_16_doubling` shows ‖x_{(n+1)ε}‖ ≥ 2‖x_{nε}‖ for every n, with one threshold for all n.

## Lemma 5.17 — statement correct, proof correct with minor slips
- **Slips:**
  - "εδ_L" should read "εγ_L".
  - Squaring the lower bound needs εγ_L‖∇U(x_{Lε})‖/2 − ‖p₀‖ ≥ 0, which isn't stated (it holds for large ‖x₀‖).
  - The bound ‖∇U(x_{iε})‖ ≤ 3^{−(L−i)}‖∇U(x_{Lε})‖ needs the step-by-step doubling from the proof of 5.16, not just its statement.
- **Proved:** `lemma_5_17`, plus the stronger `logAcc_tendsto`/`acc_small`. The oscillations condition is not needed: since εp_{Lε} = x_{Lε} − x_{(L−1)ε} − (ε²/2)∇U(x_{Lε}), we get ‖p_{Lε}‖ ≥ 2‖x_{Lε}‖, so ‖p₀‖² − ‖p_{Lε}‖² ≤ −‖x₀‖². Then the third condition of Thm 5.14 (`oscillation2`) finishes the proof.

## Theorem 5.14 — statement correct, proof correct
- **Proved:** `thm_5_14` / `expected_acc_tendsto_zero`. For any momentum law μ, ∫ α(x₀, x_{Lε}(p)) μ(dp) → 0 as ‖x₀‖ → ∞. So the rejection probability r(x₀) → 1, and since π has a positive density, ess sup r = 1. Prop 3.5 then gives the claim. This also needs only the growth condition and `oscillation2`.
- **Remark:** Prop 3.5 is stated for Metropolis–Hastings kernels where α depends on (x, y). On x-space the HMC acceptance depends on p₀, so the result is really being applied through "P(x,{x}) ≥ r(x)".

## Theorem 2.2 — statement correct, proof correct
- **(i)** is Theorem 5.14. If L is random (as under A1), averaging over L still gives r → 1. The condition `oscillation2` mentions L, so it should be read for L = 1, which is the strongest case. The oscillations condition is in fact superfluous.
- **(ii)** follows from Thm 5.18 plus Prop 3.6. I proved the deterministic core: `displacement` gives ‖x_{Lε} − x₀‖ ≤ Lε‖p₀‖ + ε²ML²/2, matching the paper. `thm_5_18` shows uniform tightness: for every η there is a δ with Q(x₀, B_δ(x₀)ᶜ) < η for all x₀.

## Corollary 2.3(ii) — statement correct, proof has a gap
- **The gap:** "direct consequence of Theorem 2.2" fails for 2 < β < 1 + log₂3 ≈ 2.585. With |∇U| = αβ|x|^{β−1}, taking |y| = 2|x| gives |∇U(y)| = 2^{β−1}|∇U(x)| < 3|∇U(x)|, so the oscillations condition fails and Thm 2.2(i) does not apply.
  - **Lean counterexample:** `not_osc_expfam`, instantiated at β = 5/2 by `not_osc_beta_five_halves` (2^{3/2} < 3). `hasDerivAt_expfam` confirms that the gradient used really is U′.
- **The fix, for every β > 2:**
  - `explode_expfam` and `osc2_expfam` show the growth condition and `oscillation2` hold.
  - `cor_2_3_ii_large` then gives acceptance → 0 through the strengthened Lemma 5.17.
- **β < 1 (correct):**
  - `bounded_grad_expfam` shows the gradient is globally bounded; this needs U ∈ C¹ and π > 0, which the paper takes for granted.
  - `no_exp_moment_expfam` shows ∫ e^{s|x|−U(x)} dx = ∞ for every s > 0.
  - So Thm 2.2(ii) applies.

## Summary
| Result | Statement | Proof |
|---|---|---|
| Thm 2.2 (i), (ii) | Correct | Correct; the oscillations hypothesis in (i) is unnecessary |
| Cor 2.3(ii) | Correct | Gap for 2 < β < 1+log₂3 (oscillations fails, Lean counterexample at β = 5/2); fixed in Lean for all β > 2; β < 1 case fine |
| Thm 5.14 | Correct | Correct, given Lemmas 5.15–5.17 and Prop 3.5 |
| Lemma 5.15 | Correct | Correct (wording slip) |
| Lemma 5.16 | Correct | Gap: uses the unstated oscillations condition; fixed in Lean without it |
| Lemma 5.17 | Correct | Correct up to the typo εδ_L → εγ_L and an unstated sign check; oscillations condition not needed |

The simplest repair for the paper: drop the oscillations condition from Thm 2.2(i)/5.14 and Lemma 5.17, and use the two-step leapfrog identity in the proofs of Lemmas 5.16–5.17. Corollary 2.3(ii) for β > 2 then follows directly.

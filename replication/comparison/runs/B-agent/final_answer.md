I checked every numbered result. **Theorems 2.8 and 4.8 are false as stated** (Lean counterexamples for both), and the last step of the proof of the main theorem, 3.1, is wrong, though the theorem itself is true and now fully proved in Lean. Everything else is correct, sometimes with small gaps in the proofs. All Lean files compile with `lake env lean` and contain no `sorry`. A deliberately false test statement was rejected, so the checker is really running.

## Main findings

**1. Theorem 2.8 is false** (if X is InvSub and h is continuous and star-shaped, then h(X) is InvSub).
- **Counterexample:** take Z ~ Pareto(1), which is InvSub, and h(x) = max(x−2, 0), which is continuous and star-shaped (also increasing and convex). Then P(h(Z) ≤ 0) = 1/2 ≠ 0, so h(Z) breaks the requirement F(0) = 0 in Definition 2.2.
- **Fix:** add h > 0 on (0,∞). With that the proof goes through; Lean proves the corrected version.

**2. Theorem 4.8 is false** (a nonnegative super-Pareto X is InvSub).
- **Main counterexample:** X = Z + 1. It is super-Pareto, X ≥ 2 and F_X(0) = 0, but (2.3) fails at x = 5/2, θ = 1/2: 3/4 + 3/4 > 1/3 + 1.
- **Second counterexample:** max(Z−2, 0) also fails, because it has an atom at 0.
- **What goes wrong in the proof:** it claims "X = h(Y) with h(0) = 0". Shift invariance only gives this for X − ess inf X, and InvSub is not shift-invariant (the paper says so itself in Section 5).
- **Fix:** require h(0) = 0 and h > 0 on (0,∞). Lean proves this version.

**3. Proof of Theorem 3.1 (main result).** The paper ends with P(S > x) ≥ F̄(x/θₙ) + F̄(x/(1−θₙ)).
- This is false. For Pareto(1) at x = 3/5, θ = 1/2 the right side is 5/3 > 1.
- The error: it drops a term that is ≤ 0 from a *lower* bound.
- **Fix:** with a = F̄(x/θ), b = F̄(x/(1−θ)), c = F̄(x), the bound already obtained minus c equals (1−c)(a+b−c), which is ≥ 0 by (2.3).
- Lean proves the full theorem for all n, with weights allowed to be 0, using a two-variable step plus induction over product measures.
- Minor: the first line of the induction mixes `>`/`≥` and double-counts the event Xₙ = x/θₙ.

**4. Examples 4.13 and 4.16 are not distribution functions.**
- Example 4.13 with a = 1/2 gives 2·(1 + 1/(e²−1)) > 1 at x = 1.
- For Example 4.16, V(1) = 1 + e⁻¹ > 1.
- So the claimed strictness of the inclusions in §4.2 and §4.3 is unsupported.

**5. Smaller issues**
- **Example 2.7** puts mass p at +∞, so it is not a real-valued random variable.
- **The Introduction's claim that InvSub "seems the only [class] including discrete distributions" is wrong:** Example 2.7 is also super-heavy-tailed (proved in Lean).
- **Theorem 4.12's proof:** the reason given, "the exponential is superadditive", is false (e⁰ < e⁰ + e⁰). The correct reason is (1−a)(1−b) ≥ 0.
- **Proposition 3.2:**
  - The statement never says the Xᵢ are copies of X.
  - The step "Var√X = Var√Y ⇒ E√X = E√Y" is a non sequitur; equal distributions give it directly.
  - √X needs X ≥ 0, which is not assumed.
  - "Enough to prove n = 2" is not justified, though general n works the same way.
- **Propositions 5.2/5.3:** the proofs swap the left-continuous F⁻ (used in Definition 5.1) for F. The two versions are different functions, but subadditivity is equivalent for both (proved in Lean), so the results stand.
- **Theorem 4.15** uses "super-Fréchet", which the paper never defines.
- **Proposition 4.3** should say "concave on the support"; 1/F̄ is not concave on all of ℝ.

## Verdicts

| Result | Statement | Proof | Lean |
|---|---|---|---|
| Lemma 2.3 | Correct, if F(0)=0 is assumed (without it, the Dirac mass at 0 is a counterexample) | Correct | Proved |
| Prop 2.5 | Correct | Correct | Proved (assuming F is differentiable on (0,∞)) |
| Thm 2.8 | **False** | Wrongly treats h as increasing and never checks F(0)=0 | Counterexample; corrected version proved |
| Thm 3.1 | Correct | **Last step wrong**, easy to repair | Proved, all n |
| Prop 3.2 | Correct, but loosely stated | Has gaps (see above) | Not formalised; checked by hand |
| Prop 3.3 | Correct | Correct (relies on 3.1 and 3.2) | Proved directly, without 3.1/3.2 |
| Thm 4.2 | Quoted from the literature | — | Not checked against the source |
| Prop 4.3 | Quoted; needs "on the support" | — | Not checked |
| Prop 4.6 | Correct | Brief: one part needs the inverse of an increasing convex function to be concave | Key identity proved |
| Thm 4.8 | **False** | Wrong ("h(0)=0") | 2 counterexamples; corrected version proved |
| Lemma 4.10 | Correct (no proof given; "straightforward") | — | Proved |
| Thm 4.11 | Quoted from the literature | — | Not checked against the source |
| Thm 4.12 | Correct | Wrong reason, inequality right | Proved |
| Thm 4.15 | Quoted; "super-Fréchet" undefined | — | Not checked against the source |
| Prop 5.2 | Correct | Has a gap (F⁻ vs F) | Quantile identity proved |
| Prop 5.3 | Correct | Has a gap (F⁻ vs F) | Proved |

For Prop 5.2, the F⁻ vs F gap is closed by the same argument as Prop 5.3; only Prop 5.3's version is formalised. Examples 2.4, 2.6 and 2.7 check out (2.6 numerically, with b = 0.7 giving a maximum of about 0.985 ≤ 1).

## Files
All in `InvSub/`; the numerical check is in `scratch/num.lean`. Each Lean file repeats the definitions it needs, because importing between files here would mean building `.olean` files, which wasn't permitted.
- `Basic.lean`
- `Main.lean`
- `Counterexamples.lean`
- `Analytic.lean`
- `InfMean.lean`
- `Corrected.lean`
- `LeftRight.lean`

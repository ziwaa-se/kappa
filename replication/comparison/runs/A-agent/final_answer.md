I checked all five numbered results in Section 3, plus the Section 3.2 remarks, Table 1 and Appendix B. Four results are correct. **Proposition 3.5 is false as stated when the lag h ≥ 2**, and Lean confirms a counterexample. Its proof is also invalid even when h = 1, though the statement itself is true in that case.

All four Lean files compile under `lake env lean` with no errors and no `sorry`/`admit`/axioms. The background agent wrote `Sequential.lean` and I re-checked it.

| File | What it proves |
|---|---|
| `OnePeriod.lean` | Theorems 3.1–3.3, the elementary-score identities, and the formula for κ_ν |
| `Sequential.lean` | Proposition 3.4 for any lag h; Proposition 3.5 for h = 1 |
| `StoppingCounterexample.lean` | A fully formal counterexample to Proposition 3.5 for h = 2 |
| `Table.lean` | Every row of Table 1 and the Appendix B inequality |

## Theorem 3.1 (form of the e-values): statement correct, proof has slips
- **Lean:** I proved the "if and only if" in both cases (p < q and p > q). I also derived the sign condition d(0) < 0 < d(1) from the mixture representation, using ν[p,q) > 0.
- **Proof error:** it says "E(0) ∈ (0,1)". It should be E(0) ∈ [0,1): λ = 1 gives E(0) = 0, and the statement itself allows λ = 1.
- **Technical gap:** S(p,y) can be infinite. For example, with mixing density θ⁻³, S(p,0) = ∞ for every p, so S(p,y) − S(q,y) is ∞ − ∞. It is safer to define the difference directly as an integral over [p,q), which is what the Lean file does.

## Theorem 3.2 (best λ and the GROW e-value): statement correct, proof has slips
- **Lean:** I proved that λ₀ is the unique maximiser of the growth rate, and that the resulting e-value is (1−π₁)/(1−κ) for y = 0 and π₁/κ for y = 1. The edge case π₁ = 1 is handled separately.
- **Sign typo:** the proof writes d(y) = ∫ 1{p ≤ θ < q}(θ − y) dν. It should be (y − θ); otherwise d(0) > 0, contradicting the line before. The conclusion is unaffected because only ratios of the d's are used.
- **False step when π₁ = 1:** "lim_{λ→1} g(λ) = −∞" fails there, since the optimum is then λ = 1. The statement still holds.
- **Minor:** the trailing "> 1/π₁" is irrelevant, and there is a stray "}".

## Theorem 3.3 (likelihood ratio for all scores): correct
- **Lean:** I proved that H = [0,p] when p < q and H = [p,1] when p > q (in the second case the supremum over θ is not attained). I also showed directly, without citing Grünwald et al., that the likelihood ratio is valid for H and is the unique growth-optimal choice among all e-values.

## Proposition 3.4 (combining e-values over time): correct, minor gaps
- **Lean:** I proved it for any lag h, together with the one-step bound E[1 + a·D | ℱ_l] ≤ 1 under the null. One technical assumption was added: the factors are bounded (for example, forecasts stay away from 0 and 1).
- **Gap:** the statement allows p_t = q_t, but then E_{p,q;λ} is 0/0. You need to set E ≡ 1 when p_t = q_t.
- **Off-by-one in the proof:** the conditioning index should run over l = 0, …, ⌊(T−k)/h⌋ − 1.
- **Naming:** the text calls it a "lemma" (before the statement and in Proposition 3.5).

## Proposition 3.5 (optional stopping): false for h ≥ 2; proof invalid for all h
**Counterexample (h = 2, checked in Lean):**
- Brier score, with p_t = 1/5, q_t = 3/5, λ_t = 1 and c_t = 1.
- Y₃ ~ Bernoulli(2/5), Y₄ = Y₃, and every other Y_t = 0. The filtration is the natural filtration of Y.
- The Brier boundary is (p+q)/2 = 2/5, so the null H_S holds at every t.
- Stop at τ = 3 if Y₃ = 0, otherwise at τ = 4. At time 3 you already know the outcome Y₄ of the bet that is still open.
- Result: E[e_τ] = 13/10 > 1. Fixed times are fine: E[e₃] = E[e₄] = 1, as Proposition 3.4 says.

**Why the proof fails even for h = 1:** it assumes E(e_t | ℱ_t) ≤ 1. But e_t is ℱ_t-measurable, so this just says e_t ≤ 1. The step that is actually needed is that e_t is a nonnegative supermartingale, and that only holds when h = 1.

**What is true:**
- **h = 1:** the statement holds. I proved it in Lean for bounded stopping times, and for every stopping time via Fatou's lemma.
- **General h:** the procedure described in Section 3.2 and Appendix B is valid. That procedure sets λ_t = 0 from τ on and reports e_{τ+h−1}. Appendix B's inequality also checks out in Lean.

**Also:** the proposition is stated for H_S instead of H_{S;c}.

## Other points in the paper
- **Unsupported claim:** Section 3.2 says the anytime-valid p-values are valid for every h. That relies on Ville's inequality, which needs a supermartingale, so it is unjustified for h > 1. I did not find a counterexample either.
- **Table 1:** all three mixing densities and κ formulas are correct. In Lean, the log-score derivative statement needs θ > 0 only because Lean defines 1/0 = 0.
- **Table 3 caption:** it says min(p_t, q_t) ≥ 0.5, but the text defines c_t = 1{max(p_t, q_t) ≥ 0.5}.
- **Case study:** "9% or 27% of the data, respectively" does not say which airports these refer to.
- **Section 4.1:** the claim "p_t dominates q_t if and only if μ ≤ 0.5" is correct.

## Verdicts
| Result | Statement | Proof |
|---|---|---|
| Theorem 3.1 | Correct (proved in Lean) | Essentially correct; E(0) ∈ (0,1) should be [0,1) |
| Theorem 3.2 | Correct (proved in Lean) | Essentially correct; sign typo, and false limit step when π₁ = 1 |
| Theorem 3.3 | Correct (proved in Lean) | Correct, by citation |
| Proposition 3.4 | Correct (proved in Lean, factors assumed bounded); needs p_t ≠ q_t or E ≡ 1 when p_t = q_t | Sketch correct; index off by one |
| Proposition 3.5 | **False for h ≥ 2** (Lean counterexample); true for h = 1 (proved in Lean) | **Invalid** for every h |

I can also put this report on a shareable page if that would help.

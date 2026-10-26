Two results are false (Lemmas 2.2 and 2.4), and one true result has a wrong proof (Proposition 2.6). The rest are correct. Everything is in `Check.lean`, which compiles with `lake env lean Check.lean` with no errors and no `sorry`.

**How I formalised the paper:** I wrote V_n(p) as `p*(1-p)/n` with `n : ℕ` and `1 ≤ n`. I wrote s² for vectors `Fin m → ℝ`, with `m ≥ 2`. The paper calls I "the unit interval" without saying which one. I took it to mean the closed interval [0,1], because that is the standard meaning and because p = 0 and p = 1 are legitimate success probabilities.

### Lemma 2.1: correct statement, correct proof
The identity is proved with `ring` (`lem_quarter_identity`). The bound V_n(p) ≤ 1/(4n) holds for every real p (`lem_quarter`).

### Lemma 2.2 (V_n(p) > 0 on I): false
- **Counterexample:** at p = 0 (or p = 1), V_n(p) = 0 (`lem_positive_false`).
- **Where the proof fails:** it claims p and 1−p are both positive, which is not true at the endpoints.
- **What is true:** strict positivity holds on the open interval (0,1) (`lem_positive_open`). On [0,1] only V_n(p) ≥ 0 holds (`lem_nonneg`).
- If you meant I = (0,1), the lemma is correct, but then you should say so where I is defined.

### Proposition 2.3 (midpoint concavity of √V_n): correct statement, thin proof
- **Proof in the paper:** it only appeals to "it is well known" that √(p(1−p)) is concave. That is true, but it is cited rather than proved.
- **Proof in Lean:** I proved it directly on [0,1] (`prop_concave`). The key step is 2√(pq(1−p)(1−q)) ≤ p(1−q) + q(1−p). That gives (√(p(1−p)) + √(q(1−q)))² ≤ (p+q)(2−p−q), which is the claim.
- **Suggestion:** a one-line Cauchy–Schwarz argument like this could replace the citation.

### Lemma 2.4 (V_n(p) ≤ p/(4n)): false
- **Counterexample:** n = 1, p = ½ gives V = ¼, which is bigger than p/4 = ⅛ (`lem_linear_false`).
- **Where the proof fails:** Lemma 2.1 gives p(1−p) ≤ ¼, not p(1−p) ≤ p/4.
- **When it holds:** for p > 0, p(1−p) ≤ p/4 holds exactly when p ≥ ¾.
- **A correct replacement:** V_n(p) ≤ p/n on [0,1] (`lem_linear_fix`).

### Proposition 2.5: correct statement, correct proof
C = ¼ works (`prop_uniform`).

### Proposition 2.6 (s²(x+y) ≤ 2s²(x) + 2s²(y)): true statement, wrong proof
- **The statement is true:** I proved it in Lean (`prop_sum`). It follows term by term from (a+b)² ≤ 2a² + 2b² applied to the centred values.
- **The proof's identity is false:** the proof claims s²(x+y) = s²(x) + s²(y), which drops the covariance term 2·cov(x,y).
- **Counterexample to that identity:** m = 2, x = y = (0,1). Then s²(x+y) = 2, but s²(x) + s²(y) = 1 (`prop_sum_identity_false`).

### Other errors in the paper
- Lemma 2.4 is not used anywhere else, so its failure does not affect the other results.
- If I is the closed interval, Lemma 2.2 should say "≥ 0" instead of "> 0".

### Summary

| Result | Statement | Proof | Lean |
|---|---|---|---|
| Lemma 2.1 | Correct | Correct | Proved |
| Lemma 2.2 | **False** on [0,1] (true on (0,1)) | Wrong at the endpoints | Counterexample p = 0; open-interval version proved |
| Proposition 2.3 | Correct | Valid but only cites "well known" | Proved directly |
| Lemma 2.4 | **False** | Wrong (misuses Lemma 2.1) | Counterexample n = 1, p = ½; corrected bound p/n proved |
| Proposition 2.5 | Correct | Correct | Proved |
| Proposition 2.6 | Correct | **Wrong** (false identity) | Statement proved; counterexample to the identity |

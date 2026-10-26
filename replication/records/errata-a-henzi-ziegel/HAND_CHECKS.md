# Case A: findings not in the answer key, checked by hand

## Theorem 3.1 (arXiv v2): "E(0) ∈ (0,1)" excludes λ = 1 — confirmed, minor (2026-10-13)

- Run issue B1 (PAPER_ARGUMENT_GAP), Lean counterexample reviewed as valid.
- The theorem (`VSIFP_02.tex:145-150`) allows λ ∈ (0,1]; at λ = 1, E(0) = 1 − 1 = 0. The proof (`:419`) says "It
  follows … that E(0) ∈ (0,1), so with λ = 1 − E(0)", which covers λ ∈ (0,1) only. The correct range is E(0) ∈ [0,1).
  The theorem is true; the slip is in the proof. (E ≡ 1, i.e. λ = 0, is not an e-value with this alternative under
  the paper's definition (eq:evalueCond), so the open end at 0 is right.)
- Unchanged in v3 (`corrected/source/VSIFP_02.tex:412`). Not part of the published correction.

## Theorem 3.2 (arXiv v2): "lim_{λ→1} g(λ) = −∞" fails at π₁ = 1 — confirmed, minor (2026-10-13)

- Run issue B2 (PAPER_ARGUMENT_GAP), Lean counterexample reviewed as valid.
- For p < q the alternative is (π₀, 1], so π₁ = 1 is allowed; then g(λ) = log(1 − λh) with h < 0, which is finite
  and increasing at λ = 1, so the claim that the maximum is attained in [0,1) is false there (the maximiser is λ = 1).
  The theorem's formula still gives the right λ and e-value at the edge (as the run records). Mirror case p > q at π₁ = 0.
- Unchanged in v3 (`corrected/source/VSIFP_02.tex:424`). Not part of the published correction.

## Journal version (Biometrika 109 (2022), 647-663), checked 2026-10-22

- Both proof steps are unchanged in the journal version, where Theorems 3.1 and 3.2 are Theorems 1 and 2: the proof of
  Theorem 1 still concludes $E(0) \in (0,1)$, and that of Theorem 2 still claims $\lim_{\lambda \to 1} g(\lambda) = -\infty$.

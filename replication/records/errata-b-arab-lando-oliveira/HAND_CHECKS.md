# Case B: findings not in the answer key, checked by hand

## Lemma 2.3 (arXiv v2): the condition $F_X(0) = 0$ is missing — confirmed (2026-10-12)

- Run: errata-b-arab-lando-oliveira-check (v1.3.1, blind), issue B01, class PAPER_ASSUMPTION_GAP, with a Lean
  counterexample reviewed as valid.
- v2, `SuperParetoPaper-v12.tex:130-133`: "A random variable X is InvSub if and only if (eq:sub-1x)". Definition 2.2
  requires $F_X(0) = 0$. For $X = 0$ a.s., $F_X(t) = 1$ for $t \ge 0$, so (eq:sub-1x) reads $2 \le 2$ and holds,
  but $F_X(0) = 1$, so $X$ is not InvSub. The "if" direction is false as printed; the "only if" direction is fine.
- The authors' corrigendum restates the lemma as "Lemma 0.2 (Lemma 2.3 in [1]). A random variable X is InvSub if and
  only if $F_X(0) = 0$ and (0.1)", i.e. with the missing condition, without comment.
- Verdict of the hand check: a real, minor defect of the statement in arXiv v2, which the authors' own restatement
  repairs. Not part of the published correction. The journal version already has the condition (see the last section).

## Proposition 3.2 (arXiv v2): two findings — both confirmed as minor (2026-10-12)

- Run issues B02 (PAPER_ARGUMENT_GAP) and B03 (DOMAIN_CLARIFICATION).
- B02. The statement (`:261-264`) does not assume $X \ge 0$; the proof uses $\sqrt X$, $\sqrt Y$ and Jensen's
  inequality for the square root, which need nonnegative values. Correct as a remark on the printed proof. The
  conclusion is still true for integrable signed $X$ (equal means plus $\le_{st}$ force equal distributions, and a
  non-degenerate $X$ cannot satisfy $X \overset{d}{=} \theta X_1 + (1-\theta) X_2$ with a finite mean: by a different
  argument: strict Jensen for a strictly convex function of linear growth, such as $\sqrt{1+x^2}$), so not an ERROR. Every variable to which the paper
  applies the proposition is nonnegative (Proposition 3.3, InvSub), so adding "nonnegative" to the statement repairs it,
  as the run's audit suggests.
- B03. "It is enough to prove the case $n = 2$" is justified if (eq:main-st) is read as holding for all $n$ and all
  weights (then it holds for $n = 2$), not for one fixed $n$ and fixed weights, which is how the statement can be read.
  A fair point about wording; minor.
- Neither is part of the published correction.

## Theorem 3.1 (arXiv v2): the published error — found (2026-10-13)

- Run issue B06 (PAPER_ARGUMENT_GAP) at `:254-256`: the first inequality of the last display, $P \ge \bar F(x/\theta_n)
  + \bar F(x/(1-\theta_n))$, is false and does not follow, because the dropped term is nonpositive (an upper, not a
  lower, bound). This is exactly the error described by the corrigendum. Lean refutation of the intermediate claim,
  reviewed as valid; the run states that the conclusion of Theorem 3.1 is not threatened.
- The issue checker adds (as its own suggestion, marked as not in the source) that the final bound still follows from
  `:254` and (eq:sub-1x). Checked by hand: with $a = F(x)$, $b = F(x/\theta_n)$, $c = F(x/(1-\theta_n))$, the
  right-hand side of `:254` minus $\bar F(x)$ is $(1-b) + (1-c)a + (1-a)(b-a) - (1-a) = a(1 + a - b - c) \ge 0$ by
  (eq:sub-1x). Correct, and shorter than the corrigendum's new induction step.

## Theorem 2.8 (arXiv v2): false as printed when h vanishes near 0 — confirmed, minor (2026-10-13)

- Run issue B05 (ERROR; alternative PAPER_ASSUMPTION_GAP). With $h(x) = \max(x-1, 0)$ (continuous, $h(0) = 0$,
  $h(x)/x$ nondecreasing, so star-shaped) and $X$ with $F_X(x) = x/(1+x)$ (InvSub), $P(h(X) = 0) = P(X \le 1) = 1/2$,
  so $F_{h(X)}(0) = 1/2 \ne 0$ and $h(X)$ is not InvSub by Definition 2.2. The proof writes $F_{h(X)} = F_X \circ
  h^{-1}$, which needs $h$ invertible. A real defect of the statement under the paper's own definition; the
  subadditivity half of the conclusion survives. Not part of the published correction.

## Lemma 4.10 (arXiv v2): the condition $F_X(0) = 0$ is missing — confirmed, minor (2026-10-13)

- Run issue B04 (PAPER_ASSUMPTION_GAP). Same pattern as Lemma 2.3: Definition 4.9 requires $F_X(0) = 0$, the lemma's
  "if" direction does not; $X = 0$ a.s. satisfies (eq:inv-NWU) ($1 \cdot 1 \le 1$) and is not super-heavy-tailed by
  definition. Minor; not part of the published correction.

## Theorem 4.8 (arXiv v2): false as printed — confirmed; the most substantial new finding (2026-10-13)

- Run issues B09 (ERROR) and B10 (PAPER_ARGUMENT_GAP, the step "h(0) = 0" at `:337`).
- Definitions: super-Pareto means $X \overset{d}{=} h(Z)$ with $F_Z = \mathcal P$ (so $F_Z(z) = 1 - 1/z$, $z \ge 1$, as
  the proof's $Y = Z - 1$ with $F_Y(x) = x/(1+x)$ shows) and $h$ increasing, convex, nonconstant (`:284-286`).
- Check: $X = Z + 1$ ($h(z) = z + 1$) is nonnegative and super-Pareto, with $F_X(x) = 1 - 1/(x-1)$ for $x \ge 2$ and
  $0$ below. Then $G(s) = 1 - F_X(1/s)$ equals $s/(1-s)$ for $s \le 1/2$, so $G(1/4) = 1/3$, while $G(1/2) = 1 -
  F_X(2) = 1$. Hence $G(1/2) = 1 > 2/3 = G(1/4) + G(1/4)$: $G$ is not subadditive and $X$ is not InvSub, although
  $F_X(0) = 0$. (The other counterexample of the run, $\max(Z - 2, 0)$, has an atom at 0.) So adding "positive" does
  not repair the statement; what the proof actually uses is $X \overset{d}{=} h(Y)$ with $h(0) = 0$, i.e. a support
  that starts at 0, which the run's suggested fix ($F_X(0) = 0$ and $F_X(x) > 0$ for $x > 0$) expresses.
- The proof's error is the claim that "by shift invariance" $h(0) = 0$ can be assumed: shift invariance of the convex
  transform order moves the law, which changes InvSub membership.
- Not part of the published correction.

## Proposition 4.6 (arXiv v2): non-degeneracy missing — confirmed, minor

- Run issue B07 (PAPER_ASSUMPTION_GAP). For a Dirac law, $\mathcal P \le_c F_X$ holds trivially (constant transform)
  but the law is not super-Pareto, which requires a nonconstant $h$. Adding "non-degenerate" repairs it.

## Proposition 5.2 (arXiv v2): $F_X(0) = 0$ missing — confirmed, minor

- Run issue B08 (PAPER_ASSUMPTION_GAP). Same pattern as Lemma 2.3 and Lemma 4.10; the parallel Proposition 5.3 prints
  the condition.

## Journal version (Electron. Commun. Probab. 30 (2025), article 65), checked 2026-10-22

- Lemma 2.3 and Proposition 5.2 state the condition $F_X(0) = 0$, so these two findings concern arXiv v2 only. The
  corrigendum quotes Lemma 2.3 in the journal's form.
- Unchanged in the journal version: Proposition 3.2 (statement and proof), Proposition 4.6, Theorem 4.8, Theorem 2.8
  (Theorem 2.9 there) and Lemma 4.10 (Lemma 4.11 there, still without $F_X(0) = 0$).

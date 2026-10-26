# P03 issue 1: nondegeneracy hypothesis of Prop 3.2 for InvSub X (obligation P03_S2)

Role: pv-issue-checker (in progress; written incrementally)

## 1. Source text

- source/SuperParetoPaper-v12.tex:269-272:
  "As a consequence of Theorem~\ref{thm:main} and Proposition~\ref{prop:inf-mean}, the following result is immediate.
   \begin{proposition} ... If $X$ is \ITS, then $\Mexp X$ is infinite."
  No proof beyond the word "immediate".
- Cited Prop 3.2, :263: "Let $X_1,\ldots,X_n$ be independent random variables such that
  $\Prob(X_1=\cdots=X_n)<1$, and $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$.
  If (\ref{eq:main-st}) holds, then $X$ has infinite mean."  Its proof (:266) uses the hypothesis in the
  form $\Prob(X_1\ne X_2)>0$ for i.i.d. copies.
- Cited Thm 3.1, :188: "If $X$ is \ITS, then the stochastic dominance (\ref{eq:main-st}) holds."
- Def 2.2, :124: "$X$ such that $F_X(0)=0$ is \ITS\ if $F_{\frac1X}^-$ is subadditive", with
  $F_{\frac1X}^-(x)=1-F_X(\frac1x)$ (:121); equivalent form eq:sub-1x (:133):
  $F_X(x/\theta)+F_X(x/(1-\theta))\le F_X(x)+1$, $x\ge0$, $\theta\in(0,1)$.

The step at :269 must supply the hypothesis $\Prob(X_1=X_2)<1$ of Prop 3.2 for i.i.d. copies of an
InvSub $X$. The source does not say why it holds.

## 2. Consumed instance

n = 2, θ = (1/2, 1/2), X real-valued with law ν = μ.map X, `IsInvSub ν` (L01 encoding: F ν 0 = 0 and
`1 - F(1/x)` subadditive on (0,∞)), copies = coordinates on μ⊗μ (step S1). Needed fact, exactly
obligation `P03_S2_Gap` (pv_work/P03ModGaps.lean:65-69):
(μ⊗μ){p | X p.1 = X p.2 (all index pairs)} < 1.
The consumed clause `P03_P02Consumed` requires exactly this (its hypothesis `μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1`).
This is not a "general form false / instance true" situation: the needed property holds for every InvSub law.

## 3. Classification: FAIR_IMPLICIT_STEP

The hypothesis of Prop 3.2 is equivalent, for i.i.d. copies, to "X is not a.s. constant", and an
InvSub X is never a.s. constant, by a one-line check against the printed definition:
if X = c a.s., then F_X(0)=0 forces c > 0, and eq:sub-1x (:133) at θ = 1/2, x = c/2 gives
F_X(c) + F_X(c) = 2 ≤ F_X(c/2) + 1 = 1, which is false. (Equivalently, in the form of Def 2.2: v(y)=1-F_X(1/y)
= 1_{y>1/c} fails v(2y) ≤ 2v(y) at y = 1/c.) The transfer "non-degenerate ⇒ P(X_1 = X_2) < 1" for
independent copies is standard (P(X_1=X_2)=Σ_a p_a^2 < 1, or: take x with 0<F(x)<1, then
P(X_1 ≤ x < X_2) = F(x)(1-F(x)) > 0).

Why not the neighbouring classes:
- Not `PAPER_ASSUMPTION_GAP`: no hypothesis is missing; non-degeneracy follows from the printed
  hypothesis "X is InvSub" of Prop 3.3.
- Not `EXPOSITION_GAP`: no range or case of the statement is left uncovered; the omitted check is a
  verification of a cited result's hypothesis, valid for every InvSub X.
- Not `PAPER_ARGUMENT_GAP`: the justification given ("immediate" from Thm 3.1 + Prop 3.2) is the
  correct route; it only omits a routine check that uses nothing beyond eq:sub-1x / Def 2.2 at a single
  point. The source itself treats degeneracy as the trivial case (:102: with finite mean, (eq:main-st)
  holds "trivially ... if and only if exactly one coefficient is strictly positive").
- Not `ENCODING_ERROR`: the obligation is a faithful rendering of Prop 3.2's printed hypothesis (:263).

## 4. Does it threaten the conclusion?

- Prop 3.3's conclusion: no. The step is true for every InvSub X (proved in Lean, §5), so the route
  Thm 3.1 + Prop 3.2 goes through for this hypothesis.
- Downstream: INVENTORY.md:32 lists no consumer of P03; nothing is affected.
- Unaffected: T02 (Thm 3.1) and P02 (Prop 3.2) themselves; the other obligations of P03 (S1, S3-S7)
  and P03's other recorded doubts (INVENTORY X14: nonnegativity, extended-valued X of Ex 2.7) are
  outside this ruling and are not decided here.

## 5. Evidence (positive, on the consumed instance)

File: pv_work/probes/issue/P03/P03_issue1_S2fill.lean (imports P03ModGaps, PVTools).
- `Paper.P03.Issue1.S2_fill : Paper.P03.P03_S2_Gap` — the exact obligation, unchanged type
  (walk reaches `Paper.P03.P03_S2_Gap` th=3944470172 vh=3959848586, matching the prover's hashes).
- Compile: `scripts/pv_lean.sh probe pv_work/probes/issue/P03/P03_issue1_S2fill.lean` →
  `RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log pv_work/logs/P03_issue1_S2fill_3.log.
- Axioms: `#pv_walk_decl Paper.P03.Issue1.S2_fill`: "AXIOMS in closure: [propext, Classical.choice,
  Quot.sound]; sorryAx reached: false"; `#print axioms` agrees.

## 6. Fill-in for the prover (exact route, as compiled)

Only Def 2.2 (:124, L01 encoding `IsInvSub`) is used, no other paper result.
1. `halve` (Def 2.2 at y = 1/x, 1/x, x>0): 1 - F(x/2) ≤ 2(1 - F(x)), i.e. F(x/2) ≥ 2F(x) - 1.
2. `exists_mid`: ∃ x, 0 < F x < 1. By contradiction (assume 0 < F x → 1 ≤ F x for all x): pick x0>0 with
   F x0 > 1/2 (`tendsto_cdf_atTop`), so F x0 ≥ 1; by `halve` and induction F(x0/2^n) ≥ 1 for all n;
   right continuity of the cdf at 0 (`StieltjesFunction.right_continuous`) with F 0 = 0 gives δ with
   F y < 1/2 on [0,δ); choose n with x0/2^n < δ (`exists_pow_lt_of_lt_one`); contradiction.
   (This is the Def 2.2 form of "a point mass violates eq:sub-1x at x=c/2, θ=1/2".)
3. `S2_fill`: with A = X⁻¹(Iic x), B = X⁻¹(Ioi x): the "all equal" set E is disjoint from A×B;
   μ A = ofReal(F x) > 0 (`ofReal_cdf`), μ B = 1 - μ A > 0 (`prob_compl_eq_one_sub`);
   (μ⊗μ)(A×B) = μA·μB ≠ 0 (`Measure.prod_prod`); E + (A×B) ≤ 1 (`measure_union`, `prob_le_one`);
   hence (μ⊗μ)E < 1 (`ENNReal.lt_add_right`).
The prover may copy these three declarations into pv_work/P03.lean in place of the S2 `sorry`
(the prover owns that file; I did not modify it). Note: the auditor should treat S2 as a fair implicit
step filled by the route above, not as source content.

## 7. Suggestion to the authors (optional, editorial)

Add after :269 a clause such as "(note that an \ITS\ random variable is not degenerate, since a point
mass at $c>0$ violates (\ref{eq:sub-1x}) at $x=c/2$, $\theta=1/2$, so $\Prob(X_1=X_2)<1$)". Checked:
this suffices for the hypothesis of Prop 3.2 (Lean, §5). Not required for correctness.

## 8. Not checked here

- Whether Prop 3.2 (P02) itself is correct (separate issues P02_issue_1/2).
- Nonnegativity / extended-valued X in P03 (INVENTORY X14), obligations S1, S3, S7.
- Independent review by pv-auditor: pending; this ruling is not confirmed until then.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no

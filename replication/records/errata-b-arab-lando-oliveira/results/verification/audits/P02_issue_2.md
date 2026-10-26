# P02 (Proposition 3.2, `prop:inf-mean`) — suspected issue 2: nonnegativity of X used by the √-argument

Role: pv-issue-checker. Status: draft ruling, NOT confirmed until reviewed by pv-auditor.
Reported by: pv-prover (`pv_work/notes/P02_prover_notes.md`, stopped item 2, gap `P02_TwoCase_Gap`) and pv-gate
(`verification/audits/P02_gate.md` item 7.2, lines 24, 30, 54, 63).

## 1. Source text (read directly)

- Statement, `source/SuperParetoPaper-v12.tex:261-264`:
  "Let $X_1,\ldots,X_n$ be independent random variables such that $\Prob(X_1=\cdots=X_n)<1$, and
  $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$. If (eq:main-st) holds, then $X$ has infinite mean."
  No nonnegativity of $X$ is printed.
- (eq:main-st), `:95-99`: "given $n$ i.i.d. copies of $X$ ... $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$."
- Definition 2.1, `:115-118`: $X\leqst Y$ iff $\Fbar_X(x)\le\Fbar_Y(x)$ for every $x\in\mathbb R$ (real-valued setting).
- Proof, `:266`: "... assume $\Mexp(X)$ is finite. As then follows that $\Mexp(Y)=\Mexp(X)$ ... $X$ and $Y$ have the same
  distribution. Therefore, $\Var(\sqrt{X})=\Var(\sqrt{Y})$, implying that $\Mexp(\sqrt{X})=\Mexp(\sqrt{Y})$. But this is not
  possible, as Jensen's inequality implies that $\Mexp(\sqrt{Y})=\Mexp(\sqrt{\theta X_1+(1-\theta)X_2}) > \theta\Mexp(\sqrt{X})
  +(1-\theta)\Mexp(\sqrt{X})=\Mexp(\sqrt{X})$, the inequality being strict because $\Prob(X_1\ne X_2)>0$."
  The proof applies $\sqrt{\cdot}$ to $X$, $Y$ and uses strict concavity of $\sqrt{\cdot}$ (Jensen); both require
  $X\ge 0$ (a.s.).

Context on the domain:
- `:111-113` general conventions: no global nonnegativity convention; "Given a random variable X ..." (real-valued).
- `:122-125` Definition ITS requires $F_X(0)=0$, i.e. $X>0$ a.s.; `:150`, `:159` say "nonnegative" explicitly where
  meant; `:191` (proof of Thm 3.1) "remembering they are nonnegative" refers to ITS variables.
- `:354` "Note that the nonnegativity is not strictly necessary for the above definitions."
- `:403-404` super-Cauchy class "allows the support to be the whole $\mathbb R$" and (`:105`, Müller) satisfies
  (eq:main-st). So the paper explicitly considers real-valued $X$ for which (eq:main-st) holds.
- `:260` the text before the proposition speaks of "random variables with infinite means" generally and cites
  Proposition 2 of [superPareto2024]; `:269-273` Prop 3.3 = Thm 3.1 + Prop 3.2 for ITS $X$.

## 2. What is consumed

- Inside the proof (:266), the steps that use nonnegativity are exactly S4b (E√X = E√Y from Var√X = Var√Y and
  E X = E Y; needs √X ∈ L², i.e. X ≥ 0) and S5 (strict Jensen for √, needs both arguments in [0,∞), where √ is
  strictly concave). S2 (E Y = E X) and S3 (dominance + equal finite means ⇒ equal law) do not use it: the
  prover's `P02_S2`, `P02_S3` (`pv_work/P02ModGaps.lean:55-77`) carry no nonnegativity premise.
- Instance consumed by the paper itself: Prop 3.3 (P03, :269-273) applies Prop 3.2 to an ITS variable $X$, for which
  $F_X(0)=0$ (:124), i.e. $X>0$ a.s.; Thm 3.1 (T02) supplies (eq:main-st) for every $n$, in particular for $n=2$.
  So the only consumed instance is: $X\ge 0$ a.s., i.i.d. copies, $n=2$, $\theta\in(0,1)$. On this instance the √
  argument applies (S6 = `TwoCase` restricted to nonnegative X, X₁, X₂, proved by the prover, final audit pending).
  Technical remark for the prover/auditor: S6 asks `∀ ω, 0 ≤ X ω`; ITS gives only `0 ≤ X` a.s. Passing between
  them (modify X on a null set, or restate S6 with `∀ᵐ`) is a technical conversion, not a paper issue.
- Printed scope: real-valued $X$ (no sign condition). The question is whether the printed (general) statement is
  covered by the printed argument, and whether it is true.

## 3. Classification: PAPER_ARGUMENT_GAP (scope: X allowed to take negative values)

Ruling. For real-valued $X$ (the printed scope) the justification at :266 fails: $\sqrt X$, $\Var(\sqrt X)$ and the
strict Jensen inequality for the concave $\sqrt{\cdot}$ are not available when $X$ takes negative values (the
total function $\sqrt{\cdot}$ is not concave on $\mathbb R$; with Mathlib's truncation the strict inequality
E√Y > E√X fails outright, Lean evidence §5). The conclusion, however, remains true for real-valued $X$ under the
gated encoding `InfiniteMean μ X := ¬ Integrable X μ` (reasoning in §4). "The given justification fails; the
conclusion is still true" is PAPER_ARGUMENT_GAP.

Why not the neighbouring classes:
- Not ERROR: no counterexample to the printed clause exists under the gated reading (§4); the Lean instance in §5
  refutes only the √-step with the silent nonnegativity removed, not the proposition (it violates (eq:main-st)).
- Not PAPER_ASSUMPTION_GAP: nonnegativity is not *needed* for the conclusion (§4), so there is no missing hypothesis
  without which the result fails; it is only needed for the particular argument chosen.
- Not (primarily) DOMAIN_CLARIFICATION: the domain of the statement is not ambiguous in the paper. Definition 2.1
  (:117) is over all $x\in\mathbb R$; :354 says nonnegativity is "not strictly necessary"; :403 explicitly
  discusses the real-supported super-Cauchy class for which (eq:main-st) holds (:105); the statement says
  "independent random variables" with no sign restriction, whereas the paper writes "nonnegative" explicitly where
  it means it (:150, :159, :334). The only implicit nonnegativity is "remembering they are nonnegative" (:191),
  which refers to ITS variables ($F_X(0)=0$), not to Prop 3.2. So reading the proposition as restricted to
  $X\ge0$ is a possible repair, not the printed reading.
- Secondary DOMAIN_CLARIFICATION point (recorded, not the primary code): for signed $X$ the phrase "infinite mean"
  is undefined in the source. Under the reading "$\Mexp X$ does not exist as a finite number" (= ¬Integrable, the
  gated encoding) the proposition holds (§4). Under the literal reading "$\Mexp X=+\infty$" it is false for
  real-valued $X$: a standard Cauchy $X$ satisfies $\theta X_1+(1-\theta)X_2 \stackrel{d}{=} X$ (1-stability), so
  (eq:main-st) holds with equality, $\Prob(X_1=X_2)=0<1$, yet $\Mexp X$ is undefined, not $+\infty$ (reasoning,
  not checked in Lean). For $X\ge0$ both readings coincide.
- Not FAIR_IMPLICIT_STEP: a competent reader cannot "fill in" √X for negative X; the repair requires replacing √ by
  a different function (a new argument, §6).
- Not ENCODING_ERROR: `TwoCase`/`P02_main` faithfully omit nonnegativity because the source omits it (gate
  P02_gate.md line 24 rejected nonnegativity as a TFA, correctly); S4b/S5/S6 carry it because the source's √ use
  silently requires it. Our encoding does not manufacture the problem: with any encoding of √ on negative
  numbers (truncation, complex values, undefined), the cited strict Jensen inequality is unavailable.

## 4. Does it threaten the conclusion?

No.
- Final conclusion of Prop 3.2 for real-valued $X$ (gated reading ¬Integrable): still true. Reasoning, not checked
  in Lean; argument constructed by the reviewer, not in the source, suggestion only, not used in any verification:
  suppose $X$ integrable. By S2, S3 (both valid for real $X$, already proved without sign premises), $X\stackrel{d}{=}Y$.
  Let $\varphi(x)=\sqrt{1+x^2}$: strictly convex on $\mathbb R$, $0\le\varphi(x)\le1+|x|$, so $\varphi(X),\varphi(X_i),\varphi(Y)$
  are integrable. Pointwise $\varphi(\theta a+(1-\theta)b)\le\theta\varphi(a)+(1-\theta)\varphi(b)$ with strict
  inequality iff $a\ne b$; integrating over $\{X_1\ne X_2\}$ (positive probability) gives
  $\Mexp\varphi(Y)<\theta\Mexp\varphi(X_1)+(1-\theta)\Mexp\varphi(X_2)=\Mexp\varphi(X)$, contradicting $X\stackrel{d}{=}Y$.
  (The gate gave an equivalent sketch with $(x-t)^+$, P02_gate.md line 24.) Independence is not even needed.
- Under the alternative literal reading "$\Mexp X=+\infty$" for signed $X$, the printed statement fails (Cauchy,
  §3); this is the secondary domain-clarification point, not this issue's main finding.
- Downstream:
  - P03 (Prop 3.3, :269-273): NOT affected by this issue. It consumes only ITS $X$ ($X>0$ a.s.) with $n=2$, where
    the √ argument works (S6). (P03's dependence on issue 1, the $n=2$ reduction S1, is separate; note that P03
    needs only the $n=2$ case, since T02 gives (eq:main-st) for $n=2$.)
  - T02 (Thm 3.1), L01, P01, Section 4 results: do not use Prop 3.2; unaffected.
  - The intro claim :102 (finite mean ⇒ (eq:main-st) fails for ≥2 positive weights) is consistent with the
    corrected general statement; unaffected.

## 5. Evidence (Lean, obstruction; not a counterexample to Prop 3.2)

File: `pv_work/probes/issue/P02/issue_P02_sqrtneg.lean` (namespace `Paper.P02.Issue2`, imports `P02Stmt`, `PVTools`).
Compiled with `scripts/pv_lean.sh probe pv_work/probes/issue/P02/issue_P02_sqrtneg.lean`:
`RESULT issue_P02_sqrtneg mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`,
log `pv_work/logs/issue_P02_sqrtneg_3.log`. Axiom checks (`#pv_walk_decl`, log lines 1-2, 33-34, 37-38):
`not_S5WithoutNonneg`, `sqrt_not_concaveOn_univ`, `instance_negative`: AXIOMS in closure
[propext, Classical.choice, Quot.sound]; sorryAx reached: false.

Contents:
- `sqrt_not_concaveOn_univ : ¬ ConcaveOn ℝ Set.univ Real.sqrt` — the Jensen inequality cited at :266 is not
  available for √ on ℝ.
- `S5WithoutNonneg : Prop` — the source step S5 (:266, strict Jensen E√Y > E√X from P(X₁≠X₂)>0, θ∈(0,1)) with the
  premises of `P02_S5` (`P02ModGaps.lean:254-258`) minus `hnn₁ hnn₂`, plus independence of X₁, X₂ as an extra
  premise (extra premises are allowed; the conclusion is the same as printed).
- `not_S5WithoutNonneg : ¬ S5WithoutNonneg` — instance: Ω = Bool×Bool with the product of two fair coins,
  X₁ = f∘fst, X₂ = f∘snd, X = X₁, f(true) = -1, f(false) = -2, θ = 1/2. Proven: measurability, `IndepFun X₁ X₂ μ`,
  `IdentDistrib X₁ X`, `IdentDistrib X₂ X`, integrability, μ{X₁≠X₂} ≥ μ{(true,false)} = 1/4 > 0; both sides of the
  strict inequality equal 0 (`sqrt_sides_zero`).
- Scope (`instance_negative`, docstring): the instance has X < 0 everywhere and does NOT satisfy (eq:main-st)
  (finite mean), so it refutes only the √-step without nonnegativity, not Prop 3.2 nor `TwoCase`. No
  `pv_work/P02_Counterexample2.lean` was written, because the printed proposition is not refuted.

## 6. Suggestion to the authors (minimal)

Either (a) add "nonnegative" to the statement of Proposition 3.2 (:263) — sufficient for the √ argument as
written and for its only use (Prop 3.3, ITS variables are positive) — or (b) keep the general statement and
replace √ by a strictly concave/convex function that is defined and integrable on ℝ, e.g. $\varphi(x)=\sqrt{1+x^2}$
(constructed by the reviewer, not in the source, suggestion only, not used in any verification; checked by the
reasoning in §4 to suffice for the ¬Integrable reading). With (b), "infinite mean" should be stated as "$X$ does not
have a finite mean" (the Cauchy case shows "$\Mexp X=+\infty$" is too strong for signed $X$). Option (a) alone
also removes the "infinite mean" ambiguity.

## 7. Not checked

- The real-valued conclusion (§4) and the Cauchy remark (§3) are reasoning, not checked in Lean.
- Issue 1 (the reduction "It is enough to prove the case n=2", S1) is not ruled here.
- S6 and the other prover lemmas are awaiting the pv-auditor final audit; I relied only on their statements.
- Human check: recommended only for the authors' intended domain (nonnegative vs real-valued) and the intended
  meaning of "infinite mean" for signed X.

Review needed: reasoning review by pv-auditor (the Lean file is obstruction evidence, not a counterexample to the
printed clause). Not confirmed before that review.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no

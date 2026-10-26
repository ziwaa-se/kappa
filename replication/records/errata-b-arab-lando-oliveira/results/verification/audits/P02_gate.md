# P02 statement gate (Proposition 3.2, prop:inf-mean)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:00:02 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `7eddf12f4c2ef0f609d8feb581aa0dac9d881254d5ee588908b04f6f79c339f9  pv_work/P02Stmt.lean`
  - `39f520ae810609d0d2ec45e94ccc4328f673d0c1fea53452ffe0b2ed536c9701  pv_work/P02Draft.lean`
  - `fc939c7ad3e1542ca921ddbf5b0d2331b5b37e0227248de5bfced2b4b29dc614  pv_work/notes/P02_draft_notes.md` (leads only)
- Compilation: `scripts/pv_lean.sh check P02Draft` -> `RESULT P02Draft mode=check exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0 log=pv_work/logs/P02Draft_2.log olean=none` (8 sorries = main + S1..S6 incl. S4a/S4b, expected for a draft).

## Source quotations (read directly)

- :95-99 "given $n$ i.i.d. copies of $X$, say $X_1,\ldots,X_n$, and weights $\theta_1,\ldots,\theta_n\geq0$ such that $\theta_1+\cdots+\theta_n=1$, we have (eq:main-st) $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$."
- :111 conventions (increasing = non-decreasing, generalised inverse, subadditive, star-shaped). No global nonnegativity convention; :354 and :403-404 explicitly allow real-valued supports (super-Cauchy "allows the support to be the whole R").
- :115-118 Definition 2.1: "$X\leqst Y$, if $\Fbar_X(x)\leq\Fbar_Y(x)$, for every $x\in\mathbb{R}$." :113 $\Fbar_X = 1-F_X$, i.e. $P(X>x)$.
- :261-264 Proposition 3.2: "Let $X_1,\ldots,X_n$ be independent random variables such that $\Prob(X_1=\cdots=X_n)<1$, and $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$. If (eq:main-st) holds, then $X$ has infinite mean."
- :266 proof: "It is enough to prove the case $n=2$. Denote $Y=\theta X_1+(1-\theta)X_2$, where $X_1$ and $X_2$ are independent and have the same distribution as $X$ and are such that $\Prob(X_1\ne X_2)>0$. Moreover, assume $\Mexp(X)$ is finite. As then follows that $\Mexp(Y)=\Mexp(X)$, both finite, this, together with (eq:main-st), implies that $X$ and $Y$ have the same distribution. Therefore, $\Var(\sqrt{X})=\Var(\sqrt{Y})$, implying that $\Mexp(\sqrt{X})=\Mexp(\sqrt{Y})$. But this is not possible, as Jensen's inequality implies that $\Mexp(\sqrt{Y}) > \theta\Mexp(\sqrt{X})+(1-\theta)\Mexp(\sqrt{X})=\Mexp(\sqrt{X})$, the inequality being strict because $\Prob(X_1\ne X_2)>0$."

## Item 1. Hypotheses: PASS

- Independence: `iIndepFun Xs μ` (:263). Weights `0 < θ i`, `∑ θ i = 1` (:263, strict positivity as printed). `μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1` is exactly P(X_1=...=X_n)<1. (eq:main-st) via `StDom` = Def 2.1 verbatim (`μ{x<X} ≤ μ{x<Y}` for all real x; ℝ≥0∞ values, no truncation).
- X undefined in :263: the reading "X_i are i.i.d. copies of X" (`IdentDistrib (Xs i) X`) is forced by (eq:main-st) :95 ("n i.i.d. copies of X") and confirmed by the proof :266 ("have the same distribution as X"). Accepted. Placing X and the X_i on one probability space is harmless (only laws matter, :119).
- Added premises: measurability of X and X_i (random variables are measurable by definition) and `IsProbabilityMeasure`: technical, approved.
- Nonnegativity: correctly NOT added to `P02_main`. It is not printed, not a global convention (:403), and not a TFA (it is a domain restriction, not derivable from context). Note (gate check of truth): `P02_main` remains true for real-valued X: if X were integrable, S3 gives X =d Σθ_iX_i, and for every rational t the convex functions (x-t)^+ give equality in Jensen, forcing a.s. all X_i equal, contradicting `hne`. So the stronger (no-nonnegativity) statement is not false, merely not covered by the source's √-argument.
- Degenerate n: n=0 makes `hsum` false; n=1 makes `hne` false (set = univ). Vacuous, consistent with source.
- No hidden hypotheses: no structures, classes or `variable`s beyond `[MeasurableSpace Ω]`, `[IsProbabilityMeasure μ]`; `Ω : Type` universe fix is harmless.

## Item 2. Conclusion: PASS

`InfiniteMean μ X := ¬ Integrable X μ`. With X measurable this is E|X| = ∞; for nonnegative X it is exactly E X = ∞. For real X the source does not define "infinite mean"; ¬Integrable is the weakest natural reading and is the negation of "E(X) is finite" which the proof assumes (:266). Accepted; the residual ambiguity for signed X is a DOMAIN_CLARIFICATION point (see item 7), not an encoding error.

## Item 3. Quantifiers / constants: PASS

No constants. θ, n, X, Xs universally quantified as in the source.

## Item 4. Domains and details: PASS

Real-valued (not periodic); equality in law via `IdentDistrib`; no a.e. issues (StDom is a statement about measures of sets); integrability via `Integrable`; `Real.sqrt` truncates negatives to 0, which only matters in S4a (true anyway) and is otherwise guarded by nonnegativity premises in S4b, S5, S6.

## Item 5. Step obligations: FAIL for S4b (false as stated), others PASS

| Step | Source | True as stated? | Smuggling? | Ruling |
|---|---|---|---|---|
| S1 (`TwoCase → P02_main`) | :266 "enough to prove n=2" | True (the conclusion `P02_main` is itself true, see item 1); but the source gives no reduction | No: `TwoCase` is the n=2 instance, a faithful encoding of the source's reduction claim | PASS. Expected stop point if the prover cannot reduce along the source; must not be proved by a non-source route (e.g. by redoing the argument for general n, or the (x-t)^+ argument). |
| S2 | :266 "E(Y)=E(X), both finite" | True | No | PASS |
| S3 | :266 "together with (eq:main-st), implies same distribution" | True (∫(F̄_Y−F̄_X)=EY−EX=0, nonnegative integrand, right-continuity) | No | PASS |
| S4a | :266 "Therefore Var(√X)=Var(√Y)" | True (IdentDistrib composed with measurable √) | No | PASS (docstring mentions nonnegativity but none is needed or assumed; harmless) |
| S4b | :266 "implying E√X = E√Y" | **FALSE AS STATED.** Counterexample: X ≡ 0, Y ≡ 1 (any probability space): both nonnegative, integrable, X ≤st Y, Var√X = Var√Y = 0, but E√X = 0 ≠ 1 = E√Y. Missing premise: `E Y = E X`, which the source established two sentences earlier ("E(Y)=E(X), both finite"). | No | **FAIL -> amendment A1** |
| S5 | :266 Jensen, strict | True (pointwise strict concavity of √ on [0,∞) on the positive-measure set {X₁≠X₂}; all terms integrable since √x ≤ 1+x; E√X₁ = E√X₂ = E√X by IdentDistrib) | No | PASS |
| S6 | :266 "this is not possible" | True | No | PASS (`hind` unused, harmless) |

Note on S4b and the drafter's "non sequitur" claim: with the missing premise restored, the source step is valid. For X ≥ 0 integrable, √X ∈ L², Var√X = E X − (E√X)²; with E X = E Y and Var√X = Var√Y one gets (E√X)² = (E√Y)², and E√·≥0 gives E√X = E√Y. So the step "Var equal, implying E equal" is a FAIR_IMPLICIT_STEP (it uses the just-proved E X = E Y), not a non sequitur. The S4b docstring sentence "this is not a valid implication in general (suspected PAPER_ARGUMENT_GAP...)" should be corrected accordingly (amendment A2, documentation only).

Assembly: S2+S3 (with Y = θX₁+(1−θ)X₂) give IdentDistrib; S4a gives Var equality; S4b (amended, with hmean from S2) gives E√X = E√Y; S5 contradicts it; S6 = `TwoCase` restricted to nonnegative X, X₁, X₂. S1 then requires the unrestricted `TwoCase`. Hence the obligations do NOT assemble to `P02_main` without nonnegativity: the chain stops exactly where the source uses √X for a random variable not stated to be nonnegative, and at the unjustified n=2 reduction. This is a correct, faithful stopping structure (POLICY §1), not an encoding defect. Finite variance of √X is automatic from X ≥ 0 and E X < ∞ (FAIR_IMPLICIT_STEP).

## Item 6. External parameters: PASS (none)

No `def Tool : Prop` external parameters. `TwoCase` is not an external parameter: it is the source's own n=2 case used as the hypothesis of reduction obligation S1, declared in `P02Stmt.lean`, `namespace Paper.P02`; its content is locked by `vh`. It is not registered in EXTERNAL_TOOLS.md and must not be (it may never appear as a hypothesis of the final `P02_main`). `StDom`, `InfiniteMean`, `TwoCase` are not redeclared elsewhere (only P01Stmt, L01Stmt exist besides; no clash by grep of `def StDom|def TwoCase|def InfiniteMean`). No "mathlib lacks" claims were made, so none to check.

## Item 7. Doubts about the source (preliminary; dispatch pv-issue-checker)

1. :263 — X is not defined in the statement and the X_i are only "independent" (identical distribution only via :95 and :266). Preliminary: EXPOSITION_GAP (or DOMAIN_CLARIFICATION); low severity since the reading is unambiguous from context.
2. :263/:266 — the proof applies √ to X and Y, i.e. silently assumes X ≥ 0; the statement does not, and the paper elsewhere admits real-valued supports (:403). Proposition as printed still appears true for real X (gate sketch in item 1), so the defect is in the coverage of the argument. Preliminary: PAPER_ARGUMENT_GAP (alternatively DOMAIN_CLARIFICATION, together with the meaning of "infinite mean" for signed X).
3. :266 — "It is enough to prove the case n=2": no reduction is given; the n-variable dominance does not directly yield an n=2 dominance with i.i.d. copies of X. The n=2 argument generalises verbatim (n-term Jensen), so the conclusion is not in doubt. Preliminary: EXPOSITION_GAP.
4. :266 — "Var(√X)=Var(√Y), implying E(√X)=E(√Y)": gate view is FAIR_IMPLICIT_STEP (valid using E X = E Y finite, see item 5); drafter suspected PAPER_ARGUMENT_GAP. Dispatch for a ruling.
5. :266 — strictness of Jensen from P(X₁≠X₂)>0: FAIR_IMPLICIT_STEP (pointwise strict concavity). No dispatch needed.

## TFAs ruled on

| Premise | Where | Ruling | Reason |
|---|---|---|---|
| `Measurable X`, `Measurable (Xs i)` (and in TwoCase, S2-S6) | P02_main, S1, TwoCase, steps | Approved | random variables are measurable |
| `IsProbabilityMeasure μ` | all | Approved | probability setting |
| `IdentDistrib (Xs i) X` | P02_main, S1 | Approved (reading, not TFA) | forced by :95, :266 |
| Nonnegativity of X | not in P02_main (correct) | Rejected as TFA for P02_main | not printed, not derivable, :403 admits real supports; allowed only inside step obligations S4b, S5, S6 that mirror the source's √ use |
| `hnn`, `hnnY` etc. in S4b/S5/S6 | steps | Approved as step-local premises | mirror the source's silent use of √; make the stop point visible at S6→TwoCase |

## External parameters

None.

## Required changes

A1 (pv_work/P02Draft.lean, theorem `P02_S4b`, lines 71-76): add the premise established by the source at :266 ("E(Y)=E(X)"), e.g. insert after line 73 (`(hXi ...) (hYi ...)`):
```
    (hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ)
```
Without it S4b is false as stated (X ≡ 0, Y ≡ 1). Keep all other premises and the conclusion unchanged.

A2 (pv_work/P02Draft.lean, docstring of `P02_S4b`, lines 66-70): replace the claim "As a step from `Var` to `E` this is not a valid implication in general (suspected PAPER_ARGUMENT_GAP; ...)" by a statement that the step uses E X = E Y (S2) and Var√X = E X − (E√X)²; the drafter's suspicion is forwarded to pv-issue-checker. Documentation only (does not change the type hash).

No change to `P02Stmt.lean`.

## Statement snapshot

Statement copy `pv_work/probes/gate/P02/gate_P02_stmtcopy.lean` (`RESULT ... exit=0`, log `pv_work/logs/gate_P02_stmtcopy_1.log`):
```
TYPE HASHES (current file, 3 declarations)
Paper.P02.InfiniteMean|def|th=1957365751|vh=1062878209|bi=icee
Paper.P02.StDom|def|th=180540177|vh=4122359899|bi=iceee
Paper.P02.TwoCase|def|th=3944470172|vh=215005570|bi=
```

Draft copy `pv_work/probes/gate/P02/gate_P02_draftcopy.lean` (`RESULT ... exit=0 sorry_warnings=8`, log `pv_work/logs/gate_P02_draftcopy_1.log`):
```
TYPE HASHES (current file, 8 declarations)
Paper.P02.P02_S1|thm|th=320467813|vh=-|bi=eicecieeeeeeeeeee
Paper.P02.P02_S2|thm|th=4187370773|vh=-|bi=iceceeeeeeeeee
Paper.P02.P02_S3|thm|th=4084716335|vh=-|bi=iceceeeeeeee
Paper.P02.P02_S4a|thm|th=2655103998|vh=-|bi=iceceee
Paper.P02.P02_S4b|thm|th=1753446197|vh=-|bi=iceceeeeeeeeee
Paper.P02.P02_S5|thm|th=1897498061|vh=-|bi=iceceeeeeeeeeeeeeee
Paper.P02.P02_S6|thm|th=2865709670|vh=-|bi=iceceeeeeeeeeeeeeeeee
Paper.P02.P02_main|thm|th=1724241671|vh=-|bi=icecieeeeeeeeeee
```
(The S4b hash will change with A1; the r2 check gives the new snapshot. All other hashes must stay identical.)

## Overall verdict

Main statement `P02_main` and `P02Stmt.lean` are faithful; one step obligation (S4b) is false as stated and must be amended before proof work.

STATEMENT GATE: PASS_WITH_AMENDMENTS

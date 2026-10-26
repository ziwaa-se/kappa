# T02 statement gate (Theorem 3.1, thm:main)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 01:07:13 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  a99991e0222d74ac2ea3ce9365e6f6b2fd6d9f52526f144d2eea59dc07af2e58
  - `pv_work/T02Draft.lean` 6c0fd4c2205cde422012d23083e4e12d5c0c079b30ba2aadf2fec0e34f0b65c8
  - `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
  - also read: `pv_work/L01Stmt.lean`, `pv_work/L01Draft.lean` (L01_main), `pv_work/P02Stmt.lean` (StDom), draft notes (used only as leads)
- Compilation: `scripts/pv_lean.sh check T02Draft` gave `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=14 nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_2.log`
- Snapshot probes: `pv_work/logs/gate_T02_stmtcopy_1.log` (exit 0, 0 sorry), `pv_work/logs/gate_T02_draftcopy_1.log` (exit 0, 14 sorry)

## Source quotations

- :95-98: "given $n$ i.i.d. copies of $X$, say $X_1,\ldots,X_n$, and weights $\theta_1,\ldots,\theta_n\geq0$ such that $\theta_1+\cdots+\theta_n=1$, we have (eq:main-st) $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$."
- :113: "$F_X$ and $\Fbar_X=1-F_X$ its cumulative distribution and survival functions".
- :115-118 (Def 2.1): "$X\leqst Y$, if $\Fbar_X(x)\leq\Fbar_Y(x)$, for every $x\in\mathbb{R}$."
- :122-125 (Def 2.2): "$X$ such that $F_X(0)=0$ is ITS if $F^-_{1/X}$ is subadditive."
- :128-135 (Lemma 2.3): ITS iff (eq:sub-1x) $F_X(x/\theta)+F_X(x/(1-\theta))\le F_X(x)+1$, $\forall x\ge0,\theta\in(0,1)$.
- :165 (Ex 2.7): a discrete ITS cdf on $(0,+\infty]$ "assigns positive mass $p$ to $+\infty$".
- :186-188 (Thm 3.1): "If $X$ is ITS, then the stochastic dominance (eq:main-st) holds."
- Proof :190-257 (base case :191-217, induction step :219-256), read in full.

## Item 1: hypotheses. PASS

- ITS: `IsInvSub (μ.map X)` (L01 encoding of Def 2.2, including `F_X(0)=0`). Correct.
- i.i.d. copies: `IIDCopies` = measurability + `iIndepFun` + `IdentDistrib` to `X`. Correct; measurability is the standard reading of "random variable". No hidden hypotheses in the structure.
- Weights: `0 ≤ θ i`, `∑ θ i = 1`, as printed at :95 (not the proof's `> 0`). Correct.
- `[IsProbabilityMeasure μ]`: standard.
- `n = 0` is excluded automatically (`hsum` becomes `0 = 1`).
- No extra premise, and no premise that states the conclusion.

## Item 2: conclusion. PASS

`StDom μ X (∑ θ i * Xs i)` is Def 2.1 for all real `x`: `μ{x<X} ≤ μ{x<Y}`, which is `P(X>x) ≤ P(Y>x)`, compared in `ℝ≥0∞`. Not weakened or strengthened. Single clause.

## Item 3: quantifiers and constants. PASS

There are no constants. Everything is universally quantified, as in the source.

## Item 4: domains and details. PASS, with one domain note

- Comparing probabilities in `ℝ≥0∞` in `StDom` and via `toReal` in the steps is safe, because all the measures are finite.
- The integral `∫_0^{x/θ} … F_X(dt)` is encoded as `∫ t in Icc 0 (x/θ) … ∂(μ.map X)`. The law gives no mass to `(-∞,0]` (`F(0)=0`), so the endpoint 0 does not matter. The upper endpoint is closed, which matches "`X_n ≤ x/θ_n`" (:222). Correct.
- **Domain note (real-valued X).** The encoding makes `X : Ω → ℝ`. The source's own Example 2.7 (:165) has an ITS variable with mass at `+∞`, and :107 cites it as the reason ITS is distinguished. Real-valued `X` is the standard reading of "random variable", so I do not require a change. But the coordinator should know about it (see item 7, issue A). Consequence (sketch, gate reasoning): for a real-valued law with `F(0)=0`, set `G(y)=1-F(1/y)`. `G` is increasing, `G(0+)=1-F(+∞)=0`, and `G` is subadditive on `(0,∞)`. Then `G(y₀) ≤ G(y₀-ε)+G(ε)` and `G(y₀+δ) ≤ G(y₀)+G(δ)` force `G` to be continuous on `(0,∞)`. So `F` is continuous, and **a real-valued ITS law has no atoms**. The drafter's atom suspicions therefore **do not materialise in this encoding** (see item 5).

## Item 5: step obligations

| Step | Source | Faithful | True as stated? | Note |
|---|---|---|---|---|
| S1 | :191-194 | yes | TRUE | The full-line integral `∫F((x-θt)/(1-θ))dν` is concentrated on `[0,x/θ]`: there is no mass below 0, and `F(y)=0` for `y≤0`. |
| S2 | :195-198 | yes | TRUE | Split `[0,x]` / `(x,x/θ]`. `ν[0,x]=F(x)` because `F(0)=0`. |
| S3 | :198-201 | yes | TRUE | `F(x)·(F(x/(1-θ))+F(x/θ)-F(x)) ≤ F(x)` by SubCond and `F(x)≥0`. |
| S4 | :217 | yes | TRUE | Also covers `x<0`, which is not written in the source. There both probabilities are 1 because `X>0` a.s. This is a fair implicit step. |
| S5 | :219-222 | yes, exact transcription | TRUE in this encoding | Because the law has no atoms (item 4), `P(X_n=c)=0` and `P(S=x)=0`. Without atoms the printed double count is harmless. The source gives no justification for the `≥`/`≤` overlap; see issue A. Also true at `n=0`. |
| S6a | :223 | yes | TRUE in this encoding | `P(X_n ≥ c)=P(X>c)`, again because there are no atoms. |
| **S6b** | :223-224 | yes for the source range | **FALSE AS STATED at `n = 0`** | With `n=0`: `1-θ(last)=0`, so the event is `(x-t)/0 ≤ 0/0`, i.e. `0 ≤ 0`, which always holds. The right side is `ν[0,x]=F(x)`. The left side is `μ{X_0 = x} = 0`. This is false whenever `F(x)>0`. The source's induction step only covers `n ≥ 3` variables (Lean `n ≥ 2`), so this is an encoding range defect, not a paper issue. For `n ≥ 1` it is true (conditioning on `X_n`, independence, `1-θ_n>0`). **Amendment 1.** |
| S7 | :224-225 | yes | TRUE | At `n=0`, `hIH` is contradictory (take `x=0`: `μ{0<X}=1 ≤ μ{0<0}=0`), so the obligation holds vacuously. For `n≥1`: IH, then `P(Y>y) ≤ P(Y≥y)`, then monotonicity of the integral (the integrands are bounded and monotone in `t`, hence measurable). |
| S8 | :246-252 | yes | TRUE | Mirror of S2: `F̄` is decreasing and the integrand is `≥ 0`. |
| S9 | :252-254 | yes | TRUE | Algebraic identity. With `a=F̄(x)`, `b=F̄(x/θ)`, `d=F̄(x/(1-θ))`, both sides equal `b+d+a(a-b-d)`. |
| S10a | :256 | yes | TRUE | SubCond rewritten in terms of `F̄`. |
| **S10b** | :256 | yes, faithful encoding of the printed inference | **FALSE AS STATED** | Needs `a(a-b-d) ≥ 0`, but `a ≥ 0` and `a-b-d ≤ 0`. Fréchet(1), `x=1`, `θ=1/2`: `a≈0.632`, `b=d≈0.393`, `a(a-b-d)≈-0.098<0`. Dropping a nonpositive term gives an upper bound, not a lower bound. Paper-side suspicion: issue B. Not an encoding error. |
| S11 | :256 | yes | TRUE | Same content as S10a. |

No obligation smuggles in the target conclusion. In S7, the IH is the source's induction hypothesis applied to the normalised weights `θ_i/(1-θ_n)`, which is a fair implicit normalisation (they are positive and sum to 1).

Assembly: S1-S4 give `n=2` with positive weights. S5-S11 give the induction step for `x ≥ 0` (except that S10b is false). The following are **not covered by any obligation**: the `x<0` case in the induction step (trivial, a fair implicit step in the assembly), and zero weights / `n=1` (issue C). As expected, the main theorem therefore cannot be assembled purely from the source route. That is a recorded paper-side matter, not a gate failure.

Overall item 5: **FAIL pending Amendment 1** (S6b). S10b is accepted as a faithful encoding of a suspected paper step.

## Item 6: external parameters. PASS

| Name | Provenance | Ruling |
|---|---|---|
| `T02_L01Consumed` | (p), L01 Lemma 2.3, "only if" half (`L01_main` `.mp`, `L01Draft.lean:32-33`) | APPROVED |

- Not stronger than the use: it is exactly `IsInvSub ν → SubCond ν`, the direction used at :201 and :256, for probability measures on ℝ. It is also true: it is L01_S1/S2 restricted to `x≥0`, and at `x=0` it reduces to `F(0)≤1`.
- Not goal-shaped.
- Applicability: it is applied to `μ.map X`, which is a probability measure because `X` is measurable.
- Declared only in `T02Stmt.lean`, in `namespace Paper.T02`, with name `T02_L01Consumed` (correct pattern). No clash with any `Stmt` name.
- `StDom` duplicates `Paper.P02.StDom` (identical body) and `Fbar` duplicates `Paper.P01.Fbar`. Both are in different namespaces, so neither is a redeclaration. Cosmetic only.
- There is no other `Tool`. Conditioning/Fubini (X05) is left as obligations S1/S6b, which I consider acceptable. No mathlib-absence claim is made, so none needed checking.

## TFAs ruled on

| TFA | Ruling |
|---|---|
| (none proposed by the drafter) | n/a |
| `hn : 2 ≤ n` in S6b (Amendment 1) | APPROVED in advance. It restricts the obligation to the source's own induction range (:219, step for `n ≥ 3` variables). `1 ≤ n` is also acceptable. |

## Item 7: doubts about the source (preliminary only; dispatch pv-issue-checker)

- **A.** :222-223 (S5/S6a). The printed `P(X_n ≥ c)+P(S ≥ x, X_n ≤ c)` and `P(X_n≥c)=F̄_X(c)` hold only if there are no atoms, and the source gives no justification. For real-valued ITS laws, atoms are excluded (item 4 sketch), so in the Lean encoding these steps are true. In the paper's own extended setting (Ex 2.7, mass at `+∞` with atoms at `1/k`), atoms exist and the step can double count. Preliminary class: DOMAIN_CLARIFICATION (possibly PAPER_ARGUMENT_GAP in the extended domain). Dispatch pv-issue-checker.
- **B.** :256 (S10b). The term dropped from the bound is nonpositive, so the claimed `P(S>x) ≥ F̄(x/θ_n)+F̄(x/(1-θ_n))` does not follow. The final `≥ F̄(x)` may still hold by a different argument (`(b+d-a)(1-a) ≥ 0`). Preliminary class: PAPER_ARGUMENT_GAP. Dispatch pv-issue-checker.
- **C.** :95 vs :219. The theorem allows `θ_i = 0` and `n = 1`. The proof treats only positive weights and `n ≥ 2`, and the reduction is unwritten. Preliminary class: EXPOSITION_GAP (likely minor). Dispatch pv-issue-checker.
- **D.** :191/:217 vs Def 2.1. The case `x < 0` is not written. Preliminary class: FAIR_IMPLICIT_STEP (not an issue).

## Required changes

1. `pv_work/T02Draft.lean`, theorem `T02_S6b` (lines 104-105): add the binder `(hn : 2 ≤ n)` (e.g. directly before `(hiid : IIDCopies μ X Xs)`), and mention in the docstring that this is the source's induction range (:219). `1 ≤ n` is also acceptable. No other line may change.
   - Optional, not required: add the same binder to S5, S6a and S7 for uniformity. If the drafter does this, the r2 check will review it.

`T02Stmt.lean` needs no change.

## Statement snapshot

`T02Stmt.lean` (copy `pv_work/probes/gate/T02/gate_T02_stmtcopy.lean`, log `pv_work/logs/gate_T02_stmtcopy_1.log`):
```
TYPE HASHES (current file, 14 declarations)
Paper.T02.Fbar|def|th=390107078|vh=3343139924|bi=ee
Paper.T02.IIDCopies.casesOn|def|th=434416582|vh=1652630351|bi=iciiiiiee
Paper.T02.IIDCopies.ident|thm|th=102015611|vh=-|bi=iciiiiee
Paper.T02.IIDCopies.indep|thm|th=3655323579|vh=-|bi=iciiiie
Paper.T02.IIDCopies.measXs|thm|th=2523711503|vh=-|bi=iciiiiee
Paper.T02.IIDCopies.meas|thm|th=4058452396|vh=-|bi=iciiiie
Paper.T02.IIDCopies.mk|ctor|th=4055493862|vh=-|bi=iciiiieeee
Paper.T02.IIDCopies.noConfusionType|def|th=4126065379|vh=65651301|bi=iiiiiieee
Paper.T02.IIDCopies.noConfusion|def|th=1892530097|vh=2957419864|bi=iiiiiiiiie
Paper.T02.IIDCopies.recOn|def|th=434416582|vh=1442461223|bi=iciiiiiee
Paper.T02.IIDCopies.rec|rec|th=53135905|vh=-|bi=iciiiiiee
Paper.T02.IIDCopies|induct|th=2293504786|vh=-|bi=iceeie
Paper.T02.StDom|def|th=180540177|vh=4122359899|bi=iceee
Paper.T02.T02_L01Consumed|def|th=3944470172|vh=1867989605|bi=
EXIT=0
```

`T02Draft.lean` (copy `pv_work/probes/gate/T02/gate_T02_draftcopy.lean`, log `pv_work/logs/gate_T02_draftcopy_1.log`); pre-amendment, so S6b will change in r2:
```
TYPE HASHES (current file, 14 declarations)
Paper.T02.T02_S10a|thm|th=1489478117|vh=-|bi=eceeeee
Paper.T02.T02_S10b|thm|th=3341842293|vh=-|bi=eceeeee
Paper.T02.T02_S11|thm|th=134606338|vh=-|bi=eceeeee
Paper.T02.T02_S1|thm|th=2536064818|vh=-|bi=iceceeeeeeeeeeeeee
Paper.T02.T02_S2|thm|th=675241779|vh=-|bi=eceeeee
Paper.T02.T02_S3|thm|th=1086017434|vh=-|bi=eeceeeee
Paper.T02.T02_S4|thm|th=2873665920|vh=-|bi=eiceceeeeeeeeeeee
Paper.T02.T02_S5|thm|th=1446304120|vh=-|bi=iceceieeeeeeee
Paper.T02.T02_S6a|thm|th=876163804|vh=-|bi=iceceieeeeeee
Paper.T02.T02_S6b|thm|th=746136603|vh=-|bi=iceceieeeeeeee
Paper.T02.T02_S7|thm|th=928160013|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S8|thm|th=3869777614|vh=-|bi=eceeeee
Paper.T02.T02_S9|thm|th=3301692871|vh=-|bi=ecee
Paper.T02.T02_main|thm|th=703880595|vh=-|bi=eicecieeeeeee
EXIT=0
```

## Overall verdict

The main statement, the step encodings and the external parameter are faithful. One step obligation (S6b) is false as stated outside the source's range, so it needs one amendment. S10b is false as stated, but it faithfully encodes a suspected paper argument gap and must stay as is.

STATEMENT GATE: PASS_WITH_AMENDMENTS

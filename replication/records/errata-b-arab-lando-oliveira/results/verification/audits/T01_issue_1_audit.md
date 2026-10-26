# T01 issue 1: counterexample review (pv-auditor)

- Role: pv-auditor (Claude Opus 5.5), independent subagent, counterexample-review mode
- Date: Tue Oct 13 01:22:54 EDT 2026 (from `date`)
- Audited: `pv_work/T01_Counterexample1.lean` (sha256 1c16f7ae…f06408f4), ruling `verification/audits/T01_issue_1.md`
- Source read directly: `source/SuperParetoPaper-v12.tex` (sha256 88ba28de…eb103294) at :100-219 and :280-339
- Imported definitions read in full: `pv_work/L01Stmt.lean` (3e9b3f0c…d03ad57e), `pv_work/T01Stmt.lean` (3859de1a…a441b), `T01_S2_Gap` at `pv_work/T01ModGaps.lean:110-112` (e47f76e8…c439a52). All hashes equal those quoted in the ruling.

## 1. Encoding fidelity (decisive item)

| Source (F = SuperParetoPaper-v12.tex) | Lean (`PrintedThm28`, lines 26-28) | Judgement |
|---|---|---|
| F:171 "Let $X$ be ITS" | `IsInvSub μ`, `μ` a probability measure (law of $X$) | faithful; F:119 allows identifying r.v. and cdf |
| Def 2.2 F:124: "$X$ such that $F_X(0)=0$ is ITS if $F^-_{1/X}$ is subadditive" | `IsInvSub μ := F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Ioi 0)` | the $F(0)=0$ conjunct is literal; `F` = Mathlib `cdf` = $P(X\le x)$ (F:113) |
| F:171 "$h$ a continuous star-shaped function"; F:111 star-shaped: defined on $[0,\infty)$, $v(0)=0$, $v(x)/x$ increasing (= non-decreasing, F:111) | `Continuous h` (on all of ℝ) ∧ `StarShaped h` (`h 0 = 0 ∧ MonotoneOn (h x / x) (Ioi 0)`) | continuity on ℝ is a stronger premise than on $[0,\infty)$ (allowed); `StarShaped` matches F:111 exactly |
| F:171 "Then $h(X)$ is ITS" | `IsInvSub (μ.map h)` | `μ.map h` is the law of $h(X)$; faithful |

- Not stronger than printed: no printed premise is dropped, one is strengthened (continuity on ℝ), the conclusion is the printed one. Quantification is universal over $X$ and $h$, as printed; nothing is constructed from parameters, the only global objects are the definitions of F:111 and Def 2.2.
- Domain reading of $F^-_{1/X}$ ($(0,\infty)$ in Lean): irrelevant to the refutation, which targets only the $F(0)=0$ conjunct. For the hypothesis side, the instance $X$ is subadditive on $(0,\infty)$, and also on $[0,\infty)$ under the paper's own convention $1-F_X(1/0)=1-F_X(+\infty)=0$ (F:165 uses the completed half line), so no domain choice helps or hurts $X$'s membership.

## 2. The instance satisfies every printed hypothesis

| Hypothesis | Lean witness | Independent check (auditor) |
|---|---|---|
| $X$ is ITS: $F_X(0)=0$ | `isInvSub_μ0`, first conjunct; μ0 is the Stieltjes measure of $g_0(x)=x^+/(1+x^+)$, `F_μ0` via Mathlib `cdf_measure_stieltjesFunction` | $g_0(0)=0$ |
| $X$ is ITS: $1-F_X(1/x)$ subadditive | `isInvSub_μ0`, second conjunct | $1-F_X(1/x)=x/(1+x)$, concave, vanishes at 0, hence subadditive; this is also the law of $Y$ used by the paper itself at F:337 |
| $h$ continuous | `h0_cont`, $h(x)=\max(x-1,0)$ | yes |
| $h$ star-shaped | `h0_star` | $h(0)=0$; $h(x)/x=0$ on $(0,1]$, $=1-1/x$ on $(1,\infty)$: non-decreasing |
| (extra) increasing, convex | `h0_mono`, `h0_convex` | yes; so the counterexample is independent of S0 and fits even the stronger class used at F:337 |

- Searched the source for definitions/conventions that could exclude this instance: F:111 (star-shaped, "increasing" = non-decreasing), F:113 (cdf), F:119, Def 2.2 (F:122-124), Thm 2.8 and proof (F:169-181), Def 4.x super-Pareto (F:286), Thm 4.8 proof (F:337, which explicitly admits "$h$ increasing convex and $h(0)=0$"). No positivity, strict monotonicity or nondegeneracy condition on $h$ appears anywhere. Nothing excludes the instance.
- Conclusion fails: $F_{h(X)}(0)=P(h(X)\le0)=P(X\le1)=g_0(1)=1/2\ne0$ (`F_map_zero`, stated about Mathlib `cdf`; re-checked in my probe). Hence $h(X)$ violates the first conjunct of Def 2.2 under any reading of "ITS".

## 3. The counterexample itself is proved (run by the auditor)

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check T01_Counterexample1` | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `pv_work/logs/T01_Counterexample1_5.log`) |
| `.olean` hash vs ruling | cb3b5727…6ffe01 matches (`python3 scripts/pv_snapshot.py hash`) |
| Probe `pv_work/probes/auditor/T01/aud_T01_issue1.lean` (`scripts/pv_lean.sh probe`) | `exit=0` (log `pv_work/logs/aud_T01_issue1_1.log`) |
| `#pv_axioms T01_Counterexample1` | ALL STANDARD (31 declarations checked) |
| `#pv_walk_decl` on `T01_counterexample` and `not_T01_S2_Gap` | AXIOMS in closure [propext, Classical.choice, Quot.sound]; sorryAx reached: false |
| `#print axioms` on `T01_counterexample`, `not_T01_S2_Gap`, `S2_of_printed`, `subadditive_map` | [propext, Classical.choice, Quot.sound] |
| Earlier project theorems used | none. The walks reach only definitions from `L01Stmt` (`F`, `IsInvSub`, …), `T01Stmt` (`StarShaped`), the def `T01_S2_Gap` (vh=193369578, equal to the gate-snapshot `th` of S2 per the ruling) and the file's own lemmas. No individual audit record of a predecessor theorem is needed. |
| Auditor's own `example` | `IsInvSub μ0 ∧ Continuous h0 ∧ StarShaped h0 ∧ F (μ0.map h0) 0 ≠ 0` and `cdf (μ0.map h0) 0 = 1/2` compile |

## 4. Scope

- **Refuted:** Theorem 2.8 (thm:inclusion, F:171) as printed, specifically the $F_{h(X)}(0)=0$ conjunct of "$h(X)$ is ITS" (`T01_counterexample`); and obligation S2 = `T01_S2_Gap` (`not_T01_S2_Gap`). `S2_of_printed` correctly shows S2 is a consequence of the printed clause.
- **Not refuted:** the subadditivity half of the conclusion (the instance even satisfies it, `subadditive_map`); L01's "only if" direction; Thm 3.1 (F:186-201), Prop 2.5, Examples 2.4/2.6/2.7, which do not use thm:inclusion (I confirm by reading F:140-219 and F:280-339 that thm:inclusion is invoked only at F:337).
- **Downstream:** T03 (Thm 4.8, F:332-337) applies thm:inclusion to exactly this kind of $h$ (increasing convex, $h(0)=0$). The ruling's lead ($X=\max(Z-2,0)$, super-Pareto per F:286, $F_X(0)=P(Z\le2)=1/2$ with $\mathcal P(x)=1-1/x$) is mathematically sound in my reading, but it is reasoning only and is not covered by this counterexample; T03 needs its own ruling.
- The ruling states its scope neither too broadly nor too narrowly.

## 5. Classification

- I agree with **ERROR** (VERDICTS §2.1): the printed conclusion is false and the counterexample satisfies every printed hypothesis (and more). This is a false theorem, not only a failing justification. PAPER_ASSUMPTION_GAP is a defensible secondary description of the remedy (a missing hypothesis on $h$), as the ruling openly says; the primary class ERROR is correct.
- Not ENCODING_ERROR: the failing conjunct is the literal presupposition of Def 2.2 and the value $P(X\le1)=1/2$ does not depend on any representation choice (cdf convention, domain of $1/x$, generalised inverse encoding are all unused by the refutation).
- Distinct from L01_issue_1 (B01): the refutation does not use L01 at all and survives B01's fix.

## 6. Suggested fix

- "$h(x)>0$ for $x>0$": checked. $P(h(X)\le0)\le P(X\le0)+P(X>0,h(X)\le0)=0+0$, so S2 holds. The side remark that it also yields monotonicity is correct: for $0<x<y$, $h(y)=y\cdot h(y)/y\ge y\cdot h(x)/x\ge h(x)$ since $h(x)>0$, $y/x>1$; with $h(0)=0<h(x)$, $h$ is increasing on $[0,\infty)$. So it also removes S0.
- Alternative "$P(h(X)\le0)=0$": removes S2 but **not** S0 (it does not force monotonicity of $h$ off the support); the ruling presents it only as an S2 alternative, which is accurate, but the authors should note it does not cover the "every function considered is increasing" step of F:174.
- Sufficiency for all of Thm 2.8 rests on the remainder of the source route (S1, S3-S6, external tool X02 = Lemma 4.1 of ineq-order2024, corrected L01), which is T01's own pipeline business; I did not verify it here. The ruling correctly marks this as reasoning, not Lean.
- The LESSONS 3 remark (nonconstant / increasing convex is not enough) is correct: the instance is all of these.
- Consequence for T03 (stated by the ruling, correct): T03's $h$ would need e.g. strict increase so that $h>0$ on $(0,\infty)$.

## 7. Not checked by me

- Fréchet variant (gate's instance): reasoning only; consistent ($e^{-1}>0$).
- T03 lead in Lean: not done (not part of this file).

## Conclusion

The encoding of Theorem 2.8 is faithful and not stronger than printed; the instance ($X$ with $F_X(x)=x/(1+x)$, $h(x)=\max(x-1,0)$) satisfies every printed hypothesis and no source convention excludes it; the refutation compiles cleanly with only standard axioms, no `sorryAx`, and uses no unaudited project theorem; the scope (the $F_{h(X)}(0)=0$ conjunct of Thm 2.8 and obligation S2) is stated correctly; classification ERROR is confirmed; the suggested fix $h>0$ on $(0,\infty)$ removes S2 and S0.

COUNTEREXAMPLE VALID

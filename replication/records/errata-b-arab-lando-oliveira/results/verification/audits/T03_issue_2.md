# T03 issue 2: step at :337 "X =d h(Y), h increasing convex and h(0)=0"

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent. Tue Oct 13 2026 (`date` at start: 02:19:56 EDT).
- Inputs: as in `verification/audits/T03_issue_1.md`. Companion ruling: `T03_issue_1.md` (Thm 4.8 false as printed).

## 1. Source (read directly)

- `source/SuperParetoPaper-v12.tex:337`: "Let $Z$ be such that $F_Z=\mathcal{P}$ and $Y=Z-1$, where $F_Y(x)=\frac{x}{x+1}$, for $x\geq0$. Given the shift invariance of the convex transform order, $X$ being super-Pareto is equivalent to $X\stackrel{d}{=}h(Y)$, where $h$ is increasing convex and $h(0)=0$, hence $h$ is star-shaped."
- :284-287 Def 4.1 (super-Pareto: $X\stackrel d=h(Z)$, $h$ increasing, convex, nonconstant; no condition on the value at the left end).
- :308-311 Def 4.5 (convex transform order $F_1\le_c F_2$ iff $F_2^{-1}\circ F_1$ convex).
- :426 (authors): the inverted-subadditive order "is not shift-invariant. In fact, shifts may be crucial in this case".
- :334 hypotheses of Thm 4.8: $X$ nonnegative super-Pareto.

## 2. What is consumed

Only the forward direction, for nonnegative super-Pareto $X$: there is $h$ increasing convex on $[0,\infty)$ with $h(0)=0$ and $X\stackrel d=h(Y)$. The "increasing convex" part is true (take $h(y)=\tilde h(y+1)$ for the $\tilde h$ of Def 4.1). The part "$h(0)=0$" is what makes $h$ star-shaped and is the only content added by the cited "shift invariance". Shift invariance of $\le_c$ gives $\mathcal P\le_c F_X \iff F_Y\le_c F_X$ (as $Y=Z-1$); it says nothing about the value $h(0)=F_X^{-1}(F_Y(0))$, which is the essential infimum of $X$.

## 3. Evidence (Lean, `pv_work/T03_Counterexample2.lean`)

```lean
def PrintedStep337 : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ], Paper.P04.SuperPareto μ → Nonneg μ →
    ∃ g : ℝ → ℝ, MonotoneOn g (Ici 0) ∧ ConvexOn ℝ (Ici 0) g ∧ g 0 = 0 ∧ μ = lawY.map g
```
(forward direction only, i.e. weaker than the printed "is equivalent"; `lawY` = law of $Z-1$, gate-approved in `T03Stmt.lean`).

- `not_PrintedStep337 : ¬ PrintedStep337`, at $X=Z$ (`paretoMeasure`, super-Pareto with $h=\mathrm{id}$, nonnegative). Proof idea (as in the Lean file): if $g(0)=0$ and $g$ is convex, then $g(y)\le y\,g(1)\le1$ for $0\le y\le 1/\max(g(1),1)$, so $P(g(Y)\le1)>0$, while $P(Z\le1)=0$. No continuity or measurability of $g$ is assumed (the non-a.e.-measurable case makes the map the zero measure, contradicting probability).
- `isInvSub_Z`: at this same $X=Z$ the conclusion of Thm 4.8 holds ($Z$ is ITS, as :279 claims). So here the step fails while the conclusion is true.
- `not_DraftS3b : ¬ DraftS3b`: the draft obligation `T03_S3b` (`pv_work/T03Draft.lean:32-34`) is false (instance $X=Z$, $g(y)=y+1$, `lawY_map_succ`). This confirms the gate's flag in Lean.
- `not_T03_T01Consumed : ¬ T03_T01Consumed`: the consumed clause (Thm 2.8 specialised to $Y$, `T03Stmt.lean:30-32`) is refutable with $g(y)=\max(y-1,0)$ (reusing `Paper.T01.Issue1.h0`, `h0_cont`, `h0_star`): $Y$ is ITS (`isInvSub_lawY`, which is obligation S5, proved here as a by-product) but $F_{g(Y)}(0)=1/2$. This confirms gate item 6 in Lean: any proof of `T03_main` must not use `hT01` ex falso.
- `consumed_of_printed`: $Z$ is a probability law, super-Pareto, nonnegative, and ITS.
- Where the conclusion also fails: for $X=Z+1$ (instance B of issue 1) the only representation has $h(y)=y+2$, $h(0)=2$, and $X$ is not ITS (`Paper.T03.Issue1.not_inv_B`).

Compilation: `scripts/pv_lean.sh build T03_Counterexample2` -> `RESULT T03_Counterexample2 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T03_Counterexample2_3.log olean=pv_work/T03_Counterexample2.olean`. `EXIT=0`.
Axioms (log lines 1-2, 31-32, 56-57, 98-99, 133-136): `not_PrintedStep337`, `not_DraftS3b`, `not_T03_T01Consumed`, `consumed_of_printed` each depend on `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false`. Modules reached: `L01Stmt`, `P04Stmt`, `T01Stmt`, `T03Stmt`, `T03_Counterexample1`, `P04_Counterexample2` (`pareto_Icc_pos`), `T01_Counterexample1` (`h0`, `h0_cont`, `h0_star`).

## 4. Classification: PAPER_ARGUMENT_GAP

- The sentence at :337 asserts a false intermediate claim (Lean refutation above), and the cited justification ("shift invariance of the convex transform order") cannot give $h(0)=0$: shifting $Y$ or $X$ changes $h(0)$, and the authors themselves note at :426 that ITS is not shift-invariant. The given justification fails: PAPER_ARGUMENT_GAP.
- Not EXPOSITION_GAP: no range or case is merely left uncovered; the argument itself is wrong for every $X$ with positive essential infimum.
- Not FAIR_IMPLICIT_STEP: no competent reader can fill in $h(0)=0$; it is false (e.g. $X=Z$).
- Not ERROR as a separate item: the printed conclusion's falsity is recorded once, in `T03_issue_1.md` (ERROR). This item records where the proof breaks.
- Not ENCODING_ERROR: the claim is encoded in the weakest form the proof uses (forward direction, ∃-form), with gate-approved definitions.

## 5. Does it threaten the conclusion?

- Yes. The gap is not benign. For instance B of issue 1 ($X=Z+1$) the step fails and the conclusion of Thm 4.8 fails too. The proof cannot be saved for the printed scope by another justification of this step. (For $X=Z$ the step fails but the conclusion holds.)
- Downstream numbered results: none consume T03. **Unaffected**: all other numbered results. The consumed clause `T03_T01Consumed` is refuted, so T03 cannot be reported CONDITIONAL on it (consistent with gate item 6).
- Other steps of :337: S5 ("Y is ITS") is true, now proved in Lean (`isInvSub_lawY`), so it is at most a FAIR_IMPLICIT_STEP (no separate ruling requested). S4 (continuity) was not examined here.

## 6. Suggestion to the authors (minimal)

Restrict Thm 4.8 as in `T03_issue_1.md` §6 ($F_X(0)=0$ and $F_X(x)>0$ for $x>0$, i.e. $X\stackrel d=h(Z)$ with $h(1)=0$, $h>0$ on $(1,\infty)$). Under that hypothesis "$h(0)=0$" at :337 follows from Def 4.1 directly ($h(0)$ is the essential infimum of $X$), and the reference to shift invariance can be deleted. Constructed by the reviewer, not in the source, suggestion only, not used in any verification (reasoning, not checked in Lean).

## 7. Not checked

- The suggested repair (reasoning only).
- Whether some other representation (not of the form $h(Y)$) could rescue the route: irrelevant, since the conclusion itself fails (issue 1, instance B).

## 8. Review

Lean evidence: needs `pv-auditor` counterexample-review mode. Not confirmed until that review passes.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: yes

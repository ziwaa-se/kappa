# T03 issue 1: Theorem 4.8 (cor:inclusion) false as printed ("nonnegative" does not suffice)

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent. Started Tue Oct 13 02:19:56 EDT 2026 (`date`).
- Inputs read: `verification/audits/T03_gate.md`, `pv_work/notes/T03_draft_notes.md`, `pv_work/T03Stmt.lean`, `pv_work/T03Draft.lean`, `pv_work/P04Stmt.lean`, `pv_work/L01Stmt.lean`, `pv_work/T01Stmt.lean`, `pv_work/T01_Counterexample1.lean`, `pv_work/P04_Counterexample2.lean`, `pv_work/T02_Counterexample1.lean`, `verification/audits/T01_issue_1.md` (verdict lines and T03 mentions), `verification/INVENTORY.md` (T03 rows).
- Companion ruling: `verification/audits/T03_issue_2.md` (the step "h(0)=0" at :337).

## 1. Source (read directly)

- `source/SuperParetoPaper-v12.tex:332-335`: "If $X$ is nonnegative super-Pareto then $X$ is \ITS."
- :122-124 (Def 2.2): "We say that a random variable $X$ such that $F_X(0)=0$ is \ITS\ ... if $F_{\frac1X}^-$ is subadditive", with :121 $F^-_{1/X}(x)=1-F_X(1/x)$.
- :111: "increasing" = non-decreasing; subadditive = $v(x+y)\le v(x)+v(y)$ on the domain of $v$.
- :279: $\mathcal P(x)=1-\frac1x$, $x\ge1$.
- :284-287 (Def 4.1): "$Y$ is super-Pareto if $Y\stackrel d=h(Z)$, where $F_Z=\mathcal P$ and $h$ is an increasing, convex and nonconstant function."
- :337 (proof): "... $X$ being super-Pareto is equivalent to $X\stackrel d=h(Y)$, where $h$ is increasing convex and $h(0)=0$, hence $h$ is star-shaped. ..."
- :426 (later remark by the authors): "this new order is not shift-invariant. In fact, shifts may be crucial in this case, since we are dealing with inverted distributions."

## 2. What is consumed

Thm 4.8 is a terminal result: the source cites `cor:inclusion` nowhere else (grep of the source for `cor:inclusion` gives only :333). The clause under test is the printed statement itself, for every nonnegative super-Pareto $X$. No instance-restriction rescue (LESSONS 2) is available: the theorem is a universal statement and its own hypotheses are what the instances below satisfy.

## 3. Counterexamples (Lean, `pv_work/T03_Counterexample1.lean`)

Encoding: the gate-approved `Paper.P04.SuperPareto` (Def 4.1), `Paper.T03.Nonneg` ("nonnegative" = $\mu(-\infty,0)=0$), `Paper.L01.IsInvSub` (Def 2.2). The printed clause:

```lean
def PrintedThm48 : Prop :=
  ∀ (μ : Measure ℝ) [IsProbabilityMeasure μ],
    Paper.P04.SuperPareto μ → Nonneg μ → IsInvSub μ
```

This is the printed statement verbatim, no premise dropped, no conclusion strengthened.

**Instance A: $X=\max(Z-2,0)$** (`μA = paretoMeasure.map hA`, `hA z = max (z-2) 0`).
- super-Pareto: `hA` is measurable, monotone, convex on $[1,\infty)$, nonconstant ($h_A(1)=0$, $h_A(3)=1$), and `μA = paretoMeasure.map hA` by definition (`sp_A`).
- nonnegative: $h_A\ge0$, so $\mu_A(-\infty,0)=0$ (`nonneg_A`).
- $F_X(0)=P(Z\le2)=1/2$ (`F_A_zero`, computed from the Pareto density), so the $F_X(0)=0$ requirement of Def 2.2 fails (`not_inv_A`).
- `theorem not_PrintedThm48 : ¬ PrintedThm48`.

**Instance B: $X=Z+1$** (`μB = paretoMeasure.map (· + 1)`). This instance defeats the obvious repair "positive" / "$F_X(0)=0$".
- super-Pareto ($h(z)=z+1$ increasing, convex, nonconstant) (`sp_B`); nonnegative (`nonneg_B`); and **$F_X(0)=0$** (`F_B_zero`, indeed $X\ge2$).
- $1-F_X(1/x)$ is not subadditive: at $x=y=1/4$, $1-F_X(2)=1-P(Z\le1)=1$ while $1-F_X(4)=1-P(Z\le3)=1/3$, and $1>1/3+1/3$ (`not_inv_B`).
- `def PrintedThm48Pos` = `PrintedThm48` plus the extra premise `F μ 0 = 0` (weaker than printed; `pos_of_printed : PrintedThm48 → PrintedThm48Pos`). `theorem not_PrintedThm48Pos : ¬ PrintedThm48Pos`.

Scope lemma `consumed_of_printed`: both instances are probability laws satisfying every printed hypothesis (B also `F_X(0)=0`). A fails exactly the $F_X(0)=0$ conjunct of Def 2.2; B fails exactly the subadditivity conjunct.

Robustness to readings (reasoning, not checked in Lean beyond what is stated):
- Domain of $F^-_{1/X}$: B fails at the points $1/4,1/4,1/2\in(0,\infty)$, which lie in every candidate domain ($(0,\infty)$, $[0,\infty)$, $(0,\infty]$).
- "Nonnegative" read as "support starting at 0" (essential infimum 0) instead of "$X\ge0$ a.s.": B is excluded, but A (essential infimum 0, atom at 0) still satisfies it and still fails. No natural reading of "nonnegative" excludes both A and B.
- Prop 4.3 / DOR are not used: the instances are checked against Def 4.1 directly, which is the definition of super-Pareto in the paper. (Under Prop 4.3, $1/\Fbar_{X}$ for B is $x-1$ on $[2,\infty)$, concave on the support; for A it is $x+2$ on $[0,\infty)$; consistent with super-Pareto on the support domain chosen in P04.)
- The encoding of `SuperPareto` asks more than the printed definition (measurable $h$); extra requirements only make the instances harder to satisfy, and they are satisfied.

Compilation: `scripts/pv_lean.sh build T03_Counterexample1` -> `RESULT T03_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T03_Counterexample1_2.log olean=pv_work/T03_Counterexample1.olean`. `EXIT=0`.
Axioms (`#print axioms` and `#pv_walk_decl`, log lines 1-2, 40-41, 82-83, 133-135): `not_PrintedThm48`, `not_PrintedThm48Pos`, `consumed_of_printed` each depend on `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false`. The walk reaches only `L01Stmt`, `P04Stmt`, `T03Stmt` (gate-approved definitions) and the file itself. The Pareto computations (`tail`, `Iic_one`, `univ_eq`, `F_P_*`) are copied from `pv_work/T02_Counterexample1.lean`; `pm_eq` proves the copied density equals `Paper.P04.paretoMeasure`.

## 4. Classification: ERROR

- VERDICTS §2: the printed conclusion is false; Lean counterexamples satisfy every printed hypothesis. This is not only a failing justification.
- Not PAPER_ASSUMPTION_GAP as the primary class: there is a missing hypothesis, but the result as printed is false, and the obvious candidate ("positive", "$F_X(0)=0$", the drafter's label) does not repair it (instance B; LESSONS 3). The repair needed is a condition on the location of the support, not on the atom at 0 only.
- Not DOMAIN_CLARIFICATION: §3 shows the statement fails under each reading of "nonnegative" and of the domain of $F^-_{1/X}$.
- Not ENCODING_ERROR: definitions are the gate-approved ones, faithful to :111, :122-124, :284-287; instances satisfy stronger forms than printed.

Mechanism (two independent failures):
1. Atom at 0 (instance A): same mechanism as T01_issue_1 (Thm 2.8 with $h$ vanishing on $[0,1]$).
2. Shift (instance B): the ITS class is not shift-invariant (the authors say so themselves at :426), while super-Pareto is invariant under $X\mapsto X+c$; at :337 the proof uses "shift invariance of the convex transform order" to normalise $h(0)=0$, which a shift cannot achieve for the inverted distribution. See `T03_issue_2.md`.

## 5. Does it threaten the conclusion?

- Thm 4.8 as printed: **yes, false** (two Lean counterexamples).
- Downstream numbered results: none (`cor:inclusion` cited nowhere else; INVENTORY lists no consumer). **Unaffected**: T01, T02, T04, L01, L02, P01-P06 do not depend on T03.
- Prose affected: introduction :107 ("This class, denoted as \ITS, includes ... under some conditions on the convex transformation, all the other classes discussed"); the conditions must include those of §6. :331 ("we relate the super-Pareto class with the \ITS\ family") also affected.
- Note for the record: Thm 4.8 holds for some nonnegative super-Pareto laws, e.g. $X=Z$ itself (Lean: `Paper.T03.Issue2.isInvSub_Z` in `pv_work/T03_Counterexample2.lean`), but not for all.

## 6. Suggestion to the authors (minimal)

Replace "nonnegative" by "with $F_X(0)=0$ and $F_X(x)>0$ for every $x>0$" (that is, $X>0$ a.s. with essential infimum $0$; equivalently $X\stackrel d=h(Z)$ with $h(1)=0$ and $h>0$ on $(1,\infty)$).

Why it suffices (constructed by the reviewer, not in the source, suggestion only, not used in any verification; reasoning, not checked in Lean): then $h(Y+1)=:g(Y)$ with $g$ increasing convex, $g(0)=0$, $g>0$ on $(0,\infty)$, $g$ continuous and $g\to\infty$. For $x>0$, $\Fbar_X(x)=1/(1+g^{-1}(x))$. Put $\varphi(s)=1-F_X(1/s)=1/(1+g^{-1}(1/s))$. Since $g$ is star-shaped, $g^{-1}(u)/u$ is non-increasing, so $s\,g^{-1}(1/s)$ is non-decreasing in $s$; hence $\varphi(s)/s=1/(s+s\,g^{-1}(1/s))$ is non-increasing, and $\varphi\ge0$ anti-star-shaped on $(0,\infty)$ is subadditive. $F_X(0)=P(g(Y)\le0)=P(Y=0)=0$. Both instances are excluded (A has an atom at 0; B has essential infimum 2). Under this hypothesis the paper's own route at :337 also works ($h(0)=0$ holds, and Thm 2.8 with the T01 repair "$h>0$ on $(0,\infty)$" applies).
The condition is sufficient, not necessary ($X=Z$ violates it but is ITS). The authors may prefer another formulation; "positive" alone is not enough (instance B).

## 7. Not checked

- The sufficiency argument in §6 (reasoning only).
- Equivalence of the "∃ h" reformulation in §6 with the cdf condition (reasoning only).
- Readings of "nonnegative" in §3 other than the encoded one (reasoning only; the encoded reading is the gate-approved one).

## 8. Review

Lean counterexample: needs `pv-auditor` counterexample-review mode. Not confirmed until that review passes.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes

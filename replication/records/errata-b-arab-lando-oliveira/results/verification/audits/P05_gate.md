# P05 statement gate (Proposition cor:invNWU, source F:429-436)

- Reviewer: pv-gate (independent subagent, Claude Opus), first gate report.
- Date: Tue Oct 13 02:15:47 EDT 2026 (from `date`).
- Source: `source/SuperParetoPaper-v12.tex` (abbreviated F), read directly at F:100-154, F:330-444.

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

| File | sha256 |
|---|---|
| pv_work/P05Stmt.lean | b5c0badc472d23cdb60f66e3845088f050a803a30c72cb65898db075da0ad72b |
| pv_work/P05Draft.lean | 5a454bb8cf5bc47fff1a6f5699fa4e0333836266b1ca43a8bbabc05f388c36d2 |
| pv_work/L02Stmt.lean (imported, definitions only) | caf65f96097f30510613ecbaae09a9c88816a2a2da4b1ac2edc1d2a5b5256d1f |
| pv_work/L01Stmt.lean (imported via L02Stmt) | 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e |
| pv_work/notes/P05_draft_notes.md (leads only) | 5050ce9bb95d2fb5fbcffe40d3bbb590760357eed1e0fd013a30fcbdcd681894 |

## Compilation

- `scripts/pv_lean.sh check P05Draft`: `RESULT P05Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/P05Draft_2.log olean=none`. The 4 sorries are S1, S2, S3 and P05_main, as expected for a draft.
- Snapshot probes: `gate_P05_stmtcopy` exit=0, 0 sorry (log pv_work/logs/gate_P05_stmtcopy_1.log); `gate_P05_draftcopy` exit=0, 4 sorry (log pv_work/logs/gate_P05_draftcopy_1.log).

## Source quotations

- F:111: "the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}:\,v(x)\leq u\}$ ... a function $v$ is said to be subadditive if $v(x+y)\leq v(x)+v(y)$, for every $x,y$ in the domain of $v$."
- F:113: "$F_X^-(x)=\Prob(X<x)$ the left-continuous cumulative distribution function".
- F:119: orders and characterisations "depend only on the cumulative distribution functions".
- F:142: "$\mathcal{H}(x)=e^{-1/x}$, for $x>0$".
- F:345-349 (Def 4.9(1)): "We say that a random variable $X$ such that $F_X(0)=0$ is ... super-heavy-tailed if $-\Log F_X(\frac1x)$ is subadditive".
- F:422-425 (Def 5.1): "$F_1\leq_{i-sb}F_2$, if $\frac{1}{F_2^{-1}(F_1^-(\frac1x))}$ is subadditive."
- F:426: "... it is also clear that the inverted-subadditive order rules out distributions whose supports strictly include the origin."
- F:429-432 (statement): "A random variable $X$ is super-heavy-tailed if and only if $F_X\leq_{i-sb}\mathcal{H}$."
- F:433-436 (proof): "Note that $\mathcal{H}^{-1}(p)=-\frac1{\Log p}$, so $\frac{1}{\mathcal{H}^{-1}(F_X(\frac1x))}=-\Log(F_X(\frac1x))$."
- Contrast F:442 (next proposition): "A random variable $X$ such that $F_X(0)=0$ is \ITS\ if and only if ..." (qualifier printed there, absent at F:431).

## Item 1. Hypotheses: PASS

- The source statement has no hypothesis beyond "a random variable $X$". `P05Conclusion μ` is for an arbitrary `μ : Measure ℝ` with no extra premise. No `structure`, type class, `variable` or hidden premise in P05Stmt, L02Stmt (`negLogInv`, `SubadditiveOnE`, `IsSuperHeavyTailed`) or L01Stmt (`F μ := ProbabilityTheory.cdf μ`).
- Not requiring `IsProbabilityMeasure μ` is harmless: I checked Mathlib `Probability/CDF.lean:58-70,82`: `cdf μ` is nonnegative, at most 1, monotone, tends to 0 and 1 for every `μ`, and is the cdf of the probability measure `(cdf μ).measure`. Quantifying over all `μ` is therefore equivalent to quantifying over probability laws. It neither strengthens nor weakens the statement, and does not by itself produce counterexamples. Any counterexample should still use a probability measure, for example `dirac 0`.
- The conclusion does not appear as a hypothesis anywhere.

## Item 2. Conclusion: PASS

- `IsSuperHeavyTailed μ ↔ InvSubLE (F μ) Hcdf` is the printed biconditional. Neither direction is missing, weakened or strengthened.
- "super-heavy-tailed" is the L02 definition, including the presupposition `F μ 0 = 0` from F:346. This literal reading follows Def 4.9: the class is defined only for $X$ with $F_X(0)=0$, so any other $X$ is not super-heavy-tailed. The L02 gate and L02_issue_1 already discussed and accepted this definition, and only the definition is reused here. L02's recorded issue concerns the L02 lemma clause, not the definition.
- Def 5.1 is encoded literally, with the left-continuous `F_1^-` from F:424 (`leftVer = Function.leftLim`, which equals `P(X<x)` for a monotone function on ℝ), the generalised inverse from F:111 (`genInv`, an `EReal` supremum) and the reciprocal (`recipE`). The draft keeps the mismatch with the proof's `F_X(1/x)` (F:434) visible: the order uses `F^-` and the proof uses `F` (S2, S3). It is not smoothed over.

## Item 3. Quantifiers and constants: PASS

There are no constants. The theorem is universal in `μ`, and the order is a property of the pair `(F μ, Hcdf)`. This matches the source.

## Item 4. Domains and details: PASS (with recorded observations)

- **Values of `recipE` at 0 and at `⊤` (drafter's convention).** For `u ∈ [0,1]`: `genInv Hcdf 0 = 0` (set `(-∞,0]`), `genInv Hcdf 1 = ⊤` (set `ℝ`, since `Hcdf < 1`), and `genInv Hcdf u = -1/log u` for `u ∈ (0,1)`. With `1/0 = ⊤` and `1/⊤ = 0`, `invSubFn F Hcdf x` is exactly `-Log F^-(1/x)` with `-Log 0 = +∞`. This is the same `EReal` convention L02 uses for `negLogInv`. It is the only monotone, continuous extension, and it introduces no content the source lacks. Approved as a notation convention, not a TFA. The values `⊥` and the junk `recipE ⊥ = 0` are never reached, because `F` takes values in `[0,1]`.
- **`Hcdf x = 0` for `x ≤ 0`.** The source gives ℋ only on `x>0` (F:142). Extending a cdf by 0 is the standard reading. It only affects `genInv Hcdf 0 = 0` (so `-Log 0 = +∞`), which is consistent with the intended formula.
- **Domain of the order function, read as `(0,∞)`.** This is a reading choice. F:111 says "every x,y in the domain of v", and the natural domain of `x ↦ 1/F_2^{-1}(F_1^-(1/x))` is `ℝ∖{0}`. The remark at F:426 ("the order rules out distributions whose supports strictly include the origin") makes sense only if negative `x` are in the domain. Under `(0,∞)` the order ignores the negative mass of `X` entirely. Under `ℝ∖{0}` (with `x+y ≠ 0`) one can check that `P(X<0)>0` violates subadditivity: take `a<0` far out so that `v(a)` is finite, and `y=-a+z` with `z↑0` so that `v(z)` goes to `+∞`. **Consequence for the statement:** the two readings are equivalent whenever `F_X(0)=0`, since then `v=+∞` on `x<0` and every mixed-sign inequality holds trivially. So the domain choice does not change the truth of P05 under either reading of the qualifier discussed in item 7. It does change which witnesses are valid: the drafter's witness `X = -1` a.s. exists only under the `(0,∞)` reading. `X = 0` a.s. works under both readings: `v = 0` on `x>0`, `v = +∞` on `x<0`, so the order holds, while `F_X(0)=1`. **No statement change is required.** The issue checker must not rest an ERROR on `X=-1` alone, because that witness depends on our domain choice (POLICY §1: our representation choices must never manufacture a paper error).
- Equality is pointwise, and no a.e. equality, measurability or `ENNReal` truncation is involved. `F μ (1/x)` is used only at `x>0`, so Lean's `1/0=0` is never reached. `SubadditiveOnE` on `Ioi 0` is closed under `x+y`.
- Periodicity, existence or construction, and finiteness are not involved.

## Item 5. Step obligations: PASS

| Step | Source | True as stated? | Comment |
|---|---|---|---|
| P05_S1 | F:434 "ℋ^{-1}(p) = -1/Log p" | Yes. For `p∈(0,1)`, `{x : Hcdf x ≤ p} = (-∞, -1/log p]` | Restricting the range to `(0,1)` is a fair reading (the formula has no meaning at `p=0,1`). It does not smuggle anything in. |
| P05_S2 | F:434 "1/ℋ^{-1}(F_X(1/x)) = -Log F_X(1/x)" | Yes, for `x>0`, all three cases `F=0`, `F∈(0,1)`, `F=1`, with the `EReal` conventions above | Written with `F_X`, as printed. |
| P05_S3 | not printed. It bridges F:424 (`F^-`) and F:434 (`F`) | **I believe it is true as stated.** `g(x) := -Log F(1/x)` is increasing and left-continuous in `x`, `g^-(x) := -Log F^-(1/x)` is its right-continuous version, `g^-(x) = g(x+)` and `g(x) = g^-(x-)`. Taking one-sided limits in the subadditivity inequality transfers it in both directions: values are in `[0,+∞]`, and `EReal` addition is continuous away from `⊤+⊥`. This is my own check, not a ruling. | Correctly labelled as unprinted. It is not stronger than what the proof needs. |
| P05_main | F:431 | **Not an obligation that the steps prove.** S2+S3 give `InvSubLE (F μ) Hcdf ↔ SubadditiveOnE (negLogInv μ) (Ioi 0)`, that is, the second conjunct of `IsSuperHeavyTailed`. The conjunct `F μ 0 = 0` in the direction order ⇒ super-heavy-tailed has no source step, and a preliminary witness (`X=0` a.s.) suggests that it fails. | The drafter flags this in the docstring and the notes. This is the target statement itself, not an encoding defect. I am not modifying it (see item 7). |

Assembly: S1 to S3 assemble exactly to the second conjunct. The gap is exactly the `F_X(0)=0` presupposition, which the source never addresses. None of S1 to S3 is false as stated, and none smuggles in the target conclusion.

## Item 6. External parameters: PASS (none)

The files contain no `def … : Prop` tool and no consumed clause. Nothing is cited externally at F:429-436. `Function.leftLim` exists in Mathlib (the draft uses it and compiles).

## Item 7. Doubts about the source (preliminary; dispatch pv-issue-checker)

1. **F:431 vs F:346, missing `F_X(0)=0` qualifier.** In the direction `F_X ≤_{i-sb} ℋ ⇒` super-heavy-tailed, nothing in the order forces `F_X(0)=0`. Preliminary witness: `X = 0` a.s. (`μ = dirac 0`). It is valid under both domain readings, whereas `X=-1` is valid only under `(0,∞)`. Compare F:442, where the qualifier is printed for the parallel P06. Preliminary class: **PAPER_ASSUMPTION_GAP**, with **DOMAIN_CLARIFICATION** as the alternative if F:346 is read as a standing restriction. This is the same pattern as the L02_issue_1 ruling. → dispatch pv-issue-checker.
2. **F:434 vs F:424, `F_X` in the proof versus `F_X^-` in the order.** The step is unprinted (S3). By my own preliminary check it holds by a one-sided-limit argument (F:428 says the result avoids "continuity difficulties"). Preliminary class: **FAIR_IMPLICIT_STEP** (at most EXPOSITION_GAP). The drafter's candidate PAPER_ARGUMENT_GAP looks too strong. Let the prover attempt S3. Dispatch pv-issue-checker only if the prover cannot close it.
3. **Endpoint values `p=0,1` of ℋ^{-1}, and the unstated `1/0`, `1/∞` conventions (F:434).** Preliminary class: **EDITORIAL**. These are not issues.
4. **Domain of the order function (F:111/F:424 vs F:426).** This is not an issue for P05 (see item 4). It is a note for the issue checker and for the reuse of `InvSubLE` in P06, where `F_X(0)=0` is assumed and the two readings coincide.

## TFA table

| Premise | Ruling |
|---|---|
| (none; no extra premises) | n/a |
| Conventions `1/0=+∞`, `1/+∞=0` (`recipE`), `Hcdf = 0` on `x≤0` | Approved as notation conventions (not premises). Consistent with L02's `-Log 0 = +∞`. |

## External parameter table

None.

## Required changes

None. The encoding is faithful. The suspected gap in item 7.1 must stay visible and must not be repaired in the statement.

## Statement snapshot

`gate_P05_stmtcopy` (copy of pv_work/P05Stmt.lean; log pv_work/logs/gate_P05_stmtcopy_1.log):
```
TYPE HASHES (current file, 8 declarations)
Paper.P05.Hcdf|def|th=3468892319|vh=1185174597|bi=e
Paper.P05.InvSubLE|def|th=3790785477|vh=179506999|bi=ee
Paper.P05.P05Conclusion|def|th=3905129696|vh=484750008|bi=e
Paper.P05.genInv|def|th=3872505921|vh=2805129803|bi=ee
Paper.P05.invSubFn|def|th=638356854|vh=3233979262|bi=eee
Paper.P05.leftVer|def|th=2287483187|vh=423012314|bi=ee
Paper.P05.recipE.match_1|def|th=3213798033|vh=556873898|bi=eeeee
Paper.P05.recipE|def|th=2418022539|vh=2323887027|bi=e
EXIT=0
```

`gate_P05_draftcopy` (copy of pv_work/P05Draft.lean; log pv_work/logs/gate_P05_draftcopy_1.log):
```
TYPE HASHES (current file, 4 declarations)
Paper.P05.P05_S1|thm|th=2539469217|vh=-|bi=ee
Paper.P05.P05_S2|thm|th=3799278201|vh=-|bi=eee
Paper.P05.P05_S3|thm|th=2550856191|vh=-|bi=e
Paper.P05.P05_main|thm|th=2049719506|vh=-|bi=e
EXIT=0
```

## Overall verdict

The statement is faithful. The obligations S1, S2 and S3 are true as stated, by my preliminary check. P05_main is the printed target, and it is suspected false because of the missing `F_X(0)=0` qualifier. That issue is for pv-issue-checker, not an encoding defect.

STATEMENT GATE: PASS

# T03 statement gate (Theorem 4.8, `cor:inclusion`)

- Reviewer: pv-gate (Claude Opus 5.5), independent subagent; no part of the draft written by me.
- Date: Tue Oct 13 02:15:41 EDT 2026 (`date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T03Stmt.lean` bbdcfd41f6aab15d2f23aa086365ff04a529ff9187908401b5f8f0691a7606c9
  - `pv_work/T03Draft.lean` 1d54bfbb96925c2ee5d4a3e1e097f2620ac54251bb1350a2f95c56386a5ca9b0
  - `pv_work/T03Stmt.olean` 6ef1b66ec9a9c44be101f66ae63e0bf5de58b330a7137b58a44865118a7f930f
  - `pv_work/notes/T03_draft_notes.md` 49a97b4a4eaf7663923df3df2b80ca69d6b9d1b0f5346e3733cd759c066e413b (leads only)
  - probe copies: `pv_work/probes/gate/T03/gate_T03_stmtcopy.lean` dda292ff…a451f, `gate_T03_draftcopy.lean` 268079df…37e82
  - source `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
- Imported definitions read in full: `pv_work/T01Stmt.lean` (StarShaped), `pv_work/L01Stmt.lean` (F, invDist, SubadditiveOn, IsInvSub), `pv_work/P04Stmt.lean` (F, Fbar, Lam, suppIn, paretoMeasure, DOR, SuperPareto, P04_X01Tool).
- Compilation: `scripts/pv_lean.sh check T03Draft` -> `RESULT T03Draft mode=check exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0 log=pv_work/logs/T03Draft_2.log`. EXIT=0. The 8 sorries are the 7 obligations plus `T03_main` (draft, allowed).

## Source quotations (read directly)

- :111 conventions: "increasing" = non-decreasing; generalised inverse; star-shaped: "$v$ defined in $[0,+\infty)$ ... $v(0)=0$ and $v(x)/x$ is increasing".
- :113 $F_X$, $\Fbar_X=1-F_X$, $\Lambda_X=F_X/\Fbar_X$.
- :122-124 Def 2.2: "a random variable $X$ such that $F_X(0)=0$ is ITS if $F^-_{1/X}$ is subadditive", with $F^-_{1/X}(x)=1-F_X(1/x)$ (:121).
- :169-172 Thm 2.8: "Let $X$ be ITS and $h$ a continuous star-shaped function. Then $h(X)$ is ITS."
- :279 $\mathcal P(x)=1-1/x$, $x\ge1$.
- :284-287 Def 4.1: "$Y$ is super-Pareto if $Y\stackrel d= h(Z)$, where $F_Z=\mathcal P$ and $h$ is an increasing, convex and nonconstant function."
- :296-299 Prop 4.3 (cited, Prop 1 of superPareto2024): super-Pareto iff $1/\Fbar_X$ concave. :301 $\Lambda_X=1/\Fbar_X-1$. :304-307 Def 4.4 DOR: $\Lambda_X$ concave.
- :332-335 Thm 4.8: "If $X$ is nonnegative super-Pareto then $X$ is ITS."
- :336-338 proof: "According to Proposition 4.3, $X$ is nonnegative DOR. Let $Z$ be such that $F_Z=\mathcal P$ and $Y=Z-1$, where $F_Y(x)=\frac{x}{x+1}$, for $x\ge0$. Given the shift invariance of the convex transform order, $X$ being super-Pareto is equivalent to $X\stackrel d=h(Y)$, where $h$ is increasing convex and $h(0)=0$, hence $h$ is star-shaped. It is straightforward to verify that $Y$ is ITS, so the conclusion follows by applying Theorem 2.8."

## Item 1. Hypotheses: PASS

- "nonnegative" (:334) -> `Nonneg μ := μ (Set.Iio 0) = 0` (T03Stmt:18). Faithful: it is exactly "X ≥ 0 a.s.", and it correctly does **not** add $F_X(0)=0$ (adding it would rescue the theorem; see item 7).
- "super-Pareto" -> `Paper.P04.SuperPareto μ` (gated and final-audited in P04; Def 4.1 with $h$ on $[1,\infty)$, monotone, convex, nonconstant, measurable). Reused, not redeclared.
- "random variable X" -> law `μ` with `[IsProbabilityMeasure μ]` (convention :119). Harmless.
- Extra binders: `hX01 : P04_X01Tool` and `hT01 : T03_T01Consumed`, both visible parameters (item 6). No extra premise on `μ`; no TFA candidates. No hidden hypotheses in `structure`s, classes or `variable`s (none used; imported defs are plain `def`s).
- No conclusion-as-hypothesis form: neither parameter mentions `μ`, and neither states `IsInvSub` of an arbitrary super-Pareto law (but see item 6 on refutability of `T03_T01Consumed`).

## Item 2. Conclusion: PASS

`Paper.L01.IsInvSub μ` = `F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Ioi 0)`, Def 2.2 as gated in L01. Neither weakened nor strengthened; single clause.

## Item 3. Quantifiers / constants: PASS

No constants. `μ` universally quantified after the parameters; the parameters are closed `Prop`s, so they do not depend on `μ`. Matches the source.

## Item 4. Domains and details: PASS

- `lawY := paretoMeasure.map (· - 1)` (T03Stmt:21): law of $Y=Z-1$, faithful to :337. `paretoMeasure` is P04's Pareto(1) law (density $x^{-2}$ on $(1,\infty)$).
- Equality of laws `μ = lawY.map g` encodes $X\stackrel d= h(Y)$; correct notion.
- `Measure.map` junk: `lawY.map g` is `0` when `g` is not a.e.-measurable. In S3a/S3b/main `μ` is a probability measure, so `μ = lawY.map g` forces a.e.-measurability; in S4 `g` agrees `lawY`-a.e. with the continuous `g ∘ max · 0` (`lawY (Iio 0) = 0`), so the map is not junk. No trap.
- No `ENNReal.ofReal`/`toReal` in T03's own statements (`paretoMeasure`'s density uses `ofReal` of a nonnegative quantity: fine, P04-gated).
- Star-shaped domain `(0,∞)` and `v 0 = 0` (T01Stmt:10-11) faithful to :111.

## Item 5. Step obligations

| Obligation | Source | Faithful | True as stated? | Smuggling? |
|---|---|---|---|---|
| S1 `Nonneg μ ∧ DOR μ` from X01 | :337 s.1 | yes | yes: X01 forward gives `F<1` and concavity of `1/Fbar` on `suppIn`; `Lam = 1/Fbar - 1` there (:301) | no |
| S2 `F lawY x = x/(x+1)`, `x ≥ 0` | :337 | yes | yes: $P(Z\le x+1)=1-\frac1{x+1}$ | no |
| S3a `∃ g` monotone, convex on `Ici 0`, `μ = lawY.map g` | :337 "X super-Pareto is equivalent to X =d h(Y), h increasing convex" (forward direction, the only one used) | yes; uses Def 4.1 directly with `g(y)=h(y+1)` instead of the cited "shift invariance of ≤_c"; a change of form, same claim | yes | no |
| S3b `g 0 = 0` for every such representation | :337 "and $h(0)=0$" | yes. The `∀ g` form is equivalent to the source's `∃ h` form: for `μ = lawY.map g`, `g` monotone convex on `[0,∞)` is pinned on `(0,∞)` (quantile of `μ` against continuous `F_Y`) and `g 0 = g(0+)` (monotone gives ≤, convexity gives ≥) | **FALSE AS STATED.** Instance: `μ = paretoMeasure` ($X=Z$, nonnegative), `g y = y + 1` (monotone, convex), `lawY.map g = paretoMeasure`, `g 0 = 1 ≠ 0`. (Reasoning, not checked in Lean.) This is the drafter's own flag. | no |
| S3c convex on `Ici 0`, `g 0 = 0` ⇒ `StarShaped g` | :337 "hence h is star-shaped" | yes | yes (slopes from 0 of a convex function increase) | no |
| S4 `g ∘ max · 0` continuous and same pushforward | silently needed by Thm 2.8 "continuous" (:171) | yes; (iii)-type implicit step, kept as an obligation, not filled | yes: convex ⇒ continuous on `(0,∞)`; at 0, monotone + convex + `g 0 = 0` give right-continuity; `lawY (Iio 0)=0` | no |
| S5 `IsInvSub lawY` | :337 "straightforward to verify that Y is ITS" | yes | yes: `F_Y(0)=0`, $1-F_Y(1/x)=\frac{x}{x+1}$ is concave, nonnegative, hence subadditive on `(0,∞)` | no |

Assembly: S3a gives `g`; S3b gives `g 0 = 0`; S4 gives continuous `g' = g ∘ max · 0` with `lawY.map g' = μ`; S3c applied to `g'` (equal to `g` on `Ici 0`) gives `StarShaped g'`; `hT01 g'` with S5 gives `IsInvSub μ`. The obligations assemble to `T03_main`. S1 (and with it `hX01`) is not needed by the assembly; it mirrors the printed first sentence. Non-blocking: `hX01` will probably be reported UNUSED by `#pv_hyp_usage`; the prover may either use S1 or leave it, but must not claim X01 as a condition of T03 unless it is used.

Ruling: PASS (faithful), with S3b recorded as **false as stated**. h(0)=0 at :337 is kept as an obligation, not filled in: confirmed.

## Item 6. External parameters

### `Paper.P04.P04_X01Tool` (reused from P04Stmt:64, not redeclared): APPROVED, type (i)
Cited at :296-299 (Prop 1 of superPareto2024) and used at :337. Gated and final-audited in P04 at this exact `vh`. Used in T03 only in the forward direction, which is no stronger than the source's use. Not goal-shaped. It still needs registration in `external_tools` (see P04_final.md §4); the coordinator should add T03 as a consumer.

### `Paper.T03.T03_T01Consumed` (T03Stmt:30-32): APPROVED as faithful, type (p) counted as (iv), predecessor T01
- Content: Thm 2.8 (:169-172) with $X:=Y$ (law `lawY`), all hypotheses kept ("continuous", "star-shaped", "X ITS"). It is the printed theorem specialised to the one ITS variable the source applies it to; not stronger than T01, not repaired (no added `g > 0` or `F_{h(X)}(0)=0` premise). Location in T01 and applicability conditions (continuity = S4, star-shaped = S3c, `Y` ITS = S5) are stated in the docstring. Correct.
- Provenance: T01 has issue T01_issue_1 (ERROR, Thm 2.8 false as printed), so (p) counts as (iv); label "(p)/(iv), predecessor T01" is correct. Priority A on the human-check worksheet.
- Name `T03_T01Consumed`, declared only in `T03Stmt.lean`, in `namespace Paper.T03`; no clash (grep of `pv_work`: `Nonneg`, `lawY`, `T03_T01Consumed` declared only there).
- Not goal-shaped: it does not mention super-Pareto or `μ`.
- **Warning (binding on prover and auditor): this parameter is refutable.** Take `g y = max (y - 1) 0`: continuous, `g 0 = 0`, `g y / y = max (1 - 1/y) 0` non-decreasing on `(0,∞)`, so `StarShaped g`; `F (lawY.map g) 0 = lawY (Iic 1) = P(Z ≤ 2) = 1/2 ≠ 0`, so `¬ IsInvSub (lawY.map g)`. With S5 (true), `T03_T01Consumed → False`. (Reasoning, not checked in Lean; consistent with T01_issue_1, whose §2 already notes that T03's instance gives no LESSONS-2 rescue.) Therefore `T03_main` is derivable ex falso from `hT01` and S5 alone. VERDICTS §4.2 forbids deriving B from contradictory premises: **any proof of `T03_main` that does not go through S3a-S3b-S3c-S4-S5 and apply `hT01` only to the `g'` of the source route is invalid**, and the auditor must check `#pv_walk` reaches S3b (or its gap). No faithful re-encoding avoids this, because the very instance used at :337 is refuted (see item 7, issue A); weakening the clause to that instance would still be false, and adding `F(lawY.map g) 0 = 0` would repair the paper. So no amendment is requested; the consequence is that T03 cannot honestly be CONDITIONAL on this clause.

## Item 7. Doubts about the source (preliminary only; dispatch pv-issue-checker)

- **A. :332-335, Thm 4.8 as printed: preliminary ERROR.** Def 4.1 with $h(z)=\max(z-2,0)$ (increasing per :111, convex, nonconstant) gives $X=h(Z)\ge0$ super-Pareto with $F_X(0)=P(Z\le2)=1/2\ne0$; Def 2.2 requires $F_X(0)=0$, so $X$ is not ITS. In Lean terms `μ = paretoMeasure.map (fun z => max (z-2) 0)` satisfies `SuperPareto`, `Nonneg`, and `¬ IsInvSub`. (Reasoning, not checked in Lean.) Same mechanism as T01_issue_1. The drafter labelled it PAPER_ASSUMPTION_GAP; the issue checker should decide between ERROR (counterexample to the printed statement) and the label for the missing "positive"/"F_X(0)=0" hypothesis. Cross-check that Prop 4.3 (cited) is not inconsistent with this instance on the domain `suppIn` (on `[0,∞)` $1/\Fbar_X = x+2$ is concave; on all of ℝ it jumps at 0).
- **B. :337 "h(0)=0": preliminary PAPER_ARGUMENT_GAP.** False for $X=Z$ (Pareto, nonnegative super-Pareto, ITS by :279), where the only representation has $h(0)=1$; the cited "shift invariance" does not yield it. Conclusion may still hold for such $X$ (e.g. $Z$). Obligation S3b.
- **C. :337 continuity of $h$ for Thm 2.8**: likely FAIR_IMPLICIT_STEP (S4 true). No dispatch needed unless the prover fails.
- **D. :337 "straightforward to verify that Y is ITS"**: likely FAIR_IMPLICIT_STEP (S5 true).
- **E. Inherited**: consumed Thm 2.8 is false as printed (T01_issue_1, ERROR); see item 6.

No ruling on paper correctness is made here.

## TFAs ruled on

| Premise | Ruling | Reason |
|---|---|---|
| (none) | n/a | `T03_main` has no extra premise on `μ` beyond the printed ones |

## External parameters

| Name | Location | Provenance | Ruling |
|---|---|---|---|
| `Paper.P04.P04_X01Tool` | P04Stmt.lean:64 (reused) | (i), :296-299 | APPROVED (likely unused by the T03 route; see item 5) |
| `Paper.T03.T03_T01Consumed` | T03Stmt.lean:30 | (p) -> (iv), predecessor T01 (:169-172, used :337) | APPROVED as faithful; **refutable**, ex falso use forbidden (item 6) |

## Required changes

None. (Non-blocking suggestion to the drafter/prover: in the S3b docstring, note the equivalence of the `∀ g` form and the source's `∃ h` form argued in item 5.)

## Statement snapshot

Statement copy (`pv_work/probes/gate/T03/gate_T03_stmtcopy.lean`, log `pv_work/logs/gate_T03_stmtcopy_1.log`, `RESULT ... exit=0 errors=0 sorry_warnings=0`):

```
TYPE HASHES (current file, 3 declarations)
Paper.T03.Nonneg|def|th=3905129696|vh=2774941542|bi=e
Paper.T03.T03_T01Consumed|def|th=3944470172|vh=4166300400|bi=
Paper.T03.lawY|def|th=3087119417|vh=1427334908|bi=
EXIT=0
```

Draft copy (`pv_work/probes/gate/T03/gate_T03_draftcopy.lean`, log `pv_work/logs/gate_T03_draftcopy_1.log`, `RESULT ... exit=0 errors=0 sorry_warnings=8`):

```
TYPE HASHES (current file, 8 declarations)
Paper.T03.T03_S1|thm|th=1654134066|vh=-|bi=eecee
Paper.T03.T03_S2|thm|th=1092559691|vh=-|bi=ee
Paper.T03.T03_S3a|thm|th=2946786374|vh=-|bi=ecee
Paper.T03.T03_S3b|thm|th=2829401491|vh=-|bi=eceeeee
Paper.T03.T03_S3c|thm|th=2382941012|vh=-|bi=eee
Paper.T03.T03_S4|thm|th=1429707550|vh=-|bi=eeee
Paper.T03.T03_S5|thm|th=1743874808|vh=-|bi=
Paper.T03.T03_main|thm|th=2677017533|vh=-|bi=eeecee
EXIT=0
```

## Overall

Statement and obligations are faithful to :332-338; no amendments. Proof work may begin under the binding restriction of item 6 (no ex falso through `T03_T01Consumed`); S3b is false as stated and will become a gap; suspected issues A and B to pv-issue-checker.

STATEMENT GATE: PASS

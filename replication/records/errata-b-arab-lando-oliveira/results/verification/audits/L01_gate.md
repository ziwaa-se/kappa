# L01 statement gate (Lemma 2.3, lem:ITS-carac)

- Reviewer: pv-gate (independent subagent, Claude Opus 5.5)
- Date: Mon Oct 12 22:01:39 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e
  - `pv_work/L01Draft.lean` abafe13bc48ebea7565b74ad3c81b81a84e51ff89803303c5e8e8595a0503e2c
  - `pv_work/notes/L01_draft_notes.md` fed517aae6cf5568f8f13e04d7505413ee93b360ce1d9223bcaa1857ae9c43b8 (leads only)
  - `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
- Imports: `L01Stmt` imports only `Mathlib`; no shared `Defs*.lean`, no predecessor Stmt files.

## Source quotations (read directly)

- F:111 — "a function $v$ is said to be subadditive if $v(x+y)\leq v(x)+v(y)$, for every $x,y$ in the domain of $v$."
- F:113 — "$F_X$ and $\Fbar_X=1-F_X$ its cumulative distribution and survival functions ... $F_X^-(x)=\Prob(X<x)$ the left-continuous cumulative distribution function".
- F:119 — "we shall refer to the random variables or to their cumulative distribution functions, with the same notations ... depend only on the cumulative distribution functions."
- F:121 — "$F_{\frac1X}^-(x)=1-F_X(\frac1x)$ is generally referred to as the inverted distribution of $X$".
- F:124 (Def 2.2) — "We say that a random variable $X$ such that $F_X(0)=0$ is \ITS\ ... if $F_{\frac1X}^-$ is subadditive."
- F:130-133 (Lemma) — "A random variable $X$ is \ITS\ if and only if $F_X(\tfrac{x}{\theta})+F_X(\tfrac{x}{1-\theta})\leq F_X(x)+1,\ \forall x\geq0,\, \theta\in(0,1)$."
- F:137 (proof) — "The subadditivity of $1-F_X(\frac1x)$ is obviously equivalent to $1-F_X(\tfrac{x}{\theta})+1-F_X(\tfrac{x}{1-\theta})\geq 1-F_X(x)$, for every $x\geq0$ and $\theta\in(0,1)$, which is clearly a rewriting of (\ref{eq:sub-1x})."
- Context (not ruled on here): F:442 states a later characterisation as "A random variable $X$ such that $F_X(0)=0$ is \ITS\ if and only if ..." (qualifier printed there, absent at F:130); F:180 (Thm 2.6) uses Lemma 2.3 in the "if" direction.

## Compilation

- `scripts/pv_lean.sh check L01Draft`: `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none` (EXIT=0; the 3 sorries are the draft obligations S1, S2, main).
- Stmt copy probe: `exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/gate_L01_stmtcopy_1.log`.
- Draft copy probe: `exit=0 errors=0 sorry_warnings=3`, log `pv_work/logs/gate_L01_draftcopy_1.log`.

## Item 1 — Hypotheses: PASS

- "A random variable X" (F:130) is encoded as its law `μ : Measure ℝ` with `[IsProbabilityMeasure μ]`; justified by F:119 (only cdfs matter). `F μ = ProbabilityTheory.cdf μ` is the right-continuous cdf `P(X ≤ x)`, matching F_X (F:113). No hidden hypotheses: no `variable`, `structure`, or extra class; `L01Stmt` imports only Mathlib.
- No extra premise in `L01_main`. The drafter's candidate TFA `F μ 0 = 0` is NOT in the draft (see TFA table: rejected as a TFA).
- No form states the conclusion as a hypothesis.
- Remark (outside L01): F:165 (ex:discITS) uses an X with mass at +∞; a probability measure on ℝ cannot represent it. Not relevant to L01's statement, but whoever drafts that example must address it.

## Item 2 — Conclusion: PASS

- `IsInvSub μ := F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Ioi 0)` faithfully encodes Def 2.2 (F:124) including its presupposition `F_X(0)=0`, read literally as part of the predicate "X is ITS".
- `SubCond` is exactly (eq:sub-1x) F:133: `∀ x ≥ 0, ∀ θ ∈ (0,1), F(x/θ)+F(x/(1-θ)) ≤ F(x)+1`.
- `L01_main : IsInvSub μ ↔ SubCond μ` is the printed biconditional, neither weakened nor strengthened. This literal reading is supported by the paper itself, which prints the qualifier "such that $F_X(0)=0$" explicitly in an analogous characterisation (F:442) but not at F:130. The literal encoding faithfully records what the printed statement says. It does not create the problem through a representation choice: the gap remains whichever domain is chosen (see item 4).

## Item 3 — Quantifiers / constants: PASS

No constants. `x` and `θ` are universally quantified in the order of F:133, and θ ranges over `Set.Ioo 0 1`, matching θ ∈ (0,1). μ is outermost.

## Item 4 — Domains and details: PASS

- Domain of `F^-_{1/X}` (not stated in the source): the draft uses `(0,∞)`. I checked the alternatives by hand:
  (a) `[0,∞)` with Lean's `1/0=0` gives `invDist(0) = 1 - F(0)`. Under F(0)=0 this is 1, and the extra subadditivity instances `v(y) ≤ 1+v(y)` and `v(0)=1 ≤ 2` hold automatically. With the natural limiting value 0 they are also trivial.
  (b) Domain ℝ: under F(0)=0, `v = 1` on (-∞,0], and every instance involving a non-positive argument reduces to `v ≤ 1 ≤ 1 + v(·)` or `1 ≤ 2`.
  So under F(0)=0 all three readings are equivalent. The `F(0)=0` issue does not depend on the domain either: for X = 0 a.s., `1 - F(1/x)` is subadditive on (0,∞), on [0,∞) and on ℝ (with Lean's 1/0=0), yet F(0)=1. The domain choice therefore neither manufactures nor hides a paper error. The proof's "for every x ≥ 0" (F:137) contains a vacuous x=0 case, which the draft handles in S2 (`2F(0) ≤ F(0)+1 ⇔ F(0) ≤ 1`). Preliminary class: FAIR_IMPLICIT_STEP / EDITORIAL, not an issue.
- Values are real (`cdf` is ℝ-valued in mathlib); no `ENNReal` truncation. Equality is pointwise, not a.e. No measurability or finiteness issues.
- The left-limit notation `F^-` (F:121) is defined there by the formula `1-F_X(1/x)`, and `invDist` uses that formula; this is faithful.

## Item 5 — Step obligations: PASS (S1, S2 true; main false as stated as printed, see item 7)

- **S1** (F:137, "obviously equivalent"): `SubadditiveOn (invDist F) (Ioi 0) ↔ ∀ x>0, θ∈(0,1), 1-F x ≤ (1-F(x/θ)) + (1-F(x/(1-θ)))`. It is true for any function F: the maps (s,t) ↦ (x,θ) = (1/(s+t), s/(s+t)) and back, s = θ/x, t = (1-θ)/x, are bijective between (0,∞)² and (0,∞)×(0,1), with x/θ = 1/s, x/(1-θ) = 1/t and s+t = 1/x. The correspondence is faithful, and the unwritten substitution is a fair implicit step. It does not smuggle in the conclusion.
- **S2** (F:137, "clearly a rewriting"): the S1 right-hand side for x>0 ⇔ `SubCond`. This is true: for x>0 it is a linear rearrangement, and the x=0 instance is `F(0) ≤ 1`, which holds for a cdf (requires `IsProbabilityMeasure`, which is present). Faithful.
- **L01_main**: the "only if" direction follows from S1 and S2 (drop the F(0)=0 conjunct). The "if" direction is **false as stated**. Counterexample: μ = dirac 0. Then F = 1 on [0,∞), so for x ≥ 0 SubCond reads 2 ≤ 2, which holds, but F(0) = 1 ≠ 0. The same failure occurs with dirac(-1) and with many non-degenerate laws with F(0) > 0. This falsity comes from the printed statement (the source proof at F:137 addresses only subadditivity and never `F_X(0)=0`), not from the encoding. Assembled, S1 and S2 give exactly `SubadditiveOn … ↔ SubCond`, which is all that the source proof establishes. The obligations faithfully expose the missing part instead of covering it.

## Item 6 — External parameters: PASS (none)

There is no `def … : Prop` tool. Mathlib's `ProbabilityTheory.cdf` is used and compiles (Stmt copy probe EXIT=0). All names are in `namespace Paper.L01`. No other Stmt file declares these names in this namespace (the existing P01 and P02 Stmt files are separate namespaces, and L01Stmt does not import them).

## Item 7 — Doubts about the source: recorded, to be dispatched (not ruled on here)

- **F:130 (with F:124)**: Lemma 2.3 omits "such that $F_X(0)=0$", so the "if" direction is false as printed (X = 0 a.s.). The proof (F:137) is silent on F_X(0)=0. Preliminary class: PAPER_ASSUMPTION_GAP. An alternative is EXPOSITION_GAP or DOMAIN_CLARIFICATION, if Def 2.2's "X such that F_X(0)=0" is read as a standing restriction of the universe of discourse. **Recommend dispatching pv-issue-checker.**
- **F:137**: the change of variables is unwritten, and the vacuous x = 0 case is included even though 1/x is undefined there. Preliminary class: FAIR_IMPLICIT_STEP / EDITORIAL (no dispatch needed).
- Lead for downstream (not L01): Thm 2.6 (F:171-180) applies the "if" direction of this lemma to h(X), so it needs F_{h(X)}(0) = F_X(h^{-1}(0)) = 0. A star-shaped h can vanish on an interval [0,a] with a > 0, in which case this need not hold. The gate for that theorem should check this.

## TFA rulings

| Candidate | Ruling | Reason |
|---|---|---|
| `F μ 0 = 0` as an extra premise of `L01_main` (drafter's candidate; not in draft) | REJECTED as a TFA | It cannot be derived from the lemma's hypothesis (eq:sub-1x): see the counterexamples above. It excludes non-degenerate cases (any law with F(0)>0 satisfying (eq:sub-1x)), which the printed lemma covers. Adding it would repair the statement and mask the suspected gap. Keep the draft as printed. |

## External parameters

None.

## Required changes

None.

Optional note for the coordinator (not a gate requirement): the source proof justifies only `SubadditiveOn … ↔ SubCond` (= S1 ∘ S2) and the "only if" direction. If the issue-checker confirms the gap, these are the parts of L01 that can be proved, and the parts that downstream results (e.g. Thm 2.6) may consume.

## Statement snapshot

`pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (log `pv_work/logs/gate_L01_stmtcopy_1.log`):
```
TYPE HASHES (current file, 5 declarations)
Paper.L01.F|def|th=390107078|vh=2204204658|bi=ee
Paper.L01.IsInvSub|def|th=3905129696|vh=4092780251|bi=e
Paper.L01.SubCond|def|th=3905129696|vh=541250335|bi=e
Paper.L01.SubadditiveOn|def|th=37722423|vh=3526866243|bi=ee
Paper.L01.invDist|def|th=2287483187|vh=4160654643|bi=ee
EXIT=0
```

`pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (log `pv_work/logs/gate_L01_draftcopy_1.log`):
```
TYPE HASHES (current file, 3 declarations)
Paper.L01.L01_S1|thm|th=3918018450|vh=-|bi=ec
Paper.L01.L01_S2|thm|th=3905991379|vh=-|bi=ec
Paper.L01.L01_main|thm|th=669855096|vh=-|bi=ec
EXIT=0
```

## Overall verdict

The statement is a faithful, literal encoding of the source. S1 and S2 are true and faithful. `L01_main` is false as stated, because the printed lemma itself fails, not because of the encoding. Proof work may begin on S1 and S2 and on the "only if" direction. The "if" direction goes to pv-issue-checker.

STATEMENT GATE: PASS

# P06 statement gate (Proposition 5.3, `cor:fsub`)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 02:15:46 EDT 2026
- Reviewed files (sha256, from `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P06Stmt.lean` f98408363da70539f235e6cbd80d6a91e19e7efc41ed08bcc67b0342c96fdeaf
  - `pv_work/P06Draft.lean` 76145291ad158df24ece2d1e745850b8a60e785f4310bce61a85d2e920a21e40
  - `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
  - `pv_work/notes/P06_draft_notes.md` 31f3e1fdf77a3170d50be7b3ca051b24ee66ebd97b43a33368a97e823742c999 (read as leads only)
- Compilation: `scripts/pv_lean.sh check P06Draft`: `exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0`, log `pv_work/logs/P06Draft_2.log`. The five sorries are S1, S1', S2, S3, S4; `P06_main` is assembled by `rw` from S4, S2, S3.
- Also compared against: `pv_work/L01Stmt.lean` (Def 2.2), `pv_work/P05Stmt.lean` and `pv_work/L02Stmt.lean` (Def 5.1, `SubadditiveOnE`).

## Source quotations (read directly)

- F:111: "the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}:\,v(x)\leq u\}$. Moreover, a function $v$ is said to be subadditive if $v(x+y)\leq v(x)+v(y)$, for every $x,y$ in the domain of $v$."
- F:113: "$F_X^-(x)=\Prob(X<x)$ the left-continuous cumulative distribution function".
- F:121: "$F_{\frac1X}^-(x)=1-F_X(\frac1x)$ is generally referred to as the inverted distribution of $X$".
- F:124 (Def 2.2): "We say that a random variable $X$ such that $F_X(0)=0$ is InvSub ... if $F_{\frac1X}^-$ is subadditive."
- F:279: "$\mathcal{P}(x)=1-\frac1x$, for $x\geq1$."
- F:424 (Def 5.1): "$F_1\leq_{i-sb}F_2$, if $\frac{1}{F_2^{-1}(F_1^-(\frac1x))}$ is subadditive."
- F:442 (Prop 5.3): "A random variable $X$ such that $F_X(0)=0$ is InvSub if and only if $F_X\leq_{i-sb}\mathcal{P}$."
- F:445 (proof): "As $\mathcal{P}^{-1}(p)=\frac{1}{1-p}$, we are reduced to verifying the subadditivity of $1-F_X(\frac1x)$."

## Item 1 — Hypotheses: PASS

- Source hypotheses: X a random variable, `F_X(0)=0`. Lean: law `μ` with `[IsProbabilityMeasure μ]`, `h0 : cdf μ 0 = 0`. The hypothesis `F_X(0)=0` is kept, as printed.
- No extra premises. No `variable`s, structures or type classes beyond `IsProbabilityMeasure` (which encodes "random variable"). No conclusion-shaped hypothesis.
- `IsInvSub` contains `cdf μ 0 = 0` as its first conjunct, as Def 2.2 does (F:124); `h0` makes it redundant, which is the printed situation.

## Item 2 — Conclusion: PASS

`IsInvSub μ ↔ isbOrder (cdf μ) paretoCdf` is the printed biconditional, neither weakened nor strengthened.

## Item 3 — Quantifiers and constants: PASS

No constants. `μ` universally quantified; nothing chosen before it.

## Item 4 — Domains and details: PASS

Self-declared definitions in `Paper.P06`, checked against the source and the L01/P05 versions:

- `SubadditiveOn` (generic codomain `[Add α] [LE α]`): instantiated at `ℝ` it is literally the body of `Paper.L01.SubadditiveOn`; at `EReal` literally the body of `Paper.L02.SubadditiveOnE`. Matches F:111.
- `IsInvSub μ := cdf μ 0 = 0 ∧ SubadditiveOn (x ↦ 1 - cdf μ (1/x)) (Ioi 0)`: definitionally the same as `Paper.L01.IsInvSub` (`F μ = cdf μ`, `invDist G x = 1 - G (1/x)`). Matches F:121/F:124.
- `genInv`: identical body to `Paper.P05.genInv`; matches F:111 (sup over ℝ, valued in `EReal`, E1).
- `recipE`: identical clauses to `Paper.P05.recipE` (`⊤ ↦ 0`, `⊥ ↦ 0`, `0 ↦ ⊤`, `r ↦ 1/r`).
- `isbOrder F₁ F₂`: unfolds to the same function as `Paper.P05.InvSubLE` (`recipE (genInv F₂ (leftLim F₁ (1/x)))`, subadditive on `(0,∞)`). Matches F:424 with `F₁⁻` = left limit (F:113). For `F₁ = cdf μ` (monotone), `leftLim` is the genuine left limit, with values in `[0,1]` and equal to `P(X < t)`.
- `paretoCdf`: `1 - 1/x` for `x ≥ 1` (F:279), `0` for `x < 1` (E3). For `p ≥ 0` every `x < 1` is in `{x | 𝒫 x ≤ p}` anyway, and the supremum is at least 1, so the extension does not affect `genInv paretoCdf p` on `p ∈ [0,1]`, the only range used.

Conventions E1–E5:
- E1 (`EReal` inverse): faithful; avoids the junk value of `sSup` in ℝ.
- E2 (`recipE`): only `1/⊤ = 0` is reached (at `F⁻(1/x) = 1`, where `genInv = ⊤`); `1/0` and `⊥` are never reached for `p ∈ [0,1]` since `genInv paretoCdf p ≥ 1`. `1/(+∞) = 0` is the natural reading and gives `1 - p` at `p = 1`, consistent with the printed formula. It does not manufacture or hide anything.
- E3: harmless (above).
- E4 (domain `(0,∞)`): consistent with the L01 gate. I checked the ℝ reading of the Def 5.1 function by hand: under `F(0)=0`, for `x ≤ 0` (Lean `1/0 = 0`) `F⁻(1/x) = 0`, so the function equals 1 there, and with values in `[0,1]` every instance with a non-positive argument is trivially satisfied. So the readings are equivalent under `h0`; the domain choice does not affect truth.
- E5 (`F₁⁻` encoded literally): correct, as Def 5.1 (F:424) prints `F_1^-`. The passage to `F_X` at F:445 is made a separate, visible obligation (S3), not absorbed into a definition. Good.
- No `ENNReal`/`toReal` truncation; `cdf` is real-valued. No a.e. issues; no measurability issue.

## Item 5 — Step obligations: PASS

I checked each obligation for truth as stated:

- **S1** (`p ∈ [0,1)`, `genInv paretoCdf p = 1/(1-p)`): `{x | 𝒫 x ≤ p} = (-∞, 1/(1-p)]` (for `x ≥ 1`, `1 - 1/x ≤ p ⇔ x ≤ 1/(1-p)`, and `1/(1-p) ≥ 1`). Supremum `1/(1-p)`. TRUE. Corresponds to F:445 "𝒫⁻¹(p) = 1/(1-p)".
- **S1'** (`p ∈ [0,1]`, `recipE (genInv paretoCdf p) = 1 - p`): `p < 1` follows from S1 (`1/(1-p) ≠ 0`); `p = 1`: the set is ℝ, sup `⊤`, `recipE ⊤ = 0`. TRUE. It is the edge case of the same clause, labelled as unprinted.
- **S2** (`isbOrder (cdf μ) paretoCdf ↔ SubadditiveOn (x ↦ 1 - leftLim (cdf μ) (1/x)) (Ioi 0)`): `leftLim (cdf μ) t ∈ [0,1]` (monotone and bounded by 0 and 1), so by S1' the `EReal` function is the coercion of the real one, and `↑a ≤ ↑b + ↑c ↔ a ≤ b + c`. TRUE. This is the first half of F:445.
- **S3** (`SubadditiveOn (1 - F⁻(1/·)) ↔ SubadditiveOn (1 - F(1/·))` on `(0,∞)`): with `g(x) = μ(Ioi(1/x))` and `g⁻(x) = μ(Ici(1/x))`, `g⁻(x) = lim_{t↓x} g(t)` and `g(x) = lim_{t↑x} g⁻(t)` (monotone convergence of sets). Subadditivity on `(0,∞)` is preserved by both one-sided limits (`x+y+2ε` / `x+y-2ε` with `ε` small, so arguments stay positive). TRUE as stated, with no extra premise needed (it holds even without `h0`). It does not smuggle in the target: it is a statement about `F` alone, independent of the Pareto benchmark and of InvSub. It corresponds to the implicit passage `F_X^-` (F:424) → `F_X` (F:445). The source gives no justification for it: see item 7.
- **S4** (under `h0`, `IsInvSub μ ↔ SubadditiveOn (1 - F(1/·))`): immediate from the definition. TRUE. Corresponds to Def 2.2 together with the hypothesis of F:442.
- **Assembly**: `P06_main` compiles by `rw [S4, S2, S3]`. The obligations together yield the theorem.

## Item 6 — External parameters: PASS (none)

`P06Stmt.lean` declares no `def … : Prop` external parameter and no consumed clause. Imports only `Mathlib`. `Function.leftLim` and `ProbabilityTheory.cdf` are mathlib declarations (they elaborate in the compiled files). The names `SubadditiveOn`, `IsInvSub`, `genInv`, `recipE` repeat names in L01/P05 but live in `namespace Paper.P06`. They are definitions, not external parameters, so the no-redeclaration rule for parameters/clauses is not engaged, and they are shown above to agree in meaning with the L01/P05 versions.

Recommendation (non-blocking, not a required change): if the coordinator wants cross-result consistency to be machine-checked, a later bridge lemma `Paper.P06.IsInvSub μ ↔ Paper.L01.IsInvSub μ` (it holds by `Iff.rfl` up to unfolding) and `isbOrder F₁ F₂ ↔ Paper.P05.InvSubLE F₁ F₂` would record it. P06 itself does not depend on them.

## Item 7 — Doubts about the source: recorded, preliminary only

1. **F:445 vs F:424** — Def 5.1 is in terms of `F_1^-(1/x)` (left-continuous cdf), while the proof reduces to subadditivity of `1 - F_X(1/x)` (right-continuous cdf, Def 2.2's inverted distribution) with no comment. The passage is S3. I believe it is true (sketch in item 5), so this is not an ERROR. Preliminary class: `FAIR_IMPLICIT_STEP`, or `EXPOSITION_GAP` if a one-line limit argument is judged necessary. Dispatch `pv-issue-checker` for the classification.
2. **F:445** — `𝒫⁻¹(p) = 1/(1-p)` is printed without range; at `p = 1` (`P(X < 1/x) = 1`) it reads `1/0`, and the intended value `𝒫⁻¹(1) = +∞`, `1/∞ = 0` is not stated (S1'). Preliminary class: `FAIR_IMPLICIT_STEP` / `EDITORIAL`. Optional for the issue checker, together with item 1.

The gate makes no ruling on whether the paper is right; the statement is not modified to rescue anything.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | The draft has no extra premises. |

## External parameters

| Name | Ruling | Provenance |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

`pv_work/probes/gate/P06/gate_P06_stmtcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, log `pv_work/logs/gate_P06_stmtcopy_1.log`):

```
TYPE HASHES (current file, 7 declarations)
Paper.P06.IsInvSub|def|th=3905129696|vh=1921472790|bi=e
Paper.P06.SubadditiveOn|def|th=525447227|vh=4303096|bi=iccee
Paper.P06.genInv|def|th=3872505921|vh=2805129803|bi=ee
Paper.P06.isbOrder|def|th=3790785477|vh=288153885|bi=ee
Paper.P06.paretoCdf|def|th=3468892319|vh=1828619286|bi=e
Paper.P06.recipE.match_1|def|th=1621131385|vh=1432657551|bi=eeeee
Paper.P06.recipE|def|th=2418022539|vh=3590760695|bi=e
EXIT=0
```

`pv_work/probes/gate/P06/gate_P06_draftcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, 5 sorry warnings, log `pv_work/logs/gate_P06_draftcopy_1.log`):

```
TYPE HASHES (current file, 6 declarations)
Paper.P06.P06_S1'|thm|th=3046643009|vh=-|bi=eee
Paper.P06.P06_S1|thm|th=3948337634|vh=-|bi=eee
Paper.P06.P06_S2|thm|th=937692659|vh=-|bi=ec
Paper.P06.P06_S3|thm|th=137725837|vh=-|bi=ec
Paper.P06.P06_S4|thm|th=3621779999|vh=-|bi=ece
Paper.P06.P06_main|thm|th=1198489325|vh=-|bi=ece
EXIT=0
```

## Overall verdict

The statement is faithful to F:440-443 under Def 2.2 (F:124) and Def 5.1 (F:424). The hypothesis `F_X(0)=0` is kept. All obligations are true as stated and they assemble into the main theorem. There are no TFAs and no external parameters.

STATEMENT GATE: PASS

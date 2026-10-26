# T01 statement gate (Thm 2.8 / thm:inclusion)

- Reviewer: pv-gate (Claude Opus 5.5), independent subagent; not the drafter.
- Date: Tue Oct 13 01:07:31 EDT 2026 (from `date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 72e3590db382e42bcc16d40ddc0b0dfcf6336e0d76086ccfd1320cff994aa0b7
  - `pv_work/T01Draft.lean` a0bcb06b422d7aca631b3735b636e4a647349d73664ed2d347d37546494b5b8b
  - `pv_work/T01Stmt.olean` 9dd03009347d7959841474c597be1aa3679c74b909aeaad19003b11e5466d5a5
  - `pv_work/L01Stmt.lean` (imported) 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e (same as L01 gate / issue hash)
  - `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
- Compilation: `scripts/pv_lean.sh check T01Draft` -> `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_3.log olean=none`.
- Gate probes (in `pv_work/probes/gate/T01/`): `gate_T01_stmtcopy.lean` (exit=0, log `pv_work/logs/gate_T01_stmtcopy_1.log`), `gate_T01_draftcopy.lean` (exit=0, 8 sorry, log `pv_work/logs/gate_T01_draftcopy_1.log`), `gate_T01_consumed_false.lean` (exit=0, 0 sorry, log `pv_work/logs/gate_T01_consumed_false_1.log`, axioms `[propext, Classical.choice, Quot.sound]`).

## Source quotations (read directly)

- F:111: "``increasing'' and ``decreasing'' are taken as ``non-decreasing'' and ``non-increasing'' ... the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}:\,v(x)\leq u\}$ ... a function $v$ defined in $[0,+\infty)$ is said to be star-shaped if $v(0)=0$ and $\frac{v(x)}x$ is increasing. If $\frac{v(x)}x$ is decreasing, $v$ is called anti-star-shaped."
- F:113, F:119: $F_X$ is the cdf; random variables and their cdfs are identified.
- F:122-124 (Def 2.2): "a random variable $X$ such that $F_X(0)=0$ is \ITS\ ... if $F_{\frac1X}^-$ is subadditive."
- F:128-134 (Lemma 2.3, L01): "$X$ is \ITS\ if and only if $F_X(\tfrac{x}{\theta})+F_X(\tfrac{x}{1-\theta})\leq F_X(x)+1,\ \forall x\geq0,\theta\in(0,1)$." (The "if" direction is false as printed: `verification/audits/L01_issue_1.md`, PAPER_ASSUMPTION_GAP, Lean `L01_if_counterexample`.)
- F:169-172 (Thm 2.8): "Let $X$ be \ITS\ and $h$ a continuous star-shaped function. Then $h(X)$ is \ITS."
- F:174: "as $h$ is continuous, $F_{h(X)}(x)=F_X(h^{-1}(x))$. Since $h$ is star-shaped, its inverse, $h^{-1}$, is anti-star-shaped (see Lemma~4.1 in \cite{ineq-order2024}), hence, given $\theta\in(0,1)$, ... $h^{-1}(\tfrac{x}{\theta})\leq\tfrac{h^{-1}(x)}{\theta}$ and $h^{-1}(\tfrac{x}{1-\theta})\leq\tfrac{h^{-1}(x)}{1-\theta}$. As every function considered is increasing, we have"
- F:176-178: the display $F_{h(X)}(\tfrac{x}{\theta}) + F_{h(X)}(\tfrac{x}{1-\theta}) = F_X(h^{-1}(\tfrac{x}{\theta})) + F_X(h^{-1}(\tfrac{x}{1-\theta})) \le F_X(h^{-1}(x))+1=F_{h(X)}(x)+1$.
- F:180: "using (eq:sub-1x) for the last inequality, thus, taking into account Lemma~\ref{lem:ITS-carac}, the proof is concluded." The proof never addresses $F_{h(X)}(0)=0$.

## Item 1. Hypotheses: PASS (main theorem), with A1 needed on the parameter side

- `IsProbabilityMeasure μ`, `IsInvSub μ`: X is ITS (F:171, Def 2.2 via L01Stmt, gate-approved). OK.
- `h : ℝ → ℝ`, `Continuous h`, `StarShaped h`: the source's h is defined on $[0,\infty)$ (F:111). Using `Continuous` on all of ℝ is harmless. Any $h$ continuous on $[0,\infty)$ extends to $x \mapsto h(\max(x,0))$, which is continuous on ℝ, has the same `StarShaped` data (`StarShaped` only looks at 0 and `Ioi 0`), and gives the same law of $h(X)$, because `F μ 0 = 0` means $\mu((-\infty,0])=0$. So there is no real strengthening. `StarShaped` matches F:111 literally (h(0)=0, h(x)/x non-decreasing on $(0,\infty)$).
- No hidden hypotheses: no `variable`s, structures or classes. The only imported definitions are L01's `F`, `IsInvSub`, `SubCond` (gate-approved in L01).
- No extra premise on h (in particular no monotonicity or positivity), which is correct: the source prints none.
- No conclusion-shaped hypothesis in the *types*. However, `hL01 : T01_L01Consumed` is **refutable** (see item 6, A1), so `T01_main` as drafted is vacuously provable. Gate probe `gate_T01_vacuous` proves `IsInvSub (μ.map h)` from `hL01` alone (0 sorry, standard axioms). This is the "derive B from contradictory premises" case that VERDICTS §4.2 forbids. It is fixed by A1.

## Item 2. Conclusion: PASS
`IsInvSub (μ.map h)` = "h(X) is ITS" (Def 2.2 including $F_{h(X)}(0)=0$). It is neither weakened nor strengthened. `μ.map h` is the law of h(X), and h is continuous, hence measurable, so the map is a probability measure.

## Item 3. Quantifiers / constants: PASS
There are no constants. All of μ, h are universally quantified, matching F:171.

## Item 4. Domains and details: PASS (with remark)
- Real-valued X: consistent with the L01 encoding (laws on ℝ). Mass at $+\infty$ (as in ex:discITS F:165) is outside the scope; T01 does not rely on it.
- `ginv` = sup over $[0,\infty)$ = the domain of h (F:111 "sup over $x$" with $v$ defined on $[0,\infty)$). Faithful. The junk value (`sSup` of an unbounded set = 0) differs from the source's $+\infty$. It matters only when h ≤ x on all of $[0,\infty)$, and it manufactures a false obligation in S1 (item 5, A2).
- There are no ENNReal/toReal issues (F is the real-valued `cdf`), no a.e. issues and no existence issues.

## Item 5. Step obligations

| Step | Source | Correspondence | True as stated? | Ruling |
|---|---|---|---|---|
| S0 `MonotoneOn h (Ici 0)` from continuity + star-shaped | F:174 "every function considered is increasing" (silent; also the h^{-1} notation of F:111 presupposes increasing v) | faithful record of a silent use | **FALSE**: h(x) = −x (h(x)/x ≡ −1 non-decreasing) or h(x) = x²−x | accepted as a recorded unjustified step (paper side, see item 7); not the decisive failure (S2 fails even for increasing h) |
| S1 `F (μ.map h) x = F μ (ginv h x)`, x ≥ 0 | F:174 | faithful | **FALSE as stated, but only because of the encoding**: for h ≤ 0 on $[0,\infty)$ (e.g. h = −x or h ≡ 0, both star-shaped) the sublevel set $\{y\ge0: h y\le x\}$ is unbounded, `ginv` = junk 0, RHS = F μ 0 = 0, LHS = 1. The source's formula is true there with $h^{-1}(x)=+\infty$, $F_X(+\infty)=1$. With bounded sublevel set it is true even without monotonicity: for x ≥ 0 the set is downward closed (star-shapedness) and closed (continuity), so it is $[0,r]$, and μ(Iic 0) = 0 | **amend (A2)** |
| S2 `F (μ.map h) 0 = 0` | not in source (Def 2.2 F:124 requires it; F:180 never checks it) | correctly labelled as not in source | **FALSE**: h(x) = max(x−1, 0) (continuous, increasing, star-shaped), X Fréchet(1) (ITS, F:142-143): $F_{h(X)}(0)=e^{-1}$ (reasoning; lead from L01_issue_1 §5); also h = −x | accepted as a recorded gap (paper side, item 7) |
| S3 `AntiStarShaped (ginv h)` | F:174 + cited Lemma 4.1 | faithful, via X02 | plausible/true (monotone star-shaped h ≥ 0; in the junk case h ≡ 0 on $[0,\infty)$, ginv ≡ 0, trivially antitone ratio) | PASS |
| S4 | F:174 "hence ... $h^{-1}(x/\theta)\le h^{-1}(x)/\theta$" | faithful (x>0; x/θ ≥ x) | true | PASS |
| S5 | F:174/177 "every function considered is increasing" (F_X monotone) | faithful | true (cdf monotone) | PASS |
| S6 | F:178/180 "using (eq:sub-1x)" | faithful | true (instance of SubCond, y ≥ 0) | PASS |

No obligation smuggles in the conclusion. Assembly (after A1, A2): for x = 0, SubCond at 0 is trivial ($2F(0)\le F(0)+1$). For x > 0: S1 (three times), S5∘S4∘S3∘S0, S6 at y = ginv h x (≥ 0, since it is an sSup of nonnegatives or the junk 0). This gives `SubCond (μ.map h)`. Then the amended L01 clause with S2 gives `IsInvSub (μ.map h)`. Under A2 the assembly also needs `BddAbove` of the sublevel sets at x, x/θ, x/(1−θ). It follows from S2 + `hs` (if $P(h(X)\le0)=0$ then h(y)>0 for some y>0, and star-shapedness gives $h(z)\ge z\,h(y)/y$ for z ≥ y, so h is unbounded). This is a FAIR_IMPLICIT_STEP that only removes our junk value (the source's $h^{-1}=+\infty$ case). The prover should label it as such. **Item 5: FAIL until A2; otherwise PASS.**

## Item 6. External parameters

| Name | Provenance | Ruling | Reason |
|---|---|---|---|
| `T01_X02Tool` | (i) \cite{ineq-order2024} Lemma 4.1, F:174 | **APPROVED** | Restricted to continuous, monotone h, which is weaker than the cited use (h^{-1} of F:111 is defined only for increasing v). Not goal-shaped (says nothing about F or ITS). The Lean statement is true (see S3). Human check: the cited lemma's exact hypotheses. A mathlib search is not applicable (research lemma). Declared in `T01Stmt.lean`, namespace `Paper.T01`, no name clash (checked against the declarations of L01/L02/P01/P02/T02 Stmt). |
| `T01_L01Consumed` | (p), L01 is ISSUE so it counts as (iv) (VERDICTS §4.1) | **REJECTED as drafted** | It is the printed biconditional for **all** μ. Its `←` half is refutable (L01_issue_1, Dirac at 0), so the hypothesis is unsatisfiable. Gate probe `gate_T01_L01Consumed_false : ¬ T01_L01Consumed` compiles (exit 0, 0 sorry). It makes `T01_main` vacuous, which violates VERDICTS §4.2 ("must not derive B from contradictory premises"). It would also hide the paper's real gap (F_{h(X)}(0)=0) inside a false parameter instead of locating it at S2. Fix: A1. |

## Item 7. Doubts about the source (preliminary only; not ruled here)

1. F:171/F:180 (with Def 2.2 F:124): $F_{h(X)}(0)=0$ is never established and fails for h(x) = max(x−1,0), which satisfies every printed hypothesis. Preliminary: **ERROR** (printed conclusion false) or PAPER_ASSUMPTION_GAP (missing a positivity hypothesis on h). Dispatch pv-issue-checker. This is distinct from L01 issue 1: fixing L01 does not repair it.
2. F:174 "every function considered is increasing": star-shaped (F:111) does not imply increasing (h = −x, x²−x), and the h^{-1} of F:111 is defined only for increasing v. Preliminary: **PAPER_ASSUMPTION_GAP**. Dispatch pv-issue-checker (may be merged with 1).
3. F:180 use of L01 "if": inherits L01_issue_1 (upstream issue; per VERDICTS §1, not written into T01's issues).
The drafter's other leads (generalised-inverse formula "as h is continuous", $h^{-1}(x)\ge0$): my preliminary reading is FAIR_IMPLICIT_STEP for x ≥ 0 (see S1 analysis), and no dispatch is needed.

## TFA table
| Premise | Where | Ruling |
|---|---|---|
| (none proposed by the drafter on the main theorem) | | |
| `BddAbove {y | 0 ≤ y ∧ h y ≤ x}` (required by A2) | S1 only, not the main theorem | APPROVED as an obligation-local encoding premise: it excludes only the case $h^{-1}(x)=+\infty$ where our `sSup` junk differs from the source. The assembly must derive it (see item 5), so it is not a main-theorem TFA |

## Required changes

- **A1** (`pv_work/T01Stmt.lean`, lines 30-36). Replace the definition by the exactly consumed clauses, with the `←` half restricted by Def 2.2's own presupposition (a specialisation, so weaker than L01, allowed by VERDICTS §4.2):
  ```lean
  def T01_L01Consumed : Prop :=
    ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
      (IsInvSub μ → SubCond μ) ∧ (F μ 0 = 0 → SubCond μ → IsInvSub μ)
  ```
  Update the docstring to: provenance (p), counts as (iv) since L01 is ISSUE (upstream issue L01_issue_1). Location in L01: "only if" and "if" halves of Lemma 2.3 (F:128-134), the latter with the added premise `F μ 0 = 0` (Def 2.2, F:124). Applicability: `→` is applied to μ (X ITS, satisfied). `←` is applied to `μ.map h` at F:180, and its premise `F (μ.map h) 0 = 0` is exactly S2, which the source never establishes (recorded gap).
- **A2** (`pv_work/T01Draft.lean`, `T01_S1`, lines 16-18). Add the premise `(hbdd : BddAbove {y : ℝ | 0 ≤ y ∧ h y ≤ x})` after `(hx : 0 ≤ x)`, and note in the docstring that it excludes only the source's $h^{-1}(x)=+\infty$ case (junk `sSup`).
- Optional (not required): update the `T01_main` docstring to say that S2 feeds the `F μ 0 = 0` premise of the amended consumed clause.

No other change is requested. In particular, do **not** add positivity or monotonicity of h to `T01_main`.

## Statement snapshot (pre-amendment; `#pv_type_hashes_here` on the gate copies)

`pv_work/logs/gate_T01_stmtcopy_1.log`:
```
TYPE HASHES (current file, 5 declarations)
Paper.T01.AntiStarShaped|def|th=4254974927|vh=1666840368|bi=e
Paper.T01.StarShaped|def|th=4254974927|vh=2775174033|bi=e
Paper.T01.T01_L01Consumed|def|th=3944470172|vh=2484386763|bi=
Paper.T01.T01_X02Tool|def|th=3944470172|vh=4251682764|bi=
Paper.T01.ginv|def|th=2287483187|vh=2419902270|bi=ee
EXIT=0
```

`pv_work/logs/gate_T01_draftcopy_1.log`:
```
TYPE HASHES (current file, 8 declarations)
Paper.T01.T01_S0|thm|th=2863022550|vh=-|bi=eee
Paper.T01.T01_S1|thm|th=1327734917|vh=-|bi=eceeeeee
Paper.T01.T01_S2|thm|th=193369578|vh=-|bi=eceeee
Paper.T01.T01_S3|thm|th=656790863|vh=-|bi=eeeee
Paper.T01.T01_S4|thm|th=1203755882|vh=-|bi=eeeeee
Paper.T01.T01_S5|thm|th=4211601353|vh=-|bi=eceeeee
Paper.T01.T01_S6|thm|th=274719269|vh=-|bi=eceeeee
Paper.T01.T01_main|thm|th=1280967929|vh=-|bi=eeeceeee
EXIT=0
```
After A1/A2, `T01_L01Consumed` (vh), `T01_S1` (th) and the `T01Stmt.olean` will change. The r2 check must re-snapshot.

STATEMENT GATE: PASS_WITH_AMENDMENTS

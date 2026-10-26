# T02 statement gate (Theorem 3.1, thm:main), revision 1 of the manuscript

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 11:01:32 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  a99991e0222d74ac2ea3ce9365e6f6b2fd6d9f52526f144d2eea59dc07af2e58 (identical to the pre-revision gate, `verification/audits/rev1/T02_gate.md`)
  - `pv_work/T02Draft.lean` 67b27187ee9426e275bee7ff05a6195fca16da5302f37e5dcad30b4aa6d93f28
  - `source/SuperParetoPaper-v12.tex` 34ff8651a0a6bdceb041fa7387ea7748cb79d9fa7cec5a51901876cd24671add
  - also read: `pv_work/L01Stmt.lean` (F, IsInvSub, SubCond), the draft notes (leads only), `verification/audits/rev1/T02_gate.md`, `T02_gate_r2.md`
- Revision check: `diff` of `verification/source_baseline_v1/SuperParetoPaper-v12.tex` against `source/SuperParetoPaper-v12.tex` shows changes **only** at :219-233 (old :219-256). The statement (:186-189), (eq:main-st) (:95-98), Def 2.1 (:115-118), Def 2.2 (:122-125), Lemma 2.3 (:128-135) and the base case (:190-217) are unchanged.
- Compilation: `scripts/pv_lean.sh check T02Draft` gave `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_6.log`
- Snapshot probes: `pv_work/logs/gate_T02_v2_stmtcopy_1.log` (exit 0, 0 sorry), `pv_work/logs/gate_T02_v2_draftcopy_1.log` (exit 0, 9 sorry). Copies: `pv_work/probes/gate/T02/gate_T02_v2_stmtcopy.lean`, `gate_T02_v2_draftcopy.lean` (new names, so the pre-revision gate copies are kept).

## Source quotations

- :95-98: "given $n$ i.i.d. copies of $X$ ... and weights $\theta_1,\ldots,\theta_n\geq0$ such that $\theta_1+\cdots+\theta_n=1$, we have $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$" (eq:main-st).
- :113: "$F_X$ and $\Fbar_X=1-F_X$ its cumulative distribution and survival functions".
- :115-118 (Def 2.1): "$X\leqst Y$, if $\Fbar_X(x)\leq\Fbar_Y(x)$, for every $x\in\mathbb{R}$."
- :122-125 (Def 2.2): "$X$ such that $F_X(0)=0$ is ITS if $F^-_{1/X}$ is subadditive."
- :128-135 (Lemma 2.3), :132-133 (eq:sub-1x): $F_X(x/\theta)+F_X(x/(1-\theta))\le F_X(x)+1$, $\forall x\ge0,\ \theta\in(0,1)$.
- :186-188 (Thm 3.1): "If $X$ is ITS, then the stochastic dominance (eq:main-st) holds."
- :191-201, :217: base case $n=2$ (integral formula, Figure 1 bound, (eq:sub-1x)), "for every $x\geq 0$ and $\theta\in(0,1)$".
- :219 (new): "Assume now that (eq:main-st) holds whenever considering $n-1$ random variables and $n-1$ nonnegative weights that sum up to $1$. Given $\theta_1,\ldots,\theta_n>0$ ... we will produce an upper bound for the complementary probability. First note that, using the induction hypothesis, we have that"
- :221-224: $P(\sum\theta_iX_i\le x) = \int_0^{x/\theta_n} P(\frac{\theta_1X_1+\cdots+\theta_{n-1}X_{n-1}}{1-\theta_n}\le\frac{x-\theta_nt}{1-\theta_n})F_X(dt) \le \int_0^{x/\theta_n}F_X(\frac{x-\theta_nt}{1-\theta_n})F_X(dt)$.
- :226-231: "this integral has exactly the same form as the one bounded in the first step, so we may use the same argument ... Figure 1": $\le F_X(\frac{x}{1-\theta_n})F_X(x)+F_X(x)(F_X(\frac{x}{\theta_n})-F_X(x)) \le F_X(x)$.
- :233: "taking into account (eq:sub-1x). Taking complements, ... $P(\sum\theta_iX_i>x)\geq\Fbar_X(x)$, which concludes the proof."

## Item 1: hypotheses. PASS

- ITS: `IsInvSub (μ.map X)` (L01 encoding of Def 2.2, includes `F_X(0)=0`).
- i.i.d.: `IIDCopies` (measurability, `iIndepFun`, `IdentDistrib` to `X`); no hidden hypothesis in the structure, no `variable` hypothesis on `T02_main`.
- Weights `0 ≤ θ i`, `∑ θ i = 1`, as printed at :95 (NOT the proof's `> 0`; correctly left unrepaired). `[IsProbabilityMeasure μ]` standard. No extra premise; no conclusion-shaped premise. `hL01` is the declared (p) parameter.

## Item 2: conclusion. PASS

`StDom μ X (∑ θ i * Xs i)`: Def 2.1 for every real `x`, compared in `ℝ≥0∞`. Neither weakened nor strengthened.

## Item 3: quantifiers and constants. PASS

No constants; everything universally quantified as in the source.

## Item 4: domains and details. PASS

- `toReal` in the step obligations: all measures are finite (probability), no truncation trap.
- `∫_0^{x/θ}` read as `∫ t in Icc 0 (x/θ) … ∂(μ.map X)`: the law has no mass on `(-∞,0]` and the integrand vanishes at `t = x/θ` (`F(0)=0`, resp. `P(Y ≤ 0) = 0` for a positive combination of a.s. positive variables), so the choice of endpoints is immaterial.
- Real-valued `X` (the domain note of the pre-revision gate, Ex 2.7 mass at `+∞`) still applies, but the old atom-sensitive lines (:222-223 of v1, issue A) are gone: the new :223-224 uses `P(Z ≤ y) ≤ F_X(y)`, which is the exact complement of the IH with no atom question.

## Item 5: step obligations. PASS

Statement hashes of S1-S4 are identical to the pre-revision snapshot (base case unchanged in the source, :190-217). S5-S8 are new and match the new text :219-233 line by line.

| Step | Source | Faithful | True as stated? | Note |
|---|---|---|---|---|
| S1 | :191-194 | yes | TRUE | unchanged (pre-revision ruling stands) |
| S2 | :195-198 | yes | TRUE | split `[0,x]` (integrand ≤ `F(x/(1-θ))`, mass `F(x)` by `F(0)=0`) and `(x,x/θ]` (integrand ≤ `F(x)`, mass `F(x/θ)-F(x)`); `x ≤ x/θ` since `θ<1`; integrand antitone hence measurable and bounded |
| S3 | :198-201 | yes | TRUE | `F(x)·(F(x/(1-θ))+F(x/θ)-F(x)-1) ≤ 0` by SubCond and `F(x) ≥ 0` |
| S4 | :217 | yes | TRUE | covers all real `x`; `x<0` trivial since `X>0`, `θX₁+(1-θ)X₂>0` a.s. (fair implicit step) |
| S5 | :219-223 (first line) | yes | TRUE | conditioning on `X_last` (independent of `Y = ∑_{i<m} θ_i X_i`), `1-θ_last > 0` (m ≥ 1 positive other weights), dividing by it preserves the event; mass outside `[0,x/θ_last]` contributes 0. Uses no IH, consistent with the source (the IH is consumed only at the `≤` line). `hm : 2 ≤ m` is the source's step range (n ≥ 3); `m ≥ 1` would suffice, so the binder only weakens. |
| S6 | :224 | yes | TRUE | `hIH` is the source's IH (:219) at the normalised weights `θ_i/(1-θ_n)` (positive, sum 1; implicit normalisation = FAIR_IMPLICIT_STEP). Pointwise `∑(θ_i/(1-θ_l))X_i = (∑θ_iX_i)/(1-θ_l)`, so `P(Z ≤ y) = 1 - P(Z>y) ≤ 1 - P(X>y) = F(y)`; both integrands monotone in `t`, bounded ⇒ integrable; `integral_mono`. No `hm` binder: at `m = 0`, `1-θ_last = 0` and `hIH` reads `μ{x<X} ≤ μ{x<0}`, false at `x=0` (`μ{0<X}=1`), so the obligation is vacuously true; for `m ≥ 1` true as above. Not a defect. |
| S7 | :226-230 | yes | TRUE | S2 with `θ := θ_last ∈ (0,1)` (`hm` gives another positive weight) and `F(0)=0` from `hits`. Faithful to "the same argument ... Figure 1". |
| S8 | :231-233 | yes | TRUE | S5 ≤ S6 ≤ S7 ≤ (S3 at `θ_last`) gives `P(sum ≤ x) ≤ F(x)`; complement gives `P(sum>x) ≥ 1-F(x) = P(X>x)`. Restricted to `x ≥ 0` as printed. |

No obligation smuggles in the conclusion: `hIH` (S6, S8) is the IH for `m` variables, the conclusion is for `m+1`; this is the source's induction.

Assembly into `T02_main` (by induction on `n`): `n=2` from S4; step `n ≥ 3` from S8 for `x ≥ 0`, with the IH obtained from `T02_main` at `m` for `Xs ∘ castSucc` (still i.i.d. copies) and the normalised weights. **Not covered by any obligation, by design (no source text):** (a) `x < 0` in the step (trivial, FAIR_IMPLICIT_STEP); (b) `n = 1` (trivial, identical distribution); (c) zero weights `θ_i = 0` (:95 allows them; :191 `θ∈(0,1)`, :219 `θ_i>0`; reduction to fewer variables unwritten). So `T02_main` cannot be assembled purely from the source route because of (c); this is recorded as a suspected paper-side gap, not repaired, which is the correct treatment.

The pre-revision false-as-stated obligation S10b (old :256) no longer exists; its paper text was removed by the revision.

## Item 6: external parameters. PASS

| Name | Provenance | Ruling |
|---|---|---|
| `T02_L01Consumed` | (p), L01 Lemma 2.3 (:128-135), "only if" half only: `∀ ν prob., IsInvSub ν → SubCond ν` | APPROVED |

- Only-if direction confirmed (no `↔`, no "if" half; the "if" half is the one affected by L01 issue 1). `vh=1867989605` identical to the pre-revision snapshot, so the content is unchanged.
- Not stronger than the use: used at :201 and :231-233 exactly as ITS ⇒ (eq:sub-1x), applied to the probability measure `μ.map X` (measurable `X`). True (sketch: for `x>0`, subadditivity of `y ↦ 1-F(1/y)` at `θ/x, (1-θ)/x`; at `x=0`, `F(0) ≤ 1`).
- Not goal-shaped. Declared only in `T02Stmt.lean`, `namespace Paper.T02`, correct `<ID>_<PredID>Consumed` name, no redeclaration.
- No mathlib-absence claims to check; conditioning/Fubini is left as obligations S1/S5.
- Docstring of `T02_L01Consumed` cites ":201 and :256"; after the revision the second use is at :231-233. Comment-only, recorded in `verification/DOC_ERRATA.md` (#2); not a required change (the file is unchanged and its `.olean` must stay identical).

## TFAs ruled on

| TFA | Ruling |
|---|---|
| none proposed by the drafter | n/a |
| `hm : 2 ≤ m` in S5, S7, S8 | APPROVED: restriction to the source's induction range (:219, step for n ≥ 3); weakens the obligations only |
| `hθ : ∀ i, 0 < θ i` in S5-S8 | APPROVED as printed at :219 (it is the source's own hypothesis of the step, not an extra premise); the mismatch with `θ_i ≥ 0` at :95 is recorded below |
| `hx : 0 ≤ x` in S1-S3, S5-S8 | APPROVED as printed at :191 (range of `x` in the step not printed; read from :191) |

## Item 7: doubts about the source (preliminary; do not rule here)

- **C (zero weights).** :95 (`θ_i ≥ 0`) vs :191 (`θ∈(0,1)`) and :219 (`θ_i > 0`): zero weights and `n=1` are never treated; the reduction to fewer variables is unwritten. Preliminary class: EXPOSITION_GAP. Dispatch pv-issue-checker (no issue file exists for this yet; only issue B was ruled, `rev1/T02_issue_1.md`).
- **D (x ≥ 0 only).** :191, :219-233 vs Def 2.1 (:117, every real `x`): `x<0` not written; follows from `F_X(0)=0`. Preliminary class: FAIR_IMPLICIT_STEP (not an issue); dispatch not needed unless the coordinator wants it confirmed.
- **Normalisation** of the IH weights (:219 vs :223): FAIR_IMPLICIT_STEP.
- **B (old :256) and A (old :222-223)**: the text concerned was removed in revision 1; the new step does not reproduce them. The follow-up status of issue B should be updated by the coordinator (resolved by revision), not by this gate.

## Required changes

None. `T02Stmt.lean` and `T02Draft.lean` may be used as is.

## Statement snapshot

`T02Stmt.lean` (copy `pv_work/probes/gate/T02/gate_T02_v2_stmtcopy.lean`, log `pv_work/logs/gate_T02_v2_stmtcopy_1.log`):
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

`T02Draft.lean` (copy `pv_work/probes/gate/T02/gate_T02_v2_draftcopy.lean`, log `pv_work/logs/gate_T02_v2_draftcopy_1.log`):
```
TYPE HASHES (current file, 9 declarations)
Paper.T02.T02_S1|thm|th=2536064818|vh=-|bi=iceceeeeeeeeeeeeee
Paper.T02.T02_S2|thm|th=675241779|vh=-|bi=eceeeee
Paper.T02.T02_S3|thm|th=1086017434|vh=-|bi=eeceeeee
Paper.T02.T02_S4|thm|th=2873665920|vh=-|bi=eiceceeeeeeeeeeee
Paper.T02.T02_S5|thm|th=2677571931|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S6|thm|th=423070263|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S7|thm|th=647170896|vh=-|bi=iceceieeeeeeeee
Paper.T02.T02_S8|thm|th=2010949643|vh=-|bi=iceceieeeeeeeeeee
Paper.T02.T02_main|thm|th=703880595|vh=-|bi=eicecieeeeeee
EXIT=0
```

Comparison with the pre-revision snapshot (`verification/audits/rev1/T02_gate_r2.md`), line by line from the hash output:
- `T02Stmt.lean`: all 14 lines identical (th, vh, bi); file sha256 also identical.
- `T02_main`: `th=703880595`, `bi=eicecieeeeeee`, identical: **the main statement is unchanged**.
- `T02_S1`-`T02_S4`: identical (base case unchanged).
- Old `T02_S5`, `S6a`, `S6b`, `S7`, `S8`, `S9`, `S10a`, `S10b`, `S11` removed; new `T02_S5`-`T02_S8` (different statements, reviewed above).

## Overall verdict

The main statement and the consumed clause are unchanged and faithful; the eight obligations match the rewritten proof text step by step and are true as stated; zero weights and the `x ≥ 0` restriction are recorded as suspected gaps, not repaired.

STATEMENT GATE: PASS

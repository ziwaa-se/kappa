# P04 statement gate, round 2 (Proposition 4.6, prop:conv) — full review of redraft after FAIL

- Reviewer: pv-gate (fresh subagent, claude-opus-5-5); full review, not only the changed parts.
- Date: Tue Oct 13 01:45:28 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P04Stmt.lean` 84cc56ad9ac6bb79afa549adadfa04d9e81e120377e0d4afe03b3141b513adb7
  - `pv_work/P04Draft.lean` 5040826f1601271c80877894a0728acde883308fe779ee4536720d6726d3758b
  - `pv_work/notes/P04_draft_notes.md` ec762ce72054e649db8b10bfd3863081ce76fbb4eca7967d439a189a6b778cdb (leads only)
- Compilation: `scripts/pv_lean.sh check P04Draft` -> `exit=0 errors=0 sorry_warnings=5 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_4.log`.
- Snapshot probes: `pv_work/logs/gate_P04_stmtcopy_r2_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_P04_draftcopy_r2_1.log` (exit=0, 5 sorry). Copies: `pv_work/probes/gate/P04/gate_P04_stmtcopy_r2.lean`, `gate_P04_draftcopy_r2.lean`.

## Source quotations (read directly in source/SuperParetoPaper-v12.tex)

- :111 "increasing ... taken as non-decreasing ...; the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}: v(x)\le u\}$."
- :113 $F_X$, $\Fbar_X=1-F_X$, odds $\Lambda_X=F_X/\Fbar_X$; "we shall not be assuming the existence of densities".
- :279 $\mathcal P(x)=1-1/x$, $x\ge1$.
- :286 Def (super-Pareto): $Y\stackrel d= h(Z)$, $F_Z=\mathcal P$, $h$ increasing, convex, nonconstant.
- :298 (Prop 1 of superPareto2024, cited): super-Pareto iff $1/\Fbar_X$ concave.
- :301 $\Lambda_X=1/\Fbar_X-1$; concavity of $\Lambda_X$ iff decreasing odds rate (side derivatives).
- :306 DOR iff $\Lambda_X$ concave. :310 $F_1\le_c F_2$ iff $F_2^{-1}\circ F_1$ convex.
- :317 "$F_X$ is DOR (or, equivalently, $X$ is super-Pareto) iff $\mathcal P\le_c F_X$. Analogously $F_X$ has increasing odds rate iff $F_X\le_c\mathcal P$."
- :320 "$\mathcal P^{-1}(u)=\frac1{1-u}$, ... $\mathcal P^{-1}\circ F_X=1/\Fbar_X=\Lambda_X+1$, so the result follows immediately."
- :323 (usage) Fréchet: "$\Lambda_{\mathcal H}$ is convex, hence $\mathcal H\le_c\mathcal P$" — confirms "increasing odds rate" = convex odds.

## Hash comparison with round 1 (by `#pv_type_hashes_here`, not by eye)

Changed: `quantile` vh (A1), `DOR` vh (A2), `P04_X01Tool` vh (A2), `P04_S4` th (A3), `P04_main` th (A3). All other 13 lines identical to round 1. No change outside A1–A3.

## Item 1. Hypotheses: PASS

- `IsProbabilityMeasure μ` ("random variable X"). No hidden hypotheses (no structures/classes/variables beyond `open`).
- `hnd : ∀ c, μ ≠ Measure.dirac c` on S4 and `P04_main` only: TFA, see TFA table.
- `hX01 : P04_X01Tool` on S5 and main: now true as stated (item 6), so main is not vacuous.
- No conclusion-as-hypothesis or equivalent: `hnd` is not implied by, nor implies, any clause.

## Item 2. Conclusion: PASS

Three clauses of :317 present: DOR ↔ 𝒫≤c F; SuperPareto ↔ 𝒫≤c F (the parenthetical); IOR ↔ F≤c 𝒫. Neither weakened nor strengthened relative to the encoded definitions.

## Item 3. Quantifiers / constants: PASS

No constants; μ universally quantified.

## Item 4. Domains and details: PASS

- A1 implemented: `quantile G u := sSup {x | G x ≤ u}` = :111 exactly. For a cdf G and u∈(0,1) the set is nonempty and bounded above, so real `sSup` has no junk value on the domains used (`suppIn paretoCdf = (1,∞)` gives u = 1−1/x ∈ (0,1); `suppIn (F μ)` gives F x ∈ (0,1)).
- A2 (`∀ x, F μ x < 1` in `DOR` and X01 RHS): faithful encoding, not an alteration. The source's Λ_X, 1/Fbar_X take value +∞ wherever Fbar_X = 0; a concave function (values in ℝ or [−∞,∞)) cannot take +∞, so "Λ_X concave" in the source's sense requires Fbar_X > 0 everywhere. This reading is also the one forced by the source's own identification DOR ⟺ super-Pareto (:301, :317): a super-Pareto law h(Z) with h convex, increasing, nonconstant is unbounded above, i.e. F < 1 everywhere. The suppIn-only reading (round 1) manufactured counterexamples; the new reading removes them and introduces none (see item 5). The domain `suppIn` itself (whole-line concavity impossible: Pareto's Λ = max(0,x−1)) remains our choice; the source's silence on the domain remains a preliminary DOMAIN_CLARIFICATION (item 7).
- IOR keeps `suppIn` without F<1: consistent, since a convex function may take +∞ (extended sense) at the top of a bounded support; and IOR, F≤c𝒫 are both encoded on the same set (S3). Reading of "increasing odds rate" as Λ convex is supported by :301 and :323.
- Checked by hand: ½δ₀+½δ₁ — DOR false (F(1)=1), X01 RHS false, not super-Pareto, 𝒫≤c F false (transform 0 on (1,2], 1 on (2,∞)); consistent. δ₀ — DOR false, X01 RHS false, not super-Pareto; 𝒫≤c δ₀ true (constant transform) — excluded by `hnd`.
- Other details unchanged and PASS: `F` = `ProbabilityTheory.cdf`; `Lam` real division only on `suppIn` (Fbar>0 there); `paretoMeasure` = density x⁻² on (1,∞) via `ENNReal.ofReal` of a nonnegative value (no truncation), total mass 1; `SuperPareto` with h measurable, monotone and convex on [1,∞), nonconstant on [1,∞) (equivalent to nonconstant on (1,∞) given monotone+convex), law = map h.

## Item 5. Step obligations: PASS

| Step | Source | True as stated? | Smuggling? | Ruling |
|---|---|---|---|---|
| S1 | :320 𝒫⁻¹(u)=1/(1−u) | True: {x : 𝒫 x ≤ u} = (−∞, 1/(1−u)] for u∈(0,1), sup = 1/(1−u) | no | PASS |
| S2 | :320 𝒫⁻¹∘F = 1/Fbar = Λ+1 | True on `suppIn (F μ)` (F∈(0,1), Fbar>0; (F+Fbar)/Fbar = 1/Fbar) | no | PASS |
| S3 | :320 → :317 clause 3 | True: both sides are ConvexOn of the same set; functions differ by +1 there (S2) | no | PASS |
| S4 | :320 "follows immediately" → :317 clause 1 | True under `hnd` (sketch below), false without `hnd` (Dirac) | no; stays an unfilled GAP obligation (X13) as required | PASS |
| S5 | :317 parenthetical via X01 + :301 | True relative to X01: both RHS share `∀x, F<1`; on `suppIn`, 1/Fbar = Λ+1 and concavity is invariant under +1 | no | PASS |
| assembly | | `P04_main` = ⟨S4, S5.symm.trans S4, S3.symm⟩, compiles | | PASS |

S4 truth sketch (gate's own check, not a proof and not a ruling on the paper): (⇒) F<1 and 1/Fbar concave on S={0<F<1} force S = [a,∞) or (a,∞) with a finite (concave increasing on ℝ cannot stay >1 at −∞), 1/Fbar strictly increasing (concave, →∞), so F = atom at a then continuous strictly increasing; then x ↦ F⁻¹(1−1/x) equals a on (1, 1/Fbar(a)] and the inverse of 1/Fbar afterwards, continuous: convex. (⇐) the transform g is convex, increasing on (1,∞); if F(b)=1 for some b, g is bounded, hence constant, hence μ Dirac (excluded by `hnd`); so F<1, g is constant then strictly increasing and continuous, and 1/Fbar on S is its inverse: concave. Without `hnd`, δ_c satisfies 𝒫≤c δ_c but not DOR, so `hnd` is genuinely needed.

## Item 6. External parameters: PASS

`P04_X01Tool` (provenance (i), Prop 1 of superPareto2024, cited at :296-299): declared only in `P04Stmt.lean` (grep of pv_work: only P04 files and superseded copies), in `namespace Paper.P04`, no redeclared name. Not goal-shaped (it is the cited characterisation, used only for the parenthetical). Not stronger than the source's use: it is exactly :298 under the shared encoding. Now true as stated (gate check): forward, h convex increasing nonconstant on [1,∞) is constant on (1,x₀] then strictly increasing to ∞, so F<1 and 1/Fbar = h⁻¹ on [h(x₀),∞), concave; backward, h := (1/Fbar)⁻¹ extended by the constant a gives the law. "mathlib does not have it": paper-specific class; no search needed. Human check remains: domain/strictness conventions of the original Prop 1.

## Item 7. Doubts about the source (preliminary only; not ruled here)

- :320 / :317 clause 1 — proof computes only 𝒫⁻¹∘F_X (the transform for F_X≤c𝒫); clause 1 needs convexity of F_X⁻¹∘𝒫 (concave-increasing / convex-inverse duality with the :111 generalised inverse, atoms). Preliminary: PAPER_ARGUMENT_GAP or FAIR_IMPLICIT_STEP. Dispatch pv-issue-checker.
- :317 clauses 1–2 at Dirac X: 𝒫≤c δ_c holds, δ_c is neither super-Pareto (:286 nonconstant h) nor DOR in the real-valued sense. `hnd` excludes this as a TFA, but the printed statement is literally false there. Preliminary: EXPOSITION_GAP (degenerate case not discussed). Dispatch pv-issue-checker.
- :306 / :298 / :317 — domain of concavity of Λ, 1/Fbar and of convexity in :310 unstated; "increasing odds rate" not formally defined. Preliminary: DOMAIN_CLARIFICATION / EXPOSITION_GAP.

## TFA table

| TFA | Status | Reason |
|---|---|---|
| `IsProbabilityMeasure μ` | approved | "random variable X" |
| `hnd : ∀ c : ℝ, μ ≠ Measure.dirac c` (S4, `P04_main`) | approved | excludes only the degenerate one-point law, which the source never discusses (and which :286 excludes from super-Pareto); not the conclusion or equivalent; needed (S4 false at δ_c). The Dirac case is recorded separately in item 7 for the issue checker, so the TFA does not hide it. |
| `∀ x, F μ x < 1` inside `DOR` / X01 | not a TFA — part of the encoded definition (item 4, A2); approved as faithful | |

## External parameter table

| Name | Provenance | Status |
|---|---|---|
| `P04_X01Tool` | (i) Prop 1, superPareto2024 (:296-299) | approved |

## Required changes

None. (A1–A4 of `P04_gate.md` implemented; S4 remains an unfilled gap obligation. Editorial only: S3 docstring "source :320-317" — no action needed.)

## Statement snapshot

Stmt copy (`pv_work/logs/gate_P04_stmtcopy_r2_1.log`):
```
TYPE HASHES (current file, 12 declarations)
Paper.P04.ConvexTransformLE|def|th=3790785477|vh=4142033147|bi=ee
Paper.P04.DOR|def|th=3905129696|vh=2211162573|bi=e
Paper.P04.Fbar|def|th=390107078|vh=3188116820|bi=ee
Paper.P04.F|def|th=390107078|vh=2204204658|bi=ee
Paper.P04.IOR|def|th=3905129696|vh=709822800|bi=e
Paper.P04.Lam|def|th=390107078|vh=1060973009|bi=ee
Paper.P04.P04_X01Tool|def|th=3944470172|vh=3975418912|bi=
Paper.P04.SuperPareto|def|th=3905129696|vh=2740489307|bi=e
Paper.P04.paretoCdf|def|th=3468892319|vh=1828619286|bi=e
Paper.P04.paretoMeasure|def|th=3087119417|vh=1064029993|bi=
Paper.P04.quantile|def|th=2287483187|vh=1543156229|bi=ee
Paper.P04.suppIn|def|th=3181325001|vh=2959148679|bi=e
```
Draft copy (`pv_work/logs/gate_P04_draftcopy_r2_1.log`):
```
TYPE HASHES (current file, 6 declarations)
Paper.P04.P04_S1|thm|th=2222932460|vh=-|bi=eee
Paper.P04.P04_S2|thm|th=3130489372|vh=-|bi=ecee
Paper.P04.P04_S3|thm|th=644444803|vh=-|bi=ec
Paper.P04.P04_S4|thm|th=4099464923|vh=-|bi=ece
Paper.P04.P04_S5|thm|th=119823538|vh=-|bi=eec
Paper.P04.P04_main|thm|th=1298071202|vh=-|bi=eece
```

## Overall verdict

PASS: statement faithful under the recorded encoding choices; all obligations true as stated (S4 under the approved TFA `hnd`), S4 kept as an unfilled gap obligation; external parameter X01 true, type (i), correctly placed. Proof work may begin.

STATEMENT GATE: PASS

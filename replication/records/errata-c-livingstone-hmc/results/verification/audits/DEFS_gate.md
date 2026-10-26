# Statement gate: DEFS (shared definitions `pv_work/Defs.lean`)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Mon Oct 12 21:55:38 EDT 2026 (from `date`)
- Reviewed file: `pv_work/Defs.lean`, sha256 `e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472`
- Compilation: `scripts/pv_lean.sh check Defs` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/Defs_2.log`
- Snapshot copy: `pv_work/probes/gate/DEFS/gate_DEFS_defscopy.lean` (verbatim copy + `import PVTools` + `#pv_type_hashes_here`), probe `exit=0`, log `pv_work/logs/gate_DEFS_defscopy_1.log`
- Drafter notes `pv_work/notes/DEFS_draft_notes.md` read as leads only; every item below was checked against the `.tex` directly.

## Source quotations (source/geo_erg_HMC_v3.1.tex)

- TEX:192: "we restrict attention to $\X = \R^d$ (and write $\|x\|$ for the Euclidean norm of $x \in \X$)".
- TEX:320: "probability densities of the form $\pi(x) \propto e^{-U(x)}$ for some $U:\X \to [0,\infty)$".
- TEX:321-323: $H(x,p) = U(x) + \frac12 p^t M^{-1} p$. TEX:324: "Provided $U(x)$ is differentiable".
- TEX:331-336: $p_{t+\e/2} = p_t - \frac{\e}{2}\nabla U(x_t)$, $x_{t+\e} = x_t + \e M^{-1}p_{t+\e/2}$, $p_{t+\e} = p_{t+\e/2} - \frac{\e}{2}\nabla U(x_{t+\e})$, $L$ steps, "for some step-size $\e>0$".
- TEX:342-350 (Alg. 1): $\delta \leftarrow H(x_0,p_0) - H\circ\varphi_T(x_0,p_0)$; accept if $\log u < \delta$.
- TEX:354-356: "we assume $M = I$".
- TEX:367-369: $\alpha(x_0,x_{L\e}) = 1 \wedge \frac{\pi(x_{L\e})}{\pi(x_0)}\exp(\frac12\|p_0\|^2 - \frac12\|p_{L\e}\|^2)$; TEX:949 same with $\exp(U(x_0)-U(x_{L\e}) + \dots)$.
- TEX:865-866 (17): $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- TEX:868-871 (18): "there is a fixed $C<\infty$ such that whenever $\|y\|\ge 2\|x\|\ge C$ then $\|\nabla U(y)\|\ge 3\|\nabla U(x)\|$".
- TEX:874 (19): $\lim_{\|x\|\to\infty,\ \|y\|\ge 2^L\|x\|}(U(x)-U(y)-\frac12\|x\|^2) = -\infty$.
- TEX:885/900/942: "for all $\|x_0\|>\eta$ and any $\|p_0\|\le\|x_0\|^\delta$ for some $\delta<1$"; "$\lim_{\|x_0\|\to\infty,\|p_0\|\le\|x_0\|^\delta}\alpha(x_0,x_{L\e}) = 0$".

## Item rulings

### 1. Hypotheses (hidden assumptions in definitions) — PASS
No `structure`, type class or `variable` carries hidden hypotheses. Definitions bake in no assumption. Not encoded in Defs and therefore to be decided per statement (not a Defs defect):
- `U ≥ 0` (TEX:320) and integrability of `e^{-U}` (finite target, TEX:192): not used by Lemmas 5.15-5.17; each Stmt gate must note whether it is assumed.
- `ε > 0` (TEX:336) is not built into `leapfrogStep`; must appear as a hypothesis in each Stmt.
- `IsGradField U gU` is optional by design. Recommendation (not required): Stmts that mention both `U` and `gU` (Lemma 5.17, Theorem 5.14) should assume `IsGradField U gU` to match "∇U is the gradient of U"; omitting it yields a more general statement, which each Stmt gate must then accept explicitly.

### 2. Conclusion — N/A (definitions only); no theorem/obligation in the file — PASS

### 3. Quantifiers / constants — PASS
- `HypOscillations`: `∃ C : ℝ, ∀ x y, 2‖x‖ ≤ ‖y‖ → C ≤ 2‖x‖ → 3‖gU x‖ ≤ ‖gU y‖` is exactly "fixed C<∞, whenever ‖y‖≥2‖x‖≥C". C chosen before x,y, as in the source.
- `HypOscillation2`: the filter `comap (‖q.1‖) atTop ⊓ 𝓟{2^L‖x‖ ≤ ‖y‖}` unfolds to: for every M there is R such that for all (x,y) with ‖x‖ ≥ R and ‖y‖ ≥ 2^L‖x‖, the expression ≤ M. This is the uniform-in-y reading, which is what TEX:970 needs (y = x_{Lε} depends on x_0, p_0). Faithful.
- `L` in (19) is free in the source (TEX:874); here it is an explicit parameter. How L is quantified relative to "for any choice T>0" (TEX:876) is left to the Theorem 5.14 Stmt gate (INVENTORY N3).

### 4. Domains and details — PASS
- `E d = EuclideanSpace ℝ (Fin d)`: norm is Euclidean, matching TEX:192.
- `piDens = exp(-U)`: unnormalised; strictly positive, so the ratio in `accProb` has no division-by-zero truncation. `π(xL)/π(x0) = exp(U x0 - U xL)`, so `accProb` agrees with both TEX:368 and TEX:949, and with Alg. 1 (P(log u < δ) = 1 ∧ e^δ, δ = H(x0,p0) - H(xL,pL), M=I).
- `H`: `(1/2)‖p‖^2 = p^t p/2` with M = I (TEX:355). Correct.
- `leapfrogStep`: checked term by term against TEX:332-334 with M = I. `leapfrogState n = (x_{nε}, p_{nε})`. Independently checked: `xLF … 1 = x0 + ε(p0 - (ε/2)∇U(x0)) = x0 - (ε²/2)∇U(x0) + εp0` (TEX:890) and `xLF … 2 = x_ε - ε²∇U(x_ε) - (ε²/2)∇U(x0) + εp0` (TEX:906). Consistent.
- `tailMomFilter d δ`: `‖q.1‖ ^ δ` is `Real.rpow` (δ : ℝ); for ‖x0‖ large the base is positive, so rpow conventions at 0 are irrelevant. Region contains p0 = 0, so for d ≥ 1 the filter is non-trivial.
- `HypExplode`: `Tendsto (‖gU x‖/‖x‖) (comap norm atTop) atTop` = TEX:866. Division by 0 only at x = 0, outside the filter's tail.
- Degenerate case d = 0: `comap norm atTop = ⊥`, so `HypExplode`, `HypOscillation2` and any limit along `tailMomFilter` hold vacuously. The source does not discuss d = 0; Stmt gates should note whether `0 < d` is assumed (relevant for Theorem 5.14, whose conclusion is not vacuous at d = 0).
- No `ENNReal`/`toReal` in the file.

### 5. Step obligations — N/A (no obligations in Defs) — PASS

### 6. External parameters — none declared in Defs — PASS
The `Hyp*` definitions are the paper's own hypotheses (17)-(19), not external tools; they are not goal-shaped. `HasGradientAt` exists in mathlib (file compiles using it).

### 7. Doubts about the source — none raised against Defs
Note for later gates (not a Defs ruling): `accProb` encodes the phase-space acceptance of Prop 4.2 (a function of (x0,p0)), while Prop 2.x (`prop:supr`, TEX:300-302) concerns the MH-type kernel on X with α(x,y) = 1 ∧ r(x,y) (TEX:163-167). Whether the theorem proof (TEX:879) correctly bridges the two belongs to the Theorem 5.14 gate / issue checker, not to these definitions.

## TFAs ruled on
None (Defs contains no premises).

## External parameters
None.

## Required changes
None.

## Recommendations (non-binding, for downstream Stmt gates)
1. Assume `ε > 0` explicitly in every Stmt using the leapfrog definitions.
2. Assume `IsGradField U gU` where both U and gU appear, or record the generalisation.
3. Record the treatment of `U ≥ 0`, `0 < d`, and the quantification of L in (19) vs T in Theorem 5.14.

## Statement snapshot (verbatim from `pv_work/logs/gate_DEFS_defscopy_1.log`)

```
TYPE HASHES (current file, 14 declarations)
Paper.Defs.E|def|th=3972626760|vh=1317487638|bi=e
Paper.Defs.HypExplode|def|th=3371666640|vh=1652790231|bi=ie
Paper.Defs.HypOscillation2|def|th=2203084122|vh=3740005225|bi=iee
Paper.Defs.HypOscillations|def|th=3371666640|vh=3819782600|bi=ie
Paper.Defs.H|def|th=3546208920|vh=3507508121|bi=ieee
Paper.Defs.IsGradField|def|th=3957315956|vh=2920123585|bi=iee
Paper.Defs.accProb|def|th=3433099469|vh=2138422550|bi=ieeeeee
Paper.Defs.leapfrogState.match_1|def|th=413685589|vh=1344119661|bi=eeee
Paper.Defs.leapfrogState|def|th=4206059416|vh=606630114|bi=ieeeee
Paper.Defs.leapfrogStep|def|th=515569345|vh=1415174749|bi=ieee
Paper.Defs.pLF|def|th=2743359568|vh=3040743533|bi=ieeeee
Paper.Defs.piDens|def|th=4080827364|vh=90937034|bi=iee
Paper.Defs.tailMomFilter|def|th=1252794912|vh=607236021|bi=ee
Paper.Defs.xLF|def|th=2743359568|vh=116598523|bi=ieeeee
EXIT=0
```

## Overall verdict
All shared definitions agree with the source at the cited lines; no required changes.

STATEMENT GATE: PASS

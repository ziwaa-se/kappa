# Statement gate: DEFS (shared definitions D01-D04)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:44:23 EDT 2026 (from `date`)
- Reviewed file: `pv_work/Defs.lean`, sha256 `1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31`
- Draft notes read as leads only: `pv_work/notes/DEFS_draft_notes.md`
- Compilation: `scripts/pv_lean.sh check Defs` -> `RESULT Defs mode=check exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/Defs_2.log`
- Snapshot probe: `pv_work/probes/gate/DEFS/gate_DEFS_defscopy.lean` (verbatim copy + `import PVTools` + `#pv_type_hashes_here`), `exit=0`, log `pv_work/logs/gate_DEFS_defscopy_1.log`
- Package status: linked (no `lake build` run).

## Source quotations (read directly)

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:28-29: "For $c \in \mathbb{R}$, the risk of the estimator $cX$ is $R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$, its mean squared error when $X$ has mean $\theta$ and variance $\sigma^2$."
- main.tex:30-31: "The oracle factor is $c^\ast = \theta^2 / (\theta^2 + \sigma^2)$."
- main.tex:32-33: "The oracle risk is $\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$."
- Uses later in the source (main.tex:39, 49, 59-60, 65, 70, 74-75) only apply R, c*, rho as these formulas; no other conventions, no constants convention.

## Item-by-item rulings

1. **Hypotheses: PASS.** D04 `Setting θ σ` is a `Prop` structure with exactly `θ ≠ 0` and `0 < σ`, matching main.tex:25. No extra premises; no type classes, `variable`s, or hidden fields. The definitions D01-D03 carry no hypotheses, which is correct: the source formulas are well-defined expressions, and D02/D03 denominators are nonzero under D04 (θ ≠ 0 gives θ²+σ² > 0), so Lean's total division agrees with the source on the whole range the source uses.
2. **Conclusion / content: PASS.** D01 `risk θ σ c = c^2*σ^2 + (1-c)^2*θ^2` is the printed formula verbatim. D02 `oracleFactor θ σ = θ^2/(θ^2+σ^2)` verbatim. D03 `oracleRisk θ σ = θ^2*σ^2/(θ^2+σ^2)` verbatim. The phrase "its mean squared error when X has mean θ and variance σ²" is a descriptive remark (the formula is the definition); omitting probability is a faithful representation choice and manufactures nothing (the identity MSE(cX) = c²σ² + (1-c)²θ² is standard and correct).
3. **Quantifiers / constants: PASS.** θ, σ, c are explicit real arguments (`bi=ee`, `eee`); c ranges over all of ℝ as in main.tex:28. No constants convention in the source.
4. **Domains and details: PASS.** All objects are real; no ENNReal/toReal, no a.e., no measurability, no existence claims. Division by zero cannot arise under `Setting`.
5. **Step obligations: N/A (PASS).** Definitions file only; no obligations. No `sorry`, no theorem statements.
6. **External parameters: N/A (PASS).** None declared.
7. **Doubts about the source: none.** The definitions are consistent; no suspected paper issue.

Naming: everything is in `namespace Paper`, as appropriate for shared definitions (`Defs*.lean`).

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | - |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None.

## Statement snapshot (verbatim from `pv_work/logs/gate_DEFS_defscopy_1.log`)

```
TYPE HASHES (current file, 12 declarations)
Paper.Setting.casesOn|def|th=3193718604|vh=425104884|bi=iiiee
Paper.Setting.mk|ctor|th=2463057330|vh=-|bi=iiee
Paper.Setting.noConfusionType|def|th=868625833|vh=1333059976|bi=iieee
Paper.Setting.noConfusion|def|th=1161041557|vh=2350489276|bi=iiiiie
Paper.Setting.recOn|def|th=3193718604|vh=3757031060|bi=iiiee
Paper.Setting.rec|rec|th=370631752|vh=-|bi=iiiee
Paper.Setting.sigma_pos|thm|th=3979656308|vh=-|bi=iie
Paper.Setting.theta_ne|thm|th=2822177398|vh=-|bi=iie
Paper.Setting|induct|th=1185911348|vh=-|bi=ee
Paper.oracleFactor|def|th=2687296866|vh=100931829|bi=ee
Paper.oracleRisk|def|th=2687296866|vh=4289151742|bi=ee
Paper.risk|def|th=3210013240|vh=241645400|bi=eee
EXIT=0
```

## Overall verdict

D01-D04 agree with main.tex:25-33; compiles cleanly; no amendments.

STATEMENT GATE: PASS

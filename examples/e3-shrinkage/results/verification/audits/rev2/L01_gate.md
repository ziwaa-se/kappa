# Statement gate: L01 (Lemma lem:square)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:58:40 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` `456d4367a87aaead1e652bd2f7bde0e259271aac77ffac71f0594c6593a259d9`
  - `pv_work/L01Draft.lean` `759eec6c7e6103f771fcf782a6acd84b8d83b4522ed1eade6113cf6021c59dfc`
  - imported `pv_work/Defs.lean` `1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31` (unchanged since DEFS gate PASS, same hash as in `verification/audits/DEFS_gate.md`)
- Draft notes `pv_work/notes/L01_draft_notes.md` read as leads only.
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none` (4 sorry = S1, S2, S3, main; expected for a draft).

## Source quotations (read directly)

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:28-29: "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"; main.tex:31: "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"; main.tex:33: "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$".
- main.tex:38-40 (statement): "For every $c \in \mathbb{R}$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:42-46 (proof): "Expanding the squares, $R(c) = (\theta^2 + \sigma^2) c^2 - 2 \theta^2 c + \theta^2$. Completing the square gives $R(c) = (\theta^2 + \sigma^2)(c - c^\ast)^2 + \theta^2 - \theta^4 / (\theta^2 + \sigma^2)$, and $\theta^2 - \theta^4 / (\theta^2 + \sigma^2) = \rho$."

## Item-by-item rulings

1. **Hypotheses: PASS.** The only hypothesis is `h : Setting θ σ`, the printed standing assumption main.tex:25 (structure fields `θ ≠ 0`, `0 < σ`, approved in DEFS gate). No extra premises, no `variable`s, no type classes beyond ℝ. No hypothesis states the conclusion or an equivalent.
   **Focus (θ²+σ²>0):** the proof divides by θ²+σ² (main.tex:44-45) without comment. Positivity follows from Setting (σ>0 alone gives σ²>0, hence θ²+σ²>0; θ≠0 also suffices). It is not added as a separate premise; the prover must derive it from `h`. This is a FAIR_IMPLICIT_STEP, not a TFA and not a paper issue. Remark: in Lean, S2, S3 and the main identity are in fact true even without `h` (if θ²+σ²=0 then θ=σ=0 and both sides are 0 under x/0=0), so the hypothesis can only weaken, never falsify; keeping it is faithful to the source.
2. **Conclusion: PASS.** `risk θ σ c - oracleRisk θ σ = (θ^2+σ^2) * (c - oracleFactor θ σ)^2` is the printed identity verbatim; single clause; neither weakened nor strengthened.
3. **Quantifiers / constants: PASS.** θ, σ fixed with the standing assumption, then `c : ℝ` arbitrary ("for every c ∈ ℝ"). No constants.
4. **Domains and details: PASS.** All real; c ranges over all of ℝ; no ENNReal/toReal, a.e., measurability, existence or finiteness issues. Lean's total division agrees with the source since θ²+σ²>0 under Setting.
5. **Step obligations: PASS.** Checked by hand for truth as stated:
   - S1 (main.tex:43): c²σ² + (1-2c+c²)θ² = (θ²+σ²)c² - 2θ²c + θ². True for all reals, no hypothesis needed; correctly stated without `h`.
   - S2 (main.tex:43-44): with s=θ²+σ²>0, s(c-θ²/s)² = sc² - 2θ²c + θ⁴/s, so R(c) = s(c-c*)² + θ² - θ⁴/s. True as stated (with `h`; even without it, see item 1).
   - S3 (main.tex:44-45): θ² - θ⁴/s = (θ²(θ²+σ²) - θ⁴)/s = θ²σ²/s = ρ. True as stated.
   - Main: R - ρ = s(c-c*)² + (θ² - θ⁴/s) - ρ = s(c-c*)² by S2, S3. Assembly closes.
   No obligation smuggles in the target or a stronger intermediate claim; each corresponds to the labelled source sentence. Note: S1 is not used by the main assembly directly (it feeds S2), matching the source route.
6. **External parameters: PASS (none).** `L01Stmt.lean` declares nothing in `namespace Paper.L01`; no `def Tool : Prop`, no consumed clauses, no redeclared names. No "mathlib lacks X" claim to check.
7. **Doubts about the source: none.** The lemma and its proof are correct as printed.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | θ²+σ²>0 is derived from Setting inside the proof (FAIR_IMPLICIT_STEP), not a premise |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None.

## Statement snapshot

Probe copies (verbatim + `import PVTools` + `#pv_type_hashes_here`):
`pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (exit=0, log `pv_work/logs/gate_L01_stmtcopy_1.log`) and
`pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (exit=0, sorry_warnings=4, log `pv_work/logs/gate_L01_draftcopy_1.log`).

L01Stmt copy:
```
TYPE HASHES (current file, 0 declarations)
EXIT=0
```

L01Draft copy:
```
TYPE HASHES (current file, 4 declarations)
Paper.L01.L01_S1|thm|th=3496134030|vh=-|bi=eee
Paper.L01.L01_S2|thm|th=954647406|vh=-|bi=eeee
Paper.L01.L01_S3|thm|th=2264002666|vh=-|bi=eee
Paper.L01.L01|thm|th=1311344541|vh=-|bi=eeee
EXIT=0
```

## Overall verdict

Statement and obligations faithful to main.tex:38-46; draft compiles (exit 0); no amendments.

STATEMENT GATE: PASS

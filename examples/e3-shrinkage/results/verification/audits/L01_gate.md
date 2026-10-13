# L01 statement gate (revision 2 re-draft)

- Reviewer: pv-gate (claude-opus-5-5), fresh subagent; did not draft L01.
- Date: Tue Oct 13 01:11:50 EDT 2026 (from `date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` 456d4367a87aaead1e652bd2f7bde0e259271aac77ffac71f0594c6593a259d9
  - `pv_work/L01Draft.lean` 6bf1cb18391ef16de60368c997cef7fc3723cd27e51a7052517af9b2cdf3d718
  - `pv_work/Defs.lean` (imported shared defs) 1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31
  - `source/main.tex` 912cac5cd9999756574dac666844f4d47760f7eb18780281625d83729084ac27
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0`, log `pv_work/logs/L01Draft_4.log` (6 sorries = S1-S5 + main, as expected for a draft).

## Source quotations (read directly)

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:28-29: "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"
- main.tex:30-31: "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"
- main.tex:32-33: "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$"
- main.tex:34: "It is the risk of the oracle factor, as Lemma~\ref{lem:square} shows." (forward remark; not a hypothesis of L01, not used in its proof; no circularity since L01's proof does not use it)
- main.tex:39-41: "For every $c \in \mathbb{R}$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:44-51: proof: $s=\theta^2+\sigma^2$, $c^\ast=\theta^2/s$, $1-c^\ast=\sigma^2/s$; $c=c^\ast+d$; displayed chain
  $R(c)=(c^\ast+d)^2\sigma^2+(1-c^\ast-d)^2\theta^2=\frac{\theta^4\sigma^2+\sigma^4\theta^2}{s^2}+2d(\frac{\theta^2\sigma^2}{s}-\frac{\sigma^2\theta^2}{s})+s d^2=\rho+s d^2$.

Defs check: `Setting` (D04), `risk` (D01), `oracleFactor` (D02), `oracleRisk` (D03) in `pv_work/Defs.lean` match :25, :29, :31, :33 literally. No hidden hypotheses (no classes, `variable`s or extra structure fields).

## Item rulings

1. Hypotheses: PASS. Only `h : Setting θ σ` (= main.tex:25). No extra premises; no conclusion-shaped hypothesis.
2. Conclusion: PASS. `risk θ σ c - oracleRisk θ σ = (θ^2+σ^2) * (c - oracleFactor θ σ)^2` is exactly :40; neither weakened nor strengthened.
3. Quantifiers/constants: PASS. θ, σ, c universally quantified; no constants chosen.
4. Domains/details: PASS. All real-valued; division only by θ²+σ² > 0 under `Setting`; no ℝ≥0∞, a.e., measurability or finiteness issues.
5. Step obligations: PASS. Checked each for truth as stated:
   - S1 (:44): true; first conjunct is definitional, second needs θ²+σ² ≠ 0, supplied by `h`.
   - S2 (:45-47): true for all reals (1-(c*+d) = 1-c*-d); no hypothesis needed, correctly none.
   - S3 (:47-48, first equality): true under `h`: c*²σ² = θ⁴σ²/s², (1-c*)²θ² = σ⁴θ²/s², linear coefficient 2d(c*σ² - (1-c*)θ²), quadratic d²(σ²+θ²).
   - S4 (:48-49, second equality): true under `h`: (θ⁴σ²+σ⁴θ²)/s² = θ²σ²/s = ρ; linear bracket is literally 0.
   - S5 (:49-51): true; equals main after rearrangement with d = c - c*.
   - Assembly: S2 at d = c - c* (c* + (c - c*) = c), S3, S4 give S5; S5 gives main by subtraction. None smuggles the conclusion beyond the source's own chain; S5 is the source's own final line "= ρ + s d², which is the claim".
6. External parameters: PASS (none). `L01Stmt.lean` declares nothing in `namespace Paper.L01`; no predecessors.
7. Doubts about the source: none. The displayed expansion at :48 is algebraically correct (verified independently above). The use of s > 0 for division is a FAIR_IMPLICIT_STEP covered by :25.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | - | No extra premises beyond `Setting`. |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | - | - |

## Required changes

None. Editorial note (not a required change, cannot be edited after review anyway): the docstring in `pv_work/L01Stmt.lean:3` cites `source/main.tex:38-40`; in the current source the lemma is at :39-41. Docstring-only slip; the coordinator may log it in `verification/DOC_ERRATA.md`.

## Statement snapshot

Copies: `pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (probe exit=0, log `pv_work/logs/gate_L01_stmtcopy_2.log`), `pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (probe exit=0, sorry_warnings=6, log `pv_work/logs/gate_L01_draftcopy_2.log`).

Stmt copy:
```
TYPE HASHES (current file, 0 declarations)
```

Draft copy:
```
TYPE HASHES (current file, 6 declarations)
Paper.L01.L01_S1|thm|th=3890704190|vh=-|bi=eee
Paper.L01.L01_S2|thm|th=1377139|vh=-|bi=eee
Paper.L01.L01_S3|thm|th=647400820|vh=-|bi=eeee
Paper.L01.L01_S4|thm|th=3459787134|vh=-|bi=eeee
Paper.L01.L01_S5|thm|th=3146976187|vh=-|bi=eeee
Paper.L01.L01|thm|th=1311344541|vh=-|bi=eeee
```

STATEMENT GATE: PASS

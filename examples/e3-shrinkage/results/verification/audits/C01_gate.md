# C01 statement gate (Corollary cor:half)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Tue Oct 13 01:22:09 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/C01Stmt.lean` 67b91dd9cae5e659f53d941df1abe152283d59138b808036a03c2c8f04f5e75c
  - `pv_work/C01Draft.lean` 779b48501f7c9f6ea20f7be8b6ac403de26e2fa0453e8441a284a153c8828101
  - `pv_work/Defs.lean` (imported) 1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31
- Also read: `pv_work/L01Stmt.lean`, `pv_work/L02Stmt.lean`, statements of `Paper.L01.L01` (L01.lean:64-65) and `Paper.L02.L02_main` (L02.lean:31).
- Compilation: `scripts/pv_lean.sh check C01Draft` -> `RESULT C01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/C01Draft_5.log olean=none`. EXIT=0; the 4 sorries are S1-S4 (expected in a draft).

## Source quotations

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:28-29: "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"
- main.tex:30-31: "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"
- main.tex:32-34: "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$. It is the risk of the oracle factor, as Lemma~\ref{lem:square} shows."
- main.tex:40 (lem:square): "For every $c$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:55 (lem:min): "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:74-76 (cor:half): "$R(c^\ast) \le R(1/2)$."
- main.tex:79-80 (proof): "By Lemma~\ref{lem:square}, $R(1/2) - R(c^\ast) = (\theta^2 + \sigma^2)(1/2 - c^\ast)^2 \ge 0$. By Lemma~\ref{lem:min}, moreover, $R(c^\ast) = \rho \le \min\{\theta^2, \sigma^2\}$."

Defs check: `risk`, `oracleFactor`, `oracleRisk`, `Setting` in Defs.lean match main.tex:25-33 literally (division in ℝ; denominator θ²+σ² > 0 under Setting, so Lean's x/0=0 convention never bites).

## Item rulings

1. Hypotheses: PASS. The only hypothesis of the source is the global setting (main.tex:25), encoded as `h : Setting θ σ` (θ ≠ 0, 0 < σ). No extra premises; no hidden hypotheses in structures/classes/variables; `Conclusion` takes no hypothesis-shaped arguments. No conclusion-as-hypothesis.
2. Conclusion: PASS. `Conclusion θ σ := risk θ σ (oracleFactor θ σ) ≤ risk θ σ (1/2)` is exactly "R(c*) ≤ R(1/2)", neither weaker nor stronger. The proof's "moreover" sentence (main.tex:80) is not part of the printed statement; it is correctly kept out of `Conclusion` (recorded as remark obligations S3, S4).
3. Quantifiers / constants: PASS. θ, σ universally quantified with the setting; no constants.
4. Domains/details: PASS. All real-valued; no ℝ≥0∞, no a.e., no measurability issues. `1 / 2 : ℝ` is the real one half.
5. Step obligations: PASS.
   - S1 (main.tex:79): R(1/2) − R(c*) = (θ²+σ²)(1/2 − c*)². True under Setting (L01 at c=1/2 minus L01 at c=c*). Corresponds to the sentence.
   - S2 (main.tex:79 "≥ 0"): true as stated for all reals (nonnegative times square); Setting not even needed. Standard implicit step.
   - S3 (main.tex:80 "R(c*) = ρ"): true (L01 at c = c*). Remark, not used in assembly.
   - S4 (main.tex:80 "ρ ≤ min{θ²,σ²}"): true (= L02 conclusion). Remark, not used in assembly.
   - None smuggles the target: S1 is the identity printed in the proof; S2 is the nonnegativity printed in the proof.
   - Assembly: `C01` follows from S1, S2 by `linarith`, and it compiles. Obligations together yield the main theorem.
   - Predecessor interfaces: `Paper.L01.L01 (θ σ) (h : Setting θ σ) (c)` and `Paper.L02.L02_main (θ σ) (hθ : θ ≠ 0) (hσ : 0 < σ)` are both available from the imported modules (FINAL_PASSED, unconditional); `L02_main`'s hypotheses are the fields `h.theta_ne`, `h.sigma_pos`. Importing them directly in Draft and not in Stmt is acceptable (no consumed clauses needed).
6. External parameters: PASS (none). No `def … : Prop` tools, no consumed clauses; Stmt declares only `Paper.C01.Conclusion` in `namespace Paper.C01`, no redeclared names.
7. Doubts about the source: see below. Not ruled on here.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises proposed or present. |

## External parameters

| Name | Ruling | Provenance |
|---|---|---|
| (none) | — | — |

## Suspected source issues (preliminary only)

- main.tex:79-80: the proof applies lem:square to the difference R(1/2) − R(c*), which literally needs R(c*) = ρ; that equality appears only in the following sentence and is attributed to lem:min, which states ρ ≤ min{θ², σ²} and does not give it. R(c*) = ρ follows from lem:square at c = c* and is also asserted at main.tex:34. Preliminary class: EDITORIAL (mis-attributed citation) / FAIR_IMPLICIT_STEP; the statement and its proof route are unaffected. Optionally dispatch pv-issue-checker to confirm the classification; the gate makes no ruling.

## Required changes

None.

## Statement snapshot

Stmt copy (`pv_work/probes/gate/C01/gate_C01_stmtcopy.lean`, log `pv_work/logs/gate_C01_stmtcopy_2.log`, exit=0):

```
TYPE HASHES (current file, 1 declarations)
Paper.C01.Conclusion|def|th=1185911348|vh=1344509186|bi=ee
EXIT=0
```

Draft copy (`pv_work/probes/gate/C01/gate_C01_draftcopy.lean`, log `pv_work/logs/gate_C01_draftcopy_2.log`, exit=0, 4 sorry warnings):

```
TYPE HASHES (current file, 5 declarations)
Paper.C01.C01_S1|thm|th=686244828|vh=-|bi=eee
Paper.C01.C01_S2|thm|th=975774998|vh=-|bi=eee
Paper.C01.C01_S3|thm|th=2392761818|vh=-|bi=eee
Paper.C01.C01_S4|thm|th=585953750|vh=-|bi=eee
Paper.C01.C01|thm|th=1472446832|vh=-|bi=eee
EXIT=0
```

## Overall verdict

The statement is faithful to main.tex:74-76 under the setting main.tex:25; obligations are true as stated and assemble to the theorem; no external parameters, no TFAs.

STATEMENT GATE: PASS

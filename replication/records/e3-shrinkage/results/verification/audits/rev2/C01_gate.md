# C01 statement gate (Corollary cor:half)

- Reviewer: pv-gate (independent subagent, Opus 5.5)
- Date: Mon Oct 12 22:26:12 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/C01Stmt.lean` 0baaaf957dc07e6e76615cc335b87c8c99a6ac031ac2a85223f144743968fef1
  - `pv_work/C01Draft.lean` 67f29826493bfa974f6490f2b109b5373bda7a6ec9b48ccbab347584f1a0353a
  - `pv_work/notes/C01_draft_notes.md` 8449e983d3dccc32e6b034b3706e82bc622304d24e80575a38a1e482a66be56f (leads only)
  - `source/main.tex` 526bc983c8c64796375a62701e0ccd4d045f6ea3073d56b03f1be2b91e9898b1
  - also read in full: `pv_work/Defs.lean`, `pv_work/L02Stmt.lean`, `pv_work/L01Stmt.lean`, `pv_work/L01.lean`; declarations of `pv_work/T01Stmt.lean` (name-collision check)
- Compilation: `scripts/pv_lean.sh check C01Draft` -> `RESULT C01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/C01Draft_2.log olean=none` (4 sorry = S1..S4, expected in a draft).

## Source quotations

- main.tex:25 "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:28-29 "$R(c) = c^2 \sigma^2 + (1-c)^2 \theta^2$"; main.tex:30-31 "$c^\ast = \theta^2 / (\theta^2 + \sigma^2)$"; main.tex:32-33 "$\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$".
- main.tex:39 (lem:square) "For every $c$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$."
- main.tex:49 (lem:min) "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:69-71 (cor:half) "$R(c^\ast) \le R(1/2)$."
- main.tex:74 "By Lemma~\ref{lem:square}, $R(1/2) - R(c^\ast) = (\theta^2 + \sigma^2)(1/2 - c^\ast)^2 \ge 0$."
- main.tex:75 "By Lemma~\ref{lem:min}, moreover, $R(c^\ast) = \rho \le \min\{\theta^2, \sigma^2\}$."

Defs (`Paper.Setting`, `risk`, `oracleFactor`, `oracleRisk`) match main.tex:25-33 verbatim and are under the DEFS gate snapshot; not re-ruled here.

## Rulings

1. **Hypotheses: PASS.** The only hypothesis is the standing assumption main.tex:25, encoded as `(h : Setting θ σ)`. No extra premise. No hidden hypotheses: `Setting` is a two-field Prop structure, no type classes or `variable`s. The main theorem `C01` has **no** `C01_L02Consumed` hypothesis; the conclusion is not assumed in any form.
2. **Conclusion: PASS.** `Conclusion θ σ := risk θ σ (oracleFactor θ σ) ≤ risk θ σ (1/2)` is exactly main.tex:70. Single clause; nothing weakened or strengthened. The second proof sentence (main.tex:75) is not part of the printed statement, so correctly not in `Conclusion`.
3. **Quantifiers/constants: PASS.** θ, σ universally quantified; no constants.
4. **Domains/details: PASS.** Real-valued throughout; `1/2 : ℝ` (elaborated in ℝ since `risk θ σ : ℝ → ℝ`); no ENNReal/toReal; division only by θ²+σ² > 0 under `Setting`.
5. **Step obligations: PASS.**
   - S1 (main.tex:74, identity): true under `Setting` (L01 at c=1/2 minus L01 at c=c*, the latter's square being 0); a fair implicit subtraction of two instances of lem:square. Not goal-smuggling.
   - S2 (main.tex:74, "≥ 0"): true (θ²+σ² ≥ 0 times a square); standard implicit step.
   - S3 (main.tex:75, "R(c*) = ρ"): true; follows from L01 at c=c*. See item 7 on attribution.
   - S4 (main.tex:75, "ρ ≤ min{θ²,σ²}" by lem:min): true as stated given `C01_L02Consumed` (and in fact true outright; L02_issue_1 records the conclusion of L02 as true). Faithful to "By Lemma lem:min".
   - Assembly: `C01` uses only S1, S2 (signatures carry no L02 hypothesis), and linarith closes `R(c*) ≤ R(1/2)` from `R(1/2)-R(c*) = X` and `0 ≤ X`. So the main theorem depends on L01 only, as the source's first sentence (main.tex:74) does. S3/S4 encode the remark (main.tex:75-76) faithfully as side obligations that do not feed the main theorem. (Dependence to be confirmed mechanically by `#pv_walk` in the final audit, since the draft still has sorry.)
6. **External parameters: PASS.** `C01_L02Consumed : Prop := ∀ θ σ, Setting θ σ → Paper.L02.Conclusion θ σ`.
   - Not stronger than the source's use: main.tex:75 applies lem:min at the same (θ,σ) under the standing assumption; L02's only hypothesis is `Setting` (main.tex:25), which holds here. `Paper.L02.Conclusion` = main.tex:49 verbatim.
   - Not goal-shaped (it is L02's conclusion, not cor:half's).
   - Provenance (p): predecessor L02 (main.tex:48-50, conclusion line 49), whose proof has a recorded PAPER_ARGUMENT_GAP (L02_issue_1); applicability: Setting θ σ is given. Correctly named `C01_L02Consumed`, declared only in `C01Stmt.lean`, in `namespace Paper.C01`; no collision (T01 uses `T01_L02Consumed`). No mathlib search needed (paper lemma).
   - Note for the coordinator: its sole consumer is S4, which the main theorem does not use; whether this affects C01's verdict is for the coordinator under VERDICTS §1, not for the gate.
7. **Doubts about the source: PASS (no dispatch needed).** main.tex:75 cites lem:min for "R(c*) = ρ ≤ min{θ²,σ²}". The natural reading is that lem:min justifies the inequality, with R(c*) = ρ a standard consequence of lem:square at c=c* (or of the definitions, directly). Preliminary class: `FAIR_IMPLICIT_STEP` / at most `EDITORIAL`; not a paper issue. The sentence is a remark not needed for the corollary. L02's own PAPER_ARGUMENT_GAP is inherited only via S4 / the (p) clause, already recorded.

## TFAs ruled on

| name | ruling | reason |
|---|---|---|
| (none proposed) | - | - |

## External parameters

| name | type | ruling | reason |
|---|---|---|---|
| `C01_L02Consumed` | (p) from L02, main.tex:48-50 | approved | equals L02's printed conclusion under the standing assumption; consumed only by S4 (remark) |

## Required changes

None.

## Statement snapshot

`pv_work/probes/gate/C01/gate_C01_stmtcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, log `pv_work/logs/gate_C01_stmtcopy_1.log`):

```
TYPE HASHES (current file, 2 declarations)
Paper.C01.C01_L02Consumed|def|th=3944470172|vh=143933708|bi=
Paper.C01.Conclusion|def|th=1185911348|vh=1344509186|bi=ee
```

`pv_work/probes/gate/C01/gate_C01_draftcopy.lean` (`scripts/pv_lean.sh probe`, exit=0, 4 sorry, log `pv_work/logs/gate_C01_draftcopy_1.log`):

```
TYPE HASHES (current file, 5 declarations)
Paper.C01.C01_S1|thm|th=686244828|vh=-|bi=eee
Paper.C01.C01_S2|thm|th=975774998|vh=-|bi=eee
Paper.C01.C01_S3|thm|th=2392761818|vh=-|bi=eee
Paper.C01.C01_S4|thm|th=3156925569|vh=-|bi=eeee
Paper.C01.C01|thm|th=1472446832|vh=-|bi=eee
```

## Overall verdict

The statement is faithful to main.tex:69-71. The main theorem depends only on L01, through S1 and S2. The remark is encoded as S3/S4, and S4 alone consumes `C01_L02Consumed`.

STATEMENT GATE: PASS

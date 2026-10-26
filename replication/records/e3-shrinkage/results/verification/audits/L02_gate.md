# L02 statement gate (revision 2 re-draft)

- Reviewer: pv-gate (independent subagent, Claude Opus)
- Date: Tue Oct 13 01:11:44 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` 0706aacdcaba4be9c94d0a42b8e97882f31759972436f03b4c66b9b10cb272c1
  - `pv_work/L02Draft.lean` c131dc3b928f6db711dd527432d7bfc8ecd7b85f1956c5422add05ef8d180b5b
  - `pv_work/Defs.lean` (imported) 1de1a18fb3644f30e48e563702b9ac69ce75585b77fc9f1ba47099648de80b31
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0`, log `pv_work/logs/L02Draft_4.log`.
- Draft notes `pv_work/notes/L02_draft_notes.md` read as leads only; all conclusions below are from the source and Lean text.

## Source quotations

- main.tex:25 "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:32-33 "The oracle risk is $\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$."
- main.tex:54-56 Lemma lem:min: "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:58-61 proof: "Since $\theta^2 + \sigma^2 > \sigma^2 > 0$, we have $\rho = \theta^2 \cdot \sigma^2 / (\theta^2 + \sigma^2) < \theta^2$, and in the same way $\rho < \sigma^2$."

Lean: `Paper.oracleRisk θ σ := θ ^ 2 * σ ^ 2 / (θ ^ 2 + σ ^ 2)` (Defs.lean:18) matches main.tex:33 exactly. `Conclusion θ σ := oracleRisk θ σ ≤ min (θ ^ 2) (σ ^ 2)` matches main.tex:55.

## Item rulings

1. **Hypotheses: PASS.** `L02_main` takes `hθ : θ ≠ 0`, `hσ : 0 < σ`, exactly the standing assumption main.tex:25 (identical to the fields of `Paper.Setting`). No extra premises, no structures/classes/variables hiding hypotheses; the conclusion is not assumed. Remark (not a required change): the brief says the steps "use Setting", but they use the two unpacked hypotheses rather than `(h : Setting θ σ)` as suggested by the Defs.lean:6 docstring. Mathematically equivalent; downstream consumers (T03) can supply `h.theta_ne`, `h.sigma_pos`. Not a fidelity issue.
2. **Conclusion: PASS.** `≤` against `min (θ^2) (σ^2)` in ℝ; neither weakened nor strengthened; single clause.
3. **Quantifiers/constants: PASS.** No constants; θ, σ universally quantified as in the source.
4. **Domains/details: PASS.** All in ℝ; no ENNReal/toReal; division by θ²+σ² which is > 0 under the hypotheses (and Lean's `x/0=0` is irrelevant there). No measurability/a.e. aspects.
5. **Step obligations: PASS.**
   - S1 (main.tex:59) `θ²+σ² > σ² ∧ σ² > 0`: true under θ ≠ 0, σ > 0 (first conjunct uses θ² > 0). Matches the sentence.
   - S2 (main.tex:60) `oracleRisk θ σ < θ²`: true (θ² > 0 and σ²/(θ²+σ²) < 1). Matches.
   - S3 (main.tex:60, "in the same way") `oracleRisk θ σ < σ²`: true (σ² > 0, θ²/(θ²+σ²) < 1 using θ² > 0). Matches; the symmetric chain θ²+σ² > θ² > 0 is a FAIR_IMPLICIT_STEP covered by main.tex:25.
   - None smuggles the conclusion; each is strictly the printed intermediate claim. Assembly: `le_min (le_of_lt S2) (le_of_lt S3)` gives `Conclusion`. No obligation is false as stated; each was checked for a missing positivity premise (LESSONS 10) — all needed positivity (θ² > 0, σ² > 0) is available from `hθ`, `hσ`.
6. **External parameters: PASS (none).** L02Stmt.lean declares only `Conclusion` in `namespace Paper.L02`; no `def … : Prop` tools, no consumed clauses, no predecessors. The obsolete harmonic-mean definitions are absent from both files.
7. **Doubts about the source: none.** The proof as printed is correct; the "in the same way" step needs θ² > 0, provided by main.tex:25 (FAIR_IMPLICIT_STEP, not an issue). No dispatch of pv-issue-checker needed.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises beyond main.tex:25 |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

Copies: `pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (log `pv_work/logs/gate_L02_stmtcopy_2.log`, exit=0, sorry_warnings=0) and `pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (log `pv_work/logs/gate_L02_draftcopy_2.log`, exit=0, sorry_warnings=4).

```
TYPE HASHES (current file, 1 declarations)
Paper.L02.Conclusion|def|th=1185911348|vh=2072270411|bi=ee
```

```
TYPE HASHES (current file, 4 declarations)
Paper.L02.L02_S1|thm|th=238763563|vh=-|bi=eeee
Paper.L02.L02_S2|thm|th=3789798266|vh=-|bi=eeee
Paper.L02.L02_S3|thm|th=3200783877|vh=-|bi=eeee
Paper.L02.L02_main|thm|th=635949411|vh=-|bi=eeee
```

## Overall verdict

The statement and step obligations are faithful to main.tex:25, 33, 54-61; no TFAs, no external parameters, no false obligations.

STATEMENT GATE: PASS

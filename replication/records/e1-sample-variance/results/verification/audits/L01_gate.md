# L01 statement gate (Lemma lem:centred)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:58:40 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean` 8952247a87215d5b05a8f25368186f3723c6d5ae94498188d6c66388cc8c4d4f
  - `pv_work/L01Draft.lean` 946d77d8562f9cfb47313ca27d905963916ce81ee8754a10e2b476e902c346b6
  - `pv_work/Defs.lean` (imported) e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e (DEFS gate: `verification/audits/DEFS_gate.md`, STATEMENT GATE: PASS)
  - `pv_work/notes/L01_draft_notes.md` (leads only) 4c3acb1132cc691f6ca632bffa2f4ba02cf449e04766d3ef2f5e7c825196f926
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none`. EXIT=0 (3 sorry warnings, expected in a draft).

## Source quotations (read directly)

- `source/main.tex:26`: "Throughout, $n \ge 1$ is an integer and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$."
- `source/main.tex:28-30` (def:mean): "$\bar x = \frac{1}{n} \sum_{i=1}^n x_i$."
- `source/main.tex:42-44` (lem:centred): "$\sum_{i=1}^n (x_i - \bar x) = 0$."
- `source/main.tex:46-48` (proof): "By the definition of $\bar x$, $\sum_{i=1}^n (x_i - \bar x) = \sum_{i=1}^n x_i - n \bar x = 0$."

Lean encoding (Defs): `Sample n := Fin n → ℝ`; `sampleMean x := (1/(n:ℝ)) * ∑ i, x i` — matches main.tex:29 exactly for n ≥ 1.

## Item rulings

1. **Hypotheses — PASS.** Source hypotheses: n ≥ 1 (global, :26), x ∈ ℝ^n. Encoded as `(n : ℕ) (hn : 1 ≤ n) (x : Sample n)` in `L01_main`. No extra premises; no structures/classes/variables hide hypotheses (Defs contains only defs and an abbrev). No conclusion-shaped hypothesis.
2. **Conclusion — PASS.** `Conclusion x := ∑ i, (x i - sampleMean x) = 0` is the printed statement verbatim (index shift i ↦ x_{i+1} is a pure notational conversion). Neither weakened nor strengthened.
3. **Quantifiers / constants — PASS.** No constants; universally quantified over n, hn, x as in the source.
4. **Domains and details — PASS.** Finite sum over `Fin n`, real-valued, exact equality; no ℝ≥0∞/toReal, measurability or a.e. issues. Division `1/(n:ℝ)` is real; n ≥ 1 is assumed, so no division-by-zero artefact enters (and the statement would anyway also hold for n = 0).
5. **Step obligations — PASS.**
   - `L01_S1` (main.tex:47, first "="): `∑ (x i - x̄) = ∑ x i - n·x̄`. True as stated for every n (sum_sub_distrib + sum_const, card Fin n = n); hn unused but harmless. Faithful to the source sentence; the linearity step is a FAIR_IMPLICIT_STEP.
   - `L01_S2` (main.tex:47, second "=", "by the definition of x̄"): `∑ x i - n·((1/n)∑ x i) = 0`. True as stated with hn (n ≠ 0 in ℝ); in fact true also for n = 0. Faithful.
   - `L01_main`: `Conclusion x` follows by unfolding `Conclusion` and chaining S1, S2 (transitivity). Assembly is complete.
   - No obligation smuggles in the target or a stronger conclusion: S1 and S2 are exactly the two printed equalities.
   - False-as-stated obligations: none.
6. **External parameters — PASS (none).** No `def … : Prop` tools or consumed clauses; the only def in L01Stmt is `Conclusion`, in `namespace Paper.L01`, no redeclared names. No "mathlib lacks X" claims to check.
7. **Doubts about the source — none.** The proof at :47 is complete and correct for n ≥ 1. No suspected paper issue; no dispatch of pv-issue-checker needed.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | `hn : 1 ≤ n` is the printed global hypothesis (main.tex:26), not a TFA. |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

Copies: `pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (log `pv_work/logs/gate_L01_stmtcopy_1.log`, exit=0) and `pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (log `pv_work/logs/gate_L01_draftcopy_1.log`, exit=0, 3 sorry warnings).

Stmt copy:
```
TYPE HASHES (current file, 1 declarations)
Paper.L01.Conclusion|def|th=3418533756|vh=3042306213|bi=ie
```

Draft copy:
```
TYPE HASHES (current file, 3 declarations)
Paper.L01.L01_S1|thm|th=4288601967|vh=-|bi=eee
Paper.L01.L01_S2|thm|th=4203949022|vh=-|bi=eee
Paper.L01.L01_main|thm|th=3668813028|vh=-|bi=eee
```

## Overall verdict

Statement faithful to main.tex:42-44 under the convention at :26; obligations S1, S2 true as stated and correspond to the two equalities at :47; proof work may begin.

STATEMENT GATE: PASS

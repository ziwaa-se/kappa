# P03 statement gate (prop:sum)

- Reviewer: pv-gate (fresh subagent, Opus)
- Date: Mon Oct 12 22:17:49 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P03Stmt.lean`  6a4717b3f60da545095da2a71402609821a8758ef14edfda45d000f8fd7009f0
  - `pv_work/P03Draft.lean` 4f2d02495a33a8da851f831230aa5e0260788b949057a647686f25e65cf1f2a6
  - `pv_work/Defs.lean`     0259b9aa4c03c2e64066ab3240783bfdbb600dc04c0b6182dccc0d6a1e831b67 (imported shared definitions)
- Compilation: `scripts/pv_lean.sh check P03Draft` -> `exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0`, log `pv_work/logs/P03Draft_2.log`.
- Draft notes `pv_work/notes/P03_draft_notes.md` read as leads only; all conclusions below are from the source and the Lean text.

## Source quotations

- main.tex:31-34 (def:svar): "For $m \ge 2$ and $u \in \mathbb{R}^m$, let $\bar u = \frac1m \sum_{i=1}^m u_i$ and $s^2(u) = \frac{1}{m-1} \sum_{i=1}^m (u_i - \bar u)^2$."
- main.tex:81-83 (prop:sum): "For $m \ge 2$ and $x, y \in \mathbb{R}^m$, $s^2(x + y) \le 2 s^2(x) + 2 s^2(y)$."
- main.tex:85-88 (proof): "We have $s^2(x + y) = s^2(x) + s^2(y)$, and $s^2(x) + s^2(y) \le 2 s^2(x) + 2 s^2(y)$ because both terms are nonnegative."

## Definitions used (Defs.lean)

- `mean u = (1/(m:ℝ)) * ∑ i, u i` — matches main.tex:32.
- `s2 u = (1/((m:ℝ) - 1)) * ∑ i, (u i - mean u)^2` — matches main.tex:33; `m - 1` is real subtraction, no ℕ truncation. For `m ≥ 2` the factor is a positive real, identical to the source. Out-of-range `m` (0, 1) is excluded by the hypothesis `hm` in every theorem.
- `x + y` on `Fin m → ℝ` is the pointwise Pi addition = vector addition in ℝ^m.

## Item rulings

1. **Hypotheses — PASS.** Source hypotheses: `m ≥ 2` (`hm : 2 ≤ m`), `x, y ∈ ℝ^m` (`x y : Fin m → ℝ`). No extra premises, no structures/type classes/variables hiding hypotheses; `P03Concl` takes no hypothesis and is not goal-shaped as a hypothesis anywhere. Remark: `P03Concl` itself does not carry `2 ≤ m`; the hypothesis sits in `P03_main`, which is acceptable (the docstring wording is slightly awkward but harmless; do not change it now, it would change nothing semantic).
2. **Conclusion — PASS.** `s2 (x + y) ≤ 2 * s2 x + 2 * s2 y` is exactly main.tex:82; neither weakened nor strengthened; single clause.
3. **Quantifiers / constants — PASS.** No constants; universal over `m ≥ 2`, `x`, `y`, as in the source.
4. **Domains and details — PASS.** Finite real vectors; equality/inequality in ℝ; no ℝ≥0∞ or `toReal` involved; division by `(m:ℝ) - 1 ≥ 1` non-degenerate under `hm`.
5. **Step obligations — PASS (faithfulness), with S1 FALSE AS STATED.**
   - **S1** (`P03_S1`, main.tex:86 "We have $s^2(x+y) = s^2(x)+s^2(y)$"): faithful verbatim encoding of the source sentence, same quantifiers and hypotheses as the theorem. It is **false as stated**: gate probe `pv_work/probes/gate/P03/gate_P03_S1false.lean` proves `¬ ∀ m ≥ 2, ∀ x y, s2 (x+y) = s2 x + s2 y` with `m = 2`, `x = y = (0,1)` (`s2 x = 1/2`, `s2 (x+x) = 2 ≠ 1`); probe `exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/gate_P03_S1false_1.log`. In general `s2(x+y) = s2 x + s2 y + 2·cov(x,y)`. Per instructions, S1 is kept as the source states it and is not repaired. The prover must not prove it; it should be recorded as the first unjustified step.
   - **S2** (`P03_S2`, main.tex:86-87): faithful; true as stated under `hm` (uses `s2 ≥ 0`, which needs `1/((m:ℝ)-1) ≥ 0`, guaranteed by `hm`; nonnegativity is a FAIR_IMPLICIT_STEP from the definition). Does not smuggle in the target.
   - **Assembly:** S1 rewritten into S2 yields `P03Concl x y`; the obligations together give the main theorem exactly as the source chains them. Neither obligation states the conclusion. Because S1 is false, the source route cannot close `P03_main`.
6. **External parameters — PASS (none).** No `def Tool : Prop`, no consumed predecessor clauses; none are needed (the source cites nothing, and P03 has no predecessors).
7. **Doubts about the source — recorded, preliminary only.** main.tex:86: the identity $s^2(x+y)=s^2(x)+s^2(y)$ is false in general (probe above). The printed conclusion main.tex:82 appears true by other means ($(a+b)^2 \le 2a^2+2b^2$ termwise on centered vectors), so the preliminary class is **PAPER_ARGUMENT_GAP** (not ERROR). The gate does not rule on this; recommend the coordinator dispatch `pv-issue-checker`.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none proposed) | — | — |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

Statement copy `pv_work/probes/gate/P03/gate_P03_stmtcopy.lean` (log `pv_work/logs/gate_P03_stmtcopy_1.log`):

```
TYPE HASHES (current file, 1 declarations)
Paper.P03.P03Concl|def|th=2798614588|vh=3065402787|bi=iee
EXIT=0
```

Draft copy `pv_work/probes/gate/P03/gate_P03_draftcopy.lean` (log `pv_work/logs/gate_P03_draftcopy_1.log`):

```
TYPE HASHES (current file, 3 declarations)
Paper.P03.P03_S1|thm|th=827841601|vh=-|bi=eeee
Paper.P03.P03_S2|thm|th=2223477596|vh=-|bi=eeee
Paper.P03.P03_main|thm|th=4267815131|vh=-|bi=eeee
EXIT=0
```

## Overall verdict

The statement and the step obligations are faithful to main.tex:81-88. S1 is a faithful encoding of a source sentence that is false as stated (suspected PAPER_ARGUMENT_GAP, to be ruled by pv-issue-checker); this does not block the gate.

STATEMENT GATE: PASS

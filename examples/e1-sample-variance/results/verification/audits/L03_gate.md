# L03 statement gate (Lemma lem:raw)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:15:44 EDT 2026 (from `date`)
- Mode: initial gate (not an amendment check)

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

```
0528bec8e0be738607a171ca1998262b777cebb4eb5601bf3377ea880bf4e2d4  pv_work/L03Stmt.lean
05e890c7e647c2dc221ae7164067ce0977829fbddd21170351b117878c6eb4af  pv_work/L03Draft.lean
6fa6a34661c1b216fc7e87cb4a0bc861e0fd53912dd061dd1594dee9e7c2be74  pv_work/notes/L03_draft_notes.md
e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e  pv_work/Defs.lean
33bc8f135f6c692d4e2b97744bad9c46cb6752122c2c23e79c173fa1343fb8d9  pv_work/L02Stmt.lean
```

## Compilation

- `scripts/pv_lean.sh check L03Draft`: `RESULT L03Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/L03Draft_2.log olean=none` (4 sorries = S1, S2, S3, main; expected in a draft).
- Snapshot probes: `gate_L03_stmtcopy` exit=0 (log `pv_work/logs/gate_L03_stmtcopy_1.log`), `gate_L03_draftcopy` exit=0, 4 sorry warnings (log `pv_work/logs/gate_L03_draftcopy_1.log`).
- Gate sanity probe `pv_work/probes/gate/L03/gate_L03_cex.lean`: exit=0, 0 sorries (log `pv_work/logs/gate_L03_cex_1.log`). Proves in Lean that for `n = 2`, `x = ![1, -1]`: `¬ Conclusion x`, and that the hypothesis `h` of S3 holds. This is only a gate truth check, not an issue ruling.

## Source quotations (read directly)

- main.tex:26 "Throughout, $n \ge 1$ is an integer and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$."
- main.tex:29 "$\bar x = \frac{1}{n} \sum_{i=1}^n x_i$."
- main.tex:33-35 "For $n \ge 2$, the sample variance of $x$ is $s^2 = \frac{1}{n-1} \sum_{i=1}^n (x_i - \bar x)^2$"
- main.tex:51 (Lemma lem:shortcut) "$\sum (x_i - \bar x)^2 = \sum x_i^2 - n \bar x^2$."
- main.tex:85-87 (Lemma lem:raw) "Suppose that $n \ge 2$. Then $s^2 \le \frac{1}{n} \sum_{i=1}^n x_i^2$."
- main.tex:90 "By Lemma lem:shortcut, $(n-1) s^2 = \sum x_i^2 - n \bar x^2 \le \sum x_i^2$."
- main.tex:91 "Dividing by $n$ gives the claim."

## Item rulings

1. **Hypotheses: PASS.** Source hypotheses: `n ≥ 2` (:86) and `x ∈ ℝ^n` (:26). Lean: `hn : 2 ≤ n`, `x : Sample n = Fin n → ℝ`. No extra premises; no hidden hypotheses in `Defs` (abbrev + three total defs, no classes/structures/variables). No conclusion-as-hypothesis. The `n ≥ 1` global convention is implied by `2 ≤ n`.
2. **Conclusion: PASS.** `Conclusion x := sampleVar x ≤ (1 / (n:ℝ)) * ∑ i, (x i)^2` is exactly :86; neither weakened nor strengthened. `sampleVar` matches :35 (factor `1/((n:ℝ)-1)`, real subtraction, no ℕ truncation; for `n ≥ 2` equals the source value). `sampleMean` matches :29.
3. **Quantifiers / constants: PASS.** No constants; statement universally quantified over `n` and `x`, as in the source.
4. **Domains and details: PASS.** Finite real sums, no a.e./measurability/ENNReal issues. `Fin n` indexing is a pure reindexing of `1..n`. Our representation does not manufacture the falsity: with the source's own definition (:35, factor `1/(n-1)`) the claim fails; the claim would hold for the population variance `1/n`, but the source explicitly defines `1/(n-1)`, which is authoritative.
5. **Step obligations: PASS (faithful), with one obligation FALSE AS STATED.**
   - S1 (:90, first equality) `((n:ℝ)-1) * sampleVar x = ∑ x_i^2 - n x̄^2` with `2 ≤ n`: true (`(n-1)·(1/(n-1)) = 1` since `n-1 ≠ 0`, then L02 `Paper.L02.L02_main`, which needs `1 ≤ n`, available from `2 ≤ n`). Faithful.
   - S2 (:90, inequality) `∑ x_i^2 - n x̄^2 ≤ ∑ x_i^2`: true for all `n` (`n x̄^2 ≥ 0`). Faithful.
   - S3 (:91 "Dividing by n gives the claim") from `(n-1) s^2 ≤ ∑ x_i^2` to `s^2 ≤ (1/n) ∑ x_i^2`: **FALSE AS STATED.** Lean-checked witness `n = 2`, `x = (1,-1)`: `x̄ = 0`, `s^2 = 2`, hypothesis `1·2 ≤ 2` holds, conclusion `2 ≤ 1` fails. This is a faithful translation of the printed step (premise = the display of :90, conclusion = the claim of :86), not an encoding error: the falsity follows from the source's own definitions, and no representation choice is involved. Per the task, not to be repaired. It does not smuggle in anything stronger than the source's own step.
   - Assembly: S1 + S2 give `h`; S3 gives `Conclusion x`. The obligations assemble to the main theorem. (Because S3 and the main conclusion are false, the main theorem cannot be proved; this is expected and is a paper-side question, not a gate defect.)
6. **External parameters: PASS (none).** No `def … : Prop` tools, no consumed clauses. L02 is used via its proved module (`import L02`, `Paper.L02.L02_main`), not via an external parameter. No redeclared names; everything is in `namespace Paper.L03`.
7. **Doubts about the source: recorded, not ruled.** Preliminary classification: main.tex:86 — `ERROR` (printed conclusion is false under the definition at :35; Lean-checked witness above); main.tex:91 — the step itself would be `PAPER_ARGUMENT_GAP` but is subsumed by the ERROR. Downstream: Corollary cor:unit (:99) invokes this lemma; its own conclusion `s^2 ≤ 2` may still be true by other means, which is for the issue checker / later stages. Recommend the coordinator dispatch `pv-issue-checker` for L03.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | No extra premises in the statement or obligations. |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None. (S3 must stay as written; it is the faithful encoding of :91.)

## Statement snapshot

From `pv_work/logs/gate_L03_stmtcopy_1.log`:

```
TYPE HASHES (current file, 1 declarations)
Paper.L03.Conclusion|def|th=3418533756|vh=556412300|bi=ie
```

From `pv_work/logs/gate_L03_draftcopy_1.log`:

```
TYPE HASHES (current file, 4 declarations)
Paper.L03.L03_S1|thm|th=2992798781|vh=-|bi=iee
Paper.L03.L03_S2|thm|th=2545237054|vh=-|bi=ie
Paper.L03.L03_S3|thm|th=3671998219|vh=-|bi=ieee
Paper.L03.L03_main|thm|th=3472474048|vh=-|bi=iee
```

## Overall verdict

The statement and obligations are faithful to main.tex:85-92. S3 and the main conclusion are false as stated, and the falsity comes from the source, not the encoding. A prover cannot close S3 or L03_main. The coordinator should route L03 to `pv-issue-checker`.

STATEMENT GATE: PASS

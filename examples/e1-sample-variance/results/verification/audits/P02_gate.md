# P02 statement gate (Proposition prop:samuelson, Samuelson's inequality)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:15:51 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P02Stmt.lean` e69fa5aa07771ae369128efd0661570592631003b4fb2e64adb4b5afc986814a
  - `pv_work/P02Draft.lean` 6ad3bc4b2b76022da64a098c61ce2ca048e1b5423c76317e2c61415741ecc0bf
  - `pv_work/notes/P02_draft_notes.md` 62702c98d36e488c54cd4a507078f1a23df9b51455ad53896e0e1a226ce69c18 (leads only)
  - imported: `pv_work/Defs.lean` e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e, `pv_work/L01Stmt.lean` 8952247a87215d5b05a8f25368186f3723c6d5ae94498188d6c66388cc8c4d4f
  - `source/main.tex` 1cbdd1aa5b3d8616c3f4505b9062441d71b2f7e2644e20af8eaa1f4aed5a3250
- Compilation: `scripts/pv_lean.sh check P02Draft` -> `exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0`, log `pv_work/logs/P02Draft_2.log` (9 sorries = S1-S8 + main, expected in a draft).
- Probes: `pv_work/probes/gate/P02/gate_P02_stmtcopy.lean` (log `pv_work/logs/gate_P02_stmtcopy_1.log`, EXIT=0), `gate_P02_draftcopy.lean` (log `pv_work/logs/gate_P02_draftcopy_1.log`, EXIT=0), `gate_P02_cs.lean` (log `pv_work/logs/gate_P02_cs_1.log`; EXIT=1 only because of a deliberately tried name `inner_mul_le_norm_mul_norm`; the relevant `sq_sum_le_card_mul_sum_sq` and `Finset.card_erase_of_mem` exist).

## Source quotations (read directly)

- main.tex:26 "Throughout, $n \ge 1$ is an integer and $x = (x_1,\dots,x_n) \in \mathbb{R}^n$."
- main.tex:29 "$\bar x = \frac{1}{n}\sum_{i=1}^n x_i$."
- main.tex:33-37 "For $n\ge 2$, ... $s^2 = \frac{1}{n-1}\sum_{i=1}^n (x_i-\bar x)^2$, ... $s = \sqrt{s^2} \ge 0$."
- main.tex:71-72 "Suppose that $n \ge 2$. Then $|x_i - \bar x| \le \frac{n-1}{\sqrt{n}}\, s$ for every $i = 1,\dots,n$."
- main.tex:76 "Let $z_j = (x_j - \bar x)/s$ ... By Lemma~\ref{lem:centred}, $\sum z_j = 0$, and by
- main.tex:77 the definition of $s^2$, $\sum z_j^2 = n-1$. Fix $i$. Then $z_i = -\sum_{j\ne i} z_j$, so by the
- main.tex:78-80 Cauchy--Schwarz inequality $z_i^2 \le (n-1)\sum_{j\ne i} z_j^2 = (n-1)(n-1-z_i^2)$."
- main.tex:82 "Hence $n z_i^2 \le (n-1)^2$, that is, $|z_i| \le (n-1)/\sqrt{n}$. Multiplying by $s$ gives the claim."

The source never mentions the case $s = 0$ (all $x_i$ equal), in which $z_j$ at line 76 is undefined.

## Item 1. Hypotheses -- PASS

- Source hypotheses: $n \ge 2$ (line 72), $x \in \mathbb{R}^n$ (line 26). Lean main: `(hn : 2 ≤ n) (x : Sample n)`. The global $n\ge1$ is implied.
- No extra premise in `P02_main`. No hidden hypotheses: `Defs.lean` has only `abbrev Sample`, `sampleMean`, `sampleVar`, `sampleStd` (no structures, classes, `variable`s); `L01Stmt.lean` only defines `Conclusion`.
- No conclusion-as-hypothesis.
- Extra premise `hs : sampleStd x ≠ 0` appears only in step obligations S2, S5, S6, S7, S8, not in the main theorem. Ruling: this is **not** a TFA and not an encoding error. It is the faithful marker of the point where the source's own construction (division by $s$ at main.tex:76) is meaningful only for $s \ne 0$. It does not strengthen the main theorem, and it is not used to excuse anything: the obligations are exactly what the source proves, and the source proves them only for $s\ne0$. Requiring the drafter to drop it would make S2 false (see item 5), and adding an `s = 0` step would be a repair, which is forbidden.

## Item 2. Conclusion -- PASS

`Conclusion x := ∀ i : Fin n, |x i - sampleMean x| ≤ ((n:ℝ) - 1) / Real.sqrt (n:ℝ) * sampleStd x`. Parsing is `((n-1)/√n) * s`, matching line 72. All $i$ quantified; neither weakened nor strengthened. `sampleStd` = `Real.sqrt sampleVar`, matching line 37; `sampleVar` uses real `(n:ℝ) - 1` (no ℕ truncation), matching line 35.

## Item 3. Quantifiers and constants -- PASS

No constants other than the explicit $(n-1)/\sqrt n$; `n`, `x`, then `∀ i`, as in the source.

## Item 4. Domains and details -- PASS

Finite index set `Fin n`; pointwise inequality; no measurability or ENNReal issues. Total-function conventions in `Defs` (division by zero) are harmless under `2 ≤ n`. `z` in `P02Stmt` uses Lean division (`z = 0` when `s = 0`); this is a representation choice that is only used in obligations and is locked by `vh`; it does not manufacture a paper error (with `z = 0`, S2 is false at s = 0, which is exactly why `hs` is carried there).

## Item 5. Step obligations -- PASS

Each checked for truth as stated (n ≥ 2 gives `(n:ℝ)-1 ≥ 1 > 0`, so `sampleVar ≥ 0` and `sampleStd^2 = sampleVar`):

| Step | Source | True as stated? | Notes |
|---|---|---|---|
| S1 `∑ z = 0` | :76 | true (also at s=0, all z=0) | uses L01 (`L01_main` needs `1 ≤ n`, follows from hn) |
| S2 `∑ z² = n-1` (hs) | :76-77 | true with hs; **false without hs** (s=0 gives 0 ≠ n-1) | hs needed and faithful |
| S3 `z_i = -∑_{j≠i} z_j` | :77 | true | from S1 |
| S4 C-S `z_i² ≤ (n-1)∑_{j≠i} z_j²` | :78-80 | true (no hs needed) | `card (univ.erase i) = n-1`, cast fine since n ≥ 1; mathlib `sq_sum_le_card_mul_sum_sq` exists |
| S5 display equality (hs) | :80 | true with hs | from S2 |
| S6 `n z_i² ≤ (n-1)²` (hs) | :82 | true (actually true even without hs, harmless) | from S4, S5 |
| S7 `|z_i| ≤ (n-1)/√n` (hs) | :82 | true | n-1 ≥ 0, √n > 0 |
| S8 claim for i (hs) | :82 | true | `|x_i - x̄| = |z_i| s` with s > 0 |

No obligation smuggles in the target or a stronger intermediate claim (S8 is the main claim restricted to s ≠ 0, which is precisely what line 82 asserts after the source's argument).

Assembly: S1-S8 yield `Conclusion x` for every `x` with `sampleStd x ≠ 0`. They do **not** yield the case `sampleStd x = 0`, because the source does not treat it. This is a faithful reflection of the source, not an encoding error. `P02_main` itself is true as stated (if s = 0 then ∑(x_i - x̄)² = 0, so every deviation is 0). How the s = 0 case is handled (stop and record vs. FAIR_IMPLICIT_STEP) is for pv-issue-checker; the gate does not rule on it and does not require a repair.

## Item 6. External parameters -- PASS (none)

No `def Tool : Prop`, no consumed clauses. Cauchy-Schwarz is in mathlib (`#check @sq_sum_le_card_mul_sum_sq` succeeds, log `pv_work/logs/gate_P02_cs_1.log`), so no external parameter is needed. L01 is imported as a proved module (`L01.lean`, `L01_main`), not as a parameter. Namespace `Paper.P02`; `z` and `Conclusion` do not clash (`Paper.L01.Conclusion` is in a different namespace).

## Item 7. Doubts about the source -- recorded, preliminary

- main.tex:76 (also :77, :82): the proof divides by $s$ without treating $s = 0$ (all $x_i$ equal), which is allowed by the hypotheses ($n\ge2$ only). The printed conclusion is true in that case (both sides 0), so this is not ERROR. Preliminary class: `EXPOSITION_GAP` (a case not covered); the issue-checker may consider whether it is a `FAIR_IMPLICIT_STEP`. Recommend dispatching pv-issue-checker.

## TFAs ruled on

| Premise | Where | Ruling | Reason |
|---|---|---|---|
| `hs : sampleStd x ≠ 0` | S2, S5-S8 (not main) | Not a TFA; approved as a faithful marker of the source's untreated case | main theorem unaffected; obligations are exactly what the source argues for s ≠ 0 |

## External parameters

None.

## Required changes

None.

## Statement snapshot

`pv_work/logs/gate_P02_stmtcopy_1.log`:
```
TYPE HASHES (current file, 2 declarations)
Paper.P02.Conclusion|def|th=3418533756|vh=2134396617|bi=ie
Paper.P02.z|def|th=2529620566|vh=777641470|bi=iee
```

`pv_work/logs/gate_P02_draftcopy_1.log`:
```
TYPE HASHES (current file, 9 declarations)
Paper.P02.P02_S1|thm|th=38167313|vh=-|bi=eee
Paper.P02.P02_S2|thm|th=3930320841|vh=-|bi=eeee
Paper.P02.P02_S3|thm|th=1166118306|vh=-|bi=eeee
Paper.P02.P02_S4|thm|th=2355933627|vh=-|bi=eeee
Paper.P02.P02_S5|thm|th=4073720051|vh=-|bi=eeeee
Paper.P02.P02_S6|thm|th=1539572540|vh=-|bi=eeeee
Paper.P02.P02_S7|thm|th=2924739321|vh=-|bi=eeeee
Paper.P02.P02_S8|thm|th=1678650314|vh=-|bi=eeeee
Paper.P02.P02_main|thm|th=3504097159|vh=-|bi=eee
```

## Overall verdict

The statement is faithful to main.tex:71-72; the obligations faithfully follow main.tex:76-82; the `s ≠ 0` premise on S2, S5-S8 correctly marks the source's untreated case and is not an encoding error.

STATEMENT GATE: PASS

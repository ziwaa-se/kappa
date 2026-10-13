# Human-check worksheet for external inputs

**This project has no external inputs.** `RESULTS.json` has `"external_tools": []`, and every final audit reports "CONDITIONS: none". There is nothing to tick off here.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A, A′, B, C, D, E | 0 | none | – | – |

## What is not an external input (for orientation)

Gap hypotheses are not external inputs. They are the printed steps that the Lean check found false, kept as hypotheses so the rest of each proof could still be checked. They are explained in `AUTHOR_REPORT.md` §4.2 and §4.3:

| Lean name (file:line) | Printed step | Source | Status |
|---|---|---|---|
| `L03_S2_Gap` (`pv_work/L03ModGaps.lean:13`) | p(1-p)/n ≤ p/(4n) from Lemma 2.1 | main.tex:70 | refuted (`pv_work/L03_Counterexample1.lean`, n=1, p=1/10) |
| `P03_S1_Gap` (`pv_work/P03ModGaps.lean:8`) | s²(x+y) = s²(x)+s²(y) | main.tex:86 | refuted (`pv_work/P03_Counterexample1.lean`, m=2, x=y=(0,1)) |

The theorems `L03_main_mod_gaps` and `P03_main_mod_gaps` take these as premises; since the premises are false, they say nothing about the printed claims.

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `IOpen`, `IClosed` | `pv_work/Defs.lean:13, 16` | `Set.Ioo 0 1`, `Set.Icc 0 1` |
| `V n p` | `pv_work/Defs.lean:21` | `p * (1 - p) / n` |
| `mean`, `s2` | `pv_work/Defs.lean:25, 29` | sample mean and sample variance on `Fin m → ℝ` |

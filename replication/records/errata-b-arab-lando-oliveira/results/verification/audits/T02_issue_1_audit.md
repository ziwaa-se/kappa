# T02 issue 1 (revision 1): reasoning review (pv-auditor)

- Reviewer: pv-auditor (independent of pv-issue-checker and pv-prover), claude-opus-5-5
- Date: Tue Oct 13 11:23:33 EDT 2026 (from `date`)
- Reviewed ruling: `verification/audits/T02_issue_1.md` (ISSUE VERDICT: FAIR_IMPLICIT_STEP, THREATENS CONCLUSION: no)
- Source read directly: `source/SuperParetoPaper-v12.tex:95-102, :111-137, :186-233`.

## Step-by-step check of the ruling

| Ruling claim | Check against the source / Lean | Result |
|---|---|---|
| §1 quotations (:95 weights `≥ 0`; :102; :186-188; :191 `θ∈(0,1)`; :219 IH "nonnegative weights", step for `θ_i > 0`) | Read verbatim; all accurate. | OK |
| §1 uncovered cases: `n=1`, `n=2` with `θ∈{0,1}`, `n≥3` with some `θ_i=0` | Correct: :191-217 only `θ∈(0,1)`, :219-233 only `θ_i>0`; no sentence handles zeros. | OK |
| §1 the step consumes the IH only at the normalised weights `θ_i/(1-θ_n)` (positive) | :223 conditions on `(θ_1X_1+⋯+θ_{n-1}X_{n-1})/(1-θ_n)`; with `θ_i>0` these weights are positive and sum to 1. | OK |
| §3 the reduction: drop indices with `θ_i=0`; sub-family is i.i.d.; pointwise equal sums; positive weights summing to 1 | Correct mathematics; no property of `F_X` or ITS used. `|S|≥1` since the sum is 1. | OK |
| §3 `|S|=1` is the identity-in-law case | Then `θ_i=1` and the combination equals `X_i ~ X`; :102's "if" direction does not use `E X<∞`. | OK |
| §4 class FAIR_IMPLICIT_STEP (not EXPOSITION_GAP / PAPER_ARGUMENT_GAP / ASSUMPTION_GAP / ERROR / ENCODING_ERROR) | The uncovered cases are literally instances of the covered case with fewer variables after a hypothesis-preserving reindexing; the authors' IH at :219 is already phrased for nonnegative weights, showing they regard zero terms as absent; no written justification fails; the printed claim is true (Lean). I agree. The stricter fallback (minor EXPOSITION_GAP) is defensible but not required. | CONFIRMED |
| §5 conclusion not threatened; downstream unaffected | `T02_main` (weights `≥ 0`) is proved in `pv_work/T02.lean` with the fill-in (final audit `T02_final.md`). The only downstream consumer, `P03_T02Consumed`, uses `n=2, θ=1/2` (positive weights) anyway. | OK |
| §6 Lean evidence | Probe `pv_work/probes/issue/T02/T02_issue1_ZeroWeights.lean` read: `zeroWeights_fill` proves the gap from `T02_PosVersion` alone. In the delivered `pv_work/T02.lean:566-602` the private `zero_weights` is the same proof, line for line (only the gap-def wrapper replaced by the explicit hypothesis `hpos : PosVersion`). Axioms of `T02_main`: `[propext, Classical.choice, Quot.sound]` (my probe `pv_work/probes/auditor/T02/auditor_T02_usage.lean`, log `pv_work/logs/auditor_T02_usage_2.log`). | OK |
| §7 fill-in is pure bookkeeping | `zero_weights` uses only: `Finset.filter`, `equivFin`, `iIndepFun.precomp` of an injection, `IdentDistrib` of each copy, `Equiv.sum_comp`, `Finset.sum_coe_sort`, `Finset.sum_filter_of_ne`. `hits` is only passed through to `PosVersion`; `T02_L01Consumed` is not in its scope. No property of `F_X`. | OK |
| §8 suggested sentence | "Terms with `θ_i=0` can be discarded, so we may assume all weights strictly positive; the case of a single positive weight is trivial (equality in distribution)." This covers all three uncovered cases (`n=1` and `n=2,θ∈{0,1}` collapse to one positive weight). Sufficient. | OK |

## Notes
- The ruling's evidence imports `T02ModGaps`; that file is now superseded by `pv_work/T02.lean` (not imported by it; not in the closure of `T02_main`). The evidence stays valid as a standalone probe.
- The `n=1` case also enters through `pos_all` (identical law); it is part of the same FAIR_IMPLICIT_STEP (anchor :102).

REVIEW: CONFIRMED

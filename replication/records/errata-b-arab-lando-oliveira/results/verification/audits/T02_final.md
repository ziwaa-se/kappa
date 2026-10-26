# T02 final audit (Theorem 3.1, thm:main), revision 1

- Auditor: pv-auditor (independent subagent), claude-opus-5-5
- Date: Tue Oct 13 11:23:33 EDT 2026 (from `date`)
- Audited object: `pv_work/T02.lean` (no gaps; `T02ModGaps.lean` superseded, see item 2). Defs: NONE.
- Source read directly: `source/SuperParetoPaper-v12.tex:95-102, :111-137, :186-233`.
- Read: gate `verification/audits/T02_gate.md`, prover notes `pv_work/notes/T02_prover_notes.md`, issue ruling `verification/audits/T02_issue_1.md`, full `pv_work/T02.lean`, `pv_work/T02Stmt.lean`, `pv_work/L01Stmt.lean`, issue probe `pv_work/probes/issue/T02/T02_issue1_ZeroWeights.lean`.
- Probes (mine): `pv_work/probes/auditor/T02/auditor_T02_usage.lean` (log `pv_work/logs/auditor_T02_usage_2.log`, exit 0), `pv_work/probes/auditor/T02/auditor_T02_nonvac.lean` (log `pv_work/logs/auditor_T02_nonvac_3.log`, exit 0).

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py T02` -> `verification/audits/T02_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T02` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (e63013a0…) |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs gate snapshot (23 gated decls, incl. S1-S8, `T02_main` th=703880595) | PASS |
| 6 | `#pv_axioms T02` | ALL STANDARD |
| 7 | `#pv_walk T02` | sorryAx: false; axioms propext, Classical.choice, Quot.sound |
| 11 | traced conditions | T02_L01Consumed |
| 12 | last writers | T02.lean pv-prover; T02Stmt.lean pv-drafter |

## 2. Gap file

Not applicable: `T02.lean` has no stopped obligation. `pv_work/T02ModGaps.lean` (pre-closure) is **superseded**: `T02.lean` imports only `T02Stmt`; the walk of `T02_main` (`auditor_T02_usage_2.log`) reaches modules `L01Stmt`, `T02Stmt`, `T02` only. `T02_ZeroWeights_Gap` is not used by anything delivered. Record: the coordinator should clear the `gaps` field of T02 and may move `T02ModGaps.lean` to `pv_work/superseded/` (I did not touch it).

## 3. Axioms and sorry

`#print axioms Paper.T02.T02_main`: `[propext, Classical.choice, Quot.sound]`; walk: sorryAx not reached.

## 4. Per-theorem conditionality

| External parameter | First level (`#pv_hyp_usage T02_main`) | Traced to | Source |
|---|---|---|---|
| `T02_L01Consumed` (`hL01`) | USED | `T02_main` -> `pos_all` -> (`T02_S4` for n=2, `pos_step` -> `T02_S8` for n≥3) -> `T02_S3`, where `hL01 ν hits x hx θ hθ` is applied directly (`T02.lean:221`); `#pv_hyp_usage T02_S3/S4/S8`: hL01 USED | :201 and :231-233 ("using (eq:sub-1x)") |

Walk controls: positive control `#pv_walk_decl T02_S3` reaches `T02_L01Consumed` (via `[T02_S3]`); negative control `#pv_walk_decl T02_S2` does not reach it. `zero_weights` has no `hL01` in scope (receives only `PosVersion`). Private helpers cannot be named in a probe (`_private.T02.0…` is rejected by the parser), so their level was confirmed by reading the proof terms: `pos_step` passes `hL01` only to `T02_S8`; `pos_all` only to `T02_S4` and `pos_step`.

Unused premises in gated obligations (item 10): `T02_S1.hx`, `T02_S2.h0`, `T02_S5.hx`, `T02_S6.{hits,hθ,hsum,hx}`. These are source-side hypotheses of step obligations (not external parameters); harmless, they only weaken the obligations. No external parameter is UNUSED.

## 5. Infrastructure (item 8, item 9)

Project constants in the closure: `L01Stmt` (F, IsInvSub, SubCond, SubadditiveOn, invDist: all `def`s, each named with its fingerprint and ruled faithful in `L01_gate.md` lines 38-39, 53, 92-96) and `T02Stmt` (StDom, Fbar, IIDCopies + projections/ctor, T02_L01Consumed: all named in `T02_gate.md` snapshot). No theorem from another result is consumed (L01 enters only through the parameter `T02_L01Consumed`). All covered.

Helpers not in the snapshot (all `private`, in `T02.lean`), audited individually:

| Helper | Content | Judgement |
|---|---|---|
| F_mono, F_nonneg, F_le_one, F_meas, F_eq_real, F_abs_le | mathlib `cdf` facts | technical, true |
| real_Ioc, real_Icc_le | `ν(a,b] = F b - F a`; `ν[0,x] ≤ F x` | technical, true |
| integrable_bdd, F_aff_meas, meas_cond | integrability / measurability | technical |
| prob_gt_eq_Fbar, toReal_le_compl | `P(X>x)=F̄(x)`, complement | notation conversion (:113) |
| ae_nonneg_of_ident | `F_X(0)=0` and `Z~X` give `Z≥0` a.s. | standard consequence of Def 2.2 (:124), "remembering they are nonnegative" (:191) |
| stdom_neg | for `x<0`, `P(X>x) ≤ P(Y>x)` when `Y≥0` a.s. | technical; used for the `x<0` fill-in (item 6) |
| last_lt_one | positive weights, ≥2 indices -> `θ_n<1` | technical (needed for `x/(1-θ_n)`) |
| PosVersion | the theorem with `θ_i>0` | statement of the case the source proves; no content |
| pos_step | source step :219-233 (S8) + `x<0` | faithful assembly |
| pos_all | induction :191 (n=0 vacuous, n=1 identity in law, n=2 = S4, n≥3 = pos_step with IH at `θ_i/(1-θ_n)`) | faithful assembly |
| zero_weights | reduction `θ_i≥0` -> `θ_i>0` | the FAIR_IMPLICIT_STEP of `T02_issue_1.md` §7, see item 6 |

None smuggles in the conclusion: `PosVersion` appears only as the hypothesis of `zero_weights` and is discharged by `pos_all`; the IH `hIH` of S6/S8/pos_step is for `m` copies, the conclusion for `m+1`.

`zero_weights` vs the stated fill-in: compared line by line with `zeroWeights_fill` in `pv_work/probes/issue/T02/T02_issue1_ZeroWeights.lean:15-47`: identical proof (steps 1-5 of §7: filter, `equivFin`, `iIndepFun.precomp`, positivity, reindexing lemma via `Equiv.sum_comp`/`Finset.sum_coe_sort`/`Finset.sum_filter_of_ne`, apply `PosVersion`). Only the wrapper differs (explicit `hpos` hypothesis instead of the gap `def`). No property of `F_X`, no ITS, no `hL01`: pure bookkeeping, no extra infrastructure.

## 6. Route fidelity

| Source | Lean | Faithful? | Note |
|---|---|---|---|
| :191 "induction on the number of random variables" | `pos_all` (strong induction) | yes | |
| :191-194 conditioning formula | `T02_S1` (joint law ν⊗ν, `Measure.prod_apply`) | yes | Fubini = "conditioning, using independence" |
| :195-198 Figure 1 split | `T02_S2` (`[0,x] ∪ (x,x/θ]`) | yes | exactly the two rectangles of Fig. 1 |
| :198-201 `≤ F_X(x)` via (eq:sub-1x) | `T02_S3` (hL01) | yes | |
| :217 n=2 conclusion | `T02_S4` | yes | plus `x<0` fill-in |
| :219-223 conditioning on `X_n` | `T02_S5` | yes | |
| :224 IH | `T02_S6` | yes | IH at normalised weights |
| :226-230 "same argument" | `T02_S7` = `T02_S2` at `θ_n` | yes | |
| :231-233 (eq:sub-1x), complements | `T02_S8` (S3 at `θ_n`) | yes | |

No route change, no result stronger than the source's.

FAIR_IMPLICIT_STEPs filled in:

| Step | Source anchor | How filled |
|---|---|---|
| `x<0` (Def 2.1 requires all real `x`; proof treats `x≥0`) | :117, :124 `F_X(0)=0`, :191 "nonnegative" | `stdom_neg` + `ae_nonneg_of_ident`: `P(sum>x)=1` for `x<0`. Gate item D. (The S4 docstring still calls it an "EXPOSITION_GAP candidate"; comment only, suggest a `DOC_ERRATA.md` entry, no rebuild needed.) |
| normalisation of IH weights `θ_i/(1-θ_n)` | :219, :223 | `hsum'`, `hpos` in `pos_all` |
| `n=1` (identity in law) | :102 | `IdentDistrib.measure_mem_eq` in `pos_all` |
| zero weights | :95 vs :191, :219 | `zero_weights` (ruling `T02_issue_1.md`, confirmed in `T02_issue_1_audit.md`) |
| integral endpoints `∫_0^{x/θ}` as `Icc` | :193 | immaterial (gate item 4) |

Domain note (from gate, unchanged): random variables are real-valued; the source's Example 2.7 has mass at `+∞`, which `T02_main` does not cover. Gate-approved scope restriction, not a paper issue.

## 7. Non-vacuity

`pv_work/probes/auditor/T02/auditor_T02_nonvac.lean` (exit 0, axioms standard): Pareto(1) law `F(x)=1-1/max(x,1)` built as a `StieltjesFunction` measure; proved `IsInvSub` (`1-F(1/x)=min(x,1)`, subadditive); two i.i.d. copies as coordinates of `Measure.pi`; `IIDCopies` proved. `T02_main` instantiated at weights `(1/2,1/2)` (`nonvac_half`, nontrivial, infinite-mean law) and `(1,0)` (`nonvac_zero`, exercises `zero_weights`). Hypotheses are jointly satisfiable (modulo the parameter `hL01`).

## 8. Status for the authors

Theorem 3.1 verified as printed (weights `θ_i ≥ 0`, all real `x`) along the paper's route, for real-valued `X`.
Depends on Lemma 2.3's "only if" direction (ITS ⇒ (eq:sub-1x)), consumed as a parameter (L01 is open as ISSUE on its other direction).
Source: revised induction step (:219-233) is correct; zero weights, `n=1`, `x<0` and the IH normalisation are unwritten but fair implicit steps (optional sentence at :191).

## FAIL items

None.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: T02_L01Consumed

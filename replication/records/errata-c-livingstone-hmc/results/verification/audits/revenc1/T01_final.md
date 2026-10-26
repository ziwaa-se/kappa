# T01 final audit (Theorem 2.2, thm:negative, TEX:208-219)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), date Tue Oct 13 01:48:33 EDT 2026.
- Audited object: `pv_work/T01.lean` (no gap file). Statement module `pv_work/T01Stmt.lean`.
- Read in full: TEX:195-234 (statement), TEX:855-996 (Thm 5.14 + proof, Lemmas 5.15-5.17, Thm 5.18 + proof), `T01.lean`, `T01Stmt.lean`, `T02Stmt.lean:32-106`, `Defs.lean:16-60`, gate reports `T01_gate.md` and `T01_gate_r2.md`, `T02_final.md`, prover notes, draft notes.
- Probes (mine): `pv_work/probes/auditor/T01/auditor_T01_nonvac.lean` (log `pv_work/logs/auditor_T01_nonvac_3.log`, exit 0, 0 sorry), `pv_work/probes/auditor/T01/auditor_T01_vacII.lean` (log `pv_work/logs/auditor_T01_vacII_1.log`, exit 0, 0 sorry). All `#print axioms` in both: `[propext, Classical.choice, Quot.sound]`.

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py T01`, run by me)

Report `verification/audits/T01_mech.md`: **MECH CHECKS: PASS**.

| Item | Result |
|---|---|
| 1 compile `T01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 private rebuild, sha256 | PASS, IDENTICAL |
| 3 PVTools hash | PASS |
| 4 fingerprints vs `T01_gate_r2.md` (16 gated decls) | PASS, all th/vh/bi identical |
| 5 Defs vs `DEFS_gate.md` | PASS |
| 6-7 `#pv_axioms`, `#pv_walk` | PASS, ALL STANDARD, no sorryAx |
| 9 helpers not in snapshot | none |
| 10 `#pv_hyp_usage` | no UNUSED (see §3) |
| 11 traced conditions | `T02_L02Consumed` only (incomplete, see §3) |

## 2. Gap files

None (no `T01ModGaps.lean`; prover notes: no gaps).

## 3. Per-theorem conditionality

`#pv_hyp_usage` (mech item 10 and my probe `auditor_T01_nonvac.lean`): every hypothesis of `T01_S1`, `T01_S3`, `T01_main` is USED.

| Parameter | Actual use | Clause |
|---|---|---|
| `hL02 : T02_L02Consumed gU eps L` | S1, passed to `T02_main` (used there at T02 step S2 via `L03_main`, per `T02_final.md`) | (i) only |
| `hE1 : Prop35` | S1 -> `T02_main` step S8 | (i) only |
| `hE6 : GaussFacts` | S1 -> `T02_main` steps S5/S6 | (i) only |
| `hE3 : Thm518` | S3, applied directly (T01.lean:38) | (ii) only |

The script's `TRACED CONDITIONS` lists only `T02_L02Consumed`: it misses `T02_Prop35`, `T02_GaussFacts` (Lean names `Prop35`, `GaussFacts` do not match their registered ids) and `Thm518` (**not registered at all**: `pv_status.py tools` has no entry for it). Corrected list: `T02_L02Consumed, T02_Prop35, T02_GaussFacts` for (i), and `Thm518` (needs registration, suggested id `T01_Thm518`, provenance (ii), TEX:978-984) for (ii).

## 4. Infrastructure (mech item 8)

| Module | Record | Status |
|---|---|---|
| `Defs` | `DEFS_gate.md` | definitions only, gated, fingerprints identical |
| `L02Stmt` (`Concl`, `ConclFixedDelta`) | `L02_gate_r2.md` | definitions only, gated |
| `L03`, `L03Stmt` | `L03_final.md`, `L03_gate.md` | individual final audit record |
| `T02`, `T02Stmt` | `T02_final.md`, `T02_gate_r2.md` | individual final audit record (PASS, CONDITIONAL) |
| `T01Stmt` | `T01_gate_r2.md` | gated in this result |

All theorems reached are covered by individual final-audit PASS records. There are no helpers without a record.

## 5. Route fidelity

Thm 2.2 has no proof of its own. The route (gate-approved, INVENTORY X3) is: (i) = Thm 5.14, (ii) = contrapositive of Thm 5.18.

| Source | Lean | Judgement |
|---|---|---|
| (i), TEX:213 = hypotheses (17)-(19) of Thm 5.14 (TEX:863-876) | `T01_S1`: unpacks `HypPartI`, calls `T02_main` | faithful; the identification is X3 (EXPOSITION_GAP, minor, already dispatched) |
| (ii) `‖∇U‖ ≤ M` (TEX:217) vs Thm 5.18 `‖∇U‖ < M` (TEX:979) | `T01_S2`: M ↦ M+1 | **FAIR_IMPLICIT_STEP** (strict vs non-strict bound, filled in with `linarith`) |
| (ii) contrapositive of Thm 5.18 against `E_π[e^{s‖x‖}] = ∞` ∀s>0 | `T01_S3`: `Thm518` gives `∃ s>0, ∫ < ⊤`; rewrite with `hinf s`; `lt_irrefl` | faithful |
| "either of the following" | `T01_main = ⟨S1, S3⟩` | faithful assembly |

No stronger result is used than the source states. `Thm518` is gate-approved as not stronger than TEX:978-984.

## 6. Non-vacuity: FAIL for the main theorem's clause (ii)

- **Part (i), non-vacuous.** In `auditor_T01_nonvac.lean`, `T01_main … .partI` is applied to d=1, `U=‖x‖⁴/4`, ε=1, L=2. Every non-external hypothesis is discharged, including `hL02` (from verified L01/L02). Compiles.
- **Part (ii) via `T01_S3`, non-vacuous.** A Cauchy-type instance: d=1, `U=log(1+‖x‖²)`, `gU=(2/(1+‖x‖²))•x`. I prove `IsGradField`, `‖gU‖ ≤ 1`, `∫⁻ e^{-U} < ⊤` (from mathlib `integrable_rpow_neg_one_add_norm_sq`) and `∀ s>0, ∫⁻ e^{s‖x‖} dπ = ⊤`. `T01_S3 … hE3 … ⟨gc_bdd, gc_heavy⟩` compiles with only `Thm518` as a parameter.
- **Part (ii) via `T01_main`, VACUOUS.** `T01_main` takes `hL02 : T02_L02Consumed gU eps L` unconditionally. That clause says `‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖` for large `‖x_0‖`, and it is false for every bounded gradient. My probe `auditor_T01_vacII.lean` proves `not_L02cons`: for every `gU : E 1 → E 1` with `‖gU‖ ≤ M`, every `eps>0` and every `L≥1`, `¬ T02_L02Consumed gU eps L` (clean, standard axioms; the argument is dimension-independent). So whenever `HypPartII` holds (d=1), the premises of `T01_main` cannot all hold, and `(T01_main …).partII` never applies to a genuine part-(ii) instance.

## 7. FAIL item

**F1 (ENCODING_ERROR, formalization side, gated statement of `T01_main`).** The predecessor condition `hL02` belongs only to part (i): L02 gives it only under (17)+(18). Yet it is a bare premise of the whole main theorem. Consequences:
- (a) the clause `partII` of the main theorem is vacuous (§6);
- (b) part (ii) wrongly appears conditional on `T02_L02Consumed`, `Prop35`, `GaussFacts`;
- (c) reconnection cannot discharge `hL02` for arbitrary `gU`, because L02's main theorem needs (17)+(18). So `T01_main` could never become closed.

This is not a paper issue. The gate (r1 item 5/6) did not catch it.

Suggested fix (needs a new statement gate): make the part-(i) parameters applicable only under (i). For example, `hL02 : HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L`, or move `hL02` into the `partI` clause. I checked that this fix suffices: S1 has `HypExplode`, `HypOscillations` available from `HypPartI` and can supply them. S3 does not use `hL02`. `aud_L02cons` shows the conditional form is satisfiable, and `T01_S3`/the Cauchy instance show that (ii) is then non-vacuous. The proofs of S1-S3 stay unchanged; only `T01_main`'s binder and its one-line proof change.

## 8. Status for the authors

Verified in Lean (steps): (i) follows from Thm 5.14 (verified CONDITIONAL in T02) and (ii) from the contrapositive of Thm 5.18 (cited/out-of-scope, parameter), along the intended route. The ≤/< mismatch between Thm 2.2(ii) and Thm 5.18 is a fair implicit step. Source: Thm 2.2 gives no proof and no pointer to Thms 5.14/5.18 (X3), and it is stated for random 𝔏 while both proofs use fixed L (X2). Both were already dispatched. No paper error found. The current FAIL is a formalization defect in the main theorem's statement.

## 9. Verdict reasoning

Mechanics are clean and every step follows the source. But the gated main theorem is vacuous on clause (ii), and its condition `hL02` can never be discharged (F1). That is a formalization-side defect, not a paper issue, so the result cannot be verified as it stands: UNFINISHED until `T01_main` is restated, re-gated and re-audited. The conditions listed below are the ones the steps really use, per clause: (i) `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`; (ii) `T01_Thm518`. `Thm518` must be registered first.

FINAL AUDIT: FAIL (F1: T01_main's unconditional hL02 makes clause (ii) vacuous and undischargeable; ENCODING_ERROR, formalization side)
SUGGESTED VERDICT: UNFINISHED
CONDITIONS: T02_L02Consumed, T02_Prop35, T02_GaussFacts, T01_Thm518

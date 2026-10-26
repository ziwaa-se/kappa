# C01 final audit (Corollary 2.3 (ii), crly:expfam; gap file `pv_work/C01ModGaps.lean`)

- Auditor: pv-auditor (independent subagent, Opus), session 140c7d85, 2026-10-13.
- Source read directly: `source/geo_erg_HMC_v3.1.tex` 205-240 (Thm 2.2, class E(β,α), Cor 2.3), 800-809 (proof: TEX:806 "Part (ii) is a direct consequence of Theorem \ref{thm:negative}").
- Read in full: `pv_work/C01ModGaps.lean`, `pv_work/C01Stmt.lean`, `pv_work/C01Draft.lean`, `pv_work/C01.lean` (S1-S5 region), `verification/audits/C01_gate.md`, `pv_work/notes/C01_prover_notes.md`, `verification/audits/C01_mech.md`; relevant lines of `T01_final_r2.md`, `C01_issue_1_audit.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py C01 --module C01ModGaps` -> `verification/audits/C01_mech.md`, **MECH CHECKS: PASS (3 manual checks)**.
Compile exit 0 / 0 sorry; private rebuild IDENTICAL; PVTools hash PASS; 15 gated fingerprints identical (S1, S3, S4, S5 th = 454888974, 2553607764, 3960329011, 1707672449, as in the gate snapshot); Defs identical; `#pv_axioms` ALL STANDARD; `#pv_walk` no sorryAx, axioms {propext, Classical.choice, Quot.sound}.
Note: the prover notes say the gate lists no th values; this is wrong, the gate report (C01_gate.md:119-128) lists them, and the script compared them.

## 2. Gap file and statement exactness (§2b, manual items 4b and the rename)

Probe `pv_work/probes/auditor/C01/auditor_C01_stmt.lean` (log `pv_work/logs/auditor_C01_stmt_1.log`, exit 0, 2 sorry = the two verbatim copies only). `C01_S2` and `C01_main` copied verbatim from `C01Draft.lean:34-35, 66-72` under their original full names.

| Check | Result |
|---|---|
| th of re-declared `Paper.C01.C01_S2` | 1705182461 = gate snapshot |
| th of re-declared `Paper.C01.C01_main` | 3911262373 = gate snapshot |
| `example : C01_S2_Gap = type_of% @C01_S2 := rfl` | compiles: gap = full ∀-closure of gated S2, unaltered |
| `example : (C01_S2_Gap → type_of% @C01_main) = type_of% @C01_main_mod_gaps := rfl` | compiles: `_mod_gaps` is exactly "gap → gated main" |
| `C01.lean` vs `C01ModGaps.lean` | read both: S1, S3, S4, S5, helpers identical; S2 is `sorry` in `C01.lean` and the def `C01_S2_Gap` in the gap file; main uses `hGap_2` in place of `C01_S2` |
| Only gap-dependent obligation | `C01_main_mod_gaps` (walks of S1, S3, S4, S5 reach no gap, no sorryAx; log lines 23-71) |

## 3. Axioms and sorry

`#pv_axioms C01ModGaps` ALL STANDARD; `#pv_walk` no sorryAx (mech items 6-7). Per-step walks of S1, S3, S4, S5 (probe log): axioms {propext, Classical.choice, Quot.sound}, sorryAx false.

## 4. Per-theorem conditionality

| Theorem | External parameters used | Evidence |
|---|---|---|
| `C01_S1`, `C01_S3`, `C01_S4`, `C01_S5` | none | no external binder; walks reach only `C01Stmt`, `Defs`, `T02Stmt` definitions (`targetMeas`) and the four private helpers |
| `C01_main_mod_gaps` | `hGap_2`, `hL02` (T02_L02Consumed), `hE1` (T02_Prop35), `hE6` (T02_GaussFacts), `hE3` (T01_Thm518): all USED | `#pv_hyp_usage` (probe log lines 7-22) |
| clause split | β<1 branch: `T01_main.partII`, built only from `T01_S3`, which uses only `Thm518` (walk-verified in `T01_final_r2.md`:42-43). β>2 branch: `hGap_2` + `T01_main.partI` → `T02_L02Consumed`, `Prop35`, `GaussFacts` | proof term C01ModGaps.lean:235-240 and T01_final_r2 |

Unused: `gU` in `C01_S3` (gated signature, harmless; no premise to remove). `hL` in S3 is used (2 ≤ 2^L).
**Correction to the mech report item 11**: "TRACED CONDITIONS: none" and "T01_Thm518 not reached" are wrong. `Paper.T01.Thm518` is in the closure (item 8, `T01Stmt`) and `hE3` is USED; the three T02 parameters are likewise used through `T01_main`. The corrected list is the one T01_final_r2 gives: `T02_L02Consumed, T02_Prop35, T02_GaussFacts, T01_Thm518`.

## 5. Infrastructure

| Module (item 8) | Record | Individual coverage |
|---|---|---|
| `T01` (`T01_S1`, `T01_S2`, `T01_S3`, `T01_main`) | `T01_final_r2.md` FINAL AUDIT PASS (CONDITIONAL) | all four audited there by name |
| `T02`, `L03` | `T02_final.md`, `L03_final.md` | reached only through `T01_main` (closure of T01, covered by its audit chain) |
| `T01Stmt`, `T02Stmt`, `L02Stmt`, `L03Stmt`, `Defs`, `C01Stmt` | respective gate reports | definitions, gated |
| private helpers `rpow_sq_aux`, `grad_norm_aux`, `expfam_U`, `expfam_grad` (item 9) | reviewed here | see below |

Helper review (read source; axioms standard via the per-step walks):
- `rpow_sq_aux`: (r²)^(β/2-1) = r^(β-2) for r>0. True, technical.
- `grad_norm_aux`: if U = k + α‖y‖^β on {‖y‖>M} and HasGradientAt U g x with ‖x‖>M, ‖x‖>0, then ‖g‖ = |αβ|‖x‖^(β-1). True (uniqueness of the derivative on the open tail). This is the source's ∇U = αβ sgn(x)|x|^{β-1} (stated at TEX:809 for part (i)). Technical calculus.
- `expfam_U`: from the class tail form, U = -log c + α‖y‖^β for ‖y‖ > max M 0. Pure rewriting of `piDens = exp(-U)`.
- `expfam_grad`: combines the two. None mentions `GeomErgodic`; none smuggles in the conclusion.

## 6. Route fidelity

Source proof of (ii) (TEX:806): "Part (ii) is a direct consequence of Theorem \ref{thm:negative}". Lean: `C01_main_mod_gaps` = `T01_main` (Thm 2.2) applied on the β<1 branch to Thm 2.2(ii)'s hypotheses (S4, S5) and on the β>2 branch to Thm 2.2(i)'s hypotheses (S1, S2, S3). Same route; no stronger result used; T01 is the verified predecessor (CONDITIONAL).

| Implicit step at TEX:806 | Lean | Classification |
|---|---|---|
| S1: β>2 ⇒ ‖∇U‖/‖x‖ → ∞ | ‖∇U‖/‖x‖ = αβ‖x‖^{β-2} on the tail, `tendsto_rpow_atTop` | FAIR_IMPLICIT_STEP |
| S2: β>2 ⇒ (18) with factor 3 | not proved; gap `C01_S2_Gap` | **false as stated for 2<β<log₂6**: confirmed PAPER_ARGUMENT_GAP (`C01_issue_1.md`, `C01_issue_1_audit.md` COUNTEREXAMPLE VALID) |
| S3: β>2 ⇒ (19) | on the region ‖y‖ ≥ 2^L‖x‖, ‖x‖>M: U(x)-U(y)-‖x‖²/2 ≤ -α(2^β-1)‖x‖^β → -∞ (needs only β>0 and L≥1) | FAIR_IMPLICIT_STEP |
| S4: β<1 ⇒ ‖∇U‖ ≤ M on all of X | tail bound αβ‖x‖^{β-1} ≤ αβ for ‖x‖ ≥ 1; compact part: U = -log π is C¹ (π∈C¹ printed, π>0 by TEX:320), gradient continuous, bounded on a closed ball | FAIR_IMPLICIT_STEP |
| S5: β<1 ⇒ E_π e^{s‖x‖} = ∞ ∀s>0 | integrand ≥ c on {‖x‖>R} (α r^β ≤ s r eventually), that set has infinite Lebesgue measure, Z ∈ (0,∞) | FAIR_IMPLICIT_STEP |
| A1 / random 𝔏 vs fixed L (X2) | not encoded; fixed L only (gate Item 4) | scope limitation, already recorded under T01 (EXPOSITION_GAP candidate) |

Remark on S3: the bound in Lean is not the "≈" sketched in the draft docstring but a cruder valid one; it is a standard estimate filling an unwritten step, not a new route.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/C01/auditor_C01_nonvac.lean` (log `pv_work/logs/auditor_C01_nonvac_3.log`, exit 0, 0 sorry, all `#print axioms` standard).

| Step | Witness | All hypotheses discharged |
|---|---|---|
| S1, S3 | β=4, α=1/4, U=‖x‖⁴/4, gU=‖x‖²x, L=3 | `InExpFam 4 (1/4) U` (M=0, c=1), `IsGradField` |
| S4, S5 | β=1/2, α=1, U = smoothTransition(‖x‖²-1)·√‖x‖ (C¹, = ‖x‖^{1/2} for ‖x‖>2), gU = gradient U | `InExpFam (1/2) 1 U` (M=2, c=1), `IsGradField`, `hπ` (bound π ≤ 48(1+‖x‖²)^{-1}) |
| β<1 branch premise `hL02` | same witness B | `notExplode`: bounded gradient fails (17), so `hL02` is dischargeable on that branch |

`C01_main_mod_gaps` as a whole has the false premise `hGap_2` (refuted in `C01_issue_1`), so it is vacuous as a closed statement; this is the expected status of a gap theorem and does not support any verified verdict.

## 8. Status for the authors

Verified in Lean (modulo the T01 conditions): the β<1 case of Cor 2.3(ii) along TEX:806 (fixed L), and the hypotheses (17), (19) for β>2. The β>2 case fails at TEX:806: hypothesis (18) of Thm 2.2(i) is false for E(β,α) with 2<β<log₂6 (PAPER_ARGUMENT_GAP; the conclusion is not refuted). Other implicit steps are FAIR_IMPLICIT_STEP; the A1/random-𝔏 scope remains as recorded under T01.

## 9. Records to update

- `verification/EXTERNAL_TOOLS.md`: C01 is a consumer of `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`, `T01_Thm518` (the script's "not reached" for T01_Thm518 is wrong).
- Prover-notes claim "gate records no th values" is inaccurate (no audit consequence).

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: T02_L02Consumed, T02_Prop35, T02_GaussFacts, T01_Thm518

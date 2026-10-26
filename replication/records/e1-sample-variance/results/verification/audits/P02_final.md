# P02 final audit (Proposition prop:samuelson, Samuelson's inequality)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), 2026-10-12 22:32 EDT (from `date`).
- Audited object: `pv_work/P02.lean` (no gap file: the s = 0 branch is now proved; `pv_work/P02ModGaps.lean` is superseded and not the audited object).
- Source read directly: `source/main.tex:26-37` (setting, definitions), `:42-48` (lem:centred), `:71-83` (statement and proof).
- Also read: `verification/audits/P02_gate.md`, `verification/audits/P02_issue_1.md`, `pv_work/notes/P02_prover_notes.md`, `pv_work/P02Stmt.lean`, `pv_work/Defs.lean`, `pv_work/P02ModGaps.lean`, the L01 final audit record.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P02`)

Report: `verification/audits/P02_mech.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `P02` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (03a0134f…) |
| 3 | PVTools.lean hash | PASS |
| 4 | 11 gated fingerprints vs `P02_gate.md` | PASS, all th/vh/bi identical |
| 5 | Defs vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms P02` | ALL STANDARD |
| 7 | `#pv_walk P02` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` gated theorems | no UNUSED hypothesis |
| 11 | traced conditions | none |
| 12 | last writers | prover (P02.lean), drafter (P02Stmt.lean) |

## 2. Gap file

Not applicable: the audited module has no gap hypothesis. Consistency check: lines 1-100 of `P02.lean` (helpers, S1-S8) are textually identical to `P02ModGaps.lean`; the only difference is that `P02_main` discharges the s = 0 branch in place of `hGap_0`. Probe confirms `P02_main` proves exactly the proposition of `P02_S0_Gap` (`∀ n, 2 ≤ n → ∀ x, sampleStd x = 0 → Conclusion x`).

## 3. Axioms and sorry

Clean (items 6-7). Re-confirmed in my probe: `#pv_walk_decl Paper.P02.P02_main` → `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false` (log `pv_work/logs/auditor_P02_nonvac_1.log`).

## 4. Per-theorem conditionality

No external parameter (`def Tool : Prop`) in the closure; nothing to trace. Hypotheses of the gated theorems are all USED. `hs : sampleStd x ≠ 0` (S2, S5-S8) is the gate-approved faithful marker of the source's s ≠ 0 route, not an external parameter; it is discharged by the case split in `P02_main`. `P02_main` hypotheses `n, hn, x, i` all USED.

## 5. Infrastructure

| Constant | Module | Record | Status |
|---|---|---|---|
| `Paper.Sample`, `sampleMean`, `sampleVar`, `sampleStd` | Defs | `DEFS_gate.md` | covered (fingerprints identical); re-read: match main.tex:26, 29, 35, 37 |
| `Paper.L01.L01_main`, `L01_S1`, `L01_S2` | L01 | `L01_final.md` (individual rows, FINAL AUDIT PASS, UNCONDITIONAL) | covered |
| `Paper.L01.Conclusion` | L01Stmt | `L01_gate.md` (cited in L01_final) | covered |
| `Paper.P02.Conclusion`, `Paper.P02.z` | P02Stmt | `P02_gate.md` | covered |

Helpers not in the snapshot (item 9), audited one by one here:

| Helper | Statement | True / non-vacuous | Role | Judgement |
|---|---|---|---|---|
| `var_nonneg` | `2 ≤ n → 0 ≤ sampleVar x` | true (1/(n-1) > 0 times sum of squares) | needed for `s² = var` | technical, from main.tex:35 |
| `std_sq` | `2 ≤ n → sampleStd x ^ 2 = sampleVar x` | true (`Real.sq_sqrt`) | main.tex:37 `s = √(s²)` | technical |
| `sum_sq_eq` | `∑(x_i - x̄)² = (n-1)·sampleVar x` | true (n-1 ≠ 0) | "definition of s²" at :77 | technical rearrangement of :35 |

None states the target conclusion or anything beyond the definitions. All are in the axiom-clean closure of `P02` (item 7).

## 6. Route fidelity (sentence by sentence)

| Source | Lean | Judgement |
|---|---|---|
| :76 "Let z_j = (x_j - x̄)/s" | `z` (P02Stmt) | faithful; Lean x/0 = 0 used only under `hs` where it matters |
| :76 "By Lemma 2.1, ∑ z_j = 0" | S1: `L01_main` + `Finset.sum_div` | faithful; pulling 1/s out of the sum is FAIR_IMPLICIT_STEP |
| :76-77 "by the definition of s², ∑ z_j² = n-1" | S2 (hs): `div_pow`, `sum_sq_eq`, `std_sq`, `field_simp` | faithful (Lean has a no-op `rw [← h2]; rw [h2]`, harmless) |
| :77 "z_i = -∑_{j≠i} z_j" | S3: `add_sum_erase` + S1 | faithful |
| :78-80 Cauchy-Schwarz "z_i² ≤ (n-1)∑_{j≠i} z_j²" | S4: mathlib `sq_sum_le_card_mul_sum_sq` on `univ.erase i`, card = n-1 | faithful; this is exactly the C-S instance used; card(univ \ {i}) = n-1 is FAIR_IMPLICIT_STEP |
| :80 "= (n-1)(n-1-z_i²)" | S5 (hs): from S2 | faithful |
| :82 "Hence n z_i² ≤ (n-1)²" | S6: `nlinarith` from S4, S5 | faithful; algebra z² ≤ (n-1)(n-1-z²) ⇔ n z² ≤ (n-1)² (n-1 > 0 not even needed) is FAIR_IMPLICIT_STEP |
| :82 "that is, \|z_i\| ≤ (n-1)/√n" | S7: `le_div_iff₀`, `le_of_sq_le_sq`, √n > 0, n-1 ≥ 0 | faithful; square root step FAIR_IMPLICIT_STEP |
| :82 "Multiplying by s gives the claim" | S8: x_i - x̄ = z_i s (s ≠ 0), s ≥ 0 (:37) | faithful |
| (not written) s = 0 case | `P02_main`, `by_cases hs` branch | fill-in, see below |

No route change, no stronger result used than in the source (Cauchy-Schwarz is the instance printed at :78-80; L01 is the cited lem:centred).

### Fill-in: the s = 0 branch (FAIR_IMPLICIT_STEP, per `P02_issue_1.md` §3, §6)

Checked against the five steps of the ruling and against main.tex:35, 37:

| Ruling step | Lean (P02.lean:107-125) | Source basis | Matches |
|---|---|---|---|
| 1. var ≥ 0 | via `std_sq` → `var_nonneg` | :35, n ≥ 2 | yes |
| 2. s = 0 ⇒ var = 0 | `rw [← std_sq hn x, hs]; ring` | :37 s = √(s²) | yes |
| 3. (1/(n-1))∑ = 0, 1/(n-1) > 0 ⇒ ∑ = 0 | `mul_eq_zero`, `one_div_pos` | :35 | yes |
| 4. sum of squares 0 ⇒ x_i - x̄ = 0 | `Finset.sum_eq_zero_iff_of_nonneg`, `pow_eq_zero_iff` | elementary | yes |
| 5. \|0\| ≤ c·0 | `abs_zero`, `mul_zero` | — | yes |

The fill-in uses only the definitions, kept as a case split; the s ≠ 0 branch is S8 unchanged. My independent view of the classification: I agree with FAIR_IMPLICIT_STEP. This is the degenerate case of a normalisation by s, in which both sides vanish directly by the source's own definitions; it adds no hypothesis, tool or idea. The issue ruling (§8) flags the label for human check (FAIR_IMPLICIT_STEP vs a minor EXPOSITION_GAP). I keep that flag; the mathematics is fully checked either way.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/P02/auditor_P02_nonvac.lean`: `scripts/pv_lean.sh probe` → RESULT exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 (log `pv_work/logs/auditor_P02_nonvac_1.log`).
- `example : ∀ n, 2 ≤ n → ∀ x, Conclusion x := P02_main`, and `Conclusion x ↔ ∀ i, |x_i - x̄| ≤ (n-1)/√n · s` by `Iff.rfl`.
- Nontrivial witness (s ≠ 0 branch): n = 3, x = (1, 2, 6); proved mean = 3, var = 7, s ≠ 0; `Conclusion w` and the near-tight instance |3| ≤ (2/√3)√7 ≈ 3.055.
- Degenerate witness (s = 0 branch): n = 2, x constant 5; proved `sampleStd c = 0`, and `Conclusion c`.

## 8. Status for the authors

Verified: Samuelson's inequality (main.tex:71-72) for all n ≥ 2 and all x, along the printed route (:76-82); depends only on lem:centred (L01, verified unconditionally) and mathlib's Cauchy-Schwarz.
Source assessment: correct as printed. The proof divides by s without mentioning s = 0 (all x_i equal); that case is trivial (both sides 0) and was filled in as FAIR_IMPLICIT_STEP. Suggested editorial sentence before :76: "If s = 0 all x_i equal x̄ and both sides vanish; assume s > 0." Label FAIR_IMPLICIT_STEP vs minor EXPOSITION_GAP is left for human check (P02_issue_1 §8).

## FAIL items

None.

## Not checked / notes

- External parameters: none registered or reached; no registered inputs to exclude.
- `P02ModGaps.lean` is superseded; it was not audited as a deliverable (only compared textually).

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

# L02 final audit (Lemma lem:shortcut, source/main.tex:50-56)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5); did not draft, gate or prove L02.
- Date: Mon Oct 12 22:10:57 EDT 2026 (from `date`)
- Audited object: `pv_work/L02.lean` (no gap file; no stopped obligations).
- Hashes (`python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02.lean` 9cf4a7dfbc94ddd9d23d1a1835694f291982d77560662b114d8811dab0c6a17b
  - `pv_work/L02Stmt.lean` 33bc8f135f6c692d4e2b97744bad9c46cb6752122c2c23e79c173fa1343fb8d9 (= gate)
  - `pv_work/Defs.lean` e69206f7d2a70bcd4649080667849f049f88b44dee34db844183a542471fc08e (= DEFS gate)
  - `source/main.tex` 1cbdd1aa5b3d8616c3f4505b9062441d71b2f7e2644e20af8eaa1f4aed5a3250 (= gate)
- Read directly: source/main.tex:1-109 (whole file, incl. l.26 convention, l.29 def:mean, l.50-56); `pv_work/L02.lean`, `pv_work/L02Stmt.lean`, `pv_work/Defs.lean` in full; gate report, DEFS gate report, draft notes, prover notes.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L02`)

Report `verification/audits/L02_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L02` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools.lean hash | PASS |
| 4 | fingerprints vs gate (4 gated decls: Conclusion, L02_S1, L02_S2, L02_main) | PASS, all th/vh/bi identical |
| 5 | Defs vs DEFS gate | PASS |
| 6 | `#pv_axioms L02` | ALL STANDARD |
| 7 | `#pv_walk L02` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 8 | project constants | `Paper.Sample`, `Paper.sampleMean` (DEFS_gate.md, named individually), `Paper.L02.Conclusion` (L02_gate.md) |
| 9 | helpers not in snapshot | none |
| 10 | hyp usage | no UNUSED |
| 11 | traced conditions | none |
| 12 | last writers | prover (L02.lean), drafter (L02Stmt.lean) |

## 2. Gap file
Not applicable (no `L02ModGaps.lean`; prover reports no gaps; all three obligations proved).

## 3. Axioms and sorry
Standard axioms only; no `sorryAx` in closure (items 6-7). Re-confirmed in my probe: `#print axioms Paper.L02.L02_main` -> [propext, Classical.choice, Quot.sound].

## 4. Per-theorem conditionality
No external parameters (`def Tool : Prop`) exist in the closure. The only hypothesis besides the data is `hn : 1 ≤ n`, the printed global convention main.tex:26, not an external parameter. `#pv_hyp_usage` (probe `pv_work/probes/auditor/L02/auditor_L02_nonvac.lean`, log `pv_work/logs/auditor_L02_nonvac_1.log`): `hn` USED in `L02_main`, passed to `L02_S2`, where it is USED (gives `(n:ℝ) ≠ 0` for `field_simp`), matching the source's use of `∑ x_i = n x̄` from def:mean. (Remark: the Lean identity is also true for n = 0, but keeping the printed hypothesis is correct.)

## 5. Infrastructure
| Constant | Record | Judgement |
|---|---|---|
| `Paper.Sample` | DEFS_gate.md (named) | `abbrev Fin n → ℝ`, faithful to l.26 |
| `Paper.sampleMean` | DEFS_gate.md (named) | `(1/n) * ∑ x i`, faithful to l.29 |
| `Paper.L02.Conclusion` | L02_gate.md (named, snapshot) | literal l.51 |

No unrecorded constants; no helpers outside the snapshot.

## 6. Route fidelity
| Source (main.tex:55) | Lean | Ruling |
|---|---|---|
| "Expanding the square" | `L02_S1`: pointwise `ring` expansion `(x_i-m)^2 = x_i^2 - 2 m x_i + m^2`, then `Finset.sum_add_distrib`, `sum_sub_distrib`, `mul_sum`, `simp` (sum of constant = n m^2) | faithful; technical conversions only |
| "using ∑ x_i = n x̄" | `L02_S2`: from def of `sampleMean` with `n ≠ 0` | FAIR_IMPLICIT_STEP: the source asserts the identity; filled in by unfolding def:mean (l.29) and cancelling 1/n using n ≥ 1 (l.26) |
| "we obtain the claim" | `L02_main`: rewrite S1, S2, `ring` (−2n m² + n m² = −n m²) | FAIR_IMPLICIT_STEP: the final algebraic simplification, done by `ring` |

Route unchanged; no stronger result used; no predecessor or external result used.

## 7. Non-vacuity
Probe `pv_work/probes/auditor/L02/auditor_L02_nonvac.lean` (`scripts/pv_lean.sh probe`, exit=0, errors=0, sorry=0): `L02_main` instantiated at n=2, x=(1,3) and n=3, x=(0,2,7) (hypothesis `1 ≤ n` satisfied); `Conclusion` at (1,3) also checked directly from the definitions (2 = 10 − 8), and a perturbed conclusion (dropping `− n x̄²`) is shown false at the same witness, so `Conclusion` is not a trivially true Prop.

## 8. Status for the authors
Lemma lem:shortcut (main.tex:50-56) is verified in full along the printed route, with no external inputs; only the global convention n ≥ 1 (l.26) is used.
Source assessment: correct; the two unwritten steps (∑x_i = n x̄ from def:mean, final simplification) are fair implicit steps. No errors, gaps or ambiguities.

## FAIL items
None.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

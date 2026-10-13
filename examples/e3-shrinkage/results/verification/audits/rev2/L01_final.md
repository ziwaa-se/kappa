# Final audit: L01 (Lemma lem:square, source/main.tex:38-46)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Mon Oct 12 22:09:10 EDT 2026 (from `date`)
- Audited object: `pv_work/L01.lean` (no gap file)
- Read directly: source `main.tex:1-79` (statement 38-40, proof 42-46, conventions 25, definitions 27-34); `pv_work/L01.lean`, `pv_work/L01Stmt.lean`, `pv_work/Defs.lean` in full; `verification/audits/L01_gate.md`, `verification/audits/DEFS_gate.md`, `pv_work/notes/L01_prover_notes.md` (prover claims not relied upon).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L01`)

Report `verification/audits/L01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (d278d7ba…) |
| 3 | PVTools hash | PASS |
| 4/4a | gated fingerprints S1, S2, S3, L01 vs gate snapshot | PASS (all th/vh/bi identical) |
| 5 | Defs vs DEFS snapshot | PASS |
| 6 | `#pv_axioms L01` | PASS, ALL STANDARD |
| 7 | `#pv_walk L01` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` | no UNUSED binders |
| 11 | traced conditions | none |
| 12 | last writer | pv-prover |

## 2. Gap file

Not applicable (no `L01ModGaps.lean`; no stopped obligations).

## 3. Per-theorem conditionality

The only hypothesis is `h : Setting θ σ`, the printed standing assumption main.tex:25; it is not an external parameter. Confirmed by my probe (`#pv_hyp_usage`): in `L01`, and in `L01_S2`, `h` is USED; it enters via `pos_of_setting` to give θ²+σ² ≠ 0 for `field_simp` (S2, S3). No `def Tool : Prop`, no consumed predecessor clause, no registered input. Conditions: none.

## 4. Infrastructure

| Constant | Module | Record | Ruling |
|---|---|---|---|
| `Paper.Setting`, `.mk`, `.sigma_pos` | Defs | DEFS_gate.md (names each, PASS) | covered |
| `Paper.risk`, `Paper.oracleFactor`, `Paper.oracleRisk` | Defs | DEFS_gate.md (names each, PASS) | covered; I re-read them against main.tex:29,31,33: verbatim |
| `Paper.L01.pos_of_setting` (private helper, item 9) | L01 | audited here | Statement `Setting θ σ → 0 < θ²+σ²`: true (σ>0), non-vacuous, technical domain fact; proof `positivity` from `sigma_pos`; within the clean axiom closure of L01; does not contain the target. PASS |

## 5. Route fidelity (sentence by sentence)

| Source | Lean | Ruling |
|---|---|---|
| main.tex:43 "Expanding the squares, R(c) = (θ²+σ²)c² − 2θ²c + θ²" | `L01_S1`: `unfold risk; ring` | faithful |
| main.tex:43-44 "Completing the square gives R(c) = (θ²+σ²)(c−c*)² + θ² − θ⁴/(θ²+σ²)" | `L01_S2`: rewrite with S1, unfold c*, `field_simp; ring` | faithful; uses S1 as the source does |
| main.tex:44-45 "θ² − θ⁴/(θ²+σ²) = ρ" | `L01_S3`: unfold ρ, `field_simp; ring` | faithful |
| conclusion (39) | `L01`: rewrite S2, S3, `ring` (cancellation of ρ) | faithful, trivial rearrangement |

No route change, no stronger result used, no new mathematics. 

FAIR_IMPLICIT_STEP: θ²+σ² ≠ 0 (division in main.tex:44-45 is not justified in text); filled in by `pos_of_setting` from σ>0 of the standing assumption main.tex:25 (as also ruled at the gate).

## 6. Non-vacuity

Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (`scripts/pv_lean.sh probe …` exit=0, 0 errors, 0 sorry; log `pv_work/logs/auditor_L01_nonvac_2.log`): witnesses `Setting 1 1` and the nontrivial `Setting (-3) 2`; `L01` applied to both (all c for the second); numerical sanity check R(0)=9, ρ=36/13, c*=9/13 (consistent: 13·(9/13)² = 81/13 = 9 − 36/13).

## 7. Status for the authors

Lemma lem:square is verified in Lean along the printed proof, with no external inputs; it uses only the standing assumption (σ>0 to divide by θ²+σ²). Source: correct as printed; no errors, gaps or ambiguities found.

## 8. Remarks

- Prover note mentions a dupNamespace linter warning (`Paper.L01.L01`); cosmetic, not an issue.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

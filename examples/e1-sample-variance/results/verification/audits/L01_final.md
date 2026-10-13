# L01 final audit (Lemma lem:centred, source/main.tex:42-48)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Mon Oct 12 22:10:54 EDT 2026 (from `date`)
- Audited object: `pv_work/L01.lean` (no gap file; no ModGaps/Closed modules)
- Read directly: `source/main.tex:24-48` (setting, def:mean, def:var, lem:centred and proof); `pv_work/L01.lean`, `pv_work/L01Stmt.lean`, `pv_work/Defs.lean` (full text); `verification/audits/L01_gate.md`; `verification/audits/DEFS_gate.md` (coverage lines); `pv_work/notes/L01_prover_notes.md`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L01`)

Report: `verification/audits/L01_mech.md`, ending `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit 0, 0 errors, 0 sorry warnings) |
| 2 | private rebuild sha256 | PASS (IDENTICAL) |
| 3 | PVTools.lean hash | PASS |
| 4 | gated fingerprints vs L01_gate (Conclusion, S1, S2, main) | PASS, all identical |
| 5 | Defs vs DEFS_gate | PASS |
| 6 | `#pv_axioms L01` | PASS, ALL STANDARD |
| 7 | `#pv_walk L01` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 11 | traced conditions | none |
| 12 | last writers | prover for L01.lean, drafter for L01Stmt.lean |

## 2. Gap files
Not applicable (no `L01ModGaps.lean`; no stopped obligations).

## 3. Axioms / sorry
Only the three standard axioms; no `sorryAx` in the closure (items 6-7).

## 4. Per-theorem conditionality
| Theorem | Hypotheses | Usage | Assessment |
|---|---|---|---|
| `L01_S1` | n, hn, x | `hn` UNUSED | S1 is true for every n; `hn` is the global source hypothesis (main.tex:26), not an external parameter. Already noted at the gate; harmless. |
| `L01_S2` | n, hn, x | all USED | `hn` gives `(n:ℝ) ≠ 0` for `field_simp`, which is the "by the definition of x̄" step (n x̄ = ∑ x_i requires n ≠ 0 in this encoding). |
| `L01_main` | n, hn, x | all USED | `hn` passed to S2 only. |

No external `def … : Prop` parameters exist; nothing to trace further.

## 5. Infrastructure (item 8)
| Constant | Module | Individual record | Status |
|---|---|---|---|
| `Paper.Sample` | Defs | `DEFS_gate.md` line 47 (fingerprint listed, STATEMENT GATE: PASS) | covered |
| `Paper.sampleMean` | Defs | `DEFS_gate.md` line 48 | covered |
| `Paper.L01.Conclusion` | L01Stmt | `L01_gate.md` line 59 | covered |

All are definitions (no theorems consumed from other project modules). No unaudited constant; no helpers to review.

## 6. Route fidelity
| Source (main.tex:47) | Lean | Ruling |
|---|---|---|
| "∑(x_i − x̄) = ∑x_i − n x̄" | `L01_S1`: `Finset.sum_sub_distrib`, then `simp` (sum of a constant over `Fin n` = n · x̄) | faithful; linearity of the finite sum and `card (Fin n) = n` are a FAIR_IMPLICIT_STEP |
| "= 0", "by the definition of x̄" | `L01_S2`: unfold `sampleMean`, `field_simp` with `(n:ℝ) ≠ 0` from `hn` | faithful; cancellation n·(1/n) = 1 under n ≥ 1 is a FAIR_IMPLICIT_STEP |
| conclusion | `L01_main`: unfold `Conclusion`, rewrite with S1, close with S2 | faithful (transitivity of the printed chain) |

No route change, no stronger result used, no new mathematical statement, no helper lemmas.

## 7. Non-vacuity
Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (`scripts/pv_lean.sh probe` → `RESULT auditor_L01_nonvac mode=probe exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/auditor_L01_nonvac_1.log`):
- nontrivial witness n = 3, x = (1, 2, 6): proved `sampleMean w = 3` and `Conclusion w` via `L01_main 3 (by norm_num) w`;
- n = 1 constant witness also instantiates;
- `Conclusion w ↔ ∑ i, (w i − sampleMean w) = 0` holds by `Iff.rfl`, so the conclusion is the printed equation, not a trivial proposition.

## 8. Status for the authors
Lemma lem:centred (main.tex:42-44) is verified along the printed proof (main.tex:47) with no external parameters and only standard axioms.
Depends on nothing beyond the global convention n ≥ 1 (main.tex:26) and Definition def:mean.
Source assessment: correct and complete; no errors, gaps or ambiguities. Two FAIR_IMPLICIT_STEPs (sum linearity, n·(1/n) = 1).

## Notes (not conditions)
- `hn` unused in `L01_S1` (step obligation only, statement true without it); not a premise of an external tool, so nothing to remove from the main theorem, where `hn` is used.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

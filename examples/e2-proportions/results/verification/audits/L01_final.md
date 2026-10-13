# L01 final audit (Lemma `lem:quarter`, main.tex:38-45)

- Auditor: pv-auditor (independent subagent, fresh session), Mon Oct 12 22:09:09 EDT 2026 (from `date`)
- Audited object: `pv_work/L01.lean` (no gap file; no gaps recorded)
- Mechanical report: `verification/audits/L01_mech.md`, run by me (`python3 scripts/pv_audit_mech.py L01`): **MECH CHECKS: PASS**
- Source read directly: main.tex:24 (convention n >= 1), 26-29 (def:vp), 38-45 (statement and proof).

## Mechanical checks (from `L01_mech.md`)

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit=0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | gated fingerprints vs `L01_gate.md` (12 decls) | PASS, identical |
| 5 | `Defs` vs `DEFS_gate.md` | PASS, identical |
| 6 | `#pv_axioms L01` | PASS, all standard |
| 7 | `#pv_walk L01` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED hypotheses |
| 11 | traced conditions | none |

## Gap files

None (no `L01ModGaps.lean`; prover notes record no gaps).

## Per-theorem conditionality

No external parameters (`def Tool : Prop`) in the closure; the only hypothesis besides `n`, `p` is `hn : 1 ≤ n`, the source's global convention (main.tex:24), reported USED by `#pv_hyp_usage` (in S2, giving `(0:ℝ) < n`). Conditions: none.

## Infrastructure (item 8)

| Constant | Record | Check |
|---|---|---|
| `Paper.DEFS.V` | `DEFS_gate.md` (names it, fingerprint line 48, ruling 2) | definition `p*(1-p)/(n:ℝ)`, faithful to main.tex:27 |
| `Paper.L01.Conclusion`, `.mk` | `L01_gate.md` (snapshot) | plain Prop structure of the two printed clauses; no hypotheses smuggled |

No project constant without an individual record. No helpers.

## Route fidelity

| Source sentence | Lean | Ruling |
|---|---|---|
| main.tex:43 "Expanding, 1/4 - (p-1/2)^2 = ... = p(1-p)" | `L01_S1`: `ring` | faithful (expansion = ring normalisation) |
| main.tex:43-44 "Since (p-1/2)^2 >= 0 and n > 0, the bound follows" | `L01_S2`: `sq_nonneg`, `0 < (n:ℝ)` from `hn`, rewrite by S1, `div_le_div_iff₀`, `nlinarith` | faithful; uses exactly the two cited facts |
| assembly | `L01_main := ⟨L01_S1 p, L01_S2 n hn p⟩` | faithful |

FAIR_IMPLICIT_STEP: (a) `n > 0` from the convention `n ≥ 1` (main.tex:24), filled by `exact_mod_cast hn`; (b) "the bound follows" = clearing the positive denominators and combining `p(1-p) = 1/4 - (p-1/2)^2 ≤ 1/4`, filled by `div_le_div_iff₀` + `nlinarith`. No route change, no stronger result used.

## Non-vacuity

Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (`scripts/pv_lean.sh probe`, exit=0, 0 errors, 0 sorry, standard axioms; log `pv_work/logs/auditor_L01_nonvac_1.log`): `Conclusion 3 (1/2)` and `Conclusion 1 7` obtained from `L01_main`; the bound is attained at `p = 1/2, n = 3` (sharp); `V 1 (1/2) ≤ 1/5` is false, so the clause is not a tautology.

## Status for the authors

Lemma lem:quarter (both clauses, all real p, n ≥ 1) is verified along the printed proof, with no external dependencies.
Source assessment: correct as printed; no errors, gaps or ambiguities (the domain of I does not enter this lemma).

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

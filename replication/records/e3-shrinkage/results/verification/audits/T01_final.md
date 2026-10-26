# Final audit: T01 (Theorem thm:oracle, source/main.tex:63-66; proof 68-72)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 01:19:27 EDT 2026 (from `date`)
- Audited object: `pv_work/T01.lean` (sha256 ed7cd5c2d923789769b6480b1a48c74bc505f28205a337c2fafceba7080ad7a1), statement `pv_work/T01Stmt.lean` (a64ad4ae…, = gate snapshot hash)
- Read directly: `source/main.tex:1-84` (convention l.25, Definition l.27-35, lem:square l.39-52, lem:min l.54-61, thm:oracle l.63-72); `pv_work/T01.lean`, `pv_work/T01Stmt.lean` in full; `verification/audits/T01_gate.md` in full; `pv_work/notes/T01_prover_notes.md`; key lines of `L01_final.md`, `L02_final.md`, `L01_mech.md`, `L02_mech.md`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py T01`)

Report `verification/audits/T01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (5593374f…) |
| 3 | PVTools hash | PASS |
| 4 | 14 gated fingerprints (Conclusion*, S1, S2, S3, main) vs gate snapshot | PASS, identical |
| 5 | Defs vs DEFS snapshot | PASS |
| 6 | `#pv_axioms T01` | PASS, ALL STANDARD (re-confirmed in my probe: S1, S2, S3, main each `[propext, Classical.choice, Quot.sound]`) |
| 7 | `#pv_walk T01` | PASS, sorryAx not reached |
| 9 | helpers not in snapshot | none |
| 12 | last writers | prover (T01.lean), drafter (T01Stmt.lean) |

The two item-10 warnings ("4 leading binders, proof binds 3") concern `Conclusion.ge` / `Conclusion.eq_iff`, which are auto-generated structure projections, not gated proof obligations; not an issue.

## 2. Gap file

Not applicable: no `T01ModGaps.lean`; no stopped obligations.

## 3. Imported modules are current

| Module | `.olean` sha256 now | = delivered = rebuilt in mech report | Final audit |
|---|---|---|---|
| L01 | a464e835…b1d | yes (`L01_mech.md` item 2) | `L01_final.md`: PASS / UNCONDITIONAL / CONDITIONS: none |
| L02 | 06f8f111…9b2 | yes (`L02_mech.md` item 2) | `L02_final.md`: PASS / UNCONDITIONAL / CONDITIONS: none |
| Defs.lean | 1de1a18f…b31 | = DEFS gate hash | DEFS_gate.md |

## 4. Per-theorem conditionality

`#pv_hyp_usage` (mech item 10 and my probe): T01_main, S1, S3 have only θ, σ, `h : Setting θ σ` (and `c` in S1), all USED; S2 has only θ, σ. `Setting` is main.tex:25 verbatim, not an external parameter. No `def … : Prop` parameters in T01Stmt/T01. TRACED CONDITIONS: none; confirmed.

Registered input `T01_L02Consumed` is **not reached** by any gated theorem (it was removed from the statement at the gate, L02 now consumed as a final-passed module). It is not a condition; the record for T01 should drop it.

## 5. Infrastructure (item 8): every project constant in the closure

| Constant(s) | Module | Individual PASS record |
|---|---|---|
| `Paper.Setting`, `.mk`, `.theta_ne`, `.sigma_pos`, `Paper.risk`, `Paper.oracleFactor`, `Paper.oracleRisk` | Defs | DEFS_gate.md (D01-D04) |
| `Paper.L01.L01`, `L01_S2`, `L01_S3`, `L01_S4`, `L01_S5`, private `s_ne` | L01 | L01_final.md (names S1-S5, main and `s_ne` individually) |
| `Paper.L02.L02_S1`, `L02_S2`, `L02_S3`, `L02_main` | L02 | L02_final.md (route table names each) |
| `Paper.L02.Conclusion` | L02Stmt | L02_gate.md; also reviewed in L02_final.md |
| `Paper.T01.Conclusion`, `.mk` | T01Stmt | T01_gate.md |

No constant without a record; no helpers in T01.lean beyond the gated S1-S3, main.

## 6. Route fidelity

| Source sentence | Lean | Ruling |
|---|---|---|
| :69 "By Lemma lem:square, R(c) − ρ = (θ²+σ²)(c−c*)²" | S1: `Paper.L01.L01 θ σ h c` | faithful, same lemma |
| :69 "≥ 0" | S1: `positivity` on the product, `linarith` | faithful |
| :69-70 "with equality iff c = c*, because θ²+σ² > 0" | S1: θ²+σ² > 0 by `positivity` from `Setting` (:25); (→) `mul_eq_zero`, factor ≠ 0, `pow_eq_zero_iff`; (←) rewrite c = c*, `linarith` | faithful; deriving θ²+σ² > 0 from :25 and the "square is zero iff base is zero" step are FAIR_IMPLICIT_STEP |
| :70 "R(0) = θ² and R(1) = σ²" | S2: `unfold risk; ring` | faithful, direct computation from :29 |
| :70-71 "Lemma lem:min gives ρ ≤ min{R(0), R(1)}" | S3: rewrite with S2, `Paper.L02.L02_main θ σ h.theta_ne h.sigma_pos` | faithful, same lemma |
| statement :64-65 | main: `⟨(S1 ·).1, (S1 ·).2, S3⟩` | pure assembly |

No route change, no stronger result used, no new mathematics.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/T01/auditor_T01_nonvac.lean` (`scripts/pv_lean.sh probe`, exit 0, 0 errors, 0 sorry, log `pv_work/logs/auditor_T01_nonvac_4.log`):
- `Setting 2 3` and `Setting (-1) (1/2)` inhabited; `T01_main` instantiated at both.
- Nontrivial values at (2,3): c* = 4/13, ρ = 36/13, R(0) = 4, R(1) = 9.
- Content check: `¬ Conclusion 0 0` (outside the setting, `eq_iff` fails at c = 1), so the conclusion is not trivially true.

## 8. Status for the authors

Theorem thm:oracle (all three clauses) verified along the printed proof, using Lemmas lem:square and lem:min, both themselves verified unconditionally. No external inputs. Source assessment: no errors, gaps or ambiguities in l.63-72; only routine fill-ins (θ²+σ²>0 from l.25; zero-product step).

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

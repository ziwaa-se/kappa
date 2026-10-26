# Final audit: T01 (Theorem thm:oracle, source/main.tex:58-67)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5); date `Mon Oct 12 22:18:46 EDT 2026` (from `date`)
- Audited object: `pv_work/T01.lean` (sha256 4acf9707…0559), statement module `pv_work/T01Stmt.lean` (sha256 8aea38f5…b00d, identical to the gate record). No gap file (all obligations proved).
- Read directly: `source/main.tex:1-79` (convention l.25, Definition l.27-34, lem:square l.38-46, lem:min l.48-56, thm:oracle l.58-67); `pv_work/T01.lean`, `T01Stmt.lean`, `Defs.lean`, `L02Stmt.lean` in full; `T01_gate.md` in full; prover notes; verdict/scope lines of `L01_final.md`, `L02_final.md`, `L02_issue_1.md`, `L02_issue_1_audit.md`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py T01`)

Report `verification/audits/T01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T01` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (d1a4b789…6aaf) |
| 3 | PVTools hash | PASS |
| 4 | statement fingerprints vs `T01_gate.md` (17 gated declarations, th/vh/bi) | PASS, all identical. This is the comparison the prover did not make; it is now done. |
| 5 | `Defs` vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms T01` | ALL STANDARD |
| 7 | `#pv_walk T01` | axioms {propext, Classical.choice, Quot.sound}; sorryAx not reached |
| 9 | helpers not in snapshot | none |
| 11 | TRACED CONDITIONS | `none` (**corrected below, item 4**) |

## 2. Gap files

Not applicable: no `T01ModGaps.lean`; S1-S5 and T01 are all proved.

## 3. Axioms / sorry

Clean (items 6-7). My own probe walk of `aud_T01_inst` (the theorem applied at a concrete point) gives the same three axioms, sorryAx false.

## 4. Per-theorem conditionality

`#pv_hyp_usage` (mech item 10, repeated in my probe `pv_work/probes/auditor/T01/auditor_T01_nonvac.lean`, log `pv_work/logs/auditor_T01_nonvac_2.log`):

| Theorem | hL02 : T01_L02Consumed | h : Setting |
|---|---|---|
| `T01` | USED | USED |
| `T01_S5` | USED (proof `exact hL02 θ σ h` after rewriting S3/S4; actual use, not a hand-off) | USED |
| `T01_S1`, `T01_S2` | (no such binder) | USED (θ²+σ²>0 via `sigma_pos`; L01) |
| `T01_S3`, `T01_S4` | (no such binder) | (no such binder) |

`T01` passes `hL02` only to `T01_S5`, where it is consumed directly. So the (p) clause enters **only through clause 3 (`le_min`, main.tex:60), at step S5 (main.tex:65-66)**; clauses 1-2 (`ge`, `eq_iff`) do not take it (S1, S2 have no such binder; that is a type-level fact, so no walk is needed).

**Correction to mech item 11.** The script reports `TRACED CONDITIONS: none` because `python3 scripts/pv_status.py tools` returns an empty registry: `T01_L02Consumed` is not registered in `verification/EXTERNAL_TOOLS.md`. The parameter is nevertheless an explicit, USED premise of the main theorem. The correct condition is `T01_L02Consumed` → S5 / clause 3. **Records to update:** register `T01_L02Consumed` ((p), predecessor L02, main.tex:48-50, consumed at main.tex:66, used by T01 S5) so that the tooling traces it.

## 5. Infrastructure (project constants in the closure, mech item 8)

| Constant(s) | Module | Covering record | Individual check |
|---|---|---|---|
| `Paper.Setting`(.mk, .sigma_pos), `risk`, `oracleFactor`, `oracleRisk` | Defs | `DEFS_gate.md` (fingerprints identical, item 5) | definitions are verbatim l.25, l.29, l.31, l.33 (read by me) |
| `Paper.L01.L01`, `L01_S1..S3` | L01 | `L01_final.md`: FINAL AUDIT PASS, UNCONDITIONAL | named and audited there |
| `_private…L01.pos_of_setting` | L01 | `L01_final.md` line 38, individually PASS | named there |
| `Paper.L02.Conclusion` | L02Stmt | `L02_gate.md` (gated def) | read by me: `oracleRisk θ σ ≤ min (θ^2) (σ^2)` = l.49 verbatim; a Prop definition, no proof content |
| `Paper.T01.Conclusion`(.mk), `T01_L02Consumed` | T01Stmt | `T01_gate.md` | fingerprints identical; statement content checked in item 6/7 below |

No constant without a record; no helper in `T01.lean` beyond S1-S5 and T01. No L02 theorem (with its stopped S2/S3) is in the closure: only the statement def `L02.Conclusion` is reached, via the (p) parameter.

## 6. Route fidelity

| Source sentence | Lean | Ruling |
|---|---|---|
| l.64 "By Lemma lem:square, R(c) − ρ = (θ²+σ²)(c−c*)² ≥ 0" | S1: `L01` + `positivity` + `linarith` | faithful; L01 is the final-passed lem:square |
| l.64-65 "with equality iff c = c*, because θ²+σ² > 0" | S2: `L01`, `mul_eq_zero`, θ²+σ²≠0, `pow_eq_zero_iff` | faithful; reason θ²+σ²>0 is printed; obtained from σ>0 (l.25) |
| l.65 "R(0) = θ²" | S3: `unfold risk; ring` | faithful computation |
| l.65 "R(1) = σ²" | S4: `unfold risk; ring` | faithful computation |
| l.65-66 "Lemma lem:min gives ρ ≤ min{R(0),R(1)}" | S5: rewrite with S3, S4, then `hL02 θ σ h` | faithful; uses exactly lem:min's printed conclusion, nothing stronger |
| Theorem l.59-60 | `T01 := ⟨S1, S2, S5⟩` | clause-by-clause assembly |

No route change, no stronger result used. FAIR_IMPLICIT_STEPs:
- θ²+σ² > 0 from σ > 0 (l.25), filled by `positivity` on `h.sigma_pos` (S1, S2). The source states the fact at l.65 without derivation.
- (c−c*)² = 0 ⇒ c = c* (S2), filled by `pow_eq_zero_iff`; standard.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/T01/auditor_T01_nonvac.lean` (sha256 ba7e8837…3a33), `scripts/pv_lean.sh probe` → `exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/auditor_T01_nonvac_2.log`:
- `Setting 1 1` and nontrivial `Setting (-3) 2` constructed;
- `T01_L02Consumed` unfolds by `rfl` to ∀θ σ, Setting θ σ → ρ ≤ min{θ²,σ²} (= l.49 under l.25), and is proved true in the probe (sanity only, not the source route; agrees with `conclusion_true` in `L02_issue_1.md`), so the conditional theorem is not vacuous;
- `T01` applied at (−3, 2): ρ = 36/13 ≤ R(c) for all c; R(9/13) = ρ via `eq_iff`; min{R(0),R(1)} = 4. Walk: standard axioms, no sorryAx.
- The type of `T01` is checked by `example` to be `T01_L02Consumed → ∀ θ σ, Setting θ σ → Conclusion θ σ`.

## 8. Status for the authors

Verified: Theorem thm:oracle (all three clauses), along the printed route, using Lemma lem:square (verified unconditionally).
Depends on: the printed conclusion of Lemma lem:min (ρ ≤ min{θ²,σ²}), used only for clause 3; that conclusion is true, but its printed proof has a PAPER_ARGUMENT_GAP (L02_issue_1).
Source assessment for T01 itself: no error or gap; editorial only, the docstring of `T01_L02Consumed` cites "main.tex:66-67" where the use is l.65-66 (already noted at the gate; a candidate for `DOC_ERRATA.md`, not a paper issue).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: T01_L02Consumed

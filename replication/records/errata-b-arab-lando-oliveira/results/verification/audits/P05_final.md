# P05 final audit (Proposition cor:invNWU, source F:429-436), gap file

- Role: pv-auditor (Claude Opus 5.5), independent subagent, final-audit mode.
- Date: Tue Oct 13 02:28:21 EDT 2026 (from `date`).
- Audited object: `pv_work/P05ModGaps.lean` (stopped obligation `P05_main`); `pv_work/P05.lean` compared.
- Read directly: source F:108-147, F:340-359, F:380-449; `pv_work/P05ModGaps.lean`, `pv_work/P05Stmt.lean`, `pv_work/L02Stmt.lean`, `pv_work/L01Stmt.lean` (full); gate `verification/audits/P05_gate.md`; prover notes `pv_work/notes/P05_prover_notes.md`; issue audit `verification/audits/P05_issue_1_audit.md`.
- My probe: `pv_work/probes/auditor/P05/aud_P05_final.lean`, `RESULT aud_P05_final mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/aud_P05_final_1.log`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P05 --module P05ModGaps`)

Report `verification/audits/P05_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P05ModGaps` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (8b6e88d0…) |
| 3 | PVTools hash | PASS |
| 4 | fingerprints of 12 gated decls vs gate snapshot | PASS (S1/S2/S3 th identical; 8 P05Stmt defs identical) |
| 4b | `P05_main_Gap` vh = gate th of `P05_main` (2049719506) | PASS |
| 6 | `#pv_axioms P05ModGaps` | ALL STANDARD |
| 7 | `#pv_walk`: sorryAx | not reached; axioms propext, Classical.choice, Quot.sound |
| 11 | traced conditions | none |
| 12 | last writers | prover (gap file), drafter (Stmt) |

## 2. Gap file checks (§2b)

| Check | Result |
|---|---|
| `example : P05_main_Gap = ∀ μ : Measure ℝ, P05Conclusion μ := rfl` | compiles |
| `example : P05_main_Gap → ∀ μ, P05Conclusion μ := P05_main_mod_gaps` (term, not reproof) | compiles |
| `diff pv_work/P05.lean pv_work/P05ModGaps.lean` | identical on lines 1-306 (S1, S2, S3 and all helpers); differs only at the stopped `P05_main` (sorry at the `F μ 0 = 0` spot) replaced by `P05_main_Gap` + `P05_main_mod_gaps` |
| gap-dependent obligations other than `P05_main` | none (S1-S3 do not use the gap) |
| truth of the gap | **false**: `P05_main_gap_false` in `pv_work/P05_Counterexample1.lean`, audited `COUNTEREXAMPLE VALID` (`P05_issue_1_audit.md`). So `P05_main_mod_gaps` is vacuous and supports nothing. |

## 3. Axioms and sorry

Mech items 6-7: standard axioms only, no `sorryAx`. Probe `#print axioms P05_S3`: [propext, Classical.choice, Quot.sound].

## 4. Per-theorem conditionality

| Theorem | Hypotheses | Finding |
|---|---|---|
| `P05_S1` | p, hp | both used |
| `P05_S2` | μ, x, hx | **`hx : 0 < x` UNUSED** (reconfirmed in probe, log line 7). Harmless: S2 holds for all x because `F μ (1/x) ∈ [0,1]`; the premise only weakens the statement. Can be removed; no effect on verdict. |
| `P05_S3` | μ | used |
| `P05_main_mod_gaps` | hGap_main, μ | used (the gap is the entire content) |

No external parameters exist; nothing to trace further. No positive-control walk needed.

## 5. Infrastructure

| Module | Constants reached | Covering record | Judgement |
|---|---|---|---|
| `L01Stmt` | `F` (= `ProbabilityTheory.cdf μ`) | `L01_gate.md` | definition, gate-approved |
| `L02Stmt` | `IsSuperHeavyTailed`, `SubadditiveOnE`, `negLogInv` | `L02_gate_r2.md` | definitions, gate-approved; literal Def 4.9(1) incl. `F_X(0)=0` (F:346) |
| `P05Stmt` | `Hcdf`, `InvSubLE`, `P05Conclusion`, `genInv`, `invSubFn`, `leftVer`, `recipE`, `recipE.match_1` | `P05_gate.md` | definitions, gate-approved (fingerprints identical) |

Only definitions are reached; no theorem from another module is consumed. Helpers not in the snapshot (item 9), reviewed one by one in the source file:

| Helper | Content | Judgement |
|---|---|---|
| `psi` | `-Log p` in EReal, `-Log 0 = ⊤` (same body as `negLogInv`) | notation |
| `genInv_zero`, `genInv_one` | ℋ^{-1}(0)=0, ℋ^{-1}(1)=+∞ (sup over ℝ, since ℋ<1) | endpoint conventions approved by gate item 4 |
| `genInv_mid` | ℋ^{-1}(p) = -1/log p on (0,1), via `{x : ℋ x ≤ p} = (-∞, -1/log p]` | exactly F:434 first half |
| `psi_eq` | `recipE (ℋ^{-1} p) = psi p` on [0,1] | F:434 second half, three cases |
| `F_mem`, `F_leftLim_mem` | cdf and its left limit in [0,1] | technical |
| `psi_nonneg`, `psi_anti`, `psi_cont` | `-Log` ≥ 0, antitone, continuous on [0,∞) into EReal | standard facts of log |
| `transfer` | abstract: monotone g, gm its right limit with g ≤ gm and g left-continuous ⇒ (gm subadditive ↔ g subadditive) | the filled-in S3 argument (see §6); proved, standard axioms; no paper statement smuggled in; not stronger than S3 needs |

None restates the target conclusion; none adds a mathematical claim beyond S1-S3 content.

## 6. Route fidelity

| Source | Lean | Judgement |
|---|---|---|
| F:434 "ℋ^{-1}(p) = -1/Log p" | `P05_S1` (`genInv_mid`) | faithful; generalised inverse per F:111 |
| F:434 "so 1/ℋ^{-1}(F_X(1/x)) = -Log F_X(1/x)" | `P05_S2` (`psi_eq` over F∈{0},(0,1),{1}) | faithful; endpoints by the `1/0=+∞`, `1/∞=0`, `-Log 0=+∞` conventions = **FAIR_IMPLICIT_STEP / EDITORIAL** (source states no conventions; only monotone continuous extension) |
| (unprinted) Def 5.1 F:424 uses `F_1^-`, proof F:434 uses `F_X` | `P05_S3` via `transfer` | **FAIR_IMPLICIT_STEP**: filled in by the one-sided-limit argument: g(x) = -Log F(1/x) is increasing and left-continuous (right-continuity of the cdf), gm(x) = -Log F^-(1/x) = g(x+) (`Monotone.tendsto_leftLim`, continuity of -Log on [0,∞)); subadditivity passes gm→g by approaching x+y from the left, and g→gm by taking right limits with EReal addition continuous off ⊤+⊥ (both values ≥ 0). F:428 ("avoiding the strict continuity difficulties") signals the authors' awareness. Not a paper gap: true for every μ, and no source step is contradicted. |
| "if" direction, conjunct `F_X(0)=0` | stopped (`P05_main`) | no source justification; refuted by δ₀ (issue 1, COUNTEREXAMPLE VALID) |

No route change; no stronger result used; no external results. The "only if" direction is **not a separately gated obligation**. For information only, my probe proves `aud_P05_onlyIf : IsSuperHeavyTailed μ → InvSubLE (F μ) Hcdf` and `aud_P05_ifSub : InvSubLE (F μ) Hcdf → SubadditiveOnE (negLogInv μ) (Ioi 0)` from the gated S2 and S3 alone (standard axioms; log lines 1-2). This shows that the source route covers exactly the "only if" direction and the subadditivity part of the "if" direction, i.e. the proposition holds for X with F_X(0)=0. It is not a gated verified clause.

## 7. Non-vacuity

S1-S3 have no hypotheses beyond ranges, so they are not vacuous. Instances compiled in the probe: S1 at p = 1/2; S2 at μ = dirac 1, x = 2; S3 at μ = gaussianReal 0 1 (nontrivial continuous law). All compile. `P05_main_mod_gaps` is vacuous (its gap is false, see §2).

## 8. Status for the authors

Verified (no conditions): the computation ℋ^{-1}(p) = -1/Log p and 1/ℋ^{-1}(F_X(1/x)) = -Log F_X(1/x) (F:434), and the unprinted F vs F^- bridge (filled in fairly), so "super-heavy-tailed ⇒ F_X ≤_{i-sb} ℋ" and "order ⇒ -Log F_X(1/x) subadditive" hold for every X.
Issue: the "if" direction as printed at F:431 is false (X ≡ 0: order holds, F_X(0)=1), PAPER_ASSUMPTION_GAP (alt. DOMAIN_CLARIFICATION); fix: add "such that F_X(0)=0" as at F:442. Editorial: proof writes F_X where Def 5.1 has F_X^-; 1/0, 1/∞ conventions unstated.

## FAIL items

None.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none

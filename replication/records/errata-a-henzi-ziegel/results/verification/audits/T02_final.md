# T02 (Theorem 3.2, `thm:grow`): final audit

- Auditor: pv-auditor (independent; did not draft, gate or prove T02). Date: Tue Oct 13 01:11:31 EDT 2026 (`date`).
- Audited object: `pv_work/T02ModGaps.lean` (gap file); `pv_work/T02.lean` compared with it.
- Read directly: `source/VSIFP_02.tex:90-106, 137-172, 395-463`; `pv_work/T02ModGaps.lean` (all), `pv_work/T02Stmt.lean`, `pv_work/T02Draft.lean`, `pv_work/T01Stmt.lean`, `pv_work/Defs.lean`; `verification/audits/T02_gate.md`, `DEFS_gate_r2.md` (verdict lines), `T01_gate.md` (verdict line), `T02_issue_1.md`; `pv_work/notes/T02_prover_notes.md`.
- Mechanical report: `verification/audits/T02_mech.md` (run by me: `python3 scripts/pv_audit_mech.py T02 --module T02ModGaps`), **MECH CHECKS: PASS** (2 manual items, done below).
- My probes: `pv_work/probes/auditor/T02/auditor_T02_gapcheck.lean` (exit=0, 7 sorry = verbatim gated copies only, log `pv_work/logs/auditor_T02_gapcheck_1.log`); `pv_work/probes/auditor/T02/auditor_T02_nonvac.lean` (exit=0, 0 sorry, log `pv_work/logs/auditor_T02_nonvac_2.log`).

## 1. Mechanical checks (from `T02_mech.md`)

| # | Check | Result |
|---|---|---|
| 1 | compile `T02ModGaps` | PASS (exit 0, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 / 4b | fingerprints of 29 gated declarations; gap `vh` = snapshot `th` (S3a, S3b, S8, S11, S15) | PASS |
| 5 | `Defs` vs DEFS_gate_r2 | PASS |
| 6–7 | `#pv_axioms` ALL STANDARD; `#pv_walk`: no `sorryAx`, axioms {propext, Classical.choice, Quot.sound} | PASS |
| 11 | traced conditions | none |
| 12 | last writers | prover / drafter, PASS |

## 2. Gap-file exact-statement check (§2b), done by me

| Item | Evidence | Result |
|---|---|---|
| Gated `T02` copied verbatim under original name | `th=4146251959` = gate snapshot | PASS |
| Gated `T02_S9` copied verbatim (as `T02_S9_gated`) | `th=429470870` = gate snapshot | PASS |
| S3a, S3b, S8, S11, S15 redeclared verbatim under original names | th 2448909884, 4046222703, 2498024117, 1679423657, 1769765856 = snapshot | PASS |
| `example : T02_Sk_Gap = type_of% @T02_Sk := rfl`, k ∈ {3a,3b,8,11,15} | compiles | PASS |
| `example (g8) (g15) : type_of% @T02 := T02_mod_gaps g8 g15` | compiles | PASS |
| `example (g8) : type_of% @T02_S9_gated := fun … => T02_S9 … g8` | compiles | PASS |
| `diff T02.lean T02ModGaps.lean` | differs only by: header comment, the 5 gap defs, removal of the 5 stopped `sorry` theorems, `hGap_S8` in S9, rename `T02`→`T02_mod_gaps` with gap premises | PASS |

## 3. Hypothesis usage / conditionality

| Theorem | Premise | Usage (`#pv_hyp_usage`) |
|---|---|---|
| `T02_S9` | `hT01 : T02_T01Consumed` | **UNUSED** |
| `T02_S9` | `hGap_S8` | USED |
| `T02_mod_gaps` | `hT01` | USED, but only passed to `T02_S9` (where UNUSED) and to `hGap_S15` (gap premise; proof term l.393/395) |
| proved obligations S1, S2, S4–S7, S10, S12–S14 | no `hT01` in signature | — |

So `T02_T01Consumed` is consumed only inside the S15 gap (the p > q case), never by a proved step. It is **not** a condition of any verified clause ("formal only" outside the gap). The mech-report warnings on binder counts (`Conclusion.*`, `T02_S9`) concern binders of the conclusion (`∀ lam`, `∀ y ∈ …`), not premises.

Note: `T02_S8_Gap` is refutable (gate `S8_false`, π₁ = 1), so `T02_mod_gaps` as a whole has a false premise; it certifies the assembly, not the grow_iff clause.

## 4. Infrastructure (item 8) and helpers (item 9)

Project constants reached are definitions only (no theorem of another module is consumed):

| Module | Constants | Record | Status |
|---|---|---|---|
| `Defs` | 13 defs (`EGrow, Erep, GrowFinite, HS, IsConsistent, IsEValue, IsGrowLambda, IsMixingMeasure, elemScore, expPi, growthRate, kappa, mixtureScore`) | `DEFS_gate_r2.md` names each (STATEMENT GATE: PASS) | covered individually |
| `T01Stmt` | `T01.MixtureRep` | `T01_gate.md` (PASS) | covered |
| `T02Stmt` | `Conclusion`, `Conclusion.mk`, `T02_T01Consumed`, `growLambda` | `T02_gate.md` (PASS) | covered |

Helpers not in the snapshot (read in full, audited here):

| Helper | Statement | True / non-vacuous | New mathematics? |
|---|---|---|---|
| `core` | from `MixtureRep`, 0<p<q<1, ν[p,q)>0: d(0) = −A, d(1) = N − A, 0<A<N, κ = A/N (A = ∫_{[p,q)}θ dν, N = ν[p,q)) | true (pN ≤ A ≤ qN, q<1); hypotheses satisfied at δ_{1/2} | no: expansion of eq:mixture (l.95) with eq:elementary (l.98-105); the computation behind l.407/l.435 |
| `core2` | `core` with min/max rewritten | true | no (min/max conversion) |
| `erep_lt` | p<q, d(0)<0 ⇒ E_{p,q;λ}(y) = 1 − λ d(y)/d(0) | true | no (l.421/431-434 rewriting, abs of negative) |
| `growLambda_eq` | p<q branch of `growLambda` = π₁ + (1−π₁)/h | true | no (notation, l.158 vs l.442) |

None contains the target conclusion. Axioms: covered by item 6/7 (ALL STANDARD, no sorryAx).

## 5. Route fidelity (sentence by sentence, case p < q)

| Source | Lean | Assessment |
|---|---|---|
| l.430 "All e-values … of the form (6)" | `hT01` carried, unused | Statement is about the family (6) itself; sentence is motivation. Fine. |
| l.431-434 g(λ) | S1 | faithful |
| l.435 d(0)<0<d(1) | S2 via `core` | `FAIR_IMPLICIT_STEP`: source gives no reason here; filled with the l.407 argument (mixture + ν[p,q)>0), computing d(0) = −A, d(1) = N−A |
| l.435 continuity, g(0)=0, lim = −∞, maximum in [0,1) | S3a, S3b **STOPPED** | false at π₁ = 1 (gate `S3a_false`, `S3b_false`); see issue 1 |
| l.435-439 h, g, g′ | S4 | faithful |
| l.440-443 g′(λ₀)=0 ⇔ λ₀ = … | S5 | faithful |
| l.444-447 π₁ ∉ H_S ⇔ … ⇔ λ₀ > 0 | S6 | faithful |
| l.448 λ₀ > 0 | S7 | faithful |
| silent: λ₀ < 1, λ₀ unique maximiser on [0,1) | S8 **STOPPED** | false at π₁ = 1 (`S8_false`); for π₁ < 1 a fair implicit step (not used as such: stopped as a whole) |
| passage [0,1) → family (0,1] (A09) | S9 from S8 gap, S7, S2, `erep_lt`, `growLambda_eq` | `FAIR_IMPLICIT_STEP`: λ = 1 excluded since E(0) = 0 and π₁ ≠ 1 (`GrowFinite` fails; paper value −∞); λ₀ ∈ (0,1) has E(0), E(1) > 0. No other route introduced. |
| l.449-453 E(0), E(1) | S10 | faithful |
| l.454 d(y) = ∫1{p≤θ<q}(θ−y)dν | S11 **STOPPED** | false (sign), gate `S11_false`; see issue 2 |
| l.455-457 (d(1)−d(0))/d(1) = 1/(1−κ) | S12 via `core` | **Recorded deviation**: proved from the correctly signed expansion d(0) = −A, d(1) = N−A (the same `core` computation as S2), not from the printed l.454. The printed l.456 chain is itself numerically correct (−N/(−N+A) = N/(N−A)); only l.454's integrand sign is wrong. No statement absent from the source is added (the step's conclusion is the printed l.456; the facts used are those already needed for l.435). Acceptable, but the e-value clause must be reported as "proved with the sign-corrected l.454". |
| l.459-460 1 − h = … = 1/κ | S13a via `core` | same recorded deviation as S12 |
| l.460 "> 1/π₁" | S13b via S6 + `core` | `FAIR_IMPLICIT_STEP` (π₁ ∉ H_S ⇔ π₁N > A); remark, not used by S14 |
| l.461-462 "which gives the desired result" | S14 (min/max = p/q) | faithful |
| l.462 "The case p > q is analogous" | S15 **STOPPED** | analogue of l.435 fails at π₁ = 0 (issue file `analogue_l462_fails`); no substitute route. |

No stronger result than the source was used; helpers are conversions.

## 6. Non-vacuity

`auditor_T02_nonvac.lean` (exit 0, 0 sorry): witness ν = δ_{1/2}, S = S_{1/2}, p = 1/4 < q = 3/4, **π₁ = 3/4** (interior alternative, H_S = [0,1/2]). Compiled: `T02_S14` (e-value clause) and `T02_S13b` instantiated there (axioms standard); `growLambda = 1/2`, `EGrow(0) = 1/2` computed; `T02_mod_gaps` instantiated at the witness with gap premises as variables. Instance lemmas reused from `T02_Counterexample1` (`#pv_axioms T02_Counterexample1`: ALL STANDARD).

## 7. What is verified / not verified

| Clause | Status |
|---|---|
| e-value clause (l.161-167), case p < q (S14) | proved, no parameters, no gaps (with S12/S13a via sign-corrected l.454) |
| grow_iff clause (l.154-160), case p < q (S9) | only modulo `T02_S8_Gap`, which is false at π₁ = 1 |
| both clauses, case p > q (S15) | gap; not proved |
| steps S1, S2, S4–S7, S10, S12, S13a, S13b | proved unconditionally |

Gaps: S3a, S3b, S8, S11, S15. Since gaps remain, the result cannot be UNCONDITIONAL or CONDITIONAL (VERDICTS §1.2).

## 8. Notes for the pending counterexample review of `T02_issue_1.md`

- The issue file says "the printed middle expression of l.456 is a false equation for the true d". I disagree: with the true d, (d(1)−d(0))/d(1) = N/(N−A), and the printed −ν/(−ν+∫θ) = −N/(−N+A) = N/(N−A); the printed l.456 chain is a true chain of real numbers. Only l.454 is wrong. This supports the EDITORIAL-level reading of issue 2 but does not change that S11 is false as printed.
- The issue confirmation (COUNTEREXAMPLE VALID) for issue 1 is still required before ISSUE can be recorded (VERDICTS §1.3); not done in this audit.

## Status for the authors

Verified in Lean (no parameters): for p < q, the GROW e-value formula E^{π₁}_{p,q} at the printed λ, and steps S1–S2, S4–S7, S10, S12–S13b. The "maximal iff λ = …" clause for p < q is proved only modulo the silent step S8, and the case p > q is not written in the source.
Source assessment: l.435 ("lim g = −∞, so max in [0,1)") fails at π₁ = 1 (mirror π₁ = 0 for p > q); the theorem's conclusion still holds there. l.454 has the wrong sign (θ − y should be y − θ), with no effect on l.456/l.460. l.462 "analogous" inherits the l.435 edge defect; l.456 stray `\}` is editorial.

FAIR_IMPLICIT_STEP: S2 (l.407 argument), S9 (λ = 1 excluded via E(0) = 0), S13b (π₁ > κ).
Not conditions: `T02_T01Consumed` (reached only through the S15 gap; UNUSED in S9).
FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE   (requires COUNTEREXAMPLE VALID on T02_issue_1, issue 1 (l.435); otherwise UNFINISHED at S3a/S3b/S8/S15)
CONDITIONS: none

# T01 final audit (Theorem 3.1, `thm:uniqueness`): gap file `pv_work/T01ModGaps.lean`

- Auditor: pv-auditor (independent; did not draft, gate, prove or rule on T01). Date: Mon Oct 12 22:44:51 EDT 2026 (`date`).
- Source read directly: `source/VSIFP_02.tex:144-149` (statement), `:402-427` (proof); definitions `:70-74` (eq:scoring), `:78` (e-value), `:93-106` (eq:mixture, eq:elementary), `:137-142` (H_S, e-value with null/alternative).
- Inputs read in full: `pv_work/T01ModGaps.lean`, `pv_work/T01.lean`, `pv_work/T01Stmt.lean`, `pv_work/Defs.lean`, `pv_work/T01Draft.lean` (S8, S10, main statements), `verification/audits/T01_gate.md`, `pv_work/notes/T01_prover_notes.md`, `verification/audits/T01_issue_1.md`; `verification/audits/T03_final.md` (infrastructure records).

## 1. Mechanical checks (run by me): `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps`

Report `verification/audits/T01_mech.md`: **MECH CHECKS: PASS** (1 manual check: renamed main theorem, done in §2).

| # | Check | Result |
|---|---|---|
| 1 | compile `T01ModGaps` | PASS, 0 errors, 0 sorry |
| 2 | private rebuild sha256 | PASS, IDENTICAL (6b937424…) |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs T01_gate (gated decls) | PASS |
| 4b | `T01_S8_Gap` vh = th(S8) = 4195242672; `T01_S10_Gap` vh = th(S10) = 2059191271 | PASS |
| 5 | Defs vs DEFS_gate_r2 | PASS |
| 6-7 | `#pv_axioms` / `#pv_walk`: ALL STANDARD, no sorryAx | PASS |
| 11 | TRACED CONDITIONS | none |

## 2. Gap file (VERIFICATION_METHODS §2b, original-name method)

Probe `pv_work/probes/auditor/T01/aud_T01_gapcheck.lean` (`scripts/pv_lean.sh probe …` exit=0, errors=0, 3 intended sorry; log `pv_work/logs/aud_T01_gapcheck_1.log`): redeclares `Paper.T01.T01`, `T01_S8`, `T01_S10` verbatim from `T01Draft.lean` under their original names.

| Check | Result |
|---|---|
| th(`T01`) = 1029269944 = snapshot | PASS |
| th(`T01_S8`) = 4195242672 = snapshot | PASS |
| th(`T01_S10`) = 2059191271 = snapshot | PASS |
| `example : T01_S8_Gap = type_of% @T01_S8 := rfl` | PASS |
| `example : T01_S10_Gap = type_of% @T01_S10 := rfl` | PASS |
| `example (g8) (g10) : type_of% @T01 := T01_mod_gaps g8 g10` | PASS |
| `pv_work/T01.lean` vs gap file | identical except: S8, S10 are `sorry` theorems there (Gap defs here) and the main theorem is `T01` calling them (here `T01_mod_gaps` with `hGap8`, `hGap10`); S1-S7, S9, helpers and proof text otherwise identical (read line by line). PASS |

Gap-dependent obligations: only the main theorem (S9 takes the S8 conclusion as a hypothesis, so it is not gap-dependent). Note: `T01_S8_Gap` is false (gate counterexample; `not_S8Gap` in issue file), so `T01_mod_gaps` is vacuous as a whole in its `hGap8` premise; it certifies only the assembly. This is inherent to a gap file and is why the result cannot be verified.

## 3. Axioms and sorry

`#pv_axioms T01ModGaps`: ALL STANDARD; walk: no `sorryAx`, closure axioms {propext, Classical.choice, Quot.sound}. PASS.

## 4. Per-theorem conditionality (`#pv_hyp_usage`, mech item 10)

| Theorem | Finding | Judgement |
|---|---|---|
| `T01_S1`, `T01_S3` | `hcons` UNUSED | Statement premise "S consistent" (l.145) is implied by `MixtureRep` (gate Item 1 noted redundant); not an external parameter; nothing to remove from the source statement. |
| `T01_S9` | `h0 : E 0 ∈ Ioo 0 1` UNUSED | Confirms prover note and issue ruling §6: the l.421 algebra does not need E(0) > 0. |
| `T01_S1`, `T01_S9` "binders" warning | the 2 extra binders are `∀ y ∈ {0,1}` of the conclusion | harmless |
| `T01_mod_gaps` | all 13 USED | no external parameters exist |

No external parameter (no `def … : Prop` tool); `CONDITIONS: none`. Gap premises `hGap8`, `hGap10` are not conditions (VERDICTS §1).

## 5. Infrastructure

Covered by individual PASS records in `T03_final.md`: `Paper.expPi`, `Paper.elemScore`, `Paper.IsEValue`. Audited here, one by one (all `def`s, no proofs, no axioms; none contains or implies the target conclusion):

| Constant | Source | Judgement |
|---|---|---|
| `Paper.IsConsistent` | l.71-74 | `∀ p, π ∈ [0,1], E_π S(π,Y) ≤ E_π S(p,Y)`; exact. PASS |
| `Paper.IsMixingMeasure` | l.97 | carried by (0,1) and finite on compact subsets of (0,1) = locally finite Borel measure on (0,1). PASS |
| `Paper.mixtureScore` | l.95 | `∫_{[0,1]} S_θ(p,y) dν`; Bochner integral, junk value excluded by the integrability clause of `MixtureRep` (TFA-1, approved at gate). PASS |
| `Paper.HS` | l.139 | `{π ∈ [0,1] : E_π{S(p,Y)-S(q,Y)} ≤ 0}`; exact. PASS |
| `Paper.Erep` | l.147 | `1 + λ(S(p,y)-S(q,y))/|S(p,1{p>q})-S(q,1{p>q})|`, `1{p>q}` as `if q < p then 1 else 0`. PASS |
| `Paper.T01.MixtureRep` | l.94-97, 145 | `IsMixingMeasure ν` ∧ for p ∈ (0,1), y ∈ {0,1}: integrability ∧ `S p y = mixtureScore ν p y`; "the mixing measure ν of S" as printed (weaker: only needed p, y). PASS |

Helpers (mech item 9; read in full):

| Helper | Content | Judgement |
|---|---|---|
| `cc` | `1{p>q}` as real | notation |
| `pos_int` | ∫ f dν|_[0,1] > 0 from f ≥ 0, f > 0 on [a,b), ν[a,b) > 0 (mathlib `integral_pos_iff_support_of_nonneg`) | technical |
| `key` | d(0) = -∫_[a,b) θ dν < 0 < ∫_[a,b)(1-θ) dν = d(1) from the elementary representation | the content of l.407 sentence "eq:mixture and ν[p,q) > 0 imply d(0) < 0 < d(1)"; source claim, filled in fairly |
| `dsign`, `cfacts` | sign case split p<q / p>q; p>q case is `key` on (q,p) | l.403 "analogous"; technical |
| `cmem`, `erep_eq` | y ∈ {0,1} is c or 1-c; remove `|·|` when d(c) < 0 | technical |

## 6. Route fidelity (sentence by sentence)

| Source | Lean | Fidelity |
|---|---|---|
| l.403 "E(y) ≥ E{1(p>q)} = 1-λ ≥ 0" | `T01_S1` (via `cfacts`) | faithful |
| l.403 "easily verify … null hypothesis" | `T01_S2`: E_π E = 1 + λ f(π)/|d(c)| | FAIR_IMPLICIT_STEP (the omitted computation, both null and alternative parts) |
| l.403 "p > q analogous" (for sufficiency) | `T01_S1/S2` handle both signs via `dsign` | FAIR_IMPLICIT_STEP (mirror sign via `key` on (q,p)) |
| l.405-407 f affine, sign of d, strictly increasing, zero π₀ ∈ (0,1) | `T01_S3` (`key`), `T01_S4` | faithful; S3 integral computation filled in = FAIR_IMPLICIT_STEP |
| l.407-409 eq:evalueCond | `T01_S5` (from `IsEValue` and complement) | faithful |
| l.411-414 "implies E_π E = 1 iff f = 0, which yields eq:ratio" | `T01_S6`: E(0) ≤ 1, E(1) > 1 at π = 0, 1; the zeros π₀ of f and π' of E_πE − 1 compared via the iff in both directions | FAIR_IMPLICIT_STEP (standard fill-in of "implies"; no stronger tool) |
| l.415-418 rearrangement | `T01_S7` | faithful (algebra) |
| l.419 "E(0) ∈ (0,1)" | **STOPPED** → `T01_S8_Gap` | false as printed (λ = 1 gives E(0) = 0); issue 1 |
| l.419-421 λ = 1 − E(0), E(y) = 1 + λ d(y)/|d(0)| | `T01_S9`, assembly in `T01_mod_gaps` | faithful |
| l.423-426 "similar arguments for p > q" | **STOPPED** → `T01_S10_Gap` | mirror inherits the l.419 defect (issue 1 §3) |
| (main) sufficiency direction | `T01_S2` + value transfer at y = 0, 1 | technical (IsEValue depends only on E 0, E 1) |

No route change; no stronger result used; no new mathematics in helpers.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/T01/aud_T01_nonvac.lean` (own witness; exit=0, 0 sorry, log `pv_work/logs/aud_T01_nonvac_2.log`, `#print axioms` = [propext, Classical.choice, Quot.sound]): ν = δ_{1/2}, S = mixtureScore ν (= S_{1/2}), p = 1/4, q = 3/4. Proved `IsConsistent S`, `MixtureRep S ν`, ν[min,max) > 0 (both orders p<q and p>q), the sign hypothesis `hd` of S4-S9 (via `T01_S3`), and a nontrivial e-value `Erep S 1/4 3/4 (1/2)` (λ = 1/2 interior) satisfying the left side of the iff. All main-theorem hypotheses are jointly satisfiable. PASS.

## 8. Status for the authors

Verified (standard axioms, no parameters): sufficiency of Theorem 3.1 (every E_{p,q;λ}, λ ∈ (0,1], is an e-value) and the necessity steps l.403-418, l.421 for p < q. Not verified: l.419 "E(0) ∈ (0,1)" is false for λ = 1 (E(0) = 0); correct range [0,1) (issue 1, PAPER_ARGUMENT_GAP, conclusion of the theorem unaffected), and the p > q case l.423 which mirrors it. ISSUE requires issue 1 to be confirmed by the pending counterexample review; otherwise the result is UNFINISHED.

## 9. Records

- New individual infrastructure PASS records (this audit): `Paper.IsConsistent`, `Paper.IsMixingMeasure`, `Paper.mixtureScore`, `Paper.HS`, `Paper.Erep`, `Paper.T01.MixtureRep`; helpers `cc`, `pos_int`, `key`, `dsign`, `cfacts`, `cmem`, `erep_eq` reviewed.
- Gap-free theorems individually PASS: `T01_S1`-`T01_S7`, `T01_S9`.
- Gaps: `T01_S8_Gap` (l.419), `T01_S10_Gap` (l.423-426), both attributed to T01 issue 1.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE   (only once T01 issue 1 receives COUNTEREXAMPLE VALID; until then UNFINISHED)
CONDITIONS: none

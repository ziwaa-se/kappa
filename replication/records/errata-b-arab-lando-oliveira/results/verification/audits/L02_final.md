# L02 final audit (Lemma 4.10, `lem:inv-NWU`, F:359-366; Def 4.9 F:344-353)

- Auditor: pv-auditor (independent subagent, Opus), final-audit mode, gap file.
- Date: Tue Oct 13 01:17:10 EDT 2026 (from `date`)
- Audited object: `pv_work/L02ModGaps.lean` (sha256 2301ae4c…352d64e); companion `pv_work/L02.lean` (sha256 58a7de3c…84736d4, 1 sorry, no olean).
- Gate snapshot: `verification/audits/L02_gate_r2.md` (STATEMENT GATE: PASS). DEFS: none.
- Issue record: `verification/audits/L02_issue_1.md`, `L02_issue_1_audit.md` (COUNTEREXAMPLE VALID: δ₀ refutes the "if" direction).
- Auditor probe: `pv_work/probes/auditor/L02/aud_L02_final.lean` (sha256 5ae86a269e1e…5e2685f), `RESULT aud_L02_final mode=probe exit=0 errors=0 sorry_warnings=1 nonstandard_axiom_lines=0 log=pv_work/logs/aud_L02_final_2.log` (the one sorry is the deliberate verbatim statement copy of `L02_main`, used only for the §2b type comparison).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L02 --module L02ModGaps`)

Report `verification/audits/L02_mech.md`, `MECH CHECKS: PASS (1 manual checks listed above)`.

| # | Check | Result |
|---|---|---|
| 1 | compile L02ModGaps | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs gate r2 (Stmt 4 defs, S1, S2, S3) | PASS, identical |
| 4b | gap definition | MANUAL → resolved in §2 below |
| 6/7 | `#pv_axioms`, `#pv_walk` | ALL STANDARD; sorryAx not reached |
| 8 | project constants | `Paper.L01.F` (L01Stmt, gate L01_gate.md), 4 L02Stmt defs (gate L02_gate_r2.md); no theorems consumed |
| 9 | helpers not in snapshot | private `F_nonneg` (reviewed §4) |
| 10 | hyp usage | S1, S3, mod_gaps: all used. S2: `IsProbabilityMeasure` and `hθ` UNUSED (see §5) |
| 11 | traced conditions | none |
| 12 | last writers | prover / drafter, as expected |

## 2. Gap file (§2b)

- 4b explained: `L02_main_Gap` is NOT a copy of the type of a step obligation; it is the missing conjunct of the main "if" direction (`∀ μ, InvNWUCond μ → F μ 0 = 0`). Its vh is therefore not expected to equal any snapshot th; the script's comparison with `L02_main` is not applicable. Its content is exactly the step the source does not justify (F:361-364 vs F:346), and it is false (δ₀; the confirmed counterexample).
- Reconnection, in probe: verbatim copy of `L02_main` (text identical to L02.lean:101-102 and to the gate r2 text), then
  `example : (L02_main_Gap → type_of% @L02_main) = type_of% @L02_main_mod_gaps := rfl` — compiles.
- Gap-dependent obligations: none. S1, S2, S3 do not take `hGap` (their types checked; S3 by `rfl` in the probe).
- `L02.lean` vs `L02ModGaps.lean`: identical text for `F_nonneg`, S1, S2, S3 and the forward direction; the only difference is the stopped `F μ 0 = 0` conjunct (`sorry` in L02.lean:109-112, `hGap μ h` in ModGaps) and the gap def/theorem name. Confirmed by reading both files in full.
- Since `L02_main_Gap` is false, `L02_main_mod_gaps` is vacuous; it supports no verified verdict (as the issue audit already notes).

## 3. Axioms / sorry

`#pv_axioms L02ModGaps`: ALL STANDARD; `#print axioms L02_main_mod_gaps` and of the witness `ν_SHT` (probe): `[propext, Classical.choice, Quot.sound]`. No sorryAx in the closure.

## 4. Infrastructure

| Constant | Record | Judgement |
|---|---|---|
| `Paper.L01.F` | L01_gate.md (gated def) | `ProbabilityTheory.cdf μ x`, faithful |
| `negLogInv`, `SubadditiveOnE`, `IsSuperHeavyTailed`, `InvNWUCond` | L02_gate_r2.md (gated defs) | faithful per gate; EReal `+∞` for `-log 0` (source convention, avoids junk `log 0 = 0`) |
| private `F_nonneg` | audited here | `cdf_nonneg`, technical, standard axioms |

No in-project theorem is consumed; no external parameter.

## 5. Per-theorem conditionality

- No external parameters anywhere; TRACED CONDITIONS: none confirmed.
- `L02_S2` has two unused binders: `[IsProbabilityMeasure μ]` and `hθ` (at x = 0 the goal is `F 0 * F 0 ≤ F 0`, which with `F 0 = 0` is trivial). `hθ` mirrors the printed quantifier `θ∈(0,1)`, the instance is a type-class convention; harmless, not conditions. (Note for the authors: S2 does not actually need F_X(0)=0 either, since F_X(0)² ≤ F_X(0) always; Lean uses `h.1` anyway, no effect.)

## 6. Route fidelity

The source prints no proof ("The following characterisation is straightforward", F:358); the hint is F:356 (super-heavy-tailed ⇔ 1/X NWU, continuous case). The Lean route is the direct substitution argument, which is the evident reading of "straightforward"; no stronger result is used.

| Step | Lean | Classification |
|---|---|---|
| S1 (only if, x>0) | subadditivity at (θ/x, (1-θ)/x), `1/(θ/x)=x/θ` etc., exponentiate; zero-value cases via EReal `⊤` | FAIR_IMPLICIT_STEP (substitution + log/exp; zero case uses −log 0 = +∞) |
| S2 (only if, x=0) | `F 0 = 0` from Def 4.9 | FAIR_IMPLICIT_STEP |
| S3 (if, subadditivity part) | x' = 1/(x+y), θ = x/(x+y) in eq:inv-NWU, take −log; zero cases give `⊤` on the right | FAIR_IMPLICIT_STEP |
| if, conjunct F_X(0)=0 | not derivable; STOPPED | gap = issue L02_issue_1 (confirmed, COUNTEREXAMPLE VALID) |

Domain reading "x>0" for subadditivity of `-Log F(1/x)` was gate-approved. No proof repair, no route change.

## 7. Non-vacuity

Probe `aud_L02_final.lean`: nontrivial law ν with cdf F(x) = x⁺/(1+x⁺) (the law of Y = Z−1, F:337), built as `StieltjesFunction.measure`, `IsProbabilityMeasure`; proved `F ν 0 = 0`, `InvNWUCond ν`, hence `IsSuperHeavyTailed ν` (via S3), and applied S1 and S2 to it. S3's hypothesis is also met by δ₀ (counterexample file). All compile with standard axioms. So S1-S3 and the "only if" direction are non-vacuous.

## 8. Status for the authors

Verified (Lean, no external parameters): the "only if" direction of Lemma 4.10 (S1, S2) and the implication eq:inv-NWU ⇒ subadditivity of −Log F_X(1/x) (S3). Not verified: the "if" direction, which fails as printed because eq:inv-NWU does not force F_X(0)=0 (δ₀; confirmed issue L02_issue_1, PAPER_ASSUMPTION_GAP / DOMAIN_CLARIFICATION: add "such that F_X(0)=0" at F:361, or drop it from Def 4.9).

## Summary

No FAIL items. Everything except the recorded gap checks out. The gap is a confirmed paper-side issue in this result, so the verdict is ISSUE.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none

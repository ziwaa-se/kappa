# P03 final audit (Proposition 3.3, prop:mean-fsub)

- Auditor: pv-auditor (independent, Opus), Tue Oct 13 01:51 EDT 2026 (from `date`)
- Audited object: `pv_work/P03.lean` (no gaps remain; `P03ModGaps.lean` superseded, not audited)
- Hashes (`pv_snapshot.py hash`): `P03.lean` 93633446ea8d…1d79b43; `P03.olean` ca7f27a59652…a19ba621 (= rebuilt); `P03Stmt.lean` a35ef3be4b2a…2d6 (= gate)
- Source read directly: `source/SuperParetoPaper-v12.tex` :95-125 (eq:main-st, Def 2.1, Def 2.2), :128-135 (L01), :186-189 (Thm 3.1), :261-273 (Prop 3.2, its proof, the sentence :269, Prop 3.3)
- Also read: gate `P03_gate.md`, prover notes, ruling `P03_issue_1.md`, `P03Stmt.lean`, `T02Stmt.lean`, `P02Stmt.lean`, `L01Stmt.lean`, verdict lines of `T02_final.md`, `P02_final.md`

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P03`)

Report `verification/audits/P03_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P03` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints of 10 gated declarations vs gate | all identical |
| 6 | `#pv_axioms P03` | ALL STANDARD |
| 7 | `#pv_walk P03` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` gated theorems | no UNUSED hypothesis |
| 11 | traced conditions | T02_L01Consumed (only registered id; see §4) |

## 2. Gap files

None: S2 was filled per ruling P03_issue_1; `P03.lean` has 0 sorry. Not applicable.

## 3. Axioms / sorry

Standard only (mech items 6-7). My probe `pv_work/probes/auditor/P03/auditor_P03_nonvac.lean` (log `pv_work/logs/auditor_P03_nonvac_2.log`, exit=0, 0 sorry): `#pv_walk_decl P03_S2` and `P03_S3` standard, sorryAx false.

## 4. Per-theorem conditionality (`#pv_hyp_usage`, probe log lines 22-53)

| Parameter | Used where (step / clause) | How |
|---|---|---|
| `P03_T02Consumed` (p, T02 = Thm 3.1 at n=2, θ=(1/2,1/2)) | S4 (`P03.lean:189`), hence S6, main | applied to the S1 copies; gives `X ≤st ½X₁+½X₂` |
| `T02_L01Consumed` (p, L01 "only if", via T02) | S4 only, as the antecedent of `P03_T02Consumed` (`hT02 hL01`, :189) | discharges T02's own condition; not used anywhere else in P03 |
| `P03_P02Consumed` (p, P02 = Prop 3.2 at n=2, θ=(1/2,1/2)) | S6 (`P03.lean:204`), hence main | gives infinite mean on the product space |

All three USED in S6 and `P03_main`; S2 walk (log :54-67) reaches only L01Stmt definitions and P03 helpers, so the S2 fill-in uses **no** external parameter (only Def 2.2 through `IsInvSub`). Mech item 11 lists only `T02_L01Consumed` because `P03_T02Consumed` and `P03_P02Consumed` are not registered in `EXTERNAL_TOOLS.md` (`pv_status.py tools` shows only T01_X02Tool, T01_L01Consumed, T02_L01Consumed). They are real conditions (gate §6 approved them as (p) parameters) and must be registered.

**Predecessor status.** T02 and P02 are ISSUE, so the consumed clauses are not closed by the source:
- `P03_T02Consumed`: T02's final audit verifies the n=2 case (S1-S4) conditional on `T02_L01Consumed`, but T02_main as a whole is not verified (S10b, PAPER_ARGUMENT_GAP). The clause is located at T02_main, so it stays open.
- `P03_P02Consumed`: P02's final audit verifies the n=2 argument only for nonnegative X; the clause here has no nonnegativity premise (signed X, P02_issue_2 PAPER_ARGUMENT_GAP; reduction to n=2, P02_issue_1_r2 DOMAIN_CLARIFICATION). It stays open.
- Observation for the coordinator (not evidence, no change made): S3 proves X>0 a.s. for every InvSub X, so P03 itself would be satisfied by a weaker clause with a nonnegativity premise. Whether that would match P02's verified part is a reconnection question, not decided here.

## 5. Infrastructure (item 8 and item 9)

| Constant(s) | Module | Record | Judgement |
|---|---|---|---|
| `L01.F`, `IsInvSub`, `SubCond`, `SubadditiveOn`, `invDist` | L01Stmt | `L01_gate.md` snapshot lines 92-96 (each named) | covered |
| `P02.InfiniteMean`, `P02.StDom` | P02Stmt | `P02_gate_r2.md` :32-33 | covered |
| `T02.IIDCopies` (+ fields, mk), `T02.StDom`, `T02_L01Consumed` | T02Stmt | `T02_gate_r2.md` :34-46 | covered |
| `P03_T02Consumed`, `P03_P02Consumed`, `P03_T02Consumed._proof_1` | P03Stmt | `P03_gate.md` (defs fingerprinted; `_proof_1` is the compiler's auxiliary proof inside the def body, covered by its vh) | covered |
| `law_fst`, `law_snd` (private) | P03 | audited here | true; push-forward of `μ⊗μ` by a coordinate is `μ` (probability). Technical conversion. |
| `halve` (private) | P03 | audited here | Def 2.2 (:124) at y=y'=1/x: `1-F(x/2) ≤ 2(1-F(x))`. Direct instance of the definition; no smuggling. |
| `exists_mid` (private) | P03 | audited here | ∃x, 0<F(x)<1 for InvSub laws. **New mathematical statement not in the source**, admitted only as the FAIR_IMPLICIT_STEP fill-in of S2 (§6). Proof: iterate `halve` from x0 with F(x0)>½, contradict right-continuity at 0 with F(0)=0. Correct; uses only Def 2.2 and mathlib cdf facts. Does not mention the target conclusion. |

All four helpers: standard axioms (walk of S2, log :54-67; whole-module walk mech item 7).

## 6. Route fidelity

Source :269: "As a consequence of Theorem 3.1 and Proposition 3.2, the following result is immediate." No other text.

| Lean step | Source | Judgement |
|---|---|---|
| S1 i.i.d. copies as coordinates of `μ⊗μ` | silent | FAIR_IMPLICIT_STEP (standard product construction) |
| S2 `P(X₁=X₂)<1` | silent; Prop 3.2 hypothesis :263 | FAIR_IMPLICIT_STEP, filled by `halve`/`exists_mid` + disjoint-rectangle bound (ruling P03_issue_1 §6) |
| S3 X>0 a.s. | from F(0)=0, Def 2.2 :124 | true; not consumed by main (documents the reading of "infinite mean") |
| S4 dominance | "consequence of Theorem 3.1" | instance n=2, θ=½ of the cited theorem; not stronger |
| S5 `T02.StDom ↔ P02.StDom` | Def 2.1 :117 | `Iff.rfl`, encoding only |
| S6 infinite mean on `Ω×Ω` | "and Proposition 3.2" | instance n=2, θ=½; θᵢ>0 satisfied |
| S7 transfer to `μ` | silent | FAIR_IMPLICIT_STEP (integrability depends only on the law, `IdentDistrib.integrable_iff`) |

Route not changed; no stronger result than the source's citations; choice n=2, θ=½ is a faithful common instance (gate §6). Scope: real-valued X only (Ex. 2.7's mass at +∞ excluded; recorded encoding choice INVENTORY X14, conclusion trivial there).

### Review of ruling P03_issue_1 (FAIR_IMPLICIT_STEP) — CONFIRMED

- The needed fact is true for every InvSub X: a point mass at c (c>0 forced by F(0)=0) gives v(y)=1-F(1/y)=𝟙{y>1/c}, which violates v(2y) ≤ 2v(y) at y=1/c (v(2/c)=1, v(1/c)=0). I checked this myself against Def 2.2 :124. For i.i.d. copies, non-degeneracy gives P(X₁=X₂)<1 (the Lean proof uses P(X₁≤x<X₂)=F(x)(1-F(x))>0).
- Classification: the hypothesis of the cited Prop 3.2 is not stated as verified, but it follows from the printed hypothesis of Prop 3.3 by a one-point check of the definition. No hypothesis is missing (not PAPER_ASSUMPTION_GAP); no case of the statement is uncovered (not EXPOSITION_GAP); the indicated route is correct (not PAPER_ARGUMENT_GAP). FAIR_IMPLICIT_STEP is acceptable. An EXPOSITION_GAP reading would be defensible but is not required, and I see no ground to overrule.
- The Lean fill-in is longer than the one-line argument (it proves "∃x, 0<F(x)<1" through right-continuity) because "not a.s. constant ⇔ ∃x, 0<F(x)<1" is itself a standard step. It uses Def 2.2 directly and no paper result or external parameter (S2 walk). Its suggested editorial sentence (§7) is correct and sufficient.
- Scope: affects only S2; downstream none (INVENTORY lists no consumer of P03).

## 7. Non-vacuity

Probe `pv_work/probes/auditor/P03/auditor_P03_nonvac.lean` (exit=0, 0 sorry, standard axioms):
- nontrivial witness: Pareto(1) law built as `StieltjesFunction` with F(x)=1-1/max(x,1); `pareto_invSub : IsInvSub P.measure` proved (v(t)=min(t,1), subadditive);
- `P03_main hL01 hT02 hP02 P.measure id …` instantiated (conditions as parameters);
- `P03_S2` instantiated at the witness with no conditions.
The hypotheses of P03 are satisfiable by a non-degenerate law.

## 8. Status for the authors

Verified: Prop 3.3 along the printed route (Thm 3.1 + Prop 3.2 at n=2, θ=½), with S1, S2, S7 as fair implicit steps; standard axioms.
Depends on: Thm 3.1 at n=2 (with L01 "only if") and Prop 3.2 at n=2 for real X; both predecessors are ISSUE, so these clauses are not closed by the source.
Source assessment: no new paper-side issue in P03; the non-degeneracy check for Prop 3.2's hypothesis is omitted but routine (optional editorial sentence, P03_issue_1 §7).

## 9. Records to update

- Register `P03_T02Consumed` (pv_work/P03Stmt.lean:17, p from T02, used S4) and `P03_P02Consumed` (pv_work/P03Stmt.lean:32, p from P02, used S6) in `EXTERNAL_TOOLS.md`; then mech item 11 will trace them.
- Record P03_issue_1 as reviewed: CONFIRMED (FAIR_IMPLICIT_STEP).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: P03_T02Consumed, P03_P02Consumed, T02_L01Consumed

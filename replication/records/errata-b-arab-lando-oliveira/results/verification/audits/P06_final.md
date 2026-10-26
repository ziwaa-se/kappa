# P06 final audit (Proposition 5.3, `cor:fsub`, source F:440-446)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Tue Oct 13 02:20:55 EDT 2026
- Audited object: `pv_work/P06.lean` (no gap file; defs = NONE beyond `pv_work/P06Stmt.lean`)
- Read directly: source F:108-125 (conventions, F:111 generalised inverse and subadditivity, F:113 `F^-`, F:121 inverted distribution, Def 2.2 at F:124), F:279 (Pareto cdf), F:419-450 (Def 5.1 at F:422-425, Prop 5.2, Prop 5.3 and proof); `pv_work/P06.lean` and `pv_work/P06Stmt.lean` in full; gate report `verification/audits/P06_gate.md`; prover notes `pv_work/notes/P06_prover_notes.md`.

## 1. Mechanical checks (run by me): `python3 scripts/pv_audit_mech.py P06`

Report `verification/audits/P06_mech.md`, **MECH CHECKS: PASS**.

| Item | Result |
|---|---|
| 1 compile `P06` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 private rebuild sha256 | PASS, IDENTICAL |
| 3 PVTools hash | PASS |
| 4 fingerprints vs gate snapshot (13 gated decls) | PASS, all th/vh/bi identical |
| 6 `#pv_axioms P06` | PASS, ALL STANDARD |
| 7 `#pv_walk P06` | PASS, no `sorryAx`; axioms propext, Classical.choice, Quot.sound |
| 11 traced conditions | none |
| 12 last writers | prover (P06.lean), drafter (P06Stmt.lean) |

## 2. Gap files
None (all obligations proved). Not applicable.

## 3. Axioms / sorry
Items 6-7: only the three standard axioms; no `sorryAx` in the closure.

## 4. Per-theorem conditionality (`#pv_hyp_usage`, item 10)

| Theorem | UNUSED | Assessment |
|---|---|---|
| `P06_S1`, `P06_S1'`, `P06_S2`, `P06_main` | none | all hypotheses used |
| `P06_S3` | `[IsProbabilityMeasure μ]` | harmless: S3 needs only monotonicity and right continuity of `cdf μ`, which mathlib supplies for any measure (`StieltjesFunction`). Not an external parameter. |
| `P06_S4` | `[IsProbabilityMeasure μ]` | harmless; S4 is definitional unfolding. |

`h0 : cdf μ 0 = 0` in `P06_main` is used via `P06_S4` (S4's `h0` is reported USED, it supplies the first conjunct of `IsInvSub`). No external `def … : Prop` parameters exist. **Conditions: none.**

## 5. Infrastructure

Item 8: the only project module reached is `P06Stmt` (7 constants: `IsInvSub`, `SubadditiveOn`, `genInv`, `isbOrder`, `paretoCdf`, `recipE`, `recipE.match_1`). These are definitions (no theorems), each reviewed individually in the gate report item 4 against F:111, F:113, F:121/124, F:279, F:424; I re-read each against the source and agree (`recipE.match_1` is the compiler-generated matcher for `recipE`). No consumed theorem from another result.

Item 9 helpers (all `private`, in `P06.lean`), reviewed one by one:

| Helper | Statement | True / non-vacuous / smuggling? | Role |
|---|---|---|---|
| `pareto_greatest` | `0≤p<1 → IsGreatest {x | 𝒫 x ≤ p} (1/(1-p))` | true (elementary algebra); no smuggling | technical: the computation of `𝒫⁻¹(p)` printed at F:445 |
| `leftLim_mem` | `0 ≤ leftLim (cdf μ) t ≤ 1` | true (monotone, bounded cdf) | technical: range condition to apply S1' |
| `approx_left` | for monotone `F`, `z>0`, `ε>0`, some `t∈(0,1/z)` with `leftLim F (1/z) - ε < F t` | true (definition of left limit) | technical, used by `s3_ab` |
| `s3_ab` | subadditivity of `1-F(1/·)` on `(0,∞)` ⇒ that of `1-F⁻(1/·)` (F monotone) | true; proof by approximating `F⁻(1/x)`, `F⁻(1/y)` from inside with `t1,t2` and monotonicity | part of S3 fill-in |
| `s3_ba` | converse, F monotone and right-continuous | true; I checked the arithmetic by hand: with `s>1/(x+y)` close (right continuity), `λ∈(u/(x+y),1)`, apply hypothesis at `(λx,λy)`, use `F⁻(1/(λ(x+y))) ≤ F(s)` and `F(1/x) ≤ F⁻(1/(λx))` | part of S3 fill-in |

None of them mentions InvSub, `isbOrder` or the Pareto benchmark except `pareto_greatest` (which is the printed quantile formula). No helper contains the target conclusion.

## 6. Route fidelity (sentence by sentence, F:445)

Source proof: "As 𝒫⁻¹(p)=1/(1-p), we are reduced to verifying the subadditivity of 1-F_X(1/x)."

| Source piece | Lean | Classification |
|---|---|---|
| "𝒫⁻¹(p) = 1/(1-p)" | `P06_S1` (p ∈ [0,1)) via `pareto_greatest`, `IsGreatest.csSup_eq` | faithful |
| same formula at p = 1 (reached when `F⁻(1/x)=1`) | `P06_S1'`: `𝒫⁻¹(1)=⊤`, `recipE ⊤ = 0 = 1-1` | FAIR_IMPLICIT_STEP: the edge value `1/𝒫⁻¹(1) = 1/∞ = 0` is the natural reading of the printed formula; filled by showing the sup over ℝ is `⊤` (`EReal.lt_iff_exists_real_btwn`, `le_sSup`) |
| "we are reduced to": Def 5.1 function equals `1-F_X^-(1/x)` | `P06_S2` (unfold Def 5.1, S1', `EReal` coercion) | faithful conversion |
| silent replacement of `F_X^-(1/x)` (Def 5.1, F:424) by `F_X(1/x)` | `P06_S3` (equivalence of the two subadditivity conditions on (0,∞)) | **FAIR_IMPLICIT_STEP** (see below) + EDITORIAL note |
| "subadditivity of 1-F_X(1/x)" = InvSub (Def 2.2, F:121/124, with hypothesis `F_X(0)=0` of F:442) | `P06_S4` | faithful (definitional) |
| assembly | `P06_main` by `rw [S4, S2, S3]` | faithful |

Route not changed; no stronger result than the source's quantile computation is used.

**S3 ruling (requested).** The source literally computes `1/𝒫⁻¹(F_X^-(1/x)) = 1 - F_X^-(1/x)` but then writes `F_X` without comment. In terms of `g(x)=1-F_X(1/x)=P(X>1/x)` and `g⁻(x)=1-F_X^-(1/x)=P(X≥1/x)`, `g⁻` is the right-limit regularisation of the increasing function `g` and `g` the left-limit regularisation of `g⁻`; subadditivity on the open half-line passes to one-sided limits. This is a standard real-analysis fact, needs no extra hypothesis (it holds even without `F_X(0)=0`), and the paper's own convention (F:121, "inverted distribution" `F_{1/X}^- = 1 - F_X(1/·)`) already identifies the two inverted functions modulo this regularisation. The ~90-line Lean argument (`approx_left`, `s3_ab`, `s3_ba`) only implements this ε-approximation; it introduces no new mathematical idea relative to the source's claim. I classify it as **FAIR_IMPLICIT_STEP**, consistent with the precedent in `verification/audits/P04_final.md` (larger quantile-duality fill-in classified the same way). It is not a technical notation conversion (it is a genuine limit argument), so it is listed here explicitly. EDITORIAL note for the authors: the proof should say "`1-F_X^-(1/x)`, equivalently (by one-sided limits) `1-F_X(1/x)`", particularly since F:428 advertises avoidance of "continuity difficulties". If the coordinator prefers an independent classification (the gate suggested dispatching `pv-issue-checker`), a ruling of EXPOSITION_GAP would change the suggested verdict to ISSUE; the mathematics is proved either way and the printed conclusion is true.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/P06/auditor_P06_nonvac.lean` (`scripts/pv_lean.sh probe`: exit=0, errors=0, sorry=0, nonstandard axioms 0, log `pv_work/logs/auditor_P06_nonvac_1.log`):
- witness `μ = δ₁` (`IsProbabilityMeasure` by instance), `cdf δ₁ 0 = 0` proved (`w_h0`);
- nontrivial content: `¬ IsInvSub δ₁` (x = y = 3/4) and hence, via `P06_main`, `¬ isbOrder (cdf δ₁) paretoCdf`;
- generic instantiation of `P06_main` elaborates.

## 8. Status for the authors

Verified: Prop 5.3 (F:440-443) in full along the printed route, with no external inputs; only standard axioms.
Depends on: nothing outside the proof file and its statement definitions.
Source: no error; two unstated fair steps at F:445 (value at p=1 of `1/𝒫⁻¹`; passage from `F_X^-` in Def 5.1 to `F_X`), the latter worth an editorial sentence.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

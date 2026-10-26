# Final audit — P01 (Proposition 2.5, `prop:ITS-dens`)

Auditor: pv-auditor, 2026-10-12 22:26. Audited object: `pv_work/P01.lean` (no gap file, no DEFS).
Source read directly: `source/SuperParetoPaper-v12.tex:111-125` (conventions, Def. 2.1, 2.2), `:147-154` (statement and proof).
Gate snapshot: `verification/audits/P01_gate_r2.md` (doubts D1-D5 and N1-N2 from `P01_gate.md`).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P01`)

Report `verification/audits/P01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P01` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | 16 gated fingerprints vs gate r2 | all identical |
| 6 | `#pv_axioms P01` | ALL STANDARD |
| 7 | `#pv_walk P01` | no `sorryAx`; axioms propext, Classical.choice, Quot.sound |
| 8 | project constants | only `P01Stmt` (8 defs, covered by the gate) |
| 10 | hyp usage | all main-theorem hypotheses USED; only `[IsProbabilityMeasure μ]` unused in S6, S7 (gate N2, harmless) |
| 11 | traced conditions | none |

Additional probe (mine), `pv_work/probes/auditor/P01/auditor_P01_nonvac.lean` (log `pv_work/logs/auditor_P01_nonvac_2.log`, exit 0):
`#pv_walk_decl Paper.P01.P01_main` reaches S1, S2, S5, S6, S7 and helpers `Fbar_eq, ae_haz, ae_haz_ennreal, hpt_id, tonelli_id, key`; **it does not reach `P01_S3` or `P01_S4`** (see §4). `#pv_hyp_usage P01_main`: all 7 binders USED.

## 2. External parameters / conditions

None. No `def … : Prop` tool hypothesis is present; the main theorem's hypotheses are exactly the printed ones (law with no mass on `(-∞,0)`, density `f`, hazard bound for `x>0`).

## 3. Infrastructure / helper audit (item 9; none had a prior record)

| Helper | Statement | True / non-vacuous | Role | Judgement |
|---|---|---|---|---|
| `Fbar_eq` | `Fbar μ t = (μ (Ioi t)).toReal` | yes | notation conversion | PASS (technical) |
| `ae_haz` | a.e. `y>0 → y f(y) ≤ Fbar(y)` | yes | the sign claim of `:153` written in the variable `y = 1/x`; `Fbar=0` case by S2 + local max of `F` (gate D2) | PASS (source content, :153) |
| `hpt_id` | pointwise ENNReal identity `a·1_{t>a} + λ((a,b]∩(-∞,t)) = b·1_{t>b} + 1_{(a,b]}(t)·t` | yes (checked case by case) | layer-cake identity for `φ(y)=y Fbar(y)` | PASS (technical) |
| `tonelli_id` | `∫ λ((a,b]∩(-∞,t)) dμ(t) = ∫_{(a,b]} μ(t,∞) dy` | yes (Fubini on `{y∈(a,b], y<t}`) | technical | PASS |
| `ae_haz_ennreal` | ENNReal form of `ae_haz` | yes | conversion (uses `f<∞` a.e.) | PASS (technical) |
| `key` | `0<a<b → a Fbar(a) ≤ b Fbar(b)` | yes | integrated (FTC) form of "derivative sign ⇒ monotone" | PASS, see §4 |

None states the target conclusion or an equivalent; `key` is monotonicity of `y Fbar(y)`, which is the intermediate claim of `:153` ("anti-star-shaped"), derived, not assumed. All are in module `P01`, covered by `#pv_axioms`/`#pv_walk` above.

## 4. Route fidelity (sentence by sentence, `:153`)

| Source | Lean | Ruling |
|---|---|---|
| (implicit) `F_X(0)=0` required by Def. 2.2 `:124` | S1 | FAIR_IMPLICIT_STEP (D5): nonnegativity + no atom |
| "the derivative of `(1/x)(1-F(1/x))`" | S2 (`F' = f` a.e.), S3 (chain rule formula) | FAIR_IMPLICIT_STEP (D1, first half) |
| "has the same sign as `(1/x)f(1/x)+F(1/x)-1`, … negative" | S4 / `ae_haz` (`≤ 0` a.e.) | "negative" for `≤ 0`: EDITORIAL (D3); `Fbar=0` case: FAIR_IMPLICIT_STEP (D2) |
| "It follows that … anti-star-shaped" | S5 via `key` | FAIR_IMPLICIT_STEP (D1, second half), see ruling below |
| "as it vanishes at zero" | S6 (`vExt 0 = 0` by representation) | FAIR_IMPLICIT_STEP (D4); the limit is not needed for subadditivity on `(0,∞)` (gate N1) |
| "therefore, it is subadditive" | S7 (in place, elementary) | faithful; standard fact the paper invokes at `:147` |

**Ruling on S5 (requested).** With `y = 1/x`, the paper's function is `g(x) = φ(1/x)`, `φ(y) = y Fbar(y)`, and the paper's sign expression equals `y f(y) - Fbar(y)`. The paper needs: this expression is `≤ 0` ⇒ `g` non-increasing. Lean proves `φ(b) - φ(a) = ∫_{(a,b]} (Fbar(y) - y f(y)) dy ≥ 0` (via `hpt_id`, `tonelli_id`, `withDensity`), using exactly the same pointwise inequality `y f(y) ≤ Fbar(y)` (`ae_haz`, the content of S4). This is the fundamental theorem of calculus for the absolutely continuous function `φ`, i.e. the standard justification of the paper's unwritten inference "a.e. derivative sign ⇒ monotone". Same function, same inequality, same conclusion, no stronger result and no extra hypothesis: **a faithful rendering, not a different route**; classified FAIR_IMPLICIT_STEP. Evidence for the prover's claim about mathlib: a search of the linked mathlib for `AbsolutelyContinuousOnInterval` finds nothing; the FTC results in `Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean` require the derivative off a countable set, not a.e. (search evidence, not `#check`).

Consequence noted for the record: gated obligations S3 and S4 are proved but **not consumed** by `P01_main` (walk above); S5 consumes S2 through `ae_haz`, which is S4's inequality before the change of variable `y=1/x`. S5's docstring "Uses: S2, S3, S4" is therefore inaccurate (doc erratum, not a proof issue; file not modified by me).

**EXPOSITION_GAP?** No. The paper writes "the derivative" of a function that is only a.e. differentiable and passes from a.e. sign to monotonicity. Without absolute continuity that inference would fail (Cantor-type functions), but the printed hypothesis "has density `f_X`" gives absolute continuity, so the step is filled from printed hypotheses by textbook measure theory; no range or case is left uncovered. FAIR_IMPLICIT_STEP; at most a remark to the authors that "derivative" is meant a.e.

## 5. Non-vacuity

`pv_work/probes/auditor/P01/auditor_P01_nonvac.lean` (exit 0): Pareto(1) law `μP = volume.withDensity fP`, `fP(t) = 1_{t>1} t^{-2}`; proved `IsProbabilityMeasure μP`, `μP(Iio 0)=0`, measurability, and the hazard bound (with equality `r(x) = 1/x` for `x>1`, nontrivial). `P01_main μP hnnP fP fP_meas rfl hhazP : InvSub μP` compiles; also `F μP 2 = 1/2` (non-degenerate law).

## 6. Status for the authors

Prop. 2.5 is verified unconditionally along the paper's route, with no external input. The derivative step at `:153` is read a.e. and its passage to monotonicity is filled by the FTC for absolutely continuous functions (fair implicit step); "negative" should read "non-positive" (editorial). No error or gap found.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

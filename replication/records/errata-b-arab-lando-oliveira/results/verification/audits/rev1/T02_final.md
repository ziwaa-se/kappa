# T02 final audit (Theorem 3.1, thm:main): `pv_work/T02ModGaps.lean`

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), final-audit mode, gap file.
- Date: Tue Oct 13 01:35:37 EDT 2026 (from `date`).
- Source: `source/SuperParetoPaper-v12.tex:186-257` (statement :186-189; (eq:main-st) :95-98; Def 2.1 :115-118; Def 2.2 :122-125; (eq:sub-1x) :131-134; F, F̄ :113). I read all of these directly.
- Inputs read: `verification/audits/T02_gate_r2.md`, `pv_work/notes/T02_prover_notes.md`, `verification/audits/T02_issue_1.md`, `pv_work/T02ModGaps.lean` (full), `pv_work/T02Stmt.lean`, `pv_work/L01Stmt.lean`; `diff pv_work/T02.lean pv_work/T02ModGaps.lean`.
- Probe: `pv_work/probes/auditor/T02/aud_T02_final.lean`. Result: `exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/aud_T02_final_2.log`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py T02 --module T02ModGaps` gave `MECH CHECKS: PASS`. The report is `verification/audits/T02_mech.md`.

| # | Check | Result |
|---|---|---|
| 1-2 | compile; private rebuild, sha256 IDENTICAL | PASS |
| 3 | PVTools hash | PASS |
| 4 | 28 gated declarations: th/vh/bi identical to gate r2 | PASS |
| 4b | `T02_S5_Gap`, `T02_S6a_Gap`, `T02_S10b_Gap`: vh = snapshot th of S5, S6a, S10b | PASS |
| 6-7 | axioms ALL STANDARD; no `sorryAx` in closure | PASS |
| 11 | TRACED CONDITIONS: none. This is only because `T02_L01Consumed` is **not registered** in EXTERNAL_TOOLS; it is used (§4) | corrected below |

## 2. Gap-file checks (§2b)

| Check | Result |
|---|---|
| `T02.lean` vs `T02ModGaps.lean` (diff) | They differ only in: `T02_main` (sorry) removed; S5, S6a, S10b turned from `sorry` theorems into `def …_Gap` ∀-closures; the assembly (`T02_PosVersion`, `T02_ZeroWeights_Gap`, `pos_step`, `pos_all`, `T02_main_mod_gaps`) added; docstrings. Every other obligation is textually identical. PASS |
| copy-and-`example`: the type of `T02_main` (copied verbatim from `T02.lean:135-140`) follows from `T02_main_mod_gaps` once `hG5 hG6a hG10b hZ` are supplied | compiles (probe). PASS |
| gap-dependent obligations | only the main theorem. S1-S4, S6b, S7-S11 use no gap. `#pv_hyp_usage T02_main_mod_gaps`: all 17 binders USED |
| `T02_ZeroWeights_Gap` (not in the gate snapshot, so not hash-checked) | Read by hand. It says: positive-weights version ⇒ nonnegative-weights version, with exactly the hypotheses of `T02_main`. It does not assume the conclusion outright: it needs `T02_PosVersion`, which `pos_all` proves modulo gaps. It faithfully records that :219 treats only θᵢ > 0 while :95 allows θᵢ ≥ 0. The classification (EXPOSITION_GAP versus FAIR_IMPLICIT_STEP) has **not been ruled on**. |

**Finding (affects how `T02_main_mod_gaps` may be cited).** `T02_S10b_Gap` is refutable. I prove `aud_not_S10b_gap (hL01 : T02_L01Consumed) : ¬ T02_S10b_Gap` in the probe. The witness is Pareto(1) (`μP`, `isInvSub_P` from `T02_Counterexample1`), with x = 0 and θ = 1/2. At x = 0 the gap demands F̄(0)² ≤ 0, but ITS gives F̄(0) = 1. The closure axioms are standard and there is no sorryAx. So, under the condition `T02_L01Consumed`, the premises `hL01` and `hG10b` of `T02_main_mod_gaps` contradict each other, and **`T02_main_mod_gaps` is no evidence for the main theorem**. This is consistent with `T02_issue_1.md` §5, and it is not a fault of the gap file: S10b is the gate-approved faithful encoding of the printed step at :256, and the printed step is itself false. A main theorem modulo gaps that can be cited would need the S10b gap restated as the consumed clause `P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x)` at that point. That is for the coordinator/prover to decide; the auditor does not propose a proof.

## 3. Axioms and `sorry`

Mechanical items 6-7: ALL STANDARD, no sorryAx. The probe's walk on `aud_not_S10b_gap` is also standard.

## 4. Conditionality

| Parameter | Used where (`#pv_hyp_usage`) | Status |
|---|---|---|
| `T02_L01Consumed` (L01 "only if": ITS ⇒ (eq:sub-1x), consumed at :201 and :256) | `T02_S3` (USED, gives (eq:sub-1x) for S3) → `T02_S4` (USED, the n = 2 case) → `pos_all`; and in `pos_step` it yields `SubCond` for S10a/S11 (and the S10b gap); `T02_main_mod_gaps` hL01 USED | **condition** |

Positive control: `#pv_walk_decl T02_S4` reaches `T02_L01Consumed`. Credibility: with Def 2.2 read as subadditivity on (0,∞), the direction ITS ⇒ (eq:sub-1x) holds. For x > 0, take y₁ = θ/x and y₂ = (1-θ)/x. For x = 0 it follows from F(0) = 0. This direction is not the one affected by L01's issue (`L01_issue_1.md`).

Hypotheses reported UNUSED in gated obligations: S1 `hx`, S2 `h0`, S6b `hx`, S7 `hits/hθ/hsum/hx`, S9 and S10a instances. These are premises of gated step statements that the proofs happen not to need. They make those statements weaker in premises, so harmless, and none is an external parameter.

## 5. Infrastructure (item 8, item 9)

| Constant(s) | Record | My individual review |
|---|---|---|
| `Paper.L01.F, invDist, SubadditiveOn, IsInvSub, SubCond` (L01Stmt) | `L01_gate.md` (definitions) | Reviewed: F = cdf (:113); invDist = 1 - F(1/x) (:121); IsInvSub = F(0) = 0 ∧ subadditive on (0,∞) (:124, domain reading gate-approved); SubCond = (eq:sub-1x) (:133). PASS |
| `StDom, Fbar, IIDCopies(+fields/mk), T02_L01Consumed` (T02Stmt) | `T02_gate_r2.md` | StDom = Def 2.1 with F̄_X(x) = P(X > x); Fbar = 1 - F (:113); IIDCopies = :95; T02_L01Consumed: see §4. PASS |
| 26 helpers (item 9) | none, so audited here | `F_*`, `Fbar_*`, `F_eq_real`, `real_Ioc`, `real_Icc_le/eq`, `integrable_bdd`, `*_aff_meas`, `*_abs_le`, `toReal_le_one'`, `meas_cond`, `last_lt_one`: cdf, measurability and arithmetic facts. `prob_gt_eq_Fbar`: P(X > x) = F̄ of the law (:113). `ae_nonneg_of_ident`, `stdom_neg`: F(0) = 0 ⇒ copies ≥ 0 a.s., hence the x < 0 case. `T02_PosVersion`: the positive-weight statement. `pos_step`, `pos_all`: assembly (see §6). None introduces new mathematics or the target conclusion. PASS |

## 6. Route fidelity

| Step | Source | Lean | Judgement |
|---|---|---|---|
| S1 | :191-194 conditioning formula | law of (X₁, X₂) = ν⊗ν, `Measure.prod_apply`, restriction to [0, x/θ] by F(0) = 0 | faithful; FAIR_IMPLICIT_STEP: "nonnegative" taken from F_X(0) = 0 (Def 2.2) |
| S2 | :195-198, Fig. 1 | split [0,x] ∪ (x,x/θ]; integrand bounds F(x/(1-θ)) and F(x); masses ≤ F(x) and F(x/θ) - F(x) | faithful reading of the figure (FAIR_IMPLICIT_STEP) |
| S3 | :198-201 "using (eq:sub-1x)" | F(x)·(sub-1x) | faithful |
| S4 | :217 | S1 + S2 + S3 for x ≥ 0; x < 0 by nonnegativity | FAIR_IMPLICIT_STEP: x < 0 is not written, but Def 2.1 needs all x ∈ ℝ |
| S5, S6a | :222-223 | stopped (gaps) | suspected atom issue, not ruled; not audited as true |
| S6b | :223-224 conditioning on Xₙ | independence of Xₙ and the rest, product law, `lintegral_indicator` | faithful |
| S7 | :225 "using the induction hypothesis" | IH with weights θᵢ/(1-θₙ) (the normalisation is printed at :224); P(Y ≥ y) ≥ P(Y > y) | faithful; P(≥) ≥ P(>) is FAIR_IMPLICIT_STEP |
| S8 | :246-252, Fig. 2 | mirror of S2; the mass of [0,x] is F(x) via F(0) = 0 | faithful |
| S9 | :252-254 | algebra (an equality, printed as ≥) | faithful |
| S10a, S11 | :256 "(eq:sub-1x) in survival form" | from SubCond | faithful |
| S10b | :256 "parenthesis negative, it follows that P ≥ F̄(x/θₙ) + F̄(x/(1-θₙ))" | stopped (gap) | printed inference invalid. I checked independently: at x = 0, F̄(0) = 1, so the claimed bound is 2 > 1 ≥ P (see also `T02_issue_1.md`) |
| induction frame | :190, :219 (base n = 2, step n-1 → n) | strong induction: n = 0 vacuous (∑θ = 1 impossible), n = 1 trivial, n = 2 = S4, n ≥ 3 = `pos_step` | faithful; FAIR_IMPLICIT_STEP for n = 1 |
| zero weights | :95 θᵢ ≥ 0 vs :219 θᵢ > 0 | `T02_ZeroWeights_Gap` premise | gap, not ruled |

No route change. No result stronger than the source is used: the only external input is L01's "only if" direction, which the source itself cites at :201 and :256.

## 7. Non-vacuity

In the probe: three i.i.d. Pareto(1) copies (`μ3, X3, Xs3`) satisfy `IIDCopies` and `IsInvSub (μ3.map X3)`, so the premises of `T02_main_mod_gaps` other than the gaps and the parameter are satisfiable. `T02_S4` applies to this nontrivial instance (θ = 1/2), given hL01. `F μP 0 = 0` witnesses the `h0` premises of S2 and S8. These witnesses come from `T02_Counterexample1`, whose audit (the T02_issue_1 review) is in progress. They are used only for non-vacuity and for the S10b-gap observation, never for a positive verdict. The non-vacuity of the **gap conjunction** fails: hG10b is refutable (§2).

## 8. Status for the authors

Verified, conditional on L01's "only if" direction (T02_L01Consumed): the n = 2 case (S1-S4), the conditioning step S6b, the IH step S7, the Figure 2 bound S8, the algebra S9, and S10a/S11. Not verified: S5/S6a (strict versus non-strict events with atoms; unruled), zero weights (unruled), and S10b. The printed inference at :256 is invalid, and its intermediate claim P ≥ F̄(x/θₙ) + F̄(x/(1-θₙ)) is false (at x = 0, for example). So the main theorem is not verified along the printed route.

## 9. Records to update

- Register `T02_L01Consumed` in `verification/EXTERNAL_TOOLS.md` (provenance p, L01 "only if", used at T02 S3/S4 and pos_step). It is currently missing, which is why the mechanical report traced no conditions.
- The suggested verdict ISSUE depends on the pending confirmation of `T02_issue_1` (counterexample review in progress). If it is not confirmed, the verdict is UNFINISHED.
- Note in the T02 record that `T02_main_mod_gaps` is uninformative because `T02_S10b_Gap` is refutable (`aud_not_S10b_gap`).

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: T02_L01Consumed

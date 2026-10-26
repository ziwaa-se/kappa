# T01 final audit (Theorem 2.8, thm:inclusion, source/SuperParetoPaper-v12.tex:169-181)

- Auditor: pv-auditor (Claude Opus 5.5), independent subagent; not the drafter, prover or gate.
- Date: Tue Oct 13 01:26:58 EDT 2026 (from `date`).
- Audited object: `pv_work/T01ModGaps.lean` (gap file; stopped obligations S0, S2). Also compared: `pv_work/T01.lean`.
- Inputs read in full: source F:100-189 (definitions F:111, F:113, F:121-137, theorem and proof F:169-181), `T01_gate.md`, `T01_gate_r2.md` (snapshot), `T01Stmt.lean`, `T01Draft.lean`, `L01Stmt.lean`, `T01ModGaps.lean`, prover notes; verdict lines of `T01_issue_1.md` / `T01_issue_1_audit.md`. `T01_issue_2.md` (S0) was not relied on.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps`)

Report `verification/audits/T01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T01ModGaps` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs `T01_gate_r2.md` (13 decls) | PASS |
| 4b | `T01_S0_Gap` vh = th(S0), `T01_S2_Gap` vh = th(S2) | PASS |
| 6 | `#pv_axioms` | ALL STANDARD |
| 7 | `#pv_walk` | no `sorryAx`; propext, Classical.choice, Quot.sound |
| 11 | traced conditions | "none" (corrected in §4: the two parameters are not registered in the tools table, which is empty) |

## 2. Gap-file checks (§2b, by me)

Probe `pv_work/probes/auditor/T01/auditor_T01_gapcheck.lean` (log `pv_work/logs/auditor_T01_gapcheck_1.log`, exit=0, 0 errors, 3 sorry = the verbatim copies):

| Declaration (verbatim from `T01Draft.lean`, original name) | th in probe | th in gate r2 snapshot |
|---|---|---|
| `T01_S0` | 2863022550 | 2863022550 |
| `T01_S2` | 193369578 | 193369578 |
| `T01_main` | 1280967929 | 1280967929 |

- `example : T01_S0_Gap = type_of% @T01_S0 := rfl`: compiles.
- `example : T01_S2_Gap = type_of% @T01_S2 := rfl`: compiles.
- `example (g0 : T01_S0_Gap) (g2 : T01_S2_Gap) : type_of% @T01_main := T01_main_mod_gaps g0 g2`: compiles.
- `diff T01.lean T01ModGaps.lean`: only S0/S2 (`sorry` theorem vs `_Gap` def), `T01_main` vs `T01_main_mod_gaps` (two gap premises, `T01_S2 …`/`T01_S0 …` replaced by `hGap_2 …`/`hGap_0 …`), and comments/docstrings. All proofs of S1, S3-S6, helpers and assembly are identical.

## 3. Axioms and sorry
Standard only (mech items 6-7; also `#print axioms T01_main_mod_gaps` in my probe: [propext, Classical.choice, Quot.sound]).

## 4. Per-theorem conditionality (`#pv_hyp_usage`, probe `auditor_T01_usage.lean`, log `pv_work/logs/auditor_T01_usage_3.log`)

| Theorem | Parameter | Status | Where it is actually used |
|---|---|---|---|
| `T01_main_mod_gaps` | `hGap_2 : T01_S2_Gap` | USED | F_{h(X)}(0)=0, feeds L01 (←), `bdd_of_S2`, x=0 case |
| | `hGap_0 : T01_S0_Gap` | USED | supplies `hm` to S3 |
| | `hL01 : T01_L01Consumed` | USED directly in the main proof | (→) applied to μ (F:178 "using (eq:sub-1x)"); (←) applied to `μ.map h` (F:180 "taking into account Lemma 2.3") |
| | `hX02 : T01_X02Tool` | USED, passed to S3 | |
| `T01_S3` | `hX02` | USED: the proof term is `hX02 h hc hs hm` (direct application) | F:174 "its inverse h^{-1} is anti-star-shaped (Lemma 4.1 of ineq-order2024)" |
| `T01_S1` | all 9 incl. `hbdd` | USED | |
| `T01_S5` | instance, `hθ` | UNUSED (mech item 10) | gated-statement hypotheses, not external parameters; harmless (monotonicity of the cdf needs no θ range) |
| `T01_S6` | instance | UNUSED | same remark |

No "enters only through Y" claim is made, so no `#pv_walk_decl` positive-control was needed: both parameters are consumed at the level read directly from the proof term.

Correction to mech item 11: the conditions really used are `T01_X02Tool` (S3) and `T01_L01Consumed` (main, both halves). `pv_status.py tools` lists no registered tools, which is why the script traced none.

## 5. Infrastructure (item 8/9)

| Constant(s) | Kind | Individual record |
|---|---|---|
| `Paper.L01.F`, `IsInvSub`, `SubCond`, `SubadditiveOn`, `invDist` | definitions | named with hashes in `L01_gate.md` (PASS, lines 38-53, 92-96) |
| `Paper.T01.StarShaped`, `AntiStarShaped`, `ginv`, `T01_X02Tool`, `T01_L01Consumed` | definitions / Prop parameters | `T01_gate.md` items 1-6 and `T01_gate_r2.md` A1 (named, hashes) |

No project theorem from another module is consumed. Helpers not in the snapshot, reviewed by me:

| Helper | Content | Judgement |
|---|---|---|
| `F_eq` | `F μ x = μ.real (Iic x)` via mathlib `cdf_eq_real` | technical |
| `real_Iic_zero` | `μ.real (Iic 0) = 0` from the `F μ 0 = 0` conjunct of ITS | technical |
| `sub_down` | sublevel set `{y ≥ 0 : h y ≤ x}` is downward closed, from star-shapedness (two cases on sign of h z; checked by hand) | technical (justifies S1, see §6) |
| `sub_eq` | bounded closed downward-closed sublevel set = `[0, ginv h x]` (`IsClosed.csSup_mem`) | technical |
| `bdd_of_S2` | gate-sanctioned FAIR_IMPLICIT_STEP for `hbdd`, see §6 | fair; depends on S2 |

None smuggles in the conclusion; all have standard axioms (closure of the module).

## 6. Route fidelity (sentence by sentence)

| Source (F:) | Lean | Judgement |
|---|---|---|
| 174 "as h is continuous, F_{h(X)}(x)=F_X(h^{-1}(x))" | `T01_S1` (x ≥ 0, with `hbdd`) via `sub_eq`, `Measure.map_apply`, no mass on (-∞,0) | faithful. FAIR_IMPLICIT_STEP: the downward closedness of the sublevel set is unwritten; filled from star-shapedness (`sub_down`), a hypothesis of the theorem, and μ((-∞,0])=0 from F_X(0)=0 (Def 2.2). No use of S0 here, so S1 does not inherit the S0 gap. `hbdd` only excludes the source's h^{-1}(x)=+∞ case (encoding junk). |
| 174 "Since h is star-shaped, its inverse h^{-1} is anti-star-shaped (Lemma 4.1 in ineq-order2024)" | `T01_S3 = hX02 h hc hs hm` | faithful; cited result as parameter X02, specialised to continuous increasing h (weaker than the cited use); `hm` from S0 (gap: the source's "every function considered is increasing") |
| 174 "given θ∈(0,1), h^{-1}(x/θ) ≤ h^{-1}(x)/θ, likewise 1-θ" | `T01_S4` (x > 0): ratio antitonicity at x ≤ x/t | faithful |
| 174-178 "As every function considered is increasing", first line of display | `T01_S1` rewrites ×3, `T01_S5` (`monotone_cdf`) | faithful |
| 178 "≤ F_X(h^{-1}(x))+1 … using (eq:sub-1x)" | `T01_S6` at y = ginv h x with `SubCond μ` from L01 (→) | faithful; FAIR_IMPLICIT_STEP: y ≥ 0 (from `le_csSup`, 0 is in the set) and that (eq:sub-1x) for X comes from Lemma 2.3 (→) |
| 180 "taking into account Lemma 2.3, the proof is concluded" | L01 (←) applied to `μ.map h`, premise `F (μ.map h) 0 = 0` = S2 | faithful; S2 is the recorded gap (source never establishes F_{h(X)}(0)=0) |
| (unwritten) case x = 0 of (eq:sub-1x) for h(X) | `rw [zero_div, h2]; norm_num` | FAIR_IMPLICIT_STEP (trivial 2F(0) ≤ F(0)+1; Lean uses S2 to simplify, but it holds for any cdf) |
| (unwritten) `hbdd` at x, x/θ, x/(1-θ) | `bdd_of_S2` | FAIR_IMPLICIT_STEP as required by `T01_gate.md` item 5 / r2 A2. Checked: if the sublevel set at x were unbounded and h(y) > 0 for some y > 0, pick z > max(y, x/c) in the set with c = h(y)/y; star-shapedness gives h(z)/z ≥ c, while h(z) ≤ x gives h(z)/z < c. Hence h ≤ 0 on (0,∞), so F_{h(X)}(0) ≥ P(X > 0) = 1, contradicting S2. It only removes our `sSup` junk value; it adds no mathematics beyond the source's h^{-1} = +∞ convention. It depends on S2, so it lies inside the gap-dependent part. |

No route change, no stronger result than the source's. The only places where the source's justification fails are S0 and S2 (stopped).

## 7. Non-vacuity (probe `auditor_T01_usage.lean`, exit=0, 0 sorry)

- Witnesses: μ0 = law with F(x) = x⁺/(1+x⁺), ITS (`Paper.T01.Issue1.isInvSub_μ0` from the audited counterexample module, standard axioms); h = id and h = x² (continuous, star-shaped; proved in probe).
- `T01_S1` instantiated nontrivially (μ0, h = x², x = 4, bounded sublevel set [0,2]); `T01_S6` instantiated with `SubCond μ0` from `T01_L01Consumed` (→); main-theorem hypotheses jointly satisfied (μ0, id).
- Note: `T01_main_mod_gaps` as a whole is vacuously true, because `T01_S2_Gap` is refuted (`Paper.T01.Issue1.not_T01_S2_Gap`) and `T01_S0_Gap` is false (h = −x). This is the expected state of a result with a confirmed issue and is why it supports no verified verdict.
- External parameters satisfiable: `T01_L01Consumed` true by the argument in `T01_gate_r2.md` A1 (re-checked: substitution s = θ/x, t = (1−θ)/x); `T01_X02Tool` true (re-checked by hand: monotone star-shaped h ≥ 0 with h(0)=0 is either ≡ 0 on [0,∞), where ginv ≡ 0, or unbounded; then h(ginv u) = u for u > 0 and u/ginv(u) ≤ v/ginv(v) for u < v).

## 8. Status for the authors

Verified (Lean, standard axioms): the proof of Thm 2.8 at F:174-180 goes through step by step **modulo two unestablished claims**, given Lemma 4.1 of ineq-order2024 (X02) and the true halves of Lemma 2.3 (L01). The source has: S2, F_{h(X)}(0)=0, never established and false (ERROR, T01_issue_1, counterexample audited VALID); S0, "every function considered is increasing", false for star-shaped h such as h = −x (ruling pending, T01_issue_2).

## 9. Records to update
- Register `T01_X02Tool` and `T01_L01Consumed` in `verification/EXTERNAL_TOOLS.md` / the tools table (`pv_status.py tools` currently empty, so mech item 11 traced "none").

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: T01_X02Tool, T01_L01Consumed

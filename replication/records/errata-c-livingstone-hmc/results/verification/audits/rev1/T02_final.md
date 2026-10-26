# T02 (Theorem 5.14, thm:light): final audit

- Auditor: pv-auditor (claude-opus-5-5), fresh subagent; did not draft, gate or prove T02.
- Date: Tue Oct 13 01:34:35 EDT 2026 (from `date`).
- Audited object: `pv_work/T02.lean` sha256 `fe514b6d…19310`; `pv_work/T02Stmt.lean` `b69ed32e…b30ba0` (= gate r2 hash). No gap file (no stopped obligation).
- Source read directly: TEX:863-880 (statement, proof), TEX:152-167 (MH framework, eqn:accept), TEX:258-315 (eqn:geoerg, Def. MH type, Prop 3.5), TEX:317-377 (HMC, Alg. 1, M = I, Prop 4.2).
- Also read: `T02_gate_r2.md`, `T02_prover_notes.md`, `T02Stmt.lean`, `T02.lean` (full), `Defs.lean` (full), `L02_final.md` (verdict section), `L03_final.md` (non-vacuity), `RESULTS.json` external_tools.
- Audited files not modified. Probe: `pv_work/probes/auditor/T02/auditor_T02_nonvac.lean` (log `pv_work/logs/auditor_T02_nonvac_4.log`, exit 0, 0 errors, 0 sorry).

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py T02`, run by me)

Report `verification/audits/T02_mech.md`: **MECH CHECKS: PASS**.

| Item | Result |
|---|---|
| 1 compile `T02` | PASS (exit 0, 0 sorry) |
| 2 private rebuild sha256 | PASS, IDENTICAL |
| 3 PVTools hash | PASS |
| 4 fingerprints vs `T02_gate_r2.md` (21 gated decls) | PASS, all identical |
| 5 Defs vs `DEFS_gate.md` | PASS |
| 6 `#pv_axioms T02` | PASS, ALL STANDARD |
| 7 `#pv_walk T02` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 10 hyp usage | `T02_main`: all 16 USED. Only UNUSED: `hgrad` in `T02_S6` (see §4) |
| 11 traced conditions | "none" only because no T02 parameter is registered in `external_tools` (record gap; see §4) |
| 12 last writers | prover (T02.lean), drafter (T02Stmt.lean) |

## 2. Gap files

Not applicable: no `T02ModGaps.lean`; every gated obligation is proved.

## 3. Axioms / sorry

Clean (items 6-7). Probe constants (`aud_grad`, `aud_pi`, `aud_L02cons`) also standard-axioms only.

## 4. Per-theorem conditionality

| Parameter of `T02_main` | Used at (confirmed by `#pv_hyp_usage` down the chain) | Provenance |
|---|---|---|
| `hL02 : T02_L02Consumed` | `T02_S2` (USED) -> `Paper.L03.L03_main` (its `hL02 : L03_L02Consumed` USED; L03_final traces it to L03 S4a, S9, S11). TEX:879 "Lemmas xelower/xlower establish `‖x_{Lε}‖ ≥ 2^L‖x_0‖`" | (p) predecessor L02 |
| `hE1 : Prop35` | `T02_S8` (USED, applied directly). TEX:879 "allowing Proposition prop:supr to be envoked" | (ii) Prop 3.5, TEX:300-303 |
| `hE6 : GaussFacts` | `T02_S6` (USED: part (a) probability measure, via `T02_S5` part (b) tail). TEX:879 "we simply note `P(‖p_0‖ ≤ ‖x_0‖^δ) → 1`" | (v) |

- `hgrad` UNUSED in `T02_S6` (intermediate obligation; harmless extra premise, `integral_mono_of_nonneg` needs no measurability). It is used in `T02_main` via S7 (`tail_ne_zero`, continuity of U) and S8. Non-blocking remark.
- Record gap: none of the three parameters is registered in `RESULTS.json` external_tools (`pv_status.py tools` lists only `L03_L02Consumed`, `L02_L01Consumed`). The coordinator must register them; I use the IDs `T02_L02Consumed`, `T02_Prop35` (= EXTERNAL_TOOLS E1), `T02_GaussFacts` (= E6) below.
- `T02_L02Consumed` has exactly the content of `L03_L02Consumed`; T02 supplies L03's condition with its own parameter, so L03's condition does not appear separately.
- **Reconnection available for `T02_L02Consumed`.** In the probe, `aud_L02cons` derives `T02_L02Consumed gU eps L` from `Paper.L01.L01_main_fixedDelta` (L01, UNCONDITIONAL), `Paper.L02.L02_main_fixedDelta_osc` and `Paper.L02.L02_S10` (verified in `L02ModGaps`, clean axioms; L02_final §7 lists them as verified), using only `heps`, (17) and (18). These are hypotheses of `T02_main`. So the L02 gap (TEX:930 uses (18), which L02 does not assume) does not affect T02: T02 assumes (18). The coordinator may run a reconnection (`T02Closed_r1`) to remove this condition. Until then it stays a condition. It is a (p)-clause whose verified source theorems exist, not an (iv) gap hypothesis.

## 5. Infrastructure (item 8, item 9)

| Module / constants | Coverage |
|---|---|
| `Defs` (16, definitions) | `DEFS_gate.md` (defs gate; definitions only) |
| `L02Stmt` (`ConclFixedDelta`, `Concl._proof_1`) | `L02_gate_r2.md` (definitions) |
| `L03` (30, theorems S1-S12, main) | `L03_final.md` PASS (individual) |
| `L03Stmt` (`L03_L02Consumed`) | `L03_gate.md` |
| `T02Stmt` (16, definitions + external Props) | `T02_gate_r2.md` |

Item 9 private helpers, read by me:

| Helper | Judgement |
|---|---|
| `gU_meas`, `step_meas`, `lf_meas`, `acc_meas` | measurability only (gU = `gradient U`, `measurable_fderiv`); technical |
| `acc_nonneg`, `intg01` | `α ≥ 0`; bounded measurable is integrable; technical |
| `tail_ne_zero` | `π{‖x‖>R} ≠ 0` from `e^{-U} > 0`, `Z < ∞`, `d ≥ 1`, open nonempty set has positive Lebesgue measure. True, non-vacuous, does not contain the target. It is a standard domain fact used in the X1 fill-in (§6) |

## 6. Route fidelity (TEX:879, sentence by sentence)

| Source | Lean | Judgement |
|---|---|---|
| "Lemmas xelower and xlower establish `‖x_{Lε}‖ ≥ 2^L‖x_0‖`" | S1 = part (a) of `hL02`; consumed by L03 | faithful (predecessor clause) |
| "Lemma arate_0 shows α → 0 as `‖x_0‖ → ∞` provided `‖p_0‖ ≤ ‖x_0‖^δ`, δ<1" | S2 = `L03_main` at δ = 1/2; S3 unfolds the filter | faithful. S3 is a pure restatement |
| "allowing Prop. prop:supr to be envoked. To conclude we simply note `P(‖p_0‖ ≤ ‖x_0‖^δ) → 1`" | S5 (E6), S6: `r(x) = 1 − ∫α dμ^G ≥ 1 − κ/2 − P(‖p_0‖ > ‖x‖^δ)`, so `r → 1`; S7': `r ≤ 1`; S7: `esssup_π r = 1` | **X1: FAIR_IMPLICIT_STEP**. The source names every ingredient (α → 0 on the region, region probability → 1, α ≤ 1 elsewhere is implicit, `esssup r = 1` is the hypothesis of Prop 3.5). Filled as: split the integral on the region / its complement (S6), then `r → 1` at infinity plus `π` positive on every tail gives `esssup = 1` (S7, `tail_ne_zero`). No stronger result was used. Not an EXPOSITION_GAP: nothing outside the printed argument is needed beyond standard measure facts |
| "establishing the result" | S8 = `Prop35` applied | faithful |
| HMC kernel is of MH type (premise of Prop 3.5, TEX:274-278, 301) | S4 proves `P(x,A) = ∫ α 1_A(x_{Lε}) dμ^G + r(x) 1_A(x)` with `r = 1 − ∫α dμ^G` (from the definition of `hmcStep`, GaussFacts (a)). `Prop35` is encoded specialised to `hmcStep` | **FAIR_IMPLICIT_STEP** for the form (mhtype) (the paper presents HMC as MH, TEX:336, 359-374). Note for the human check of E1 below |

Note for the human check of `T02_Prop35`. Def. MH type (TEX:274-278) takes α "defined in (eqn:accept)", i.e. a density ratio in (x,y) (TEX:163-167). The HMC acceptance (Prop 4.2, TEX:366-369) also depends on `p_0`. So the HMC kernel fits form (mhtype) with `r(x) = 1 − ∫α dμ^G` (S4), but not literally with α from eqn:accept. The encoded `Prop35` carries this applicability. It is credible: the Roberts–Tweedie argument uses only the rejection mass `P(x,{x}) ≥ r(x)`, so the conclusion is not threatened. I record this as an observation for the human check of E1, not as a confirmed paper issue; it does not affect the verdict. Possible classification if the issue checker pursues it: DOMAIN_CLARIFICATION, minor.

Other encoding points (gate-approved, unchanged): "for any choice T > 0" is encoded as for every ε > 0 and every L ≥ 1, with the same L in (19) (N3). TFA-1..4 (`ε>0, L≥1`, `d≥1`, `IsGradField`, `Z<∞`) are standing conventions (TEX:320, 336).

## 7. Non-vacuity (probe `auditor_T02_nonvac.lean`, exit 0, 0 sorry)

- Nontrivial instance d = 1, `U x = ‖x‖⁴/4`, `gU x = ‖x‖²·x`, ε = 1, L = 2. Proved: (17), (18) (C = 0), (19) (every L), `IsGradField` (`aud_grad`), `∫⁻ e^{-U} < ∞` (`aud_pi`, via `e^{-t⁴/4} ≤ e·e^{-t²}` and mathlib Gaussian integrability), and **`T02_L02Consumed` itself** (`aud_L02cons`, from verified L01/L02 theorems).
- `example (hE1 : Prop35) (hE6 : GaussFacts) : ¬ GeomErgodic (‖x‖⁴/4) (‖x‖²x) 1 2 := T02_main …` compiles. Every non-external hypothesis is discharged on a nontrivial instance. `Prop35` and `GaussFacts` remain parameters; both are true statements (Roberts–Tweedie; standard Gaussian facts) but are not proved here.

## 8. Status for the authors

Verified in Lean: Theorem 5.14, along the printed route (Lemmas 5.15-5.17, α → 0 on the high-probability region, `r → 1`, `esssup r = 1`, Prop 3.5). It depends on Prop 3.5 (cited), on standard Gaussian facts, and on the conclusion of Lemma 5.16 under (17)+(18). Both of Theorem 5.14's hypotheses hold here, and the conclusion is available from the verified L01/L02 theorems, so reconnection can remove that condition. Source: the passage to `esssup r = 1` and the MH-type identification are compressed but fair (FAIR_IMPLICIT_STEP). Observation: HMC's α depends on `p_0`, so it is not literally of the eqn:accept form. Editorial: "envoked" (TEX:879).

## 9. Verdict reasoning

All mechanical checks pass. The whole statement is proved along the source route. There are no gaps, debts or unencoded parts. All in-project constants are covered by individual records. Non-vacuity holds on a nontrivial instance. Three external parameters are really used, so the suggested verdict is CONDITIONAL. No paper issue is confirmed in this result. L02's PAPER_ARGUMENT_GAP does not propagate: T02 assumes (18).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: T02_L02Consumed, T02_Prop35, T02_GaussFacts

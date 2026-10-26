# T02 final audit (Theorem 5.14, thm:light), revised manuscript

- Auditor: pv-auditor (independent subagent, opus), session 13bf576d; did not draft, gate or prove T02.
- Date: Tue Oct 13 11:25:20 EDT 2026 (from `date`).
- Audited object: `pv_work/T02.lean` (no gap file; the prover reports none and the walk finds no `sorryAx`).
- Source read directly: `source/geo_erg_HMC_v3.1.tex:895-941` (statement and proof, including the random-`L` paragraph 934-940), 264-303 (eqn:geoerg, MH type, Prop. 3.5), 381-411 (A1 and fixed-`L` convention), 1011-1016 via L03 (Lemma 5.17).
- Also read: `pv_work/T02Stmt.lean`, `pv_work/L03Stmt.lean`, `pv_work/Defs.lean`, the gate reports `T02_gate.md` (items 6-7, TFA table) and `T02_gate_r2.md` (snapshot), prover notes `pv_work/notes/T02_prover_notes.md`, `L03_final.md` §4 and §6, and the `L03_main` signature in `pv_work/L03.lean:345-348`.
- Probes (mine): `pv_work/probes/auditor/T02/final_T02_probe.lean` (exit=0, 0 errors, 0 sorry; log `pv_work/logs/final_T02_probe_5.log`), `pv_work/probes/auditor/T02/final_T02_aux.lean` (exit=0; log `pv_work/logs/final_T02_aux_1.log`).

## 1. Mechanical checks (run by me)

I ran `python3 scripts/pv_audit_mech.py T02` myself. It wrote `verification/audits/T02_mech.md`, ending in **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T02` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL `be37120c…` |
| 3 | PVTools hash | PASS |
| 4 | 35 gated fingerprints vs `T02_gate_r2.md` | PASS (all th/vh/bi identical) |
| 5 | Defs vs DEFS snapshot | PASS |
| 6 | `#pv_axioms T02` | ALL STANDARD |
| 7 | `#pv_walk T02` | no `sorryAx`; propext, Classical.choice, Quot.sound |
| 11 | traced conditions | script: `T02_L03Consumed` only. **Inconsistent and corrected below (§3)** |
| 12 | last writers | prover (T02.lean), drafter (T02Stmt.lean) |

**Script inconsistency (item 11).** The script reports `T02_Prop35`, `T02_GaussFacts` and `T02_Prop35Rand` as "registered but not reached". Its own item 10 lists `hE1`/`hE6` as USED in `T02_main`/`T02_main_randL`. My `#pv_hyp_usage` and `#pv_walk_decl` runs (§3) show that all three are reached and used. So the trace in item 11 is wrong. A possible cause is that the registry's Lean line numbers point at the docstrings (`T02Stmt.lean:78`, `:88`) and not at the definitions (`:82`, `:92`); I did not diagnose this. I corrected the trace by hand. This is a tooling and record issue, not a FAIL of the proof.

## 2. Gap files

None (no `T02ModGaps.lean`; the walk finds no `sorryAx`). Not applicable.

## 3. Per-theorem conditionality

`#pv_hyp_usage` results (probe log lines 2-103):

| Theorem | External parameters USED | UNUSED |
|---|---|---|
| `T02_main` | `hL03 : T02_L03Consumed`, `hE1 : Prop35`, `hE6 : GaussFacts` | `hexp`, `hosc`, `hosc2` |
| `T02_main_randL` | `hL03` (per `l`), `hE1 : Prop35Rand`, `hE6 : GaussFacts`, `hA1` | `hexp`, `hosc`, `hosc2` (per `l`) |
| `T02_S9` | `hE1 : Prop35` (directly applied) | none |
| `T02_SR6` | `hE1 : Prop35Rand` (directly applied) | none |
| `T02_S5` | `hE6` (via S2, S4) | `hδ : δ < 1` (step lemma; `δ<1` is consumed in S1, harmless) |
| `T02_S2` | `hE6` ((b) and (a)) | none |
| `T02_SR1` | `hE6`, `hL03` | none |

Where each parameter is actually used:
- `T02_L03Consumed` → S1 (TEX:911-916, "From Lemma arate_0"), and through it the fixed-`L` main theorem; SR1 → `T02_main_randL` for each `l` with `𝔏{l} ≠ 0`.
- `T02_GaussFacts` → S2 (clause (b): Gaussian tail, TEX:917-921) and S4 (clause (a): `μ_G` is a probability measure, TEX:926-931), through S5 into `T02_main`; through `J01` (`0 ≤ ∫α ≤ 1`, i.e. "bounded by one", TEX:938) and SR1 into `T02_main_randL`.
- `T02_Prop35` → S9 (TEX:932, "Proposition prop:supr then implies"), in `T02_main`.
- `T02_Prop35Rand` → SR6 (TEX:935-936, "the same conclusion follows"), in `T02_main_randL`.

Walk check with a positive control (probe §3):
- `#pv_walk_decl Paper.T02.T02_S9` reaches `Paper.T02.Prop35` (via `T02_S9`). This is the positive control.
- The walk from `T02_main` reaches `Prop35`, `GaussFacts` (via S5, S4) and `T02_L03Consumed` (via S1).
- The walk from `T02_main_randL` reaches `Prop35Rand` (via SR6), `GaussFacts` (via SR1/SR3) and `T02_L03Consumed` (via SR1, S1).

**hexp / hosc / hosc2 unused (checked as asked).** These are the printed hypotheses (17), revised (18) and (19) (TEX:897-907). The source uses them at exactly one place: as the hypotheses of Lemma 5.17, cited at TEX:911 ("From Lemma arate_0"). Their content enters T02 only through `hL03`. `T02_L03Consumed` is by `rfl` literally `∀ δ<1, Paper.L03.Concl U gU eps L δ` (probe `example … := rfl`). That is the conclusion of `Paper.L03.L03_main`, whose hypotheses are `hL02, heps, hL, hexp, hosc, hosc2` (`L03.lean:345-347`).

Confirmation: in the probe theorem `composed`, I discharged `hL03` by `L03_main … hexp hosc hosc2` inside `T02_main`. `#pv_hyp_usage` then reports `hexp`, `hosc`, `hosc2` all **USED**, with axioms standard. So the three premises are not superfluous: they are consumed at reconnection, and they must stay in the statement for fidelity and reconnection. They are not external parameters and not conditions.

## 4. Infrastructure (item 8): individual records

| Constant | Record | Verdict |
|---|---|---|
| `Paper.Defs.E`, `H._proof_1`, `HypExplode`, `leapfrogStep`, `leapfrogState` (+`match_1`), `xLF` | `L02_final.md` §4, `L01_final.md` §5 (individual rows) | covered |
| `Paper.Defs.pLF`, `piDens`, `accProb`, `tailMomFilter`, `HypOscillation2` | `L03_final.md` §4 (individual rows) | covered |
| `Paper.L03.Concl`, `Paper.L03.HypOscillations3`, `HypOscillations3._proof_1` | `L03_final.md` §4 | covered |
| `Paper.Defs.IsGradField` | **audited here**: `∀ x, HasGradientAt U (gU x) x`. This is "U differentiable, ∇U" (TEX:320, 332); `gU` is the true gradient. Non-vacuous (`w_grad` in the probe) | PASS |
| `Paper.Defs.IsGradField._proof_2` | audited here: `#print` gives `CompleteSpace (E d) := complete_of_proper`, an instance proof with no content | PASS |
| `Paper.T02.gaussMeas` | audited here: Lebesgue with density `(2π)^{-d/2} e^{-‖p‖²/2}` = `N(0,I)` (TEX:366, M=I) | PASS |
| `gaussMeas._proof_1/2/3`, `targetMeas._proof_4`, `GeomErgodic._proof_5` | audited here: `#print` gives `Module.Finite`, `BorelSpace`, `(0+2).AtLeastTwo`, `IsScalarTower`, `OuterMeasureClass` instance proofs; standard axioms | PASS (no content) |
| `Paper.T02.targetMeas` | audited here: `Z⁻¹ · e^{-U} dx` (TEX:320); `Z<∞` is the premise `hπ` | PASS |
| `Paper.T02.rejProb` | audited here: `1 − ∫ α(x,x_{Lε}) μ_G(dp)` = TEX:922, 278 | PASS |
| `Paper.T02.hmcStep` | audited here: Algorithm 1, accept `x_{Lε}` with probability α, else stay; its MH form `αQ + rδ_x` is proved as S6 (TEX:274-279) | PASS |
| `Paper.T02.hmcPow` (+`match_1`) | audited here: `P^0 = δ_x`, `P^{n+1}(x,·) = ∫P^n(x,dy)P(y,·)` | PASS |
| `Paper.T02.tvDist` | audited here: `sup_A |μA − νA|` (TEX:267). A factor 2 relative to other conventions does not matter for (geoerg) | PASS |
| `Paper.T02.GeomErgodic` | audited here: eqn:geoerg (TEX:265-267). `∃ρ∈[0,1)`, π-a.e. finite `M`, bound `∀x,n`. The `∀x` form is equivalent to the π-a.e. form (set `M = ∞` on the exceptional null set), and `ρ ≥ 0` loses nothing (`ofReal` clips). So `¬GeomErgodic` is neither weakened nor strengthened | PASS |
| `Paper.T02.Prop35`, `Prop35Rand` | audited here: external (ii). Restriction of Prop. 3.5 (TEX:300-302) to the encoded HMC kernels with the standing conventions; premise `esssup_π r = 1`. Not goal-shaped: it needs the separately proved `esssup r = 1`. Gate-approved | PASS (as parameters) |
| `Paper.T02.GaussFacts` | audited here: external (v). (a) `μ_G` is a probability measure; (b) `μ_G(‖p‖ ≤ R^δ) → 1` for `δ>0`. Both are true standard facts | PASS (as parameter) |
| `Paper.T02.T02_L03Consumed` | audited here: `rfl`-equal to the conclusion type of `L03_main` (probe); positions only. Dischargeable: `w_L03` in the probe proves it for a concrete instance via `L03_main`, `L02_main` and `L01_main` | PASS |
| `Paper.T02.A1Law` | audited here: A1 (TEX:393) with `s>0`, `𝔏` a probability on ℕ, `𝔏{0}=0` (TFA-5). The moment clause is unused (an extra premise, allowed). Satisfiable (`w_A1`) | PASS |
| `Paper.T02.rejProbRand`, `hmcStepRand`, `hmcPowRand`, `GeomErgodicRand` | audited here: the 𝔏-mixture of the fixed-`L` objects, with `L` independent of `x` (TEX:381, 934-935); same geoerg form | PASS |

No constant encodes the target conclusion.

Helpers not in the snapshot (item 9), each read in full:

| Helper | Content | Judgement |
|---|---|---|
| `gU_meas`, `step_meas`, `lf_meas`, `acc_meas` | measurability of ∇U (gradient = fderiv), leapfrog map and α | technical |
| `acc_nonneg`, `acc_le_one`, `intg01`, `J01` | `0 ≤ α ≤ 1`, integrability, `0 ≤ ∫α dμ_G ≤ 1` | technical ("bounded by one", TEX:938) |
| `tail_ne_zero` | `π{‖x‖>R} ≠ 0` (open nonempty set, `e^{-U}>0`, `0<Z<∞`) | technical; supports the implicit step at TEX:932 |
| `essSup_one_of` | `r ≤ 1` and `r → 1` at ∞ give `esssup_π r = 1` | technical, FAIR_IMPLICIT_STEP F2 |
| `step_apply`, `step_le_one` | the kernel on measurable sets as a lintegral; mass ≤ 1 | technical (used by S6, SR4) |

## 5. Route fidelity

Fixed `L` (TEX:911-932):

| Source | Lean | Faithful? |
|---|---|---|
| 911 "Fix any δ<1" | `T02_main` fixes `δ = 1/2` | yes; FAIR_IMPLICIT_STEP F1 (see below) |
| 911-916 "From Lemma arate_0", sup α → 0 | S1: unfold `hL03 δ` (Tendsto along `tailMomFilter`) into the uniform ε-R form | yes, the printed L03 conclusion only |
| 917-921 Gaussian tail → 0 | S2 from `GaussFacts` (b) and complement | yes |
| 922-925 `1 − r = ∫α dμ_G` | S3, by the definition | yes |
| 926-931 split at `‖p0‖ ≤ ‖x0‖^δ`, bound by sup + tail | S4 (`α ≤ κ` on the region, `α ≤ 1` off it) | yes |
| 930 "→ 0", 932 "r(x0) → 1" | S5 (κ/2 + κ/2) | yes |
| 932 "Prop. prop:supr then implies" | S7 (`r ≤ 1`), S8 (`esssup r = 1`), S9 (`Prop35`) | yes; FAIR_IMPLICIT_STEP F2, F3 |

Random `L` (TEX:934-940). **Faithfulness question asked by the coordinator: the encoding is faithful.**

| Source | Lean | Faithful? |
|---|---|---|
| 934-935 `L ~ 𝔏` position-independent, as in A1 | `Lmeas : Measure ℕ` independent of `x`; `A1Law`; kernel `hmcStepRand = 𝔏`-mixture of `hmcStep` | yes (TFA-5 approved) |
| 936-937 "argument applied conditional on each fixed L" | hypotheses `hL03 l`, `hosc2 l` for every `l ≥ 1` with `𝔏{l} ≠ 0` (TFA-6); SR1 reruns S1, S3, S5 for each such `l` | yes |
| 937-938 "conditional acceptance → 0, bounded by one" | SR1 (`∫α_l dμ_G → 0`), `J01` (`0 ≤ · ≤ 1`) | yes |
| 938-940 "law of L does not depend on x0, dominated convergence" | SR2: `tendsto_integral_filter_of_dominated_convergence` on ℕ, dominating function `1`, a.e. limit via `ae_iff_of_countable` | yes; exactly the cited argument |
| 940 unconditional acceptance → 0 | SR2 result, then SR3 (`r → 1`) | yes |
| 935-936 "the same conclusion follows" (Prop. 3.5 for this kernel) | SR5 (esssup = 1), SR5' (`r ≤ 1`), SR6 (`Prop35Rand`) | yes; F2, F3 for the random kernel |

No route change. Nothing stronger than the source is used: L03 appears only in its printed conclusion, Prop. 3.5 only in a specialisation, and the Gaussian facts are standard. S6 and SR4 (MH-type form of the kernels) are proved, though not consumed by the main theorems; they document F3.

FAIR_IMPLICIT_STEP entries:
- **F1** (TEX:911, 917-921). The proof says "Fix any δ<1", but the second display, `μ_G(‖p0‖ > ‖x0‖^δ) → 0`, is false for `δ ≤ 0`. For example, at `δ = 0` it is the constant `μ_G(‖p0‖>1) > 0`. The argument needs only one `δ ∈ (0,1)`. Lean takes `δ = 1/2`. Classification: EDITORIAL for "any" (it should read "any δ ∈ (0,1)"); not a gap in the theorem. This is new relative to the gate list.
- **F2** (TEX:932). "r(x0) → 1" implies `esssup_π r = 1`. This needs `r ≤ 1` and `π{‖x‖>R} > 0` for all `R` (`e^{-U}>0`). Filled by S7, `tail_ne_zero`, `essSup_one_of` (gate item 7.3).
- **F3** (TEX:932, 936). Applying Prop. 3.5 requires the HMC kernel (and the 𝔏-mixture) to be of MH type. S6 and SR4 prove the form `αQ + rδ_x`. Applicability with an α that depends on `p0` is left to the external parameter (gate item 7.3, possible DOMAIN_CLARIFICATION, low priority).
- **F4** (TEX:936-937). The hypotheses with `L` (namely (19)) are needed for each `l` in the support of 𝔏 (TFA-6, gate item 7.1).

## 6. Non-vacuity

Probe `final_T02_probe.lean` (exit 0). Nontrivial witness on `E 1`: `U x = ‖x‖⁴/4`, `∇U x = ‖x‖² x`, `ε = 1`, `L = 2`. Proved in the probe:
- `IsGradField` (`w_grad`);
- `∫⁻ e^{-U} < ∞` (`w_pi`, Gaussian domination);
- (17), revised (18) and (19) (`w_explode`, `w_osc3`, `w_osc2`);
- `T02_L03Consumed` from `L03_main ∘ L02_main ∘ L01_main` (`w_L03`).

From these:
- `nonvac_main : Prop35 → GaussFacts → ¬GeomErgodic (UW 1) (gW 1) 1 2`.
- Random `L`: `𝔏 = (δ_1+δ_2)/2` satisfies `A1Law` (`w_A1`), giving `nonvac_randL : Prop35Rand → GaussFacts → ¬GeomErgodicRand …`.

Axioms of `nonvac_main`, `nonvac_randL` and `composed`: propext, Classical.choice, Quot.sound. Only the external inputs remain open in these witnesses. `GaussFacts` is a true standard fact, and `Prop35`/`Prop35Rand` are specialisations of a published proposition. They are not refuted by anything here (not proved either; they are visible parameters).

## 7. Status for the authors

Verified: Theorem 5.14 for fixed `T = Lε` (TEX:895-932), and the random-`L` extension (TEX:934-940), both along the source route.
They depend on Lemma 5.17 (consumed clause, to be reconnected), Prop. 3.5 for the HMC kernel and for its 𝔏-mixture (cited, Roberts–Tweedie 1996), and standard Gaussian facts.
Source: no error or gap. Editorial: "Fix any δ<1" should be "δ ∈ (0,1)" (TEX:911/917-921 fails for δ ≤ 0). The implicit steps F2–F4 are listed above.

## 8. Records to correct

- `EXTERNAL_TOOLS.md` / registry: `T02_Prop35`, `T02_GaussFacts`, `T02_Prop35Rand` and `T02_L03Consumed` currently say "not a condition of any result". All four are used conditions of T02:
  - `T02_main` uses L03Consumed, Prop35 and GaussFacts;
  - `T02_main_randL` uses L03Consumed, Prop35Rand and GaussFacts.
- The registry Lean lines `T02Stmt.lean:78` and `:88` point at docstrings; the definitions are at `:82` and `:92`.
- `pv_audit_mech.py` item 11 under-traced the conditions for T02 (see §1).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: T02_L03Consumed, T02_Prop35, T02_GaussFacts, T02_Prop35Rand

# L03 final audit (Lemma 5.17, lem:arate_0), revised manuscript

- Auditor: pv-auditor (independent subagent, opus), session 13bf576d, 2026-10-13
- Audited object: `pv_work/L03.lean` (no gap file; prover reports none, and the walk finds no `sorryAx`)
- Source read directly: source/geo_erg_HMC_v3.1.tex:1011-1096 (statement and proof), 893-909 (hypotheses (17)-(19), revised (18)), 330-336 and 361-374 (leapfrog, Prop. 4.2 / eqn:mprop2); L02 statement through `pv_work/L02Stmt.lean` (TEX:960-966).
- Also read: gate report `verification/audits/L03_gate.md`, `pv_work/L03Stmt.lean`, `pv_work/L02Stmt.lean`, `pv_work/Defs.lean`, prover notes `pv_work/notes/L03_prover_notes.md`, infrastructure records in `L01_final.md`, `L02_final.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L03` -> `verification/audits/L03_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L03` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL `0a045055…` |
| 3 | PVTools hash | PASS |
| 4 | 19 gated fingerprints vs gate snapshot | PASS |
| 5 | Defs vs DEFS snapshot | PASS |
| 6 | `#pv_axioms L03` | ALL STANDARD |
| 7 | `#pv_walk L03` | no `sorryAx`; axioms propext, Classical.choice, Quot.sound |
| 11 | traced conditions | `L03_L02Consumed` |
| 12 | last writers | prover (L03.lean), drafter (L03Stmt.lean) |

Item 10 notes: S11 has `heps`, `hγ` UNUSED (step lemma, harmless, already noted by the gate; no main-theorem premise is unused). S4b warning (11 type binders, 9 bound by the proof term): the 2 extra binders are the conclusion's own `∀ i, i < L →`, introduced by `intro` in the proof; they are not hypotheses. All 13 binders of `L03_main` USED.

## 2. Gap files

None (no `L03ModGaps.lean`; walk confirms no `sorryAx`). Not applicable.

## 3. Per-theorem conditionality

Probe `pv_work/probes/auditor/L03/final_L03_r1_probe.lean` (exit=0, log `pv_work/logs/final_L03_r1_probe_2.log`), `#pv_hyp_usage`:

| Theorem | `hL02` | other |
|---|---|---|
| `L03_S4a` | USED (stepwise clause, `(hb …).1`) | `C` USED |
| `L03_S7` | USED (via private `core`: `3^L‖x0‖ ≤ ‖x_L‖`, `(ha …).2`) | `hexp`, `heps` USED |
| `L03_S10` | USED (via `core`, same clause) | `hexp`, `heps` USED |
| `L03_S13` | USED (`3^L` clause, read in proof text line 311) | `hosc2` USED |
| `L03_S4b` | n/a | `hosc` (revised (18)) USED |

So `L03_L02Consumed` is genuinely used, at TEX:1023-1025 (S4a, stepwise), TEX:1049-1051 (S7), TEX:1076-1083 (S10), TEX:1092 (S13), both clauses of L02. `core` is private (not addressable by `#pv_hyp_usage`); I read its text: `hL02 δ hδ` is destructured and `.2` used at line 57. No other external parameter exists.

## 4. Infrastructure (item 8): individual records

| Constant | Record | Verdict |
|---|---|---|
| `Paper.Defs.E`, `H._proof_1`, `HypExplode`, `leapfrogStep`, `leapfrogState` (+`match_1`), `xLF` | `L02_final.md` §4 (individual rows) | covered |
| `Paper.L02.Concl` | `L02_final.md` §4 | covered |
| `Paper.Defs.pLF` | audited here: second component of `leapfrogState` = `p_{iε}`, TEX:330-336 | PASS |
| `Paper.Defs.piDens` | audited here: `exp(-U x)`, unnormalised π ∝ e^{-U} (TEX:320); only ratios used | PASS |
| `Paper.Defs.accProb` | audited here: `min 1 (π(x_L)/π(x_0) · exp(½‖p0‖² − ½‖p_L‖²))` = Prop. 4.2 (TEX:368); equals TEX:1021 by S1 | PASS |
| `Paper.Defs.tailMomFilter` | audited here: `comap ‖q.1‖ atTop ⊓ 𝓟{‖q.2‖ ≤ ‖q.1‖^δ}` = "‖x0‖→∞, ‖p0‖≤‖x0‖^δ", uniform over the region (TEX:1014, 1094-1095). Non-trivial: `filter_neBot` proved in probe for d = 1 | PASS |
| `Paper.Defs.HypOscillation2` | audited here: (19) TEX:905-907, filter `‖x‖→∞ ⊓ {2^L‖x‖ ≤ ‖y‖}`, `atBot` | PASS |
| `Paper.L02.Concl._proof_1`, `Paper.L03.HypOscillations3._proof_1` | `#print`: `(1+2).AtLeastTwo` numeral instance proofs, no axioms | PASS (no content) |
| `Paper.L03.HypOscillations3` | audited here: exact revised (18) TEX:900-903 (`‖y‖ ≥ 3‖x‖ ≥ C ⇒ ‖∇U(y)‖ ≥ 3‖∇U(x)‖`), C fixed first | PASS |
| `Paper.L03.Concl` | audited here: Tendsto of `accProb` along `tailMomFilter d δ` to 𝓝 0 = TEX:1014 | PASS |
| `Paper.L03.L03_L02Consumed` | audited here: `∀ δ<1, Paper.L02.Concl gU eps L δ`, exactly L02's printed conclusion (TEX:960-966); positions only, not goal-shaped. Dischargeable: probe `w_L02` proves it from `Paper.L02.L02_main` + `Paper.L01.L01_main` | PASS |

All are definitions; none encodes the target conclusion.

Helpers not in the snapshot (item 9), each read:

| Helper | Content | Judgement |
|---|---|---|
| `pLF_succ` | unfold one leapfrog step for p (TEX:332-334) | technical |
| `geom_third` | `2Σ_{i=1}^L 3^{-i} = 1 − 3^{-L}` (TEX:1043-1047) | technical arithmetic |
| `ev_tail` | eventually `η < ‖x0‖ ∧ ‖p0‖ ≤ ‖x0‖^δ` in tailMomFilter | technical filter unpacking |
| `explode_thresh` | (17) as threshold `‖y‖ > R ⇒ K‖y‖ ≤ ‖∇U(y)‖` | technical (definition of limit) |
| `core` | (17) + L02 `3^L` clause ⇒ `2‖x0‖ ≤ c‖∇U(x_L)‖` and `‖p0‖ ≤ ‖x0‖` for large ‖x0‖ (any c>0) | exactly TEX:1049-1051 / 1076-1083 shared; no new mathematics |

## 5. Route fidelity

| Source | Lean | Faithful? |
|---|---|---|
| 1019-1022 recall α | S1: unfold `accProb`, `piDens`, exp algebra | yes |
| 1030-1036 first inequality (reverse triangle, with eqn:mprop2 TEX:372) | S2 (eqn:mprop2 derived from leapfrog defs by induction), S3 (norm_sub_le, norm_sum_le) | yes |
| 1023-1024 "Lemma lem:xlower applies and 3‖x_i‖ ≥ C" | S4a: L02 stepwise clause; ‖x_i‖ ≥ ‖x0‖ by iterating it; η ≥ C/3 | yes; FAIR_IMPLICIT_STEP (monotonicity ‖x_i‖ ≥ ‖x0‖ from stepwise, filled by induction) |
| 1025-1029 eqn:gradgeometric "using (stepwise) and (oscillations)" | S4b: revised (18) on consecutive pairs (x_j, x_{j+1}), iterated | yes |
| 1036-1040 second inequality | S5: reindex i ↦ L−i and absorb (ε/2)‖∇U(x0)‖ ≤ ε3^{-L}G into the i = L term | yes; FAIR_IMPLICIT_STEP (as the gate ruled) |
| 1041-1047 geometric sum | S6 | yes |
| 1049-1051 RHS positive by (17) and ‖x_L‖ ≥ 3^L‖x0‖ | S7 via `core` (needs ‖p0‖ ≤ ‖x0‖^δ ≤ ‖x0‖ for ‖x0‖ > 1) | yes; FAIR_IMPLICIT_STEP (‖x0‖ > 1 within "sufficiently large") |
| 1052-1065 squaring | S8 (`pow_le_pow_left₀` on 0 < a−b ≤ P) | yes |
| 1066-1075 eqn:kinetic | S9 algebra | yes |
| 1076-1083 two bounds | S10 via `core` | yes |
| 1084-1085 RHS ≤ −‖x0‖² | S11 (nlinarith; holds with slack) | yes |
| 1086-1091 | S12 | yes |
| 1092-1093 (19) with 3^L ≥ 2^L | S13: compose (19) with q ↦ (q.1, x_L) | yes |
| 1093-1095 α → 0 uniformly | S14: exp → 0 at −∞, min with 1, eventual bound | yes |

No route change, no stronger result than the source uses (L02 only in its printed form; (18) only in its revised printed form; (17), (19) as printed). Context premises: `0 < ε` (TEX:336), `1 ≤ L` (TFA-1, approved by gate from TEX:908). The source context `IsGradField U gU` and `U ≥ 0` are not assumed (Lean statement is more general; harmless).

## 6. Non-vacuity

Probe `final_L03_r1_probe.lean` (exit=0): nontrivial witness on `E 1`, `gU x = ‖x‖²•x`, `U x = ‖x‖⁴/4`, `ε = 1`, `L = 2`. Proved `HypExplode`, `HypOscillations3` (C = 0), `HypOscillation2`, and `L03_L02Consumed` (from `L02_main` and `L01_main`); `nonvac : Concl (UW 1) (gW 1) 1 2 δ` for every δ < 1; `filter_neBot`: `tailMomFilter 1 δ` is not ⊥, so the limit statement has content. Axioms of both: propext, Classical.choice, Quot.sound.

## 7. Status for the authors

Verified: Lemma 5.17 (α(x0, x_{Lε}) → 0 uniformly over ‖p0‖ ≤ ‖x0‖^δ, every δ < 1) along the revised proof TEX:1018-1096, under (17), revised (18), (19), ε > 0, L ≥ 1.
Depends on: the conclusion of Lemma 5.16 (L02) as printed (now UNCONDITIONAL; reconnection to follow).
Source: no errors or gaps found; implicit steps (reindexing/absorption at 1036-1040, ‖x0‖ ≥ 1 at 1076-1083, ‖x_i‖ ≥ ‖x0‖ at 1023-1024) are FAIR_IMPLICIT_STEP.

## 8. Records to update

`verification/EXTERNAL_TOOLS.md` entry `L03_L02Consumed` is stale: it says line `L03Stmt.lean:25`, "growth by 2^L", "per-step doubling", "used by S4a, S9, S11", "L02 carries an open PAPER_ARGUMENT_GAP". Actual: `pv_work/L03Stmt.lean:39`, `3^L` and per-step tripling (revised L02), used in S4a, S7, S10, S13; L02 is now UNCONDITIONAL.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: L03_L02Consumed

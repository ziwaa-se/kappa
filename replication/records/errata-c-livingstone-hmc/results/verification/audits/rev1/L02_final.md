# L02 (Lemma 5.16, lem:xlower): final audit (gap file)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5); not drafter, gate, prover or issue-checker of L02.
- Timestamp: Tue Oct 13 01:14:38 EDT 2026 (`date`).
- Audited object: `pv_work/L02ModGaps.lean` sha256 `dee04179…48930b`; `pv_work/L02.lean` `c3c7f688…19bb0e0`; `pv_work/L02Stmt.lean` `a4fe112e…6f294` (= gate r2).
- Source read directly: `source/geo_erg_HMC_v3.1.tex` 358-375 (Prop 4.2), 860-935 (Thm 5.14 hypotheses, L01, L02 statement and proof).
- Also read: `L02_gate_r2.md`, `L02_prover_notes.md`, `L02_issue_1_audit.md`, `L02Stmt.lean`, `L01Stmt.lean`, `L01.lean` (main), `Defs.lean` 30-89, VERIFICATION_METHODS §2b, VERDICTS §1.
- Audited files not modified. Probes: `pv_work/probes/auditor/L02/final_L02_gapcheck.lean`, `final_L02_nonvac.lean`.

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py L02 --module L02ModGaps`, run by me)

Report `verification/audits/L02_mech.md`: **MECH CHECKS: PASS**.

| Item | Result |
|---|---|
| 1 compile `L02ModGaps` | PASS (exit 0, 0 sorry) |
| 2 private rebuild sha256 | IDENTICAL |
| 3 PVTools hash | PASS |
| 4 19 gated fingerprints vs `L02_gate_r2.md` | all identical |
| 4b gap defs | `L02_main_fixedDelta_Gap` vh = th(L02_main_fixedDelta) = 397542044; `L02_main_Gap` vh = th(L02_main) = 3808770304 |
| 5 Defs vs DEFS_gate | identical |
| 6-7 axioms / walk | ALL STANDARD; sorryAx not reached |
| 10 hyp usage | UNUSED: `hδ` in S11, `heps` in S8b (harmless superfluous premises of step obligations; gated, so left as is) |
| 11 traced conditions | none (registry empty; see §4: the consumed clause `L02_L01Consumed` is USED but unregistered) |

## 2. Gap file: exact-statement check (§2b)

Probe `final_L02_gapcheck.lean` (log `pv_work/logs/final_L02_gapcheck_1.log`, exit 0, 2 sorry = the two verbatim copies):

| Check | Result |
|---|---|
| verbatim copy of `L02_main_fixedDelta` (Draft l.22-24) under original name: th | 397542044 = gate snapshot |
| verbatim copy of `L02_main` (Draft l.14-16): th | 3808770304 = gate snapshot |
| `L02_main_fixedDelta_Gap = type_of% @L02_main_fixedDelta := rfl` | compiles |
| `L02_main_Gap = type_of% @L02_main := rfl` | compiles |
| `example (g : _Gap) : type_of% @L02_main_fixedDelta := L02_main_fixedDelta_mod_gaps g` (and for `L02_main`) | compiles |
| `diff L02.lean L02ModGaps.lean` | differs only at the two stopped main theorems (sorry vs Gap def + `_mod_gaps`); S1-S11, helpers, `L02_main_fixedDelta_osc` identical |

The gaps are the two stopped main theorems themselves (stop at S8b, TEX:930). No other obligation is gap-dependent.

## 3. Per-theorem conditionality (`#pv_hyp_usage`, `#pv_walk_decl`)

| Theorem | `hL01` (L01 clause) | `hosc` (18) | Note |
|---|---|---|---|
| S1, S1_general, S2, S5, S7, S11 | not a premise | not a premise | pure leapfrog algebra / telescoping |
| S3 | not a premise | not a premise | (17) only |
| S4, S6, S8a | USED | not reached | walk: `HypOscillations` absent |
| S8b | USED | USED (positive control: walk reports `HypOscillations` via S8b) | printed (18) step |
| S9, S10, `gen`, `L02_main_fixedDelta_osc` | USED | USED (walk: via S8b and private `gen`) | |
| `L02_main_fixedDelta_mod_gaps`, `L02_main_mod_gaps` | passed to Gap only | — | not verified content |

`hL01` is actually used at: S4 (`‖x_ε‖>2‖x_0‖` so (17) applies at `x_ε`, TEX:912), S8a (TEX:930 first sentence), S8b (pair `(x_0,x_ε)` for (18), TEX:930), S10 i=1, `gen` base case. `hosc` is an explicit premise of the auxiliary theorem only, not an external parameter.

## 4. Infrastructure (item 8/9)

| Constant(s) | Record | Status |
|---|---|---|
| `Defs`: E, HypExplode, HypOscillations, leapfrogStep, leapfrogState, xLF (+ aux proofs) | DEFS_gate.md | definitions; gate PASS, unchanged |
| `L01Stmt`: `ConclFixedDelta` | L01_gate.md (and L01_final.md, L01 UNCONDITIONAL) | definition only |
| `L02Stmt`: Concl, ConclFixedDelta, L02_L01Consumed | L02_gate_r2.md | definitions only |

No earlier theorem is in the closure. Helpers reviewed one by one (item 9):

| Helper | Content | Judgement |
|---|---|---|
| xLF_zero/one/rec | unfolding `leapfrogStep` (TEX:331-335) | technical |
| xLF_diff | `x_{n+1}-x_n = εp_0 - (ε²/2)∇U(x_0) - ε²Σ_{1≤j≤n}∇U(x_j)`; difference form of eqn:mprop (TEX:364) | technical; proved from definitions |
| hbig | unfolds (17) filter to `∃R, ‖x‖>R → M‖x‖ ≤ ‖∇U(x)‖` | technical |
| ple | `‖p_0‖ ≤ ‖x_0‖^δ ≤ ‖x_0‖` for `‖x_0‖ ≥ 1` | FAIR (TEX:896 "negligibly small") |
| norm5, x1_bound, step_bound | triangle inequalities (TEX:890, 914, 920) | technical |
| seq_mono, seq_sum | real-sequence bookkeeping | technical |
| gen | general step i≥4 (TEX:934 "entirely analogous") | see §5; true, non-vacuous, does not assume the conclusion |

## 5. Route fidelity (source sentence vs Lean)

| Source | Lean | Judgement |
|---|---|---|
| TEX:906 formula for `x_{2ε}` | S1 by unfolding | faithful |
| TEX:910 ratio bound | S2 (printed coefficient ε²/2 on ‖∇U(x_ε)‖, weaker valid form) | faithful |
| TEX:913-916 (inter21), "δ>0 arbitrarily small" | S3 (renamed δ' to avoid clash with momentum δ) | faithful; FAIR_IMPLICIT_STEP: (17) + `‖p_0‖ ≤ ‖x_0‖` gives the second inequality |
| TEX:912 "RHS ≥ 2 amounts to upper bounding the middle term" | S4: first term ≥ 5+ε by (17) at `x_ε` (needs L01), middle ≤ 2 by S3 (δ'=1/2), last ≤ ε | FAIR_IMPLICIT_STEP: first term large by (17) at `x_ε`, `‖x_ε‖ ≥ 2‖x_0‖` from Lemma 5.15 |
| TEX:920 ratio for `x_{3ε}` | S5 via one-step identity (m=2) | faithful |
| TEX:922-925 reciprocal bound | S6 from S3 and S4 (`‖x_{2ε}‖ ≥ ‖x_ε‖`) | faithful |
| TEX:928 | S7 by triangle inequality from S1 | faithful |
| TEX:930 "second and last terms arbitrarily small" | S8a: (17) at `x_ε`, L01 | FAIR_IMPLICIT_STEP |
| TEX:930-932 "Envoking (18) gives ≤ 1/6" | S8b: (18) on `(x_0,x_ε)` with `2‖x_0‖ ≥ C` | faithful to the printed route; this is the step not justified by the lemma's hypotheses (issue 1) |
| TEX:934 `‖x_{3ε}‖ ≥ 2‖x_{2ε}‖` | S9 combines S4-S8b, first term large by (17) at `x_{2ε}` | faithful; FAIR_IMPLICIT_STEP for the first term |
| TEX:934 "entirely analogous ... any fixed i" | S10: i=1 L01, i=2 S4, i=3 S9, i≥4 `gen` | FAIR_IMPLICIT_STEP, filled per gate A3 (one-step identity, (18) on consecutive pairs, (17) at `x_{(i-1)ε}`). The middle terms are bounded together by the (18) chain `3g_{j-1} ≤ g_j ⇒ g_0+Σg_j ≤ g_{m}/2` and not term by term by reciprocals; `gen` also re-derives the i=2,3 links by this argument (using (18) where the printed i=2 step does not). Same ingredients the source invokes; noted, not a provenance debt for the verdict-bearing object (which is stopped) |
| TEX:934 "establishing the result" | S11 telescoping; `L02_main_fixedDelta_osc` = S10+S11 | faithful |

No stronger result than the source is used; eqn:mprop is proved (S1_general), not assumed. The prover did not replace the TEX:930 justification: the verdict-bearing theorem is stopped there.

## 6. Non-vacuity

Probe `final_L02_nonvac.lean` (log `pv_work/logs/final_L02_nonvac_1.log`, exit 0, 0 sorry, `#print axioms nonvac` = [propext, Classical.choice, Quot.sound]):
- non-trivial witness on `E 1`: `∇U(x) = ‖x‖² x`; proved `HypExplode` and `HypOscillations` (C = 0);
- `L02_L01Consumed` at the witness obtained from the audited `Paper.L01.L01_main_fixedDelta`;
- `L02_main_fixedDelta_osc` instantiated (ε = 1, L = 3) gives `ConclFixedDelta`;
- the region `η < ‖x_0‖, ‖p_0‖ ≤ ‖x_0‖^δ` is non-empty for every η, δ (p_0 = 0).

## 7. Verdict reasoning

- Issue 1 (PAPER_ARGUMENT_GAP at TEX:930-933, analogous step TEX:934) is independently confirmed (`L02_issue_1_audit.md`: REVIEW: CONFIRMED). The verdict-bearing `L02_main_fixedDelta` is only available modulo its Gap, so the result is ISSUE (VERDICTS §1.3, gaps never support a verified verdict).
- Still verified (clean, standard axioms, gated statements): S1-S11 and the auxiliary `L02_main_fixedDelta_osc` (the conclusion under (17)+(18)), conditional on the L01 clause `L02_L01Consumed`. L01 is FINAL_PASSED UNCONDITIONAL, so this clause can be discharged by reconnection; `L02_L01Consumed` is not yet registered in `external_tools` (record gap).
- Not an external parameter: `hosc` (18), an explicit premise of the auxiliary theorem.

## 8. Status for the authors

Verified in Lean along the printed route: all steps of the proof of Lemma 5.16 and its conclusion `‖x_{Lε}‖ ≥ 2^L‖x_0‖` (fixed-δ reading) under (17)+(18) and Lemma 5.15. Under the printed hypothesis (17) alone the proof does not go through: TEX:930 invokes (18), which the lemma does not assume (PAPER_ARGUMENT_GAP; the conclusion itself appears true, so minor). The general step (TEX:934, "entirely analogous") is not written out; editorial: "Envoking" (TEX:930).

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: L02_L01Consumed

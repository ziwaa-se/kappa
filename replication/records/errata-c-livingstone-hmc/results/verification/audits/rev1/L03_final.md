# L03 (Lemma 5.17, lem:arate_0) — final audit

- Auditor: pv-auditor (independent subagent, opus), session 094f9f86; date: Tue Oct 13 01:10:31 EDT 2026 (`date`)
- Audited object: `pv_work/L03.lean` (no gap file; prover notes report no stopped obligations)
- Read directly: source TEX:328-374 (leapfrog, Prop 4.2), 862-877 (hypotheses (17)-(19), Thm 5.14), 899-935 (L02 statement and proof), 937-971 (L03 statement and proof); `pv_work/L03.lean` (full), `pv_work/L03Stmt.lean`, `pv_work/L02Stmt.lean`, `pv_work/Defs.lean:30-92`; gate report `verification/audits/L03_gate.md`; prover notes `pv_work/notes/L03_prover_notes.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L03` -> `verification/audits/L03_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | check `L03` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (08adbb31…) |
| 3 | PVTools hash | PASS |
| 4 | 15 gated fingerprints vs `L03_gate.md` | PASS (all th/vh/bi identical) |
| 5 | Defs vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms L03` | PASS, ALL STANDARD |
| 7 | `#pv_walk L03` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 10 | hyp usage | UNUSED only `hδ` in S4b and `hb` in S6 (step-level redundant premises, gate already noted `hb` redundant; not external parameters, harmless) |
| 11 | TRACED CONDITIONS | none (see §4: this is because `L03_L02Consumed` is not yet registered; corrected below) |

No gap file: §2b checks not applicable.

## 2. Axioms / sorry

Items 6-7 PASS. Probe `pv_work/probes/auditor/L03/auditor_L03_nonvac.lean` (log `pv_work/logs/auditor_L03_nonvac_3.log`, exit 0) re-confirms `'Paper.L03.L03_main' depends on axioms: [propext, Classical.choice, Quot.sound]`.

## 3. Per-theorem conditionality

The only external parameter (provenance (p)) is `hL02 : L03_L02Consumed gU eps L`. `pv_status.py tools` lists an **empty registry**, so the script could not trace it; it is nevertheless a visible parameter of `L03_main`, reported USED.

| Theorem | `hL02` | Where actually consumed (source code + `#pv_hyp_usage`) |
|---|---|---|
| `L03_main` | USED | passed to S10 and S11 |
| `L03_S10` | USED | passed to S4a and S9 |
| `L03_S4a` | USED | leaf use: `hL02.2 δ hδ` (part (b), consecutive doubling, TEX:934) — TEX:954 step |
| `L03_S9` | USED | leaf use: `hL02.1 δ hδ` (part (a), L02 printed statement) — TEX:968 |
| `L03_S11` | USED | leaf use: `hL02.1 δ hδ` (part (a)) — region of (19), TEX:970 |

Both parts are really used (part (b) only in S4a). Paper hypotheses `hexp` (S9), `hosc` (S4a), `hosc2` (S11), `heps`, `hδ`, and TFA `hL : 1 ≤ L` (S2/S3/S4b/S10) are all USED; they are printed hypotheses or gate-approved TFA, not conditions.

## 4. Infrastructure (item 8 / item 9)

| Constant(s) | Kind | Covering record / my check |
|---|---|---|
| `Paper.Defs.*` (14) | definitions | `DEFS_gate.md` (fingerprints identical); I re-read `leapfrogStep`, `xLF`, `pLF`, `accProb`, `tailMomFilter`, `HypExplode`, `HypOscillations`, `HypOscillation2` against TEX:331-336, 366-369, 865-875: faithful |
| `Paper.Defs.HypOscillations._proof_3`, `Paper.L02.Concl._proof_1`, `Paper.L03.L03_L02Consumed._proof_1` | numeral `AtLeastTwo` auto-proofs | printed; "does not depend on any axioms"; no content |
| `Paper.L02.ConclFixedDelta` | definition | `L02_gate_r2.md`; used only inside the consumed clause |
| `Paper.L03.L03_L02Consumed` | (p) clause definition | `L03_gate.md` item 6 (approved, with registry note) |
| no in-project **theorem** from another module is in the closure | — | no interface walk needed |

Helpers not in snapshot (item 9), reviewed individually:

| Helper | Content | Ruling |
|---|---|---|
| `pLF_succ` | one-step unfolding of the leapfrog momentum, proved by `simp only` on the definitions | technical, true, axioms clean |
| `geom_third` | `2 Σ_{i=1}^L 3^{-i} = 1 - 3^{-L}` by induction | technical (closed form of the bracket at TEX:955/957) |
| `ev_tail` | eventually-membership for `tailMomFilter` | technical filter bookkeeping |

None smuggles the conclusion.

## 5. Route fidelity (sentence by sentence)

| Source | Lean | Ruling |
|---|---|---|
| TEX:947-950 acceptance formula | S1: unfold `accProb`, `exp` algebra | faithful (Prop 4.2, TEX:368) |
| TEX:953 line 1 (from eqn:mprop2, TEX:371-373) | S2 (eqn:mprop2 by induction from leapfrog recursion), S3 (triangle inequality) | faithful; S2 derives the cited Prop 4.2 formula from the definitions rather than assuming it |
| TEX:954 "where (18) is used for the second line" | S4a: (18) on consecutive pairs `(x_{jε}, x_{(j+1)ε})`, using doubling (part (b)) and `‖x_{jε}‖ ≥ ‖x_0‖ ≥ C/2`; S4b: summation with reindexing `i ↦ L-i`, x_0 term absorbed in the `(1/3)^L` term | follows the source; the doubling is what the source needs and is the claim of TEX:934 (see issue candidate A). Index reversal at TEX:954 (`(1/3)^i` paired with `x_{iε}`): EDITORIAL; aggregate inequality correct |
| TEX:955, 957 bracket ≥ γ_L > 0 | S5 with `γ_L = 3^{-L}` exactly (`geom_third`) | faithful (γ_L taken equal to the bracket, an admissible choice) |
| TEX:958-959 squaring | S6 needs `‖p_0‖ ≤ (εγ_L/2)‖∇U(x_{Lε})‖` | FAIR_IMPLICIT_STEP: filled in S10 from the TEX:968 bound (`εγG/2 = 2T ≥ 4‖x_0‖ ≥ ‖p_0‖`) |
| TEX:960 expansion, undefined δ_L | S7 with cross term `εγ_L G b` | EDITORIAL: δ_L = γ_L |
| TEX:962-965 | S8 algebra | faithful |
| TEX:966-969 "for any M<∞ … ≥ M‖x_{Lε}‖ ≥ 2^L‖x_0‖" | S9 for `M ≥ 1` (gate-approved), used with M = 1; first inequality from (17) at `x_{Lε}`, second from L02 (a) | faithful on the instance used (see issue candidate B) |
| TEX:970 "it follows that ‖p_0‖²−‖p_{Lε}‖² ≤ −‖x_0‖²" | S10: `‖p_0‖ ≤ ‖x_0‖^δ ≤ ‖x_0‖` (‖x_0‖>1, δ<1), `T ≥ 2^L‖x_0‖ ≥ 2‖x_0‖`, so `4T(‖p_0‖−T) ≤ −2T² ≤ −‖x_0‖²` | FAIR_IMPLICIT_STEP (routine algebra the source omits; uses `L ≥ 1`, TFA) |
| TEX:970 "envoking (19) gives the result" | S11: exponent ≤ U(x_0)−U(x_{Lε})−½‖x_0‖², with `(x_0,x_{Lε})` in the (19) region by L02 (a); S12: exp → 0, min continuity | faithful |

No route change; no result stronger than the source's used. Generalisation (gate-approved): `IsGradField U gU` is not assumed; the proof never uses it, so the source statement follows by instantiation.

## 6. Gate-suggested issue candidates (my assessment; final classification belongs to pv-issue-checker + review)

- **A. TEX:953-957 / 934 / 899-901 — doubling from L02's proof, not its statement.** The second line of TEX:954 needs (18) on consecutive pairs, hence `‖x_{(i+1)ε}‖ ≥ 2‖x_{iε}‖ ≥ C`. L02's printed statement (TEX:900) and the lead-in TEX:937 give only `‖x_{Lε}‖ ≥ 2^L‖x_0‖`. The needed fact is asserted by the paper itself at TEX:934 ("‖x_{iε}‖ ≥ 2‖x_{(i−1)ε}‖ for any fixed i"). So the gap is in citation/exposition only; the conclusion is not threatened, and the proof of L03 goes through once that internal claim is available. Assessment: EXPOSITION_GAP of low severity (borderline EDITORIAL: L02's statement should be strengthened to the per-step doubling). Not a gap in L03's own reasoning; its truth depends on L02's proof (L02 has its own pending PAPER_ARGUMENT_GAP on the use of (18), which matters for reconnection, not for this audit).
- **B. TEX:966-970 — "for any M<∞".** False for what: the displayed chain `M‖x_{Lε}‖ ≥ 2^L‖x_0‖` fails for M < 1 (e.g. M = 0, x_0 ≠ 0). Credible for what: every M ≥ 1, and the argument needs only one such M (M = 1 suffices, as the Lean proof shows). No range of the conclusion is left uncovered. Assessment: EDITORIAL (over-quantified wording), at most EXPOSITION_GAP; the omitted passage to `≤ −‖x_0‖²` is FAIR_IMPLICIT_STEP.

Neither candidate has been independently confirmed, so neither can make L03 ISSUE in this audit (VERDICTS §1.3). If a review confirms either as a paper-side issue, the result becomes ISSUE with the main clause still verified conditionally on `L03_L02Consumed`.

## 7. Non-vacuity

Probe `pv_work/probes/auditor/L03/auditor_L03_nonvac.lean`, exit 0, 0 sorry:
- Nontrivial witness: `gU x = ‖x‖²·x`, `U x = ‖x‖⁴/4` satisfy (17), (18) (C = 0) and (19) (every L) in every dimension; stated jointly for d = 2.
- The limit region is nonempty arbitrarily far out (d = 1): the conclusion is not vacuous for d ≥ 1.
- `L03_main` applied to a fully discharged instance (d = 0, all hypotheses including `L03_L02Consumed` proved), compiling: the hypothesis set is jointly satisfiable. A full nontrivial instance of `L03_L02Consumed` (d ≥ 1) is exactly L02's conclusion, provided at reconnection; not constructed here.

## 8. Status for the authors

Lemma 5.17 is verified in Lean along the printed proof, under (17)-(19), ε > 0 and L ≥ 1, conditional on Lemma 5.16 in a form that includes the per-step doubling `‖x_{iε}‖ ≥ 2‖x_{(i−1)ε}‖` (proved at TEX:934 but not stated in Lemma 5.16).
Source: the proof is sound; editorial slips: undefined δ_L (TEX:960), reversed index (TEX:954), "for any M<∞" should read "for M ≥ 1" (TEX:966); Lemma 5.16's statement should include the per-step doubling it proves.

## 9. Records to update

- Register `L03_L02Consumed` (provenance p, predecessor L02, `pv_work/L03Stmt.lean:25`, source TEX:899-901 + TEX:934; consumers L03 S4a (part b), S9 and S11 (part a)) in the tools registry; currently absent, which is why item 11 traced no condition.
- Reconnection must use L02's `L02_S10` / `L02_main_fixedDelta_osc` with L03's (18) (gate item 6).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: L03_L02Consumed

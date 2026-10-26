# P05 final audit (Proposition 3.5 `prop:stopping`, source/VSIFP_02.tex:233-240, proof l.473-478)

- Role: pv-auditor (independent subagent, Claude Opus 5.5); not the drafter, gate, prover or issue checker.
- Date: Tue Oct 13 01:52:50 EDT 2026 (from `date`).
- Audited object: `pv_work/P05ModGaps.lean` (sha256 c38f1c3193c96ba15a1b39707dd84b70951173cb6fc36b7cbc531e80b530d602); also compared with `pv_work/P05.lean` (1c62d843…) and `pv_work/P05Stmt.lean` (b267a3ed…, the hash approved by gate r2).
- Read directly: source l.195-252, l.440-495; `P05Draft.lean`, `P05.lean`, `P05ModGaps.lean`, `P05Stmt.lean`, `P04Stmt.lean`; `P05_gate_r2.md`; prover notes; `P05_issue_1.md`; verdict lines of `P04_final.md`.
- Probes: `pv_work/probes/auditor/P05/auditor_P05_final1.lean` (log `pv_work/logs/auditor_P05_final1_1.log`, exit=0, 2 sorry warnings = the two verbatim statement copies), `auditor_P05_final2.lean` (log `pv_work/logs/auditor_P05_final2_1.log`, exit=0, 0 sorry).

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py P05 --module P05ModGaps`, run by me)

Report `verification/audits/P05_mech.md`: **MECH CHECKS: PASS** (9 manual items).

| # | Check | Result |
|---|---|---|
| 1 | compile `P05ModGaps` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (e992ef4b…) |
| 3 | PVTools hash | PASS |
| 4 | 10 gated fingerprints vs `P05_gate_r2.md` | PASS (S0, S1, S2, S3, S4, Sapp, Snn, `P05_P04Consumed` identical) |
| 4b | gap definition `P05_Sbridge_Gap` | MANUAL → PASS by §2b probe (item 2 below) |
| 5 | `Defs` vs `DEFS_gate_r2.md` | PASS |
| 6-7 | `#pv_axioms`, `#pv_walk` | PASS: ALL STANDARD; closure `[propext, Classical.choice, Quot.sound]`; sorryAx not reached |
| 9 | helpers not in snapshot | none |
| 11 | traced conditions | "none": only because `P05_P04Consumed` is not registered in `EXTERNAL_TOOLS.md`; corrected in item 4 below |
| 12 | last writers | PASS (prover for ModGaps, drafter for Stmt) |

The "changed in the gap file" notes for S0-S4, Sapp, Snn in the mech list are generic: item 4 shows their th/vh/bi identical to the gate snapshot, and none of them takes the gap (they are not gap-dependent).

## 2. Gap file exact-statement check (VERIFICATION_METHODS §2b)

Probe `auditor_P05_final1.lean` imports `P05ModGaps`, redeclares `Paper.P05.P05_Sbridge` and `Paper.P05.P05_main` verbatim from `P05Draft.lean` (l.62-67, l.20-27) under their original names (same `variable {Ω : Type*}` header):

| Check | Result |
|---|---|
| `#pv_type_hashes_here`: `P05_Sbridge` th | 864997650 = gate r2 snapshot |
| `#pv_type_hashes_here`: `P05_main` th / bi | 710880581 / `iieeeeeeeeeeeeeeeee` = gate r2 snapshot |
| `example : P05_Sbridge_Gap.{0} = type_of% @P05_Sbridge.{0} := rfl` (also `.{1}`) | compiles: gap is the full ∀-closure of the gated obligation |
| `example (g : P05_Sbridge_Gap.{0}) : type_of% @P05_main.{0} := P05_main_mod_gaps g` (also `.{2}`) | compiles: `_mod_gaps` is exactly "gap → gated main" |
| `P05.lean` vs `P05ModGaps.lean` (read in full) | identical except: header docstring; `universe u`/`Type u` instead of `Type*` (needed so gap and main share the universe); `theorem P05_Sbridge … sorry` replaced by `def P05_Sbridge_Gap`; `P05_main` renamed `P05_main_mod_gaps` with `hGap_Sbridge` first and the call `P05_Sbridge …` replaced by `hGap_Sbridge …` (l.153). Only the stopped obligation differs. |

Gap-dependent obligations: only the main theorem (S0-S4, Sapp, Snn do not take it; their types are gate-identical).

## 3. Axioms and sorry

`#pv_axioms P05ModGaps`: ALL STANDARD (9 declarations). `#pv_walk_decl Paper.P05.P05_main_mod_gaps`: closure axioms `[propext, Classical.choice, Quot.sound]`, sorryAx not reached.

## 4. Per-theorem conditionality (`#pv_hyp_usage`)

| Premise of `P05_main_mod_gaps` | First level | Where actually used |
|---|---|---|
| `hGap_Sbridge` (gap) | USED | l.153, input `hcb` of S3 (source l.476 underbrace) |
| `hP04 : P05_P04Consumed` (p) | USED | `P05_Snn` (hyp_usage: USED) → destructured `hP04 t ht` for ℱ_t-measurability, `e_t ≥ 0`, `∫⁻ ≤ 1` → integrability/nonnegativity feeding S2 (source l.226 consumed at l.474-476); also passed to the gap |
| `hset` | USED | `P05_Snn` → `P05_Sapp` (hyp_usage: USED) → `c_mem` (ℋ_S ⊆ ℋ_{S;c}) |
| `hS`, `hh` | USED | only as arguments of `hGap_Sbridge` (l.153; no other S_j takes them; read from the 20-line proof term). Not used by the proved part. |
| `hτ`, `hτ1`, `hQ` | USED | S1/S2/S4 measurability, S0 (TFA), probability measure |

Conditions: `P05_P04Consumed` (type (p), predecessor P04, clause l.222-227, all `T ≥ h+1`), used in step Snn (and inside the gap). It is **not registered** in `EXTERNAL_TOOLS.md`/`RESULTS.json` (hence mech "none"). P04's own final audit is PASS / CONDITIONAL on `P04_T01Consumed, P04_MixingOfStrict`; after any reconnection those would be inherited. Because P05 has a gap, conditions do not support a verified verdict here.

## 5. Infrastructure (item 8)

| Module | Constants reached | Record | Judgement |
|---|---|---|---|
| `Defs` | `Erep`, `IsConsistent`, `IsStrictlyConsistent`, `expPi` | `DEFS_gate_r2.md` (fingerprints identical) | definitions only, gate-approved |
| `P04Stmt` | `HSc`, `HScInt`, `Ik`, `IsEValueUnder`, `P04Conclusion` (+ mk/rec/casesOn), `SeqSetting` (+ mk, `c_mem` projection), `eT` | `P04_gate_r2.md` | definitions/structure projections only; no theorems consumed; walk does not enter `P04.lean` |
| `P05Stmt` | `P05_P04Consumed` | `P05_gate_r2.md` (vh identical) | (p) clause, not stronger than P04's conclusion (gate A1) |

No theorem from another module is consumed; no unrecorded constant.

## 6. Route fidelity (source l.474-476)

| Source | Lean | Assessment |
|---|---|---|
| l.474 setting: filtration, a.s. finite stopping time, `e_t` | `τ : Ω → ℕ`, `IsStoppingTime ℱ τ`; `e_t = P04.eT` (l.236 "under the assumptions of Lemma prop:combination") | representation choice approved at gate (everywhere finite τ) |
| l.474 premise `E(e_t | F_t) ≤ 1` a.s. for P04's `e_t` | `P05_Sbridge_Gap` | **stopped**: not given by P04 (which gives only `E e_t ≤ 1`); since `e_t` is ℱ_t-measurable the premise means `e_t ≤ 1` a.s. Ruling `P05_issue_1.md`. Not repaired. |
| l.476 `E e_τ = Σ_{t≥1} E{e_t 1(τ=t)}` | S1 (`lintegral_iUnion` over `{τ=t}`) + S0 for `t ≤ h` | FAIR_IMPLICIT_STEP: countable additivity of the lower integral over the partition `{τ=t}`; terms `t ≤ h` vanish by the gate-approved TFA `τ ≥ h+1` a.s. (S0) |
| l.476 second equality "by the definition of conditional expectation" | S2 (`setIntegral_condExp`, `{τ=t} ∈ ℱ_t`, integrability from Snn) | faithful; FAIR_IMPLICIT_STEP: `{τ=t} ∈ ℱ_t` and integrability of `e_t` (from P04 clause via Snn) are unstated |
| l.476 underbrace `≤ 1 a.s.` | S3 with `hcb` = gap | faithful use of the stopped premise |
| l.476 final `≤ 1` | S4 (`measure_iUnion`, `prob_le_one`) | FAIR_IMPLICIT_STEP: disjointness, Q probability |
| l.236-238 ℋ_S vs ℋ_{S;c} | Sapp (`c_t ∈ {0,1}`) | FAIR_IMPLICIT_STEP |
| E as `∫⁻ ofReal` | Snn nonnegativity | encoding convention (gate) |

No route change, no stronger result used, no private helpers (item 9 empty). The prover did not try another route for Sbridge.

## 7. Non-vacuity (`auditor_P05_final2.lean`, exit 0, 0 sorry)

Nontrivial witness (from `P05_Counterexample1`: h = 2, Brier score, non-constant `Y`, `λ_2 = 1`, non-trivial filtration, non-constant stopping time τ ∈ {3,4}, Q uniform on Bool): `hS0, hset0, hP040, htau0, hQ0, htau0_ge` all hold, and `P05_main_mod_gaps g S0 2 … htau0 Q0 hQ0 htau0_ge` instantiates. All non-gap hypotheses are satisfiable. Corroboration: `example : ¬ P05_Sbridge_Gap.{0}` compiles via `Issue1.not_Sbridge` (closure axioms standard, no sorryAx); so the gap premise is false and the mod-gaps theorem carries no content beyond the proved steps S0-S4/Sapp/Snn. (`P05_Counterexample1` is under separate counterexample review; used here only as a witness/corroboration, not as audit evidence for the issue.)

## 8. Status for the authors

Verified in Lean along the source route (l.474-476): the general optional-stopping computation (S1-S4) and the use of Proposition 3.4's clause (via the unregistered (p) parameter `P05_P04Consumed`). Not verified: the proof applies the premise `E(e_t | F_t) ≤ 1` to Proposition 3.4's e-values without justification. Since `e_t` is ℱ_t-measurable, that premise says `e_t ≤ 1`, which is false in general (PAPER_ARGUMENT_GAP at l.474/476; ERROR for h ≥ 2 per ruling `P05_issue_1.md`, pending counterexample review). Minor: "Lemma \ref{prop:combination}" refers to a Proposition (EDITORIAL); ℋ_S vs ℋ_{S;c} at l.236-238 (DOMAIN_CLARIFICATION, minor).

## 9. Records to update

- Register `P05_P04Consumed` (p, predecessor P04, source l.222-227, used by P05 Snn) in `EXTERNAL_TOOLS.md`/`RESULTS.json`.
- Record gap `P05_Sbridge_Gap` (l.474/476) in P05's `gaps`.
- ISSUE needs `COUNTEREXAMPLE VALID` from the pending review `verification/audits/P05_issue_1_audit.md`; if that review is not valid, P05 is UNFINISHED (ISSUE_UNCONFIRMED).

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE   (stopped step Sbridge l.474/476; requires COUNTEREXAMPLE VALID in P05_issue_1_audit.md, otherwise UNFINISHED / ISSUE_UNCONFIRMED)
CONDITIONS: P05_P04Consumed   (Snn: P04 clause l.226; unregistered (p); not a basis for a verified verdict because of the gap)

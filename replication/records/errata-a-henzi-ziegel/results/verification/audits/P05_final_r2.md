# P05 final audit r2 (Proposition 3.5, `prop:stopping`), complete file `pv_work/P05.lean`

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), session 8d34e999
- Date: Tue Oct 13 11:06 EDT 2026 (from `date`)
- Source read directly: `source/VSIFP_02.tex` l.108-119 (𝓗_{S;c}, 𝓗_S), l.141-148 (Thm 3.1, eq:representation), l.197-234 (h = 1 route l.200-214, l.227; Prop 3.4 l.216-221; statement l.229-234), l.399-416 (proof of Thm 3.1; the "easily verify" sentence is **l.400**, not l.403), l.446-469 (proof).
- Inputs read: full `pv_work/P05.lean`, `pv_work/P05Stmt.lean`; prover notes; previous audit `P05_final.md`; issue ruling `P05_issue_1.md` (§6, verdict FAIR_IMPLICIT_STEP); `T01_issue_1.md` scope lines; `P04_gate_r2.md` fingerprints.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P05`)

Report `verification/audits/P05_mech_r2.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P05` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (4bb8caa1…) |
| 3 | PVTools hash | PASS |
| 4 | 21 gated fingerprints vs `P05_gate_r2.md` | PASS (S0 th 1557197759 included) |
| 5 | Defs vs `DEFS_gate_r2.md` | PASS |
| 6 | `#pv_axioms P05` | ALL STANDARD |
| 7 | `#pv_walk P05` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 11 | traced conditions | script: "none; P05_P04Consumed not reached". **Wrong, corrected in §3** |

No gap file this time: `P05.lean` has no `sorry`; `P05ModGaps.lean` is **not imported** (import line is `import P05Stmt` only; walks of `P05_main` and `P05_S0` reach only modules Defs, P04Stmt, P05Stmt, P05, T01Stmt; no `P05ModGaps`, no `P04`, no `T01` proof module).

## 2. Probe

`pv_work/probes/auditor/P05/auditor_P05_r2_nonvac.lean` (`scripts/pv_lean.sh probe …`: exit 0, 0 errors, 0 sorry, log `pv_work/logs/auditor_P05_r2_nonvac_1.log`). Contains non-vacuity witnesses, `#pv_hyp_usage` on main/S8/S7/S0, `#pv_walk_decl` on S7 (positive control), main, S0.

## 3. Per-theorem conditionality

| Premise | Chain (`#pv_hyp_usage`, `#pv_walk_decl`) | Actual use |
|---|---|---|
| `hP04 : P05_P04Consumed` | main USED → `P05_S8` USED → `P05_S7` USED; S7 proof term `hP04 hrep hset hS hh Q hQ k hk (fk∘τ) (P05_S4 …)` | S7 (l.452-456), **h > 1 branch only** |
| `hrep : MixtureRep S ν` | main → S8 → S7, passed only into `hP04` | applicability premise of the consumed clause (gate-approved TFA-2), not a separate parameter |
| S0 (h = 1) | 15/15 binders USED; signature has no `hrep`, no `hP04` | walk of `P05_S0`: **does not reach** `P05_P04Consumed`, `T01.MixtureRep`, any T01/P04 clause (modules: Defs 5, P04Stmt 16, P05Stmt 5, P05 28) |

Walk evidence: positive control `#pv_walk_decl Paper.P05.P05_S7` reaches `P05_P04Consumed` via `[P05_S7]`; `#pv_walk_decl Paper.P05.P05_main` reaches it via `[P05_main, P05_S8, P05_S7]`. So `P05_P04Consumed` is a real condition (of the h > 1 case). At h = 1 the clause is vacuous (premise `1 < h`; discharged by `absurd` in the probe).

Unused step premises (gated, harmless): `P05_S4.hk`, `P05_S6.hh`, `P05_S6.hk`. `IsStopTime.le_meas/pos` warnings concern auto-generated projections.

## 4. Infrastructure (item 8, item 9)

| Module | Constants | Record | Fingerprints |
|---|---|---|---|
| Defs | Erep, HS, IsConsistent, IsMixingMeasure, IsStrictlyConsistent, elemScore, expPi, mixtureScore | `DEFS_gate_r2.md` | item 5 PASS |
| P04Stmt | HSc, HScInt, Ik, Mk, eT, filtK, fk, SeqSetting (+ ctor/projections) | `P04_gate_r2.md` | compared by me (walk vs gate l.62-98): all th/vh identical |
| P05Stmt | IsStopTime (+ ctor/proj.), P05Conclusion, P05_P04Consumed | `P05_gate_r2.md` | item 4 PASS |
| T01Stmt | MixtureRep (h > 1 branch only) | `T01_gate.md` | th 889021459 / vh 1663983606 as in previous audit |

Only definitions/structure projections from other modules; no external theorem consumed. Private helpers (all read in full):

| Helper | Content | Judgement |
|---|---|---|
| `S0_mono`, `S1_anti`, `clamp_*`, `meas_S0/S1/SZ/Sb/Erep`, `meas_factor`, `fk_le_iff`, `ofReal_sum_le'` | unchanged from the gap file; audited in `P05_final.md` §5 | technical |
| `Erep_nonneg` (new) | `0 ≤ E_{p,q;λ}(y)` for consistent S, p,q,λ ∈ [0,1], y ∈ {0,1}: d(b) ≥ −|d(b)|, d(1−b) ≥ 0 from monotonicity of S(·,0)/S(·,1); denominator 0 ⇒ E = 1 | exactly l.400 "E(y) ≥ E{1(p>q)} = 1−λ ≥ 0"; true; uses only consistency (weaker than Thm 3.1's hypotheses) |
| `pt_bound1` (new) | `(1−π)E(0)+πE(1) ≤ 1` for π ∈ H_S(p,q) when c = 1; λ = 0 ⇒ E ≡ 1 when c = 0 | l.400 "one can easily verify that E has the given null hypothesis" (ring identity 1 + λ f(π)/|d(b)|, f(π) ≤ 0) and l.205; true; no T01/mixing parameter (confirmed by walk) |
| `cond_prep` (copied from P04) | a.s. `E_Q(Y_{t+h}|ℱ_t) ∈ [0,1]` and, if c_t = 1, ∈ H_S(p_t,q_t), from `HScInt` (l.114-115) by linearity of condExp on Y ∈ {0,1} | technical, true |
| `lint_condExp` (copied from P04) | `∫⁻ G·ofReal Z = ∫⁻ G·ofReal E(Z|ℱ_t)` for ℱ_t-measurable G ≥ 0 | defining property of condExp, technical |
| `core1` (P04 `core6` with `pt_bound1`) | `∫⁻ g·E_t(Y_{t+h}) ≤ ∫⁻ g` for ℱ_t-measurable g ≥ 0 | l.202-209 pull-out + l.207 bound; technical |

None smuggles in the conclusion; none uses a stronger result than the source.

## 5. Route fidelity

h > 1 (S1-S8): unchanged from `P05_final.md` §6 (identical declarations, fingerprints PASS); same findings (EDITORIAL: "k ∈ {1,…,k}" l.460, Σ_ℓ M^[k] l.454, M for e l.466/468; FAIR_IMPLICIT_STEP: identity l.468, measurability S6, τ ≥ 1 case t < k in S4).

h = 1 (S0), new:

| Source | Lean | Classification |
|---|---|---|
| l.232 𝓗_S = 𝓗_{S;c} with c ≡ 1 (l.119) | `hset1` (SeqSetting with c ≡ 1) | form conversion |
| l.217-218 at h = 1: e_t = ∏_{l=1}^{t−1} E_l(Y_{l+1}) | `heG : eT S 1 … t = G (t−1)` (unfolding) | form conversion |
| l.214 "non-negative" | `hnn` via `Erep_nonneg` (l.400) | FAIR_IMPLICIT_STEP: nonnegativity of factors filled from the sufficiency half of Thm 3.1, source l.400 (not affected by T01 issue 1, which concerns only l.412's E(0) ∈ (0,1)) |
| l.202-203 conditioning on ℱ_T, pull out ℱ_T-measurable product | `hone` via `core1`, `lint_condExp` | faithful |
| l.205-207 E_Q{E_T(Y_{T+1})|ℱ_T} ≤ 1 a.s. for Q ∈ 𝓗_{S;c} | `pt_bound1` + `cond_prep` | FAIR_IMPLICIT_STEP: l.207 relies on E_{p,q;λ} being an e-value for H_S (Thm 3.1, "easily verify", l.400); filled in by the one-line computation 1 + λ·f(π)/|d(b)| ≤ 1. Same route as the source; uses only consistency |
| l.211-214 iterate ⇒ supermartingale (index slip at l.214, EDITORIAL per ruling; l.227 indexing (e_t)_{t≥2} used) | `hone` gives ∫_A G_{n+1} ≤ ∫_A G_n, A ∈ ℱ_{n+1}, G_n ℱ_{n+1}-measurable | faithful |
| l.227 optional stopping (Ramdas 2020 §3) | stopped process F_n = ofReal G(min(τ−1,n)), split on {τ ≤ n+1} ∈ ℱ_{n+1}, ∫F_0 = 1, Fatou (`lintegral_liminf_le`), F_n eventually constant | FAIR_IMPLICIT_STEP per ruling `P05_issue_1.md` §6, filled exactly as P04_S10 (standard optional-stopping argument for nonnegative supermartingales, no boundedness of τ needed via Fatou); checked the indices: on {τ > n+1}, min(τ−1,n+1) = n+1 and the step uses A = {τ ≤ n+1}ᶜ ∈ ℱ_{n+1} correctly |

Encoding notes: Lean's x/0 = 0 gives E ≡ 1 when the denominator vanishes (p = q), gate-approved convention (`P04_gate_r2.md` l.50). τ ≥ 1 (ℕ = {1,2,…}) gate-approved. No route change, no stronger result than in the source.

## 6. Non-vacuity (probe of §2, all `#print axioms` standard)

Witness: Ω = Unit, ν = Lebesgue on (0,1), S = mixtureScore ν (Brier/2, strictly consistent, MixtureRep proved), p ≡ 1/4, q ≡ 3/4, Y ≡ 0, non-constant c_t, λ_t (λ_t = 1/2 on even t), τ ≡ 3, Q = Dirac ∈ HScInt S h F Yd 1 p q (proved for every h).
- `nonvac_S0` (h = 1, from `P05_S0`, no parameters) and `nonvac_main_h1` (`P05_main` at h = 1; `hP04` vacuous) compile.
- `nonvac_main_h2` (`P05_main` at h = 2) with `hP04` discharged from the proved `Paper.P04.P04_S10` (c := 1) compiles; so the condition is satisfiable at a nontrivial instance.
- Limitation: Ω = Unit (deterministic); this witnesses satisfiability of all hypotheses, not a stochastically rich instance.

## 7. Status for the authors

- Verified: Prop 3.5, E_Q(e_{τ+h−1}) ≤ 1 for Q ∈ 𝓗_S, all h ≥ 1; h = 1 unconditionally along l.200-214/l.227 (with l.400), h > 1 conditional on the P04 proof clause l.452 (`P05_P04Consumed`, hence after reconnection on P04's conditions `P04_T01Consumed`, `P04_MixingOfStrict`).
- Source: no error; the proof writes only h > 1 (l.447) and cites Ramdas for h = 1 (FAIR_IMPLICIT_STEP); editorial slips l.214 index, l.454 Σ_ℓ, l.460 "k ∈ {1,…,k}", l.466/468 M for e.

## 8. Records to update

- `EXTERNAL_TOOLS.md` / registry entry `P05_P04Consumed`: status "not a condition of any result" is wrong; it is a **condition of P05** (step S7 → S8 → main, h > 1 branch, source l.452). The mech script's "not reached" follows from that stale status.
- `verification/DOC_ERRATA.md` row 1 added: `P05.lean` docstrings cite "l.403" for the Thm 3.1 sufficiency sentence; correct line is l.400.
- `P05ModGaps.lean` is superseded by `P05.lean` (not imported anywhere in P05's closure).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: P05_P04Consumed

# P04 final audit (Proposition 3.4, `prop:combination`)

- Auditor: pv-auditor (independent; not drafter, gate or prover), session 8d34e999
- Started: Tue Oct 13 10:53:15 EDT 2026 (`date`)
- Audited object: `pv_work/P04.lean` (no gap file; no obligation stopped)
- Source read directly: `source/VSIFP_02.tex` l.90-119 (mixture representation, l.103 strict consistency vs ν, H_{S;c} l.113-119), l.143-148 (T01), l.199-221 (h = 1 sketch and the statement), l.399-416 (T01 proof, l.400 E ≥ 1-λ), l.446-469 (proof of P04)
- Also read: `pv_work/P04Stmt.lean`, `pv_work/Defs.lean`, `pv_work/T01Stmt.lean` (full), `pv_work/P04.lean` (full, 924 lines), `verification/audits/P04_gate_r2.md`, `P04_gate.md` (items 7 and TFAs), `pv_work/notes/P04_prover_notes.md`

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py P04` -> `verification/audits/P04_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P04` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL (db55f693…) |
| 3 | PVTools.lean hash | PASS |
| 4 | 55 gated fingerprints vs `P04_gate_r2.md` | PASS, all th/vh/bi identical |
| 5 | `Defs` vs `DEFS_gate_r2.md` | PASS |
| 6 | `#pv_axioms P04` | ALL STANDARD |
| 7 | `#pv_walk P04` | no `sorryAx`; axioms propext, Classical.choice, Quot.sound |
| 11 | TRACED CONDITIONS | P04_MixingOfStrict, P04_T01Consumed |
| 12 | last writers | prover (P04.lean), drafter (P04Stmt.lean) |

No gap file, so §2b gap checks do not apply.

## 2. Per-theorem conditionality (step 4)

From `#pv_hyp_usage` (log `pv_work/logs/auditor_P04_mech2_1.log`) and reading the proof terms:

| Parameter | Status in `P04_main` | Where it is actually used (step / clause) |
|---|---|---|
| `hT01 : P04_T01Consumed S` | USED | **S1** (l.452 "nonnegative", via l.400 `E ≥ 1-λ ≥ 0`): `hE.1`, `hE.2.1` (the `0 ≤ E 0`, `0 ≤ E 1` parts of `IsEValue`); **S0 / `pt_bound`** (l.205-209 one-step bound): `hE.2.2.1` (null part `E_π E ≤ 1` for `π ∈ H_S(p_t,q_t)`). Reaches the e-value clause of the conclusion via S5-S7 (h = 1) and S9b, S9c, S10, S11 (h > 1). Not used for the measurability clause (S3 has no `hT01`). |
| `hMix : P04_MixingOfStrict S` | USED | Same two sites: supplies the premise `0 < ν[min,max)` of `hT01` (l.103, "only if" direction). Used only as a premise of `hT01`. |

Both uses are direct and essential (the applied results are consumed in the bound), confirmed by reading `P04_S1` (l.125-143) and `pt_bound` (l.295-326). The walk tool tracks constants, not local hypotheses, so `#pv_walk_decl` "enters only through" checks are not applicable here; `#pv_hyp_usage` reports USED at S1, S0, S5-S7, S9b, S9c, S10, S11, main.

UNUSED leading hypotheses in gated steps (not external parameters, harmless; noted per item 10): `hh` in S0, S1; `hT` in S3, S11; `hh` in S14; `hk` in S9b. `P04_main` has no unused hypothesis. The `SeqSetting.*` warnings concern auto-generated projections (no proof content).

## 3. Infrastructure (step 5)

The closure reaches only definitions in three modules; **no earlier in-project theorem is consumed** (T01's theorems are not in the closure; T01 enters only as the parameter `P04_T01Consumed`).

| Module | Constants | Covered by | My check |
|---|---|---|---|
| `Defs` | `Erep`, `HS`, `IsConsistent`, `IsStrictlyConsistent`, `IsEValue`, `IsMixingMeasure`, `elemScore`, `expPi`, `mixtureScore` | `DEFS_gate_r2.md` (fingerprints identical, item 5) | read in full; match l.70-74, l.94-102, l.132-148 |
| `T01Stmt` | `MixtureRep` | `T01_gate.md` | read in full; TFA-2 (ν given with S) approved |
| `P04Stmt` | 24 (SeqSetting, Ik, eT, HSc, HScInt, IsEValueUnder, P04Conclusion, P04_T01Consumed, P04_MixingOfStrict, Mk, filtK, fk) | `P04_gate_r2.md` (fingerprints identical, item 4) | read in full; match l.113-119, l.217-220, l.447-452, l.458 |

Helpers not in the snapshot (item 9), reviewed one by one (all in `pv_work/P04.lean`, standard axioms by item 6):

| Helper | Content | Ruling |
|---|---|---|
| `S0_mono`, `S1_anti` | `S(·,0)` nondecreasing, `S(·,1)` nonincreasing on [0,1] from consistency | true, standard; used only for measurability (technical) |
| `clamp_mem/mono/eq` | clamp to [0,1] | trivial |
| `meas_S0/S1/SZ/Sb/Erep` | measurability of `S(r,Z)` and of the factor `E` | technical (l.220 measurability, unargued in source) |
| `cond_prep` | a.s. `E_Q(Y_{t+h}|ℱ_t) ∈ [0,1]` and, if `c_t = 1`, `∈ H_S(p_t,q_t)`, from `Q ∈ H_{S;c}` via `d = d0(1-Y)+d1·Y` | translation of the definition l.115 into the one-period null l.132; technical |
| `lint_condExp` | `∫ G·Z = ∫ G·E(Z|ℱ_t)` for ℱ_t-measurable `G ≥ 0` | pull-out property (l.202-203); standard |
| `pt_bound` | pointwise `E_π E ≤ 1` (cases λ = 0, p = q give 1; else T01 null part) | l.205-209; uses `hT01`, `hMix` |
| `core6` | weighted one-step bound `∫ g·E_t ≤ ∫ g` | l.202-209 tower/pull-out, in integral form |
| `Mk_range`, `prod_meas`, `filtK_eq`, `filtK_le`, `Mk_meas`, `Mk_zero`, `fk_ge`, `fk_le_iff`, `fk_div` | index arithmetic, `∏_∅ = 1`, `ℱ_j = {∅,Ω}` for j ≤ 0 | technical, match l.447-452, l.458-462, l.468 |

None introduces a mathematical claim beyond the source or smuggles in the conclusion.

## 4. Route fidelity (step 6)

| Source | Lean | Ruling |
|---|---|---|
| l.220 "are ℱ_T-measurable" (no argument) | S2, S3 (factor at `l` is ℱ_{l+h}-measurable, `l+h ≤ T`) | FAIR_IMPLICIT_STEP (gate item 7.5) |
| l.200-204 tower property, pull out ℱ_T-measurable factors | `core6` with weight = product of earlier factors (S5) | same route, integral form |
| l.205-209 `c_T = 0 ⇒ λ_T = 0 ⇒ E ≡ 1`; `E_Q{E|ℱ_T} ≤ 1` a.s. | S4, S0 (`cond_prep`, `pt_bound`, uses T01 null part) | same route; "E_Q{E(Y)|ℱ_T} = E_π E with π = E_Q(Y|ℱ_T)" filled in (`cond_prep`): FAIR_IMPLICIT_STEP |
| l.211-214 iterate (h = 1) | S5, S6 (induction), S7 (`I_1 = {1,…,T-1}`) | same route |
| l.447-452 `e_t = ∑ M^{[k]}_t / h` | S8 (`rfl`) | definitional |
| l.452 "M^{[k]} is a nonnegative supermartingale w.r.t. 𝔉^{[k]}" (no argument) | S9a (adapted), S9b (nonneg, S1), S9c (one-step bound at the times `k+hs`, `core6` with weight `1_A M_t`) | FAIR_IMPLICIT_STEP: the h = 1 computation l.200-209 applied on the subsequence `k+hs` (gate item 7.1) |
| l.452 "therefore E_Q(M_τ) ≤ 1 for any 𝔉^{[k]}-stopping time" | S10: stopped process, S9c on `{τ > n}`, `M_0 = 1`, Fatou | FAIR_IMPLICIT_STEP (standard optional stopping for nonnegative supermartingales) |
| l.453-455 (with τ ≡ T, not written) | S11 (constant stopping time, linearity) | FAIR_IMPLICIT_STEP (gate item 7.5) |
| l.456-468 (f_k, stopping times; used by P05) | S12, S13 (with TFA `τ ≥ 1`), S14 | same route; `k ∈ {1,…,k}` at l.460 and `M` for `e` at l.466-468 are EDITORIAL |
| l.452, l.466 proof written "for Q ∈ ℋ_S" while l.220 claims ℋ_{S;c} | proved for ℋ_{S;c}: `λ_t = 0` when `c_t = 0` (l.205, l.217) makes those factors 1 (S4, `pt_bound`) | the c-reduction is printed at l.205-209; I rule it FAIR_IMPLICIT_STEP (gate item 7.2 preliminary EXPOSITION_GAP; not dispatched, not confirmed) |

No route change; no stronger result used than the source uses (T01 sufficiency + l.103 only). The lintegral/integral form instead of conditional-expectation notation is a change of form only.

TFAs (gate-approved) in force: TFA-1 `HScInt` (integrable score difference, L¹ meaning of l.115), TFA-2 `(ν, hrep)`, `p_t = q_t ⇒ E = 1` (Lean `x/0 = 0`), `τ ≥ 1` in S13.

Open candidate (not a FAIL item, not confirmed): `p_t = q_t` (gate item 7.3; RESUME "DOMAIN_CLARIFICATION, not registered"). At l.217 `(p_t,q_t) ∈ (0,1)^2` allows `p_t = q_t`, where l.146 is 0/0. Reading A "E := 1 when p_t = q_t" (the encoding): result proved. Reading B "implicitly p_t ≠ q_t": a special case of A, also proved. So the conclusion does not depend on the reading; I assess it as EDITORIAL-level domain remark rather than an ISSUE. The coordinator may dispatch a reasoning review if a ruling is wanted.

## 5. Non-vacuity (step 7)

| Probe | Instance | Result |
|---|---|---|
| `pv_work/probes/auditor/P04/auditor_P04_nonvac.lean` (h = 1 branch) | ν = Lebesgue on (0,1), S = mixtureScore ν (half Brier), strictly consistent; `hT01` discharged by `Paper.T01.T01_S2`; `hMix` proved; Ω = Unit, c ≡ 1, p ≡ 1/4, q ≡ 3/4, λ ≡ 1/2, Y ≡ 0; `Q = dirac ()` ∈ HScInt; T = 2 | exit 0, 0 sorry, axioms standard (log `pv_work/logs/auditor_P04_nonvac_3.log`) |
| `pv_work/probes/auditor/P04/auditor_P04_nonvac2.lean` (h > 1 branch) | same S, h = 2, T = 3, alternating `c_t` (1 on even t, 0 on odd t), `λ_t = c_t/2`; `Q = dirac ()` ∈ HScInt | exit 0, 0 sorry, axioms standard (log `pv_work/logs/auditor_P04_nonvac2_1.log`) |

Both conditions are satisfiable for a genuine S, and the null class contains a measure satisfying the dominance hypothesis with `c_t = 1`, `λ_t > 0`.

## 6. Status for the authors

Verified (Lean, standard axioms): Proposition 3.4 in full (ℱ_T-measurability and the e-value property under ℋ_{S;c}, all T ≥ h+1, h = 1 and h > 1), along the source route.
Depends on: the "if" direction of Theorem 3.1 (T01, ISSUE B1 elsewhere; this clause itself is verified in T01) and the l.103 assertion "strictly consistent ⇒ ν charges every interval".
Source: proof correct; unargued but standard steps (supermartingale property l.452, optional stopping, measurability, ℋ_S vs ℋ_{S;c}); p_t = q_t gives 0/0 in (3.1); typos l.454 (ℓ/k), l.460, l.466-468.

FAIL items: none.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: P04_T01Consumed, P04_MixingOfStrict

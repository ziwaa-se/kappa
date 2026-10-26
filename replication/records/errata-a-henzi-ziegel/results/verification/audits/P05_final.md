# P05 final audit (Proposition 3.5, `prop:stopping`), gap file `pv_work/P05ModGaps.lean`

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), session 8d34e999
- Date: Tue Oct 13 10:58:14 EDT 2026
- Source read directly: `source/VSIFP_02.tex` l.200-244 (context, statement l.229-234) and l.446-469 (proof; the old separate proof l.471-476 is commented out and not used).
- Inputs: gate snapshot `verification/audits/P05_gate_r2.md`, DEFS snapshot `verification/audits/DEFS_gate_r2.md`, prover notes `pv_work/notes/P05_prover_notes.md`, full text of `pv_work/P05ModGaps.lean`, `pv_work/P05Stmt.lean`, `pv_work/P05Draft.lean`, `pv_work/P04Stmt.lean`.
- Scope: everything except the stopped obligation `P05_S0` (case h = 1). The issue ruling `verification/audits/P05_issue_1.md` is still being written; I did not wait for it and did not rule on it.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P05 --module P05ModGaps`)

Report `verification/audits/P05_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `P05ModGaps` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | 21 gated fingerprints vs `P05_gate_r2.md` | PASS |
| 4b | `P05_S0_Gap` vh = th of `P05_S0` (1557197759) | PASS |
| 5 | Defs vs `DEFS_gate_r2.md` | PASS |
| 6 | `#pv_axioms P05ModGaps` | ALL STANDARD |
| 7 | `#pv_walk`: sorryAx reached false; axioms propext, Classical.choice, Quot.sound | PASS |
| 11 | traced conditions | script says "none; P05_P04Consumed not reached". **Corrected below (§4): it is reached and used.** |

## 2. Gap file (§2b), probe `pv_work/probes/auditor/P05/auditor_P05_gapcheck.lean` (log `pv_work/logs/auditor_P05_gapcheck_2.log`, exit 0, 2 intended sorries)

| Check | Result |
|---|---|
| `P05_main` redeclared verbatim (draft l.20-26) under original name: th | 800987792 = snapshot |
| `P05_S0` redeclared verbatim (draft l.34-38): th | 1557197759 = snapshot |
| `example : P05_S0_Gap.{u} = type_of% @P05_S0.{u} := rfl` (universe 0 and generic u) | compiles |
| `example (g : P05_S0_Gap.{u}) : type_of% @P05_main.{u} := fun {Ω} {m0} => @P05_main_mod_gaps Ω m0 g` | compiles |
| `diff pv_work/P05.lean pv_work/P05ModGaps.lean` | only: header/docstrings, `universe u_1` made explicit, `P05_S0` (sorry) → `P05_S0_Gap` def, main renamed with premise `hGap_0`, one call site. S1-S8 and helpers identical. |
| gap-dependent obligations | only the main theorem (S1-S8 do not use S0) |

Note (form only): `hGap_0` sits after the auto-bound implicits `{Ω} {m0}` rather than first; the `example` above shows the type is exactly "gap → gated main". No effect.

## 3. Axioms / sorry
Covered by items 6-7: standard axioms only, no `sorryAx` in the closure of `P05ModGaps`.

## 4. Per-theorem conditionality (`#pv_hyp_usage`, `#pv_walk_decl`, same probe)

| Premise | Chain | Actual use |
|---|---|---|
| `hP04 : P05_P04Consumed` | main_mod_gaps USED → `P05_S8` USED → `P05_S7` USED; S7's proof term is `hP04 hrep hset hS hh Q hQ k hk (fk ∘ τ) (P05_S4 …)` | S7 (l.452-456), h > 1 branch |
| `hrep : MixtureRep S ν` | main → S8 → S7, passed only into `hP04` | applicability premise of the consumed clause (inherited P04 TFA-2, gate-approved), not a parameter |
| `hGap_0` | main, h = 1 branch | gap (not a condition) |

Walk confirmation: `#pv_walk_decl Paper.P05.P05_S7` (positive control, direct user) reaches `Paper.P05.P05_P04Consumed` via `[P05_S7]`; `#pv_walk_decl Paper.P05.P05_main_mod_gaps` reaches it via `[main_mod_gaps, P05_S8, P05_S7]`. **So P05_P04Consumed is a real condition of the h > 1 part. The mech script's "registered but not reached" is wrong**; the likely cause is the stale registry entry (`pv_status.py tools` lists it as "P04 main conclusion … used for integrability in step Snn", source l.216-221, Lean location without line). The actual Lean def (`pv_work/P05Stmt.lean:43`) is the P04 *proof* clause l.452 (= `P04_S10` with c := 1, h > 1), used in step S7. The registry entry should be corrected.

Unused step premises (item 10, gated statements, harmless, not parameters): `P05_S4.hk`, `P05_S6.hh`, `P05_S6.hk`. The `IsStopTime.le_meas/pos` warnings concern auto-generated projections.

Predecessor status: P04 final audit = PASS, CONDITIONAL on `P04_T01Consumed`, `P04_MixingOfStrict` (`verification/audits/P04_final.md`). After reconnection these will be inherited by P05 through `P05_P04Consumed`.

## 5. Infrastructure (item 8 / item 9)

Constants reached outside `P05ModGaps`: only definition modules; the walk does not enter `P04.lean`, `T01.lean` or any proof module.

| Module | Constants | Record | Fingerprint check |
|---|---|---|---|
| Defs | 7 defs | `DEFS_gate_r2.md` | item 5 PASS |
| P04Stmt | HSc, HScInt, Ik, Mk, eT, filtK, fk, SeqSetting (+ ctor, auto projections) | `P04_gate_r2.md` | th/vh compared by me line by line with the walk output: all identical |
| P05Stmt | IsStopTime (+ ctor/projections), P05Conclusion, P05_P04Consumed | `P05_gate_r2.md` | item 4 PASS |
| T01Stmt | MixtureRep | `T01_gate.md` l.92 | th 889021459 / vh 1663983606 identical |

No in-project theorem outside the audited file is consumed; nothing to audit on the spot.

Private helpers in `P05ModGaps.lean` (item 9), read in full:

| Helper | Content | Judgement |
|---|---|---|
| `S0_mono`, `S1_anti` | from consistency, `S(·,0)` nondecreasing, `S(·,1)` nonincreasing on [0,1] (nlinarith) | true, technical (measurability), copied from P04 |
| `clamp_mem/mono/eq` | clamp to [0,1] | trivial |
| `meas_S0/S1/SZ/Sb/Erep` | measurability of `Erep` factor via monotone composition | technical |
| `meas_factor` | each factor m0-measurable (adaptedness + filtration mono) | technical |
| `fk_le_iff` | `fk h k τ ≤ t ↔ τ ≤ ⌊(t-k)/h⌋h + k` in ℤ | exactly l.460 "f_k(τ) ≤ t iff τ ≤ k+hs", in floor form |
| `ofReal_sum_le'` | `ofReal(Σ) ≤ Σ ofReal` | technical (avoids needing nonnegativity) |

None adds mathematics beyond the source or smuggles in the conclusion.

## 6. Route fidelity (h > 1)

| Source | Lean | Note |
|---|---|---|
| l.447-452 def of I_k(t), M^[k], 𝔉^[k]; "e_t = Σ M^[k]_t/h" | `P05_S1` (rfl), `Mk`, `filtK` | faithful |
| l.452 "M^[k] nonneg supermartingale … E_Q(M^[k]_{τ[k]}) ≤ 1 for any 𝔉^[k]-stopping time" | `P05_P04Consumed` via `P05_S7` | consumed predecessor clause (P04 proof, = P04_S10 with c := 1); same clause, not stronger |
| l.453-456 averaged bound | inside `P05_S8` | source writes Σ_ℓ M^[k]: EDITORIAL |
| l.456-459 f_k(τ) ∈ {τ,…,τ+h−1} | `P05_S3` (proved; not needed by S8) | faithful |
| l.459-463 f_k(τ) is 𝔉^[k]-stopping time | `P05_S4` + `fk_le_iff` | t = k+hs+j decomposition replaced by ℤ floor arithmetic (form conversion). Case t < k (𝔉^[k]_t trivial, l.452 convention) handled via τ ≥ 1: FAIR_IMPLICIT_STEP (convention ℕ = {1,2,…}, gate-approved `IsStopTime.pos`). Source typo "k ∈ {1,…,k}": EDITORIAL |
| l.464-468 E(M_{τ+h−1}) = E((1/h)Σ M^[k]_{f_k(τ)}) ≤ 1, using M_{t+h−1} = Σ M^[k]_{f_k(t)}/h | `P05_S5` (identity, proved for t ≥ 1), `P05_S8` | "M" for "e": EDITORIAL. The identity is stated without proof in the source: FAIR_IMPLICIT_STEP, filled by integer division arithmetic (`Int.natCast_div`, `Int.add_mul_ediv_right`) |
| silent: linearity of E over the h summands | `P05_S6` (measurability of stopped process) + `lintegral_finset_sum` | FAIR_IMPLICIT_STEP: measurability from adaptedness and countable range of τ |
| silent: ℋ_S vs ℋ_{S;c} | `P05_S2` (proved, not used after gate amendment A1) | harmless side fact |

No route change, no stronger result used than at l.452. Inherited TFA: `HScInt` integrability premise (from P04, gate-approved).

## 7. Non-vacuity, probe `pv_work/probes/auditor/P05/auditor_P05_nonvac.lean` (log `pv_work/logs/auditor_P05_nonvac_1.log`, exit 0, 0 sorry, axioms standard)

Nontrivial witness: Ω = Unit, `ν` = Lebesgue on (0,1), `S = mixtureScore ν` (strictly consistent, `MixtureRep` proved), h = 2, p ≡ 1/4, q ≡ 3/4, Y ≡ 0, c_t, λ_t non-constant (c_t = 1, λ_t = 1/2 for even t; 0 otherwise), τ ≡ 3, Q = Dirac ∈ `HScInt S 2 F Y 1 p q` (proved, so ℋ_S is nonempty). `P05_P04Consumed` is **discharged at the witness** from the proved `Paper.P04.P04_S10` (c := 1), so it is satisfiable. `nonvac_S8` (no parameters left) and `nonvac_main` (gap premise as parameter) compile.

## 8. Status for the authors
- Verified (modulo h = 1): for h > 1, E_Q(e_{τ+h−1}) ≤ 1 for Q ∈ ℋ_S, following l.446-468 exactly; depends on the P04 proof clause l.452 (P05_P04Consumed, hence after reconnection on P04's conditions P04_T01Consumed, P04_MixingOfStrict).
- Not verified: h = 1 (the proof starts "Let h > 1", l.447; l.227 only cites Ramdas 2020), gap S0, ruling pending in P05_issue_1. Editorial slips: "k ∈ {1,…,k}" (l.460), Σ_ℓ M^[k] (l.454), M for e (l.466, 468).

## 9. Records to update
- `EXTERNAL_TOOLS.md` / RESULTS.json entry `P05_P04Consumed`: meaning should be "P04 proof clause l.452 (P04_S10 with c := 1, h > 1): E_Q(M^[k]_{τ'}) ≤ 1 for 𝔉^[k]-stopping times τ'", location `pv_work/P05Stmt.lean:43`, source l.452, used by P05 step S7 (→ S8 → main, h > 1 branch); status: condition of P05.

FINAL AUDIT: PASS            (everything except the stopped obligation P05_S0 = case h = 1)
SUGGESTED VERDICT: ISSUE     (only if P05_issue_1 confirms a paper-side gap for h = 1; until then UNFINISHED; a gap never supports CONDITIONAL)
CONDITIONS: P05_P04Consumed

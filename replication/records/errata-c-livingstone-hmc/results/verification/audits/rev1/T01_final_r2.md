# T01 final audit, round 2 (Theorem 2.2, thm:negative, TEX:208-219)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5). Date: Tue Oct 13 01:57:48 EDT 2026.
- Audited object: `pv_work/T01.lean` (no gap file). Statement module: `pv_work/T01Stmt.lean`. Gate: `verification/audits/T01_gate.md` (re-gate after encoding fix E1). Previous audit: `verification/audits/revenc1/T01_final.md` (FAIL F1).
- I read the following myself: TEX:200-221 (statement), TEX:860-880 (Thm 5.14 and its proof), TEX:974-996 (Thm 5.18 and its proof), `T01.lean` and `T01Stmt.lean` in full, the gate report, the prover notes, the r1 audit and its probes, and the gate probe `gate_T01_nonvac.lean` (for `bdd_not_explode`).
- My probe: `pv_work/probes/auditor/T01/auditor_T01_r2.lean`, log `pv_work/logs/auditor_T01_r2_1.log`: `RESULT … exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`.

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py T01`, which I ran)

Report: `verification/audits/T01_mech.md`, **MECH CHECKS: PASS**.

| Item | Result |
|---|---|
| 1 compile `T01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 private rebuild, sha256 | PASS, IDENTICAL (fa9b4bf4…) |
| 3 PVTools hash | PASS |
| 4 fingerprints vs `T01_gate.md` (16 gated decls) | PASS. `T01_main` th=2118693897, the new E1 binder |
| 5 Defs vs `DEFS_gate.md` | PASS |
| 6-7 `#pv_axioms`, `#pv_walk` | PASS, ALL STANDARD, sorryAx not reached |
| 9 helpers not in snapshot | none |
| 10 `#pv_hyp_usage` | no UNUSED. The binder-count WARNING on `T01Concl.partI/partII` is for structure projections, not theorems with proofs, so it can be ignored |
| 11 traced conditions | `T02_L02Consumed` only. This is incomplete; see §3 |
| 12 last writers | prover / drafter, consistent |

## 2. Gap files

None. There is no `T01ModGaps.lean`, and the prover notes record no gaps.

## 3. Per-theorem conditionality

`#pv_hyp_usage` (probe log lines 4-46): every binder of `T01_main`, `T01_S1` and `T01_S3` is USED.

| Parameter (Lean) | Registered id | Actual use | Clause |
|---|---|---|---|
| `hL02 : HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L` | `T02_L02Consumed` | `T01_main` applies it to `h.1 h.2.1` (from `HypPartI`). This feeds S1, which passes it to `T02_main`, where step S2 uses it via `L03_main` (walk path `T01_S1 → T02_main → T02_S2`) | (i) only |
| `hE1 : Prop35` | `T02_Prop35` | S1 → `T02_main` → `T02_S8` (walk) | (i) only |
| `hE6 : GaussFacts` | `T02_GaussFacts` | S1 → `T02_main` → `T02_S6` (walk) | (i) only |
| `hE3 : Thm518` | not registered; intended id `T01_Thm518` | S3, applied directly (T01.lean:38) | (ii) only |

Per-clause check with a positive control:
- `#pv_walk_decl Paper.T01.T01_S1` reaches `Prop35`, `GaussFacts` and `T02_L02Consumed` (log lines 109, 112, 113). The detection works. (The `stopping Paper.T02.T02_main` option did not cut the walk, but that does not affect this conclusion.)
- `#pv_walk_decl Paper.T01.T01_S3` (log lines 135-169) reaches none of those three. It reaches only `Thm518` plus definitions.
- The proof term of `T01_main` (T01.lean:60-61) builds `partII` only from `T01_S3`. So clause (ii) depends only on `Thm518`, and clause (i) depends only on `T02_L02Consumed`, `Prop35` and `GaussFacts`. At the level of the `T01_main` signature, all four are binders and all four are used. All four are therefore conditions of the result.

The script's `TRACED CONDITIONS` missed three conditions:
- `Prop35` and `GaussFacts`, because their Lean names do not match the registered ids `T02_Prop35` and `T02_GaussFacts`;
- `Thm518`, because it is not registered in `EXTERNAL_TOOLS` (`pv_status.py tools` has no entry for it).

Corrected list: `T02_L02Consumed, T02_Prop35, T02_GaussFacts, T01_Thm518`.

## 4. Infrastructure (mech item 8)

| Module | Record | Status |
|---|---|---|
| `Defs` (16) | `DEFS_gate.md` | definitions only, gated, fingerprints identical |
| `L02Stmt` (`Concl._proof_1`, `ConclFixedDelta`) | `L02_gate_r2.md` | definitions only, gated |
| `L03` (30), `L03Stmt` (2) | `L03_final.md` (PASS, CONDITIONAL on `L03_L02Consumed`), `L03_gate.md` | individual final-audit record. Reached only inside T02's proof |
| `T02` (10), `T02Stmt` (16) | `T02_final.md` (PASS, CONDITIONAL), `T02_gate_r2.md` | individual final-audit record. `T02_main` is the only theorem T01 consumes |
| `T01Stmt` (7) | `T01_gate.md` | gated in this result |

Every theorem reached is covered by an individual final-audit PASS record. No helpers lack a record, and no undeclared helpers exist (item 9: none).

Condition chain: `L03_L02Consumed` is a parameter of `L03_main`. Inside `T02_S2`, T02 supplies it from `T02_L02Consumed`; the walk shows no free `L03_L02Consumed` parameter at the T01 level, and T02's audit lists only `T02_L02Consumed`. So it does not appear as a separate condition of T01.

## 5. Route fidelity

Thm 2.2 has no proof of its own. The route, approved by the gate (INVENTORY X3), is: (i) = Thm 5.14, and (ii) = the contrapositive of Thm 5.18.

| Source | Lean | Judgement |
|---|---|---|
| (i) TEX:213: (17) plus eqn:oscillations (18) plus eqn:oscillation2 (19), which are exactly the hypotheses of Thm 5.14 (TEX:864-876) | `T01_S1`: unpacks `HypPartI`, calls `T02_main` | faithful (X3, EXPOSITION_GAP minor, already dispatched) |
| (i) the applicability of L02's clause | `T01_main`: `hL02 h.1 h.2.1` | technical: it routes the predecessor clause under (17) and (18), which are available from `HypPartI` |
| (ii) `‖∇U‖ ≤ M` (TEX:217) vs Thm 5.18's `‖∇U‖ < M` (TEX:979) | `T01_S2`: `M ↦ M+1`, `linarith` | **FAIR_IMPLICIT_STEP** (the source passes silently from a non-strict to a strict bound) |
| (ii) `E_π[e^{s‖x‖}] = ∞` ∀ s>0 against Thm 5.18's necessary condition | `T01_S3`: `Thm518` gives `∃ s>0, ∫ < ⊤`; rewrite with `hinf s hs`; `lt_irrefl` | faithful contrapositive |
| "If either of the following hold" | `T01_main = ⟨S1 ∘ hL02, S3⟩` | faithful assembly |

The proof uses no result stronger than what the source states. `Thm518` is the deterministic-L specialisation of TEX:978-984; the gate approved it as not stronger than the printed theorem. No private helpers exist. The proofs of S1-S3 are unchanged from r1; only the binder of `T01_main` and its one-line proof changed.

## 6. Non-vacuity (probe `auditor_T01_r2.lean`, clean, standard axioms)

| Clause | Witness | What is discharged | Result |
|---|---|---|---|
| (i) via `T01_main … .partI` | d=1, `U=‖x‖⁴/4`, `gU=‖x‖²•x`, ε=1, L=2 | (17), (18), (19), `IsGradField`, `∫⁻e^{-U}<⊤`, and `hL02 := fun _ _ => aud_L02cons …` (from verified L01/L02 theorems) | compiles; only `Prop35`, `GaussFacts`, `Thm518` remain as parameters |
| (ii) via `T01_main … .partII` | d=1, Cauchy-type `U=log(1+‖x‖²)`, `gU=(2/(1+‖x‖²))•x`, ε=1, L=2 | `‖gU‖ ≤ 1`, `∀ s>0, ∫⁻ e^{s‖x‖} dπ = ⊤`, `IsGradField`, `∫⁻e^{-U}<⊤`, and `hL02 := fun h _ => absurd h gc_not_explode` (my own proof that a bounded gradient fails (17)) | compiles; only `Prop35`, `GaussFacts`, `Thm518` remain as parameters |

`#print axioms` for `aud_L02cons`, `gc_heavy` and `gc_not_explode`: `[propext, Classical.choice, Quot.sound]`.

**F1 from r1 is resolved.** Clause (ii) of the main theorem now applies to a genuine heavy-tailed instance. Its premises `Prop35` and `GaussFacts` are nominal for (ii): they are unconditional statements about the kernel and the Gaussian, not constraints on `gU`.

## 7. FAIL items

None.

Record item (not an audit FAIL): `Thm518` (`pv_work/T01Stmt.lean:25`) must be registered in `verification/EXTERNAL_TOOLS.md` with id `T01_Thm518`: provenance (ii), source TEX:978-984 (proof TEX:986-996 via Prop. 3.6), used by T01 step S3, clause (ii), specialised to 𝔏 = δ_L.

## 8. Status for the authors

Verified in Lean along the intended route: (i) follows from Thm 5.14 (T02, CONDITIONAL on `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`), and (ii) is the contrapositive of Thm 5.18 (cited/out-of-scope, parameter `T01_Thm518`); covers fixed L only. Source: no paper error found. Thm 2.2 gives no proof or pointer (X3), it is stated for random 𝔏 (X2), and its `≤ M` versus Thm 5.18's `< M` is a fair implicit step.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: T02_L02Consumed, T02_Prop35, T02_GaussFacts, T01_Thm518

# P03 re-check after the re-proof of upstream T02 (gated statement unchanged)

- Auditor: pv-auditor (independent, Opus), Tue Oct 13 11:28 EDT 2026 (from `date`)
- Mode: re-check (v1.3.1). Previous records: `verification/audits/P03_mech.md` (01:48; copied aside before the run to `pv_work/probes/auditor/P03/P03_mech_before_recheck.md`), `verification/audits/P03_final.md` (01:51).
- New mechanical report (I ran it): `python3 scripts/pv_audit_mech.py P03` -> `verification/audits/P03_mech_r2.md`, **MECH CHECKS: PASS**. The script wrote `_r2`, so `P03_mech.md` was not overwritten.
- Probe: `pv_work/probes/auditor/P03/auditor_P03_recheck.lean`, log `pv_work/logs/auditor_P03_recheck_2.log` (exit=0, 0 errors, 0 sorry).

## 1. Comparison with the previous mechanical report

| Item | Before (P03_mech.md) | Now (P03_mech_r2.md) | Same? |
|---|---|---|---|
| 1 compile | PASS, 0 errors / 0 sorry | PASS, 0 errors / 0 sorry | yes |
| 2 rebuild sha256 | ca7f27a5…a19ba621 IDENTICAL | ca7f27a5…a19ba621 IDENTICAL | yes (same .olean as at the final audit) |
| 3 PVTools hash | 445fe54f… | 445fe54f… | yes |
| 4 fingerprints (10 gated decls vs P03_gate.md) | all identical | all identical | yes |
| 6 `#pv_axioms P03` | ALL STANDARD | ALL STANDARD (8 decls, also in my probe log :74-82) | yes |
| 7 `#pv_walk P03` | no sorryAx; propext, Classical.choice, Quot.sound | same | yes |
| 8 modules reached | L01Stmt 5, P02Stmt 2, P03Stmt 3, T02Stmt 8 | same constants, same counts | yes |
| 8 record for T02Stmt | `T02_gate_r2.md` (now `audits/rev1/`) | `T02_gate.md` (post-revision gate, STATEMENT GATE: PASS) | changed record, same content: fingerprints of `IIDCopies`, `StDom`, `T02_L01Consumed` identical in `rev1/T02_gate_r2.md` :44-46 and `T02_gate.md` :117-119 |
| 9 helpers | exists_mid, halve, law_fst, law_snd | same | yes (audited in P03_final §5) |
| 10 `#pv_hyp_usage` | no UNUSED (6,7,7,9,5,10,8,10) | same | yes |
| 11 TRACED CONDITIONS | T02_L01Consumed | P03_P02Consumed, P03_T02Consumed, T02_L01Consumed | text differs; explained below |

Item 11: the earlier trace showed only `T02_L01Consumed` because `P03_T02Consumed` and `P03_P02Consumed` were then unregistered. P03_final §4/§9 asked for their registration and its CONDITIONS line already listed all three. They are now registered (`pv_status.py tools`), so the new trace equals the CONDITIONS line of `P03_final.md`. The conditions themselves did not change.

Item 8 and upstream: P03's closure reaches only `T02Stmt` from T02, not the module `T02`, so the re-proof of T02 cannot change P03's `.olean` (confirmed: hash identical). T02Stmt is covered by the new gate `T02_gate.md` (PASS); T02's new final audit `T02_final.md` (11:24) ends `FINAL AUDIT: PASS / SUGGESTED VERDICT: CONDITIONAL / CONDITIONS: T02_L01Consumed`.

## 2. `P03_T02Consumed` against the T02 main theorem

`T02_main` (`pv_work/T02.lean:611`), signature printed in the probe log :83-88: `T02_L01Consumed → ∀ {Ω} [MeasurableSpace Ω] (μ) [IsProbabilityMeasure μ] {n} X Xs, IIDCopies μ X Xs → IsInvSub (μ.map X) → ∀ θ, (∀ i, 0 ≤ θ i) → ∑ θ i = 1 → StDom μ X (∑ θ i * Xs i)`.

`P03_T02Consumed` (`pv_work/P03Stmt.lean:17-23`) is the instance n = 2, θ = (1/2, 1/2), with `T02_L01Consumed` as the first antecedent (same order as `T02_main`). Exact type equality by `rfl` does not apply (the clause is a specialisation, as approved at the P03 gate), so I used the instantiation check:

| Check | Result |
|---|---|
| `theorem auditor_P03_T02Consumed_holds : Paper.P03.P03_T02Consumed := fun hL01 _ _ μ _ X Xs hiid hits => T02_main hL01 μ X Xs hiid hits (fun _ => 1/2) (fun _ => by norm_num) (by simp)` | compiles; the conclusion is accepted by definitional unfolding only (no tactic acts on the goal; the tactics only discharge θ ≥ 0 and ∑ θ = 1) |
| `#print axioms` | propext, Classical.choice, Quot.sound |
| `#pv_walk_decl` | sorryAx false; reaches `T02_main`, `T02_S1`-`T02_S8` and T02 private helpers (all under `T02_final.md` PASS), T02Stmt/L01Stmt defs with fingerprints equal to the gate snapshots |

So `P03_T02Consumed` still matches, and it now follows from T02's main theorem under T02's only condition `T02_L01Consumed`. P03 already carries `T02_L01Consumed` as its own parameter.

## 3. Notes for the coordinator (not FAIL items)

- `P03_T02Consumed` is now discharged by `T02_main` given `T02_L01Consumed` (probe above). A reconnection (`P03Closed_r<k>`) could remove it from P03's conditions, leaving `T02_L01Consumed, P03_P02Consumed`. Until such a reconnection is audited, the recorded conditions stay unchanged.
- `EXTERNAL_TOOLS.md`, row `P03_T02Consumed`, still says "T02 is ISSUE (B06); the clause is not closed by the source." That is out of date given `T02_final.md` (CONDITIONAL on T02_L01Consumed). The coordinator should update the human-check text.
- P03_final §4 says "T02_main as a whole is not verified (S10b)". That refers to the earlier T02 version and is superseded by the T02 re-proof. It does not affect P03's verdict, which already treated the clause as a condition.

## 4. Conclusion

Fingerprints, `.olean` hash, axioms, sorry walk and hypothesis usage are the same as at the final audit. The conditions are the same as the `CONDITIONS` line of `P03_final.md`, which is now matched mechanically. Item 8 covers T02Stmt with the new T02 gate, and T02 has a new final audit with a PASS record. P03 keeps its verdict: CONDITIONAL on P03_T02Consumed, P03_P02Consumed and T02_L01Consumed.

RECHECK: PASS

# T01 final audit, round 2 (Theorem thm:ks, source/main.tex:53-63)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5, session c83df710), Tue Oct 13 01:07 EDT 2026.
- Audited object: `pv_work/T01.lean` (complete, no gap file; olean sha256 `2b288052…891e12`, private rebuild IDENTICAL). Previous audit `T01_final.md` was on `T01ModGaps.lean` (S1 stopped); since then S1 has been proved (pass 2, proof session 2, pv-prover a54cad74, 2026-10-12 22:45).
- Read myself: `source/main.tex` (whole file: definitions 24-31, result 53-58, proof 60-63, bibliography 65-74); `pv_work/T01.lean` (all 447 lines); `pv_work/T01Stmt.lean` (all); prover notes `pv_work/notes/T01_prover_notes.md` (all); gate report `T01_gate.md` (relevant sections); previous final audit `T01_final.md`; tool registry (`pv_status.py tools`).
- Mechanical report: `verification/audits/T01_mech_r3.md` (run by me: `python3 scripts/pv_audit_mech.py T01`): **MECH CHECKS: PASS**.
- My probe: `pv_work/probes/auditor/T01/auditor_T01_nonvac_r3.lean`, log `pv_work/logs/auditor_T01_nonvac_r3_1.log`, exit=0, 0 errors, 0 sorry, standard axioms. (An earlier probe `auditor_T01_nonvac_r2.lean`, from an interrupted run, fails only because it imports `T01_mod_gaps` without importing `T01ModGaps`. That module cannot be imported alongside `T01` because the public names clash. It is superseded by r3, and its `rfl` comparison is replaced by mech item 4.)

## 1. Mechanical checks (from `T01_mech_r3.md`)

| # | Check | Result |
|---|---|---|
| 1 | check `T01` | PASS: exit 0, 0 errors, **0 sorry** |
| 2 | private rebuild + sha256 | PASS, IDENTICAL |
| 3 | PVTools.lean hash | PASS |
| 4 | 22 gated fingerprints (th/vh/bi) vs `T01_gate.md` | PASS, all identical (incl. S1 th 253117068, T01 th 2870806094) |
| 5 | Defs vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms T01` | PASS, ALL STANDARD |
| 7 | `#pv_walk T01` | PASS: sorryAx not reached; closure axioms propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` on gated theorems | no UNUSED. The binder-count warnings on `KSConclusion.cdf/.conv` (auto-generated projections) and on `T01_S6` (the proof term `hKol Ω' Q B hB` is eta-reduced over `z`, `0 < z`) are harmless |
| 11 | TRACED CONDITIONS | `DonskerUniformSup, KolmogorovFormula` (confirmed in §4) |
| 12 | last writers | pv-prover (T01.lean), pv-drafter (T01Stmt.lean): PASS |

There is no gap file, so the §2b gap checks do not apply. `T01.lean` contains every gated obligation (S1 to S6 and the main theorem), and every one is proved.

## 2. Infrastructure (items 8, 9)

| Constant | Record / my review | Judgement |
|---|---|---|
| `Paper.Defs.{Dn, cdfOf, edf, edfRV}` | `DEFS_gate.md` (fingerprints identical) | covered |
| `Paper.T01.{ConvInDist, IsBrownianBridge, supAbs, Kfun(+_proof_1), KSConclusion(.mk), DonskerUniformSup, KolmogorovFormula}` | `T01_gate.md` (definitions only; fingerprints identical) | covered |
| `T01_S1`…`T01_S6`, `T01` | this audit (§3) | PASS |
| private `edf_bounds`, `cdfOf_eq_cdf`, `Iic_inter_Icc01`, `pit_law`, `law_comp` | audited individually in `T01_final.md` §3; source text re-read now, unchanged except that `edf_bounds` moved above S1 | PASS (re-confirmed) |
| private `meas_finset_sup` (new) | finite `Finset.sup` of measurable `EReal`-valued functions is measurable; induction with `Measurable.max` | true, technical; `Finset.measurable_sup` reported absent by the prover (probe "unknown constant"; not needed for the verdict). PASS |
| private `meas_finset_inf` (new) | dual, with `Measurable.min` | true, technical. PASS |
| private `meas_exists_mem_Ico` (new) | for fixed `U ⊆ ℝ` and measurable `L, R : Ω → EReal`, `{ω ∣ ∃ t ∈ U, L ω ≤ t < R ω}` is measurable; it equals `{ψ(L ω) < R ω}` with `ψ a = sInf (U ∩ [a,∞))` monotone, so it is measurable (`Monotone.measurable`, `measurableSet_lt`) | true (I checked the set equality: `sInf_lt_iff` gives exactly a witness `t ∈ U`, `a ≤ t`, `t < R`); non-vacuous; mentions no conclusion. PASS |
| `*._proof_k` | compiler-generated | covered by parents |

No other project module is reached (L01, P01 are not in the closure). No helper states or assumes the target conclusion.

## 3. Route fidelity

| Source | Lean | Assessment |
|---|---|---|
| main.tex:54-55 "√n D_n converges in distribution" (D_n main.tex:29-31) presupposes D_n is a random variable | `T01_S1`: `Measurable (Dn P X n)` for any `P`, measurable `X` | **FAIR_IMPLICIT_STEP** (ruling `T01_issue_1.md` §6; gate S1 row). How it was filled in: case split on whether `cdfOf` is bounded above. If unbounded (only possible for a non-probability `P`, Lean junk), `Dn ≡ 0`. If bounded, `{Dn > r} = ⋃_{S ⊆ Fin n} {∃ t ∈ U_S, max_S X_i ≤ t < min_{Sᶜ} X_i}`, because `F_n(t)` depends on `t` only through `{i : X_i ≤ t}` (main.tex:26). This is a finite union of measurable sets. Purely a measurability fact, no new mathematical claim. I checked the proof (lines 67-144); it compiles. **Not consumed** by S5/S6/T01 (it appears in no proof term of the assembly), but it closes the Bochner-junk concern of gate item 4 for every sample, including the uniform one inside `DonskerUniformSup`. |
| (silent) reduction from continuous F to uniform samples | `T01_S2` (measurability, `iIndepFun.comp`, PIT via `pit_law`), `T01_S3` (D_n(X) = D_n(F∘X) a.s., null event F(X_k) ∈ F(ℚ), IVT, ciSup comparison), `T01_S4` (`integral_congr_ae`) | **FAIR_IMPLICIT_STEP** (ruling `T01_issue_1.md` §5; continuity hypothesis main.tex:54). I re-read the proofs: identical to what `T01_final.md` §5 audited. S3 uses `C = F(ℚ)` instead of the ruling's `N ∪ Z`, which changes only the form |
| main.tex:61 "Donsker's invariance principle for the empirical process", 61-62 "applied to the supremum, which is a continuous functional" | `T01_S5`: `hDon` applied to `U k = F ∘ X k` (line 422), then S4 + S3 | Source route. The parameter is the uniform case, weaker than the general-F principle the source invokes; the sup-functional step is folded into the citation (gate §6, accepted) |
| main.tex:62 "The form of K is due to Kolmogorov" | `T01_S6 := hKol Ω' Q B hB` | Source route; the parameter is exactly as strong as the source's use (`z > 0`) |
| main.tex:53-58 | `T01 := ⟨S5 …, S6 …⟩` | both clauses |

No route change; no stronger result used than the source cites; the private helpers are technical conversions or the recorded fair fill-ins. The `n = 0` case in S3 is Lean junk outside the source's `n ≥ 1` and is handled technically.

## 4. Per-theorem conditionality (`#pv_hyp_usage`, probe r3)

| Parameter | Where actually used | Clause |
|---|---|---|
| `DonskerUniformSup` | `T01` → `T01_S5` (USED; applied directly at T01.lean:422; not passed further) | `conv` (main.tex:54-56, proof 61-62) |
| `KolmogorovFormula` | `T01` → `T01_S6` (USED; the proof term is `hKol …`) | `cdf` (main.tex:56-57, proof 62) |

- S1, S2, S3, S4 have no external parameter in their signatures, so they cannot use one. Because these tools are Prop hypotheses, not constants, the binder analysis is decisive and a walk is not needed.
- `conv` does not depend on `KolmogorovFormula`; `cdf` does not depend on `DonskerUniformSup`. Neither clause is unconditional.
- Both tools are registered (`pv_status.py tools`), type (i). There is no recorded debt and no unencoded part.

## 5. Non-vacuity (probe r3, exit 0, standard axioms)

- `P = infinitePi (fun _ => volume.restrict (Icc 0 1))` and `X k ω = ω k`. Proved: measurability, `iIndepFun`, identical laws, `cdfOf = max (min t 1) 0`, continuity. Then `nonvac_T01 (hDon) (hKol) : KSConclusion P X := T01 …` compiles, so the hypotheses are jointly satisfiable by a nondegenerate continuous law.
- `nonvac_S1` (S1 at n = 5) and `nonvac_S2` (the PIT law clause) also compile on the same witness.
- The continuity hypothesis is a real restriction (Dirac-0 counter-witness in `auditor_T01_nonvac.lean`, round 1).
- That a Brownian bridge exists in the encoded sense is argued in gate item 46. The truth of the two tools is a human check.

## 6. FAIL items

none.

## 7. Records to update

- `RESULTS.json`: T01 gaps list is now empty (S1 proved); `T01ModGaps.lean` is superseded by `T01.lean`.
- `EXTERNAL_TOOLS.md` / tool record `DonskerUniformSup`: the human-check note "measurability of D_n … is the unproved Lean lemma T01_S1" is outdated. `T01_S1` is now proved for every `P`, so this point is settled in Lean. The rest of the note stands.

## 8. Status for the authors

Verified in Lean: the whole of Theorem thm:ks along the printed route, plus the standard unprinted reduction of continuous F to uniform samples and the measurability of D_n (FAIR_IMPLICIT_STEP). This rests on two cited results: Donsker 1952 (→ `conv`) and Kolmogorov 1933 (→ `cdf`).
No error, gap or ambiguity in the source. There are editorial notes only: the uniform reduction could be stated in one sentence at main.tex:61, and the bridge form of K is due to Doob and Donsker (main.tex:62).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: DonskerUniformSup, KolmogorovFormula

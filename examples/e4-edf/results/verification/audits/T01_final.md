# T01 final audit (Theorem thm:ks, source/main.tex:53-63)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Mon Oct 12 22:32:52 EDT 2026
- Audited object: `pv_work/T01ModGaps.lean` (sha256 `206a7a19…02dd9f`); `pv_work/T01.lean` (`a2b143fe…b9a0ce`, contains `sorry` for S1, no olean); `pv_work/T01Stmt.lean` (`93560a47…050bc3`, same hash as in the gate report).
- Read myself: `source/main.tex` (whole file, 76 lines; result 53-58, proof 60-63, conventions 24-31); `pv_work/T01ModGaps.lean`, `T01.lean` (diff), `T01Draft.lean`, `T01Stmt.lean`, `Defs.lean` (all in full); gate report `T01_gate.md`; issue ruling `T01_issue_1.md`; prover notes `T01_prover_notes.md`.
- Mechanical report: `verification/audits/T01_mech.md` (run by me, `python3 scripts/pv_audit_mech.py T01 --module T01ModGaps`): **MECH CHECKS: PASS**.
- My probes: `pv_work/probes/auditor/T01/auditor_T01_stmt.lean` (log `pv_work/logs/auditor_T01_stmt_1.log`, exit=0, 2 sorry = the verbatim copies), `pv_work/probes/auditor/T01/auditor_T01_nonvac.lean` (log `pv_work/logs/auditor_T01_nonvac_2.log`, exit=0, 0 sorry).

## 1. Mechanical checks (from `T01_mech.md`)

| # | Check | Result |
|---|---|---|
| 1 | compile `T01ModGaps` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools.lean hash | PASS |
| 4 | 22 gated fingerprints vs gate snapshot | PASS |
| 4b | `T01_S1_Gap` vh = gate th of `T01_S1` (253117068) | PASS |
| 5 | Defs vs DEFS snapshot | PASS |
| 6-7 | `#pv_axioms`, `#pv_walk`: no sorryAx, axioms only propext/Classical.choice/Quot.sound | PASS |
| 10 | `#pv_hyp_usage`: no UNUSED hypothesis in any gated theorem | PASS |
| 11 | TRACED CONDITIONS: none | **Incorrect as a record, corrected in §4** (the two tools are not registered in `external_tools`, so the script cannot trace them) |

## 2. Gap file checks (VERIFICATION_METHODS §2b)

| Check | Result |
|---|---|
| Verbatim copy of gated `T01` (T01Draft.lean:9-16) under its original name: th | 2870806094 = gate snapshot |
| Verbatim copy of gated `T01_S1` (T01Draft.lean:20-22): th | 253117068 = gate snapshot |
| `example : T01_S1_Gap = type_of% @T01_S1 := rfl` | compiles |
| `example : type_of% @Paper.T01.T01 := @Paper.T01.T01_mod_gaps` (**no Gap argument**) | compiles |
| `example : type_of% @T01 = type_of% @T01_mod_gaps := rfl` | compiles |
| `T01.lean` vs `T01ModGaps.lean` (`diff`) | differ only in S1 → `def T01_S1_Gap` and in the rename `T01` → `T01_mod_gaps` (plus docstrings); all other obligations identical |
| Gap-dependent obligations | none |
| `#pv_walk_decl Paper.T01.T01_mod_gaps` | 18 T01ModGaps constants reached, `T01_S1_Gap` **not** among them; sorryAx false |
| Positive control: `#pv_walk_decl` on a probe theorem taking `T01_S1_Gap` | `T01_S1_Gap` detected (REACHED via AuditCtrl) |

So the **entire gated main statement** is proved without S1.

## 3. Infrastructure (item 8, item 9)

| Constant | Record / my review | Judgement |
|---|---|---|
| `Paper.Defs.{edf, edfRV, cdfOf, Dn}` | `DEFS_gate.md` (PASS, fingerprints identical) | covered |
| `Paper.T01.{ConvInDist, IsBrownianBridge, supAbs, Kfun, KSConclusion(.mk), DonskerUniformSup, KolmogorovFormula}` | `T01_gate.md` (PASS, fingerprints identical; both tools approved as type (i)) | covered (definitions, no theorems) |
| `T01_S2`…`T01_S6`, `T01_mod_gaps` | this audit | PASS (see §5) |
| private `cdfOf_eq_cdf` | read: `cdfOf P X = cdf (P.map (X 0))` for measurable `X 0`, probability `P` | true; pure conversion to mathlib's `cdf` (main.tex:30-31); PASS |
| private `Iic_inter_Icc01` | `Iic u ∩ Icc 0 1 = Icc 0 (min u 1)` | true set identity; PASS |
| private `pit_law` | probability `μ` on ℝ with continuous `cdf μ` ⇒ `μ.map (cdf μ) = volume.restrict (Icc 0 1)` | true (probability integral transform); this is the content of §5 S2.3 of the issue ruling, i.e. part of the FAIR_IMPLICIT_STEP fill-in, not a new statement beyond S2; non-vacuous (e.g. uniform law); does not mention the conclusion; PASS |
| private `law_comp` | S2's third conjunct with `hind` dropped (it is not needed for the law) | true, weaker-premise form of a gated obligation's clause; PASS |
| private `edf_bounds` | `0 ≤ edf x t ≤ 1` (also for `n = 0`) | true technical bound; PASS |
| `*._proof_k` auxiliaries | compiler-generated | covered by their parents |

All helpers: axioms standard (walk closure); none states or assumes the target conclusion. No other project module is reached (L01, P01 not in the closure).

## 4. Per-theorem conditionality

| Parameter | Used where (`#pv_hyp_usage`, walk) | Clause |
|---|---|---|
| `DonskerUniformSup` | `T01_mod_gaps` → `T01_S5` (USED, applied at T01ModGaps.lean:303 to `U = F∘X`) | `conv` (main.tex:54-56; proof main.tex:61-62) |
| `KolmogorovFormula` | `T01_mod_gaps` → `T01_S6` (USED, `hKol Ω' Q B hB`) | `cdf` (main.tex:56-57; proof main.tex:62) |

- S2, S3, S4 use no external parameter (their signatures contain none; walks above).
- The `cdf` clause does not depend on `DonskerUniformSup`; the `conv` clause does not depend on `KolmogorovFormula`. Neither clause is unconditional.
- **Correction to mech item 11**: TRACED CONDITIONS should be `DonskerUniformSup, KolmogorovFormula`. Both are type-(i) visible parameters approved by the gate (`T01_gate.md` §6) but not yet registered in `RESULTS.json` `external_tools` / `EXTERNAL_TOOLS.md` (the registry has only `GlivenkoCantelli`; the two appear only under "Candidates"). The coordinator must register them (`pv_status.py add-tool`), with the gate's notes: `DonskerUniformSup` provenance (i), uniform case only, sup-functional step covered by the citation; `KolmogorovFormula` provenance (i), human-check note on attribution (Kolmogorov 1933 vs Doob/Donsker bridge form).
- Note for the human check of `DonskerUniformSup`: in its Lean form (Bochner integrals in `ConvInDist`) its truth also uses that `Dn P U n` is a.e.-strongly measurable for the uniform sample (a standard fact: right-continuity of `t ↦ |G_n(t) - G(t)|` reduces the sup to ℚ). This is the only place where the content of S1 matters (see §7).

## 5. Route fidelity (source sentence by sentence)

| Source | Lean | Assessment |
|---|---|---|
| main.tex:61 "The convergence is Donsker's invariance principle for the empirical process \cite{donsker}" | `T01_S5`: `hDon` applied to `U k = F ∘ X k` | Source route. The tool is the uniform case, weaker than the general-F principle the source invokes (gate §6). |
| main.tex:61-62 "applied to the supremum, which is a continuous functional" | folded into `DonskerUniformSup` (sup-level statement) | Covered by the citation (gate §6 ruling, accepted); no hidden step. |
| (silent) reduction of continuous F to uniform samples | `T01_S2` (PIT, independence, measurability), `T01_S3` (D_n(X) = D_n(F∘X) a.s.), `T01_S4` (a.e.-equal sequences share limits in distribution) | **FAIR_IMPLICIT_STEP** (ruling `T01_issue_1.md` §3, §5; I concur: the printed continuity hypothesis main.tex:54 exists for exactly this step, and it is standard). Filled in as: S2 by `Continuous.measurable`, `iIndepFun.comp`, `pit_law` (sublevel sets of a continuous cdf are `Iic q` with `F q = u`); S3 by the null event "some `F(X_k ω) ∈ F(ℚ)`" (countable set, Lebesgue-null under the uniform law), the pointwise equivalence `X_k ≤ t ↔ F(X_k) ≤ F(t)` off it, the IVT for `range F ⊇ (0,1)`, and a ciSup comparison; S4 by `integral_congr_ae`. S3 uses `C = F(ℚ)` instead of the ruling's `N ∪ Z`: same mathematics (flat-spot null event + uniform law), a difference of form only. |
| (Lean junk) `n = 0` in S3 | handled by `le_of_tendsto'` (both sides equal 1) | outside the source's scope (Defs D01 `n ≥ 1`); technical; fine. |
| main.tex:62 "The form of K is due to Kolmogorov \cite{kolmogorov}" | `T01_S6 := hKol …` | Source route; the parameter is exactly as strong as the source's use (`z > 0`). |
| main.tex:53-58 assembly | `T01_mod_gaps := ⟨S5, S6⟩` | Both clauses. |

No route change; no result stronger than the source's citations; helpers are technical conversions or the recorded fair fill-in.

## 6. Non-vacuity (`auditor_T01_nonvac.lean`, exit 0, 0 sorry, standard axioms)

- Nontrivial witness: `P = infinitePi (fun _ => volume.restrict (Icc 0 1))`, `X k ω = ω k`. Proved: measurability, `iIndepFun`, identical laws, and `cdfOf P X = fun t => max (min t 1) 0`, hence continuous. `example (hDon) (hKol) : KSConclusion P X := T01_mod_gaps hDon hKol …` compiles: all hypotheses of the main theorem are jointly satisfiable by a nondegenerate continuous law.
- The continuity hypothesis is a real restriction: the Dirac-0 sample has a discontinuous `cdfOf` (proved in the probe).
- The tools themselves are classical true statements (gate §6); their truth is the human check, not a Lean check.

## 7. S1 and the verdict

- S1 (`Measurable (Dn P X n)` for arbitrary `P`) is stopped, BUDGET_EXHAUSTED (two proof sessions; prover notes, session 2). It is **formalization side**, never a paper issue: the source never states it; issue ruling §6 classifies it FAIR_IMPLICIT_STEP; the gate (item 5) judged it true. I agree it is true; I did not prove it.
- It is **not consumed** by any step: confirmed by the walk + positive control and by the gap-free `example` in §2. The main theorem `T01_mod_gaps` has the identical type (th 2870806094) as the gated `T01`.
- Its only role is semantic: the gate's faithfulness argument for `ConvInDist` (gate item 4: "the Bochner junk trap does not fire because D_n is measurable") cites it. For T01's hypotheses this is needed only for the uniform sample `U` (S3 then transfers a.e.), i.e. it is part of the truth of `DonskerUniformSup` in its Lean form, not of the derivation.
- **Effect on the verdict (by the rules).** VERDICTS §1.2: "A result with gaps can only be ISSUE or UNFINISHED." T01 has a recorded gap (S1 in `gaps`, `sorry` in `T01.lean`) and no confirmed paper-side issue, so the verdict is **UNFINISHED** (stage 4 proof, reason BUDGET_EXHAUSTED at S1), with the partial result: *the whole gated main statement (both clauses) is verified conditionally on `DonskerUniformSup` (conv) and `KolmogorovFormula` (cdf), with no gap premise.* It must not be ISSUE.
- **Path to CONDITIONAL (recommendation, coordinator/gate decision, not mine):** since S1 is not a step of the source route and not consumed, removing it from the obligation list does not change any consumed declaration or the main theorem's type. This is a change to the gated draft, so it needs a gate decision (`T01_gate_r2.md`). If the gate drops S1, then `T01.lean` without S1 is `T01_mod_gaps` renamed, with no `sorry`; after a build and a mechanical re-check (fingerprints of the remaining gated declarations unchanged), the result meets VERDICTS §1.2 as CONDITIONAL with conditions `DonskerUniformSup`, `KolmogorovFormula`. If it is dropped, the gate should record the measurability of `Dn` for the uniform sample as a human-check point of `DonskerUniformSup` (see §4), so that the semantic role of S1 stays visible. Dropping it merely because it is hard would not be acceptable if it were consumed; here it is not.

## 8. Status for the authors

Verified (modulo the two cited results Donsker 1952 → `conv`, Kolmogorov 1933 → `cdf`): the whole statement of Theorem thm:ks along the printed route, plus the standard unprinted reduction of continuous F to uniform samples (FAIR_IMPLICIT_STEP).
Open on the formalization side only: measurability of D_n (S1, unused by the proof). No error, gap or ambiguity in the source for this result; optional editorial: one sentence on the uniform reduction (main.tex:61) and the attribution of the bridge form of K (main.tex:62, EDITORIAL per gate).

## 9. FAIL items

none (the mech item 11 "TRACED CONDITIONS: none" is a records omission, corrected in §4; it is not a defect of the audited artifact).

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNFINISHED   (stage proof, BUDGET_EXHAUSTED at S1, an unused formalization-side obligation; partial: whole gated statement verified conditionally on the two tools with no gap premise; CONDITIONAL once the gate drops S1, see §7)
CONDITIONS: DonskerUniformSup, KolmogorovFormula   (not yet registered ids; register via add-tool)

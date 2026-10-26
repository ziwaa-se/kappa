# T01 statement gate (re-review after encoding fix E1 / final-audit F1)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5). Date: Tue Oct 13 01:51:10 EDT 2026.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 31c0d3fbc36637a8158bc1763420cdf85c0c5f8222951c8d7761b5b7c2e7fa76
  - `pv_work/T01Draft.lean` a39c82d829091a7f33820166787a5b4ae4e628fe5d94a183886de95c95bc4ff5
- Also read: `pv_work/T02Stmt.lean` (full), `pv_work/Defs.lean` (HypExplode/HypOscillations/HypOscillation2/IsGradField/piDens/E),
  `T02.lean:324-336` (`T02_main` signature), `L02.lean:561-625` (`L02_S10`, `L02_main_fixedDelta_osc`),
  previous gate `verification/audits/revenc1/T01_gate_r2.md`, final audit `verification/audits/revenc1/T01_final.md` (F1),
  draft notes (leads only).
- Source read directly: TEX:185-229, 855-904, 970-999 (`source/geo_erg_HMC_v3.1.tex`).

## Compilation

- `scripts/pv_lean.sh check T01Draft`: `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_6.log`. The 4 sorries are the bodies of `T01_main`, `T01_S1`, `T01_S2`, `T01_S3` (draft).
- Snapshot probes: `pv_work/logs/gate_T01_stmtcopy_2.log` (exit 0, 0 sorry), `pv_work/logs/gate_T01_draftcopy_2.log` (exit 0, 4 sorry).
- Gate probe `pv_work/probes/gate/T01/gate_T01_nonvac.lean`: log `pv_work/logs/gate_T01_nonvac_2.log`, exit 0, 0 sorry; `#print axioms` of `bdd_not_explode` and `assembly`: `[propext, Classical.choice, Quot.sound]`.

## Scope of this re-review

Change E1 (draft notes, amendment log): only the `T01_main` binder `hL02` changed, from
`T02_L02Consumed gU eps L` to `HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L`, plus docstring.
Checked with `#pv_type_hashes`, not by eye: all 12 `T01Stmt` lines are identical to the r2 snapshot (`revenc1/T01_gate_r2.md:29-40`), including `Thm518` vh=3970237549, and `T01_S1`, `T01_S2`, `T01_S3` have the same th/bi. Only `T01_main` changed: th 1845210232 -> 2118693897, bi unchanged (`ieeeeeeeeeeeee`). So no other statement change was introduced. Items not affected by E1 were re-read against the source and are confirmed briefly below.

## Source quotations

- Thm 2.2 (TEX:208-219): "If either of the following hold then HMC will *not* produce a geometrically ergodic Markov chain: (i) lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞ and (eqn:oscillations) and (eqn:oscillation2) are satisfied; (ii) There is an M<∞ such that ‖∇U(x)‖ ≤ M for all x ∈ X, and E_π[e^{s‖x‖}]=∞ for every s>0." No proof.
- Thm 5.14 (TEX:863-876): (17) explode, (18) oscillations with fixed C, (19) oscillation2 with 2^L ⇒ HMC with fixed T = Lε not geometrically ergodic for any T>0. Proof TEX:879-880: "Lemmas xelower and xlower ... establish ‖x_{Lε}‖ ≥ 2^L‖x_0‖", then Lemma arate_0, Prop. 3.5, Gaussian tail.
- Lemma xlower (TEX:899-901): hypothesis (17) only (its proof uses (18), see L02 issue; `L02_main_fixedDelta_osc`, `L02_S10` take `hexp`, `hosc`).
- Thm 5.18 (TEX:978-984): "If ‖∇U(x)‖ < M for all x ∈ X, then a necessary condition for HMC to produce a geometrically ergodic Markov chain is ∫ e^{s‖x‖}π(dx) < ∞ for some s>0." Proof TEX:986-996 (via Prop. 3.6).
- Conventions: X = R^d, Euclidean norm, π finite target with Lebesgue density (TEX:192).

## Item rulings

### 1. Hypotheses: PASS
- Part (i): `HypPartI = HypExplode ∧ HypOscillations ∧ HypOscillation2 U L` matches TEX:213 with (17)-(19) of TEX:865-875 (unchanged, r2-gated).
- Part (ii): `HypPartII` = `∃ M, ∀ x, ‖gU x‖ ≤ M` and `∀ s>0, ∫⁻ e^{s‖x‖} dπ = ⊤` matches TEX:217 (unchanged).
- Standing premises `0<d`, `IsGradField`, `∫⁻ e^{-U} < ⊤`, `0<eps`, `1≤L`: TFA-A, approved before, unchanged.
- **New binder `hL02` (the point of E1).** It is the (p) consumed clause of L02 stated under exactly the applicability conditions L02 needs: (17) `HypExplode` (printed hypothesis of Lemma xlower, TEX:900) and (18) `HypOscillations` (used in L02's proof; `L02_main_fixedDelta_osc`/`L02_S10` take exactly `hexp`, `hosc`, besides `heps` (a premise of `T01_main`) and L02's own L01 clause). Hence:
  - not stronger than needed: it is implied by the old binder (`new_binder_weaker` in the probe) and demands the clause only where the source's route (TEX:879 → Lemmas 5.15/5.16) applies, i.e. under (i);
  - satisfiable/dischargeable: in the (i) situation it is what L02 provides (the final auditor already discharged the stronger unconditional form for `U = ‖x‖⁴/4`, `revenc1/T01_final.md` §6); outside (17) it holds vacuously;
  - not goal-shaped: its conclusion is a leapfrog growth bound, not `¬ GeomErgodic` or anything equivalent.
- Hidden hypotheses: none in structures/classes/variables (no `variable`s; `T01Concl` fields are the two clauses).

### 2. Conclusion: PASS
`T01Concl` (unchanged): `partI : HypPartI → ¬ GeomErgodic`, `partII : HypPartII → ¬ GeomErgodic`. Neither weakened nor strengthened; scope restriction to 𝔏 = δ_L stated in docstrings (X2, already dispatched).

### 3. Quantifiers and constants: PASS
`ε, L` universally quantified at the theorem level (TFA-B reading, approved before); `M`, `s` inside `HypPartII` as in TEX:217. The new binder is per `(gU, eps, L)`, which matches L02's per-`(gU, ε, L)` conclusion. No constant chosen out of order.

### 4. Domains and details: PASS (unchanged)
`E d = EuclideanSpace ℝ (Fin d)`; `E_π[e^{s‖x‖}] = ∞` encoded with `∫⁻` and `ENNReal.ofReal` of a positive function (no truncation trap); `targetMeas` normalised with `∫⁻ e^{-U} < ⊤`. Bound `≤ M` vs `< M` handled by S2.

### 5. Step obligations: PASS
- S1 (TEX:213 ↔ Thm 5.14): still takes `hL02 : T02_L02Consumed gU eps L` unconditionally, together with `h : HypPartI U gU L`. This is fine: S1 is only meaningful under (i) (its hypothesis `h`), and under (i) the conditional binder of `T01_main` yields exactly this premise via `hL02 h.1 h.2.1`. S1 is true as stated (it is `T02_main` with the unpacked `h`), it is not vacuous (auditor's `U = ‖x‖⁴/4` instance), and it does not smuggle the conclusion. Making S1's binder conditional too would be equivalent in the presence of `h`; not required. For reconnection, S1's premise can be discharged from L02 using `h.1`, `h.2.1`, so this does not block closure.
- S2 (`≤ M` ⇒ `< M+1`): true, FAIR_IMPLICIT_STEP (unchanged).
- S3 (contrapositive of Thm 5.18): true given `Thm518`; does not use `hL02`, `Prop35`, `GaussFacts` (unchanged).
- Assembly: checked in Lean (`assembly` in the probe): with S1 and S3 as stated as hypotheses and the new `T01_main` binders, `T01Concl` follows by `⟨fun h => S1 … (hL02 h.1 h.2.1) … h, fun h => S3 … h⟩`. Compiles, standard axioms.
- **Non-vacuity of part (ii) (F1 resolved).** Probe `bdd_not_explode`: for `0 < d` and every `gU` with `‖gU x‖ ≤ M` for all `x`, `¬ HypExplode gU`. Hence `hL02_free_on_bounded`: under the first conjunct of `HypPartII`, the new binder holds for free, so `T02_L02Consumed` is no longer required for part (ii). Together with the auditor's Cauchy-type instance satisfying `HypPartII` and all standing premises (`revenc1/T01_final.md` §6), `(T01_main …).partII` now applies to genuine part-(ii) instances, conditional only on `Prop35`, `GaussFacts`, `Thm518` as parameters.
- Remaining parameters `hE1 : Prop35`, `hE6 : GaussFacts` stay unconditional binders of `T01_main`. They are universally quantified statements about all `U` / the Gaussian, not constraints on `gU`, so they cannot make clause (ii) vacuous unless they are false outright (they are gated content of T02, vh-locked). Consequence for the record only: at the level of the `T01_main` signature, part (ii) nominally carries them; the per-clause dependence (they are used only by (i)) is to be stated by the final auditor via `#pv_hyp_usage`/the per-clause table, as in `revenc1/T01_final.md` §3. Not a fidelity defect.
- False-as-stated obligations: none.

### 6. External parameters: PASS
- `hL02`: provenance (p), predecessor L02 (TEX:899-901 printed clause plus the intermediate bound at TEX:934, `L02_S10`); applicability conditions (17), (18) now appear explicitly as the antecedents of the binder, and are supplied in S1's use from `HypPartI` (`h.1`, `h.2.1`); `heps` from `T01_main`. Declared in `T02Stmt.lean` (`Paper.T02.T02_L02Consumed`) and reused, not redeclared; vh unchanged (T02 file not touched). The draft keeps the reuse of T02's name rather than a `T01_L02Consumed` alias; this was accepted at r2 and is unchanged.
- `Thm518`: (ii), unchanged (vh=3970237549 identical to r2), not stronger than TEX:978-984 (deterministic-L specialisation, `<M`). Note (from the final audit, not a gate issue): it still has to be registered in `verification/EXTERNAL_TOOLS.md`.
- `Prop35` (ii), `GaussFacts` (v): reused from T02, unchanged.

### 7. Doubts about the source: no new ones
Previously recorded and already dispatched (no gate ruling): X3 (Thm 2.2 has no proof/pointer, EXPOSITION_GAP minor), X2 (random 𝔏 vs fixed L, EXPOSITION_GAP preliminary), `≤ M` vs `< M` (FAIR_IMPLICIT_STEP), unquantified ε, L (DOMAIN_CLARIFICATION). E1 is a formalization-side fix (F1, ENCODING_ERROR) and raises no paper issue.

## TFA table

| TFA | Ruling | Reason |
|---|---|---|
| TFA-A: `0<d`, `IsGradField`, `∫⁻e^{-U}<⊤`, `0<ε`, `1≤L` | approved (unchanged) | standing conventions TEX:192, 320; exclude only degenerate cases |
| TFA-B: unquantified `ε, L` read as "for every" | approved (unchanged) | quantifier reading, as T02 "for any choice T>0" |

## External parameter table

| Parameter | Type | Ruling |
|---|---|---|
| `hL02 : HypExplode gU → HypOscillations gU → T02_L02Consumed gU eps L` | (p), L02 | approved; weaker than the r2 binder; conditions (17),(18) explicit; not goal-shaped |
| `Prop35` | (ii) | approved (unchanged, T02) |
| `GaussFacts` | (v) | approved (unchanged, T02) |
| `Thm518` | (ii) | approved (unchanged); registration pending (coordinator) |

## Required changes

None.

## Statement snapshot

Copy `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (log `pv_work/logs/gate_T01_stmtcopy_2.log`):
```
TYPE HASHES (current file, 12 declarations)
Paper.T01.HypPartII|def|th=3957315956|vh=1173314425|bi=iee
Paper.T01.HypPartI|def|th=1151819367|vh=3393636548|bi=ieee
Paper.T01.T01Concl.casesOn|def|th=1373956722|vh=1243287819|bi=iiiiiiee
Paper.T01.T01Concl.mk|ctor|th=3893591694|vh=-|bi=iiiiiee
Paper.T01.T01Concl.noConfusionType|def|th=1533223712|vh=2188585157|bi=iiiiieee
Paper.T01.T01Concl.noConfusion|def|th=4150213738|vh=1585562462|bi=iiiiiiiie
Paper.T01.T01Concl.partII|thm|th=2740704371|vh=-|bi=iiiiiee
Paper.T01.T01Concl.partI|thm|th=2679091220|vh=-|bi=iiiiiee
Paper.T01.T01Concl.recOn|def|th=1373956722|vh=697509788|bi=iiiiiiee
Paper.T01.T01Concl.rec|rec|th=2963399103|vh=-|bi=iiiiiiee
Paper.T01.T01Concl|induct|th=4031747299|vh=-|bi=ieeee
Paper.T01.Thm518|def|th=3944470172|vh=3970237549|bi=
```

Copy `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (log `pv_work/logs/gate_T01_draftcopy_2.log`):
```
TYPE HASHES (current file, 4 declarations)
Paper.T01.T01_S1|thm|th=3069413807|vh=-|bi=ieeeeeeeeeeeee
Paper.T01.T01_S2|thm|th=3202775329|vh=-|bi=iee
Paper.T01.T01_S3|thm|th=4061819840|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_main|thm|th=2118693897|vh=-|bi=ieeeeeeeeeeeee
```

This snapshot supersedes `verification/audits/revenc1/T01_gate_r2.md` for `T01_main` (only that line differs).

## Overall verdict

The E1 binder is faithful, weaker than the r2 binder, and confined to part (i). Part (ii) is now non-vacuous; this was checked in Lean. No other statement changed (hashes). S1's unconditional premise is acceptable.

STATEMENT GATE: PASS

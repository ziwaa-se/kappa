# T01 statement gate (revision 1 re-draft)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5). Date: Tue Oct 13 11:15:48 EDT 2026 (`date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T01Stmt.lean` 8fc2a4d18764fd3971590419010dc401ea979598a8e2e5d6a5a8bb7cd8a493b8
  - `pv_work/T01Draft.lean` 66f1291ccbcee411f7f9f3cdb25c7607469a851895f96b97f6d5352437ad039e
  - imported, read in full / in the relevant parts: `pv_work/T02Stmt.lean` 3413fed69562741660be94ac7497ea85180309b908fb03d66cba601f8eb264eb,
    `pv_work/L03Stmt.lean` 42fcf7cd82a9d77fa1fdb0d555caea9e0415a9629257d1c70aa13018529c07c6 (`HypOscillations3`, `Concl`),
    `pv_work/Defs.lean` e573c173018c4d76c43445dec04b28371b1c4a1b070dc9de1a4f2c14f38d3472 (`E`, `piDens`, `IsGradField`, `xLF`, `accProb`, `HypExplode`, `HypOscillation2`),
    `pv_work/T02Draft.lean` (signatures of `T02_main` and `T02_main_randL`), `pv_work/C01Stmt.lean` (uses of T01 names).
- Draft notes `pv_work/notes/T01_draft_notes.md` read as leads only.
- Source read directly: `source/geo_erg_HMC_v3.1.tex` 150-239, 296-395, 800-839, 860-949, 1095-1124;
  previous manuscript `verification/source_baseline_v1/geo_erg_HMC_v3.1.tex` 208-219, 978-984 (baseline_before per RESULTS.json).
- Pre-revision gate: `verification/audits/rev1/T01_gate.md` (snapshot lines 93-117).

## Compilation

- `scripts/pv_lean.sh check T01Draft`: `RESULT T01Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/T01Draft_8.log`. 4 sorries = bodies of `T01_main`, `T01_S1`, `T01_S2`, `T01_S3`.
- Snapshot probes: `pv_work/logs/gate_T01_stmtcopy_3.log` (exit 0, 0 sorry), `pv_work/logs/gate_T01_draftcopy_3.log` (exit 0, 4 sorry).
- Gate probe `pv_work/probes/gate/T01/gate_T01_rev1check.lean`, log `pv_work/logs/gate_T01_rev1check_1.log`: exit 0, 0 sorry; `#print axioms` of all four probe theorems `[propext, Classical.choice, Quot.sound]`. Contents:
  (a) `consumed_from_T02_main`: the type of `T02_main` (copied verbatim from `T02Draft.lean:20-26`) with T02's own parameters yields `T01_T02Consumed`; `consumed_to_T02_concl`: the converse direction (clause gives back exactly T02's conclusion, no strengthening);
  (b) `consumed_free_on_partII`: under `HypPartII` (with `0<d`) the clause holds for free (bounded `gU` never satisfies (17));
  (c) `assembly`: S1, S3 as stated give `T01_main`; `S2_true`: S2 proved (`M+1`).

## Source quotations

- Thm 2.2 (TEX:208-219), unchanged w.r.t. `source_baseline_v1`:208-219: "If either of the following hold then HMC will *not* produce a geometrically ergodic Markov chain: (i) lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞ and (eqn:oscillations) and (eqn:oscillation2) are satisfied; (ii) There is an M<∞ such that ‖∇U(x)‖ ≤ M for all x ∈ X, and E_π[e^{s‖x‖}]=∞ for every s>0." No proof, no pointer.
- Thm 5.14 (TEX:895-909): (17) explode; (18) "there is a fixed C<∞ such that whenever ‖y‖ ≥ 3‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖" (revised, TEX:900-903); (19) with 2^L (TEX:905-907); "then HMC with fixed integration time T = Lε does not produce a geometrically ergodic Markov chain for any choice T>0". Proof TEX:911-932 (Lemma arate_0, Gaussian tail, Prop. 3.5); random-L paragraph TEX:934-940: "When the number of leapfrog steps is drawn from a position-independent distribution 𝓛(·) as in Assumption A1, the same conclusion follows provided the above argument is applied conditional on each fixed L ... dominated convergence".
- Thm 5.18 (TEX:1103-1109), unchanged w.r.t. `source_baseline_v1`:978-984: "If ‖∇U(x)‖ < M for all x ∈ X, then a necessary condition for the Hamiltonian Monte Carlo method to produce a geometrically ergodic Markov chain is ∫ e^{s‖x‖}π(dx) < ∞ for some s>0." Proof TEX:1111-1121 (Prop. 3.6, fixed L in the displayed bound).
- HMC = Algorithm 1 (TEX:338-352): "REQUIRE x_{i-1}, ε ≥ 0, 𝔏(·)"; "draw p_0 ~ N(0,M), L ~ 𝔏(·)". 𝔏 "a distribution defined over Z_+" (TEX:192). Section 4 standing assumption: 𝔏 does not depend on the current position (TEX:381). A1 (TEX:393) is an assumption of the positive results (TEX:204), not printed in Thm 2.2.
- Consumer: Cor 2.3 proof TEX:806 "For part (ii), the case β<1 is a direct consequence of part (ii) of Theorem thm:negative" (Cor 2.3 is "under assumption A1", TEX:230), and TEX:834-836 (part (ii), β>2 via Thm 5.14 conditional on each fixed L, dominated convergence "under Assumption A1").
- Conventions: X = R^d, Euclidean norm, π finite with Lebesgue density (TEX:192); π ∝ e^{-U}, U differentiable (TEX:320, 324); M = I (TEX:355).

## Item rulings

### 1. Hypotheses: PASS (fixed L)
- Part (i): `HypPartI = HypExplode gU ∧ Paper.L03.HypOscillations3 gU ∧ HypOscillation2 U L`. (17) `HypExplode` (Defs:75-76) matches TEX:897-899 along `‖x‖ → ∞`. (18) `HypOscillations3` (L03Stmt:24-25): `∃ C, ∀ x y, 3‖x‖ ≤ ‖y‖ → C ≤ 3‖x‖ → 3‖gU x‖ ≤ ‖gU y‖` is exactly "‖y‖ ≥ 3‖x‖ ≥ C ⇒ ‖∇U(y)‖ ≥ 3‖∇U(x)‖" (TEX:900-903); the stale `2‖x‖` form (`Paper.Defs.HypOscillations`) is no longer used. (19) `HypOscillation2 U L` (Defs:86-90) matches TEX:905-907 with the chain's `L` (TFA-B/N9 reading, same as the T02 gate).
- Part (ii): `HypPartII` (unchanged, vh identical to rev1) = `∃ M, ∀ x, ‖gU x‖ ≤ M` and `∀ s>0, ∫⁻ ofReal(e^{s‖x‖}) d(targetMeas U) = ⊤`, i.e. TEX:217 (`≤ M`, every `s>0`, `E_π` w.r.t. the normalised π).
- Standing premises of `T01_main` (`0<d`, `IsGradField`, `∫⁻ e^{-U} < ⊤`, `0<ε`, `1≤L`): TFA-A, as approved at rev1 and in the T02 gate.
- Parameters: `hT02 : T01_T02Consumed U gU eps L`, `hE3 : Thm518` (item 6). The removed binders `hL02`, `hE1 : Prop35`, `hE6 : GaussFacts` are now carried transitively by T02 (correct: they were only used by part (i)).
- **No re-introduction of the earlier ENCODING_ERROR (F1).** `T01_T02Consumed` is an implication with antecedent `HypPartI`; probe `consumed_free_on_partII` proves `HypPartII U gU → T01_T02Consumed U gU eps L` (for `0<d` the antecedent `HypExplode` is refuted by the bound). So no unconditional clause constrains bounded-gradient potentials; `(T01_main …).partII` depends in substance on `Thm518` only.
- Hidden hypotheses: none (no `variable`s, no classes; `T01Concl` has exactly the two clause fields).
- No conclusion-as-hypothesis: neither parameter mentions `HypPartII → ¬ GeomErgodic`; `T01_T02Consumed` has the part-(i) conclusion shape, but it is the (p) clause of the predecessor whose own theorem has exactly this conclusion (Thm 5.14), which is the source's route for (i) (X3), see item 6.

### 2. Conclusion: PASS for the 𝔏 = δ_L instance; scope incomplete (see Required change R1)
- `T01Concl` (th/vh unchanged): `partI : HypPartI → ¬ GeomErgodic`, `partII : HypPartII → ¬ GeomErgodic`, i.e. "if either holds then not geometrically ergodic", clause by clause. Neither weakened nor strengthened for a fixed number of leapfrog steps.
- **Scope (focus "fixed L vs random L", X2).** "HMC" in TEX:209 is Algorithm 1 (TEX:342-343) with `L ~ 𝔏`, 𝔏 any position-independent law on Z_+ (TEX:192, 381); Thm 2.2 does not assume A1. `hmcStep`/`GeomErgodic` are the instance 𝔏 = δ_L. So the drafted statement proves only a special case of the printed one, i.e. it is a weakened conclusion. Before the revision this could not be avoided; now T02 provides `GeomErgodicRand`, `hmcStepRand`, `A1Law` and `T02_main_randL` (gate-passed, `T02_gate_r2.md`), the printed Thm 5.18 speaks of "the HMC method" generally (so a random-𝔏 specialisation is a faithful (ii) external input), and the only downstream consumer uses Thm 2.2(ii) under A1, i.e. for random L (TEX:806 with TEX:230). Leaving random 𝔏 out would make any final verdict on T01 a partial pass of the item. Required change R1 adds the random-𝔏 statement as a second main theorem; the fixed-L declarations stay unchanged (so the C01 cascade is limited, see the fingerprint section).

### 3. Quantifiers and dependence of constants: PASS
`ε, L` (and in R1 `𝔏`) are universally quantified at theorem level, `M` and `s` inside `HypPartII` exactly as in TEX:217 (`∃ M` before `∀ x`; `∀ s>0`). `C` of (18) existential inside `HypOscillations3` before `x, y`, as printed ("a fixed C"). The `L` of (19) is the chain's `L` (N9 reading; approved as TFA-B). No constant is chosen out of order; the paper has no constants that depend on other objects here.

### 4. Domains and details: PASS
`E d = EuclideanSpace ℝ (Fin d)` (non-periodic R^d). `E_π[e^{s‖x‖}] = ∞` via `∫⁻ ENNReal.ofReal (exp …)`; the integrand is positive, so `ofReal` truncates nothing; `targetMeas` is normalised (finite and nonzero normaliser under `hπ`, `e^{-U} > 0`). `GeomErgodic` (T02-gated, eqn:geoerg) is for every `x, n` with `M` π-a.e. finite, as printed. `≤ M` (TEX:217) vs `< M` (TEX:1104) bridged by S2 (proved in the probe). Equalities are pointwise; no a.e. issue arises.

### 5. Step obligations: PASS
- S1 (TEX:213 ↔ Thm 5.14): `T01_T02Consumed` plus standing premises plus `h : HypPartI` ⇒ `¬ GeomErgodic`. True (direct application of the clause); corresponds to the identification X3 (not printed). Does not smuggle anything stronger than T02's conclusion (probe `consumed_to_T02_concl`).
- S2 (`≤ M ⇒ < M+1`, TEX:217 vs 1104): true, proved in the probe (`S2_true`); FAIR_IMPLICIT_STEP.
- S3 (TEX:217 with TEX:1103-1109): contrapositive of `Thm518` with S2: the hypotheses of `Thm518` are all available (`0<d`, `IsGradField`, `hπ`, `0<ε`, `1≤L`, `<M` from S2); its conclusion `∃ s>0, ∫⁻ … < ⊤` contradicts `HypPartII.2 s`. True as stated given `Thm518`; no missing premise (positivity of `s` is part of `Thm518`'s conclusion, matching `∀ s>0` in `HypPartII`).
- Assembly: checked in Lean (probe `assembly`, standard axioms).
- False-as-stated obligations: none.

### 6. External parameters: PASS
- `T01_T02Consumed U gU eps L` — provenance (p), predecessor T02 (not yet proved), location `Paper.T02.T02_main` (`T02Draft.lean:20-26`), Theorem 5.14, TEX:895-909, proof 911-932. Applicability: T02's hypotheses (17) `hexp`, (18) `hosc` (revised), (19) `hosc2` are the three components of `HypPartI` with the same `U, gU, L`; the standing premises are antecedents of the clause and are supplied by `T01_main`'s own binders. T02's own parameters (`T02_L03Consumed U gU eps L`, `Prop35`, `GaussFacts`) are supplied at reconnection (probe `consumed_from_T02_main` shows the clause follows from `T02_main`'s type once these are given). Not stronger than the source's use (equal to T02's conclusion, probe (a')). Not goal-shaped in the forbidden sense: it is the predecessor's printed conclusion, which TEX:213 restates (X3), and it does not touch part (ii) (probe (b)). Declared in `T01Stmt.lean`, `namespace Paper.T01`, name `<ID>_<PredID>Consumed`, no redeclared name (the stale `Paper.T02.T02_L02Consumed` reuse is gone; `T02_L02Consumed` no longer exists in T02Stmt).
- `Thm518` — provenance (ii) (out-of-scope numbered result whose statement is used as given; content vh=3970237549 unchanged since rev1). Not stronger than TEX:1103-1109: specialised to `hmcStep` (𝔏 = δ_L), adds only the standing premises (weaker), keeps the hypothesis `‖gU x‖ < M` and the conclusion "for some `s>0`". Truth as stated: consistent with the printed theorem for any fixed `ε>0`, `L≥1` (the displayed bound TEX:1118 is uniform in `x`). Docstring line references now TEX:1103-1109 (correct). Registration in `verification/EXTERNAL_TOOLS.md` with the corrected source_loc (notes: RESULTS.json still cites TEX:978-984): coordinator.
- mathlib evidence: not applicable (paper-specific results).

### 7. Doubts about the source (preliminary, no ruling)
- X3, TEX:208-219: Thm 2.2 has no proof and no pointer to Thms 5.14/5.18; identification by content. Preliminary EXPOSITION_GAP (minor). Recommend dispatch of pv-issue-checker (still never dispatched, RESUME.md:22).
- X2, TEX:209 vs 342-343, 908, 934-940, 1103-1121: Thm 2.2 is for HMC with `L ~ 𝔏`, Thm 5.14 is stated for fixed `T = Lε`, its random-L paragraph covers 𝔏 "as in Assumption A1" only, Thm 5.18's proof treats fixed L only, Thm 2.2 does not assume A1. Preliminary EXPOSITION_GAP (range of 𝔏 not covered by the supporting argument for part (i) outside A1). Recommend dispatch of pv-issue-checker once R1 is drafted.
- N9, TEX:209 vs 908: unquantified `ε, L` (and which `L` in (19)). Preliminary DOMAIN_CLARIFICATION; the reading "for every `ε>0`, `L≥1`, same `L` in (19)" (random L: (19) for every `L` charged by 𝔏, as TEX:834 "for every fixed L") is adopted as TFA-B.
- TEX:217 `≤ M` vs TEX:1104 `< M`: FAIR_IMPLICIT_STEP (not an issue).

## TFA table

| TFA | Ruling | Reason |
|---|---|---|
| TFA-A: `0<d`, `IsGradField U gU`, `∫⁻ e^{-U} < ⊤`, `0<ε`, `1≤L` | approved | standing conventions TEX:192, 320, 324, 336; exclude only degenerate cases |
| TFA-B: unquantified `ε, L` read as "for every", same `L` in (19) | approved | quantifier reading (N9), as T02 "for any choice T>0" (TEX:908) |
| TFA-C (for R1): `IsProbabilityMeasure 𝔏`, `𝔏{0} = 0` | approved in advance | 𝔏 is "a distribution over Z_+" (TEX:192) of the number of leapfrog steps; `L = 0` (T = 0, the chain never moves) is a degenerate case not discussed |
| TFA-D (for R1): (19) for every `l ≥ 1` charged by 𝔏 | approved in advance | the `L` of (19) is the chain's `L`; for random L the source applies the argument "conditional on each fixed L" (TEX:936-937, 834); same as T02 TFA-6 |
| `A1Law` as a premise of the random-𝔏 main theorem | **rejected** | Thm 2.2 does not assume A1 (TEX:208-219; A1 is the assumption of the positive result, TEX:201, 204); not derivable from the context. It may appear only inside the consumed clause (where T02 states it, TEX:935) and in step obligations, see R1 |

## External parameter table

| Parameter | Type | Ruling |
|---|---|---|
| `T01_T02Consumed U gU eps L` | (p), T02, `T02_main` (T02Draft:20-26), Thm 5.14 TEX:895-909 | approved; equals T02's conclusion; conditions = `HypPartI` + standing premises; free under (ii) (probe) |
| `Thm518` | (ii), Thm 5.18 TEX:1103-1109 | approved (vh unchanged); δ_L specialisation, weaker than printed |
| (R1) `T01Rand_T02Consumed U gU eps Lmeas` | (p), T02, `T02_main_randL` (T02Draft:117-125), TEX:934-940 | approved in advance in the exact form below (shape compiled in probe `gate_T01_R1shape.lean`) |
| (R1) `Thm518Rand` | (ii), Thm 5.18 TEX:1103-1109 ("the HMC method", any 𝔏) | approved in advance in the form below; must not carry `A1Law` |

## Required changes

**R1 (scope: random 𝔏).** Keep every existing declaration of `T01Stmt.lean` and `T01Draft.lean` unchanged (texts and hashes). Add:

In `pv_work/T01Stmt.lean`, inside `namespace Paper.T01`, after `T01Concl` (before `end Paper.T01`):
```lean
/-- EXTERNAL INPUT, provenance (ii): Theorem 5.18 (TEX:1103-1109) for HMC with `L ~ 𝔏` (Algorithm 1,
TEX:342-343), standing conventions as in `Thm518`, 𝔏 a probability law on `L ≥ 1`. -/
def Thm518Rand : Prop :=
  ∀ (d : ℕ) (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ),
    0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    IsProbabilityMeasure Lmeas → Lmeas {0} = 0 →
    (∃ M : ℝ, ∀ x : E d, ‖gU x‖ < M) →
    GeomErgodicRand U gU eps Lmeas →
    ∃ s : ℝ, 0 < s ∧ (∫⁻ x : E d, ENNReal.ofReal (Real.exp (s * ‖x‖)) ∂(targetMeas U)) < ⊤

/-- Hypothesis (i) of Theorem 2.2 for random 𝔏: (17), (18) revised, (19) for every `l` charged by 𝔏. -/
def HypPartIRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (Lmeas : Measure ℕ) : Prop :=
  HypExplode gU ∧ Paper.L03.HypOscillations3 gU ∧
    ∀ l : ℕ, 1 ≤ l → Lmeas {l} ≠ 0 → HypOscillation2 U l

/-- CONSUMED CLAUSE of T02, provenance (p): conclusion of `Paper.T02.T02_main_randL`
(TEX:934-940) for fixed `U, gU, ε, 𝔏`. -/
def T01Rand_T02Consumed {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) :
    Prop :=
  0 < d → IsGradField U gU → (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤ → 0 < eps →
    A1Law gU eps Lmeas → HypPartIRand U gU Lmeas → ¬ GeomErgodicRand U gU eps Lmeas

/-- Conclusion of Theorem 2.2 for HMC with `L ~ 𝔏`. -/
structure T01ConclRand {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ) :
    Prop where
  partI : HypPartIRand U gU Lmeas → ¬ GeomErgodicRand U gU eps Lmeas
  partII : HypPartII U gU → ¬ GeomErgodicRand U gU eps Lmeas
```
(The name `T01Rand_T02Consumed` ends in `_T02Consumed`, which `pv_status.py:1191` uses to identify the predecessor; `T01_T02Consumed` is already taken by the fixed-L clause.)

In `pv_work/T01Draft.lean`, add the main theorem
```lean
theorem T01_main_randL {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (Lmeas : Measure ℕ)
    (hT02R : T01Rand_T02Consumed U gU eps Lmeas) (hE3R : Thm518Rand)
    (hd : 0 < d) (hgrad : IsGradField U gU)
    (hπ : (∫⁻ x : E d, ENNReal.ofReal (piDens U x)) < ⊤)
    (heps : 0 < eps) (hP : IsProbabilityMeasure Lmeas) (h0 : Lmeas {0} = 0) :
    T01ConclRand U gU eps Lmeas := by
  sorry
```
with **no `A1Law` binder** (TFA rejected above), and step obligations: `T01_SR1` (part (i) for 𝔏 satisfying A1, from `hT02R`, with premises `hA1 : A1Law gU eps Lmeas` and `h : HypPartIRand U gU Lmeas`; TEX:213 with TEX:934-940); `T01_SR3` (part (ii), contrapositive of `Thm518Rand` with S2; TEX:217, 1103-1109). In the docstring of `T01_main_randL` and in the notes, state that part (i) for laws 𝔏 that do not satisfy A1 has no justification in the source (the supporting argument TEX:934-940 is "as in Assumption A1"): the prover stops `partI` there and records it (X2); this must not be rescued by adding `A1Law` to the main theorem.
In the notes: register `Thm518Rand` (ii) and `T01Rand_T02Consumed` (p, location `T02_main_randL`, applicability: (17), (18) = `h.1`, `h.2.1`; (19) per charged `l` = `h.2.2`; `A1Law`, standing premises as antecedents; T02's per-`l` `T02_L03Consumed`, `Prop35Rand`, `GaussFacts` transitive).

**R2 (docstrings, optional, editorial).** `T01Stmt.lean` docstrings of `Thm518` (line 28) and `T01Concl` (lines 60-62) say random 𝔏 "is not covered"; after R1 they should point to `Thm518Rand`/`T01ConclRand`. Changing them changes no `th`/`vh` hash but changes the `.olean`; acceptable now since T01 is not yet reviewed in final form. Not required for PASS.

## Changes against the pre-revision gate (`verification/audits/rev1/T01_gate.md`:93-117), by `#pv_type_hashes`

| Declaration | rev1 | now | status |
|---|---|---|---|
| `Paper.T01.HypPartII` | th=3957315956 vh=1173314425 bi=iee | identical | **unchanged** (C01Stmt still consumes it; line 50) |
| `Paper.T01.HypPartI` | th=1151819367 vh=3393636548 | th=1151819367 **vh=1055139947** | **changed** (revised (18), `HypOscillations3`) |
| `Paper.T01.T01Concl` (+ `mk`, `partI`, `partII`, `rec`, `casesOn`, `recOn`, `noConfusion*`) | as listed | identical | unchanged by hash; note that the meaning of field `partI` changed through `HypPartI` (hashes reference `HypPartI` by name) |
| `Paper.T01.Thm518` | th=3944470172 vh=3970237549 | identical | unchanged |
| `Paper.T01.T01_T02Consumed` | absent | th=4031747299 vh=1497662525 bi=ieeee | **new** |
| `Paper.T01.T01_main` | th=2118693897 bi=ieeeeeeeeeeeee | **th=150518589** bi=ieeeeeeeeeee | **changed** (binders `hL02`, `hE1`, `hE6` removed, `hT02` added) |
| `Paper.T01.T01_S1` | th=3069413807 bi=ieeeeeeeeeeeee | **th=478559951** bi=ieeeeeeeeeee | **changed** |
| `Paper.T01.T01_S2` | th=3202775329 bi=iee | identical | unchanged |
| `Paper.T01.T01_S3` | th=4061819840 bi=ieeeeeeeeeee | identical | unchanged |

For the C01 cascade: of the T01 names C01Stmt uses (`HypPartII`, via `open Paper.T01`), none changed; `HypPartI`, `T01_main` (main-theorem fingerprint) and `T01_S1` changed, `T01_T02Consumed` is new. R1 adds new names only and changes none of the above.

## Statement snapshot

Copy `pv_work/probes/gate/T01/gate_T01_stmtcopy.lean` (log `pv_work/logs/gate_T01_stmtcopy_3.log`):
```
TYPE HASHES (current file, 13 declarations)
Paper.T01.HypPartII|def|th=3957315956|vh=1173314425|bi=iee
Paper.T01.HypPartI|def|th=1151819367|vh=1055139947|bi=ieee
Paper.T01.T01Concl.casesOn|def|th=1373956722|vh=1243287819|bi=iiiiiiee
Paper.T01.T01Concl.mk|ctor|th=3893591694|vh=-|bi=iiiiiee
Paper.T01.T01Concl.noConfusionType|def|th=1533223712|vh=2188585157|bi=iiiiieee
Paper.T01.T01Concl.noConfusion|def|th=4150213738|vh=1585562462|bi=iiiiiiiie
Paper.T01.T01Concl.partII|thm|th=2740704371|vh=-|bi=iiiiiee
Paper.T01.T01Concl.partI|thm|th=2679091220|vh=-|bi=iiiiiee
Paper.T01.T01Concl.recOn|def|th=1373956722|vh=697509788|bi=iiiiiiee
Paper.T01.T01Concl.rec|rec|th=2963399103|vh=-|bi=iiiiiiee
Paper.T01.T01Concl|induct|th=4031747299|vh=-|bi=ieeee
Paper.T01.T01_T02Consumed|def|th=4031747299|vh=1497662525|bi=ieeee
Paper.T01.Thm518|def|th=3944470172|vh=3970237549|bi=
```

Copy `pv_work/probes/gate/T01/gate_T01_draftcopy.lean` (log `pv_work/logs/gate_T01_draftcopy_3.log`):
```
TYPE HASHES (current file, 4 declarations)
Paper.T01.T01_S1|thm|th=478559951|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_S2|thm|th=3202775329|vh=-|bi=iee
Paper.T01.T01_S3|thm|th=4061819840|vh=-|bi=ieeeeeeeeeee
Paper.T01.T01_main|thm|th=150518589|vh=-|bi=ieeeeeeeeeee
```
After R1 the amendment check (`T01_gate_r2.md`) must show these 17 lines unchanged plus the new R1 declarations.

## Overall verdict

The fixed-L statement is faithful: revised (18) is used, the T02 consumed clause equals T02's conclusion and does not make part (ii) vacuous (checked in Lean), `Thm518` is unchanged and not stronger than printed, and no step obligation is false as stated. However, it covers only the instance 𝔏 = δ_L of a theorem printed for HMC with L ~ 𝔏, and the infrastructure to state the random case now exists. Required change R1 adds the random-𝔏 statement without an A1 premise.

STATEMENT GATE: PASS_WITH_AMENDMENTS


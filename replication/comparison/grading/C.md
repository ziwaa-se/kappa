# Grading C: "On the geometric ergodicity of Hamiltonian Monte Carlo" (arXiv v4, pre-correction; scope Thm 2.2, Cor 2.3(ii), Thm 5.14, Lemmas 5.15-5.17)

Grader: Claude (Opus 5.5), 2026-10-16, following `grader_prompt_C.md` and `BASELINE_PROTOCOL.md`. The authors check this grading.

Inputs used:

- Paper: `runsrc/C/geo_erg_HMC_v3.1.tex` (1323 lines, sha256 `ba2f97f6…`). It is byte-identical to the Kit's first-round source (`verification/source_baseline_v1/` and the snapshot's `source_baseline/`), to the Agent's `source/`, to the arXiv v4 source in `references/errata/C-livingstone-hmc/arxiv-v4/`, and to the paper part of the Chat's `message.txt`. The Kit project's current `source/` is the corrected text used in its later revision; it is not used here.
- Reference: `references/errata/C-livingstone-hmc/ANSWER_KEY.md` (with `answer_key.json`). There are no hand checks for C. The corrigendum (`arxiv-v5/source/corrigendum_arxiv.tex`, the key's source) was read only to compare the arms' repairs with the published one.
- Kit: snapshot `20261013-023743-before-revision` (`RESULTS.json`, `BLOCKERS.md`, `EXTERNAL_TOOLS.md`, `audits/` including `audits/revenc1/`), and report `report_archive/20261013-114547/AUTHOR_REPORT.md`, which is byte-identical to the snapshot's report. For Lean, the snapshot's `pv_work/` copies are used. They agree byte for byte with `pv_work/superseded/rev1/` for every module except `C01.lean`, `C01Draft.lean` and `C01Stmt.lean`. Those three in `rev1/` are later files: the rev1 README records C01 moved in twice, at 02:38 and at 11:26, and the second move overwrote the first. `Defs.lean` and `PVTools.lean` are unchanged in `pv_work/`.
- Agent: `C-agent/session.json` ("result"), `LightTails.lean`, `HeavyTails.lean`, `lean_check.md`.
- Chat: `C-chat/session.json` ("result"), `lean_blocks/block_01.lean`, `lean_check.md`. The block is identical to the code block of the reply. The chat folder has a `session.json`, so all three arms are graded.

Grader Lean checks were run in `<tmp>/grading-C/` (Lean 4.19.0, Mathlib `c44e0c8e`) with `lake env lean`. Copies are in `grading/C_lean/`:

- `GraderKit.lean`. It imports the Kit's 14 first-round modules. These were taken from the snapshot and compiled in dependency order with `lake env lean -R kit -o`, as `scripts/pv_lean.sh` does; every module has 0 errors and 0 `sorry`. The file does three things:
  - It prints the axioms of every theorem the Kit cites.
  - It re-checks the Kit's L02 positive probe `gap_holds`, copied verbatim without the PVTools walk command.
  - It joins the Kit's own first-round theorems: `grader_L02_uncond`, `grader_L03_clause`, `grader_L03_uncond`, `grader_T02_only_cited`, `grader_T01_only_cited`, `grader_explode_not_osc`, `grader_C01_gap_false` and `grader_L02_gap_true`.
- `AgentCheck.lean`. This is `LightTails.lean` plus `grader_agent_explode_not_osc` and `#print axioms` lines. `HeavyTails.lean` was recompiled unchanged with 0 errors.
- `ChatCheck.lean`. This is `block_01.lean` plus `grader_chat_not_osc` and `#print axioms` lines.

Every `#print axioms` in these files gives `[propext, Classical.choice, Quot.sound]`. The only warning is an unused-section-variable linter note in `AgentCheck.lean`.

## 0. Reference (answer key, translated into protocol classes)

Numbering, as in the key: 2.2 = `thm:negative`, 2.3 = `crly:expfam`, 5.14 = `thm:light`, 5.15 = `lem:xelower`, 5.16 = `lem:xlower`, 5.17 = `lem:arate_0`. Conditions: (17) = `eqn:explode`, (18) = `eqn:oscillations`, (19) = `eqn:oscillation2`. All three arms use this numbering.

| No. | Key verdict | Protocol class | Defect / note |
|---|---|---|---|
| 5.15 | verified | OK | none |
| 5.16 | ISSUE, `PAPER_ASSUMPTION_GAP` (also acceptable: `PAPER_ARGUMENT_GAP`, or UNFINISHED naming the hypothesis) | PROOF | The lemma (TEX:899-901) assumes only (17). Its proof uses (18) at TEX:930-933: "Envoking (18) gives ‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6". The statement is true under (17) alone. `ERROR` is not acceptable. Second, minor published correction. |
| 5.17 | verified (possibly conditional) | OK | δ_L for γ_L is editorial. |
| 5.14 | CONDITIONAL on the 5.16 clause (iv) and on the cited result on rejection probabilities (ii) | OK | uses Lemma 5.16 |
| 2.2 | CONDITIONAL: (i) through 5.14, (ii) through Thm 5.18 | OK | |
| 2.3(ii) | ISSUE, `PAPER_ARGUMENT_GAP`, for 2 < β < 1 + log₂3 | PROOF | "Part (ii) is a direct consequence of Theorem 2.2" (TEX:806) fails, because (18) is false on E(β,α) for 2 < β < 1 + log₂3 ≈ 2.585 (for \|y\| = 2\|x\| the gradient ratio is 2^{β−1} < 3). The statement is true. Neither `ERROR` nor a verified verdict for all of (ii) is acceptable. This is the published error. |

Known (published) problems: 2. The main one is Cor 2.3(ii); the second, minor one is Lemma 5.16.

## 1. Per-result table

Abbreviations:

- Cls: class. Corr: correctly classified. Nat: nature right (for FALSE/PROOF results only). FA: false alarm. Lean: Lean-backed under the protocol's strict rule (faithful statements only; see §2). Inp: cited-input handling.
- **Rule for PROOF results.** For 5.16, the defect is that the proof uses a hypothesis the lemma does not have. The use of (18) is shown by reading the proof, in every arm. What Lean can back is that the statement holds under the printed hypothesis alone, which shows that the defect is in the proof (PROOF, not FALSE). No arm cites a Lean proof that (17) does not imply (18) for 5.16. The Kit's and the Agent's files both contain the pieces; see §5. For 2.3(ii), Lean can back the defect directly, by refuting (18) on the class.
- **Inputs.** Six input uses are counted:
  - 5.17 ← the clause of 5.16, including the per-step doubling;
  - 5.14 ← the clause of 5.16;
  - 5.14 ← Prop 3.5 (cited);
  - 5.14 ← the Gaussian tail fact ("we simply note", TEX:879);
  - 2.2(ii) ← Thm 5.18, whose proof uses the cited Prop 3.6;
  - 2.3(ii) ← the facts about E(β,α) that "direct consequence" asserts without proof: (17) and (19) for β > 2, and a bounded gradient with infinite exponential moments for β < 1.
  
  2.2(i) and 2.3(ii) also inherit the inputs of 5.14 and 2.2; these are not counted twice. For 5.16, the only input is Lemma 5.15, which is in scope and has no problem, so it is "n.a.". For the Chat, "explicit (prose)" means that the reply names the dependence, but there is no Lean behind it.

| No. | Reference | Kit Cls | Kit Corr | Kit Nat | Kit FA | Kit Lean | Kit Inp | Agent Cls | Agent Corr | Agent Nat | Agent FA | Agent Lean | Agent Inp | Chat Cls | Chat Corr | Chat Nat | Chat FA | Chat Lean | Chat Inp |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 5.15 | OK | OK (UNCONDITIONAL, fixed-δ reading) | yes | n.a. | no | yes: `Paper.L01.L01_main_fixedDelta` | n.a. | OK ("Correct (wording slip)") | yes | n.a. | no | yes: `lemma_5_15` | n.a. | OK ("True"; constant slip)¹ | yes | n.a. | no | no: `lemma_5_15_core` is a one-step core (different) | n.a. |
| 5.16 | PROOF: the proof uses (18), which is not assumed; statement true | PROOF (ISSUE B01, PAPER_ARGUMENT_GAP; "conclusion still true under (17)") | yes | yes | no | no (strict): the statement-true evidence `gap_holds` (probe) is weaker, since it carries the L01 clause as a parameter. The grader's join `grader_L02_uncond` is faithful. `lean_main` `L02_main_fixedDelta_mod_gaps` is a gap record (different). | n.a. (L01 clause kept as explicit parameter `L02_L01Consumed`) | PROOF ("proof has a gap: uses the unstated oscillations condition"; statement correct) | yes | yes | no | yes (statement-true part): `lemma_5_16` | n.a. (5.15 proved and used) | PROOF ("Proof uses (oscillations), which is not a hypothesis"; "True as stated") | yes | yes | no | no (no Lean) | n.a. |
| 5.17 | OK (δ_L typo editorial) | OK (CONDITIONAL on `L03_L02Consumed`) | yes | n.a. | no | no: `Paper.L03.L03_main` is weaker (predecessor parameter, disclosed); the grader's join `grader_L03_uncond` is faithful | explicit | OK ("Correct up to the typo εδ_L → εγ_L and an unstated sign check") | yes | n.a. | no | yes: `lemma_5_17` | proved (`lemma_5_16_doubling`) | OK ("Correct; typos; relies on intermediate doublings not recorded in 5.16") | yes | n.a. | no | no: only proof steps (`gamma_L`, `lemma_5_17_square`) | explicit (prose) |
| 5.14 | OK (conditional on the 5.16 clause and Prop 3.5) | OK (CONDITIONAL on `T02_L02Consumed`, `T02_Prop35`, `T02_GaussFacts`) | yes | n.a. | no | no: `Paper.T02.T02_main` is weaker (three disclosed parameters) | explicit / explicit / explicit | OK ("Correct, given Lemmas 5.15–5.17 and Prop 3.5") | yes | n.a. | no | no: `thm_5_14` is a core ("expected acceptance → 0"), different | 5.16 clause proved; Prop 3.5 explicit; Gaussian tail proved (any probability law, `tail_small`) | OK ("Correct modulo the lemma issues") | yes | n.a. | no | no (no Lean) | 5.16 clause explicit (prose); Prop 3.5 explicit (prose); Gaussian tail unbacked |
| 2.2 | OK (conditional: (i) via 5.14, (ii) via 5.18) | OK (CONDITIONAL on T02's three parameters plus `T01_Thm518`; fixed L only) | yes | n.a. | no | no: `Paper.T01.T01_main` is weaker (four parameters, deterministic L) | Thm 5.18 explicit (+ inherited from 5.14) | OK ("Correct; the oscillations hypothesis in (i) is unnecessary") | yes | n.a. | no | no: `thm_5_14` and `thm_5_18` are cores (different) | Thm 5.18 explicit (Prop 3.6 named, the tightness core of 5.18 proved) (+ inherited) | OK ("True for fixed L; ambiguous under A1"; "Reduces to Thm 5.14/5.18; fine")² | yes | n.a. | no | no (no Lean) | Thm 5.18 explicit (prose) (+ inherited) |
| 2.3(ii) | PROOF: (18) fails on E(β,α) for 2 < β < 1+log₂3; statement true | PROOF (ISSUE B02, PAPER_ARGUMENT_GAP, 2 < β < log₂6 = 1+log₂3; "conclusion not refuted") | yes | yes | no | yes: `Paper.C01.Issue1.osc_fails`, `not_S2Printed` | class facts proved (`C01_S1`, `C01_S3`, `C01_S4`, `C01_S5`) (+ inherited) | PROOF ("Gap for 2 < β < 1+log₂3 … Lean counterexample at β = 5/2"; statement correct) | yes | yes | no | yes: `not_osc_expfam` (+ `not_osc_beta_five_halves`) | class facts proved (`explode_expfam`, `osc2_expfam`, `bounded_grad_expfam`, `no_exp_moment_expfam`) (+ inherited) | PROOF ("Gap: (5.oscillations) fails for 2 < β < 1+log₂3"; "The conclusion is still true") | yes | yes | no | no (strict): `oscillations_fails_beta_five_halves` is a reduced form (different); counted leniently | class facts unbacked (+ inherited) |

¹ Chat on 5.15. Its summary row reads "Arithmetic slip: the constant 6/ε² does not give a strict bound", and it suggests 8/ε². This is graded OK with an editorial note, like the Agent's "wording slip" and the Kit's editorial note on the same line (report §5 #4). Suppose it is read as PROOF instead. The slip is confirmed by hand (§3), and the key accepts an issue on 5.15 that is confirmed by hand. The classification and the false-alarm count do not change.

² Chat on 2.2. The flag "ambiguous under A1" concerns random L, an exposition point. The Kit raises the same point (X2) and keeps CONDITIONAL; the Agent handles it in its text. The Chat calls the proof "fine for fixed L" and says the extension is easy. This is graded OK, and the claim is correct (§3).

Where each arm's class comes from:

- Kit: `RESULTS.json` verdicts (L01 UNCONDITIONAL; L02 ISSUE B01; L03, T02, T01 CONDITIONAL; C01 ISSUE B02) and `BLOCKERS.md` B01, B02.
- Agent: its final "Summary" table.
- Chat: its "Summary" table.

**Lenient reading.** Count, in addition, statements that differ from the printed one only by disclosed conditions (cited inputs or predecessor clauses kept as explicit parameters), or by a one-line reduction stated by the arm. Then:

- Kit: Lean-backed on all six results. The predecessor parameters are discharged by the grader's joins from the Kit's own files, and only `Prop35`, `GaussFacts` and `Thm518` remain.
- Agent: four results (5.15, 5.16, 5.17, 2.3(ii)). For 5.14 and 2.2 its Lean stops at "expected acceptance → 0" and at tightness. The kernel, total variation, the essential supremum and Prop 3.5/3.6 are argued in words or cited.
- Chat: one result (the reduced counterexample for 2.3(ii)).

## 2. Faithfulness of the cited Lean theorems

### Shared encodings

- **Leapfrog.** Kit `leapfrogStep` (Defs.lean:34) and Agent `lfStep` (LightTails.lean:17) both define `p' = p − (ε/2)∇U(x)`, `x' = x + εp'`, `p'' = p' − (ε/2)∇U(x')`. This is TEX:330-335 with M = I (TEX:354-356). The Chat writes the one-step formula x_ε = x_0 − (ε²/2)g + εp directly (TEX:890).
- **(17).** Kit `HypExplode`: `‖gU x‖/‖x‖ → ∞` along `‖x‖ → ∞`. Agent `Explode`: `∀ K, ∃ R, ∀ x, R ≤ ‖x‖ → K‖x‖ ≤ ‖g x‖`. Both are TEX:865-867.
- **(18).** Kit `HypOscillations` and Agent `Osc`: `∃ C, ∀ x y, C ≤ 2‖x‖ → 2‖x‖ ≤ ‖y‖ → 3‖∇U x‖ ≤ ‖∇U y‖`. Both are TEX:868-871. The Chat has no definition.
- **(19).** Kit `HypOscillation2` (a `Tendsto … atBot` over `‖x‖ → ∞` inside `{2^L‖x‖ ≤ ‖y‖}`) and Agent `Osc2` (`∀ M, ∃ R, ∀ x y, R ≤ ‖x‖ → 2^L‖x‖ ≤ ‖y‖ → U x − U y − ‖x‖²/2 ≤ −M`). Both are TEX:873-874.
- **Acceptance.**
  - Kit `accProb` = `min 1 (π(x_{Lε})/π(x_0) · exp(½‖p_0‖² − ½‖p_{Lε}‖²))` with `π = e^{−U}`.
  - Agent `acc` = `min 1 (exp(U x_0 − U x_{Lε} + ‖p_0‖²/2 − ‖p_{Lε}‖²/2))`.
  - Both are TEX:366-369 in the form used at TEX:949.
- **Abstraction (treated alike for all arms).**
  - The Kit works on `EuclideanSpace ℝ (Fin d)`. It passes ∇U as a free field `gU`, and links it to U (`IsGradField`) only in T02, T01 and C01. Its L03 audit notes that `IsGradField` is not assumed, as a gate-approved generalization.
  - The Agent works on any real normed space and passes ∇U as a free field `g`, with no link to U except `hasDerivAt_expfam`.
  - Instantiating at ℝ^d and ∇U gives the printed statement, with no printed hypothesis dropped or added. I count this abstraction as faithful for every arm.
  - Dropping a hypothesis that the paper prints for that result counts as "stronger". An extra hypothesis, including a predecessor clause or a cited input kept as a parameter, counts as "weaker". A different conclusion counts as "different". These are the same conventions as in E3.
- **Quantifier reading of 5.15/5.16.** The lemmas say "for all ‖x_0‖>η and any ‖p_0‖ ≤ ‖x_0‖^δ for some δ<1". In the fixed-δ reading, η may depend on δ. This reading is the one the proofs use, the one Lemma 5.17 uses ("for any δ<1", TEX:940), and the one the corrigendum writes ("for any fixed δ<1"). The Kit and the Agent both use it, and I rule it faithful. The uniform reading is also true (the Kit's enc1 probe `concl_true`).

### Kit (first round, snapshot `pv_work/`)

| Result | Lean theorem | Lean signature (brief) | Printed statement | Ruling | Reason / disclosure |
|---|---|---|---|---|---|
| 5.15 | `Paper.L01.L01_main_fixedDelta` (L01.lean:76, = `lean_main`) | `0 < eps → HypExplode gU → ∀ δ < 1, ∃ η, ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → 2‖x0‖ < ‖xLF gU eps x0 p0 1‖` | "If (17) holds then there exists an η<∞ such that for all ‖x_0‖>η and any ‖p_0‖≤‖x_0‖^δ for some δ<1, … ‖x_ε‖>2‖x_0‖" (TEX:884-886) | **faithful** | fixed-δ reading |
| 5.16 (`lean_main`) | `Paper.L02.L02_main_fixedDelta_mod_gaps` (L02ModGaps.lean:626) | `L02_main_fixedDelta_Gap → L02_L01Consumed gU eps → 0 < eps → HypExplode gU → ConclFixedDelta gU eps L` | "If (17) holds then … ‖x_{Lε}‖ ≥ 2^L‖x_0‖" (TEX:899-901) | **different** (gap record) | Its premise is the lemma's own ∀-closure, so the theorem adds nothing to the premise. The premise is true (`grader_L02_gap_true`). The Kit's verdict is ISSUE, and it does not cite this theorem as evidence that the proof holds. |
| 5.16 (issue, auxiliary) | `Paper.L02.L02_main_fixedDelta_osc` (L02ModGaps.lean:607) | `L02_L01Consumed → 0 < eps → HypExplode → HypOscillations → ConclFixedDelta` | same | **weaker** (adds (18)) | Disclosed (B01: "proved with (18) as premise"). Shows that the printed route goes through once (18) is assumed. |
| 5.16 (statement true) | probe `Paper.L02.IssueCheck1.gap_holds` (`pv_work/probes/issue/L02/issue_L02_positive.lean`; grader copy `Grader.KitC.gap_holds`) | `∀ d gU eps L, L02_L01Consumed gU eps → 0 < eps → HypExplode gU → ConclFixedDelta gU eps L` | same | **weaker** (Lemma 5.15's conclusion as a parameter) | Disclosed. The Kit's own `L01_main_fixedDelta` proves the parameter. The grader's join `grader_L02_uncond` (`0 < eps → HypExplode gU → ConclFixedDelta gU eps L`) is faithful, with standard axioms. The probe is labelled "suggestion only, not used in any verification", but B01 and the report (§4.2) cite it as the evidence that the conclusion holds under (17). Its argument is the two-step leapfrog identity, the same as the Agent's and the corrigendum's. |
| 5.17 | `Paper.L03.L03_main` (L03.lean:330, = `lean_main`) | `L03_L02Consumed gU eps L → 0 < eps → 1 ≤ L → (17) → (18) → (19) → δ < 1 → Tendsto (accProb U gU eps L) (tailMomFilter d δ) (𝓝 0)` | "If (17), (18) and (19) hold then for any δ<1 … lim α(x_0,x_{Lε}) = 0" (TEX:939-944) | **weaker** (predecessor clause) | The clause is 5.16's conclusion plus the per-step doubling that 5.16 proves but does not state (`L03Stmt.lean:16-28`). Disclosed (CONDITIONAL; report §3 #2). Otherwise the hypotheses and conclusion match. The grader's join `grader_L03_uncond` (under (17)-(19) only) is faithful. |
| 5.14 | `Paper.T02.T02_main` (T02.lean:324, = `lean_main`) | `T02_L02Consumed → Prop35 → GaussFacts → 0 < d → IsGradField U gU → ∫⁻ e^{−U} < ⊤ → 0 < eps → 1 ≤ L → (17) → (18) → (19) → ¬ GeomErgodic U gU eps L` | "If (17), (18), (19) … HMC with fixed integration time T = Lε does not produce a geometrically ergodic chain for any T>0" (TEX:863-877) | **weaker** (three parameters) | `GeomErgodic` (T02Stmt.lean:65) is eqn:geoerg (TEX:266-268): ∃ρ<1 and a π-a.e. finite M with TV(P^n(x,·), π) ≤ M(x)ρ^n. The kernel `hmcStep` is Algorithm 1 with fixed L, as "fixed integration time". The conditions d>0, `IsGradField` and finite mass are standing conventions. Disclosed. The grader's join `grader_T02_only_cited` removes `T02_L02Consumed`, leaving `Prop35` (cited) and `GaussFacts` (standard). The grader did not re-verify the encoding of `Prop35`. |
| 2.2 | `Paper.T01.T01_main` (T01.lean:53, = `lean_main`) | `(HypExplode → HypOscillations → T02_L02Consumed) → Prop35 → GaussFacts → Thm518 → … → T01Concl`. Here `partI`: (17)∧(18)∧(19) → ¬GE; `partII`: (∃M, ‖gU‖ ≤ M) ∧ (∀ s>0, ∫ e^{s‖x‖} dπ = ⊤) → ¬GE | "If either (i) … or (ii) … then HMC will not produce a geometrically ergodic chain" (TEX:208-219) | **weaker** (four parameters; deterministic L) | Both clauses match the printed hypotheses. The restriction to fixed L is disclosed (report §0 "Fixed L only"; X2). The grader's join `grader_T01_only_cited` leaves only `Prop35`, `GaussFacts` and `Thm518`. |
| 2.3(ii) (issue) | `Paper.C01.Issue1.osc_fails` (C01_Counterexample1.lean:88), `not_S2Printed` (:144); also `osc_holds` (:100) | `InExpFam β α U → IsGradField U gU → 2 < β → β < logb 2 6 → ¬ HypOscillations gU`; `¬ (∀ β α U gU, InExpFam β α U → IsGradField U gU → 2 < β → HypOscillations gU)` | TEX:806 ("a direct consequence of Theorem 2.2"), with (18) at TEX:868-871 and the class at TEX:223-226 | **faithful** | `InExpFam` (C01Stmt.lean:26) is the printed class in d = 1: α,β>0, π = e^{−U} ∈ C¹, and π(x) = c·exp(−α‖x‖^β) for ‖x‖>M. The tail gradient is derived in Lean (`tail_grad`). log₂6 = 1+log₂3, the key's range. `not_S2Printed` refutes exactly the step "β > 2 ⇒ (18)", with witness β = 5/2, α = 1. |
| 2.3(ii) (`lean_main`) | `Paper.C01.C01_main_mod_gaps` (C01ModGaps.lean:227; `RESULTS.json` says ":1") | `C01_S2_Gap → … → C01Concl β U gU eps L` | TEX:229-239 | **different** (vacuous) | Its premise `C01_S2_Gap` is false (`grader_C01_gap_false`). It is a record of the printed route and is not cited as evidence that (ii) holds. |

### Agent (`LightTails.lean`, `HeavyTails.lean`)

| Result | Lean theorem | Lean signature (brief) | Printed statement | Ruling | Reason / disclosure |
|---|---|---|---|---|---|
| 5.15 | `lemma_5_15` (LightTails.lean:93) | `0 < ε → δ < 1 → Explode g → ∃ η, ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → 2‖x0‖ < ‖(lf g ε x0 p0 1).1‖` | TEX:884-886 | **faithful** | fixed-δ reading; abstraction as above |
| 5.16 | `lemma_5_16` (:148) | `0 < ε → δ < 1 → Explode g → ∃ η > 0, ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → ∀ L, 2^L‖x0‖ ≤ ‖x_{Lε}‖` | TEX:899-901 | **faithful** | Under (17) only, as printed. η is uniform in L; the printed statement leaves the order of η and L open, and the instance at the paper's L is the printed claim. Backs "statement true". |
| 5.16 (extra) | `lemma_5_16_doubling` (:117) | `… ∀ n, 2‖x_{nε}‖ ≤ ‖x_{(n+1)ε}‖ ∧ ‖x0‖ ≤ ‖x_{nε}‖` | the per-step doubling claimed in the proof (TEX:934) | stronger than the printed statement | correct; feeds 5.17 |
| 5.17 | `lemma_5_17` (:223) | `0 < ε → δ < 1 → 1 ≤ L → Explode g → Osc g → Osc2 U L → ∀ η>0, ∃ R, ∀ x0 p0, R < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → acc U g ε L x0 p0 < η` | TEX:939-944 | **faithful** | All three hypotheses are kept; `Osc` is unused. U and g are not linked (abstraction, as in the Kit's L03). Since acc ≥ 0, the conclusion is the printed limit. |
| 5.17 / 5.14 ((18) not needed) | `logAcc_tendsto` (:177), `acc_small` (:237), `expected_acc_tendsto_zero` (:273) | as `lemma_5_17` / `thm_5_14` without `Osc g` | — | stronger (drop (18)) | backs the Agent's claim that (18) is superfluous; see §3 |
| 5.14 | `thm_5_14` (:317) | `IsProbabilityMeasure μ → 0 < ε → 1 ≤ L → Explode g → Osc g → Osc2 U L → ∀ η>0, ∃ R, ∀ x0, R < ‖x0‖ → ∫⁻ p, ofReal (acc U g ε L x0 p) ∂μ < η` | TEX:863-877 | **different** (core) | The conclusion is "expected acceptance → 0", i.e. r(x_0) → 1, not "not geometrically ergodic". There is no HMC kernel, no total variation and no essential supremum. The remaining steps are by hand and disclosed: r → 1 ⇒ ess sup r = 1 (π > 0), then Prop 3.5. The answer says "Prop 3.5 then gives the claim", and its opening says the step through Props 3.5/3.6 is "used as allowed, not re-proved". μ is any probability law, which covers N(0,I). |
| 2.2 (i) | `thm_5_14` | as above | TEX:211-213 | **different** (core) | as above; random L handled in words |
| 2.2 (ii) | `thm_5_18` (HeavyTails.lean:103), `displacement` (:36) | `0 < ε → (∀ x, ‖g x‖ ≤ B) → ∀ L, ∀ η>0, ∃ δ, ∀ x0, μ{p \| δ ≤ ‖x_{Lε} − x0‖} < η`; `‖x_{nε} − x0‖ ≤ nε‖p0‖ + ε²Bn²/2` | TEX:215-217, via Thm 5.18 (TEX:978-996) | **different** (core) | Proves the hypothesis of Prop 3.6 (uniform tightness), not the conclusion. Prop 3.6 is not in Lean (disclosed). |
| 2.3(ii) (issue) | `not_osc_expfam` (:331), `not_osc_beta_five_halves` (:366) | `0 < α → 1 < β → 2^{β−1} < 3 → (∀ x, M0 < \|x\| → \|g x\| = αβ\|x\|^{β−1}) → ¬ Osc g` | TEX:806 with TEX:868-871, 223-226 | **faithful** | The class enters through its tail gradient \|∇U\| = αβ\|x\|^{β−1}. This is the paper's own formula (TEX:809) and holds for every member. The derivative is checked separately (`hasDerivAt_expfam`, x>0) rather than linked in one statement. The theorem covers the whole range 1 < β < 1+log₂3. |
| 2.3(ii), β > 2 (repair) | `cor_2_3_ii_large` (:428) | `0 < α → 2 < β → 0 < ε → 1 ≤ L → (U tail = α\|x\|^β + c) → (\|g\| tail = αβ\|x\|^{β−1}) → ∀ η>0, ∃ R, ∀ x0, R < ‖x0‖ → ∫⁻ acc dμ < η` | TEX:238 | **different** (core) | as `thm_5_14` |
| 2.3(ii), β < 1 | `bounded_grad_expfam` (HeavyTails.lean:124), `no_exp_moment_expfam` (:162) | g continuous with the tail formula ⇒ ∃ B, ∀ x, ‖g x‖ ≤ B; `∫⁻ ofReal(exp(s\|x\|)·exp(−U x)) = ⊤` for s > 0 | the two hypotheses of 2.2(ii) for E(β,α), β < 1 | **faithful** (for the two hypotheses) | Continuity of g = U′ follows from π ∈ C¹ and π > 0. The moment condition is stated as an unnormalised Lebesgue integral, which is equivalent because 0 < Z < ∞. |

### Chat (`lean_blocks/block_01.lean`)

| Result | Lean theorem | Lean signature (brief) | Printed statement | Ruling | Reason / disclosure |
|---|---|---|---|---|---|
| 5.15 | `lemma_5_15_core` (l.7) | `0 < ε → 0 < ‖x0‖ → 4‖x0‖ ≤ (ε²/2)‖g‖ → ε‖p‖ ≤ ‖x0‖/2 → 2‖x0‖ < ‖x0 − (ε²/2)•g + ε•p‖` | TEX:884-886 | **different** (core) | One deterministic step with numeric premises; no (17), η or δ. The Chat calls it "Formalised as `lemma_5_15_core`". |
| 5.17 | `gamma_L` (l.22), `lemma_5_17_square` (l.31) | `1 − 2Σ_{i=1}^L (1/3)^i = (1/3)^L`; `0 ≤ A − P → A − P ≤ q → P² − q² ≤ 2A(P − A/2)` | TEX:955-965 (steps) | **different** (steps) | Correct steps (with A = εγ_L‖∇U‖/2, the second is the paper's bound at TEX:962-965), not the lemma. |
| 2.3(ii) (issue) | `oscillations_fails_beta_five_halves` (l.47) | `∀ C, ∃ x y : ℝ, 0 < x ∧ C ≤ 2x ∧ 2x ≤ y ∧ y^{3/2} < 3x^{3/2}` | TEX:806 with (18) | **different** (reduced form) | This is (18) for the bare power x^{3/2} at β = 5/2, with αβ divided out. No U, ∇U or class appears. The reduction is stated in the docstring ("U'(x) ∝ x^{3/2} on x > 0"); in the class it holds for x > M, where U′(x) = (5/2)α x^{3/2}. The grader's `grader_chat_not_osc` derives ¬(18) for any g with tail \|g x\| = c\|x\|^{3/2}, c > 0, in a few lines, so the reduction is routine. Counted leniently. |

The Chat says its code "has **not been machine-checked**". The code compiles with standard axioms (`lean_check.md`; grader).

## 3. Claims outside the reference

No arm reports a problem in a numbered result that the reference lacks. Every arm's verdicts match the key, and no arm calls a key-OK result FALSE or PROOF. The remaining claims (notes on proofs, editorial points, repairs and strong positive claims) were checked by hand, and some also in Lean.

### Kit

| # | Claim (quoted) | Check | Ruling |
|---|---|---|---|
| K1 | "(17) does not imply (18) (reasoning example U' = x^3(2+sin x), not checked in Lean)" (B01) | (17): \|U′(x)\|/\|x\| ≥ x² → ∞. (18) fails: take x = π/2+2πk, so U′(x) = 3x³, and y the least point ≥ 2x with sin y = −1, so U′(y) = y³ ≤ (2x+2π)³ < 9x³ = 3U′(x) for x > 2π/(9^{1/3}−2) ≈ 78.4. A Lean witness from the Kit's own files: `grader_explode_not_osc` (β = 5/2). | correct |
| K2 | TEX:885 "quantifier order … is ambiguous; both readings are true" (report §5 #3; `revenc1/L01_issue_1.md`) | Uniform reading: ‖p_0‖ ≤ ‖x_0‖^δ for some δ<1 gives ‖p_0‖ < ‖x_0‖ (‖x_0‖>1), so the last term is < ε. A first term > 3+ε then suffices, by (17). | correct |
| K3 | TEX:896 "as printed it does not give ratio >2 for large ε; even read as a bound on ‖∇U(x_0)‖/‖x_0‖ it gives only ratio > 2 − (negligible)" (report §5 #4) | As printed: (ε²/2)·ratio > 6/ε² gives > 2 only if ε² < 2 (roughly). As a ratio bound: first term > 3, so the right side is > 3 − 1 − ε‖p_0‖/‖x_0‖. The slip is harmless because (17) gives any constant. | correct (editorial) |
| K4 | "per-step doubling is proved at 934 but not in Lemma 5.16's statement" (report §4.x; `L03_final` §6A) | TEX:953-954 applies (18) to consecutive pairs (x_{iε}, x_{(i+1)ε}), which needs ‖x_{(i+1)ε}‖ ≥ 2‖x_{iε}‖. 5.16's statement gives only ‖x_{Lε}‖ ≥ 2^L‖x_0‖. | correct (exposition) |
| K5 | squaring at TEX:958-959 needs ‖p_0‖ ≤ (εγ_L/2)‖∇U(x_{Lε})‖; the step to ≤ −‖x_0‖² is routine (`L03_final` §5) | Squaring a lower bound needs it to be non-negative; it holds for large ‖x_0‖. | correct |
| K6 | "'for any M<∞': the displayed chain fails for M<1; M=1 suffices" (report §5 #8) | At M = 0, "0 ≥ 2^L‖x_0‖" is false. For 0<M<1 the chain does not follow from 5.16 as stated (it holds for large ‖x_0‖ under (17)). M = 1 suffices for the conclusion. | correct (editorial; "fails" is literal at M ≤ 0) |
| K7 | "δ_L is undefined (equals γ_L)"; TEX:954 "silently re-indexes i→L−i … the aggregate inequality is correct" (report §5 #6, #7) | With ‖∇U(x_{iε})‖ ≤ 3^{−(L−i)}‖∇U(x_{Lε})‖, Σ_{i=1}^{L−1}‖∇U(x_{iε})‖ + ½‖∇U(x_0)‖ ≤ Σ_{i=1}^{L} 3^{−i}‖∇U(x_{Lε})‖. | correct (editorial) |
| K8 | X1: passage from α→0 on a high-probability region to ess sup r = 1 is a fair implicit step (`T02_final` §6) | 1 − r(x) ≤ sup_{region} α + P(‖p_0‖ > ‖x‖^δ) → 0, and π > 0 on every tail. | correct |
| K9 | 2.2(ii) "≤M" vs Thm 5.18 "<M": "FAIR_IMPLICIT_STEP (M→M+1)" | trivial | correct |
| K10 | X2: "Thm 2.2 stated for random 𝔏 under A1, verified for fixed L" (report §4.x, left open) | Thm 2.2 does not fix L, but its (19) contains 2^L. Thm 5.14 is for fixed T = Lε. | correct (exposition) |
| K11 | X3: "Theorem 2.2 has no proof or pointer" | TEX:208-219 is followed by discussion, with no proof environment and no reference to §5. | correct (exposition) |
| K12 | "the HMC acceptance depends on p_0 when Prop 3.5 is applied" (report §5); "the Roberts–Tweedie argument uses only the rejection mass P(x,{x}) ≥ r(x)" (`T02_final` §6) | The HMC acceptance (TEX:366-369) depends on p_0, not only on (x,y). The marginal kernel has P(x,{x}) ≥ r(x), and that is what the cited argument needs. | correct (observation, not a defect) |
| K13 | Repairs: B01 "state Lemma 5.16 as 'If (17) and (18) hold'" or argue from (17); B02 (1) restrict to β ≥ log₂6 (`osc_holds`), (2) "replace '2' in (18) by 'some fixed k≥2' (… k=3^(1/(β-1)))", flagged unverified | (B01) `L02_main_fixedDelta_osc` and `gap_holds`. (B02-1) `osc_holds` compiles. (B02-2) For \|y\| ≥ k\|x\| the ratio is ≥ k^{β−1} = 3, and under (17) the lemmas give any fixed step ratio. This is essentially the corrigendum's repair (\|y\| ≥ 3\|x\|). Since (18) can be dropped altogether (A1), any such variant works. | correct |
| K14 | "envoked"/"Envoking"/"envoking" spelling; missing full stop at TEX:806 | TEX:806: "Theorem \ref{thm:negative} For part (i)". | correct (editorial) |

### Agent

| # | Claim (quoted) | Check | Ruling |
|---|---|---|---|
| A1 | "The oscillations condition is not needed: since εp_{Lε} = x_{Lε} − x_{(L−1)ε} − (ε²/2)∇U(x_{Lε}), we get ‖p_{Lε}‖ ≥ 2‖x_{Lε}‖, so ‖p₀‖² − ‖p_{Lε}‖² ≤ −‖x₀‖²"; "The simplest repair for the paper: drop the oscillations condition from Thm 2.2(i)/5.14 and Lemma 5.17" | Strong positive claim, going beyond the key and the corrigendum, which keeps a corrected (18). By hand:<br>(a) The identity holds: x_{Lε} = x_{(L−1)ε} + εp_{(L−½)ε} and p_{Lε} = p_{(L−½)ε} − (ε/2)∇U(x_{Lε}).<br>(b) Under (17), per-step doubling (A2) gives ε‖p_{Lε}‖ ≥ (ε²/2)‖∇U(x_{Lε})‖ − (3/2)‖x_{Lε}‖ ≥ 2ε‖x_{Lε}‖ for large ‖x_0‖.<br>(c) Hence ½‖p_0‖² − ½‖p_{Lε}‖² ≤ ½‖x_0‖² − 2‖x_0‖² for ‖p_0‖ ≤ ‖x_0‖.<br>(d) (19) at (x_0, x_{Lε}) then gives log α → −∞.<br>In Lean: `logAcc_tendsto`, `acc_small` and `expected_acc_tendsto_zero` have no `Osc` hypothesis and compile with standard axioms. Prop 3.5 does not use (18). | correct |
| A2 | "`lemma_5_16_doubling` shows ‖x_{(n+1)ε}‖ ≥ 2‖x_{nε}‖ for every n, with one threshold for all n" | Two-step identity: ‖x_{(n+2)ε}‖ ≥ ε²‖∇U(x_{(n+1)ε})‖ − 2‖x_{(n+1)ε}‖ − ‖x_{nε}‖ ≥ (5 − 2 − ½)‖x_{(n+1)ε}‖, by induction. Lean compiles. | correct |
| A3 | "'first term larger than 6/ε²' really means ‖∇U(x₀)‖/‖x₀‖ > 6/ε²; a slip, not an error" | The verdict (harmless slip) is right. The proposed reading alone still leaves the strictness slack noted in K3/C5. The Agent's own Lean uses 10/ε². | correct (diagnosis incomplete; not counted against it) |
| A4 | "The step to general i is also only sketched ('entirely analogous')" | TEX:934 | correct |
| A5 | "'εδ_L' should read 'εγ_L'"; "Squaring … needs εγ_L‖∇U(x_{Lε})‖/2 − ‖p₀‖ ≥ 0, which isn't stated"; "needs the step-by-step doubling from the proof of 5.16, not just its statement" | as K7, K5, K4 | correct |
| A6 | "Prop 3.5 is stated for Metropolis–Hastings kernels where α depends on (x, y) … really being applied through 'P(x,{x}) ≥ r(x)'" | as K12 | correct |
| A7 | "If L is random (as under A1), averaging over L still gives r → 1. The condition oscillation2 mentions L, so it should be read for L = 1, which is the strongest case." | {\|y\| ≥ 2^L\|x\|} shrinks as L grows, so (19) at L = 1 implies all L. Then 1 − r = Σ_l P(L=l)(1 − r_l) → 0 by dominated convergence (L ≥ 1 a.s.). | correct |
| A8 | "`displacement` gives ‖x_{Lε} − x₀‖ ≤ Lε‖p₀‖ + ε²ML²/2, matching the paper"; `thm_5_18` uniform tightness | The paper's bound (TEX:993) is Lε²M/2 + Mε²L(L−1)/2 + Lε‖p_0‖ = Lε‖p_0‖ + Mε²L²/2. Lean compiles. | correct |
| A9 | "The fix, for every β > 2: … `cor_2_3_ii_large` then gives acceptance → 0 through the strengthened Lemma 5.17" | follows from A1 with `explode_expfam` and `osc2_expfam`; "not geometrically ergodic" then needs Prop 3.5 (cited) | correct |
| A10 | β < 1: "this needs U ∈ C¹ and π > 0, which the paper takes for granted" | TEX:223 states π ∈ C¹; π > 0 is implicit in U = −log π (TEX:320). | correct |

### Chat

| # | Claim (quoted) | Check | Ruling |
|---|---|---|---|
| C1 | 2.2(i): "(5.oscillation2) contains `2^L`, which is meaningless when `L` is random under **A1**"; fix: the L = 1 version plus dominated convergence | as K10 and A7 | correct (exposition) |
| C2 | "Prop 3.5 … holds because `r(x) ≥ 1 − sup_{‖p₀‖≤‖x‖^δ} α − P(‖p₀‖>‖x‖^δ) → 1` and π charges every neighbourhood of infinity" | as K8 | correct |
| C3 | 2.2(ii): "`≤ M` while 5.18 uses `< M`, which is harmless. Random `L` is also harmless: `L` is a.s. finite" | P(‖x_{Lε} − x_0‖ ≥ δ) ≤ P(L > N) + sup_{l≤N} P(lε‖p_0‖ + ε²Ml²/2 ≥ δ), uniformly in x_0 | correct |
| C4 | Cor 2.3(ii), β<1: "`U'` is globally bounded … `E_π e^{s\|x\|} = ∞` for every `s`" | as A10; s\|x\| − α\|x\|^β → ∞ | correct |
| C5 | 5.15: with ratio > 6/ε² "the right-hand side is `> 3 − 1 − ε‖p₀‖/‖x₀‖`, which is *slightly less* than 2 … Use 8/ε²" | as K3; with 8/ε² the first term is > 4 | correct (editorial) |
| C6 | 5.16: "The coefficient of `‖∇U(x_ε)‖/‖x_ε‖` is ε², not ε²/2. The weaker bound is still valid."; "`δ` is reused for two different quantities" | x_{2ε} = x_ε − ε²∇U(x_ε) − (ε²/2)∇U(x_0) + εp_0, so ε² is right, and ε²/2 gives a smaller, still valid lower bound. δ is both the momentum exponent and the slack in TEX:913-915. | correct (editorial) |
| C7 | "The lemma is nevertheless true under (explode) alone. By induction …" | The sketch is valid; it is proved in Lean by the Agent (`lemma_5_16`) and by the Kit's probe. | correct |
| C8 | "The statement should also record the intermediate doublings … because Lemma 5.17 uses them" | as K4 | correct |
| C9 | 5.17: "`γ_L = 3^{−L}`"; squaring "valid once `εγ_L‖∇U(x_{Lε})‖/2 − ‖p₀‖ ≥ 0`"; "εδ_L" should be "εγ_L" | 1 − 2Σ3^{−i} = 3^{−L}; Lean `gamma_L`, `lemma_5_17_square` compile | correct |
| C10 | "`M‖x_{Lε}‖ ≥ 2^L‖x₀‖` should be `M‖x_{Lε}‖ ≥ M2^L‖x₀‖`" | Same line as K6. The printed chain is not justified for M < 1. The Chat's version holds for every M ≥ 0 by 5.16, and the Kit's M ≥ 1 also works. | correct (editorial) |
| C11 | "(Oscillations) is again avoidable: … `‖∇U(x_{iε})‖ ≤ (C/ε²)‖x_{(i+1)ε}‖` … `o(‖∇U(x_{Lε})‖)`" | From x_{(i+1)ε} = 2x_{iε} − x_{(i−1)ε} − ε²∇U(x_{iε}) (or the first step for i = 0): ε²‖∇U(x_{iε})‖ ≤ C‖x_{(i+1)ε}‖ ≤ C‖x_{Lε}‖ = o(‖∇U(x_{Lε})‖) by (17). The bracket in TEX:955 is then ≥ ½ − o(1). This is a different route from A1, with the same conclusion. | correct |
| C12 | "Theorem 5.14, and hence Corollary 2.3(ii), hold for all β > 2 if (5.oscillations) is dropped" | as A1, A9 | correct |
| C13 | 5.14: "`P(‖p₀‖ ≤ ‖x₀‖^δ) → 1` holds for any δ > 0" | It also makes explicit that δ > 0 is needed, which the paper's "δ<1" leaves implicit. | correct |

## 4. Totals

| Measure | Kit | Agent | Chat |
|---|---|---|---|
| Results correctly classified (of 6) | 6 | 6 | 6 |
| Nature right (PROOF results, of 2) | 2 | 2 | 2 |
| Known problems found (published, of 2) | 2 (Cor 2.3(ii); Lemma 5.16) | 2 | 2 |
| Main published error: (18) fails on E(β,α) for 2 < β < 1+log₂3 | yes, exact range, Lean (`osc_fails`) | yes, exact range, Lean (`not_osc_expfam`) | yes, exact range, Lean in reduced form |
| False alarms | 0 | 0 | 0 |
| Lean-backed claims, faithful only (of 6) | 2 (5.15, 2.3(ii)) | 4 (5.15, 5.16, 5.17, 2.3(ii)) | 0 |
| Lean-backed, also counting disclosed conditions (parameters for cited inputs or predecessor clauses) and a stated one-line reduction | 6 | 4 | 1 (2.3(ii)) |
| Core in Lean, final step to "not geometrically ergodic" by citation and hand | none | 5.14, 2.2 (`thm_5_14`, `thm_5_18`) | none |
| Cited inputs (6 uses): proved / explicit / hidden / unbacked | 1 / 5 / 0 / 0 | 4 / 2 / 0 / 0 | 0 / 4 (prose) / 0 / 2 |
| Claims outside the reference: correct / wrong / unclear | 14 / 0 / 0 | 10 / 0 / 0 | 13 / 0 / 0 |

Summary:

1. All three arms classify the six results as the reference does and find both published problems with the right nature and no false alarm: the failure of (18) on E(β,α) for 2 < β < 1+log₂3 behind Cor 2.3(ii), and the unassumed (18) in the proof of Lemma 5.16.
2. They differ in evidence:
   - The Kit formalizes the chain down to "not geometrically ergodic", with the HMC kernel and geometric ergodicity defined. It keeps Prop 3.5, the Gaussian facts, Thm 5.18 and the Lemma 5.16 clause as explicit parameters; the last is dischargeable from its own files, but it did not do so in round 1. Only 5.15 and the Cor 2.3(ii) counterexample are faithful without conditions.
   - The Agent proves 5.15-5.17 faithfully and self-contained, including the 5.16 clause and the Gaussian tail. It stops at "acceptance → 0" for 5.14 and 2.2.
   - The Chat has no Lean statement of any numbered result, only proof steps and a reduced counterexample (all of which compile, although it said they were not checked).
3. Agent and Chat go beyond the reference and the corrigendum by showing that (18) can be dropped from Lemma 5.17, Theorem 5.14 and Theorem 2.2(i): the Agent in Lean, the Chat by hand. The Kit records the gaps and proposes a ratio-k repair that matches the published fix, but does not notice that (18) is unnecessary.

## 5. Notes for the authors (not graded)

- **Kit file provenance.** `pv_work/superseded/rev1/` does not hold the first-round `C01.lean`, `C01Draft.lean` and `C01Stmt.lean`: they were overwritten by the revision-round copies moved in at 11:26. The snapshot `20261013-023743-before-revision/pv_work/` has the first-round versions. It agrees with `rev1/` for every other module and was used here.
- **Kit `lean_main` entries.**
  - L02's `lean_main` is a gap record whose premise is true (`grader_L02_gap_true`, via the Kit's own probe).
  - C01's is a gap record whose premise is false (`grader_C01_gap_false`). `RESULTS.json` gives its line as ":1"; the theorem is at line 227.
  - The predecessor clause carried by L03, T02, T01 and C01 is discharged in three lines from first-round theorems (`grader_L03_clause`). The Kit's report notes that this reconnection "was available but not executed".
- **(17) ⇏ (18) in Lean.** For 5.16, the Kit argues this only in words (K1), and the Agent and Chat do not address it; they only note that (18) is not a hypothesis of the lemma. The Kit's and the Agent's files nevertheless contain the Lean pieces. For the Kit, `C01_S1` and `osc_fails` at β = 5/2 give `grader_explode_not_osc`. For the Agent, `explode_expfam` and `not_osc_beta_five_halves` give `grader_agent_explode_not_osc`.
- **Strong claim A1/C11/C12.** It is correct and stronger than the published corrigendum, which keeps a corrected (18) with \|y\| ≥ 3\|x\|. The key step in the Agent's Lean proof is εp_{Lε} = x_{Lε} − x_{(L−1)ε} − (ε²/2)∇U(x_{Lε}). The authors may wish to look at it themselves, since neither the key nor the corrigendum covers it.
- **Agent session.** $3.24, 697 s, 45 turns. There were three permission denials: two `grep` searches in the Mathlib sources and one Python edit of its own Lean file. None of them concerns reference files.
- **Chat session.** $1.45, 275 s, 2 turns. The reply notes that "No tools were available in this turn". Its Lean compiles.

# P04 final audit (Proposition 4.6, prop:conv), source/SuperParetoPaper-v12.tex:315-321

- Auditor: pv-auditor (fresh subagent, claude-opus-5-5). Date: Tue Oct 13 02:02:05 EDT 2026.
- Audited object: `pv_work/P04.lean` sha256 8f95003b7c064363e059728bd95d86271bb89ea30334da962442c37169e6beee (imports only `P04Stmt`, sha256 84cc56ad…adb7 = gate r2). Not modified.
- Read directly: source :279-329 (statement :315-318, proof :319-321, definitions :284-311, use at :323); gate `verification/audits/P04_gate_r2.md` (whole); ruling `verification/audits/P04_issue_1.md` (whole); prover notes; `P04.lean` and `P04Stmt.lean` in full.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P04`)

Report `verification/audits/P04_mech.md`, `MECH CHECKS: PASS`.

| Item | Result |
|---|---|
| 1 compile `P04` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 private rebuild sha256 | PASS, IDENTICAL |
| 3 PVTools hash | PASS |
| 4 fingerprints vs gate r2 (18 gated decls: 12 Stmt defs + S1-S5, main) | PASS, all th/vh/bi identical |
| 6 `#pv_axioms P04` | ALL STANDARD |
| 7 `#pv_walk P04` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 8 project constants | only `P04Stmt` (12 defs), covered by gate r2 (each named in the snapshot) |
| 10 hyp usage | all USED except the `IsProbabilityMeasure` instance of `P04_S2` (UNUSED; harmless, formal only, gated binder) |
| 11 TRACED CONDITIONS | `none`: **incorrect, see §4** (P04_X01Tool is not registered in `external_tools`, so the script cannot trace it) |

## 2. Gap file

Not applicable: S4 is now proved in `P04.lean`; no `_Gap` hypothesis remains in the audited module (walk: no sorryAx; `P04_S4` th=4099464923 = gate snapshot = former `P04_S4_Gap` vh). `pv_work/P04ModGaps.lean` is stale (coordinator to supersede).

## 3. Axioms and sorry

Mechanical items 6-7 PASS. My probe `pv_work/probes/auditor/P04/auditor_P04_nonvac.lean` (log `pv_work/logs/auditor_P04_nonvac_2.log`, exit 0): S3, S4, S5 and the witness theorem all have closure axioms [propext, Classical.choice, Quot.sound], sorryAx not reached.

## 4. Per-theorem conditionality

| Hypothesis | Theorems | Where actually used | Status |
|---|---|---|---|
| `hX01 : P04_X01Tool` (Prop 1 of superPareto2024, quoted :296-299, provenance (i)) | `P04_S5`, `P04_main` | `P04_S5` line 494 `rw [hX01 μ inferInstance]` (directly, not passed on); `P04_main` uses it only via `P04_S5` for clause 2 | **condition** of clause 2 (":317 parenthetical, super-Pareto ⇔ 𝒫 ≤c F_X") |
| `hnd : ∀ c, μ ≠ δ_c` | `P04_S4`, `P04_main` | `P04_S4` → `s4_bwd` step B only (line 393 `apply hnd c`) | gate-approved TFA, not an external parameter |

Walk evidence (same probe): positive control `#pv_walk_decl P04_S5` reaches `P04_X01Tool`; `#pv_walk_decl P04_S4` and `#pv_walk_decl P04_S3` do **not** reach it. So clause 1 (DOR ⇔ 𝒫 ≤c F_X) and clause 3 (IOR ⇔ F_X ≤c 𝒫) are free of X01; only clause 2 uses it.

Correction to mech item 11: the script reports `TRACED CONDITIONS: none` because `P04_X01Tool` is not in the `external_tools` registry (`python3 scripts/pv_status.py tools` lists only T01/T02/P03 entries; `EXTERNAL_TOOLS.md` still has X01 only as a candidate). The gate approved it as an external parameter (gate r2 item 6). The coordinator must register it (id `P04_X01Tool`, `pv_work/P04Stmt.lean:64`, type (i), source :296-299, used by P04 S5 / clause 2, human check: domain and strictness conventions of Prop 1 of superPareto2024; also listed as candidate for T03).

## 5. Infrastructure

| Constant(s) | Record | Judgement |
|---|---|---|
| 12 defs of `P04Stmt` (`F`, `Fbar`, `Lam`, `suppIn`, `paretoCdf`, `paretoMeasure`, `quantile`, `ConvexTransformLE`, `DOR`, `IOR`, `SuperPareto`, `P04_X01Tool`) | gate r2 snapshot, individually, vh identical | PASS |
| Private helpers (item 9): `lam_eq`, `s4_F_mono`, `s4_set_nonempty`, `s4_set_bdd`, `s4_le_Q`, `s4_F_le_of_lt_Q`, `s4_Q_le`, `s4_le_F_Q`, `s4_Q_mono`, `s4_pareto_val`, `s4_supp_pareto`, `s4_key_le`, `s4_key_lt`, `s4_G`, `s4_lam_add_one` | reviewed here (read in full) | technical: quantile facts for the :111 inverse (via mathlib `monotone_cdf`, `tendsto_cdf_*`, right-continuity, `csSup` lemmas), Pareto value/support, field algebra, `1/Fbar = Λ+1` (= :320 identity). No new mathematics, no target smuggled. PASS |
| `s4_fwd`, `s4_bwd` | reviewed here (read in full) | carry the duality content; match issue-1 §5 (⇒)(a)-(d) and (⇐)A-D step by step; the only extra premise `hnd` is used only in (⇐)B. PASS |

No other in-project module is reached.

## 6. Route fidelity

| Source | Lean | Judgement |
|---|---|---|
| :320 "𝒫⁻¹(u)=1/(1−u)" | `P04_S1` (quantile of :111 computed: sSup of Iic) | faithful |
| :320 "𝒫⁻¹∘F_X = 1/Fbar_X = Λ_X+1" | `P04_S2` on `suppIn (F μ)` | faithful |
| :320 "result follows", clause 3 (F_X ≤c 𝒫 ⇔ Λ convex) | `P04_S3`: convexity invariant under +1 | faithful; exactly what the source computes |
| :320 "result follows", clause 1 (𝒫 ≤c F_X ⇔ Λ concave) | `P04_S4` = `s4_fwd`/`s4_bwd`: the :320 identity + duality "increasing concave ⇔ inverse convex" for the :111 generalised inverse | **FAIR_IMPLICIT_STEP** (issue 1), filled as below |
| :317 parenthetical "(equivalently super-Pareto)" via :298 (Prop 4.3, cited) and :301 (Λ = 1/Fbar − 1) | `P04_S5` with `hX01`, `lam_eq` | faithful; cited result kept as visible parameter |
| assembly | `P04_main := ⟨S4, S5.symm.trans S4, S3.symm⟩` | faithful |

FAIR_IMPLICIT_STEP fill-in (S4): (⇒) Φ = 1/Fbar concave on S = {0<F<1}; S upward closed; Φ strictly increasing right of any point of S (concavity + Φ→∞); T(x) = F⁻¹(1−1/x) satisfies T(a x₁+b x₂) ≤ a T(x₁)+b T(x₂) by the quantile facts. (⇐) T monotone, continuous (convex on open set); F<1 (else T bounded convex ⇒ constant ⇒ μ Dirac, excluded by `hnd`); F⁻¹(F p) = p on S (left continuity of T); then concavity of Φ from convexity of T. No stronger result than the source's identity + standard duality is used; route unchanged.

### Review of ruling `verification/audits/P04_issue_1.md`

- Classification FAIR_IMPLICIT_STEP: **accepted**. Definition :310 is stated as F₂⁻¹∘F₁ convex; the proof at :320 computes only 𝒫⁻¹∘F_X, which is the transform of clause 3. Clause 1 needs the inverse direction, which is the standard concave/convex inverse duality of the convex transform order; with atoms and flat pieces it needs only routine generalised-inverse bookkeeping (checked line by line in `s4_fwd`/`s4_bwd`). The given justification is incomplete, not wrong, and the step holds on every non-degenerate law. So it is not a PAPER_ARGUMENT_GAP.
- No external parameter: confirmed by walk (S4 closure contains no `P04_X01Tool` or other `Prop` parameter; its only premises are μ, the instance and `hnd`).
- The helpers in `P04.lean` correspond to the ruling's probe `pv_work/probes/issue/P04/P04_issue1_S4fill.lean` (sha256 08d5dbac…d4fb), renamed `s4_*` and made private (prover notes). I reviewed the copies in `P04.lean`, and they are what the kernel checked. This closes the ruling's "independent review pending" item (§7) for the S4 fill-in. The Dirac case and the domain questions are not covered by this review.
- Suggested editorial addition at :320 (issue 1 §6): correct as worded ("increasing; concave iff inverse convex").

## 7. Non-vacuity

Probe `pv_work/probes/auditor/P04/auditor_P04_nonvac.lean` (exit 0, log `pv_work/logs/auditor_P04_nonvac_2.log`):
- Nontrivial witness: uniform law on [0,1] (`volume.restrict (Icc 0 1)`), with `IsProbabilityMeasure` proved and non-Dirac proved (`unif_nd`: singletons are null). `nonvac_main (hX01) := P04_main hX01 unif unif_nd` compiles, so every hypothesis except the parameter X01 is discharged. Clauses 1 and 3 are also instantiated without X01 (`P04_S4 unif unif_nd`, `P04_S3`).
- X01 is not vacuous: gate r2 item 6 argued it true as stated (not checked in Lean here).
- Dirac sanity check for `hnd`: proved `¬ DOR δ₀` (F(0)=1). Together with the gate's hand check that 𝒫 ≤c δ_c holds (constant transform), this confirms that `hnd` is needed and that it excludes only the one-point laws.

## 8. Open source-side points (not ruled here)

- Dirac case (gate r2 item 7, second bullet): at X = c, 𝒫 ≤c δ_c holds, while δ_c is not super-Pareto (:286, h nonconstant) and not DOR in the real-valued reading. So clause 2, and clause 1 under that reading, fail literally. `hnd` is a gate-approved TFA that is visible and recorded. **No independent ruling exists yet** (no `P04_issue_2`). Note for the issue checker: clause 2 fails at δ_c under every reading of "concave", because super-Pareto excludes δ_c by :286 and ≤c holds for it. Classify between EXPOSITION_GAP (degenerate case not discussed) and ERROR. If confirmed, P04 becomes ISSUE (ISSUE takes precedence, VERDICTS §1.3), with clauses 1-3 still verified for non-degenerate X under the condition below.
- Domain of concavity/convexity (:306, :310) and "increasing odds rate" undefined (gate item 7, third bullet): preliminary DOMAIN_CLARIFICATION, not ruled.
- Encoding choices E3 (`suppIn` domain) and A2 (`F<1` inside DOR and X01): approved by the gate as faithful readings. They manufacture no paper error here.

## 9. Status for the authors

Verified in Lean along the source route (:320 identity plus one fair implicit duality step) for every non-degenerate X: DOR ⇔ 𝒫 ≤c F_X and IOR ⇔ F_X ≤c 𝒫 unconditionally; "super-Pareto ⇔ 𝒫 ≤c F_X" conditional on the cited Prop 1 of superPareto2024 (:298). Source: the passage to F_X⁻¹∘𝒫 at :320 is left implicit (fair). The degenerate X = c is a literal exception to the statement that the text does not discuss (pending ruling), and the domain of concavity is unstated.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: P04_X01Tool

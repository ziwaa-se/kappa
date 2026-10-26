# L01 final audit (Lemma `lem:steps`, source/main.tex:35-43)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), 2026-10-12 22:11 EDT
- Audited object: `pv_work/L01.lean` (no gap file; prover notes report no gaps)
- Read myself: source/main.tex:1-60 (definition main.tex:24-27, lemma 35-38, proof 40-43); `pv_work/L01.lean`, `pv_work/L01Stmt.lean`, `pv_work/Defs.lean` in full; gate report `verification/audits/L01_gate.md`; DEFS gate `verification/audits/DEFS_gate.md`; draft and prover notes.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L01`)

Report `verification/audits/L01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | 12 gated fingerprints vs L01_gate | PASS |
| 5 | Defs vs DEFS_gate | PASS |
| 6 | `#pv_axioms L01` | ALL STANDARD |
| 7 | `#pv_walk L01` | no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | hyp usage | no UNUSED; `Conclusion.values` warning is the structure projection (binder count artefact, not a parameter) |
| 11 | traced conditions | none |

## 2. Gap file
Not applicable (no `L01ModGaps.lean`; no stopped obligations).

## 3. Axioms / sorry
Confirmed again in probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (log `pv_work/logs/auditor_L01_nonvac_2.log`): `#pv_axioms L01` ALL STANDARD for S1, S2, main; `#print axioms L01_main` = [propext, Classical.choice, Quot.sound].

## 4. Per-theorem conditionality
No external parameters exist. The only hypotheses are `n`, `hn : 1 ≤ n`, `x` (and `s t hst`, `t` as statement variables). `#pv_hyp_usage` on `L01_S1`, `L01_S2` (probe): all USED. `hn` is the source hypothesis `n ≥ 1` of Definition `def:edf` (main.tex:25), not an external parameter. (Remark: mathematically S1 holds without `hn`, but `hn` is a source hypothesis, so this is not a defect.)

## 5. Infrastructure (individual audit; no prior infrastructure records)

| Constant | Module | Audit on the spot | Result |
|---|---|---|---|
| `Paper.Defs.edf` | Defs | Definition `(1/n) * #{i : Fin n | x i ≤ t}` = main.tex:26 (index shift i ↦ i+1, non-strict ≤); no theorem content, cannot smuggle a conclusion; fingerprint identical to DEFS_gate | PASS |
| `Paper.L01.Conclusion` | L01Stmt | Plain Prop structure with two fields = the two printed clauses (main.tex:36-37); no hidden premises | PASS |
| `Paper.L01.Conclusion.mk` | L01Stmt | Auto-generated constructor | PASS |

No other project constants in the closure.

## 6. Route fidelity

| Source sentence | Lean | Ruling |
|---|---|---|
| main.tex:41 "If s ≤ t, every i with x_i ≤ s also satisfies x_i ≤ t" | `hsub`: filter at s ⊆ filter at t via `hi.trans hst` | faithful |
| main.tex:41 "so F_n(s) ≤ F_n(t)" | `Finset.card_le_card hsub`, multiplied by `1/n ≥ 0` (`mul_le_mul_of_nonneg_left`) | FAIR_IMPLICIT_STEP: monotonicity of multiplication by the nonnegative factor 1/n, filled by a mathlib lemma |
| main.tex:41-42 "n F_n(t) counts a subset of {1,…,n}" | k := card of the filter; `Finset.card_le_univ` + `Fintype.card_fin` gives k ≤ n, i.e. k ∈ range (n+1) | FAIR_IMPLICIT_STEP: "a subset of an n-element set has at most n elements" |
| (implicit) n · (1/n) · k = k | `field_simp` with `(n:ℝ) ≠ 0` from `hn` | FAIR_IMPLICIT_STEP: cancellation using n ≥ 1 (source hypothesis) |
| assembly | `⟨L01_S1 hn x, L01_S2 hn x⟩` | faithful |

No route change, no stronger result used, no helper lemmas, no new mathematics.

## 7. Non-vacuity
Probe (exit 0): `L01_main` instantiated at n = 3, x = (0, 1, 2) gives `Conclusion x`; nontriviality checked: `edf x 1 = 2/3` (a non-extreme value). Statement-shape `example` with the gated type also compiles.

## 8. Status for the authors
Lemma `lem:steps` (both clauses: monotonicity of F_n, and n F_n(t) ∈ {0,…,n}) is verified in Lean along the printed proof, with no external inputs.
It depends only on Definition `def:edf` (n ≥ 1).
Source assessment: no errors, gaps or ambiguities; three standard implicit steps, all fair.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

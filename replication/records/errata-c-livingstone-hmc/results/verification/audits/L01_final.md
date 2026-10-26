# L01 final audit — Lemma 5.15 (lem:xelower), revised manuscript

- Auditor: pv-auditor (independent subagent, Opus), Tue Oct 13 10:51:12 EDT 2026
- Audited object: `pv_work/L01.lean` (no gap file; prover notes `pv_work/notes/L01_prover_notes.md`)
- Source read directly: `source/geo_erg_HMC_v3.1.tex:945-958` (statement and proof), 897-899 ((17) eqn:explode), 330-336 (leapfrog recursion, "step-size ε>0").
- Gate: `verification/audits/L01_gate.md` (STATEMENT GATE: PASS); DEFS snapshot `verification/audits/DEFS_gate.md`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L01`)
Report `verification/audits/L01_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | 8 gated fingerprints vs gate | identical |
| 5 | Defs vs DEFS snapshot | identical |
| 6–7 | `#pv_axioms`, `#pv_walk` | ALL STANDARD; sorryAx not reached |
| 9 | helpers not in snapshot | none |
| 10 | hyp usage | all used in `L01_main`; `heps` UNUSED in `L01_S4` only |
| 11 | traced conditions | none |

## 2. Gap files
None (all obligations proved). N/A.

## 3. Axioms / sorry
propext, Classical.choice, Quot.sound only; no sorryAx (mech items 6–7).

## 4. Conditionality
- No external parameter (`def … : Prop` tool) in any gated statement. `L01_main` hypotheses `heps : 0 < eps` (printed, TEX:336) and `h : HypExplode gU` ((17), the lemma's printed hypothesis) are both USED; they are source hypotheses, not conditions.
- `heps` UNUSED in `L01_S4`: correct mathematically (ε·r^{δ-1} → 0 for any real ε); it is a premise of an internal obligation, not of the main theorem, so no action on the result. Cosmetic only (could be dropped from S4's type).

## 5. Infrastructure (no individual records existed; audited on the spot)
| Constant | Source | Judgement |
|---|---|---|
| `Paper.Defs.E` | TEX:192-194 | `EuclideanSpace ℝ (Fin d)`, Euclidean norm. Faithful. |
| `Paper.Defs.leapfrogStep` | TEX:332-334, M=I | ph = p − (ε/2)∇U(x), x' = x + ε ph, p' = ph − (ε/2)∇U(x'). Faithful term by term. |
| `Paper.Defs.leapfrogState` (+ `match_1`) | TEX:330 "L steps of the recursion" | n-fold iterate from (x0,p0). Faithful. |
| `Paper.Defs.xLF` | TEX:330-336 | first component. Faithful; `xLF … 1` = x0 − (ε²/2)∇U(x0) + εp0 (proved as S1). |
| `Paper.Defs.HypExplode` | TEX:897-899 | `Tendsto (‖gU x‖/‖x‖) (comap ‖·‖ atTop) atTop`. Faithful; unchanged by revision. |
| `Paper.Defs.H._proof_1` | — | auto-generated `(0+2).AtLeastTwo := instNatAtLeastTwo` (numeral instance proof, shared); `#print` in probe. Harmless, no content. |
| `Paper.L01.Concl` (+ `_proof_1`) | TEX:946 | ∃ η, ∀ x0 p0, η<‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → 3‖x0‖ < ‖x_ε‖. Faithful (fixed δ first, as the gate ruled). Does not smuggle the conclusion as a hypothesis. |
None is an axiom; all are definitions; axioms of the closure are standard (mech item 7).

## 6. Route fidelity (sentence by sentence)
| Source | Lean | Fidelity |
|---|---|---|
| TEX:951 equality x_ε = x0 − (ε²/2)∇U(x0) + εp0 | S1: unfold + `module` | faithful (L=1 case of the recursion) |
| TEX:951 inequality ≥ (ε²/2)‖∇U‖ − ‖x0‖ − ε‖p0‖ | S2: norm_smul, triangle ineq. | faithful |
| TEX:953-956 divide by ‖x0‖ | S3 (with x0 ≠ 0) | faithful |
| TEX:957 last term ≤ ε‖x0‖^{δ−1}, → 0 | S4 (→ 0) + bound in S6 via `rpow_sub_one` | faithful |
| TEX:957 first term → ∞ by (17) | S5 from `HypExplode` | faithful |
| TEX:957 "Hence RHS > 3 for all sufficiently large ‖x0‖" | S6: thresholds B=5, c=1, η = max(R5,R4,0) | faithful |

No route change, no stronger result than the source used, no helper lemmas.
FAIR_IMPLICIT_STEP:
- "sufficiently large" made explicit: first term > 5 and last term < 1 gives RHS > 5 − 1 − 1 = 3.
- η ≥ 0 ensures ‖x0‖ > 0, so the division at TEX:955 is legitimate (the source divides silently).
- ‖p0‖/‖x0‖ ≤ ‖x0‖^{δ−1} from ‖p0‖ ≤ ‖x0‖^δ (source states the bound; filled in by `Real.rpow_sub_one`).

## 7. Non-vacuity
Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (log `pv_work/logs/auditor_L01_nonvac_3.log`, exit 0, 0 errors, 0 sorry): nontrivial witness `gU x = ‖x‖ • x` on E 1, proved `HypExplode` (axioms standard), and `L01_main` applied with ε = 1 and with ε = 1/10, δ = 1/2; the tail region is nonempty (a point of norm 6 exists).

## 8. Status for the authors
Verified: Lemma 5.15 in full along the printed route (one leapfrog step, reverse triangle inequality, divide by ‖x0‖, limit argument), for each fixed δ < 1 and step size ε > 0.
Depends on: only the printed hypothesis (17) and ε > 0 (TEX:336); no external inputs.
Assessment: no error, gap or ambiguity found in TEX:945-958.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none

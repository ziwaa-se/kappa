# C01 final audit (Corollary 2.3, part (ii) only; revision 1)

- Auditor: pv-auditor (claude-opus-5-5), 2026-10-13 11:42 EDT (`date`).
- Audited object: `pv_work/C01.lean` (delivered sha256 e9ffc144…, identical to the private rebuild).
- Source read directly: `source/geo_erg_HMC_v3.1.tex` 205-240 (Thm 2.2, class E(β,α), Cor 2.3), 800-839 (proof of (ii)), 893-910 (thm:light, revised (18)).
- Mechanical report: `verification/audits/C01_mech.md` — `MECH CHECKS: PASS`.
- Own probe: `pv_work/probes/auditor/C01/auditor_C01_final1.lean`, log `pv_work/logs/auditor_C01_final1_2.log` (exit 0, 0 errors, 0 sorry).

## 1. Mechanical checks (script, run by me)

| # | Check | Result |
|---|---|---|
| 1 | compile `C01` | PASS (exit 0, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | 21 gated fingerprints vs `C01_gate.md` | PASS |
| 5 | `Defs` vs `DEFS_gate.md` | PASS |
| 6-7 | `#pv_axioms` / `#pv_walk` | PASS: propext, Classical.choice, Quot.sound; sorryAx not reached |
| 12 | last writers | pv-prover (C01.lean), pv-drafter (C01Stmt.lean) |

## 2. Imported-definition fingerprints (requested by the gate)

From `#pv_type_hashes` / `#pv_walk_decl` in my probe, compared with `C01_gate.md` §6 table:

| Constant | now | gate | status |
|---|---|---|---|
| `Paper.T02.GeomErgodic` | th=4031747299 vh=3856057058 | same | identical |
| `Paper.T02.targetMeas` | th=2842052545 vh=3780488904 | same | identical |
| `Paper.T01.HypPartII` | th=3957315956 vh=1173314425 | same | identical |
| `Paper.L03.HypOscillations3` | th=3371666640 vh=3973787725 | same | identical |
| `Paper.Defs.HypExplode` | th=3371666640 vh=1652790231 | same | identical |
| `Paper.Defs.HypOscillation2` | th=2203084122 vh=3740005225 | same | identical |
| `Paper.Defs.IsGradField`, `Paper.Defs.piDens` | covered by mech item 5 (Defs identical to DEFS_gate) | | identical |

## 3. Per-theorem conditionality

| Hypothesis | Where actually used | Evidence |
|---|---|---|
| `hT01 : C01_T01Consumed` clause (b) (Thm 2.2(ii)) | `C01_S1c` (β<1), term `hT01.2 … ⟨S1a, S1b⟩` (TEX:806) | `#pv_hyp_usage C01_S1c`: USED; direct application in proof term |
| `hT01` clause (a) (Thm 2.2(i)/thm:light, revised (18)) | `C01_S6` (β>2), term `hT01.1 … S3 S4 S5b` (TEX:834) | `#pv_hyp_usage C01_S6`: USED; `#pv_walk_decl C01_S6` reaches `C01_T01Consumed` |
| `hE, hgrad, hπ, heps, hL` | standing conventions / class hypotheses; all USED in `C01_main` | `#pv_hyp_usage C01_main` |
| `hL` in `C01_S5a` | UNUSED (2^L ≥ 1 holds for every `L : ℕ`) | mech item 10. A redundant premise of a step obligation, faithful to TEX:825 "each fixed L≥1"; EDITORIAL, not a condition |

No external parameter is passed only to a helper; both uses are the direct applications above, so no deeper walk is needed.

**Condition id.** The mechanical tracer reports `TRACED CONDITIONS: none` only because `C01_T01Consumed` is **not registered** in `verification/EXTERNAL_TOOLS.md` (`pv_status.py tools` lists no such id). It is a real visible parameter (provenance (p), predecessor T01, approved by the gate) and is used as above. I correct the traced conditions to `C01_T01Consumed`; the coordinator should register it.
`T01_Thm518` is registered "C01 (via T01)" but no C01 theorem reaches it: it is not a condition of C01 now; it (and T01's other conditions `T01_T02Consumed`, and through T02 `T02_Prop35`, `T02_GaussFacts`) is inherited only at reconnection with T01.

## 4. Infrastructure (item 8, item 9)

| Module | Constants reached | Coverage |
|---|---|---|
| `C01Stmt` | `C01Concl`, `C01_T01Consumed`, `InExpFam`, `TailGrad` (+ auto `_proof_` terms) | `C01_gate.md` PASS (definitions only) |
| `Defs` | `E`, `piDens`, `IsGradField`, `HypExplode`, `HypOscillation2`, `accProb`, `leapfrog*`, `pLF`, `H` | `DEFS_gate.md` PASS (definitions only) |
| `L03Stmt` | `HypOscillations3` | `L03_gate.md` PASS; L03_final.md |
| `T01Stmt` | `HypPartII` | `T01_gate_r2.md` PASS |
| `T02Stmt` | `GeomErgodic`, `targetMeas`, `hmcStep`, `hmcPow`, `gaussMeas`, `tvDist` | `T02_gate_r2.md` PASS; T02_final.md |

No imported **theorem** is consumed; only definitions (each fingerprint-locked by its gate) and auto-generated `_proof_` well-formedness terms. Nothing to audit on the spot beyond the private helpers:

| Helper (private) | Content | Judgement |
|---|---|---|
| `rpow_sq_aux` | (r²)^{β/2-1} = r^{β-2} | technical |
| `grad_vec_aux` | gradient of k+α‖y‖^β is αβ‖x‖^{β-2}x (uniqueness of derivative) | technical calculus, part of TEX:810 |
| `expfam_U` | π = c e^{-α|x|^β} ⇒ U = −log c + α|x|^β in the tail | conversion of "∝" |
| `expfam_grad` | combination of the above | technical |
| `norm1`, `nz_of_pos` | ‖x‖ = |x 0| in E 1 | representation |
| `tail_norm_of_vec`, `tail_norm_of_tg` | ‖∇U(x)‖ = αβ|x|^{β-1} in the tail | TEX:813/821 computation |
| `expfam_fin` | ∫π < ∞ from the tail form (bound by (1+‖x‖)^{-2}) | standard; needed inside S1b for the normalisation (`targetMeas`) — consistent with "π is a density" |

None states or smuggles the conclusion; all axioms standard (walk).

## 5. Route fidelity

| Step | Source | Lean | Ruling |
|---|---|---|---|
| β<1 | TEX:806 "direct consequence of part (ii) of Thm 2.2" | S1c = clause (b) applied to S1a, S1b | faithful |
| S1a ‖∇U‖ ≤ M | not written (TEX:806) | continuity of ∇U (π∈C¹, π>0) on a compact ball + tail value αβ|x|^{β-1} ≤ αβ for |x|≥1 | FAIR_IMPLICIT_STEP |
| S1b E_π e^{s‖x‖} = ∞ | not written (TEX:806) | for large |x|, α|x|^β ≤ s|x| (β<1), so π e^{s|x|} ≥ c on a set of infinite Lebesgue measure; normaliser finite and nonzero | FAIR_IMPLICIT_STEP |
| S2 tail gradient | TEX:807-810 | `C01_S2` via `grad_vec_aux` | faithful (differentiation filled in, FAIR_IMPLICIT_STEP) |
| S3 (17) | TEX:811-816 | `C01_S3`, ratio αβ|x|^{β-2}→∞ | faithful |
| S4 (18), revised | TEX:817-824, C>3M, ratio ≥ 3^{β-1} > 3 | `C01_S4`, C = 3·max(M,0)+1 (> 3M, also covers M<0) | faithful |
| S5a/S5b (19) | TEX:825-834 | `C01_S5a` (bound with (2^L)^β = 2^{Lβ}), `C01_S5b` (→ −∞) | faithful; "|x| sufficiently large" → |x|>M |
| S6 | TEX:834 "Theorem thm:light applies conditional on each fixed L" | clause (a) applied to S3, S4, S5b | faithful |
| A1 / random 𝔏 | TEX:834-836 dominated convergence | **not encoded** (scope) | not covered; must not be claimed |
| main | (ii) TEX:238 | case split S1c / S6 | faithful |

No route change, no stronger result used than the source cites (clause (a)/(b) were shown equivalent to T01's conclusion at d=1 by the gate).

## 6. Non-vacuity

Probe: `U x = (‖x‖²)²` (β = 4 > 2, α = 1, M = 0, c = 1) satisfies `InExpFam 4 1 U4` and `IsGradField U4 (fun x => (4‖x‖²)•x)`; both compile, axioms standard. `hπ` follows from `InExpFam` (helper `expfam_fin`), `eps = 1`, `L = 1` trivial. So the hypotheses of `C01_main` other than `hT01` are jointly satisfiable in the β>2 branch. `hT01` is T01's conclusion at d=1 (gate probe `consumed_from_T01Concl`), discharged at reconnection.

## 7. Earlier issue B02 (`verification/audits/rev1/C01_issue_1*.md`)

Cause of B02: the old (18) required ‖y‖ ≥ **2**‖x‖ ≥ C ⇒ ‖∇U(y)‖ ≥ 3‖∇U(x)‖, false for 2<β<log₂6 (ratio 2^{β-1} < 3), and the old proof of (ii) said only "direct consequence of Theorem 2.2". In the revised source, (18) reads ‖y‖ ≥ **3**‖x‖ ≥ C (TEX:900-903), and the proof of (ii) now verifies it explicitly for every β>2 with ratio ≥ 3^{β-1} > 3 (TEX:817-824). `C01_S4` proves exactly this, for all β>2, with no gap. **The revised source removes the cause of B02 for C01**; the coordinator may use `--resolve B02`. (Whether the revised (18) still suffices for thm:light itself is T02's matter, covered by T02's own audit; C01 is conditional on it through `C01_T01Consumed`.)

## 8. Status for the authors

Verified: Cor 2.3(ii) for fixed number L of leapfrog steps (both β<1 and β>2 branches), along the source route, with all calculus steps filled in fairly.
Depends on: Thm 2.2 (i) with revised (18) and (ii) as consumed clause `C01_T01Consumed` (predecessor T01); part (i) not encoded (user scope); the random-𝔏/A1 passage TEX:834-836 not covered.
Source assessment: no error or gap found in (ii); the old B02 gap is removed by the revision; S1a/S1b are unwritten but standard verifications (FAIR_IMPLICIT_STEP).

## FAIL items

None. Record notes (not FAIL): register `C01_T01Consumed` in `EXTERNAL_TOOLS.md`; `T01_Thm518` is not a direct condition of C01 (only via T01 at reconnection); `hL` unused in `C01_S5a` (EDITORIAL).

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: C01_T01Consumed

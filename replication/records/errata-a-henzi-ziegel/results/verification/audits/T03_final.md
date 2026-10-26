# Final audit: T03 (Theorem 3.3, `thm:allscores`)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), Mon Oct 12 22:19 EDT 2026 (from `date`)
- Audited object: `pv_work/T03.lean` (no gaps, no `T03ModGaps.lean`)
- Source read directly: `source/VSIFP_02.tex:150-201` (statement 190-198, context 151, 188, 201), `:455-467` (proof 465-467); definitions via `pv_work/Defs.lean` (DEFS_gate_r2) and `pv_work/T03Stmt.lean` (T03_gate).
- Inputs read: `verification/audits/T03_gate.md`, `pv_work/notes/T03_prover_notes.md`, full `pv_work/T03.lean`, `pv_work/T03Stmt.lean`, `pv_work/Defs.lean`, `verification/EXTERNAL_TOOLS.md`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py T03` -> `verification/audits/T03_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `T03` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs T03_gate (10 gated decls) | PASS |
| 5 | Defs vs DEFS_gate_r2 | PASS |
| 6 | `#pv_axioms T03` | ALL STANDARD |
| 7 | `#pv_walk T03` | no sorryAx; propext, Classical.choice, Quot.sound only |
| 11 | traced conditions | `none` (**corrected below**: X03 is used but not yet registered) |

## 2. Gap files

None; not applicable.

## 3. Axioms / sorry

Clean (items 6-7). Also confirmed in my probe `auditor_T03_nonvac.lean`: `#pv_axioms T03: ALL STANDARD (10 declarations checked)`.

## 4. Per-theorem conditionality

`#pv_hyp_usage` (mech item 10 and probe `pv_work/probes/auditor/T03/auditor_T03_nonvac.lean`, log `pv_work/logs/auditor_T03_nonvac_1.log`):

| Theorem | X03 (`GruenwaldThm1`) | Other notes |
|---|---|---|
| `T03_S1`..`T03_S4` | not a hypothesis | — |
| `T03_S5` | USED (term is literally `X03 (HAll p q) π₁ p … s3 s4`) | `hq` UNUSED: a printed hypothesis, not an external parameter; harmless in a step obligation |
| `T03_main` | USED, only by passing to `T03_S5` | all 8 hypotheses USED |

Actual use of X03: step S5 = the sentence "The result then follows by Theorem 1 of \cite{Gruenwald2019}, with $W_1$ being the Dirac measure of the point $\{\pi_1\}$" (`VSIFP_02.tex:466`). No walk needed: S5's proof term is a direct application of X03 (positive control trivially satisfied).

**Correction to mech item 11.** The script reports `TRACED CONDITIONS: none` because X03 is listed in `EXTERNAL_TOOLS.md` only under "Candidates from INVENTORY §6", and the generated registry (`pv_status.py tools`) is empty. X03 is a real, used external parameter (provenance (i)), approved by the gate (T03_gate item 6). Condition: **X03**. It must be registered.

## 5. Infrastructure (no prior individual audit records; each audited here)

| Constant | Module | Judgement |
|---|---|---|
| `Paper.expPi` | Defs | `(1-π) f 0 + π f 1`: expectation under Bernoulli(π) (l.74, 91). Correct, no axioms (def). |
| `Paper.elemScore` | Defs | `(θ-y)(1{θ<p} - 1{θ<y})` = l.98-99 `S_θ(p,y)=(θ-y){1(p>θ)-1(y>θ)}`. Correct. |
| `Paper.HAll` | Defs | `{π ∈ [0,1] : ∀ θ ∈ [0,1], E_π{S_θ(p,Y)-S_θ(q,Y)} ≤ 0}` = l.140 (sup ≤ 0 iff all ≤ 0). Correct. |
| `Paper.IsEValue` | Defs | `E ≥ 0` at 0,1; `E_π E ≤ 1` on null; `> 1` on alternative (l.78, 142). Correct. |
| `Paper.EGrowAll` | Defs | `(1-π₁)/(1-p)` at y=0, `π₁/p` otherwise (l.193-196). Correct on y ∈ {0,1}. |
| `Paper.T03.LogFinite` | T03Stmt | positivity at outcomes of positive π₁-probability; encodes `log 0 = -∞` correctly. |
| `Paper.T03.IsGrowEValue` | T03Stmt | e-value for H vs {π₁}, finite growth, maximizes `E_{π₁} log` over null-e-values (l.151). Faithful. |
| `Paper.T03.GrowIs` | T03Stmt | GROW + π₁-a.s. uniqueness ("the GROW e-value", l.191). Faithful; not stronger than the text (pointwise uniqueness at null outcomes would be false). |
| `Paper.T03.GruenwaldThm1` | T03Stmt | external parameter X03; specialisation of GHK 2019 Thm 1 with Dirac W₁, requires exactly the two facts verified at l.466. Not goal-shaped (quantified over arbitrary H, p₀). **Shown true as encoded**: I proved it in `pv_work/probes/auditor/T03/auditor_T03_x03sat.lean` (`AuditorT03.x03_holds`, exit 0, axioms `[propext, Classical.choice, Quot.sound]`, log `pv_work/logs/auditor_T03_x03sat_2.log`), so it introduces no false consequence and the theorem is not vacuous because of it. The probe is an auditor check only, not evidence about the cited paper, and does not change T03's dependence on X03. |

None of these constants is or implies the target conclusion other than through X03's stated premises (S3, S4), which T03 proves.

Item 9 helpers (all `private` in `T03.lean`):

| Helper | Content | Judgement |
|---|---|---|
| `expPi_diff` | `E_π{S_θ(p,Y)-S_θ(q,Y)} = (1{θ<p}-1{θ<q})(θ-π)` for θ ∈ [0,1] | technical unfolding (`simp`, `ring`) |
| `expPi_grow` | `E_π E* - 1 = (π-p)(π₁-p)/(p(1-p))` | technical computation (`field_simp`, `ring`) |
| `HAll_self` | `HAll p p = [0,1]` | technical; handles p = q |
| `S34` | case split: p<q ⇒ p<π₁, H=[0,p]; q<p ⇒ π₁<p, H=[p,1]; p=q impossible | combines S1/S2 with h2; elementary |

No new mathematics beyond the "direct computation" of l.466.

## 6. Route fidelity

| Source sentence (l.466) | Lean | Fidelity |
|---|---|---|
| "A direct computation shows that $H=[0,p]$ if $p<q$" | `T03_S1` (via `expPi_diff`, test θ = p) | FAIR_IMPLICIT_STEP: computation not printed; filled by the elementary computation of `E_π` of elementary-score differences |
| "and $H=[p,1]$ if $p>q$" | `T03_S2` (test θ = (max q π + p)/2) | FAIR_IMPLICIT_STEP, same |
| "$\mathbb{E}_\pi E^{\pi_1*} \le 1$ for all $\pi \in H$" | `T03_S3` (via `expPi_grow`, `S34`) | FAIR_IMPLICIT_STEP: the side of π₁ relative to p is derived from π₁ ∉ H, which the source leaves implicit |
| "and $> 1$ for $\pi \notin H$" | `T03_S4` | FAIR_IMPLICIT_STEP, same |
| "The result then follows by Theorem 1 of Gruenwald2019, $W_1$ Dirac at π₁" | `T03_S5` = X03 applied | exact; cited result kept as visible parameter |

Route unchanged; no stronger result used than the source's citation. The case p = q (not discussed by the source) is handled as vacuous: `HAll p p = [0,1]` contradicts `π₁ ∈ [0,1], π₁ ∉ H`; this is a consequence of the printed hypotheses, not an added assumption (EDITORIAL at most, no issue).

## 7. Non-vacuity

Probe `pv_work/probes/auditor/T03/auditor_T03_nonvac.lean` (`RESULT … exit=0 errors=0 sorry_warnings=0`):
- p = 1/2, q = 3/4, π₁ = 9/10: all printed hypotheses hold (π₁ ∉ H = [0,1/2]); `T03_main` instantiates; the parameter-free part `IsEValue E* H {π₁}` holds.
- p = 3/4, q = 1/4, π₁ = 0: π₁ ∉ H = [3/4,1] (other branch, boundary π₁).
- X03 satisfiable (proved, section 5), so the conditional theorem is non-vacuous.

## 8. Status for the authors

Theorem 3.3 is verified along the paper's route, conditional only on the cited Grünwald–de Heide–Koolen 2019 Thm 1 (X03, used in the last sentence of the proof, l.466).
The "direct computation" (H = [0,p] / [p,1], the bounds ≤ 1 on H and > 1 off H) checks out; these are fair implicit steps.
No errors, gaps or ambiguities found. The case p = q is vacuous and does not need separate treatment.

## FAIL items

None.

## Records to update

- Register X03 (`Paper.T03.GruenwaldThm1`, `pv_work/T03Stmt.lean:42`, provenance (i), l.188/l.466, used by T03 step S5) in the `RESULTS.json` external_tools registry. Human check point (from T03_gate): confirm that GHK 2019 Thm 1 covers (a) GROW identification of the likelihood ratio, (b) a.s. uniqueness. Note: the auditor probe shows that X03 as encoded is provable in Lean.
- Infrastructure PASS records (this audit) for: `Paper.expPi`, `Paper.elemScore`, `Paper.HAll`, `Paper.IsEValue`, `Paper.EGrowAll`, `Paper.T03.LogFinite`, `Paper.T03.IsGrowEValue`, `Paper.T03.GrowIs`, `Paper.T03.GruenwaldThm1`.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: X03

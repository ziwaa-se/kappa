# P02 final audit (Proposition 3.2, prop:inf-mean), gap file

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), final-audit mode. Date: Mon Oct 12 22:44:19 EDT 2026.
- Audited object: `pv_work/P02ModGaps.lean` (sha256 `992fb2c2…ae315`), `.olean` `e570e6de…3c6263` (privately rebuilt: IDENTICAL). Stopped-obligation file `pv_work/P02.lean` (`f4d691dc…01cf`).
- Source read directly: `source/SuperParetoPaper-v12.tex:260-273` (statement :261-264, proof :265-267, use in Prop 3.3 :269-273).
- Inputs read: gate `verification/audits/P02_gate_r2.md`, `pv_work/P02Stmt.lean`, prover notes `pv_work/notes/P02_prover_notes.md`, issue rulings `P02_issue_1_r2.md` (DOMAIN_CLARIFICATION, review CONFIRMED) and `P02_issue_2.md` (PAPER_ARGUMENT_GAP, review CONFIRMED).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P02 --module P02ModGaps`)

Report `verification/audits/P02_mech.md`: **MECH CHECKS: PASS** (1 manual check, done in §2).

| Item | Result |
|---|---|
| compile `P02ModGaps` | exit 0, 0 errors, 0 sorry |
| private rebuild sha256 | IDENTICAL |
| PVTools hash | PASS |
| fingerprints of 11 gated declarations vs gate r2 | all identical (S2, S3, S4a, S4b, S5, S6 and Stmt defs) |
| `P02_S1_Gap` vh = snapshot th of `P02_S1` | PASS (320467813) |
| `#pv_axioms` / `#pv_walk` | ALL STANDARD (propext, Classical.choice, Quot.sound); sorryAx not reached |
| TRACED CONDITIONS | none |

## 2. Gap file exact-statement checks (§2b, done by me)

Probe `pv_work/probes/auditor/P02/auditor_P02_exact.lean` (`RESULT … exit=0 errors=0 sorry_warnings=2` = the two verbatim copies; log `pv_work/logs/auditor_P02_exact_1.log`):

| Check | Result |
|---|---|
| verbatim `Paper.P02.P02_S1` redeclared: th | 320467813 = snapshot |
| verbatim `Paper.P02.P02_main` redeclared: th | 1724241671 = snapshot |
| `example : P02_S1_Gap = type_of% @P02_S1 := rfl` | compiles |
| `example : P02_TwoCase_Gap = TwoCase := rfl` | compiles (gap is exactly the gated `TwoCase`, no weakening) |
| `example (g1) (g2) : type_of% @P02_main := P02_main_mod_gaps g1 g2` | compiles |
| `P02.lean` vs `P02ModGaps.lean` (`diff`) | differ only in `P02_main`/`P02_S1` (sorry) vs `P02_S1_Gap`/`P02_TwoCase_Gap`/`P02_main_mod_gaps`; S2–S6 and helper identical |
| Gap-dependent obligations | none among S2–S6 (each is proved without any gap premise); only `P02_main_mod_gaps` depends on the gaps |

The second gap `P02_TwoCase_Gap` is not a numbered obligation: it stands for the passage from S6 (proved with `X, X₁, X₂ ≥ 0`) to the gated `TwoCase` (no nonnegativity). That passage is exactly issue 2.

## 3. Hypothesis usage (item 10)

No external parameters exist. UNUSED hypotheses (all ordinary premises, none an external tool):
- `P02_S2`: `hX hX₁ hX₂`, probability-measure instance; harmless.
- `P02_S4a`: probability-measure instance; harmless.
- `P02_S4b`: `hdom`; kept as proof context by the gate's choice; harmless.
- `P02_S6`: `hind` (independence of X₁, X₂). Faithful: the source n=2 argument at :266 never uses independence (only identical distribution and P(X₁≠X₂)>0). Remark for the report: the n=2 case proved here holds without independence.

## 4. Infrastructure (item 8, item 9)

| Constant | Record | Judgement |
|---|---|---|
| `Paper.P02.StDom`, `InfiniteMean`, `TwoCase` (P02Stmt) | `P02_gate_r2.md` (gate reviewed each definition) | covered |
| `sqrt_integrable_aux` (private, item 9) | audited here | true (`√z ≤ z+1` for z ≥ 0, then `Integrable.mono'`); technical conversion for the silent integrability of √ in :266; no new mathematics; no target smuggling; axioms standard (module-wide `#pv_axioms`) |

## 5. Route fidelity (source :266, sentence by sentence)

| Source sentence | Lean | Fidelity |
|---|---|---|
| "It is enough to prove the case n=2." | S1: STOPPED → `P02_S1_Gap` | issue 1 (DOMAIN_CLARIFICATION, confirmed). Not filled in. |
| "Denote Y = θX₁+(1−θ)X₂ … P(X₁≠X₂)>0." | setup of S6 (`hne : μ{X₁=X₂}<1` converted to `0<μ{X₁≠X₂}`) | notation conversion |
| "assume E(X) finite … E(Y)=E(X), both finite" | S2: linearity + `IdentDistrib.integral_eq` | faithful |
| "this, together with (eq:main-st), implies that X and Y have the same distribution" | S3: integrated survival difference ∫(F̄_Y−F̄_X)=E Y−E X=0 with F̄_X ≤ F̄_Y ⇒ a.e. equal ⇒ everywhere by right continuity ⇒ equal law | FAIR_IMPLICIT_STEP (standard fact "≤st + equal finite means ⇒ equal law", filled in by the standard Fubini argument) |
| "Therefore Var(√X)=Var(√Y)" | S4a: `IdentDistrib.comp` + `variance_eq` | faithful |
| "implying E(√X)=E(√Y)" | S4b: Var√Z = E Z − (E√Z)², with E X = E Y (S2) and E√· ≥ 0 | FAIR_IMPLICIT_STEP (as ruled by the gate); source route kept, though equal laws give it directly |
| "Jensen … E√Y > θE√X+(1−θ)E√X = E√X, strict because P(X₁≠X₂)>0" | S5: pointwise strict concavity of √ on [0,∞) (`Real.strictConcaveOn_sqrt`), integrated; strict via `integral_pos_iff_support_of_nonneg_ae` | faithful (two-point Jensen integrated = the Jensen step for this convex combination) |
| "But this is not possible" | S6: S4b equality contradicts S5 strict inequality | faithful |
| silent: X ≥ 0 (√ used) | S4b, S5, S6 carry `hnn` premises; `TwoCase` (no nonnegativity) not derived → `P02_TwoCase_Gap` | issue 2 (PAPER_ARGUMENT_GAP, confirmed). Not filled in. |

No route change, no stronger result used, no gap filled by a new argument.

## 6. Non-vacuity

Probe `pv_work/probes/auditor/P02/auditor_P02_nonvac.lean` (`RESULT auditor_P02_nonvac mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/auditor_P02_nonvac_2.log`):
- **S5, nontrivial witness:** Ω = Bool×Bool with two independent fair coins, X₁ = f∘fst, X₂ = f∘snd, f(true)=1, f(false)=0, θ=1/2; all premises proved (identical distribution, integrability, μ{X₁≠X₂} ≥ 1/4 > 0); `P02_S5` instantiated.
- S2 at the same witness; S3, S4a, S4b at Y = X (admissible).
- **S6 not witnessed in Lean.** Any instance satisfying its premises has non-integrable X (that is the theorem), so a witness needs an infinite-mean law with the n=2 dominance (e.g. Pareto(1), source :279 together with Thm 3.1). Not constructed; recorded as an open check, not a failure of the verified content.

## 7. What is verified apart from the gaps

- **Verified (no conditions):** Prop 3.2 in the case n = 2 for **nonnegative** X, X₁, X₂ (`P02_S6`): if X₁, X₂ have the law of X, P(X₁=X₂)<1, 0<θ<1 and X ≤st θX₁+(1−θ)X₂, then X is not integrable. Independence is not needed. Each step S2, S3, S4a, S4b, S5 is verified as stated.
- **Not verified:** (a) general n (S1, issue 1, depends on the reading of "(eq:main-st) holds"); (b) real-valued (signed) X even for n = 2 (issue 2: √ is not defined/concave on ℝ). `P02_main` holds only modulo `P02_S1_Gap` and `P02_TwoCase_Gap`.

## 8. Status for the authors

Verified: the n=2 argument of :266 for nonnegative X (independence unused), all steps, standard axioms only, no external inputs.
Not verified: the reduction "enough to prove n=2" (DOMAIN_CLARIFICATION: meaning of "(eq:main-st) holds") and the case of signed X (PAPER_ARGUMENT_GAP: √ needs X ≥ 0, not printed).
Source assessment: argument sound for nonnegative X with n=2; two confirmed paper-side issues; "infinite mean" for signed X is ambiguous (see issue 2).

## 9. Checks not completed

- S6 non-vacuity witness in Lean (see §6).

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none

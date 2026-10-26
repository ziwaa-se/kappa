# P04 final audit (Proposition 3.4 `prop:combination`, source/VSIFP_02.tex:222-227; proof l.469-471; h=1 sketch l.205-220)

- Auditor: pv-auditor (independent; not drafter, gate, prover or issue-checker). Date: Tue Oct 13 01:38:17 EDT 2026 (`date`).
- Audited object: `pv_work/P04.lean` (no gap file; no obligation stopped).
- Read myself: source l.90-125 (conventions, l.106 mixing claim, l.111 lag h ≥ 1, l.116-122 `H_{S;c}`), l.200-240, l.440-479; `pv_work/P04.lean` (full), `P04Stmt.lean`, `Defs.lean`, `T01Stmt.lean`; gate r2 report; prover notes; `P04_issue_1.md`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py P04`)

Report `verification/audits/P04_mech.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `P04` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (627f9fbc…) |
| 3 | PVTools hash | PASS |
| 4 | 43 gated fingerprints vs `P04_gate_r2.md` | PASS, all identical |
| 5 | `Defs` vs `DEFS_gate_r2.md` | PASS |
| 6 | `#pv_axioms P04` | ALL STANDARD |
| 7 | `#pv_walk P04` | no `sorryAx`; axioms propext, Classical.choice, Quot.sound |
| 12 | last writers | P04.lean pv-prover; P04Stmt.lean pv-drafter |

No gap file, so §2b gap checks do not apply.

## 2. Conditionality (`#pv_hyp_usage`, log `pv_work/logs/auditor_P04_mech2_1.log`)

| Parameter | Status in gated theorems | Where actually used (read in the proof term) |
|---|---|---|
| `hT01 : P04_T01Consumed S` | USED in S1, S5, S6, S7, S8, main | applied directly in `P04_S1` (factor ≥ 0, l.403) and in `pt_bound` (`E_π E ≤ 1` for `π ∈ H_S`, l.213), reached by S5/S6 via `core6`, S7, S8, main |
| `hMix : P04_MixingOfStrict S` | USED in the same theorems | applied directly in `P04_S1` and `pt_bound` to get `ν[min p q, max p q) > 0`, the premise of the T01 clause (X02, l.106 "only if") |

`TRACED CONDITIONS: none` in mech item 11 only because neither parameter is registered in `EXTERNAL_TOOLS.md` (X02 is still a "candidate" row, and the (p) clause has no row). Corrected by step 4: both are real conditions.

UNUSED premises (not external parameters; printed hypotheses, report only): `hT : h+1 ≤ T` in `P04_S3` and `P04_S8` (the claims hold for every `T`), and `hh : 1 ≤ h` in `P04_S7`. `hh` and `hT` are printed at l.111/l.223. They are used in `P04_main` through S3/S8 binder passing. No change requested.

Scope restriction (formalization side, TFA-1, gate-approved): the e-value clause is proved for `Q ∈ HScInt`, i.e. `Q ∈ ℋ_{S;c}` **with** integrable score differences `S(p_t,Y_{t+h}) − S(q_t,Y_{t+h})` (used in S4). For scores unbounded at 0/1 (e.g. log score), measures in `ℋ_{S;c}` without this integrability are not covered. This must be stated with the verdict ("integrability premise"); it is not a paper issue.

## 3. Infrastructure (item 8, 9)

| Constant(s) | Kind | Record | Judgement |
|---|---|---|---|
| `Paper.Erep, HS, IsConsistent, IsEValue, IsMixingMeasure, IsStrictlyConsistent, elemScore, expPi, mixtureScore` | definitions | `DEFS_gate_r2.md` (fingerprints identical) | covered; no theorems |
| `Paper.P04.*` (21: `SeqSetting` + projections, `Ik`, `eT`, `HSc`, `HScInt`, `IsEValueUnder`, `P04Conclusion`, the two parameters) | definitions / structure projections | `P04_gate_r2.md` (identical) | covered; projections are auto-generated |
| `Paper.T01.MixtureRep` | definition | `T01_gate.md` | covered |

No in-project **theorem** from another module is in the closure (P04 imports only `P04Stmt` → `T01Stmt` → `Defs`). Helpers not in the snapshot, audited one by one:

| Helper | Statement true? | Role | Judgement |
|---|---|---|---|
| `S0_mono`, `S1_anti` | yes (consistency inequalities at (p,q),(q,p), algebra) | measurability of `S(·,y)` | technical, FAIR_IMPLICIT_STEP for "F_T-measurable" |
| `clamp_mem/mono/eq` | trivial | measurability via monotone composition | technical |
| `meas_S0/S1/SZ/Sb/Erep`, `prod_meas` | yes | measurability of factors and products | technical |
| `lint_condExp` | yes (`∫G·Z = ∫G·E(Z|F_t)` for `F_t`-measurable `G ≥ 0`; trim/withDensity) | lintegral pull-out, l.209 | standard property, X07 |
| `pt_bound` | yes | pointwise l.213: `λ=0` or `p=q` gives factor 1, else T01 clause at `π ∈ H_S` | carries the source step; no new mathematics |
| `core6` | yes | body of S6 (S5 is its indicator case) | technical |

None states the target conclusion or a stronger result; all have standard axioms (closure walk of P04).

## 4. Route fidelity

| Source | Lean | Assessment |
|---|---|---|
| l.223 "`e_T` are F_T-measurable" (no justification) | S2, S3 (factor at `l` is `F_{l+h}`-measurable, `l+h ≤ T` for `l ∈ I_k`) | FAIR_IMPLICIT_STEP; needs measurability of `S(·,y)`, filled in from consistency (monotone in p) |
| l.211-215 one-step bound `E_Q{E_T(Y_{T+1})|F_T} ≤ 1`, case `c_t=0` ⇒ `λ_t=0`, factor ≡ 1 | S4 (identify `π_t = E(Y_{t+h}|F_t)` ∈ `H_S` a.s. when `c_t=1`), S5, `pt_bound` | FAIR_IMPLICIT_STEP (identification via affine-in-y form and pull-out, not written in the source) |
| l.208-209 tower + pull out earlier factors | S6 / `core6` / `lint_condExp` in lintegral form (factors nonnegative by T01 l.403) | faithful; lintegral form is a type conversion avoiding integrability of the product |
| l.217-220 "iterating", l.470 "sequential conditioning on `F_{k+hl}`, l=1..⌊(T-k)/h⌋, for each of the h products" | S7: induction on the number of factors, last factor conditioned on its forecast time `F_{k+hs}` (s = n−1,…,0) | **DEVIATION recorded**: the Lean conditions on `F_{k+hs}`, `s = 0..n−1` (i.e. `F_l`, `l ∈ I_k`), not the printed `F_{k+hl}`, `l = 1..n`. The printed list is shifted up by h: conditioning on `F_{k+hn}` removes nothing (whole product measurable) and `F_k` is missing. The corrected list is exactly what "as in the case h=1" (l.208: factor index T conditioned on F_T) prescribes, so the route is the source's route with the index slip corrected. Agrees with `P04_issue_1.md` (EDITORIAL slip / FAIR_IMPLICIT_STEP; I concur on reading l.206-220, 470 myself). Not a route change and no stronger tool. |
| l.220 "average the products" | S8: linearity of lintegral, `(1/h)·h·1 = 1`, `I_k` = image of `range n` | FAIR_IMPLICIT_STEP (average of e-values is an e-value) |
| T01 "if" clause l.403, l.106 mixing positivity | parameters `hT01`, `hMix` | visible parameters (p) and (ii)/(iii); not proved here |

`p_t = q_t` (allowed by l.223 `(0,1)^2`, but l.147/T01 need `p ≠ q`): Lean `Erep = 1` there (numerator 0). Candidate DOMAIN_CLARIFICATION, flagged by the issue-checker as a separate "issue 2" candidate; not yet ruled. Under the "no bet" reading (E ≡ 1, as l.211 for λ = 0) the result holds; under the "undefined" reading `e_T` is undefined on `{p_l = q_l}`. No reading makes the conclusion false.

## 5. Non-vacuity (`pv_work/probes/auditor/P04/auditor_P04_nonvac.lean`, log `pv_work/logs/auditor_P04_nonvac_2.log`, EXIT=0, `nonvac` and `Q_mem` axioms propext, Classical.choice, Quot.sound)

Every hypothesis of `P04_main` instantiated, including both parameters:
- `ν = Lebesgue|(0,1)`, `S = mixtureScore ν` (= Brier/2 on [0,1]); `MixtureRep S ν` and `IsStrictlyConsistent S` proved;
- `hT01` discharged from the gap-free `Paper.T01.T01_S2`; `hMix` proved for this S (any mixing measure ν' of S charges every `[a,b) ⊂ (0,1)`);
- data on `Ω = Unit`: `Y ≡ 0, c ≡ 1, p ≡ 1/4, q ≡ 3/4, λ ≡ 1/2` (λ > 0, genuine c = 1 constraint), `h = 1`, `T = 2`;
- `Q = dirac ()` ∈ `HScInt` (null set non-empty), and the e-value bound is applied to it.

## 6. Status for the authors

Verified: Prop. 3.4 (both clauses, all `T ≥ h+1`) along the source route, assuming T01's "if" clause (l.403) and the l.106 mixing positivity, for Q with integrable score differences.
Source: l.470 σ-field indices shifted by h (editorial; corrected `F_l, l ∈ I_k` used); `p_t = q_t` case of `E_{p,q;λ}` undefined (candidate domain clarification); several routine steps (S2-S4, S8) unwritten.

## 7. Records

- Register `P04_MixingOfStrict` (X02, (ii)/(iii), l.106) and `P04_T01Consumed` ((p) of T01, l.144-149/l.403) in `EXTERNAL_TOOLS.md`; the mech trace then picks them up.
- Record the S7 index deviation and TFA-1 integrability scope with the verdict; route issue 2 (`p = q`) to the issue checker; P04 issue 1 needs the reasoning review (this audit agrees with its classification but is not that review).
- `P04_T01Consumed` can be reconnected via `T01_S2` (compiles in my probe); T01 itself is not yet verified.

FAIL items: none.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL   (ISSUE instead only if the p_t = q_t DOMAIN_CLARIFICATION is opened and confirmed; issue 1 is FAIR_IMPLICIT_STEP/EDITORIAL and does not change it; integrability premise TFA-1 stated with the verdict)
CONDITIONS: P04_T01Consumed, P04_MixingOfStrict

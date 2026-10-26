# P04 issue 1: ruling (pv-issue-checker)

Result: Proposition `prop:combination` (P04), source/VSIFP_02.tex:222-227, proof l.469-471.
Suspected issue: the σ-field list at l.470 is shifted by `h`. The question also covers the status of the unwritten steps behind "as in the case h=1" (l.469) and the case `p_t = q_t` (l.223 with l.147).
Reported by pv-drafter (P04_draft_notes.md:48-50), pv-gate (P04_gate.md:83-86) and pv-prover (P04_prover_notes.md:33-36).

## 1. Source text (read directly)

- l.223-226 (statement): "`I_k = {k + hs : s = 0, …, ⌊(T-k)/h⌋ - 1}`, `e_T = (1/h) Σ_{k=1}^h ∏_{l∈I_k} E_{p_l,q_l;λ_l}(Y_{l+h})` are `F_T`-measurable and are e-values under `H_{S;c}`."
- l.469-470 (proof, in full): "Follows as in the case `h = 1` with sequential conditioning on `F_{k+hl}`, `l = 1, …, ⌊(T-k)/h⌋`, for each of the `h` products `∏_{l∈I_k} E_{p_l,q_l;λ_l}(Y_{l+h})`."
- l.206-220 (the h=1 case being invoked): `E_Q{∏_{t=1}^T E_t(Y_{t+1})} = E_Q[∏_{t=1}^{T-1} E_t(Y_{t+1}) · E_Q{E_T(Y_{T+1}) | F_T}]`. Then l.213: `E_Q{E_T(Y_{T+1})|F_T} = (1-c_T) + c_T E_Q{…|F_T} ≤ 1`, and l.220: "Iterating this argument …". The last factor is conditioned on its **forecast time** `T`.
- l.147: `E_{p,q;λ}(y) = 1 + λ (S(p,y) - S(q,y)) / |S(p,1{p>q}) - S(q,1{p>q})|`. Theorem 3.1 (l.145) assumes `p ≠ q`. l.211 sets `E_{p,q;0} ≡ 1`.

## 2. What is consumed

Fix `k ∈ {1..h}` and `n = ⌊(T-k)/h⌋`. The product for `k` has the factors `F_s := E_{p_{k+hs},q_{k+hs};λ_{k+hs}}(Y_{k+h(s+1)})`, `s = 0..n-1`. Factor `F_s` is `F_{k+h(s+1)}`-measurable, and its one-step bound `E_Q(F_s | F_{k+hs}) ≤ 1` (l.213 with `t = k+hs`) holds at its forecast time `k+hs`.
The h=1 route therefore needs the σ-fields `F_{k+hs}` for `s = n-1, n-2, …, 0`, i.e. `F_l` for `l ∈ I_k`.
As printed, the list is `F_{k+hl}` for `l = 1..n`. This is the needed list shifted up by one step `h`:
- top element `F_{k+hn}`: the whole product is `F_{k+hn}`-measurable, so conditioning on it returns the product unchanged and removes no factor. This is proved in Lean (§5).
- `F_k` is missing, and it is the σ-field needed to bound the last remaining factor `F_0 = E_k(Y_{k+h})`.
- the middle elements `F_{k+h}, …, F_{k+h(n-1)}` are the needed ones for `s = 1..n-1`.

So a literal application of the printed list does not give the bound. The h=1 route invoked in the same sentence does give it ("as in the case h = 1": condition the last factor on its forecast time, as at l.208-209).
Probable origin of the slip (reasoning): in the h=1 display, l.208 runs the product up to `t = T` with `Y_{T+1}` and conditions first on `F_T`. P04's `I_k` stops one step earlier (`k+h(n-1)`, so that `e_T` is `F_T`-measurable). The printed range `l = 1..n` reproduces the top index of the l.208 display rather than of `I_k`.

## 3. Classification

**Index shift at l.470: an EDITORIAL index slip. As a step it is FAIR_IMPLICIT_STEP (no paper issue).**

- Not `ERROR`: the conclusion is true. P04_S7/S8/main are proved in Lean along the h=1 route (§5).
- Not `PAPER_ARGUMENT_GAP`: the method the proof names (sequential conditioning "as in the case h = 1") works unchanged. Only the printed index range is off by one. Any reader who repeats l.208-213 conditions each factor on its forecast time `l ∈ I_k`. No idea beyond the cited h=1 argument is needed. The same sentence also names the products to be peeled, `∏_{l∈I_k}`, whose index set is the correct list.
- Not `EXPOSITION_GAP`: no range or case of the statement is left uncovered. Every `T ≥ h+1` and every `k` is handled by the same route.
- Not `ENCODING_ERROR`: the shift is in the source text itself, not in our encoding. `P04Stmt.lean` encodes `I_k` and `e_T` as printed.

**Unwritten steps behind "as in the case h = 1" (l.469): FAIR_IMPLICIT_STEP.** They are routine for a reader of l.205-220:
1. Identifying `E_Q{E_t(Y_{t+h}) | F_t} = 1 + λ_t(d_t(0) + π_t(d_t(1) - d_t(0)))/|…|` with `π_t = Q(Y_{t+h}=1|F_t)`, and `π_t ∈ H_S` a.s. when `c_t = 1` (l.213). `E` is affine in the binary `y`, and `p_t, q_t, λ_t` are `F_t`-measurable (pull-out). Lean: P04_S4, S5, `pt_bound`.
2. Pulling out possibly unbounded nonnegative factors (l.209). This is done in `lintegral` form with nonnegativity from T01 (`E ≥ 1-λ ≥ 0`, l.403). Lean: P04_S6, `lint_condExp`.
3. Averaging over `k` (l.220 and l.78: an average of e-values is an e-value). Lean: P04_S8.
4. Measurability of `S(·,y)` for "F_T-measurable" (monotone in `p` for a consistent `S`). Lean: P04_S2, S3.

The integrability of the score difference in the definition of `H_{S;c}` is a formalization-side premise (TFA-1, `HScInt`). It is not a paper issue under this ruling.

**`p_t = q_t` (l.223 allows it; l.147 is then `1 + λ·0/0`; T01 assumes `p ≠ q`): DOMAIN_CLARIFICATION, not threatening.** This is a separate point from the index shift. I recommend recording it as its own issue (P04 issue 2) rather than folding it into this verdict.
- Reading A: `E_{p,p;λ}` is undefined, so `e_T` is undefined on `{p_l = q_l}` and the statement is meaningless there.
- Reading B: "no bet", `E_{p,p;λ} ≡ 1`. This is the convention of l.211 for `λ = 0`, and Lean's `Erep` gives it since the numerator is 0. The proposition holds (P04_main).
- Reading C: put `λ_t := 0` whenever `p_t = q_t` (adapted). Same as B.

No natural reading assigns a factor with conditional mean > 1, so the conclusion is not threatened. Minimal fix: add "with `E_{p,q;λ} :≡ 1` if `p = q`" at l.211 or l.223.

## 4. Does it threaten the conclusion?

- P04 conclusion (l.226): **no**. Under the corrected index list (the only reading under which the cited h=1 route applies), every step is proved in Lean: P04_S7 (sequential conditioning), P04_S8 (e-value), P04_main. These are conditional on the external parameters `P04_T01Consumed` and `P04_MixingOfStrict` and on premise TFA-1. Those dependencies are unrelated to this issue.
- Downstream: not affected.
  - P05 / `prop:stopping` (l.235-240, proof l.473-477) uses only `E(e_t|F_t) ≤ 1` and the assumptions of P04.
  - Appendix `app:stopping` (l.480 ff.) uses `I_k(T)` as printed at l.223, not the l.470 list.
  - T01-T03 do not depend on P04.

## 5. Evidence

- Obstruction for the literal top step, Lean: `pv_work/probes/issue/P04/issue_P04_shift.lean`.
  - `full_prod_meas` proves that the product of the `n` factors started at `k` is `F_{k+hn}`-measurable.
  - `literal_top_step_trivial` proves that `Q[∏ | F_{k+hn}] = ∏` (given integrability, i.e. whenever the conditional expectation is the genuine one).
  - Compile: `scripts/pv_lean.sh probe pv_work/probes/issue/P04/issue_P04_shift.lean` gave `RESULT issue_P04_shift mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `pv_work/logs/issue_P04_shift_2.log`).
  - `#pv_walk_decl`: axioms in closure `[propext, Classical.choice, Quot.sound]`, sorryAx reached: false.
  - The same run gives `#pv_axioms P04: ALL STANDARD (11 declarations checked)`.
- Missing `F_k` in the printed list: reasoning, not checked in Lean. After peeling factors `s = n-1..1`, the remaining `E_Q F_0` needs conditioning on `F_k`, which the printed list does not contain.
- Positive evidence that the corrected reading works: `Paper.P04.P04_S7` (`pv_work/P04.lean:455`) is proved by induction, conditioning the last factor on `F_{k+h·n}` for the `(n+1)`-factor product, i.e. on its forecast time. `P04_main` axioms are standard (log above, line 44).
- No counterexample exists (the conclusion holds), so `pv_work/P04_Counterexample1.lean` is not written.

## 6. Suggestion to the authors (minimal)

At l.470, replace "`F_{k+hl}`, `l = 1, …, ⌊(T-k)/h⌋`" with "`F_{k+hl}`, `l = ⌊(T-k)/h⌋ - 1, …, 0` (i.e. `F_l`, `l ∈ I_k`, in decreasing order)".
Check: this is exactly the route of P04_S7, which compiles.
Separately (issue 2 candidate): state `E_{p,q;λ} :≡ 1` when `p = q`.

## 7. Not checked

- I did not re-run the build of `pv_work/P04.lean`. I relied on the prover's `exit=0` (P04_prover_notes.md:3) and the `#pv_axioms P04` output in my own probe run, which loaded the existing `.olean`.
- The issue at l.93 (additive terms in the mixture representation; gate item 3) is outside this ruling.
- This ruling is not confirmed until pv-auditor's independent review passes. A reasoning review is needed, since the Lean probe only covers the obstruction.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no

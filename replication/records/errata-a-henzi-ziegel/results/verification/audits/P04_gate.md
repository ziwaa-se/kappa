# P04 statement gate, revision 1 (Proposition 3.4, `prop:combination`)

- Reviewer: pv-gate (independent subagent; not the drafter)
- Date: Tue Oct 13 02:25:31 EDT 2026 (`date`)
- Source read directly: `source/VSIFP_02.tex` l.80-239 (scores and mixture l.88-103, sequential setting and H_{S;c} l.106-123, one-period H_S and kappa l.130-139, T01 l.143-148, h=1 sketch l.198-214, P04 statement l.216-221, remarks l.223-227, P05 l.229-234) and l.395-469 (T01 proof l.399-416, P04 proof l.446-469).
- Comparison only: `verification/audits/rev1/P04_gate.md` (revision-0 gate; its line numbers refer to the earlier manuscript).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):

| file | sha256 |
|---|---|
| pv_work/P04Stmt.lean | c7d955ff68f9a3add691f71b5ed2e62de995bfec4a387b52a27c27a1da08f414 |
| pv_work/P04Draft.lean | 3ac6bba2bc3e0460724eea1a13279f4976fa482056da5dd5fafa554f998d7192 |
| pv_work/notes/P04_draft_notes.md (leads only) | 5f3a5a7c1c7b5c1a2f82eeb2c042a2dafae1a1de39862bc10b489ea8e885d237 |
| pv_work/Defs.lean (imported) | 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c |
| pv_work/T01Stmt.lean (imported) | 011685b5b1e5a9f9d221fb49cf0478b632e812be2257bd23085e5357d6b1c8f2 |
| pv_work/P05Stmt.lean (imports P04Stmt) | b267a3edb81e86f520fffc6f02ef4be5448b2f8cccf1cc1d45a49be2507287f0 |

- Compilation: `scripts/pv_lean.sh check P04Draft` -> `RESULT P04Draft mode=check exit=0 errors=0 sorry_warnings=17 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_6.log`.
- Gate probes (`pv_work/probes/gate/P04/`; new names `*_v2_*` so the revision-0 probes are kept):
  - `gate_P04_v2_stmtcopy.lean` EXIT=0, 0 sorry (log `pv_work/logs/gate_P04_v2_stmtcopy_1.log`)
  - `gate_P04_v2_draftcopy.lean` EXIT=0, 17 sorry (log `pv_work/logs/gate_P04_v2_draftcopy_1.log`)
  - `gate_P04_s13cex.lean` EXIT=0, 0 sorry (log `pv_work/logs/gate_P04_s13cex_1.log`). It proves `¬ (statement of P04_S13)` (Ω = Bool, ℱ n = ⊤, τ = 0 on `true` and 1 on `false`, h = k = 2, t = 0). It also checks `(-1 : ℤ) / 2 = -1` (floor division used by `filtK`/`fk`). `#pv_walk_decl`: axioms [propext, Classical.choice, Quot.sound], sorryAx reached: false.

## Source quotations

- Statement, `VSIFP_02.tex:216-221`: "Let $(Y_t, c_t, p_t, q_t, \lambda_t) \in \{0,1\}^2\times(0,1)^2\times[0,1]$ be defined on a measurable space $(\Omega,\mathcal F)$ and adapted to the filtration $\mathcal F_t$, $t\in\mathbb N$, and assume $\lambda_t = 0$ if $c_t = 0$. Let further $\myS$ be a strictly consistent scoring function. Then for all $T\ge h+1$, with $I_k=\{k+hs: s=0,\dots,\lfloor (T-k)/h\rfloor-1\}$, $e_T=\frac1h\sum_{k=1}^h\prod_{l\in I_k}E_{p_l,q_l;\lambda_l}(Y_{l+h})$ are $\mathcal F_T$-measurable and are e-values under $\mathcal H_{\myS;c}$."
- h=1 sketch, `:200-214`: tower property at $\mathcal F_T$ and pull-out (l.202-203); "$E_{p_t,q_t;0}\equiv1$ if $c_t=0$ … $\mathbb E_{\mathbb Q}\{E_{p_T,q_T;\lambda_T}(Y_{T+1})\mid\mathcal F_T\} = (1-c_T)+c_T\,\mathbb E_{\mathbb Q}\{\cdots\mid\mathcal F_T\}\le1$ almost surely for $\mathbb Q\in\mathcal H_{\myS;c}$" (l.205-209); iteration, "non-negative supermartingale" (l.214).
- Proof, `:446-469`: "Let $h>1$. … $M^{[k]}_t=\prod_{l\in I_k(t)}E_{p_l,q_l;\lambda_l}(Y_{l+h})$, $\mathfrak F^{[k]}=(\mathcal F_{\lfloor (t-k)/h\rfloor h+k})_t$ … $\mathcal F_j:=\{\Omega,\emptyset\}$ for $j\le0$. Then $e_t=\sum_k M^{[k]}_t/h$. For $k=1,\dots,h$, the process $(M^{[k]}_t)$ is a nonnegative supermartingale with respect to $\mathfrak F^{[k]}$ for any $\mathbb Q\in\mathcal H_{\myS}$, and therefore satisfies $\mathbb E_{\mathbb Q}(M^{[k]}_{\tau[k]})\le1$ for any $\mathfrak F^{[k]}$-stopping time" (l.452), then $f_k(\tau)$ (l.456-463) and $M_{\tau+h-1}$ (l.464-468).
- $\mathcal H_{\myS;c}$, `:113-119`; lag $h\ge1$, `:108`; e-value, `:141` (and l.78); mixture, `:90-102`; l.103: "The scoring function $\myS$ is strictly consistent if and only if $\nu$ assigns positive mass to all non-degenerate intervals in $(0,1)$."
- $H_{\myS}$ interval remark, `:135-138` (one-period; $\kappa_\nu$ needs $\nu\{[a,b)\}>0$).
- T01, `:143-148`, and its proof `:400`: "If $E(y)$ is of the stated form, then $E(y)\ge E\{\one(p>q)\}=1-\lambda\ge0$, and one can easily verify that $E$ has the given null hypothesis."

## Item 1. Hypotheses: FAIL (amendments R1-R3)

- `SeqSetting` encodes all of l.217 (ranges, adaptedness, `λ_t = 0` if `c_t = 0`); `c_t` is ℱ_t-measurable as in l.119. `hh : 1 ≤ h` is l.108. `IsStrictlyConsistent S` is D02. `ν`, `hrep : T01.MixtureRep S ν` is TFA-2 (approved earlier; l.90-94 convention, T01 l.144). No hidden hypotheses: only `variable {Ω} {m0}`; the structures contain exactly the listed fields.
- Index `t = 0` (Lean ℕ includes 0, the source's ℕ starts at 1): harmless for the main theorem, as in revision 0 (a source instance embeds with `c_0 = λ_0 = 0`). It does matter for the stopping-time obligation S13 (item 5, R4).
- **Defect (R1-R3)**: hypothesis `hT01 : P04_T01Consumed S ν h ℱ Y c p q lam` puts into a hypothesis a step of the paper's own argument for this result (the one-step bound of l.205-209). The source derives that step, and this project can prove it (see item 6). It is also wrongly labelled as a clause of T01.

## Item 2. Conclusion: PASS

`P04Conclusion` = `Measurable[ℱ T] (eT …)` ∧ `IsEValueUnder (eT …) (HScInt …)`, which is l.220 ("$\mathcal F_T$-measurable and e-values under $\mathcal H_{\myS;c}$"). `IsEValueUnder` is `e ≥ 0` everywhere plus `∫⁻ ofReal e ≤ 1`, so the lintegral is the true expectation (no `ofReal`/`toReal` truncation trap). `Ik`, `eT` match l.217-218 (ℕ division = floor; `T - k ≥ 1` since `k ≤ h < T`). `P04_main` quantifies over all `T ≥ h+1`. No alternative is claimed, and the source states none. The conclusion is not strengthened; the only narrowing is the class `HScInt` (TFA-1). P05Stmt consumes exactly `P04Conclusion` (unchanged hashes of its components, see snapshot).

## Item 3. Quantifiers and constants: PASS

The order is `S, ν, h, ℱ, Y, c, p, q, λ`, then `∀ T ≥ h+1`, then `∀ Q ∈ HScInt` inside `IsEValueUnder`. This matches l.216-220. There are no constants.

## Item 4. Domains and details: PASS

- `HSc` is a.s. (`∀ᵐ ∂Q`) as at l.115, and `IsProbabilityMeasure` as in 𝒫 (l.112).
- **TFA-1 `HScInt`** (integrability of `S(p_t,Y_{t+h}) − S(q_t,Y_{t+h})` under Q, all t): APPROVED again. It is the standard L¹ meaning of the conditional expectation at l.115. It avoids the junk `condExp = 0` that would make the hypothesis vacuous and the claim false. It only narrows the class of Q and is not goal-shaped.
- `p_t = q_t`: allowed by l.217, but `E_{p,q;λ}` (l.146) is 0/0 there. Lean's `Erep = 1` is the same "no bet" convention as `λ = 0` (l.205). This is acceptable and is the DOMAIN_CLARIFICATION recorded in revision 0.
- **ν positivity**: needed only to apply T01 pointwise (`ν{[min,max)} > 0`). It is supplied by `P04_MixingOfStrict` (l.103, "only if"). The parameter is true: if `ν[a,b) = 0`, then `p = a` and `π = (a+b)/2` give equal expected scores under the mixture, contradicting strictness. It is not stronger than the source, which asserts the equivalence.
- `filtK`/`fk` use ℤ floor division (`/` on ℤ is Euclidean, which is the floor for `h > 0`; checked `(-1:ℤ)/2 = -1` in the probe). For `t < k`, the index `⌊(t-k)/h⌋h+k ≤ k-h ≤ 0` gives `⊥`, matching l.452.
- Measurability of `S(·,y)`: not assumed. It follows from consistency (`S(·,0)` nondecreasing and `S(·,1)` nonincreasing on [0,1]), so S2, S3 and S9a hold with `hS`.
- h=1 / h>1 coverage: `P04_main` takes `hh : 1 ≤ h`. The h=1 branch is S5-S7 (l.199-214, with the index shift against `e_T` noted; `Ik 1 T 1 = Icc 1 (T-1)`). The h>1 branch is S8-S11 (l.446-455). Measurability is S3 for both. Coverage is complete.

## Item 5. Step obligations: FAIL (R4; R3 changes binders)

| step | source | true as stated? | smuggling? | ruling |
|---|---|---|---|---|
| main | l.216-221 | follows from S3 + (S7 if h=1, S11 if h>1) | — | PASS |
| S1 `0 ≤ E_t` | l.400 (T01), l.452 "nonnegative" | true (λ=0 or p=q gives 1; otherwise consistency gives `d(1{p>q})` with sign opposite to the other outcome, so `E ≥ 1-λ`) | no | PASS (after R1 it uses the one-period clause plus hMix) |
| S2 factor ℱ_{t+h}-measurable | l.220 (no justification) | true with `hS` (monotone `S(·,y)`) | no | PASS; FAIR_IMPLICIT_STEP |
| S3 `e_T` ℱ_T-measurable | l.220 | true: `l ∈ I_k` gives `l+h ≤ k+h⌊(T-k)/h⌋ ≤ T` | no | PASS |
| S4 `c_t=0` gives factor 1 | l.205, l.217 | true (`0·x/y = 0`) | no | PASS |
| S5 h=1: `E∏_{1..n+1} ≤ E∏_{1..n}` | l.200-211 | true given the one-step bound (pull out the ℱ_{n+1}-measurable nonnegative product) | no | PASS |
| S6 h=1 iteration | l.214 | true (induction; empty product, Q probability) | no | PASS |
| S7 h=1 e-value | l.214, l.217-220 | true (S1, S6 with n = T-1) | it is the h=1 e-value clause, proved from S6 | PASS |
| S8 `e_t = (1/h)∑ M^{[k]}_t` | l.452 | true (definitional) | no | PASS |
| S9a adaptedness to `𝔉^{[k]}` | l.452 | true (factor l = k+hs, s < n, has `l+h ≤ k+hn`; `t<k` gives the empty product, a constant) | no | PASS |
| S9b `M^{[k]} ≥ 0` | l.452 | true (S1) | no | PASS |
| S9c `∫_A M_{t+1} ≤ ∫_A M_t`, `A ∈ 𝔉^{[k]}_t` | l.452 (no argument) | true given the one-step bound. Checked: either `M_{t+1} = M_t`, or `t+1 = k+hm` (m ≥ 1), and then `filtK` index = `t+1-h` = the forecast time of the new factor, and `M_t` and `A` are measurable there | supermartingale step, not the target | PASS |
| S10 optional stopping, ℕ-valued τ' | l.452 "therefore" | true (`M_0 = 1`; `{τ'>n} ∈ 𝔉^{[k]}_n` with S9c gives `E M_{τ'∧n} ≤ 1`; Fatou) | no | PASS; standard fact (v) as an obligation |
| S11 h>1 e-value | l.452-455 | true (S8, S9b, S10 with τ' ≡ T, linearity of ∫⁻) | assembly | PASS |
| S12 `τ ≤ f_k(τ) ≤ τ+h-1` | l.458 | true (`f = τ + (h-1-r)`, `r = (τ-k-1) mod h`) | no | PASS |
| **S13** `{f_k(τ) ≤ t} ∈ 𝔉^{[k]}_t` | l.459-463 | **FALSE AS STATED** (Lean counterexample `gate_P04_s13cex.lean`). The draft lets τ take the value 0 with `{τ ≤ 0} ∈ ℱ_0` arbitrary. For k = h and t < k, `filtK = ⊥` but `{f_h(τ) ≤ t} = {τ = 0}`, since `f_h(0) = 0`. The source has τ ∈ ℕ = {1,2,…} (l.230) and ℱ_j trivial for j ≤ 0 (l.452); with `τ ≥ 1` the obligation is true | no | FAIL → R4 (encoding, not a paper issue) |
| S14 `e_{t+h-1} = (1/h)∑ M^{[k]}_{f_k(t)}` | l.468 | true for `t ≥ 1` (`⌊(t+h-1-k)/h⌋ = ⌊(t-k-1)/h⌋+1`, natural subtractions nonnegative) | no | PASS |

S12-S14 are not used by `P04_main`. They are for P05.

Assembly: `P04_main` follows from S3 together with S7 (h = 1) or S11 (h > 1). Once R2 adds S0, the steps S5 and S9c use S0 instead of `hT01`.

## Item 6. External parameters

### `P04_T01Consumed` (revision-1 form): REJECTED (R1, R2)

Questions in the task, each ruled:
- **Goal-shaped?** Not in the strict sense. It does not state the conclusion or an equivalent. The product and supermartingale steps, optional stopping, averaging and measurability remain obligations.
- **Stronger than the source's use?** No. Conjunct 2 is exactly the bound asserted at l.207-209 ("≤ 1 almost surely for Q ∈ H_{S;c}"), in the equivalent integral form for nonnegative E_t. Conjunct 1 is l.400 / l.452 "nonnegative".
- **True as stated?** Yes (checked; LESSONS 10 considered). Conjunct 1 follows from `IsConsistent` alone: for p<q, write a = d(0) and b = d(1); consistency at π=p and π=q gives a ≤ 0 ≤ b, so `E(0) ∈ {1-λ, 1}` and `E(1) ≥ 1`. For conjunct 2, write `E_t = 1 + g_t d_t(Y_{t+h})` with `g_t = λ_t c_t/D_t ≥ 0` ℱ_t-measurable (λ_t = c_tλ_t by `lam_zero`). Truncate `g_t ∧ n`. Pulling out gives `∫ 1_A (g_t∧n) d_t = ∫ 1_A (g_t∧n) E[d_t|ℱ_t] ≤ 0` by `HScInt`, and Fatou concludes. Neither T01 nor ν is needed.
- **Faithful consumed clause of T01?** **No.** T01 (l.143-148) is a one-period statement for fixed numbers p ≠ q and π ∈ [0,1]. It contains no filtration, conditional expectation or H_{S;c}. Conjunct 2 is therefore not a clause of T01, so provenance (p) and the name `<ID>_<PredID>Consumed` are incorrect. It is also not (iv), because it is no clause of a paper lemma.
- **Faithful encoding of the source's unjustified claim at l.452?** **No.** l.452 claims the supermartingale property of `M^{[k]}`, which the draft keeps as obligation S9c. The parameter instead encodes the one-step bound of l.205-209. The source does justify that bound: l.207 reduces it to `c_T = 1`, and the remaining "≤ 1" is the definition of H_{S;c} (l.115) plus linearity and pull-out of the ℱ_T-measurable `λ_T/D_T`. That is a FAIR_IMPLICIT_STEP, and revision 0 of this project proved it in Lean (the old S4-S6; `verification/audits/rev1/P04_issue_1.md` l.52). The same computation at lag h is what l.452 needs. Making it a parameter therefore places a derivable step of the result under review into a hypothesis (POLICY §1: no parameter for steps the source justifies). It would also make the verdict needlessly CONDITIONAL.
- Location and naming: declared only in `P04Stmt.lean`, `namespace Paper.P04`, no redeclared name. OK, but see R1.

### `P04_MixingOfStrict`: APPROVED

Provenance (ii), l.103 (the docstring says l.106, the old numbering; see R5), asserted without proof; used silently (iii) in P04. It is the revision-0 R1 form (unchanged hash `th=3052518861`), true (item 4) and not goal-shaped. Its premise `MixtureRep S ν` makes it no stronger than l.103.

### Replacement consumed clause (after R1): APPROVED in advance

The revision-0 one-period clause is approved: (p) of T01, l.143-148 "if" direction, proof l.400. Its applicability in P04 is pointwise at `p_t(ω), q_t(ω), λ_t(ω)` when `c_t = 1`, `λ_t > 0` and `p_t ≠ q_t`, with `IsConsistent` from `hS.1` and `ν{[min,max)} > 0` from `hMix`. `T01_final.md` l.100 records that T01's sufficiency direction is verified, so the clause can be discharged by `Paper.T01.T01_S2` (`pv_work/T01ModGaps.lean:162`), as the revision-0 probe `gate_P04_t01link.lean` showed. Whether to discharge it is the coordinator's decision. Since T01's verdict is pending ISSUE (VERDICTS §4.1), the clause counts as (iv) if it is not discharged.

## Item 7. Doubts about the source (preliminary; not ruled here)

1. `VSIFP_02.tex:452`: "$(M^{[k]}_t)$ is a nonnegative supermartingale with respect to $\mathfrak F^{[k]}$" has no argument for h > 1. Template: the h=1 computation l.200-214, applied at the forecast times `k+hs` (S9c route). Preliminary: FAIR_IMPLICIT_STEP (alternatively PAPER_ARGUMENT_GAP). Dispatch pv-issue-checker.
2. `VSIFP_02.tex:452, 466` versus `:220`: the proof is written "for any $\mathbb Q\in\mathcal H_{\myS}$" (c ≡ 1), but the statement claims $\mathcal H_{\myS;c}$. The c-case is treated only in the h=1 sketch (l.205-209). Preliminary: EXPOSITION_GAP. Dispatch pv-issue-checker.
3. `VSIFP_02.tex:217` with `:146`: `p_t = q_t` is allowed but `E_{p,q;λ}` is 0/0 there (carried over from revision 0). Preliminary: DOMAIN_CLARIFICATION. Dispatch only if not already recorded for this revision.
4. `VSIFP_02.tex:454` (sum index ℓ with summand indexed by k), `:460` ("k ∈ {1,…,k}"), `:466-468` (`M` without superscript, meaning `e`): EDITORIAL.
5. `VSIFP_02.tex:446-469`: ℱ_T-measurability of `e_T` and the choice τ ≡ T for Proposition 3.4 are never stated. Preliminary: FAIR_IMPLICIT_STEP; no dispatch needed unless the coordinator wishes.

The S13 defect is an encoding matter (τ ≥ 1 in the source), not a paper issue.

## TFAs ruled on

| id | content | ruling | reason |
|---|---|---|---|
| TFA-1 `HScInt` | integrability of the score difference under Q, all t | APPROVED | L¹ meaning of the conditional expectation at l.115; avoids the junk `condExp`; only narrows the class of Q |
| TFA-2 `(ν) (hrep : T01.MixtureRep S ν)` | S given with its mixing measure | APPROVED | l.90-94 convention, T01 l.144; unchanged from revision 0 |
| TFA-3 premises `1 ≤ h`, `ν[a,b) > 0` inside `P04_T01Consumed` | weaken the clause | moot (the clause is rejected, R1) | — |
| `p_t = q_t` gives `Erep = 1` | representation choice | APPROVED | the "no bet" convention of l.205; record the domain point |
| (needed after R4) `τ ≥ 1` in S13 | source τ ∈ ℕ = {1,2,…} (l.230), `ℱ_j` trivial for j ≤ 0 (l.452) | APPROVED | faithful domain of the source; excludes only τ = 0, which the source does not consider |

## External parameters

| name | provenance | ruling |
|---|---|---|
| `P04_T01Consumed` (current, sequential) | labelled (p)/(iii)/(iv); actually a source-derived step (l.205-209, FAIR_IMPLICIT_STEP) | REJECTED (R1, R2) |
| `P04_T01Consumed` (after R1, one-period) | (p) T01 l.143-148, proof l.400; (iv) while T01 is pending ISSUE; dischargeable by `Paper.T01.T01_S2` | APPROVED |
| `P04_MixingOfStrict` | (ii) l.103, (iii) in P04 | APPROVED |

## Required changes

- **R1** (`pv_work/P04Stmt.lean` l.72-90): replace the docstring and the definition of `P04_T01Consumed` by the one-period clause:
  ```lean
  def P04_T01Consumed (S : ℝ → ℝ → ℝ) : Prop :=
    IsConsistent S → ∀ ν : Measure ℝ, T01.MixtureRep S ν →
      ∀ p ∈ Set.Ioo (0:ℝ) 1, ∀ q ∈ Set.Ioo (0:ℝ) 1, p ≠ q →
        0 < ν (Set.Ico (min p q) (max p q)) →
          ∀ lam ∈ Set.Ioc (0:ℝ) 1,
            IsEValue (Erep S p q lam) (HS S p q) ∅
  ```
  The new docstring should state: (p) of T01, l.143-148 "if" direction, proof l.400; applicability pointwise at `(p_t ω, q_t ω, λ_t ω)` with `c_t = 1`, `λ_t > 0` and `p_t ≠ q_t`, `IsConsistent` from `hS.1`, and ν-positivity from `hMix` (l.103); (iv) while T01 is pending ISSUE.
- **R2** (`pv_work/P04Draft.lean`, insert after `P04_S4`): add the obligation
  ```lean
  /-- S0.  (l.205-209 one-step bound `E_Q{E_t(Y_{t+h}) | ℱ_t} ≤ 1` a.s. for `Q ∈ ℋ_{S;c}`, applied at
  lag `h` at l.452; derivation: definition of `ℋ_{S;c}` (l.115), linearity, pull-out of the
  `ℱ_t`-measurable `λ_t/D_t`, the case `c_t = 0` being S4.)  Integral form for `A ∈ ℱ_t`. -/
  theorem P04_S0 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν) (h : ℕ)
      (hh : 1 ≤ h) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
      (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
      (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
      (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y c p q) (t : ℕ) (A : Set Ω)
      (hA : MeasurableSet[ℱ t] A) :
      ∫⁻ ω in A, ENNReal.ofReal (Erep S (p t ω) (q t ω) (lam t ω) (Y (t + h) ω)) ∂Q ≤ Q A := by
    sorry
  ```
  Update the docstrings of S5 and S9c: "the one-step bound S0" instead of "the consumed T01 clause".
- **R3** (`pv_work/P04Draft.lean`, `P04_main`, `P04_S1`, `P04_S5`, `P04_S6`, `P04_S7`, `P04_S9b`, `P04_S9c`, `P04_S10`, `P04_S11`): replace `(hT01 : P04_T01Consumed S ν h ℱ Y c p q lam)` by `(hT01 : P04_T01Consumed S)`. Keep all other binders. Update the docstrings of `P04_main` and `P04_S1` (S1 uses the one-period clause plus `hMix`).
- **R4** (`pv_work/P04Draft.lean` l.192, `P04_S13`): after `(hτ : ∀ n, MeasurableSet[ℱ n] {ω | τ ω ≤ n})` insert `(hτ1 : ∀ ω, 1 ≤ τ ω)`. Add to the docstring: "τ ∈ ℕ = {1,2,…} (l.230), ℱ_j trivial for j ≤ 0 (l.452)". P05's use of S13 must respect this.
- **R5** (docstrings only; the files are not yet reviewed, so editing is allowed): in `P04Stmt.lean`, change the module doc "l.222-227" to "l.216-221", and in the `P04_MixingOfStrict` docstring change "l.106" to "l.103" and "l.93-97" to "l.90-102". Update the notes (consumed-clause section, TFA-3, external-inputs table).
- After R1, `P05Stmt.olean` must be rebuilt (it imports `P04Stmt`). P05Stmt uses only `P04Conclusion`, `SeqSetting`, `eT` and `HScInt`, whose hashes are unchanged by R1.
- No other change.

## Statement snapshot (pre-amendment; to be superseded by the r2 snapshot)

`pv_work/logs/gate_P04_v2_stmtcopy_1.log`:
```
TYPE HASHES (current file, 37 declarations)
Paper.P04.HScInt|def|th=4049409469|vh=4086871767|bi=iieeeeeee
Paper.P04.HSc|def|th=4049409469|vh=4068097418|bi=iieeeeeee
Paper.P04.Ik|def|th=2688782768|vh=1188971402|bi=eee
Paper.P04.IsEValueUnder|def|th=991135443|vh=3738125688|bi=iiee
Paper.P04.Mk|def|th=3661733293|vh=2458480867|bi=ieeeeeeeee
Paper.P04.P04Conclusion.casesOn|def|th=2675418763|vh=1507955123|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.evalue|thm|th=4035352186|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.measurable|thm|th=4135999659|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.mk|ctor|th=2848929677|vh=-|bi=iiiiiiiiiiiee
Paper.P04.P04Conclusion.noConfusionType|def|th=29438603|vh=2860735649|bi=iiiiiiiiiiieee
Paper.P04.P04Conclusion.noConfusion|def|th=3611900954|vh=4253560742|bi=iiiiiiiiiiiiiie
Paper.P04.P04Conclusion.recOn|def|th=2675418763|vh=1945409720|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.rec|rec|th=2364683867|vh=-|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion|induct|th=2076968018|vh=-|bi=iieeeeeeeee
Paper.P04.P04_MixingOfStrict|def|th=3052518861|vh=2636801367|bi=e
Paper.P04.P04_T01Consumed|def|th=1961053678|vh=3727104048|bi=iieeeeeeeee
Paper.P04.SeqSetting.Y_adapted|thm|th=1845958995|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.Y_mem|thm|th=2839112627|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.c_adapted|thm|th=2580291967|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.c_mem|thm|th=405650024|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.casesOn|def|th=2469678534|vh=2258885665|bi=iiiiiiiiiee
Paper.P04.SeqSetting.lam_adapted|thm|th=295661739|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.lam_mem|thm|th=2343973461|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.lam_zero|thm|th=1211223059|vh=-|bi=iiiiiiiieeee
Paper.P04.SeqSetting.mk|ctor|th=588935457|vh=-|bi=iiiiiiiieeeeeeeeeee
Paper.P04.SeqSetting.noConfusionType|def|th=3681074281|vh=2499496481|bi=iiiiiiiieee
Paper.P04.SeqSetting.noConfusion|def|th=2508541176|vh=145876914|bi=iiiiiiiiiiie
Paper.P04.SeqSetting.p_adapted|thm|th=2626217022|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.p_mem|thm|th=791283169|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.q_adapted|thm|th=1779977113|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.q_mem|thm|th=1757075794|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.recOn|def|th=2469678534|vh=2691199307|bi=iiiiiiiiiee
Paper.P04.SeqSetting.rec|rec|th=29311890|vh=-|bi=iiiiiiiiiee
Paper.P04.SeqSetting|induct|th=15571848|vh=-|bi=iieeeeee
Paper.P04.eT|def|th=4241663065|vh=662740667|bi=ieeeeeeee
Paper.P04.filtK|def|th=2857920538|vh=3732874505|bi=iieeee
Paper.P04.fk|def|th=3512939730|vh=180150542|bi=eee
```

`pv_work/logs/gate_P04_v2_draftcopy_1.log`:
```
TYPE HASHES (current file, 17 declarations)
Paper.P04.P04_S10|thm|th=1332232536|vh=-|bi=iieeeeeeeeeeeeeeeeeeeee
Paper.P04.P04_S11|thm|th=2874136934|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S12|thm|th=2384155120|vh=-|bi=eeee
Paper.P04.P04_S13|thm|th=3311405543|vh=-|bi=iieeeeeeee
Paper.P04.P04_S14|thm|th=3901520671|vh=-|bi=ieeeeeeeeee
Paper.P04.P04_S1|thm|th=3776789693|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S2|thm|th=1825503320|vh=-|bi=iieeeeeeeeeee
Paper.P04.P04_S3|thm|th=3849468069|vh=-|bi=iieeeeeeeeeeeee
Paper.P04.P04_S4|thm|th=1386535428|vh=-|bi=iieeeeeeeeeeee
Paper.P04.P04_S5|thm|th=753579893|vh=-|bi=iieeeeeeeeeeeeeeeeee
Paper.P04.P04_S6|thm|th=233294422|vh=-|bi=iieeeeeeeeeeeeeeeeee
Paper.P04.P04_S7|thm|th=969313545|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S8|thm|th=125539248|vh=-|bi=ieeeeeeee
Paper.P04.P04_S9a|thm|th=1085402202|vh=-|bi=iieeeeeeeeeeeeee
Paper.P04.P04_S9b|thm|th=953591195|vh=-|bi=iieeeeeeeeeeeeeeeeeee
Paper.P04.P04_S9c|thm|th=1204844674|vh=-|bi=iieeeeeeeeeeeeeeeeeeeeee
Paper.P04.P04_main|thm|th=3970572382|vh=-|bi=iieeeeeeeeeeeeeeeee
```

## Overall verdict

Required changes R1-R5 are listed above. The one false-as-stated obligation is P04_S13 (R4). The parameter `P04_T01Consumed` in its current form is rejected (R1-R3). After the amendments, a check (`P04_gate_r2.md`) with a new snapshot is required.

STATEMENT GATE: PASS_WITH_AMENDMENTS

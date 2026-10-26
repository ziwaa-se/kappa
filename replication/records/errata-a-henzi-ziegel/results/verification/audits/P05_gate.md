# P05 statement gate (Proposition 3.5, `prop:stopping`), draft revision 1

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Tue Oct 13 10:41:47 EDT 2026
- Earlier P05 gate reports from the previous revision are in `verification/audits/rev1/`. This report covers the current draft only. The probe copies use the suffix `_rev2` so the rev1 probe files are left untouched.

## Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`)

| file | sha256 |
|---|---|
| pv_work/P05Stmt.lean | e85c93c6971ca1df1b1d1d9ad2d135b28b84c3daeca36581cdbecca06c268464 |
| pv_work/P05Draft.lean | 9ef64f5f5b770cc078af8fba0b9d31226f11bfa108a7d9387be3f1c508c619f0 |
| pv_work/P04Stmt.lean (imported) | f8f6cf447fc559ee047e08a19eceb4474e4a717f7a7f2b3d6503b2e1d6ef6119 |
| pv_work/notes/P05_draft_notes.md (leads only) | b7328ecdcbbdbc4d6d25325af0a3f64321a42a61846e0a9f382776b005acd14d |

I also read `pv_work/Defs.lean` (`IsConsistent`, `IsStrictlyConsistent`, `Erep`), `pv_work/T01Stmt.lean` (`MixtureRep`), and `P04_main`, `P04_S9a-c` and `P04_S10` in `pv_work/P04Draft.lean`, plus `verification/audits/P04_gate.md` and `P04_gate_r2.md` (for TFA-1, TFA-2 and τ ≥ 1).

## Compilation

- `scripts/pv_lean.sh check P05Draft`: `RESULT P05Draft mode=check exit=0 errors=0 sorry_warnings=10 nonstandard_axiom_lines=0 log=pv_work/logs/P05Draft_6.log`. The 10 sorries are `P05_main` and `P05_S0`–`P05_S8`.
- Probe of the Stmt copy: exit=0, sorry_warnings=0 (log `pv_work/logs/gate_P05_stmtcopy_rev2_1.log`).
- Probe of the Draft copy: exit=0, sorry_warnings=10 (log `pv_work/logs/gate_P05_draftcopy_rev2_1.log`).

## Source quotations (source/VSIFP_02.tex)

- l.229-233: "Let $\tau \in \mathbb{N}$ be a stopping time. Then under the assumptions of Proposition \ref{prop:combination}, $\mathbb{E}_{\mathbb{Q}}(e_{\tau+h-1}) \leq 1, \ \mathbb{Q} \in \mathcal{H}_{\myS}$."
- l.217-220 (assumptions of P04): $(Y_t, c_t, p_t, q_t, \lambda_t) \in \{0,1\}^2\times(0,1)^2\times[0,1]$, adapted to $\mathcal F_t$, $t\in\mathbb N$, $\lambda_t = 0$ if $c_t=0$, $\myS$ strictly consistent; $e_T = \frac1h\sum_{k=1}^h\prod_{l\in I_k}E_{p_l,q_l;\lambda_l}(Y_{l+h})$ with $I_k = \{k+hs: s=0,\dots,\lfloor (T-k)/h\rfloor-1\}$.
- l.108: integer lag $h \ge 1$. l.114-119: $\mathcal H_{\myS;c}$, with $\mathcal H_{\myS;c} = \mathcal H_{\myS}$ when $c_t\equiv 1$. l.90-103: mixture representation convention (TFA-2 of P04).
- l.227: "For $h = 1$, this is a consequence of the fact that $(e_t)_{t \geq 2}$ is a non-negative supermartingale [Ramdas2020, Section 3]." l.214 states the supermartingale property for $h=1$.
- l.447: "Let $h > 1$." l.447-452: definitions of $I_k(t)$, $M^{[k]}_t$, $\mathfrak F^{[k]} = (\mathcal F_{\lfloor (t-k)/h\rfloor h+k})_t$, $\mathcal F_j$ trivial for $j\le 0$.
- l.452: "For $k = 1, \dots, h$, the process $(M^{[k]}_t)_{t \in \mathbb{N}}$ is a nonnegative supermartingale with respect to $\mathfrak{F}^{[k]}$ for any $\mathbb{Q} \in \mathcal{H}_{\myS}$, and therefore satisfies $\mathbb{E}_{\mathbb{Q}}(M^{[k]}_{\tau[k]}) \le 1$ for any $\mathfrak{F}^{[k]}$-stopping time $\tau^{[k]}$."
- l.456-463: $f_k(\tau) = (\lfloor(\tau-k-1)/h\rfloor+1)h+k \in\{\tau,\dots,\tau+h-1\}$ is an $\mathfrak F^{[k]}$-stopping time.
- l.464-468: $\mathbb E_{\mathbb Q}(M_{\tau+h-1}) = \mathbb E_{\mathbb Q}(\frac1h\sum_k M^{[k]}_{f_k(\tau)})\le 1$, $\mathbb Q\in\mathcal H_{\myS}$, using $M_{t+h-1} = \sum_k M^{[k]}_{f_k(t)}/h$.
- l.460 uses $\mathbb N_0$ separately from $\mathbb N$, so $\mathbb N = \{1,2,\dots\}$.

## Item 1: Hypotheses. FAIL (amendment A2)

- `hh : 1 ≤ h` (l.108), `SeqSetting` (l.217, the same structure gated for P04), `IsStrictlyConsistent S` (l.220), `τ : Ω → ℕ` with `IsStopTime ℱ τ` (l.230; `{τ ≤ n} ∈ ℱ n`, finite valued). These are correct.
- TFA `1 ≤ τ` (inside `IsStopTime.pos`): APPROVED. In the source ℕ = {1,2,…} (l.460 versus ℕ_0), and P04 gate r2 approved the same TFA for S13. In Lean, `ℱ 0` adds no constraint because `{τ ≤ 0} = ∅`.
- No hidden hypotheses: there is only `variable {Ω} {m0}`, and the structures contain exactly the listed fields.
- **Missing hypothesis (A2).** "Under the assumptions of Proposition 3.4" (l.230) is encoded for P04 with `(ν : Measure ℝ) (hrep : T01.MixtureRep S ν)` (TFA-2, approved by the P04 gate, l.90-103 convention). `P05_main` omits it. On its own, this would only make the main statement stronger, and I believe it is still true (see item 5). The problem is the consumed clause. P04's step `P04_S10`, the source location the clause is taken from, has `hrep` among its applicability conditions. `P05_P04Consumed` drops it, so the clause is stronger than the predecessor's assertion as encoded, and its applicability conditions cannot be met inside `P05_main` at reconnection. See item 6 and A2.

## Item 2: Conclusion. PASS

`P05Conclusion` is `∀ Q ∈ HScInt S h ℱ Y (fun _ _ => 1) p q, ∫⁻ ofReal(eT … (τ ω + h - 1) ω) ∂Q ≤ 1`. This is l.232 with ℋ_S = ℋ_{S;c≡1} (l.119), narrowed by TFA-1 `HScInt` (approved for P04).

- There is no `ofReal` truncation trap: `eT ≥ 0` under `IsConsistent` (the argument in P04_gate item 5: `d(0) ≤ 0 ≤ d(1)` for p<q), so the lintegral equals the expectation.
- `e_{τ+h-1}` at τ = 1 is `e_h`. P04's statement defines `e_T` only for T ≥ h+1, but the formula is defined at T = h (all `I_k(h) = ∅`, `e_h = 1`), and that is the value the proof at l.468 uses. The draft encoding A07 is correct.
- The conclusion is neither weakened nor strengthened. No clause is missing.

## Item 3: Quantifiers and constants. PASS

There are no constants. The order (S, h, ℱ, data, τ, then ∀ Q) matches l.229-233. The bound 1 is uniform.

## Item 4: Domains and details. PASS

- The stopping time is with respect to 𝔉 = (ℱ_t) and is finite valued (`τ : Ω → ℕ`), as l.230 states "τ ∈ ℕ".
- `filtK` and `fk` are the P04 definitions (l.450, l.452, l.458), computed in ℤ with floor division (`Int` `/` is the Euclidean division, which is the floor for h > 0).
- The statement involves no a.e. issue: the conclusion is an integral bound.
- Measurability is not assumed. It is obligation S6 (see item 5).
- The ℝ≥0∞/ℝ conversion is discussed in item 2.

## Item 5: Step obligations. PASS (all true as stated; labels checked)

- **S0** (h = 1): true as stated. For h = 1, `Mk 1 t = ∏_{l=1}^{t-1} E_l(Y_{l+1})` is ℱ_t-measurable. One-step bound: write `E = 1 + g·d` with `g ≥ 0` ℱ_t-measurable, truncate at n and apply Fatou, as in P04_gate r2 S0. This gives a nonnegative supermartingale with `M_1 = 1`, and Fatou on `M_{τ∧n}` gives `E M_τ ≤ 1` for finite τ.
  - Label: the source does give a route outside the proof environment, namely l.227 (supermartingale l.214 + Ramdas 2020 §3, a cited result (i)). The docstring's "NO proof for h=1" is accurate only for the proof environment l.446-469. This is not a blocking point. The prover or issue-checker should decide whether S0 is reached through l.214/l.227 plus an external parameter (i), or recorded as a gap. See item 7.
- **S1**: definitional (the summand of `eT` is `Mk`), l.452. True.
- **S2**: ℋ_S ⊆ ℋ_{S;c}. Since `c ∈ {0,1}`, `c·condExp ≤ 0` follows from `condExp ≤ 0`, and the integrability conjunct is the same. True. After A1 it is no longer needed by S7 (see A1).
- **S3**: write `τ-k-1 = ah + r` with `0 ≤ r < h`. Then `f_k(τ) = τ - 1 - r + h ∈ [τ, τ+h-1]`, and `toNat` is harmless because `h-1-r ≥ 0`. This also holds for τ = 0. True (l.458).
- **S4**: `f_k(τ) ≤ t ⇔ τ ≤ ⌊(t-k)/h⌋h + k =: g`. If g ≤ 0, the set is empty (τ ≥ 1) and so lies in ⊥. Otherwise it lies in ℱ_g. True (l.459-463). The premise `1 < h` is extra and harmless.
- **S5**: for t ≥ 1, with `t-k-1 = ah + r`, both `⌊(t+h-1-k)/h⌋` and `⌊(f_k(t)-k)/h⌋` equal a+1 ≥ 0. So `I_k(t+h-1) = I_k(f_k(t))`. True (l.468).
- **S6**: measurability of `ω ↦ Mk k (fk(τ ω)) ω`. This is true, but not trivial, because `S` is an arbitrary function ℝ→ℝ→ℝ. Under `IsConsistent`, `Δ(p) = S(p,1) - S(p,0)` is nonincreasing and `G(π) = E_π S(π,·)` is concave, so `S(·,0) = G - pΔ` and `S(·,1)` are Borel on (0,1). With `p_t, q_t ∈ (0,1)`, each `Mk t` is m0-measurable, and the countable decomposition over `{τ = n}` concludes. This is a FAIR_IMPLICIT_STEP (silently used, (iii) in the notes), not a paper issue.
- **S7**: follows from the clause with τ' = f_k(τ) (S4) and S2. True given the clause.
- **S8**: S5 pointwise at t = τ ω ≥ 1, `ofReal` of a nonnegative sum, linearity of ∫⁻ (S6), and S7. True.
- **Assembly**: main = S0 (h = 1) + S8 (h > 1). Together they give `P05_main`.
- No obligation smuggles in the target. S7 is the clause instantiated at f_k(τ), which is the source's own step (l.452 + l.456).

## Item 6: External parameter `P05_P04Consumed`. FAIL (amendments A1, A2)

- **Provenance (p): correct.** It is consumed from the proof of P04, l.452, "(M^{[k]}) is a nonnegative supermartingale … therefore E_Q(M^{[k]}_{τ[k]}) ≤ 1 for any 𝔉^{[k]}-stopping time", which is P04 draft step `P04_S10`. It is restricted to h > 1, as the proof begins "Let h > 1" (l.447). This is faithful: the source asserts the clause only in the h > 1 branch.
- **Not the printed P04 conclusion: correct.** `P04Conclusion` (l.220) is only about fixed T, and P05 needs the optional-stopping clause at random times. Consuming the proof sentence at l.452 is the faithful choice.
- **Name and location**: the name `P05_P04Consumed` follows `<ID>_<PredID>Consumed`. It is declared in `P05Stmt.lean`, `namespace Paper.P05`, and redeclares no existing name (it reuses `Paper.P04.*`).
- **Not goal-shaped**: it concerns `Mk` at 𝔉^{[k]}-stopping times, not `eT` at τ+h-1. The derivation of P05 from it still requires S3-S5, S8.
- **Truth**: true as stated. Each factor has E[·|ℱ_l] ≤ 1 under ℋ_{S;c} (λ_l = 0 where c_l = 0). M^{[k]} jumps only at times ≡ k mod h, and Fatou gives the optional stopping result. It needs only strict (even plain) consistency, not ν.
- **Defect 1, stronger than the source sentence (A1).** l.452 asserts the clause "for any Q ∈ ℋ_S". The Lean clause quantifies over `Q ∈ HScInt S h ℱ Y c p q` = ℋ_{S;c} ⊇ ℋ_S, which is a stronger assertion than the one printed at l.452. P05 uses it only on ℋ_S (l.466). The rule card says an external parameter is never stronger than the source's use. Fix: state it for ℋ_S. It remains derivable from `P04_S10` by instantiating `c := fun _ _ => 1`, since `SeqSetting ℱ Y 1 p q lam` follows from `SeqSetting ℱ Y c p q lam`: only `c_adapted`, `c_mem` and `lam_zero` change, and they are trivial for c ≡ 1.
- **Defect 2, applicability conditions (A2).** `P04_S10` (the stated location) requires `(ν) (hrep : T01.MixtureRep S ν)`, as well as P04's parameters `P04_T01Consumed` and `P04_MixingOfStrict`. Leaving out the P04 parameters is the documented inheritance-at-reconnection convention, so that part is acceptable. `hrep`, however, is an approved hypothesis (TFA-2) of P04, not a parameter. Omitting it makes the clause stronger than its source location, and the applicability condition "how the conditions hold here" cannot be met in `P05_main`, which has no ν.
- The "mathlib does not have it" evidence is not applicable: this is a clause of the paper's own proof.

## Item 7: Doubts about the source (preliminary, not ruled here)

1. **h = 1 case** (l.229-234 versus l.447 "Let h > 1"). The proof environment covers only h > 1. l.227 justifies h = 1 by the l.214 supermartingale property plus a cited optional-stopping result (Ramdas 2020 §3). Preliminary classification: EXPOSITION_GAP candidate, possibly downgraded to a cited external input (i) / FAIR_IMPLICIT_STEP if the l.214 + l.227 route holds. **Dispatch pv-issue-checker.**
2. **l.214 indexing**: "the process ∏_{j=1}^t E_{p_j,q_j;λ_j}(Y_{j+1}), t = 2,3,…, is a non-negative supermartingale w.r.t. (ℱ_t)". The t-th term involves Y_{t+1}, so it is not ℱ_t-adapted (off by one; e_t of l.218 with h = 1 is ∏_{j=1}^{t-1}). Preliminary: EDITORIAL / EXPOSITION_GAP. Relevant to item 1. Same pv-issue-checker dispatch.
3. l.452 says ℋ_S inside the proof of P04, whose statement concerns ℋ_{S;c} (l.220). This is P04's concern (no impact on P05 after A1).
4. Typos: l.454 index ℓ for k; l.460 "k ∈ {1,…,k}"; l.466/468 `M` for `e`. EDITORIAL.

## TFAs ruled on

| TFA | content | ruling | reason |
|---|---|---|---|
| `IsStopTime.pos` (τ ≥ 1) | ℕ = {1,2,…} | APPROVED | l.460 ℕ_0 versus ℕ; same as the P04 r2 ruling |
| `HScInt` (inherited TFA-1) | integrability of the score difference | APPROVED (inherited) | P04_gate TFA-1 |
| `(ν, hrep)` (TFA-2 of P04) | mixture representation convention | REQUIRED to be added (A2) | assumptions of P04 as encoded; applicability of the clause |

## External parameters

| name | provenance | ruling |
|---|---|---|
| `P05_P04Consumed` | (p), P04 proof l.452 = `P04_S10`, h > 1 | REJECTED as written; approved after A1 + A2 |

## Required changes

- **A1** (`pv_work/P05Stmt.lean`, l.45): in `P05_P04Consumed`, replace
  `∀ Q ∈ HScInt S h ℱ Y c p q, ∀ k ∈ Finset.Icc 1 h, ∀ τ' : Ω → ℕ,`
  by
  `∀ Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q, ∀ k ∈ Finset.Icc 1 h, ∀ τ' : Ω → ℕ,`
  (l.452 "for any Q ∈ ℋ_S"). Update the docstring (l.37-38): it is now stated for ℋ_S as at l.452, and it is derivable from `P04_S10` with c := 1. In `P05Draft.lean`, the docstring of S7 (l.86-87) should no longer cite S2. S2 may be kept or removed; if removed, update the notes.
- **A2** (`pv_work/P05Stmt.lean`, l.42-44): give the clause the applicability condition of `P04_S10`. Add the argument `(ν : Measure ℝ)` after `(S : ℝ → ℝ → ℝ)` and the premise `T01.MixtureRep S ν →` before `SeqSetting ℱ Y c p q lam →`. In `pv_work/P05Draft.lean`, add `(ν : Measure ℝ) (hrep : T01.MixtureRep S ν)` after `(S : ℝ → ℝ → ℝ)` in `P05_main` (l.20), `P05_S7` (l.88) and `P05_S8` (l.100), and pass ν in `hP04 : P05_P04Consumed S ν h ℱ Y c p q lam`. Update the clause docstring and the notes (the external-inputs table: applicability `hrep` from P05_main, as P04_main). Adding `ν, hrep` to S0 and S6 is optional.
- Optional, not required: relabel the S0 docstring to mention the l.214 + l.227 (Ramdas, cited) route.

## Statement snapshot (copies `pv_work/probes/gate/P05/gate_P05_stmtcopy_rev2.lean`, `gate_P05_draftcopy_rev2.lean`)

Stmt copy (`pv_work/logs/gate_P05_stmtcopy_rev2_1.log`):
```
TYPE HASHES (current file, 11 declarations)
Paper.P05.IsStopTime.casesOn|def|th=684456660|vh=3754682799|bi=iiiiiee
Paper.P05.IsStopTime.le_meas|thm|th=3381446121|vh=-|bi=iiiiee
Paper.P05.IsStopTime.mk|ctor|th=351244110|vh=-|bi=iiiiee
Paper.P05.IsStopTime.noConfusionType|def|th=1932249251|vh=245851765|bi=iiiieee
Paper.P05.IsStopTime.noConfusion|def|th=3747551284|vh=1109229026|bi=iiiiiiie
Paper.P05.IsStopTime.pos|thm|th=447953783|vh=-|bi=iiiiee
Paper.P05.IsStopTime.recOn|def|th=684456660|vh=1201850754|bi=iiiiiee
Paper.P05.IsStopTime.rec|rec|th=3308248231|vh=-|bi=iiiiiee
Paper.P05.IsStopTime|induct|th=1866782038|vh=-|bi=iiee
Paper.P05.P05Conclusion|def|th=3968915205|vh=3232930259|bi=iieeeeeeee
Paper.P05.P05_P04Consumed|def|th=609196166|vh=2235679019|bi=iieeeeeeee
```

Draft copy (`pv_work/logs/gate_P05_draftcopy_rev2_1.log`):
```
TYPE HASHES (current file, 10 declarations)
Paper.P05.P05_S0|thm|th=1557197759|vh=-|bi=iieeeeeeeeeee
Paper.P05.P05_S1|thm|th=125539248|vh=-|bi=ieeeeeeee
Paper.P05.P05_S2|thm|th=1605119062|vh=-|bi=iieeeeeeeee
Paper.P05.P05_S3|thm|th=2384155120|vh=-|bi=eeee
Paper.P05.P05_S4|thm|th=1463795132|vh=-|bi=iieeeeeeee
Paper.P05.P05_S5|thm|th=3901520671|vh=-|bi=ieeeeeeeeee
Paper.P05.P05_S6|thm|th=3176615292|vh=-|bi=iieeeeeeeeeeeeeee
Paper.P05.P05_S7|thm|th=861273493|vh=-|bi=iieeeeeeeeeeeeeeeeee
Paper.P05.P05_S8|thm|th=4256137844|vh=-|bi=iieeeeeeeeeeeeee
Paper.P05.P05_main|thm|th=1883951936|vh=-|bi=iieeeeeeeeeeeeee
```

This snapshot is for the pre-amendment text. After A1 and A2, the r2 check produces the binding snapshot.

STATEMENT GATE: PASS_WITH_AMENDMENTS

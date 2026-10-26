# P05 issue 1 (Proposition 3.5, `prop:stopping`, revised source `source/VSIFP_02.tex`): ruling on the case h = 1

Role: pv-issue-checker. Date: Tue Oct 13 10:56:23 EDT 2026. Reported by: pv-gate (`verification/audits/P05_gate.md` item 7, `P05_gate_r2.md` l.52) and pv-prover (`pv_work/notes/P05_prover_notes.md` §"Stopped obligation S0"). Obligation: `P05_S0`, gap `P05_S0_Gap` in `pv_work/P05ModGaps.lean:157-161`.
Status: **not confirmed** until pv-auditor review (reasoning review; the Lean probe is positive evidence, not a counterexample).

Note: `verification/audits/rev1/P05_issue_1.md` (ERROR) concerns the earlier manuscript (old statement `E(e_τ) ≤ 1`, old proof l.471-476, now commented out). It does not apply to the present text and is not reused here.

## 1. Source quotations (read directly)

- l.229-234 (statement): "Let $\tau \in \mathbb{N}$ be a stopping time. Then under the assumptions of Proposition \ref{prop:combination}, $\mathbb{E}_{\mathbb{Q}}(e_{\tau+h-1}) \leq 1, \ \mathbb{Q} \in \mathcal{H}_{\myS}$." The assumptions of Prop 3.4 (l.217-220) allow every lag $h \ge 1$, so h = 1 is in scope.
- l.227 (immediately before the statement): "Our last theoretical result states that the e-values $e_T$ constructed above are also valid when $T$ is replaced by a stopping time $\tau$. For $h = 1$, this is a consequence of the fact that $(e_t)_{t \geq 2}$ is a non-negative supermartingale \citep[see][Section 3]{Ramdas2020}."
- l.200-211 (h = 1 computation): $\mathbb{E}_\mathbb{Q}\{\prod_{t=1}^T E_t(Y_{t+1})\} = \mathbb{E}_\mathbb{Q}[\prod_{t=1}^{T-1}E_t(Y_{t+1})\,\mathbb{E}_\mathbb{Q}\{E_T(Y_{T+1})\mid\mathcal F_T\}]$, with $\mathbb{E}_\mathbb{Q}\{E_T(Y_{T+1})\mid\mathcal F_T\}\le 1$ a.s. (l.207), hence $\mathbb{E}\prod_{t=1}^T \le \mathbb{E}\prod_{t=1}^{T-1}$ (l.211).
- l.214: "Iterating this argument shows that the product ... is an e-value for $\mathcal{H}_{\myS; c}$; more precisely, the process $\prod_{j = 1}^t E_{p_j, q_j; \lambda_j}(Y_{j + 1})$, $t = 2, 3, \dots$, is a non-negative supermartingale with respect to $(\mathcal{F}_t)_{t \in \mathbb{N}}$."
- l.446-447 (the proof that establishes P05; headed "Proof of Proposition \ref{prop:combination}", the separate P05 proof l.471-476 is commented out): "... Let $h > 1$. For $k = 1, \dots, h$, define $I_k(t)$ ..., $M^{[k]}_t$, $\mathfrak{F}^{[k]}$ ..."
- l.452: "the process $(M^{[k]}_t)$ is a nonnegative supermartingale with respect to $\mathfrak{F}^{[k]}$ ... and therefore satisfies $\mathbb{E}_{\mathbb{Q}}(M^{[k]}_{\tau[k]}) \le 1$ for any $\mathfrak{F}^{[k]}$-stopping time"; l.456-468: $f_k(\tau)$ is an $\mathfrak F^{[k]}$-stopping time and $e_{\tau+h-1} = \frac1h\sum_k M^{[k]}_{f_k(\tau)}$.
- Definitions: l.217-218 $I_k = \{k+hs: s = 0,\dots,\lfloor (T-k)/h\rfloor-1\}$, $e_T = \frac1h\sum_{k=1}^h\prod_{l\in I_k}E_l(Y_{l+h})$. At h = 1: $I_1(T) = \{1,\dots,T-1\}$, $e_T = \prod_{l=1}^{T-1}E_l(Y_{l+1})$, $e_1 = 1$ (empty product, l.452 $\prod_\emptyset := 1$).

## 2. What is consumed

Consumed instance: h = 1, $c \equiv 1$ ($\mathcal H_{\myS}$, l.232), $\tau$ an $(\mathcal F_t)$-stopping time with values in $\{1,2,\dots\}$. Then $e_{\tau+h-1} = e_\tau = \prod_{l=1}^{\tau-1}E_l(Y_{l+1})$, and the claim is $\mathbb{E}_\mathbb{Q} e_\tau \le 1$.

What this needs: (a) $(e_t)_{t\ge1}$ is a nonnegative $(\mathcal F_t)$-supermartingale under $\mathbb Q \in \mathcal H_{\myS}$, i.e. $\mathbb E[e_{T+1}\mid\mathcal F_T]\le e_T$; (b) optional stopping for a nonnegative supermartingale at an a.s. finite ($\mathbb N$-valued, possibly unbounded) stopping time: $\mathbb E e_\tau \le \mathbb E e_1 = 1$.

Where the source supplies it: (a) is exactly l.200-211 (one-step bound with $T$ the conditioning time: $e_{T+1} = e_T\cdot E_T(Y_{T+1})$, $e_T$ is $\mathcal F_T$-measurable, l.207 bounds the conditional factor) and is stated at l.214 and l.227; (b) is cited at l.227 (Ramdas 2020, Sec. 3; Doob/Ville optional stopping), a standard textbook fact.

## 3. Classification

**Main: FAIR_IMPLICIT_STEP** (not a paper issue).

Reasons:
1. The h = 1 case is not uncovered: l.227 gives an explicit argument (supermartingale + optional stopping, with citation), and the supermartingale property is computed in the text at l.200-211. "Let h > 1" at l.447 restricts the appendix proof because h = 1 was handled in the main text, exactly as for Proposition 3.4 itself (P04's h = 1 case is also only l.200-214; P04 was verified for h = 1 along that route, `verification/audits/P04_final.md` l.72, l.97).
2. The h = 1 argument has the same strength as the h > 1 argument the gate already accepted: l.452 also just asserts "nonnegative supermartingale ... therefore $\mathbb E(M_{\tau})\le1$ for any stopping time", accepted as FAIR_IMPLICIT_STEP (`P04_final.md` l.74; filled in as `P04_S9c`, `P04_S10`). At h = 1 the appendix objects reduce literally to those of l.214/l.227: $M^{[1]}_t = e_t$, $\mathfrak F^{[1]}_t = \mathcal F_t$ ($t\ge1$), $f_1(\tau) = \tau$ (checked in Lean, §5). So "Let h > 1" only excludes a case where the appendix proof would read word for word like l.227.
3. Optional stopping for an unbounded but finite stopping time needs a limit step (bounded stopping at $\tau\wedge n$, then Fatou). This is the standard proof of the cited result, and it is the same step filled in for h > 1 in `P04_S10`.

Why not the neighbouring classes:
- Not EXPOSITION_GAP: no range is left without an argument; h = 1 is covered by l.227 + l.200-214.
- Not PAPER_ARGUMENT_GAP: the given justification (supermartingale + optional stopping) does yield the claim; nothing in it fails (unlike the rev1 text, whose premise $\mathbb E(e_t\mid\mathcal F_t)\le1$ was false).
- Not ENCODING_ERROR: the encoding of the statement is correct. The Lean gap exists only because the consumed clause `P05_P04Consumed` (`pv_work/P05Stmt.lean:43-48`) was drafted from l.452, which carries `1 < h`. The h = 1 route needs its own clause from l.214/l.227. That is a drafting choice, not a paper problem.

Side item, l.214 indexing: **EDITORIAL** (not an issue). Literally, $\prod_{j=1}^t E_j(Y_{j+1})$ is $\mathcal F_{t+1}$-measurable, not $\mathcal F_t$-measurable, so "supermartingale with respect to $(\mathcal F_t)$" is off by one. The computation at l.202-211 conditions correctly on $\mathcal F_T$ for the product up to $T$ (= $e_{T+1}$), and l.227 states it correctly as $(e_t)_{t\ge2}$ with $e_t = \prod_{j=1}^{t-1}$. A competent reader shifts the index. This does not affect the h = 1 claim.

## 4. Does it threaten the conclusion?

- Final conclusion of P05: **no**. For h = 1 the claim $\mathbb E_\mathbb Q e_\tau\le1$ holds by the route in l.200-214 + l.227 (the filling-in in §6 follows the source route and uses no new idea).
- Downstream: none affected. The h = 1 uses ($\tau_\alpha$ l.238-241, the anytime-valid p-value l.246, the lag-1 simulations and case study) rely on a claim that is true and justified in the source.
- Unaffected: the h > 1 branch (`P05_S1`-`P05_S8`, already proved in `pv_work/P05ModGaps.lean`), P04 (verified separately), T01-T03.
- External parameters inherited by the h = 1 route: the same as the h > 1 route (T01 one-step e-value property, via `P04_T01Consumed`, and `P04_MixingOfStrict`, through the l.207 bound / `core6` of P04), plus the integrability premise of `HScInt`. Nothing new.

## 5. Evidence (Lean, positive)

File: `pv_work/probes/issue/P05/issue_P05_h1_reduction.lean` (imports `P05Stmt`, `PVTools`).
- `fk_one : 1 ≤ τ → fk 1 1 τ = τ` (l.458 at h = 1).
- `eT_one : eT S 1 Y p q lam t ω = Mk S 1 Y p q lam 1 t ω` (l.452 $e_t = \sum_k M^{[k]}_t/h$ at h = 1).
- `stop_filtK_one`: every `IsStopTime ℱ τ` is a `filtK ℱ 1 1`-stopping time (l.459-463 at h = 1).
- `H1Clause` (def): the l.452 clause at h = 1, k = 1 (same shape as `P05_P04Consumed` with h := 1), i.e. the content of l.214 + l.227.
- `S0_of_H1Clause : H1Clause S ℱ Y p q lam → IsStopTime ℱ τ → P05Conclusion S 1 ℱ Y p q lam τ`, i.e. `P05_S0` follows from the h = 1 supermartingale/optional-stopping clause by the specialisation of l.456-468.

Compile: `scripts/pv_lean.sh probe pv_work/probes/issue/P05/issue_P05_h1_reduction.lean` → `RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/issue_P05_h1_reduction_2.log` (last line `EXIT=0`).
Axioms (`#print axioms` in the probe, log lines 1-4): `fk_one` [propext, Quot.sound]; `eT_one`, `stop_filtK_one`, `S0_of_H1Clause` [propext, Classical.choice, Quot.sound]. All standard.
`#pv_hyp_usage Paper.P05.Issue1Probe.S0_of_H1Clause`: all hypotheses USED, including `hcl` and `hτ` (log lines 6-18).
No counterexample file is written: the claim is true for h = 1, so there is nothing to refute. `pv_work/P05_Counterexample1.lean` was **not** created.

Not checked in Lean: that `H1Clause` itself holds. By reading `pv_work/P04.lean:578-744`, the proofs of `P04_S9a`, `P04_S9b`, `P04_S9c` and `P04_S10` use their `1 < h` hypothesis only through `1 ≤ h` (`by omega`, `hh1`). So the same proof text gives `H1Clause` at h = 1, with c := 1 (via `P05_S2`). This is a reading, not compiled.

## 6. How to fill in the step (for the prover; FAIR_IMPLICIT_STEP)

Source route: l.200-211 (one-step bound) → l.214/l.227 (supermartingale) → l.227 (optional stopping, Ramdas 2020 Sec. 3).
1. Have pv-drafter / pv-gate add an h = 1 consumed clause with provenance l.214 + l.227. It can be `H1Clause` from the probe (or `P05_P04Consumed` with `1 < h` replaced by `h = 1` and provenance l.214/l.227, *not* l.452). Its applicability conditions are as in `P05_P04Consumed` (`T01.MixtureRep S ν`, `SeqSetting`, `IsStrictlyConsistent S`).
2. Close `P05_S0` by `S0_of_H1Clause` (copy the three lemmas `fk_one`, `eT_one`, `stop_filtK_one` and the theorem into `pv_work/P05.lean`; they are pure unfolding/arithmetic).
3. To discharge the clause at reconnection (rather than leave it as a parameter): repeat the text of `P04_S9a`/`S9b`/`S9c`/`S10` (`pv_work/P04.lean:578-744`) with `h = 1`, `k = 1`, `c := 1`. Concretely: stopped process $F_n = \mathrm{ofReal}(e_{\tau\wedge n})$; $\int F_{n+1}\le\int F_n$, splitting on $\{\tau\le n\}\in\mathcal F_n$ and using the one-step bound `core6` (l.207) on the complement; $\int F_0 = 1$ (empty product); Fatou (`lintegral_liminf_le`) since $F_n\to\mathrm{ofReal}(e_\tau)$ eventually constantly. The private helpers of P04 (`core6`, `Mk_range`, `filtK_eq`, `Mk_meas`) must be copied, not imported (they are private; P04.lean must not be edited). Alternatively, P04 could expose `1 ≤ h` versions in a later revision of its own files, but that is P04's owner's decision.
Mathlib cross-check (bounded case): `MeasureTheory.Submartingale.expected_stoppedValue_mono` exists (`Mathlib/Probability/Martingale/OptionalStopping.lean:40`). It is not needed if step 3 copies P04_S10.

## 7. Suggestion to the authors (minimal, optional)

Editorial only: (i) at l.447 write "For h = 1 the claim is l.214/l.227; let h > 1", or note that the argument also covers h = 1 with $M^{[1]} = e$, $f_1(\tau)=\tau$; (ii) at l.214 index the product as $\prod_{j=1}^{t-1}$ (or say "with respect to $(\mathcal F_{t+1})$"); (iii) the appendix proof heading "Proof of Proposition \ref{prop:combination}" also proves Proposition \ref{prop:stopping} and could say so. None of these changes any mathematics.

## 8. Not checked / human check

- The truth of `H1Clause` at h = 1 is argued by reading P04's proofs (§5), not compiled. It becomes Lean-checked once the prover carries out §6 step 3.
- Human check needed: no (editorial points only).

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no

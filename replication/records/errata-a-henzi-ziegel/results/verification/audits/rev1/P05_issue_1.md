# P05 issue 1 (Proposition 3.5, `prop:stopping`): ruling

- Role: pv-issue-checker (independent subagent, Claude Opus 5.5). Not the drafter, gate or prover.
- Date: Tue Oct 13 01:48:13 EDT 2026 (from `date`).
- Status: ruling complete; **not confirmed** until the counterexample review by pv-auditor passes.
- Read: `source/VSIFP_02.tex` l.74-122, 140-149, 200-252, 292, 316, 469-495; `pv_work/P05Stmt.lean`, `pv_work/P05Draft.lean`, `pv_work/P04Stmt.lean`, `pv_work/Defs.lean`; `verification/audits/P05_gate.md` (Item 7), `P05_gate_r2.md`; verdict lines of `P04_final.md`, `P04_issue_1.md`.

## 1. Source quotations (read directly)

- Statement, `source/VSIFP_02.tex:233`: "Our last theoretical result states that the e-values $e_T$ constructed above are also valid when $T$ is replaced by a stopping time $\tau$."
- `:235-240`: "Let $\tau \in \mathbb{N}$ be a almost surely finite stopping time. Then under the assumptions of Lemma \ref{prop:combination}, $\mathbb{E}_{\mathbb{Q}}(e_{\tau}) \leq 1, \ \mathbb{Q} \in \mathcal{H}_{\myS}$."
- Cited result P04, `:223-226`: $(Y_t,c_t,p_t,q_t,\lambda_t)\in\{0,1\}^2\times(0,1)^2\times[0,1]$ adapted to $\mathcal F_t$, $\lambda_t=0$ if $c_t=0$, $\myS$ strictly consistent; "for all $T \geq h + 1$, with $I_k = \{k + hs: s = 0, \dots, \lfloor (T-k)/h\rfloor - 1\}$, $e_T = \frac{1}{h}\sum_{k=1}^{h}\prod_{l\in I_k}E_{p_l,q_l;\lambda_l}(Y_{l+h})$ are $\mathcal{F}_T$-measurable and are e-values under $\mathcal{H}_{\myS; c}$."
- Proof, `:474`: "Let $\mathcal{F}_t$, $t \in \mathbb{N}$ be a filtration, $\tau$ an almost surely finite stopping time and $e_t$, $t \in \mathbb{N}$, a sequence of random variables such that $\mathbb{E}(e_t \mid \mathcal{F}_t) \leq 1$ almost surely. Then by the definition of the conditional expectation with respect to a $\sigma$-field,"
- `:476`: $\mathbb{E}(e_{\tau}) = \sum_{t=1}^{\infty}\mathbb{E}\{e_t 1(\tau=t)\} = \sum_{t=1}^{\infty}\mathbb{E}\{\underbrace{\mathbb{E}(e_t\mid\mathcal{F}_t)}_{\le 1\text{ a.s.}} 1(\tau=t)\} \le 1.$
- Definitions: e-value `:78` ($E\ge0$, $\mathbb E(E)\le1$); $\mathcal H_{\myS;c}$ `:116-118`; $c\equiv1$ gives $\mathcal H_{\myS}$ `:122`; lag $h\ge1$, $(Y_t,p_t,q_t)$ adapted to $\mathcal F_t$, $(p_t,q_t)$ forecasts for $Y_{t+h}$ `:111`; $E_{p,q;\lambda}$ `:146-148`; Brier score $(y-p)^2$ strictly consistent `:74`.
- Paper's own remark `:242`: "... when $h > 1$, the coefficients $\lambda_t$ ... for $t = t_0 - h + 1, \dots, t_0 - 1$ have already been determined in the past and may not be set to zero at $t_0$ ... This implies that the stopped e-value depends on the unknown, future observations $Y_{t_0+1},\dots,Y_{t_0+h-1}$, so it is random."
- `:220` ($h=1$): "Iterating this argument shows that the product ... is an e-value"; `:213`: $\mathbb{E}_{\mathbb{Q}}\{E_{p_T,q_T;\lambda_T}(Y_{T+1})\mid\mathcal F_T\}\le 1$ a.s. for $\mathbb Q\in\mathcal H_{\myS;c}$.

## 2. What the step consumes

- The proof (l.474-476) proves a general lemma: for **any** sequence $e_t$ with $\mathbb E(e_t\mid\mathcal F_t)\le 1$ a.s. and a.s. finite stopping time $\tau$, $\mathbb E e_\tau\le 1$. That lemma is valid (it is what obligations S1-S4 encode).
- To get Proposition 3.5 it must be applied to P04's $e_t$ (l.236 "under the assumptions of Lemma prop:combination"). The consumed instance is: P04's $e_t$, $t\ge h+1$, with P04's clause (`P05_P04Consumed`: $e_t$ is $\mathcal F_t$-measurable, $e_t\ge0$, $\mathbb E_{\mathbb Q}e_t\le 1$ for $\mathbb Q\in\mathcal H_{\myS;c}$). The source never states or proves $\mathbb E(e_t\mid\mathcal F_t)\le1$ for these $e_t$ (obligation `P05_Sbridge`).
- Since $e_t$ is $\mathcal F_t$-measurable, $\mathbb E(e_t\mid\mathcal F_t)=e_t$, so the premise demands $e_t\le1$ a.s. That is false for every non-degenerate P04 e-value (Lean: `condExp_self_of_P04`, `not_Sbridge`). So the justification fails for **every** lag $h\ge1$.
- `e_τ` means $e_{\tau(\omega)}(\omega)$: l.233 ("valid when $T$ is replaced by a stopping time $\tau$") and the first equality at l.476 ($\mathbb E(e_\tau)=\sum_t\mathbb E\{e_t1(\tau=t)\}$) both fix this reading.
- Whether the **conclusion** survives depends on the lag:
  - $h=1$: $e_T=\prod_{l=1}^{T-1}E_{p_l,q_l;\lambda_l}(Y_{l+1})$ (I_1(T) = {1,…,T-1}). The conclusion is true (§4.2, reasoning).
  - $h\ge2$: the conclusion is false (§5, Lean counterexample at $h=2$).

## 3. Classification

Primary code: **ERROR** (the printed Proposition 3.5, which via P04's assumptions covers every lag $h\ge1$, is false for $h=2$). Breakdown:

| part | code | why not the neighbouring code |
|---|---|---|
| l.235-240, case $h\ge2$ | **ERROR** | Counterexample satisfying every printed hypothesis (and P04's conclusion), with $\mathbb E_{\mathbb Q}e_\tau=5/4$. Not PAPER_ARGUMENT_GAP: the conclusion itself fails, not only the justification. Not DOMAIN_CLARIFICATION: see "reading B" below; the source's own text (l.233, l.476) fixes the reading under which it is false. |
| l.474-476 applied to P04's $e_t$, case $h=1$ | PAPER_ARGUMENT_GAP | The justification (premise $\mathbb E(e_t\mid\mathcal F_t)\le1$) does not hold for P04's $e_t$, but the conclusion is true (supermartingale / l.242 route, §4.2). Not EXPOSITION_GAP: no uncovered range; the argument itself fails. Not FAIR_IMPLICIT_STEP: the missing argument (supermartingale property + optional stopping + a limit argument for unbounded $\tau$) is a different proof, not a routine filling-in of l.476. Mitigation: the discussion at l.242 sketches a valid route for $h=1$ and bounded $\tau$. |
| l.236-238: $\mathcal H_{\myS}$ in the conclusion vs general $c_t$ in the assumptions | DOMAIN_CLARIFICATION (minor) | Reading (i) literal: claim only for $\mathbb Q\in\mathcal H_{\myS}$ ($c\equiv1$ null) while $e_t$ is built with general $c_t,\lambda_t$; reading (ii) intended: $\mathbb Q\in\mathcal H_{\myS;c}$ (as in l.226). Truth status is the same under both: true for $h=1$ (the §4.2 argument works under $\mathcal H_{\myS;c}$, factors with $c_t=0$ are $\equiv1$), false for $h\ge2$ (the counterexample has $c\equiv1$, where $\mathcal H_{\myS}=\mathcal H_{\myS;c}$). Does not threaten anything beyond the ERROR. |
| l.223 vs l.236: $\tau<h+1$, where P04's claim does not cover $e_\tau$ | FAIR_IMPLICIT_STEP | The printed formula l.224 evaluated at $T\le h$ gives $\lfloor (T-k)/h\rfloor-1<0$ for every $k\in\{1,…,h\}$ (since $T-k<h$), so every $I_k=\emptyset$ and $e_T=1$; a constant 1 is trivially an e-value and is $\mathcal F_T$-measurable. Not EXPOSITION_GAP: the range is absorbed by the printed formula itself. See §8 for how to fill it in. |
| l.476: sum from $t=1$, integrability, $\{\tau=t\}\in\mathcal F_t$, disjointness | FAIR_IMPLICIT_STEP | Standard measure theory (already noted by the gate). |
| "Lemma \ref{prop:combination}" labelling a Proposition (l.236) | EDITORIAL | Not an issue. |

**Reading B (considered and rejected as the printed reading).** l.242 describes "optional stopping at $t_0$" as setting $\lambda_t\equiv0$ for $t\ge t_0$, the stopped e-value then being the (random) value after $Y_{t_0+h-1}$ is observed; Appendix l.480-495 uses this for $\tau_{\alpha,h}$. If $e_\tau$ were read as "$e_{\tau+h-1}$ computed with $\lambda_t1\{t<\tau\}$", the statement would plausibly be true for every $h$ (§7). But the Proposition writes $e_\tau$, l.233 says "$T$ is replaced by a stopping time $\tau$", and the proof's first equality at l.476 is reading A. So the printed statement is ERROR under its own reading; reading B is recorded as the suggested correction, not as an ambiguity that saves the statement.

## 4. Does it threaten the conclusion?

### 4.1 Final conclusion of P05
**Yes.** For $h\ge2$ the printed conclusion $\mathbb E_{\mathbb Q}(e_\tau)\le1$ fails (Lean, §5). For $h=1$ the conclusion stands, but the printed proof does not establish it.

### 4.2 Case $h=1$ (reasoning, not checked in Lean; constructed by the reviewer partly following the source's own remark at l.242, not the printed proof; suggestion only, not used in any verification)
Write $f_l=E_{p_l,q_l;\lambda_l}(Y_{l+1})\ge0$, $e_T=\prod_{l=1}^{T-1}f_l$ ($e_1=1$).
- Route 1 (l.242): set $\lambda'_l=\lambda_l1\{l<\tau\}$. $\{l<\tau\}=\{\tau\le l\}^c\in\mathcal F_l$, so $\lambda'$ is adapted, in $[0,1]$, and $0$ where $c_l=0$; P04's hypotheses hold. The P04 e-value built with $\lambda'$ at time $T$ equals $e_{\tau\wedge T}$, so $\mathbb E_{\mathbb Q}e_{\tau\wedge T}\le1$ for every $T\ge2$. Since $\tau<\infty$ a.s., $e_{\tau\wedge T}\to e_\tau$ a.s., and Fatou gives $\mathbb E_{\mathbb Q}e_\tau\le1$.
- Route 2: $\mathbb E(f_T\mid\mathcal F_T)\le1$ (l.213) makes $(e_T)$ a nonnegative supermartingale; optional stopping plus Fatou gives the same.
Either route depends on P04 / the conditional one-step bound l.213 (P04: SUGGESTED CONDITIONAL, `P04_final.md`). Neither is the printed proof.

### 4.3 Downstream
- **Affected:**
  - Every use of $e_\tau$ with $h\ge2$ in the sense $e_{\tau(\omega)}(\omega)$, in particular the claim at l.252 that $p_{t_0}=\min\{1,\inf_{s\le t_0}1/e_s\}$ are anytime-valid "for all $t_0\ge h+1$" when $h\ge2$: its justification for $h\ge2$ would need P05 (or a Ville-type inequality for $e_t$), and P05 fails for $h\ge2$. **Not checked** whether the l.252 claim itself fails for $h\ge2$ (the Lean instance does not violate it: there $\sup_s e_s\in\{1,3/2\}$ with probability 1/2 each).
  - The validity claim for the $h=2,3$ stopped e-values in Section 4.2 (l.292, "validity is guaranteed") and the $\tau_{\alpha,h}$ procedure (l.248-252, Appendix l.480-495), insofar as they rely on P05. They are plausibly valid by reading B (P04 at fixed time with $\lambda'_t=\lambda_t1\{t<\tau\}$; $\tau_{\alpha,h}\le T$ is bounded), which is not P05 as printed (reasoning, not checked in Lean).
- **Unaffected:**
  - P04 (Proposition 3.4): the counterexample satisfies P04's conclusion (Lean `hP040`, proved unconditionally for this instance).
  - All $h=1$ uses: $\tau_\alpha$ (l.244-246), Section 4.1 simulations (l.261-274, $Y_{t+1}$), lag-1 results of Section 4.2; their conclusion holds by §4.2 (but P05's printed proof does not cover them).
  - The case study (l.316: "No optional stopping is applied in all e-values").
  - The general lemma at l.474-476 itself (true for sequences satisfying its premise; obligations S1-S4).

## 5. Lean evidence

File `pv_work/P05_Counterexample1.lean` (sha256 7a2501858d82102e72f3d3ad77cfb90178f5fababcda732909df8d6e8ddcfa11), namespace `Paper.P05.Issue1`, imports `P05Stmt` only.

- `PrintedClause : Prop`: P05's printed statement (l.235-240) with P04's assumptions (l.223), quantified over every $h\ge1$, $\Omega:\texttt{Type}$, filtration, data, stopping time, $\mathbb Q\in\mathcal H_{\myS}$ (`HScInt … (fun _ _ => 1) …`); conclusion `∫⁻ ofReal (eT … (τ ω) ω) ∂Q ≤ 1`. Its binders are exactly those of the gated `Paper.P05.P05_main` (gate r2 hash `th=710880581`). Extra premises (only weaken it): `P05_P04Consumed` (P04's conclusion), $\tau$ finite everywhere, the TFA $\tau\ge h+1$ a.s., integrability in `HScInt`.
- Instance ($h=2$): $\Omega=$ Bool, $\mathbb Q$ uniform; $Y_3=Y_4=1\{b\}$, other $Y_t=0$; $\mathcal F_t$ trivial for $t\le2$, everything for $t\ge3$; Brier score $S(p,y)=(y-p)^2$ (l.74); $p_t=1/4$, $q_t=3/4$, $c_t=1$; $\lambda_2=1$, other $\lambda_t=0$. Then $E_{1/4,3/4;1}(y)=2y$, $e_3=1$, $e_T=(1+2Y_4)/2$ for $T\ge4$. $\tau=3$ if $b$ false, $4$ if $b$ true.
- Hypotheses proved: `hS0` (Brier strictly consistent), `hset0` (`SeqSetting`: ranges, adaptedness, $\lambda_t=0$ if $c_t=0$), `htau0` (stopping time), `htau0_ge` ($\tau\ge3$), `hQ0` ($\mathbb Q\in\mathcal H_{\myS}$ with integrability: $\mathbb E[S(p_t,Y_{t+2})-S(q_t,Y_{t+2})\mid\mathcal F_t]$ is $0$ for $t=1,2$, $-1/2$ otherwise), `hP040` (P04's conclusion for every $T\ge3$ and **every** $\mathbb Q'\in\mathcal H_{\myS;c}$).
- `lintegral_stopped`: $\mathbb E_{\mathbb Q}e_\tau=5/4$. `not_printed : ¬ PrintedClause`.
- Scope: `printed_of_main_shape`: the type of `P05_main` (at `Ω : Type`) implies `PrintedClause`, so `not_printed` refutes the gated `P05_main`. `#pv_hyp_usage` shows the premise `Hmain` USED.
- Obstruction for the step: `SbridgeClause` encodes obligation `P05_Sbridge`; `condExp_self_of_P04` (general: P04's measurability clause gives $\mathbb E(e_t\mid\mathcal F_t)=e_t$); `not_Sbridge : ¬ SbridgeClause` ($e_4=3/2$ on $\{b\}$, $\mathbb Q\{b\}=1/2$).
- Compilation: `scripts/pv_lean.sh check P05_Counterexample1` -> `RESULT P05_Counterexample1 mode=check exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/P05_Counterexample1_2.log`; `scripts/pv_lean.sh build P05_Counterexample1` -> `exit=0 errors=0 sorry_warnings=0 … olean=pv_work/P05_Counterexample1.olean` (log `pv_work/logs/P05_Counterexample1_3.log`).
- Axiom check: probe `pv_work/probes/issue/P05/issue_P05_axioms.lean` -> `RESULT issue_P05_axioms mode=probe exit=0 errors=0` (log `pv_work/logs/issue_P05_axioms_1.log`): `#pv_axioms P05_Counterexample1: ALL STANDARD (55 declarations checked)`; `#pv_walk_decl` of `not_printed` and of `not_Sbridge`: `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`.
- General $h\ge2$ (reasoning, not checked in Lean): same construction with $Y_{h+1}=Y_{h+2}=1\{b\}$, $\mathcal F_t$ trivial for $t\le h$, $\lambda_2=1$: $e_{h+1}=1$, $e_{h+2}=(h-1+2Y_{h+2})/h$, $\mathbb E e_\tau=1+1/(2h)>1$.

Review points for the auditor: (1) `PrintedClause` vs l.235-240 + l.223 (nothing missing, conclusion not stronger); (2) the instance satisfies each hypothesis (all proved, no `sorry`); (3) no source definition excludes it: $p_t\ne q_t$, values in $(0,1)$, $Y\in\{0,1\}$, $\lambda\in[0,1]$, $\mathbb Q$ lies on the boundary of $\mathcal H_{\myS}$ for $t=1,2$ ("$\le0$" allowed, l.118); taking $\mathbb Q\{b\}=\pi\in(0,1/2)$ instead gives $\mathbb E e_\tau=1+\pi/2>1$ strictly inside the null (reasoning, not checked in Lean).

## 6. Not checked

- Whether the l.252 anytime-valid p-value claim fails for $h\ge2$.
- The $h=1$ truth (§4.2) and reading-B truth (§7) are reasoning only.
- The general-$h\ge2$ and strict-interior variants (reasoning only).

## 7. Suggestion to the authors (minimal)

1. Restrict Proposition 3.5 to $h=1$, and replace the proof at l.474-476 by one of the §4.2 routes (e.g. apply Proposition 3.4 with $\lambda'_t=\lambda_t1\{t<\tau\}$, which gives $\mathbb E e_{\tau\wedge T}\le1$, then Fatou). The premise "$\mathbb E(e_t\mid\mathcal F_t)\le1$" must be dropped: for $\mathcal F_t$-measurable $e_t$ it means $e_t\le1$.
2. For $h\ge2$, state the version actually used in l.242/Appendix: with $\lambda'_t=\lambda_t1\{t<\tau\}$, the stopped e-value $e'_{\tau+h-1}$ (Proposition 3.4's $e$ computed with $\lambda'$, evaluated at $\tau+h-1$) satisfies $\mathbb E_{\mathbb Q}e'_{\tau+h-1}\le1$. Checked by the reviewer: for $T\ge\tau+h-1$ every index $l\le\tau-1$ lies in some $I_k(T)$ and the factors with $l\ge\tau$ are $1$, so $e'_T=e'_{\tau+h-1}$; P04 gives $\mathbb E e'_T\le1$ for each $T$, and Fatou gives the claim. On the Lean instance this gives $\mathbb E=\tfrac12\cdot\tfrac12+\tfrac12\cdot\tfrac32=1$ (no contradiction).
Constructed by the reviewer, not in the source (route 1 follows the remark at l.242); suggestion only, not used in any verification.

## 8. How to fill in the FAIR_IMPLICIT_STEP for $\tau<h+1$ (for the prover; side item only)

For $1\le T\le h$ and $k\in\{1,…,h\}$: if $k\le T$ then $0\le T-k<h$, so $\lfloor(T-k)/h\rfloor-1=-1$; if $k>T$ then $\lfloor(T-k)/h\rfloor-1\le-2$. Either way $I_k=\emptyset$, every product is $1$, and $e_T=\frac1h\cdot h=1$. In Lean, `Paper.P04.Ik h T k` uses natural subtraction and `(T-k)/h = 0`, so `eT … T = 1` for `T ≤ h` (gate Item 2 already notes this). The term then contributes $\mathbb Q(\tau=T)$ in S1-S4. The TFA $\tau\ge h+1$ a.s. is therefore not needed for truth; it stays a harmless extra premise in the counterexample. This does not affect the main ruling.

## Required human check

Yes: a human should confirm that $e_\tau$ in Proposition 3.5 is meant as $e_{\tau(\omega)}(\omega)$ (reading A, as l.233 and l.476 indicate) and not the l.242 "stopped e-value" (reading B). Under reading A the statement is false for $h\ge2$; under reading B it is a different statement that the source does not print.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes

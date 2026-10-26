# P05 statement gate (Proposition 3.5, `prop:stopping`)

- Reviewer: pv-gate (independent subagent, Claude Opus 5.5); not the drafter.
- Date: Tue Oct 13 01:36:17 EDT 2026 (from `date`).
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P05Stmt.lean` 7b7cd58624df957844c95c3524045a49be85743dc8bd46f20f5f48bde1b370d7
  - `pv_work/P05Draft.lean` 049fcd0bd47e87db71a75139906b94317edf79470e901197eddb0c194563e135
  - `pv_work/notes/P05_draft_notes.md` f5419e4549ce576d3eaefb6e283ab0a5defd86c5a8d71707cebd74cf8b431bad (leads only)
  - also read: `pv_work/P04Stmt.lean`, `pv_work/P04.lean` l.553-565 (P04_main signature), `pv_work/Defs.lean` (declaration list).
- Compilation: `scripts/pv_lean.sh check P05Draft` -> `RESULT P05Draft mode=check exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/P05Draft_2.log`.

## Source quotations (read directly)

- Statement, `source/VSIFP_02.tex:235-240`: "Let $\tau \in \mathbb{N}$ be a almost surely finite stopping time. Then under the assumptions of Lemma \ref{prop:combination}, $\mathbb{E}_{\mathbb{Q}}(e_{\tau}) \leq 1, \ \mathbb{Q} \in \mathcal{H}_{\myS}$."
- Assumptions of P04, `:223-226`: $(Y_t,c_t,p_t,q_t,\lambda_t)\in\{0,1\}^2\times(0,1)^2\times[0,1]$ adapted to $\mathcal F_t$, $\lambda_t=0$ if $c_t=0$, $\myS$ strictly consistent; "for all $T \geq h+1$ ... $e_T$ ... are $\mathcal{F}_T$-measurable and are e-values under $\mathcal{H}_{\myS; c}$."
- Proof, `:474`: "Let $\mathcal{F}_t$ ... be a filtration, $\tau$ an almost surely finite stopping time and $e_t$, $t \in \mathbb{N}$, a sequence of random variables such that $\mathbb{E}(e_t \mid \mathcal{F}_t) \leq 1$ almost surely. Then by the definition of the conditional expectation ..."; `:476`: $\mathbb{E}(e_\tau)=\sum_{t\ge1}\mathbb{E}\{e_t 1(\tau=t)\}=\sum_{t\ge1}\mathbb{E}\{\underbrace{\mathbb{E}(e_t\mid\mathcal F_t)}_{\le 1\text{ a.s.}}1(\tau=t)\}\le 1$.
- Definitions: $\mathcal H_{\myS;c}$ `:116-118`; $c_t\equiv1$ gives $\mathcal H_{\myS}$ `:122`; lag $h\ge1$, $(Y_t,p_t,q_t)$ adapted `:111`; e-value `:78` ($E\ge0$, $\mathbb E(E)\le1$).
- Discussion `:242`: for $h>1$, pending $\lambda_t$ "may not be set to zero at $t_0$ ... the stopped e-value depends on the unknown, future observations". Appendix `:480-495` concerns $\tau_{\alpha,h}$ only (not used by P05's proof).

## Item 1 - Hypotheses: FAIL (repairable, see A1-A4)

- `SeqSetting ℱ Y c p q lam`, `IsStrictlyConsistent S`, `1 ≤ h` encode l.236 + l.223 + l.111: correct. Not used by the current proof route, which is itself a symptom (below).
- `τ : Ω → ℕ`, `IsStoppingTime ℱ τ`: l.236 literally "τ ∈ ℕ"; everywhere-finite is a stronger hypothesis than a.s. finite, so the Lean theorem is (slightly) weaker than the source; it cannot manufacture a paper error (a counterexample to the Lean form is one to the source). Accepted as a representation choice.
- `∀ᵐ ω ∂Q, h+1 ≤ τ ω`: TFA, approved (table below).
- **`hP04 : P05_P04Consumed S h ℱ Y p q lam` is rejected.** It is not a clause of P04 and not a hypothesis of the printed statement (l.236 assumes only "the assumptions of Lemma prop:combination"). Its third component `condExp (ℱ t) Q e_t ≤ 1` a.e. is the premise of the general lemma the proof writes at l.474; the proof never shows P04's $e_t$ satisfies it. Since `hset` makes $e_t$ $\mathcal F_t$-measurable, this component is equivalent to $e_t\le1$ Q-a.s., which is false in every non-degenerate instance (a P04 e-value with $\mathbb E e_t = 1$ and non-constant $e_t$ exceeds 1 with positive probability). Placing it among the hypotheses of `P05_main` makes the unjustified step a hypothesis and would produce a CONDITIONAL verdict that hides the gap (POLICY §1: a missing substantive assumption is not a technical detail; stop at the first unjustified step and record it). The step has to be an obligation, see A1-A4.
- No hidden hypotheses in structures/classes: `HScInt` includes `IsProbabilityMeasure` and P04's integrability premise (P04-gate-approved TFA, inherited consistently).

## Item 2 - Conclusion: PASS

`∫⁻ ofReal (eT .. (τ ω) ω) ∂Q ≤ 1` for `Q ∈ HScInt .. (fun _ _ => 1) ..` is $\mathbb E_Q(e_\tau)\le1$ for $Q\in\mathcal H_{\myS}$; $e_\tau\ge0$ (P04 clause), so the lower integral is the expectation, and it equals $+\infty$, not a junk 0, if $e_\tau$ is not integrable. Not weakened, not strengthened. Note `eT` for `T ≤ h` evaluates to 1 in Lean, but the TFA prevents that range from being used.

## Item 3 - Quantifiers, constants: PASS

`τ` is fixed before `Q`; the conclusion holds for each `Q ∈ ℋ_S`; the TFA is per `Q`. No constants. Matches l.236-238.

## Item 4 - Domains and details: PASS (with remarks)

- `ℋ_S` (c ≡ 1) vs `ℋ_{S;c}`: the statement says $\mathcal H_{\myS}$ (l.238) while the assumptions carry $c_t$ (l.236). Literal reading kept: conclusion only for `c ≡ 1`, which is the weaker claim ($\mathcal H_{\myS}\subseteq\mathcal H_{\myS;c}$). Faithful; drafter's DOMAIN_CLARIFICATION note is fine.
- Stopping time with respect to the same `ℱ` (l.205): correct.
- a.e. vs everywhere: TFA is a.e.; nonnegativity everywhere comes from the P04 clause (P04 `IsEValueUnder`). No ofReal/toReal trap in the conclusion.
- Measurability of $e_\tau$ is not part of the claim; it follows from adaptedness, no issue.

## Item 5 - Step obligations

Truth as stated (each checked mathematically):
- S0: true (subset of a null set).
- S1: true (sets `{τ=t}` measurable since `ℱ t ≤ m0`, pairwise disjoint, cover Ω; `lintegral` over a countable disjoint union). `hP04`, `hτ1` unused.
- S2: true given nonnegativity and integrability of $e_t$ (`setIntegral_condExp` on `{τ=t} ∈ ℱ t`, `condExp_nonneg`, `ofReal_integral_eq_lintegral_ofReal`). Matches l.474/476 second "=".
- S3: true given the condExp bound. Matches the underbrace at l.476.
- S4: true. Matches l.476 final "≤ 1" (implicit disjointness, probability measure).
- Main assembles from S0-S4: yes.

Ruling: the S0-S4 chain faithfully encodes the general lemma l.474-476, which is valid. But the step "P04's $e_t$ satisfy $\mathbb E(e_t\mid\mathcal F_t)\le1$" (implicit at l.236/474) has no obligation: it was moved into the hypothesis `hP04`. That step is the first one the source does not justify, and it must appear as its own obligation (A3). Under the amended encoding that obligation is **false as stated** in general (it is equivalent to $e_t\le1$ a.s.); this is the faithful record of the suspected gap, not an encoding defect. **FAIL as drafted; the amendments fix it.**

## Item 6 - External parameters / consumed clauses

| name | claimed provenance | ruling | reason |
|---|---|---|---|
| `P05_P04Consumed` (current body) | (iii)/(p) | **REJECTED** | (p) needs a location in P04; the drafter's notes say "location in P04: none". (iii) does not fit: the premise is stated explicitly at l.474 as the premise of the proof's own general lemma; what is silent is its applicability to P04's $e_t$, and that is a proof step, not an external fact. The condExp component is stronger than anything P04 gives and is false in non-degenerate cases; with `hset` it makes the target nearly immediate (`e_τ ≤ 1` a.s.), i.e. the effect is goal-shaped. The name suggests a P04 clause, which is misleading. |
| `P05_P04Consumed` (amended per A1) | (p) | approved in advance if written exactly as in A1 | Location: P04 statement l.222-227 = `Paper.P04.P04_main` conclusion `∀ T, h+1 ≤ T → P04Conclusion S h ℱ Y c p q lam T` (`pv_work/P04.lean:556-560`). Applicability: P04's hypotheses (l.223: `SeqSetting`, strict consistency, `h ≥ 1`) are exactly P05's `hset`, `hS`, `hh` (l.236); `Q ∈ ℋ_S ⊆ ℋ_{S;c}` because `c_t ∈ {0,1}` (obligation S_app, A3). Not stronger than P04. P04's own parameters (`P04_T01Consumed`, `P04_MixingOfStrict`) are inherited on reconnection, not redeclared. |

Placement and namespace: in `P05Stmt.lean`, `namespace Paper.P05`, no redeclared names: OK. No "mathlib lacks X" claim is load-bearing (`IsStoppingTime` exists; the draft compiles with it).

## Item 7 - Doubts about the source (preliminary only; dispatch pv-issue-checker)

1. `VSIFP_02.tex:474,476` (with l.236): the proof assumes $\mathbb E(e_t\mid\mathcal F_t)\le1$ a.s. for P04's $e_t$; P04 gives only $\mathbb E e_t\le1$, and since $e_t$ is $\mathcal F_t$-measurable the premise says $e_t\le1$ a.s. Preliminary: **PAPER_ARGUMENT_GAP**. The drafter's reading is the literal one (no other filtration is in play: $\tau$ must be a stopping time for the $\mathcal F_t$ used at l.476), and it is faithful. For $h=1$ the conclusion is plausibly true by a route the source does not give (nonnegative supermartingale, Fatou).
2. Same location, case $h\ge2$: the printed conclusion may be false (preliminary **ERROR candidate**, for the issue-checker to decide). Sketch: $h=2$, $e_3=(f_1+1)/2$, $e_4=(f_1+f_2)/2$ with $f_2=E_{p_2,q_2;\lambda_2}(Y_4)$. $\mathcal H_{\myS}$ controls $f_2$ only given $\mathcal F_2$. If $Y_3$ reveals $Y_4$, then $\tau=3$ on $\{f_2<1\}$-revealing paths and $\tau=4$ otherwise gives $\mathbb E e_\tau=\tfrac12\mathbb Ef_1+\tfrac12\{1+(1-\pi)(1-f_2(0))\}>1$ when $\mathbb E f_1=1$ and $\mathbb E(f_2\mid\mathcal F_2)=1$. This matches the paper's own remark at l.242. The other $t$ (λ_t = 0 or a dominance-consistent choice) still need checking for $Q\in\mathcal H_{\myS}$.
3. `:236-238`: `ℋ_S` vs the `c_t` of the assumptions: DOMAIN_CLARIFICATION (low priority); `:223` vs `:236`: $e_\tau$ undefined for $\tau<h+1$, and "Lemma" labels a Proposition: EXPOSITION_GAP / EDITORIAL.
4. `:476`: sum from $t=1$, integrability, $\{\tau=t\}\in\mathcal F_t$ not mentioned: FAIR_IMPLICIT_STEP.

The gate does not rule on whether the paper is right. The statement must not be changed to rescue the proof; A1-A4 only move the unjustified step from a hypothesis to an obligation.

## TFAs ruled on

| TFA | ruling | reason |
|---|---|---|
| `∀ᵐ ω ∂Q, h + 1 ≤ τ ω` (P05_main, S0, S1) | approved | $e_T$ is defined only for $T\ge h+1$ (l.223). The source is silent on $\tau<h+1$ and its own stopping rules use $t\ge h+1$ (l.246, 250). It excludes only the range where $e_\tau$ is undefined. Not goal-shaped. |
| integrability premise inside `HScInt` | approved (inherited) | Same justification as the P04 gate; it only makes the condExp in $\mathcal H_{\myS}$ meaningful. |
| `τ` ℕ-valued everywhere (vs a.s. finite) | approved as a representation choice | Literal "τ ∈ ℕ" (l.236); it makes the Lean claim weaker, so it cannot create a paper error. |

## Required changes

- **A1** (`pv_work/P05Stmt.lean` l.16-31): replace the docstring and definition of `P05_P04Consumed` with the faithful P04 clause, provenance (p), location P04 l.222-227 / `P04_main` (`pv_work/P04.lean:556-560`), applicability as in Item 6:
  ```lean
  def P05_P04Consumed (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
      (Y c p q lam : ℕ → Ω → ℝ) : Prop :=
    ∀ T : ℕ, h + 1 ≤ T → Paper.P04.P04Conclusion S h ℱ Y c p q lam T
  ```
  The docstring must state that the conditional bound of l.474 is **not** part of this clause.
- **A2** (`pv_work/P05Draft.lean`, `P05_main` l.22): `(hP04 : P05_P04Consumed S h ℱ Y c p q lam)` (add `c`). Nothing else in the signature or conclusion changes.
- **A3** (`pv_work/P05Draft.lean`): add these obligations, each with hypotheses `hP04` (amended), `hset`, `hS`, `hh` as needed, `Q`, `hQ : Q ∈ Paper.P04.HScInt S h ℱ Y (fun _ _ => 1) p q`, `t`, `ht : h + 1 ≤ t`:
  - `P05_Sapp`: `Q ∈ Paper.P04.HScInt S h ℱ Y c p q` (from `hset.c_mem`; FAIR_IMPLICIT_STEP, `ℋ_S ⊆ ℋ_{S;c}`);
  - `P05_Snn`: `(∀ ω, 0 ≤ eT S h Y p q lam t ω) ∧ Integrable (eT S h Y p q lam t) Q` (from the P04 clause: nonnegativity, ℱ_t-measurability with `ℱ t ≤ m0`, `∫⁻ ≤ 1`);
  - `P05_Sbridge`: `∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1`, with a docstring saying it is the step implicit at l.236/474 ("$e_t$ ... such that $\mathbb E(e_t\mid\mathcal F_t)\le1$" applied to P04's $e_t$), not justified by the source, and expected false as stated (suspected issue). The prover must not try to prove it by another route.
- **A4** (`pv_work/P05Draft.lean`, S1-S3): remove `hP04` from S1 (unused). In S2, replace `hP04` by `(h0 : ∀ ω, 0 ≤ Paper.P04.eT S h Y p q lam t ω) (hint : Integrable (Paper.P04.eT S h Y p q lam t) Q)`. In S3, replace `hP04` by `(hcb : ∀ᵐ ω ∂Q, condExp (ℱ t) Q (Paper.P04.eT S h Y p q lam t) ω ≤ 1)`. Statements are otherwise unchanged; `P05_main` then assembles S0, S1, Sapp, Snn, Sbridge, S2, S3, S4.
- Notes and the external-input register: change the provenance of `P05_P04Consumed` to (p) with the P04 location, and record the suspected issue against `P05_Sbridge`.

## Statement snapshot (copies `pv_work/probes/gate/P05/gate_P05_stmtcopy.lean`, `gate_P05_draftcopy.lean`; of the files as reviewed, before amendments)

`scripts/pv_lean.sh probe` stmtcopy: `RESULT gate_P05_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_P05_stmtcopy_1.log`
```
TYPE HASHES (current file, 1 declarations)
Paper.P05.P05_P04Consumed|def|th=3886387302|vh=239114790|bi=iieeeeeee
```
`scripts/pv_lean.sh probe` draftcopy: `RESULT gate_P05_draftcopy mode=probe exit=0 errors=0 sorry_warnings=6 nonstandard_axiom_lines=0 log=pv_work/logs/gate_P05_draftcopy_1.log`
```
TYPE HASHES (current file, 6 declarations)
Paper.P05.P05_S0|thm|th=450545156|vh=-|bi=iieeeeee
Paper.P05.P05_S1|thm|th=1921296961|vh=-|bi=iieeeeeeeeeeeee
Paper.P05.P05_S2|thm|th=3237536747|vh=-|bi=iieeeeeeeeeeeeee
Paper.P05.P05_S3|thm|th=531412518|vh=-|bi=iieeeeeeeeeeeee
Paper.P05.P05_S4|thm|th=2133614533|vh=-|bi=iiecee
Paper.P05.P05_main|thm|th=3807328605|vh=-|bi=iieeeeeeeeeeeeeeeee
```
This snapshot will be superseded after the amendments; the r2 check gives the binding one.

## Overall verdict

The main statement (conclusion, quantifiers, domains, TFA) is faithful. The consumed clause is rejected because it turns the source's unjustified step (l.474/476) into a hypothesis. Proof work may begin only after A1-A4 are made and checked in `P05_gate_r2.md`.

STATEMENT GATE: PASS_WITH_AMENDMENTS

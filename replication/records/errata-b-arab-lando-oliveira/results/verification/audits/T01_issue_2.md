# T01 issue 2: obligation S0 "every function considered is increasing" (F:174)

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent
- Status: ruling complete (formalization side). **Not confirmed** until a pv-auditor review passes; the Lean evidence below should be checked in counterexample-review mode.
- Date: Tue Oct 13 01:23:47 EDT 2026 (from `date`)
- Dispatched by the coordinator. Reported by pv-gate (`verification/audits/T01_gate.md` item 7, repeated in `T01_gate_r2.md:33`, instance h = -x) and by pv-prover (`pv_work/notes/T01_prover_notes.md:4`, `T01_S0_Gap` in `pv_work/T01ModGaps.lean:9-10`).

## 1. Source quotations (read directly from `source/SuperParetoPaper-v12.tex`)

- F:111: "``increasing'' and ``decreasing'' are taken as ``non-decreasing'' and ``non-increasing'' ... the generalised inverse of an increasing function $v$ is denoted as $v^{-1}(u)=\sup\{x\in\mathbb{R}:\,v(x)\leq u\}$ ... a function $v$ defined in $[0,+\infty)$ is said to be star-shaped if $v(0)=0$ and $\frac{v(x)}x$ is increasing."
  - The domain is $[0,\infty)$. **No codomain restriction** (no "nonnegative", no $v:[0,\infty)\to[0,\infty)$) appears anywhere in the source.
- F:171 (Theorem 2.8): "Let $X$ be \ITS\ and $h$ a continuous star-shaped function. Then $h(X)$ is \ITS." No monotonicity of $h$ is assumed.
- F:174 (proof): "Note that, as $h$ is continuous, $F_{h(X)}(x)=F_X(h^{-1}(x))$. Since $h$ is star-shaped, its inverse, $h^{-1}$, is anti-star-shaped (see Lemma~4.1 in \cite{ineq-order2024}), hence ... $h^{-1}(\tfrac{x}{\theta})\leq\tfrac{h^{-1}(x)}{\theta}$ and $h^{-1}(\tfrac{x}{1-\theta})\leq\tfrac{h^{-1}(x)}{1-\theta}$. As every function considered is increasing, we have"
- F:176-178: $F_{h(X)}(\tfrac{x}{\theta}) + F_{h(X)}(\tfrac{x}{1-\theta}) = F_X(h^{-1}(\tfrac{x}{\theta})) + F_X(h^{-1}(\tfrac{x}{1-\theta})) \le F_X(h^{-1}(x))+1$, "using (eq:sub-1x) for the last inequality" (F:180).
- F:337 (only other consumer, T03): $h$ "increasing convex and $h(0)=0$, hence $h$ is star-shaped" (monotone there).
- (The coordinator's task text cites F:180 for the sentence; the sentence is at F:174, F:180 is the end of the proof.)

## 2. Does the paper's domain of h rescue S0? (the coordinator's question)

- **No codomain restriction is printed.** F:111 only says $v$ is "defined in $[0,+\infty)$". So $h(x)=-x$ is star-shaped per F:111 ($h(0)=0$, $h(x)/x\equiv-1$ is non-decreasing) and is continuous, but it is not increasing. Under the printed definition, "every star-shaped $h$ is increasing" is false. The gate's observation is correct (Lean: `not_T01_S0_Gap`, §4).
- **Under a nonnegative reading** ($h:[0,\infty)\to[0,\infty)$, common in the reliability literature but **not printed here**), S0 would be a one-line fact: for $0<x<y$, $h(y)=y\cdot\frac{h(y)}{y}\ge y\cdot\frac{h(x)}{x}\ge h(x)$. So the domain question matters only for the literal truth of "h is increasing". As §3 shows, it does not matter for the proof.
- So S0 is **not** "covered by the domain of h". It is covered by something else: the source never consumes the monotonicity of $h$ (§3).

## 3. What is consumed at F:174-178

- The sentence "As every function considered is increasing" justifies the passage from the two inequalities $h^{-1}(\tfrac{x}{\theta})\le\tfrac{h^{-1}(x)}{\theta}$, $h^{-1}(\tfrac{x}{1-\theta})\le\tfrac{h^{-1}(x)}{1-\theta}$ to the chain at F:176-178. The functions applied in that chain are $F_X$ and $h^{-1}$. $h$ itself does not occur in it.
  - The step $F_X(h^{-1}(\tfrac{x}{\theta}))\le F_X(\tfrac{h^{-1}(x)}{\theta})$ (implicit between F:177 and F:178) needs only that **$F_X$ is increasing**. A cdf is always increasing. This is `T01_S5` (`pv_work/T01ModGaps.lean:137-142`), proved from `monotone_cdf` alone, with no hypothesis on $h$.
  - $h^{-1}$ is increasing on $[0,\infty)$ for any $h$: its defining sets $\{y: h(y)\le u\}$ grow with $u$. In any case S5 does not use this.
  - The other uses of $h^{-1}$ need no monotonicity of $h$ either. S1 (F:174, "$F_{h(X)}(x)=F_X(h^{-1}(x))$") is proved in `T01_S1` from continuity plus star-shapedness (downward-closed sublevel sets, private `sub_down`). S4 needs only that $h^{-1}$ is anti-star-shaped.
- **Where monotonicity of $h$ entered the Lean route.** It entered only through the external parameter `T01_X02Tool` (`pv_work/T01Stmt.lean:26-28`). Its docstring says it is "Specialised to continuous increasing `h` ... which is weaker than the source's use". The source states the cited fact at F:174 for star-shaped $h$: "Since $h$ is star-shaped, its inverse, $h^{-1}$, is anti-star-shaped (see Lemma~4.1 ...)", with no monotonicity premise. Because the drafter restricted the tool to monotone $h$, the assembly needed `T01_S0_Gap` to feed the tool's extra premise (`T01ModGaps.lean:199-200`). S0 is therefore an obligation that **our encoding** created. It does not correspond to a mathematical step that the source takes.
- Fair reading of the sentence: "every function considered" refers to the functions composed in the displayed chain ($F_X$, $h^{-1}$). Under that reading the sentence is true. Read as also covering $h$, the sentence is literally false, but the inference does not use that part. In both readings no step of the source's argument fails.

## 4. Evidence (Lean)

File `pv_work/probes/issue/T01/T01_issue2_S0.lean` (namespace `Paper.T01.Issue2`, `import T01ModGaps`, `import PVTools`). It imports the reviewed files unchanged: `T01ModGaps.lean` e47f76e8…c439a52 and `T01Stmt.lean` 3859de1a…974a441b, the same hashes as in `T01_issue_1.md` and `T01_gate_r2.md`.

- **(a) `not_T01_S0_Gap : ¬ T01_S0_Gap`.** S0 as encoded is false. The instance is $h=-x$: `neg_star` proves it star-shaped, `continuous_neg` proves it continuous, and $h(0)=0>-1=h(1)$. This confirms the gate. It refutes our obligation, not a printed clause of the paper.
- **(b) `T01_main_mod_S2_src`.** This is the prover's assembly `T01_main_mod_gaps` (`T01ModGaps.lean:192-222`), reproduced line for line. The only change is that S0 + S3 are replaced by `T01_X02ToolSrc := ∀ h, Continuous h → StarShaped h → AntiStarShaped (ginv h)`, which is the cited fact at the strength the source states it (F:174).
  - Its hypotheses are `T01_S2_Gap`, `T01_L01Consumed` and `T01_X02ToolSrc`. **It takes no S0.** `#pv_hyp_usage` reports all 9 binders USED.
  - `#pv_walk_decl` reaches `T01_S1, T01_S2_Gap, T01_S4, T01_S5, T01_S6` and does **not** reach `T01_S0_Gap`.
  - The private helpers `F_eq`, `real_Iic_zero` and `bdd_of_S2` are copied verbatim from `T01ModGaps.lean:13-20, 151-189`, because private declarations cannot be imported. The originals `sub_down`/`sub_eq` are reached through `T01_S1`.
- **(c) Scope evidence only, constructed by the reviewer, not in the source, and not used to verify T01: `X02Src_of_X02 : T01_X02Tool → T01_X02ToolSrc`.** The proof goes through $h^+=\max(h,0)$: $h^+$ is continuous, star-shaped (`pos_part_star`) and monotone on $[0,\infty)$ (`pos_part_mono`), and `ginv h⁺ u = ginv h u` for $u\ge0$ (`ginv_pos_part`).
  - It shows that the source-strength tool is **no stronger** than the gate-approved restricted tool. So re-encoding the tool at source strength cannot bring in a false or vacuous parameter.
  - Corollary `T01_main_mod_S2`: with the gate-approved parameters as they stand, T01 holds modulo S2 alone. Its walk also does not reach `T01_S0_Gap`.
- Compilation: `scripts/pv_lean.sh probe pv_work/probes/issue/T01/T01_issue2_S0.lean` printed `RESULT T01_issue2_S0 mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T01_issue2_S0_1.log olean=none`. The only warning is an unused variable `hx` in the copied `bdd_of_S2'`; the original has the same unused binder.
- Axioms: `#print axioms` on `not_T01_S0_Gap`, `T01_main_mod_S2_src`, `X02Src_of_X02` and `T01_main_mod_S2` gives `[propext, Classical.choice, Quot.sound]` in each case. Each `#pv_walk_decl` reports "AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false" (log lines 3-4, 13-14, 47-48).
- Hashes (sha256, `python3 scripts/pv_snapshot.py hash`): the probe d263d6a557f56b6ddd79f423c74e4e2eec772b7c2e9158e9a8a9ce3e8d3903de; the source 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294.
- No `pv_work/T01_Counterexample2.lean` was written, because there is no counterexample to a printed clause. The only refutation, (a), is of our own obligation.
- Non-monotone instance where S2 **holds** (reasoning, not checked in Lean): take $h(x)=x(x-1)$ and $X$ Pareto with $F_X(t)=\max(0,1-1/t)$.
  - $X$ is ITS, because $1-F_X(1/y)=\min(1,y)$ is concave and nonnegative, hence subadditive.
  - $h$ is continuous and star-shaped ($h(x)/x=x-1$), but it is decreasing on $[0,\tfrac12]$.
  - $F_{h(X)}(0)=P(X\le1)=0$.
  - So S0 fails on an instance that issue 1 does not cover, and (b)/(c) show that the source route still closes there, modulo S2 and the tools.

## 5. Classification: ENCODING_ERROR (formalization side; not a paper issue)

- **Why ENCODING_ERROR.** The false obligation S0 does not correspond to any step that the source takes. It was created by two encoding choices:
  - the drafter specialised the external tool `T01_X02Tool` to monotone $h$, although the source cites it for star-shaped $h$ (F:174);
  - the drafter read "every function considered" as asserting that $h$ is increasing.
  - The fidelity rule says our own representation choices must never manufacture a paper error. Lean (b) shows that the source route closes without S0 once the tool is encoded at the source's strength.
- **Why not PAPER_ASSUMPTION_GAP.** No hypothesis "h increasing" is needed by any step of the source's argument (§3, Lean (b)). There is one reservation: if Lemma 4.1 of \cite{ineq-order2024} itself requires monotone $h$, the source cites it slightly beyond its scope. Even then the cited conclusion is true for all continuous star-shaped $h$ (Lean (c), with the restricted tool as parameter), so at most a citation-scope remark (EDITORIAL) would remain. That needs a human check of the cited paper, since there is no network access.
- **Why not PAPER_ARGUMENT_GAP.** The justification given ("increasing") does yield the step that is actually taken ($F_X$ increasing, `T01_S5`). The sentence does not fail as an inference.
- **Why not DOMAIN_CLARIFICATION.** Under both readings of the codomain of $h$ (real-valued, as printed; or nonnegative), the source's argument for the inequality chain is unaffected (§2-§3). The reading changes only the truth of a claim the proof does not use.
- **Why not ERROR.** The printed Theorem 2.8 is false (issue 1), but that failure lies in $F_{h(X)}(0)=0$. The counterexample of issue 1 uses an increasing $h$. Failures of S0 add no new counterexample: either S2 also fails (e.g. $h=-x$, where $F_{-X}(0)=1$; this is issue 1), or the route closes (§4, last item).
- **Why not FAIR_IMPLICIT_STEP.** S0 is false as encoded and cannot be filled in. The fix is to remove it from the encoding (§7).
- **Distinct from issue 1?** Yes, but S0 is not a paper issue at all. Issue 1 (ERROR, $F_{h(X)}(0)=0$) stands unchanged. Its counterexample uses an increasing $h$, and its suggested fix ($h>0$ on $(0,\infty)$) would also make $h$ increasing, so no conflict arises.

## 6. Does it threaten the conclusion?

- **T01:** no. S0 contributes no failure. Theorem 2.8 still fails, through issue 1 only. With S0 removed, the source route is complete modulo exactly S2 (issue 1), `T01_L01Consumed` (upstream issue L01_issue_1) and the cited tool (`T01_main_mod_S2_src`).
- **Downstream:** none affected by S0. T03 (F:337) uses an increasing $h$ in any case.
- **Unaffected:** everything that does not use T01, listed in `T01_issue_1.md` §5, and T01's own obligations S1, S3-S6, whose statements do not involve S0.

## 7. Suggested action

- **Formalization (for the coordinator, drafter and gate; not a paper change).**
  - Drop `T01_S0_Gap` from the T01 route.
  - Re-encode the external tool at the source's strength: `T01_X02ToolSrc` as in the probe, with provenance (i), Lemma 4.1 of ineq-order2024 cited at F:174.
  - Use the assembly `T01_main_mod_S2_src`. This needs a new gate round for the changed parameter.
  - Lean (c) shows that the new parameter follows from the currently approved one, so it is not stronger. Do **not** use the reviewer's reduction (c) as a step of the verification, because it is not in the source.
  - Update `pv_work/notes/T01_prover_notes.md` (S0: ENCODING_ERROR, removed) through the prover. That file is not mine to edit.
- **Authors (optional, EDITORIAL, not an issue):** "As $F_X$ is increasing" would be more precise than "As every function considered is increasing" at F:174.

## 8. Not checked

- Whether Lemma 4.1 of \cite{ineq-order2024} assumes $h$ increasing. There is no network access, so this needs a human check (§5).
- The non-monotone instance with S2 holding (§4, last item) is reasoning, not checked in Lean.

## 9. Needs human check

Yes, briefly: look up the hypotheses of Lemma 4.1 in \cite{ineq-order2024}. If they include monotonicity, at most an EDITORIAL citation-scope note results (§5). This does not change the verdict.

ISSUE VERDICT: ENCODING_ERROR
THREATENS CONCLUSION: no


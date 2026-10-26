# L01 (Lemma 5.15, lem:xelower) — suspected issue 1: uniform-in-δ reading not reached by the printed proof

- Checker: pv-issue-checker (independent subagent, claude-opus-5-5).
- Started: Mon Oct 12 22:16:00 EDT 2026 (from `date`).
- Status: COMPLETE (Mon Oct 12 22:18:45 EDT 2026). Not yet independently reviewed; not confirmed until pv-auditor reviews it.

## 1. Source quotations (read directly)

- Statement, source/geo_erg_HMC_v3.1.tex:884-886: "If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$, it holds that $\|x_\e\|>2\|x_0\|$."
- Proof, TEX:888-897: "$\|x_\e\| = \| x_0 - \frac{\e^2}{2}\nabla U(x_0) + \e p_0 \| \geq \frac{\e^2}{2}\|\nabla U(x_0)\| - \|x_0\| - \e\|p_0\|$. Dividing by $\|x_0\|$ gives $\frac{\|x_\e\|}{\|x_0\|} \geq \frac{\e^2}{2}\frac{\|\nabla U(x_0)\|}{\|x_0\|} - 1 - \e\frac{\|p_0\|}{\|x_0\|}$. Using (\ref{eqn:explode}), we can choose an $x_0$ such that the first term on the right-hand side is larger than $6/\e^2$, and the last term can be made negligibly small as $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, which establishes the result."
- (17) eqn:explode, TEX:865-867: $\lim_{\|x\|\to\infty}\|\nabla U(x)\|/\|x\| = \infty$.
- Consumers of the δ-region:
  - Thm 5.14 proof, TEX:879: "... provided $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$ ... $\mathbb{P}(\|p_0\| \leq \|x_0\|^\delta) \to 1$ as $\|x_0\| \to \infty$" (a probability of a fixed region: δ fixed).
  - Lemma 5.16 (lem:xlower), TEX:899-901: same phrasing as L01; its proof (TEX:903-935) treats $\e\|p_0\|/\|x_\e\|$ etc. as "arbitrarily small by choosing $\|x_0\|$ large enough" (TEX:916, 930), i.e. again fixed δ.
  - Lemma 5.17 (lem:arate_0), TEX:939-943: "for any $\delta<1$ it holds that $\lim_{\|x_0\|\to\infty,\|p_0\|\leq\|x_0\|^\delta} \alpha = 0$" — explicitly δ fixed first.

## 2. The two Lean readings (pv_work/L01Stmt.lean, gated in L01_gate.md / L01_gate_r2.md)

- `Concl` (l.18-20): `∃ η, ∀ x0 p0, η < ‖x0‖ → (∃ δ, δ < 1 ∧ ‖p0‖ ≤ ‖x0‖^δ) → 2‖x0‖ < ‖x_ε‖` — η uniform in δ.
- `ConclFixedDelta` (l.24-26): `∀ δ < 1, ∃ η, …` — η = η(δ).
- State of the proof files: `L01_main_fixedDelta : ConclFixedDelta` proved along S1-S5 (pv_work/L01ModGaps.lean l.80-95); `L01_main_Gap : Prop := … Concl gU eps` left open (l.76-77).
- Gate rulings bearing on this (L01_gate.md item 3, item 5 "Assembly", item 7; carried over in L01_gate_r2.md l.29): both readings are faithful; the **verdict-bearing target is `L01_main_fixedDelta`**; failing to reach `Concl` along the printed route "is a consequence of our reading choice and must not be recorded as a paper issue"; the EXPOSITION_GAP suggestion was explicitly rejected. The prover notes (L01_prover_notes.md l.9) follow this. I agree with the gate after my own check below; the gate notes are leads, my evidence is §4.

## 3. What is consumed

- Inside the proof: display (20) (TEX:893-895) with the last term $\e\|p_0\|/\|x_0\|$; the printed reason it is harmless is "negligibly small as $\|p_0\|\le\|x_0\|^\delta$ for some $\delta<1$" (TEX:896). This reason is valid for **fixed** δ (S5, proved: ε‖p0‖/‖x0‖ ≤ ε‖x0‖^{δ−1} → 0).
- Downstream: every consumer uses the region $\{\|p_0\|\le\|x_0\|^\delta\}$ with δ fixed first (TEX:879 probability of the region; TEX:916/930 "arbitrarily small by choosing ‖x0‖ large" in L02; TEX:940 "for any δ<1" in L03). No consumer needs η uniform in δ. The consumed instance is therefore `ConclFixedDelta`, which is proved.

## 4. Evidence (Lean)

File: `pv_work/probes/issue/L01/L01Issue1Probe.lean` (sha256 865f149b055eb8293db85bb503e17155d3862b298be44d036a40fc5ca39477ee).
Compilation: `scripts/pv_lean.sh probe pv_work/probes/issue/L01/L01Issue1Probe.lean` →
`RESULT L01Issue1Probe mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L01Issue1Probe_2.log` (EXIT=0; earlier attempt _1 failed on a `field_simp` goal, fixed).
Axioms (log l.3-5): all three theorems depend only on `[propext, Classical.choice, Quot.sound]`. `#pv_hyp_usage concl_true`: d, gU, eps, heps, hexp all USED.

- (A) **Obstruction** `not_uniformS5 (eps) (heps : 0 < eps) : ¬ UniformS5 1 eps (eps/2)`: in `E 1`, for every η there are x0, p0 with ‖x0‖ = R > max(η,1), ‖p0‖ = R/2 = R^δ for δ = 1 − log 2/log R < 1, and ε‖p0‖/‖x0‖ = ε/2. So the printed justification "the last term can be made negligibly small" (TEX:896) is **false when η must be uniform in δ**: sup over admissible (δ, p0) of ‖p0‖/‖x0‖ is 1 (approached, not attained) for every ‖x0‖ > 1. The step S5 cannot be assembled into `Concl`; the prover's stop is correct.
- (B) **Positive** `concl_true : HypExplode gU → Concl gU eps` — CONSTRUCTED BY THE REVIEWER, NOT IN THE SOURCE, SUGGESTION ONLY, NOT USED IN ANY VERIFICATION. Route: S4 with B = 3 + ε; for ‖x0‖ > max(η₁,1), ‖p0‖ ≤ ‖x0‖^δ ≤ ‖x0‖ (base > 1, δ < 1), so ε‖p0‖/‖x0‖ ≤ ε; (20) then gives ratio > 3 + ε − 1 − ε = 2. Shows the uniform reading is true, so the lemma's conclusion holds under both readings.
- (C) **Scope** `concl_imp_fixed : Concl → ConclFixedDelta`: the uniform reading is the strictly stronger target; the fixed-δ one is what the proof and the consumers use.

## 5. Classification

**Primary: `ENCODING_ERROR` (formalization side, narrow scope) — not a paper issue.** What is "wrong" is not a Lean definition but our treatment of `L01_main : Concl` as a target of the paper: the source's claim, as fixed by its own proof (TEX:896) and by all three consumers (TEX:879, 916/930, 940), is the fixed-δ claim. The open gap `L01_main_Gap` exists only because we posed the stronger reading; POLICY §1: our representation choices must never manufacture a paper error. The gate already said so (L01_gate.md item 3).

Why not the neighbouring codes:
- **FAIR_IMPLICIT_STEP — no.** The proposed fill-in (ε‖p0‖/‖x0‖ ≤ ε for ‖x0‖ ≥ 1, absorbed by taking the first term > 3 + ε) is not an omitted routine step of the printed argument; it **replaces** the printed justification "negligibly small", which (A) shows is false uniformly in δ. Adopting it would be a route change (POLICY §1), so the prover must not use it, and `L01_main` must not be proved that way.
- **PAPER_ARGUMENT_GAP — no, under the fair reading.** It would be the right code only if the paper's claim were the uniform one: then the justification at TEX:896 would fail (obstruction A) while the conclusion is true (B). But the uniform reading is not the claim the source proves or uses; recording a gap against it would be manufacturing a paper error from our reading choice.
- **EXPOSITION_GAP — no.** No range or case of the intended (fixed-δ) claim is uncovered; and in any case a failing justification would be PAPER_ARGUMENT_GAP, not EXPOSITION_GAP.
- **DOMAIN_CLARIFICATION — no.** VERDICTS §2.1 requires that "the conclusion depends on the reading". Here it does not: both readings are true (`L01_main_fixedDelta` proved along the source route; `concl_true` reviewer-constructed). The ambiguous quantifier order at TEX:885 is at most an `EDITORIAL` remark (not an issue).
- **TRANSLATION_BLOCKED — no.** Nothing is blocked: the verdict-bearing statement is fully proved.

## 6. Does it threaten the conclusion?

- Lemma 5.15 itself: **no.** The fixed-δ conclusion is proved along S1-S5 with standard axioms only (L01ModGaps.lean `L01_main_fixedDelta`); the uniform reading is also true (B).
- Downstream: **no result affected.** Lemma 5.16 (L02, TEX:899-935), Lemma 5.17 (L03, TEX:939-943) and Theorem 5.14 (TEX:879) consume only the fixed-δ region; they should be connected to `ConclFixedDelta` / `L01_main_fixedDelta`, never to `Concl` / `L01_main_mod_gaps`.
- Unaffected: everything; no result needs `L01_main_Gap`.

## 7. Required handling (formalization side; no change to any reviewed file by me)

- Record L01's verdict on `L01_main_fixedDelta` (`lean_main`), as the gate already ruled.
- Do **not** list `L01_main_Gap` as an open gap of L01 or as a paper issue; label `L01_main` / `L01_main_mod_gaps` as a non-bearing alternative reading (or move them to `pv_work/superseded/`). The type of `L01_main_fixedDelta` is unchanged, so its proof is not voided and no re-gate of it is needed; the coordinator may ask pv-gate to note the retirement of `L01_main` as a target.
- Downstream drafters (L02, L03, Thm 5.14) must import the fixed-δ clause.

## 8. Suggestion to the authors (optional, editorial)

Write the lemma as "For every δ < 1 there is η < ∞ such that for all ‖x0‖ > η and all ‖p0‖ ≤ ‖x0‖^δ, ‖x_ε‖ > 2‖x0‖" (same for Lemma 5.16), matching the proof and Lemma 5.17's "for any δ<1". Checked: this is exactly `ConclFixedDelta`, proved. (Also the gate's EDITORIAL note: "6/ε²" at TEX:896 belongs to ‖∇U‖/‖x0‖, not to the first term.)

## 9. Not checked

- L02/L03/Thm 5.14 drafts were not inspected; the claim that they consume only the fixed-δ form rests on reading TEX:879, 899-935, 939-943 (above), not on their Lean statements.
- The probe (B) is evidence for the ruling only and is not a verification of anything.

## 10. Review needed

Counterexample/obstruction review by pv-auditor of `pv_work/probes/issue/L01/L01Issue1Probe.lean` (A, C) and of the classification argument in §5. Since the ruling is formalization-side, it does not move L01 to ISSUE.

ISSUE VERDICT: ENCODING_ERROR
THREATENS CONCLUSION: no

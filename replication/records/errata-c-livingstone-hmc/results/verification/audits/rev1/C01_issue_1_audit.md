# C01 issue 1: counterexample review (pv-auditor)

- Auditor: pv-auditor (Opus), Tue Oct 13 02:12:09 EDT 2026 (from `date`)
- Reviewed: ruling `verification/audits/C01_issue_1.md`; Lean `pv_work/C01_Counterexample1.lean` (sha256 60ec6bb2…b85b, same as in the ruling, rehashed with `pv_snapshot.py hash`); checker probe `pv_work/probes/issue/C01/issue_C01_axioms.lean`.
- Source read directly: TEX:208-219 (Thm 2.2), 223-227 (E(β,α)), 229-245 (Cor 2.3), 804-806 (proof of (ii)), 863-876 (Thm 5.14, (17)-(19)), 884-957 (lem:xelower, lem:xlower, lem:arate_0).
- Auditor probe: `pv_work/probes/auditor/C01/audit_C01_issue1.lean` (log `pv_work/logs/audit_C01_issue1_1.log`).

## 1. Encoding fidelity (decisive item)

| Object | Source | Lean | Judgement |
|---|---|---|---|
| (18) | TEX:868-871 "there is a fixed C<∞ such that whenever ‖y‖ ≥ 2‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖" | `Defs.HypOscillations gU := ∃ C, ∀ x y, 2‖x‖ ≤ ‖y‖ → C ≤ 2‖x‖ → 3‖gU x‖ ≤ ‖gU y‖` (Defs.lean:80-81) | Verbatim. Checked by `Iff.rfl` in my probe. |
| E(β,α) | TEX:223-226: π ∈ C¹(ℝ), ∃ M<∞, π ∝ exp(-α\|x\|^β) for \|x\|>M, α,β>0 | `C01.InExpFam` (C01Stmt.lean:26-28), π = `piDens U` = e^{-U} (TEX:320), ∃ M, c>0, π = c·exp(-α‖x‖^β) on ‖x‖>M | Faithful (d=1 as `E 1`, ‖x‖ = \|x\|; "∝" = constant c>0). Checked by `Iff.rfl`. |
| ∇U | U = -log π, ∇U its gradient (TEX:320) | `IsGradField U gU` = `HasGradientAt U (gU x) x` for all x | Faithful; the witness U = ‖x‖^{5/2} is differentiable everywhere, so no convention excludes it. |
| Refuted proposition | What TEX:806 consumes on the β>2 branch: Thm 2.2(i) needs (18) (TEX:213) | `S2Printed` = binder list of `C01_S2` (C01Draft.lean:34-35; same in C01.lean:109-110, still `sorry`) | Not stronger: it has all printed premises (class membership, gradient, β>2) and exactly (18) as conclusion. My probe checks `example : ¬(∀ (β α) (U) (gU) (hU : InExpFam β α U) (hgrad : IsGradField U gU) (hβ : 2<β), HypOscillations gU) := not_S2Printed`, using the draft's binder names; it compiles. The checker's `rfl` check also passes. |

Global vs. constructed objects: in Cor 2.3(ii), β, α, M and π are given (the class member); ∇U is determined by π; C in (18) is existential and is chosen after U. `osc_fails` quantifies C correctly (`rintro ⟨C, hC⟩`, witness x chosen depending on C). No mis-encoding is involved.

The other route was also checked: Thm 2.2(ii) (TEX:217) needs a globally bounded ∇U, which fails for β>1 because ‖∇U‖ = αβ\|x\|^{β-1} → ∞. So TEX:806 has no route other than 2.2(i) for β>2.

## 2. Instance satisfies all printed hypotheses

- Witness: β = 5/2, α = 1, U = ‖x‖^{5/2}, π = exp(-‖x‖^{5/2}), M = 0, c = 1. `witness_inExpFam` proves C¹ via `contDiff_norm_rpow`. It satisfies the form globally, so it satisfies the class even under the stronger reading of "and any x ∈ ℝ" at TEX:226. `witness_grad` is an everywhere gradient. π is integrable, so it is also a legitimate target, although S2 does not ask for that.
- 2 < 5/2 < log₂6 is proved in Lean (2^{5/2} = 4√2 < 6).
- No definition elsewhere in the source excludes it: E(β,α) is defined only at TEX:223-226, and (18) is stated only at TEX:868-871.

## 3. The counterexample is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check C01_Counterexample1` (run by me) | exit=0, errors=0, sorry_warnings=0, nonstandard_axiom_lines=0 (log `_4`) |
| `#pv_axioms C01_Counterexample1` (my probe) | ALL STANDARD (12 declarations checked) |
| `#print axioms` not_S2Printed / osc_fails / osc_holds | [propext, Classical.choice, Quot.sound] each |
| Project theorems used | none: only the gated definitions `InExpFam` (C01 gate PASS), `IsGradField`, `HypOscillations`, `piDens`, `E` (DEFS gate), plus mathlib lemmas. No earlier project theorem needs an audit record. |

The proof of `osc_fails` is general: it holds for every member with 2<β<log₂6, any α, M, c. It uses the tail formula ‖gU x‖ = αβ‖x‖^{β-1}, obtained from uniqueness of gradients, and the pair (x, 2x) with ‖x‖ beyond max(\|C\|, R), where the ratio is 2^{β-1} < 3 and ‖gU x‖ > 0. I agree with the arithmetic: 2^{β-1} < 3 ⇔ β < log₂6. `osc_holds` (β ≥ log₂6, with C = 2R+1) is also correct and covers y of either sign, since only ‖y‖ enters.

## 4. Scope

- Refutes: the implicit applicability step `C01_S2` ("every member of E(β,α) with β>2 satisfies (18)"). More strongly, `osc_fails` shows that (18) fails for **every** member with 2<β<log₂6. So the justification at TEX:806 fails exactly on β ∈ (2, log₂6).
- Does not refute:
  - Cor 2.3(ii) itself, on any range: no statement about geometric ergodicity is proved false.
  - Thm 2.2 / Thm 5.14 (T01/T02) as conditional statements.
  - lem:xelower, lem:xlower and lem:arate_0 as conditional lemmas.
  - The β ≥ log₂6 part of the (18) step, which holds by `osc_holds`.
  - The β<1 branch.
- So the classification **PAPER_ARGUMENT_GAP** (TEX:806, β ∈ (2, log₂6)) is right:
  - it is not ERROR, because the conclusion is not refuted;
  - it is not ENCODING_ERROR (§1);
  - it is not FAIR_IMPLICIT_STEP, because the printed (18) is false there;
  - it is not ASSUMPTION_GAP, because no hypothesis on π restores the cited route without shrinking the class.
- **THREATENS CONCLUSION: no** is right: the conclusion is left unestablished on that range, not shown false.
- The ruling's remarks about trajectory pairs and MALA are correctly labelled as unverified reasoning and are not used as evidence.

## 5. Suggested fix

- Option 1 (apply Thm 2.2(i) only for β ≥ log₂6): this removes the (18) failure, as confirmed by `osc_holds`. It is a scope restriction, though. For 2<β<log₂6, (ii) is then simply unproved unless the authors give another argument. The ruling says this.
- Option 2 (ratio k instead of 2 in (18)): plausible, because lem:xlower and lem:arate_0 use the factor 3 and the bracket 1-2Σ(1/3)^i, and both are kept. It is unverified, though, and the ruling correctly marks it for human check.

## 6. Status for the authors

The proof of Cor 2.3(ii) at TEX:806 appeals to Thm 2.2(i). For 2<β<log₂6 ≈ 2.585, hypothesis (18) of that theorem fails for every member of E(β,α), and this is proved in Lean with standard axioms only. The corollary's conclusion is not refuted; its justification is missing on that range.

Reason for verdict: `not_S2Printed` faithfully refutes exactly the gated obligation C01_S2 (= (18) for all of E(β,α), β>2), it is not stronger than what TEX:806 consumes, the witness satisfies every printed hypothesis, and it compiles with standard axioms only. The class is PAPER_ARGUMENT_GAP (β ∈ (2, log₂6)), and THREATENS CONCLUSION: no is right.

COUNTEREXAMPLE VALID

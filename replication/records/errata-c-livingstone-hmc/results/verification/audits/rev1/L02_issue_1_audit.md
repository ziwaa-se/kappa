# L02 issue 1: reasoning review with a check of the positive probe (pv-auditor)

- Reviewed ruling: `verification/audits/L02_issue_1.md` (ISSUE VERDICT: PAPER_ARGUMENT_GAP, THREATENS CONCLUSION: no).
- Auditor: pv-auditor (independent subagent, claude-opus-5-5). Timestamp: Tue Oct 13 01:06:11 EDT 2026 (`date`).
- Source read directly: `source/geo_erg_HMC_v3.1.tex` lines 855-944. I also searched the whole file for `explode`, `oscillations`, `Throughout` and `standing`.
- Audited files were not modified. My probes are in `pv_work/probes/auditor/L02/`.

## 1. Source facts (checked myself)

| Claim in ruling | Check | Result |
|---|---|---|
| The Lemma 5.16 statement assumes only (17) (TEX:899-901) | TEX:900: "If (\ref{eqn:explode}) holds then ..." | confirmed |
| The proof invokes (18) (TEX:930-932) | "Envoking (\ref{eqn:oscillations}) gives ‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6" | confirmed |
| (18) is a hypothesis of Thm 5.14 and Lemma 5.17 but not of Lemmas 5.15/5.16 | TEX:863-876, 885, 900, 940 | confirmed |
| No standing convention makes the §5 lemmas inherit the hypotheses of Thm 5.14 | grep: (18) appears only at TEX:213 (Thm 2.2), 869, 882, 930, 940, 957; Notation (TEX:192) has no such convention | confirmed |
| Context lines | TEX:879 "in this case"; TEX:882 "in this scenario" (these lean toward the intended setting (17)-(19)) | confirmed; see §4 |
| "Entirely analogous" for i ≥ 4 (TEX:934) | the text is as quoted | confirmed |

## 2. Positive probe: the printed statement holds under (17) alone

I copied the probe verbatim (Read/Write) to `pv_work/probes/auditor/L02/audit_L02_issue1_positive.lean`, changing only the namespace. I added two reconnection `example`s: (a) `L02_main_fixedDelta_mod_gaps gap_holds` has exactly the gated signature (L01 clause, `0 < eps`, `HypExplode`, giving `ConclFixedDelta`); (b) `L02_main_fixedDelta_Gap = (∀ … )` closes by `rfl`.

| Check | Result |
|---|---|
| Compile | `RESULT audit_L02_issue1_positive mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `pv_work/logs/audit_L02_issue1_positive_1.log`) |
| `#print axioms gap_holds` | `[propext, Classical.choice, Quot.sound]` |
| `#pv_walk_decl` | sorryAx reached: false. Project constants reached: `E`, `leapfrogStep`, `leapfrogState`, `xLF`, `HypExplode`, `L01.ConclFixedDelta`, `L02_L01Consumed`, `L02.ConclFixedDelta`, `L02_main_fixedDelta_Gap`, and the probe's own lemmas. **`HypOscillations` is not reached**, so (18) is not used. |
| Fingerprint | `L02_main_fixedDelta_Gap` vh=397542044 equals the gated `L02_main_fixedDelta` th=397542044 (`L02_gate_r2.md:53`) |
| Mathematical soundness | The recursion `x_{n+2} = 2x_{n+1} - x_n - ε²∇U(x_{n+1})` agrees with TEX:906 (`x_{2ε} = x_ε - ε²∇U(x_ε) + (x_ε - x_0)`). The probe proves it by unfolding the gated `leapfrogStep`. The induction (base: L01 clause; step: (17) at x_{k+1} with R < ‖x_{k+1}‖) is sound. |
| Scope | The probe proves the fixed-δ reading only (the verdict-bearing reading). It assumes the L01 clause, which is a consumed predecessor clause and is legitimate. |

The probe is evidence for the classification only. It is reviewer-constructed, so it must not be used to verify L02. I agree with the ruling on this point.

## 3. The (17)⇏(18) example (§4 of the ruling), checked by reasoning

The example: U(x) = ∫_0^x t³(2+sin t) dt on R (d = 1), so ∇U(x) = x³(2+sin x).

- U is C^∞, U(x) ≥ x⁴/4, and e^{-U} is integrable, so no standing regularity or integrability assumption excludes this U.
- (17) holds: |∇U(x)|/|x| ≥ x² → ∞ in both directions, because 2+sin x ≥ 1.
- (18) fails for every C. Take x = π/2+2πk > max(C, 80), so ∇U(x) = 3x³. Let y be the least point ≥ 2x with sin y = -1. Then 2x ≤ y < 2x+2π and ∇U(y) = y³.
- Comparison: 3|∇U(x)| = 9x³, and 9^{1/3} ≈ 2.0801. Since 0.0801·80 ≈ 6.41 > 2π ≈ 6.283, we get 9x³ > (2x+2π)³ > |∇U(y)|.
- The premise of (18) holds: |y| ≥ 2|x| ≥ C, because x > C ≥ C/2 (and the case C ≤ 0 is trivial).

The example is valid, and the margin is tight but correct for x > 80 (the threshold is x > 2π/(9^{1/3}-2) ≈ 78.4). Hence (18) is not available from the hypotheses of Lemma 5.16. This was not checked in Lean (by the checker or by me). By reasoning I confirm it.

## 4. Classification boundary

**PAPER_ARGUMENT_GAP vs FAIR_IMPLICIT_STEP.** I agree with PAPER_ARGUMENT_GAP.

- A FAIR_IMPLICIT_STEP is a step the source leaves out, where the omitted standard reasoning is available under the printed hypotheses. Here the source does not leave a step out. It gives an explicit reason, (18), and that reason is not among the lemma's printed hypotheses.
- The lemma's hypothesis list is explicit and deliberately differs from that of Lemma 5.17 (TEX:940 lists (17), (18), (19)). The phrases "in this case" (TEX:879) and "in this scenario" (TEX:882) explain the intent, but they do not override an explicit "If (17) holds".
- I do not adopt an inherited-hypothesis reading as a convention, because the source states none.

**PAPER_ARGUMENT_GAP vs EDITORIAL (wrong reference number).** I considered this boundary too.

- The bound at TEX:932 can be obtained under (17). Use the reverse triangle inequality on the first step, ε²‖∇U(x_0)‖ ≤ 2‖x_ε‖ + 2‖x_0‖ + 2ε‖p_0‖ (the companion of TEX:914, not printed), together with (17) at x_ε. That is a different argument, not a corrected cross-reference: (17) does not "give" the displayed ratio bound by the printed reasoning. So EDITORIAL would understate the problem.
- Severity is minor; THREATENS CONCLUSION: no is right.

**Not ERROR.** The conclusion is proved under (17) + L01 (§2), with standard axioms.

**Not PAPER_ASSUMPTION_GAP.** (18) is not necessary (§2). I agree.

**Not ENCODING_ERROR.** `HypExplode` and `HypOscillations` (`pv_work/Defs.lean:75-81`) match TEX:865-871 literally. The dependency on (18) is visible in the source text itself.

**TEX:934, i ≥ 4.** Under (17) alone the "entirely analogous" step inherits the same dependency on (18). It is correctly folded into this issue rather than raised as a separate one.

## 5. Scope and fix

**Scope.** The issue is located at TEX:930-933, plus the analogous step at TEX:934. Only the printed justification of Lemma 5.16 is affected. Lemma 5.17 (L03) and Theorem 5.14 (T02) both assume (18) explicitly, so their use of Lemma 5.16 is in a setting where the printed route is valid. The "not affected" list is correct. Also, the intermediate bounds ‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖ hold under (17) + L01 alone; this is the `key` statement in the probe, which I recompiled.

**Option A** (add (18) to the hypotheses of Lemma 5.16) is sufficient.

- By reasoning: with ‖x_ε‖ ≥ 2‖x_0‖ ≥ C, (18) gives ‖∇U(x_ε)‖ ≥ 3‖∇U(x_0)‖, which is the TEX:932 bound. The rest of the TEX:920-934 argument then goes through.
- `L02_main_fixedDelta_osc` compiles with standard axioms and no sorryAx (my probe `audit_L02_issue1_osc.lean`, log `pv_work/logs/audit_L02_issue1_osc_1.log`). I did not audit its route fidelity; that belongs to the final audit.

**Option B** (keep the statement, replace the (18) citation with an argument from (17)) is also sufficient, by the argument in §4. It is reviewer-constructed and is a suggestion only.

## 6. Not checked

- The (17)⇏(18) example in Lean (I checked it by reasoning only).
- Route fidelity of `gen` and `L02_main_fixedDelta_osc` (final audit).
- The uniform-in-δ reading `L02_main`.

REVIEW: CONFIRMED

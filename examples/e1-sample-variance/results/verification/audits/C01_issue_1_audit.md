# C01 issue 1: counterexample review (pv-auditor)

- Role: pv-auditor (Opus), counterexample-review mode. Date: 2026-10-13.
- Reviewed: `verification/audits/C01_issue_1.md`, probe `pv_work/probes/issue/C01/issue_C01_intermediate.lean`, logs `pv_work/logs/issue_C01_intermediate_1.log` (checker) and `_2.log` (my recompile).
- Source read directly: main.tex:26, 28-38 (def:mean, def:var), 50-51 (lem:shortcut), 85-92 (lem:raw), 94-100 (cor:unit).
- No audited file was modified, and no code was repaired.

## 1. Encoding fidelity (decisive item)

| Check | Source | Lean | Result |
|---|---|---|---|
| Hypothesis $n\ge2$ | :95 | `2 ≤ n` | match |
| Hypothesis $\lvert x_i\rvert\le1$ for all $i$ | :95 | `∀ i, |x i| ≤ 1` | match |
| Sample $x\in\mathbb R^n$ | :26 | `Sample n = Fin n → ℝ` (DEFS_gate PASS, hashes equal: log:11-13 vs DEFS_gate.md:47-50) | match |
| Intermediate asserted | :99 "$s^2 \le \frac1n\sum x_i^2 \le 1$", i.e. $s^2\le1$ | `sampleVar x ≤ 1` | match |
| $s^2$ | :35 $\frac{1}{n-1}\sum(x_i-\bar x)^2$ | `(1/((n:ℝ)-1)) * ∑ (x i - sampleMean x)^2` | match |
| Not stronger | | same premises as :95; conclusion is exactly the printed intermediate; probe `rfl` example (file:55-57) confirms the unfolded shape | PASS |

- Which objects are global and which are constructed: $x$ and $n$ are universally quantified by the corollary. $s^2$ and $\bar x$ are constructed from $x$ by def:var and def:mean. The intermediate is asserted for the corollary's own sample, so it is read under the corollary's hypotheses. This is the weakest fair reading, because the chain at :99 is applied to that sample.
- `chain_yields_intermediate` (built from the audited `C01_S1` and `C01_S2`) confirms that $s^2\le1$ is exactly what links 1 and 2 of the printed chain commit to.
- **No ENCODING_ERROR.**

## 2. The instance satisfies every printed hypothesis

- $n=2$ and $x_0=(1,-1)$ (`L03.x0 = ![1,-1]`). Then $2\le2$, and $|x_i|=1\le1$ (`x0_bounded`).
- By hand: $\bar x=0$, $s^2=\frac{1}{1}(1+1)=2>1$ (`x0_var`).
- No definition or convention excludes $x_0$. The global $n\ge1$ (:26) holds, and def:var needs $n\ge2$ (:33), which holds.

## 3. The counterexample is proved

| Check | Result |
|---|---|
| Recompile `scripts/pv_lean.sh probe …` | `RESULT issue_C01_intermediate mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `_2.log`) |
| `#pv_walk_decl` for all 5 theorems | closure axioms `[propext, Classical.choice, Quot.sound]`, `sorryAx reached: false` (log:2,17,31,46,61) |
| `intermediate_false` closure | Defs, `L03_Counterexample1` (`x0`, `x0_var`, `x0_bounded`, `x0_C01_intermediate_fails`), current file (log:16-29) |
| Records for reused constants | `L03_Counterexample1` constants: L03_issue_1_audit.md (COUNTEREXAMPLE VALID; names `x0_bounded`, `x0_C01_intermediate_fails`, `x0_C01_conclusion_holds`, l.35,57-58). I also read the source of `x0_var` (L03_Counterexample1.lean:32-34) here: it is a numeric simp. `C01_S1`, `C01_S2`, `C01_L03Consumed`, `Conclusion`: C01_final.md (PASS, l.33-46) and C01_gate.md. Defs: DEFS_gate.md PASS |
| `Conclusion` hashes | th=3418533756, vh=1612149043 (log:52), equal to C01_gate.md:86 |

## 4. Scope

- **Refuted:** the intermediate $s^2\le1$ asserted at :99, for samples satisfying :95, at $n=2$. The family $x_i=(-1)^i$ for even $n$ ($\bar x=0$, $s^2=n/(n-1)>1$) is correct by my hand check. It is reasoning, not checked in Lean.
- **Not refuted:** C01's printed conclusion $s^2\le2$, which holds at $x_0$ with equality (`x0_conclusion_holds`). C01's links 2 and 3 are not refuted either: they remain valid. L01, L02, P01 and P02 are unaffected. No result cites cor:unit, so there is no downstream impact.
- "Gap, not falsity" is stated correctly. The checker does not present the issue as an error in the conclusion.

## 5. Classification

- **PAPER_ARGUMENT_GAP: justified.** VERDICTS §2.1 lists "an intermediate assertion is false" explicitly under this class.
  - The false intermediate $s^2\le1$ is printed in C01's own proof text (:99), and it is false under C01's own hypotheses (:95). So it is a defect of this result itself (§1.3), not only an inherited one.
  - ERROR is correctly excluded, because the conclusion is not refuted. ASSUMPTION, EXPOSITION and DOMAIN are correctly excluded as well.
- **Own issue, separate from B01: justified, with one caveat on the argument.**
  - `no_true_premise_supports_chain` is logically trivial: any premise implying a false statement is false. The same could be said of any result that consumes a false lemma, so on its own it does not separate C01 from the generic inherited case of §1.3.
  - The decisive point is a different one: what fails is C01's **own** target $s^2\le1$, stated in C01's text. It fails whatever lem:raw says, because $s^2=2$ is attained under C01's hypotheses. Reconnection (§4.1 (iv), stage 6b) is therefore impossible for any revision of L03, and the authors must change :99 itself.
  - This differs from B01 (lem:raw:86/:91) in location and in fix, so recording both is not double counting.
  - `repaired_L03_second_link_fails` confirms that the suggested repair of L03 alone does not rescue link 2.
  - I agree with the checker that the policy point deserves a human check (C01_issue_1.md §8).
- **Conclusion not threatened: justified.** It holds at the instance. The general argument via lem:shortcut is the reviewer's own reasoning, labeled as not checked in Lean, and it is not used in any verdict. I agree with it by hand: $(n-1)s^2\le\sum x_i^2\le n$.

## 6. Suggested fix

- Chain "$s^2\le\frac1{n-1}\sum x_i^2\le\frac n{n-1}\le2$", using the repaired lem:raw. I checked it by hand: $\sum x_i^2\le n$ because $|x_i|\le1$, and $n/(n-1)\le2 \iff n\ge2$. The repaired lem:raw itself is true by lem:shortcut ($n\bar x^2\ge0$).
- The fix removes the problem. It is a suggestion to the authors only.

## 7. Effect on records

- C01 → ISSUE with `issues: [C01 issue 1 (PAPER_ARGUMENT_GAP, main.tex:99)]` and `upstream_issues: [L03 issue 1 (B01)]`.
- Clauses verified: none unconditionally. The implication from the printed lem:raw stays compiled (C01_final.md), but its premise is refuted.
- Human check: the policy point only (§5).

Reason: the encoding matches main.tex:95/:99 exactly and is not stronger than the printed text; x0=(1,-1) satisfies every printed hypothesis; the probe compiles cleanly with only the standard axioms; the intermediate s^2 ≤ 1 at main.tex:99 is refuted (PAPER_ARGUMENT_GAP, C01's own issue; the conclusion s^2 ≤ 2 is not threatened).

COUNTEREXAMPLE VALID

# L02 — issue 1 ruling (pv-issue-checker)

- **Role:** `pv-issue-checker` (independent subagent; not the drafter, not the gate of L02)
- **Date:** Wed Sep 30 19:56:43 EDT 2026 (`date`)
- **Result under check:** L02 = Lemma `lem:quot` (Lemma 2.3 in the compiled document), statement `source/main.tex:71-76`, proof `source/main.tex:78-81`
- **Suspected issue as forwarded:** the proof multiplies the inequality by `1+x` without securing `1+x>0`, while the printed domain `x ≠ -1` also contains `x < -1`; reported independently by `pv-drafter` (`pv_work/notes/L02_draft_notes.md` §6) and by `pv-gate` (`verification/audits/L02_gate.md` §7)
- **Read directly (not via summaries):** `source/main.tex:1-92` in full — notation/conventions `main.tex:26-33`, the lemma `71-76`, its proof `78-81`, the Remark `83-85`, and the other two results (`37-43`, `52-69`) to determine downstream use; `verification/RESULTS.json` (dependency fields); `pv_work/L02Stmt.lean`, `verification/audits/L02_gate.md`, `pv_work/notes/L02_draft_notes.md` (leads only, not evidence)
- **Environment:** `scripts/pv_lean.sh packages` reports `linked` (mathlib 2452 of 6305 modules compiled); no `lake build`, no `lake update`, no network was used. I modified no file outside `pv_work/L02_Counterexample1.lean`, `pv_work/probes/issue/L02/` and this report.

## 1. What the source says (verbatim)

Statement, `source/main.tex:71-76`:

```
\begin{lemma}\label{lem:quot}
For every real number $x \neq -1$ we have
\[
  \frac{x^2}{1+x} \ge x - 1 .
\]
\end{lemma}
```

Proof, `source/main.tex:78-81` (one sentence, the whole justification):

```
\begin{proof}
Multiplying both sides by $1+x$, the claim is equivalent to
$x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
\end{proof}
```

Relevant conventions, `source/main.tex:28-29`: "Throughout, $\R$ denotes the real numbers and $\Rpos$ the positive real numbers." The lemma says **"For every real number $x \neq -1$"**, so its domain is `ℝ \ {-1}`, which contains the whole ray `x < -1`. There is no global convention in the notation section restricting the variable of this lemma (the `S(x,y,z)` notation of `main.tex:30-33` is not used here), and the lemma is not stated over `\Rpos`.

Adjacent, **not** a hypothesis — `source/main.tex:83-85`:

```
\begin{remark}
Lemma~\ref{lem:quot} is used in the companion paper only for $x \ge 0$.
\end{remark}
```

This Remark has no `\label`, is not referenced by the lemma, and states how a *companion paper* uses the lemma. Per the task instruction and POLICY §1 (conventions stated in the source are adopted fairly, but our reading must not silently repair the printed claim), it is used below only as context about author intent and to delimit the scope of the refutation; it does not narrow what Lemma 2.3 claims.

## 2. What the step consumes (concrete instance)

The printed proof has exactly one non-trivial step, at `main.tex:79`: "Multiplying both sides by $1+x$, the claim is equivalent to $x^2 \ge (x-1)(x+1)$". Multiplying an inequality `A ≥ B` by `c` preserves the direction only for `c > 0` and reverses it for `c < 0`; for the asserted *equivalence* over the printed domain the step needs `1 + x > 0`, i.e. `x > -1`, which is **not** printed.

Consumed instance for the ruling, as set in the task: the single real number `x = -2`.

- `x = -2` satisfies the only printed hypothesis: `-2 ≠ -1`.
- `1 + x = -1 ≠ 0`, so the printed quotient is genuinely defined there (this is not a Lean junk-value artefact).
- `x^2/(1+x) = 4/(-1) = -4`, and `x - 1 = -3`; the printed conclusion reads `-4 ≥ -3`, which is **false**.
- The "obvious" algebraic fact the source ends with is nevertheless true here: `x^2 = 4 ≥ 3 = (x-1)(x+1)`. So the printed argument runs through to a true final inequality while the claimed conclusion is false — the break is exactly in the "is equivalent to" step.

Beyond the single witness, the failure region is exactly the lower branch: the printed inequality is **true for every `x > -1`** and **false for every `x < -1`** (both proved in Lean, §5). In particular the general form is false while the range the authors say they use (`x ≥ 0`, `main.tex:83-85`) is entirely inside the true region — this is the A.7/Theorem-3.11 pattern from the previous round, and it is why §6 below is a scope restriction, not a retraction.

## 3. Classification

**Primary code: `ERROR`** — the printed conclusion of Lemma 2.3 is false as printed, on a non-empty, non-degenerate part (an open ray) of its own printed domain. Evidence: a Lean counterexample satisfying every printed hypothesis (§5).

Why not the neighbouring classes:

- Not `PAPER_ARGUMENT_GAP`: that code is for a justification that fails while the conclusion may still be true. Here no argument can rescue the printed statement; it has counterexamples. (The sign omission at `main.tex:79` *is* a genuine argument defect and is recorded below as a secondary, contributing `PAPER_ARGUMENT_GAP`, but the primary, stronger finding is `ERROR`.)
- Not `PAPER_ASSUMPTION_GAP` as the primary code: one can describe the defect as "the hypothesis `1+x>0` is missing", and that is the shape of the minimal fix (§6). But `PAPER_ASSUMPTION_GAP` is the right primary code when the *printed claim* is defensible once the reader supplies the obviously-intended hypothesis. Here the printed claim, read as printed, is refuted by a counterexample, which is precisely the trigger for `ERROR` (VERDICTS §2). Secondary code: `PAPER_ASSUMPTION_GAP` (the needed `x > -1` is not printed).
- Not `EXPOSITION_GAP`: nothing is merely "uncovered"; the uncovered range is not a range where the result holds with worse constants — it is a range where the printed inequality is false. There are no constants to absorb anything.
- Not `FAIR_IMPLICIT_STEP`: a competent reader cannot routinely fill in `1+x>0`, because it is not available — it is false on part of the stated domain. Silently adding it would change the statement, not fill a step.
- Not `DOMAIN_CLARIFICATION`: the printed domain is unambiguous ("every real number $x \neq -1$"). The Remark at `main.tex:83-85` mentions a different, smaller range, but it speaks about the companion paper's *use*, not about this lemma's domain, so there are not two readings of the lemma's own statement. (If a reader did insist on reading the Remark as retroactively restricting the lemma, the result would be true under that reading and false under the printed one; I record this alternative explicitly, but the printed text does not support it: the Remark comes after the proof, has no label, and says "is used ... only for", not "we assume".)
- Not `ENCODING_ERROR`: the falsity does not come from our Lean representation. `x ≠ -1` is the printed side condition; at the witness `1 + x = -1 ≠ 0`, so Lean's total division equals the source's quotient there; no `ENNReal`/`toReal` truncation is involved. Mechanical confirmation that the refuted object is exactly the gated statement: the `vh` of `PrintedClause` is `4196440307`, identical to the `th` of `Paper.L02.L02_main` in the gate snapshot (`verification/audits/L02_gate.md`, "Statement snapshot"); and the `vh` of `PrintedEquivalenceStep` is `370882976`, identical to the gate's `th` for `Paper.L02.L02_S1`. So I refuted the ∀-closures of exactly the gated statements, not a paraphrase of them.
- Not `TRANSLATION_BLOCKED`: everything needed compiled; no mathlib module was missing.

## 4. Does it threaten the conclusion?

- **Final conclusion of L02 itself: yes, it fails.** The printed inequality is false for every `x < -1`. L02 as printed cannot receive a verification verdict; it is an ISSUE.
- **Downstream results inside this paper: none affected.** `verification/RESULTS.json` records `depends_on: []` for L01 and `depends_on: ["L01"]` for P01; and reading `source/main.tex:1-92` directly, `\ref{lem:quot}` occurs only once outside the lemma itself, at `main.tex:84` inside the Remark. The proof of Proposition `prop:nesbitt` (`main.tex:59-69`) uses Nesbitt's inequality and Lemma `lem:amgm` only; Lemma `lem:amgm` (`main.tex:45-50`) uses nothing. So:
  - **Unaffected:** L01 (Lemma 2.1, `lem:amgm`, `main.tex:37-50`) and P01 (Proposition 2.2, `prop:nesbitt`, `main.tex:52-69`) — neither uses Lemma 2.3, directly or transitively.
  - **Unaffected outside this paper, as far as the Remark describes it:** the companion paper's use at `x ≥ 0`. I proved in Lean that the `x ≥ 0` clause is true (`consumed_clause_holds`), and that it follows from the printed clause (`consumed_of_printed`), so the refutation does not reach that use. Caveat: I have no access to the companion paper, so I cannot verify that its use really stays in `x ≥ 0`; that claim rests on `main.tex:84` alone and is **not checked** here.

## 5. Evidence (Lean)

**File:** `pv_work/L02_Counterexample1.lean`
- sha256 (source) `17d5097369405e235d03543edc1426c1e94102837fdd7197a9062ad824f92fcc`
- sha256 (`pv_work/L02_Counterexample1.olean`) `de30ab78c67e0514bf81246fc19c6c2294698626e1492c8a0af8c965c3de5ae1`
- imports only `Mathlib.Data.Real.Basic`, `Mathlib.Tactic.{Linarith, Ring, FieldSimp, Positivity}`; it does **not** import `L02Stmt`/`L02`, is imported by nothing in the proof chain, and repairs nothing.

**Compilation (run by me, in this session):**
```
$ scripts/pv_lean.sh build L02_Counterexample1
RESULT L02_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_3.log olean=pv_work/L02_Counterexample1.olean
```
Real exit code **0**, 0 errors, 0 `sorry`. Log `pv_work/logs/L02_Counterexample1_3.log`. (Attempt 1, log `..._1.log`, failed with "unknown tactic" because `field_simp`/`positivity` were not imported; availability was then confirmed by the probe `pv_work/probes/issue/L02/issue_L02_tactics.lean`, exit 0, log `pv_work/logs/issue_L02_tactics_1.log`.)

**Axiom / sorry check (not grep):** probe `pv_work/probes/issue/L02/issue_L02_axioms.lean`, log `pv_work/logs/issue_L02_axioms_2.log`, exit 0:
```
#pv_axioms L02_Counterexample1: ALL STANDARD (21 declarations checked)
WALK module L02_Counterexample1 stopping []: 21 roots, 5208 constants reached
AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false
```
All axioms are the three allowed ones; `sorryAx reached: false`.

**Contents of the evidence file:**

| Declaration | Content | Role |
|---|---|---|
| `PrintedClause : Prop` | `∀ x : ℝ, x ≠ -1 → x ^ 2 / (1 + x) ≥ x - 1` | the clause of `main.tex:71-76` word for word; every printed hypothesis present, conclusion not strengthened. `vh=4196440307` = gate's `th` for `L02_main` |
| `witness_satisfies_printed_hypothesis` | `(-2 : ℝ) ≠ -1` | the instance satisfies the only printed hypothesis |
| `witness_lhs`, `witness_rhs`, `witness_denom` | `(-2)^2/(1+(-2)) = -4`, `(-2)-1 = -3`, `1+(-2) ≠ 0` | the computed values; denominator nonzero, so no junk value |
| **`counterexample`** | **`¬ PrintedClause`** | **the refutation** |
| `PrintedObviousFact`, `printed_obvious_fact_holds` | `∀ x : ℝ, x^2 ≥ (x-1)*(x+1)`, and it is true | the source's closing "which is obvious" is itself correct |
| `PrintedEquivalenceStep`, `equivalence_step_false` | `∀ x ≠ -1, (x²/(1+x) ≥ x-1 ↔ x² ≥ (x-1)(x+1))`, refuted | locates the break exactly at `main.tex:79` ("is equivalent to"). `vh=370882976` = gate's `th` for `L02_S1` |
| `PrintedStepUsedDirection`, `used_direction_false` | the single implication the argument actually consumes, refuted | shows the failure is not an artefact of reading "equivalent" as `↔` |
| `quot_identity` | `x²/(1+x) = (x-1) + 1/(1+x)` for `1+x ≠ 0` | scope tool only (my own algebra, not a source step) |
| `RestrictedClause`, `restricted_clause_holds` | the clause on `x > -1` is **true** | the true region |
| `fails_on_whole_lower_branch` | for every `x < -1` the printed inequality fails | the failure region is exactly `x < -1`, not just one point |
| `RestrictedEquivalenceStep`, `restricted_equivalence_step_holds` | the `main.tex:79` equivalence is valid on `x > -1` | checks that the suggested fix repairs the *proof*, not only the statement |
| `ConsumedClause`, `consumed_of_printed`, `consumed_clause_holds` | the `x ≥ 0` clause of the Remark; printed ⟹ consumed; and the consumed clause is true | `consumed_of_printed`-style scope lemma: the refutation is of something at least as strong as any consumer's reading, and it does not reach the `x ≥ 0` use |

**Review points (VERIFICATION_METHODS §5):**
1. `PrintedClause` is not stronger than the source: it is the printed universal statement with the printed hypothesis `x ≠ -1` retained and the printed conclusion unchanged (hash-confirmed equal to the gated `L02_main` type).
2. The instance `x = -2` satisfies every printed hypothesis (`witness_satisfies_printed_hypothesis`).
3. No definition or convention in the source excludes the instance: `main.tex:28-29` puts `x` in `ℝ`, the lemma says "every real number", and `-2 ≠ -1`; the only other candidate restriction, `main.tex:84`, is a Remark about the companion paper, not a hypothesis.

## 6. Suggestion to the authors (minimal change)

Replace the domain in the statement at `source/main.tex:72`:

> For every real number $x \neq -1$ we have …

by

> For every real number $x > -1$ we have …

(equivalently: "for every real $x$ with $1+x>0$"). Nothing else needs to change: the printed one-sentence proof at `main.tex:79-80` then becomes correct as written, because `1+x>0` is exactly what makes "multiplying both sides by $1+x$" an equivalence. Optionally add three words to the proof — "Multiplying both sides by the positive number $1+x$" — to make the use of the hypothesis visible.

I checked in Lean that this suggestion really suffices, on both counts:
- the statement: `restricted_clause_holds : ∀ x : ℝ, -1 < x → x^2/(1+x) ≥ x-1`;
- the printed proof step: `restricted_equivalence_step_holds`, i.e. the asserted equivalence of `main.tex:79-80` does hold for `x > -1`.

The `x ≥ 0` range mentioned in the Remark at `main.tex:83-85` lies strictly inside `x > -1` (`consumed_clause_holds`), so restricting to `x > -1` keeps everything the authors say they need, and `x > -1` is optimal: by `fails_on_whole_lower_branch` no larger subset of `ℝ \ {-1}` works. A weaker alternative fix — restricting to `x \ge 0` as the Remark suggests — also works but discards true content.

These sentences are a reviewer's suggestion, constructed by the reviewer, not present in the source; **suggestion only, not used in any verification**. No file of the L02 proof chain was modified.

## 7. Human check needed?

Not for the paper-side ruling: the refutation is a single closed arithmetic fact, fully machine-checked with standard axioms only. Two items are outside my reach and should be flagged to a human:
1. the companion paper's actual usage range (the Remark at `main.tex:84` claims `x \ge 0`; the companion paper is not in `source/`, so I could not verify it). If any companion use falls in `x < -1`, that use is broken too.
2. whether the authors prefer the `x > -1` or the `x \ge 0` restriction — an editorial choice, not a correctness question.

## 8. Not checked / out of scope

- Whether L02's Lean draft should now be closed as an ISSUE with no `main` theorem: that is the coordinator's/prover's call, not mine. I did not touch `pv_work/L02Stmt.lean`, `pv_work/L02Draft.lean`, or any L02 proof file.
- The companion paper (not part of `source/`).
- L01 and P01 were read only to determine whether they use Lemma 2.3 (they do not); no ruling on their correctness is made here.
- `quot_identity`, `restricted_clause_holds`, `restricted_equivalence_step_holds` are my own algebra, produced only to delimit the scope and to test the suggestion; they are **not** a repair of the source's proof and are used in no verification of L02.

ISSUE VERDICT: ERROR
THREATENS CONCLUSION: yes

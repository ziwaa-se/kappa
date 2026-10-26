# Comparison with a direct use of a language model: protocol

Fixed before any baseline run (see `KEYS_LOG.md` for the time and checksum). Not public until the paper is.

## Question

If a statistician gives the paper directly to a strong language model and asks it to use Lean to check the proofs,
instead of using the kit, what do they get? Does the kit find more of the known problems, raise fewer false alarms,
back its claims with better evidence, and at what cost?

## Arms

| Arm | Model | Tools | Input | Budget |
|---|---|---|---|---|
| **Kit** | kit v1.3.1 (Sonnet coordinator and writers, Opus reviewers) | its own | the paper folder | the round-1 runs already reported (no new runs) |
| **Chat** | `claude-opus-5-5` | none (`claude -p --tools ""`) | the paper's LaTeX source pasted into one message, then prompt P0 | one reply |
| **Agent** | `claude-opus-5-5` in Claude Code, no kit | file tools and `lake env lean` in a folder with the paper and a Lean 4.19.0 + Mathlib `c44e0c8e` project (the same environment as the kit); Mathlib sources readable; no network | prompt P1 | capped at the kit's round-1 cost for that paper, rounded up to the dollar; it may stop earlier |

Both baselines use the strongest model available to us, for every step; the kit uses the cheaper model for its
writing roles. The agent baseline is told how to compile Lean, so that it does not lose time on setup.

Papers: E1, E2, E3 (original version), and the published cases A, B, C in their pre-correction versions (C with the
same scope as the kit's run). One run per arm and paper, as for the kit. Runs are blind in the same way as the kit's:
no answer key, correction or kit record is readable (permission denials, checked afterwards with
`examples/tools/blind_audit.py`), no network.

A GPT model is not part of the comparison: we have no API access, and pasting into a chat interface by hand would not
be comparable in cost or time. (Optional, by the authors: paste P0 and the paper into ChatGPT and keep the reply; it
is graded like the Chat arm.)

## Prompts (verbatim)

P0 (Chat; after the paper's source):

> Above is the LaTeX source of my paper. Please use Lean 4 with Mathlib to help me check it. For each numbered result
> (theorem, proposition, lemma, corollary), tell me whether its statement and its proof are correct, give Lean 4 code
> that proves it, or a counterexample if it is false, and point out any errors in the paper.

P1 (Agent):

> The folder source/ contains the LaTeX source of my paper. Lean 4 (v4.19.0) and Mathlib are set up in this folder:
> write .lean files here and check each one with `lake env lean <file>`. There is no internet access, and no one is
> available to answer questions, so work on your own until you are done. Please use Lean to check the paper: for each
> numbered result (theorem, proposition, lemma, corollary), tell me whether its statement and its proof are correct,
> prove in Lean what you can, give a counterexample in Lean when something is false, and point out any errors in the
> paper. End with a summary that gives a verdict for each numbered result.

For case C both prompts add: "Check only Theorem 2.2, Corollary 2.3(ii), Theorem 5.14 and Lemmas 5.15–5.17; you may
use the other results of the paper without checking them." (the kit's scope).

## Grading (fixed now; applied to every arm)

**Reference.** The answer keys written before the kit's runs, plus the findings not in the keys that we confirmed by
hand (`HAND_CHECKS.md` of E1 and of cases A and B). A baseline finding that is in neither is checked by hand in the
same way and counted as correct or as a false alarm.

**Per result**, the arm's final answer is put in one of four classes:

- `OK`: statement and proof are correct (the kit's verified verdicts, conditional or not);
- `FALSE`: the statement is false;
- `PROOF`: the proof as written fails (a gap, a false step, a missing hypothesis), whatever the truth of the statement;
- `OPEN`: no conclusion, or the result was not addressed.

The reference class of a result is `FALSE` for an `ERROR`, `PROOF` for the other paper-side issue classes, `OK` for
verified results, and `OPEN` for E4-type limits (none in this comparison). A result counts as **correctly
classified** when the arm says `OK` for an `OK` result, or reports the same defect as the reference for a `FALSE` or
`PROOF` result: the same step, clause, missing condition or ambiguity. Whether it then calls the defect `FALSE` or
`PROOF` is scored separately ("nature right"), because the line between a false statement and a missing hypothesis
is often a matter of reading (e.g. a characterization missing $F_X(0) = 0$, or an interval whose endpoints are not
specified). A result with several defects in the reference counts as correctly classified if the arm reports at least
the most important one (the published error, the planted one, or the first in the reference's list). Saying `OK` for a result whose proof fails counts as a miss even if the statement is
true and the arm proved it by another argument: the question is whether the paper's proof holds.

**Known problems found**: the planted errors and gaps of E1–E3 and the published errors of A–C, by the same rule.

**False alarms**: `FALSE` or `PROOF` for a result whose statement and proof the reference (after hand checking)
finds correct.

**Evidence.** Every Lean file the arm produced (Agent: the files in its folder; Chat: the code blocks of its reply,
each saved as a file) is compiled at the pinned versions, with `#print axioms` for each theorem the arm cites. A claim
counts as **Lean-backed** when the cited theorem compiles, depends only on the three standard axioms, contains no
`sorry`, and states what the paper states (checked by reading the statement against the paper; a weaker, stronger or
different statement does not count). For the Kit arm the existing records and the offline replay are used.

**Efficiency.** Cost as reported by Claude Code; active time from the session's start and end; tokens; and cost per
correctly classified result.

**Grader.** The grading is done by the authors' assistant (Claude) with these rules and checked by the authors. The
grader knows which arm produced an answer; the compilation and axiom checks are mechanical, and every judgement of
faithfulness and every hand check is written down with its reason, so that it can be audited.

**Interruptions.** A baseline session cut off by a usage limit is not graded; it is rerun from scratch after the reset.

## Addition (2026-10-16, after the E1–E3 agent runs had finished and before any grading)

Prompted by the authors' question how a direct use of a model handles results that rest on cited or unproved
inputs, one more measure is recorded for every arm: **cited inputs disclosed**. For each numbered result whose proof
in the paper uses a cited result, a fact asserted without proof, or a clause of another result with a problem, the
arm's handling is put in one of four classes: *proved* (the arm proved the input itself, in Lean), *explicit* (the
input is a stated hypothesis or assumption and the verdict says that it depends on it), *hidden* (the input enters
through `axiom`, `sorry`, an unstated hypothesis, or a weakened statement, and the verdict does not say so), or
*unbacked* (the verdict says correct without Lean evidence for the step). The kit's records give its classes
directly. This measure was not in the protocol fixed at 14:54; it is reported as an addition.

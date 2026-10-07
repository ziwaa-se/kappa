# Verdict and classification rules (shared by all roles; binding)

This file defines three things:
- the **four-class verdict** for each numbered result;
- the **classification** of each issue, answering "whose side is at fault";
- the registration rules for **external inputs**.

Verdicts are based on evidence only, never on confidence.

---

## 1. Result-level verdicts: each numbered result belongs to exactly one class

### 1.1 UNCONDITIONAL — verified unconditionally

All of the following hold:

1. The statement received PASS from an **independent gate** (`verification/audits/<ID>_gate.md`).
2. The **whole statement** (all clauses) has been proved in Lean along the **source's proof route**.
   - The gated declarations in the final file match the gate snapshot (compared with `#pv_type_hashes`). The comparison covers types, binder annotations, and the content hash of each `def`.
3. All compilation checks are clean:
   - `scripts/pv_lean.sh build` exits with code 0, with no `sorry`;
   - `#pv_axioms` reports all STANDARD;
   - the `#pv_walk` closure contains no `sorryAx`, and the only axioms are `propext`, `Classical.choice`, `Quot.sound`.
4. The theorem signature has **no** external tool parameters, and there is no provenance debt recorded in words.
5. The **independent final audit** gives PASS (`<ID>_final.md`). It includes an infrastructure check: every earlier in-project theorem in the closure has its own individual PASS record.
6. **Non-vacuity**: the hypothesis class has been instantiated with a concrete witness and compiled; or the final audit states why this is not needed.

### 1.2 CONDITIONAL — verified conditionally

Items 1, 2, 3, 5 and 6 above hold, but at least one of the following is true:

- the theorem signature carries ≥1 **visible parameter**: a registered external input (i)–(v), or a consumed clause (p) of a predecessor result that has not yet been reconnected, named `<ID>_<PredID>Consumed`;
- there is **provenance debt** recorded in words (e.g. the compiled proof of some dependency did not follow the source route);
- the statement has a part that is **not encoded** (`unencoded` field).

**A gap hypothesis can never be the basis for verified conditionally.** Gaps are recorded in the result's `gaps` field and do not count as external inputs. A result with gaps can only be ISSUE or UNFINISHED.

Every condition must be listed individually, together with **which step and which clause** uses it (confirmed by the final audit's proof-term walk).

**Conditions checked by a person (v1.3).** When a person has checked an external input (for example a cited theorem against the literature), record it with `python3 scripts/pv_status.py human-check <ID> --by <who> --how <against what>`. The result stays **CONDITIONAL**: the Lean proof still assumes the condition, and a person's check is a different kind of evidence from the Lean kernel's. The progress table and the report list such results as "verified conditionally; conditions checked by a person", with who, when and how. A result becomes UNCONDITIONAL only when the condition itself is proved in Lean and connected, as in the reconnection of stage 6b. Record a human check only when the user states in chat who checked which condition and how; never infer it.

Mixed cases:
- **Some clauses are unconditional**: the whole item is still recorded as CONDITIONAL, stating which clauses are unconditional.
- **Part of the statement is not encoded** (e.g. an external assertion inside "in particular"): if the main statement is proved, it may still be recorded as CONDITIONAL, but it must state **"cannot be reported as fully verified"** and list the parts that are not encoded.

### 1.3 ISSUE — issue recorded

The statement or proof of this result **itself** has at least one registered issue, **confirmed by independent review**, that meets the evidence standard of §3. Confirmation means: a counterexample review gives `COUNTEREXAMPLE VALID`, or a reasoning review gives `REVIEW: CONFIRMED`. The issue's class is one of:
- `ERROR`
- `PAPER_ARGUMENT_GAP`
- `PAPER_ASSUMPTION_GAP`
- `EXPOSITION_GAP`
- `DOMAIN_CLARIFICATION`

Rules:
- **ISSUE takes precedence.** When this result itself has an issue, record ISSUE even if other clauses are verified, and state which clauses are still verified (and under what conditions).
- **An issue in a predecessor result does not make this result ISSUE.** This result is instead made conditional on the predecessor's **exact consumed clause** and recorded as CONDITIONAL, with the predecessor's issue numbers noted in `upstream_issues`; these issues are **not** written into this result's `issues`.
- The **downstream impact** must be stated: which results are affected, which are not, and why.

### 1.4 UNFINISHED — unfinished

Anything not in the three classes above is unfinished. It must state **where it stopped**: the stage, the specific step, and the reason. The reason codes and the allowed "stage × reason" combinations are in a single table at the start of `PIPELINE.md`; this file does not list them separately.

A suspected issue that review failed to confirm (`ISSUE_UNCONFIRMED`) is also unfinished. It goes on the human-check list but does not count as a paper issue.

**Unfinished is never counted as a paper error.**

---

## 2. Issue classification: every issue must have one primary class, answering "whose side is at fault"

### 2.1 Paper side (makes the result ISSUE)

| Code | Question it answers | Meaning | Minimum evidence |
|---|---|---|---|
| `ERROR` | The printed conclusion itself is false | There is a counterexample satisfying **all printed hypotheses** | Preferably an independently reviewed Lean counterexample; otherwise explicit reasoning, labeled "reasoning, not checked in Lean" |
| `PAPER_ARGUMENT_GAP` | **Where the existing proof goes wrong** | The justification given for some step does not hold: the cited tool does not apply, an intermediate assertion is false, or the reasoning is invalid. The conclusion itself may still be true | Point to the source sentence, what the step needs, and why the given justification does not yield it; a Lean proof of the obstruction is even better |
| `PAPER_ASSUMPTION_GAP` | **A condition is missing, so the step cannot be derived** | The step needs a hypothesis that the source does not print and that cannot be fairly derived | Name the missing hypothesis; preferably attach an example showing that without it the step cannot be derived (or is false) |
| `EXPOSITION_GAP` | The conclusion is true, but the source does not cover some range or case | E.g. no argument is given for the range "n < n₀" | State the missing range, and why it cannot be absorbed into the constants |
| `DOMAIN_CLARIFICATION` | The domain or object is ambiguous, and the conclusion depends on the reading | E.g. periodic versus non-periodic readings | Give both readings and whether the result holds under each |

### 2.2 Not issues (recorded, but do not affect the verdict)

| Code | Meaning |
|---|---|
| `FAIR_IMPLICIT_STEP` | A step a competent reader would routinely fill in. Adopt it as usual, and state how it is filled in |
| `EDITORIAL` | Typos, inconsistent notation, ordering problems |

### 2.3 Formalization side (**mistakes made in writing the proof in Lean, or inability to write it**; never a paper issue)

| Code | Meaning | Handling |
|---|---|---|
| `ENCODING_ERROR` | Our Lean statement or definition does not match the source (missed by the gate) | Fix it, re-gate, and record it; the existing proof is void |
| `TRANSLATION_BLOCKED` | Missing library interface, technical difficulty, failure to compile | The result stays UNFINISHED; state the goal it is stuck on |
| `TECHNICAL_FORMALIZATION_ASSUMPTION` (TFA) | An encoding choice approved by the gate, e.g. measurability, or positivity derivable from context | Must have a justification; list each one; must not mask substantive assumptions |

**A compilation failure by itself is never evidence of a paper error.**

---

## 3. Evidence standard for issues

1. **A counterexample refutes only the one clause it targets.**
   - It must satisfy **all** printed hypotheses of that clause.
   - Its Lean encoding must not be **stronger** than the printed clause; otherwise it refutes only a stronger statement we wrote ourselves. This is confirmed item by item by independent review.
2. Distinguish "**the proof has a gap**" from "**the theorem is false**"; never present the former as the latter.
3. Every issue must record the following:
   - the primary class code;
   - the `file:line` of the source sentence;
   - exactly what fails;
   - the path to the Lean evidence, or the statement "reasoning, not checked in Lean";
   - the downstream results that are affected and those that are **not affected**;
   - any recorded suggested fix (it may come only from the auditors or reviewers; the coordinator must not draft its own);
   - whether a human check is needed.
4. **A new argument constructed by the reviewers themselves** (e.g. a better bound not in the source) serves only as a "suggestion to the author". It **never enters any verification verdict**.
5. A partial pass is not a pass of the whole item. A conditional theorem is not an unconditional theorem. `#print axioms` showing only the three standard axioms does **not** remove theorem parameters.

---

## 4. Registration rules for external inputs (visible parameters)

Mathematical content that the source uses but that this project does not prove in Lean is always written as `def ToolName : Prop := …`, as an explicit premise of the theorem. **Never write it as an `axiom`.**

### 4.1 Provenance type: each one must be labeled

| Type | Meaning |
|---|---|
| (i) | An external result explicitly cited by the source (give the `\cite` location) |
| (ii) | A fact the source asserts without proof |
| (iii) | Something the source **never states** but the proof silently uses (must be prominently flagged) |
| (iv) | A clause of one of the source's own lemmas, where that lemma's proof has a recorded issue |
| (v) | A standard fact with no interface in the pinned mathlib |
| (p) | A **consumed clause** of a predecessor result in the paper, used while the predecessor is not yet fully proved, named `<ID>_<PredID>Consumed`. Once the predecessor passes the final audit, it must be reconnected (`PIPELINE.md` stage 6b); if the predecessor ends up ISSUE or UNFINISHED, it counts as (iv) |

A **gap hypothesis** `<ID>_S<k>_Gap` is not an external input. It appears only in `<ID>ModGaps.lean`, is recorded in the result's `gaps` field, and is **not** registered in `external_tools`.

### 4.2 Writing requirements

- **Specialize only in the way the source uses it.** It may be **weaker** than the literature's result (extra premises, special cases only), never stronger.
- **No "goal-shaped" parameters.** A parameter must not contain this result's conclusion, nor an intermediate estimate that first appears in this result's proof.
- **"mathlib does not have it" must have evidence.** Use `#check` or search in `.lake/packages/mathlib`, and record the names searched and the results. Judging "it does not exist" from memory is often wrong (LESSONS 1).
- The **exact consumed clause** of a **predecessor result** (the paper's own lemma A) may be used as a parameter when checking B. But you must not assume B, must not invent a version stronger than A, and must not derive B from contradictory premises.
- **Do not re-prove external theory that the source only cites without giving a proof.** Write it as a parameter and leave it to human check.
- **Do not spend large numbers of tokens building infrastructure just to save one parameter.**
  - What the paper **proves itself** must be proved, because that is exactly what is being checked.
  - A standard fact that the paper only **cites or silently uses** is written as a (v) parameter if proving it would need a lot of infrastructure.
  - Give priority to completing the paper's numbered results.

**Where to register**: the machine-readable registry is `external_tools` in `RESULTS.json`, and `pv_status.py validate` checks that every condition is registered; detailed descriptions go in `verification/EXTERNAL_TOOLS.md`, whose table can be generated with `python3 scripts/pv_status.py tools`. Each parameter must state clearly:
- Lean name and `file:line`;
- its mathematical meaning in one sentence;
- provenance type and location in the source;
- users (which result, which clause);
- the review judgment;
- the specific points needing human check.

**Priority of the human-check worksheet** (used by `/pv-report`):

From highest to lowest risk:

| Priority | Includes |
|---|---|
| A | (iv), and (p) that could not be reconnected and whose predecessor has an issue: clauses of the paper's own lemmas whose proofs have problems. **Most in need of mathematical checking** |
| A′ | (iii): never stated in the source. Flag prominently, and suggest that the author add it to the text |
| B | (i) whose attribution or numbering is doubtful |
| C | (ii): facts the source asserts without proof |
| D | Remaining (i): explicitly cited theorems; only need to confirm that the Lean specialization has not become stronger |
| E | (v): standard facts that merely lack an interface in mathlib |

---

## 5. Reporting rules

- The header counts must equal the sum of the per-row verdicts, and the four classes must sum to the total number of numbered results.
- When any visible parameter or not-encoded part exists, you **must not** claim the whole paper is fully verified, and must not claim Level 4.
- The progress table is in English so it can be screenshotted and shared; the body text may be in whichever language the user prefers.
- Always take timestamps from the `date` command; never estimate them.

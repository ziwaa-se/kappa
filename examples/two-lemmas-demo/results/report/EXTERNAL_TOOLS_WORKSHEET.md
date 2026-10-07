# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

**For this paper, there is nothing to check in this worksheet.** Both numbered results (Lemma 1, Lemma 2) use **zero external parameters**: `RESULTS.json`'s `external_tools` array is empty, both `pv_work/L01Stmt.lean` and `pv_work/L02Stmt.lean` are machine-confirmed to declare 0 constants, and the registry table in `verification/EXTERNAL_TOOLS.md` has no rows. The source cites no external literature (`\cite` occurs nowhere in `source/demo.tex`, confirmed by a full read of all 29 lines).

Two *candidates* were considered during drafting and resolved **before** reaching the gate — neither ever became a registered external input, so neither appears as a checkable row below. They are recorded here only for transparency (full detail: `verification/EXTERNAL_TOOLS.md` "Candidates from inventory", `verification/report/work/external_tools.md`):

1. `sq_nonneg` (a real square is `\ge 0`, used in Lemma 1's proof at `source/demo.tex:17`) — not a type (v) item at all, since mathlib already has a direct interface (`#check sq_nonneg` succeeds); cited directly in the Lean proof term instead of being declared as a parameter.
2. The "same sign ⇒ nonnegative product" step (used in Lemma 2's proof at `source/demo.tex:25-26`) — this is the proof's own single substantive internal step, not content imported from outside, so it was encoded as a step obligation of Lemma 2's own proof rather than as an external parameter. It turned out to be false; see `AUTHOR_REPORT.md` §4.1 and `verification/BLOCKERS.md` B1 — this is a recorded **paper issue**, not an external-input check.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order (which determines what the constants depend on), every hypothesis, the constants in the conclusion.
3. **Notation.** Not applicable to this paper — both lemmas use only ordinary real-number notation (`+`, `-`, `\cdot`, `\ge`), no measure-theoretic or extended-real notation occurs.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| *(none)* | — | — | — | — |

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected. These most need a mathematical check.
- **A′**: (iii) never stated in the source, but silently used by the proof. Flag these prominently; suggest that the authors add them to the text.
- **B**: (i) with doubtful attribution or numbering.
- **C**: (ii) facts the source asserts but does not prove.
- **D**: the remaining (i) explicitly cited theorems; only confirm that the Lean specialization has not become stronger.
- **E**: (v) standard facts that merely lack an interface in mathlib.

Gap hypotheses are not external inputs and are not listed here. None exist in this project (neither result produced a `<ID>ModGaps.lean` file).

---

## Level A / Level A′ / Level B / Level C / Level D / Level E

**No rows in any level.** This paper has no external inputs of any provenance type (i)-(v) or (p). (Lemma 2's B1 issue is a paper-side `ERROR`, adjudicated in `AUTHOR_REPORT.md` §4.1 and `verification/BLOCKERS.md`, not an external input awaiting a person's check.)

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| *(none)* | — | Both lemmas use only plain real-number arithmetic; no paper-specific notation is introduced. |

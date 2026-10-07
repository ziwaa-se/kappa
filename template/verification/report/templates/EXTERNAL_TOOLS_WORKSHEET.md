# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order (which determines what the constants depend on), every hypothesis, the constants in the conclusion.
3. **Notation.** `∫⁻` is an integral with values in `[0,∞]`; `ENNReal.ofReal` truncates negative numbers to 0; ...

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected. These most need a mathematical check.
- **A′**: (iii) never stated in the source, but silently used by the proof. Flag these prominently; suggest that the authors add them to the text.
- **B**: (i) with doubtful attribution or numbering.
- **C**: (ii) facts the source asserts but does not prove.
- **D**: the remaining (i) explicitly cited theorems; only confirm that the Lean specialization has not become stronger.
- **E**: (v) standard facts that merely lack an interface in mathlib.

Gap hypotheses are not external inputs and are not listed here. They are explained under the corresponding issue in AUTHOR_REPORT §4.

---

## Level A

### #<n> `<LeanName>`: <one sentence>

- **Source**: `source/…:line`
- **Why it needs checking**: ...
- **Mathematical content**: ...
- **Suggested checking route** (taken from the proof sketch in the audit records): ...
- **Used by**: ...
- **Lean definition** (`pv_work/…:line`, quoted verbatim):

```lean
def … : Prop := …
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level A′ / Level B / Level C / Level D / Level E

(Same format as above. Levels D and E may be combined into one table.)

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|

# Registry of external inputs (visible parameters)

For the rules see `verification/rules/VERDICTS.md` §4. Each parameter is a `def … : Prop`, used as an explicit hypothesis of a theorem, and **never written as an axiom**.

Provenance types:
- (i) explicitly cited in the source;
- (ii) asserted in the source but not proved;
- (iii) **never stated in the source**;
- (iv) a clause of one of the source's own lemmas whose proof has a recorded issue;
- (v) a standard fact with no interface in the pinned mathlib;
- (p) the consumed clause `<ID>_<PredID>Consumed` of a predecessor; it must be reconnected once the predecessor is proved.

Gap hypotheses `<ID>_S<k>_Gap` are **not** registered here; they are recorded in each result's `gaps` field. The machine-readable registry is `external_tools` in `RESULTS.json`; the table below can be generated with `python3 scripts/pv_status.py tools`.

| ID | Lean name (file:line) | Meaning in one sentence | Type | Source location | Used by (result/clause/step) | mathlib search evidence | Audit judgment | Human check points |
|---|---|---|---|---|---|---|---|---|

## Provenance debt recorded in words (not Lean hypotheses)

| Debt | Content | Affected | Not affected |
|---|---|---|---|

## External assertions not encoded

| Assertion | Source location | Impact |
|---|---|---|

# E4 "Three facts about the empirical distribution function": answer key

Written before the run, kept outside the run folder, never copied into it. The point of this paper is the boundary of
the pinned Mathlib (revision `c44e0c8e`): what the kit does when a statement or a step needs theory the library does
not have.

| No. | Result | Expected verdict | Expected classification / inputs | Also acceptable | Not acceptable |
|---|---|---|---|---|---|
| 2.1 | $F_n$ nondecreasing; $nF_n(t) \in \{0,\dots,n\}$ | UNCONDITIONAL | — | — | anything else |
| 2.2 | Glivenko–Cantelli: $D_n \to 0$ a.s. for i.i.d. $X_i$ | CONDITIONAL | the statement can be written with Mathlib's independence, identical distribution and almost-sure convergence; the proof only names a standard theorem, without a citation, so the input is of provenance (v) if Mathlib has no interface for it (searched and recorded), or (ii) | an input labelled (i) if the kit treats the named theorem as cited; UNFINISHED `TRANSLATION_BLOCKED` only if the report names the missing interface needed to *state* the result | UNCONDITIONAL (the paper gives no proof to check); an issue |
| 2.3 | Kolmogorov–Smirnov limit law | UNFINISHED, `TRANSLATION_BLOCKED` | stating the result needs a Brownian bridge (and the law of its supremum), which the pinned Mathlib does not provide; the report should say what is missing and where the check stopped | CONDITIONAL, if the drafter states the cited theorems with the Brownian bridge as an explicit abstract parameter and the gate accepts that encoding as faithful; the report must then say that the limit object is a parameter, not a Mathlib construction | an issue; UNCONDITIONAL |

What this paper does not test: `BUDGET_EXHAUSTED` (the proofs are either trivial or absent; that stop reason can only be
reported where it happens).

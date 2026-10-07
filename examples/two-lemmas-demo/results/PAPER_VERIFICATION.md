# Checklist of all numbered results (in PDF numbering order)

**2 numbered results: 1 verified unconditionally, 0 verified conditionally, 1 with recorded issues, 0 unfinished (2026-10-01 00:35).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 1 | 1 | L01 | Verified unconditionally | Lemma 1 (a^2+b^2 >= 2ab) verified unconditionally: both source steps (ring identity; sq_nonneg) hold, no external parameters, equality tight at a=b. |
| Lemma 2 | 1 | L02 | Recorded issue | Lemma 2 (x^2 >= x for all real x) has a recorded ERROR: false on 0<x<1, witness x=1/2, confirmed by an independently reviewed Lean counterexample (B1). Does not affect L01. |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

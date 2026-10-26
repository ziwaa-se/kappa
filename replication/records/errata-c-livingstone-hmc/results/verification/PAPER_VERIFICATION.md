# Checklist of all numbered results (in PDF numbering order)

**6 numbered results: 3 verified unconditionally, 2 verified conditionally, 0 with recorded issues, 1 unfinished (2026-10-13 11:45).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 5.15 |  | L01 | Verified unconditionally | Lemma 5.15 verified unconditionally; no external parameters |
| Lemma 5.16 |  | L02 | Verified unconditionally | Lemma 5.16 verified unconditionally (reconnected to L01) |
| Lemma 5.17 |  | L03 | Verified unconditionally | Lemma 5.17 verified unconditionally (reconnected) |
| Theorem 5.14 |  | T02 | Verified conditionally | Theorem 5.14 verified; conditional on Prop35, GaussFacts, Prop35Rand |
| Theorem 2.2 |  | T01 | Unfinished | Thm 2.2 verified conditionally for deterministic L; random-L part (i) unfinished because of a formalization-side encoding error (not a paper issue). |
| Corollary 2.3 |  | C01 | Verified conditionally | Cor 2.3(ii) verified (conditional on Thm 2.2 clause); part (i) not encoded |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

# Checklist of all numbered results (in PDF numbering order)

**4 numbered results: 4 verified unconditionally, 0 verified conditionally, 0 with recorded issues, 0 unfinished (2026-10-13 01:24).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.1 | 1 | L01 | Verified unconditionally | Lemma 2.1 (completing the square) verified unconditionally; revised proof correct. |
| Lemma 2.2 | 1 | L02 | Verified unconditionally | Lemma 2.2 (rho <= min) verified unconditionally; revised proof is correct (fair implicit use of theta^2>0). |
| Theorem 2.3 | 1 | T01 | Verified unconditionally | Theorem 2.3 verified unconditionally using the now-verified Lemmas 2.1 and 2.2. |
| Corollary 2.4 | 1 | C01 | Verified unconditionally | Corollary oracle beats one half |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

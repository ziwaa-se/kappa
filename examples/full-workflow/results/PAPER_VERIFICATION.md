# Checklist of all numbered results (in PDF numbering order)

**3 numbered results: 2 verified unconditionally, 1 verified conditionally, 0 with recorded issues, 0 unfinished (2026-09-30 20:53).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.1 | 1 | L01 | Verified unconditionally | Fully verified, no external parameters, no gaps. gate verification/audits/L01_gate.md; final verification/audits/L01_final.md |
| Proposition 2.2 | 1 | P01 | Verified conditionally | Condition: P01_NesbittInequality (cited, Nesbitt1903 Thm 1, step S2). Uses L01 (UNCONDITIONAL). gate verification/audits/P01_gate.md; final verification/audits/P01_final.md |
| Lemma 2.3 | 2 | L02 | Verified unconditionally | Revision 1: domain narrowed to x > -1, proof's sign step now explicit. Fully verified, no external parameters, no gaps. Resolves B01 (closed history: old x≠-1 text was ERROR). gate verification/audits/L02_gate.md; final verification/audits/L02_final.md |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

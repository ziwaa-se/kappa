# Checklist of all numbered results (in PDF numbering order)

**6 numbered results: 3 verified unconditionally, 0 verified conditionally, 3 with recorded issues, 0 unfinished (2026-10-12 22:48).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.1 | 1 | L01 | Verified unconditionally | Lemma 2.1 verified unconditionally. |
| Lemma 2.2 | 1 | L02 | Recorded issue | Lemma 2.2 proved for I=(0,1); I open/closed not stated and the lemma is false on [0,1] at p=0,1 (DOMAIN_CLARIFICATION). |
| Proposition 2.3 | 1 | P01 | Verified unconditionally | Proposition 2.3 verified unconditionally (I read as [0,1]; concavity of sqrt(p(1-p)) derived from mathlib). |
| Lemma 2.4 | 1 | L03 | Recorded issue | Lemma 2.4 is false as printed (n=1, p=1/10); step main.tex:70 does not follow from Lemma 2.1 (ERROR). |
| Proposition 2.5 | 1 | P02 | Verified unconditionally | Proposition 2.5 verified unconditionally (C=1/4 via Lemma 2.1). |
| Proposition 2.6 | 1 | P03 | Recorded issue | Proposition 2.6: proof step main.tex:86 is false (missing cross term); conclusion not refuted (PAPER_ARGUMENT_GAP). |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

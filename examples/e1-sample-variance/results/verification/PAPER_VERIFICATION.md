# Checklist of all numbered results (in PDF numbering order)

**6 numbered results: 3 verified unconditionally, 1 verified conditionally, 2 with recorded issues, 0 unfinished (2026-10-13 01:08).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.1 | 1 | L01 | Verified unconditionally | Centred sum is zero; verified in Lean with no external inputs. |
| Lemma 2.2 | 1 | L02 | Verified unconditionally | Variance shortcut identity; verified in Lean with no external inputs. |
| Proposition 2.3 | 1 | P01 | Verified conditionally | Popoviciu-based variance bound verified in Lean, conditional on the cited Popoviciu inequality. |
| Proposition 2.4 | 1 | P02 | Verified unconditionally | Samuelson's inequality verified in Lean with no external inputs; the s=0 case (main.tex:76) is a ruled FAIR_IMPLICIT_STEP fill-in. |
| Lemma 2.5 | 2 | L03 | Recorded issue | Lemma is false: s^2 <= (1/n) sum x_i^2 fails for n=2, x=(1,-1); verified counterexample in Lean. |
| Corollary 2.6 | 2 | C01 | Recorded issue | Printed proof at main.tex:99 passes through s^2 <= 1, false at n=2, x=(1,-1) (own PAPER_ARGUMENT_GAP, B02; upstream B01). The conclusion s^2 <= 2 is not shown false. |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

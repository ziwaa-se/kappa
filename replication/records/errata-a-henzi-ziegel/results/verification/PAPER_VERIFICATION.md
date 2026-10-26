# Checklist of all numbered results (in PDF numbering order)

**5 numbered results: 0 verified unconditionally, 3 verified conditionally, 2 with recorded issues, 0 unfinished (2026-10-13 11:21).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Theorem 3.1 |  | T01 | Recorded issue | Theorem 3.1 holds; proof step E(0) in (0,1) at l.412 (and mirror at l.412-415; old manuscript l.419, l.423) is false at lambda=1 (minor argument gap). |
| Theorem 3.2 |  | T02 | Recorded issue | Theorem 3.2 holds; l.424 (and mirror l.424; old manuscript l.435, l.462) claim fails at pi1=1 / pi1=0 (argument gap); S14 and other steps proved. |
| Theorem 3.3 |  | T03 | Verified conditionally | GROW e-value for H against pi1 equals the likelihood ratio, given the cited Gruenwald et al. Theorem 1 (X03); S1-S4 direct computation proved. |
| Proposition 3.4 |  | P04 | Verified conditionally | Proposition 3.4 (sequential e-values for lag h, h=1 and h>1) proved in Lean; depends on the T01 e-value clause (T01 has issue B1) and the strict-consistency mixing fact. |
| Proposition 3.5 |  | P05 | Verified conditionally | Proposition 3.5 (stopped value bound for stopping times, revised statement E(e_{tau+h-1}) <= 1): h=1 case proved along l.227 and l.200-214 (with l.400) as a fair implicit step, parameter-free; h>1 reconnected to P04 (P05Closed_r1). Conditional on P04_T01Consumed and P04_MixingOfStrict (h>1 branch). |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

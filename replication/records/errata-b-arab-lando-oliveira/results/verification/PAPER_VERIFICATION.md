# Checklist of all numbered results (in PDF numbering order)

**12 numbered results: 3 verified unconditionally, 2 verified conditionally, 7 with recorded issues, 0 unfinished (2026-10-13 11:29).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.3 |  | L01 | Recorded issue | ISSUE: B01 PAPER_ASSUMPTION_GAP, missing F_X(0)=0 |
| Proposition 2.5 |  | P01 | Verified unconditionally | Prop 2.5 verified unconditionally; the derivative step is rendered in integrated (Tonelli) form, a faithful rendering per the audit; 'negative' at :153 should read non-positive (editorial). |
| Theorem 2.8 |  | T01 | Recorded issue | Theorem 2.8 is false as printed: h(x)=max(x-1,0) gives F_{h(X)}(0)=1/2 (Lean counterexample); rest verified in gap file. |
| Theorem 3.1 |  | T02 | Verified conditionally | Thm 3.1 verified conditionally on the only-if direction of Lemma 2.3 (T02_L01Consumed); the revised induction step is correct as written; zero weights, n=1, x<0 and weight renormalisation are fair implicit steps. |
| Proposition 3.2 |  | P02 | Recorded issue | ISSUE: B02 PAPER_ARGUMENT_GAP, B03 DOMAIN_CLARIFICATION |
| Proposition 3.3 |  | P03 | Verified conditionally | Prop 3.3 verified conditionally on T02_L01Consumed (only-if half of Lemma 2.3) and P03_P02Consumed (Prop 3.2, ISSUE); the Thm 3.1 clause is reconnected to T02; the non-degeneracy step at :269 is a fair implicit step. |
| Proposition 4.6 |  | P04 | Recorded issue | Prop 4.6 DOR via convex transform order |
| Theorem 4.8 |  | T03 | Recorded issue | Thm 4.8 is false as printed (max(Z-2,0) and Z+1; Lean counterexamples, review VALID) and the h(0)=0 step at :337 fails for X=Z. |
| Lemma 4.10 |  | L02 | Recorded issue | Lemma 4.10 omits F_X(0)=0; 'if' direction false (B04); S1-S3 and 'only if' verified |
| Theorem 4.12 |  | T04 | Verified unconditionally | Thm 4.12 super-heavy-tailed implies InvSub |
| Proposition 5.2 |  | P05 | Recorded issue | Prop 5.2 omits F_X(0)=0, so the 'if' direction is false for X=0 a.s. (Lean counterexample, review VALID); S1-S3 verified. |
| Proposition 5.3 |  | P06 | Verified unconditionally | Prop 5.3 verified unconditionally; the F^- to F switch (S3) and the p=1 edge (S1') are fair implicit steps (editorial: state them). |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

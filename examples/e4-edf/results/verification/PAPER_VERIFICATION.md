# Checklist of all numbered results (in PDF numbering order)

**3 numbered results: 1 verified unconditionally, 2 verified conditionally, 0 with recorded issues, 0 unfinished (2026-10-13 01:08).**
For how verdicts are defined see `verification/rules/VERDICTS.md`:
- "Verified conditionally" means the source proof has been verified step by step in Lean, but depends on results the paper cites or does not prove. All of these results are listed as explicit parameters and are never disguised as proved.
- "Unfinished" is never counted as a paper error.
- This file is not a claim that the whole paper is fully verified.

| PDF no. | Page | ID | Verdict | Evidence scope / conditions / issues / what is still missing |
|---|---:|---|---|---|
| Lemma 2.1 | 1 | L01 | Verified unconditionally | EDF is nondecreasing and n F_n(t) is an integer in 0..n; proved along the printed route. |
| Proposition 2.2 | 1 | P01 | Verified conditionally | D_n tends to 0 a.s. for iid samples; holds given the cited Glivenko-Cantelli theorem, which is the source's whole proof. The Lean check has no content beyond showing that the printed proposition is an instance of the encoded GlivenkoCantelli parameter (P01_final §6). |
| Theorem 2.3 | 1 | T01 | Verified conditionally | Verified conditionally: the gated statement is proved in full (S1-S6), conditional on DonskerUniformSup and KolmogorovFormula. |

<!-- Each row states: the verdict; the conditions (external parameters and provenance debts, and which step each is used in); which clauses are unconditional; the parts not encoded;
     the assessment of the source (error / gap / ambiguity / typo); downstream impact; evidence links (gate report, final audit report, issue ruling). -->

## Unnumbered assertions and standalone calculations in the source proofs

| ID | Source location | Content | Current limits of the evidence |
|---|---|---|---|

## Non-vacuity and limits on the formalization side

(Non-vacuity witnesses, technical formalization assumptions (TFA), provenance debts, etc. None of these changes any verdict.)

## Evidence entry points

- `verification/RESULTS.json`, `verification/BLOCKERS.md`, `verification/AUDIT.md`, `verification/EXTERNAL_TOOLS.md`, `verification/audits/`

# Timeline of the example run

The progress table at five moments of the run. Each table was regenerated from the snapshot the kit saved at that moment, with the kit's own `python3 scripts/pv_status.py table`; nothing was edited except the time in each heading, which is the snapshot's time.

## 1. During the first check (20:04)

The run had finished Lemma 2.1 and Lemma 2.3. Proposition 2.2 was still being drafted (its record still at `INVENTORIED`), so it is listed as unfinished. If the run had stopped here (a usage limit, a closed window), `/pv-resume` would continue from this point.

#### Verification progress — A short note on three elementary inequalities (2026-09-30 20:04)

**3 numbered results: 1 verified (unconditional) · 0 verified (conditional) · 1 issue recorded · 1 unfinished.**

| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |
|---|---|---|---|---|---|
| 2.1 | L01 | Lemma AM-GM for two reals | Verified (unconditional) | FINAL_PASSED | AM-GM for two reals (ab ≤ (a²+b²)/2, equality iff a=b): fully verified, no conditions. |
| 2.2 | P01 | Proposition Nesbitt-type refinement | Unfinished | INVENTORIED |  |
| 2.3 | L02 | Lemma quotient inequality | Issue recorded | STOPPED | Lemma 2.3 (x²/(1+x) ≥ x-1 for x≠-1) is false as printed: counterexample x=-2 gives -4≥-3, which fails. ERROR, confirmed by independent counterexample review. Does not affect L01 or P01. |

## 2. First check complete (20:19)

Every result has a verdict: unconditional, conditional (on the cited Nesbitt inequality) and an issue (`ERROR`, with a reviewed Lean counterexample). The first report was then written and fact-checked.

#### Verification progress — A short note on three elementary inequalities (2026-09-30 20:19)

**3 numbered results: 1 verified (unconditional) · 1 verified (conditional) · 1 issue recorded · 0 unfinished.**

| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |
|---|---|---|---|---|---|
| 2.1 | L01 | Lemma AM-GM for two reals | Verified (unconditional) | FINAL_PASSED | AM-GM for two reals (ab ≤ (a²+b²)/2, equality iff a=b): fully verified, no conditions. |
| 2.2 | P01 | Proposition Nesbitt-type refinement | Verified (conditional) | FINAL_PASSED | Nesbitt-type refinement (S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²)) for x,y,z>0): verified, conditional on Nesbitt's inequality (cited, Nesbitt1903 Thm 1), used via L01 (UNCONDITIONAL). |
| 2.3 | L02 | Lemma quotient inequality | Issue recorded | STOPPED | Lemma 2.3 (x²/(1+x) ≥ x-1 for x≠-1) is false as printed: counterexample x=-2 gives -4≥-3, which fails. ERROR, confirmed by independent counterexample review. Does not affect L01 or P01. |

## 3. Revised paper received (20:40)

The authors corrected Lemma 2.3. `/pv-revise` compared the new source with the baseline, found that only Lemma 2.3 changed, and reset only it. Its previous verdict is kept in its history; 2.1 and 2.2 keep their verdicts.

#### Verification progress — A short note on three elementary inequalities (2026-09-30 20:40)

**3 numbered results: 1 verified (unconditional) · 1 verified (conditional) · 0 issue recorded · 1 unfinished.**

| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |
|---|---|---|---|---|---|
| 2.1 | L01 | Lemma AM-GM for two reals | Verified (unconditional) | FINAL_PASSED | AM-GM for two reals (ab ≤ (a²+b²)/2, equality iff a=b): fully verified, no conditions. |
| 2.2 | P01 | Proposition Nesbitt-type refinement | Verified (conditional) | FINAL_PASSED | Nesbitt-type refinement (S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²)) for x,y,z>0): verified, conditional on Nesbitt's inequality (cited, Nesbitt1903 Thm 1), used via L01 (UNCONDITIONAL). |
| 2.3 | L02 | Lemma quotient inequality | Unfinished | INVENTORIED | (before revision 1: Issue recorded) stopped: SOURCE_CHANGED |

## 4. Corrected lemma re-checked (20:55)

Lemma 2.3 was drafted, gated, proved and audited again from scratch: now verified unconditionally. Issue B01 was closed by the new final audit.

#### Verification progress — A short note on three elementary inequalities (2026-09-30 20:55)

**3 numbered results: 2 verified (unconditional) · 1 verified (conditional) · 0 issue recorded · 0 unfinished.**

| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |
|---|---|---|---|---|---|
| 2.1 | L01 | Lemma AM-GM for two reals | Verified (unconditional) | FINAL_PASSED | AM-GM for two reals (ab ≤ (a²+b²)/2, equality iff a=b): fully verified, no conditions. |
| 2.2 | P01 | Proposition Nesbitt-type refinement | Verified (conditional) | FINAL_PASSED | Nesbitt-type refinement (S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²)) for x,y,z>0): verified, conditional on Nesbitt's inequality (cited, Nesbitt1903 Thm 1), used via L01 (UNCONDITIONAL). |
| 2.3 | L02 | Lemma quotient inequality | Verified (unconditional) | FINAL_PASSED | (before revision 1: Issue recorded) Lemma 2.3 revised (x > -1): x^2/(1+x) >= x-1 fully verified, no conditions; the printed statement now excludes the x < -1 region where the pre-revision text was false (B01), and the proof's sign-fact step (1+x>0) is now explicit. |

Output of `python3 scripts/pv_status.py followup` at this point:

| No. | ID | Before (revision) | Now | Issues found before | Status of those issues |
|---|---|---|---|---|---|
| 2.3 | L02 | Recorded issue (revision 1) | Verified unconditionally | B01 | B01: resolved |

## 5. A person checked the cited result (20:56)

A reader's check of Nesbitt's inequality was recorded with `pv_status.py human-check`. Proposition 2.2 stays conditional, now marked "conditions checked by a person".

#### Verification progress — A short note on three elementary inequalities (2026-09-30 20:56)

**3 numbered results: 2 verified (unconditional) · 1 verified (conditional) · 0 issue recorded · 0 unfinished.**

Of the results verified conditionally, 1 has every condition checked by a person (still conditional: the conditions are not checked in Lean).

| No. | ID | Result | Verdict | Stage | Conditions / issues / where stopped |
|---|---|---|---|---|---|
| 2.1 | L01 | Lemma AM-GM for two reals | Verified (unconditional) | FINAL_PASSED | AM-GM for two reals (ab ≤ (a²+b²)/2, equality iff a=b): fully verified, no conditions. |
| 2.2 | P01 | Proposition Nesbitt-type refinement | Verified (conditional); conditions checked by a person | FINAL_PASSED | Nesbitt-type refinement (S(x,y,z) ≥ 3(xy+yz+zx)/(2(x²+y²+z²)) for x,y,z>0): verified, conditional on Nesbitt's inequality (cited, Nesbitt1903 Thm 1), used via L01 (UNCONDITIONAL). |
| 2.3 | L02 | Lemma quotient inequality | Verified (unconditional) | FINAL_PASSED | (before revision 1: Issue recorded) Lemma 2.3 revised (x > -1): x^2/(1+x) >= x-1 fully verified, no conditions; the printed statement now excludes the x < -1 region where the pre-revision text was false (B01), and the proof's sign-fact step (1+x>0) is now explicit. |

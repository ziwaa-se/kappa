# Independent fact check of the final report (pv-factcheck)

- **Role**: `pv-factcheck` (independent; did not write the report, did not compile it)
- **Date**: 2026-09-30 (post-revision-1 round)
- **Checked**: `verification/report/AUTHOR_REPORT.md` (118 lines), `verification/report/EXTERNAL_TOOLS_WORKSHEET.md` (59 lines), `verification/report/FILES_TO_CHECK.md` (73 lines)
- **Against (read directly, not through any summary)**: `source/main.tex` (whole file, 93 lines), `verification/source_baseline/main.tex`, `verification/audits/{L01_gate,L01_final,P01_gate,P01_final,L02_gate,L02_final,L02_issue_1,L02_issue_1_audit}.md`, `verification/{RESULTS.json,PAPER_VERIFICATION.md,BLOCKERS.md,EXTERNAL_TOOLS.md,AUDIT.md,DOC_ERRATA.md,INVENTORY.md,RESUME.md}`, `verification/rules/VERDICTS.md` §1,§5, `pv_work/{L01.lean,L01Stmt.lean,P01.lean,P01Stmt.lean,L02.lean,L02Stmt.lean}`, `pv_work/superseded/`, the previous round's `verification/report/work/factcheck.md` (now replaced by this file), `verification/report/work/consistency_check.md`, `python3 scripts/pv_status.py followup` (run by me).
- **Counts**: **Major 1, Moderate 5, Minor 8.**

This round contains **no invented suggested fix**: every suggestion in §4.1 and §5 of the report is traceable to `verification/audits/L02_issue_1.md` §6, `L02_issue_1_audit.md` §6, `BLOCKERS.md:31`, or `P01_gate.md:227-232` / `P01_final.md:94`. The four verdicts, the one condition, the "not affected" list and the resolution of B01 are all correct.

---

## 1. Problem table

### Major

#### MAJ-1 — §6 claims every step obligation was "independently proved in Lean by **both the gate and the final audit**"; no record supports this, and the prover is dropped

| | |
|---|---|
| **Report text** | `AUTHOR_REPORT.md:94`: "**Mathematical completion (parts supported by reasoning only)**: none — every step obligation of all three results was independently proved in Lean by both the gate and the final audit; no result rests on reasoning alone." |
| **What the source says** | (a) The step obligations were proved in Lean by `pv-prover` inside `pv_work/L01.lean`, `P01.lean`, `L02.lean` (five, seven and five gated declarations respectively; `L01_final.md:22`, `P01_final.md:19`, `L02_final.md:35`). (b) The **gates** proved obligations only in side probes, and not all of them: `L01_gate.md:179-182` — "I proved **the two substantive obligations** independently … (the exact statements of S3 and S4)", i.e. 2 of 4, not every obligation; `P01_gate.md:31,132` — "all six step obligations proved true as stated"; `L02_gate.md:48-49,153` — truth probe over S1–S4. (c) The **final audits did not re-prove the step obligations at all**: they ran the mechanical suite, re-checked statement fingerprints, re-ran `#pv_axioms`/`#pv_walk`, judged route fidelity and ran non-vacuity probes (`L01_final.md:12-37,68-87`, `P01_final.md:10-27,60-87`, `L02_final.md:25-40,119-179`); `P01_final.md:53` states explicitly "Not re-derived (per task)". No record anywhere says a final audit proved a step obligation. |
| **Source `file:line`** | `verification/audits/L01_gate.md:179-182`; `verification/audits/P01_gate.md:31,132`; `verification/audits/L02_gate.md:48-49`; `verification/audits/P01_final.md:53`; `verification/audits/L01_final.md:12-37`; `verification/audits/L02_final.md:25-40` |
| **Why Major** | It asserts machine-checked evidence that does not exist (independent re-proof by the final audits) and over-attributes independence; it is the same class of claim the previous round's fact check ruled **Major** (old `factcheck.md:24`, MAJ-1: "'proved true in Lean by **both** the gate and the auditor' is false: only the auditor proved it"). The *conclusion* ("nothing rests on reasoning alone") is correct — only the evidence attribution is wrong. |
| **Suggested correction** | "**Mathematical completion (parts supported by reasoning only)**: none. Every step obligation of all three results is proved in Lean inside the audited modules (`pv_work/L01.lean`, `P01.lean`, `L02.lean`); each statement was approved in advance by an independent gate (which also re-proved obligations in its own probes: all six for Proposition 2.2, S1–S4 for Lemma 2.3, S3 and S4 for Lemma 2.1), and each finished module was re-compiled, fingerprint-checked and walked for axioms/`sorry` by an independent final audit. No result rests on reasoning alone." |

### Moderate

#### MOD-1 — "No one has verified Nesbitt's inequality in Lean" is contradicted by the P01 final audit, which proved it in a probe

| | |
|---|---|
| **Report text** | `FILES_TO_CHECK.md:17`: "**Whether the external inputs are true**: see `EXTERNAL_TOOLS_WORKSHEET.md`. **No one has verified Nesbitt's inequality in Lean**; this is a **mandatory check** …". Same absolute form at `EXTERNAL_TOOLS_WORKSHEET.md:3` ("None of the items below has been **proved in Lean**") with no qualification anywhere in the three files. |
| **What the source says** | `P01_final.md:85`: "`theorem auditor_nesbitt_sat : Paper.P01.NesbittInequality` proved in `aud_P01_extsat.lean` (`nlinarith` after clearing denominators); `#print axioms` → `[propext, Classical.choice, Quot.sound]` — the **single condition is satisfiable and in fact true**"; `P01_final.md:87`: "a **reviewer-constructed argument** … never evidence about the paper and not part of the audited proof. The audited `P01.lean` still carries `hN` as a visible parameter, so the verdict stays CONDITIONAL". `RESUME.md:35` records the same ("Its mathematical content was independently proved true in a reviewer probe, but citation attribution is not something Lean can check"). `P01_final.md:101` (status for the authors) even says "A separate check of ours confirms this condition is itself a true statement, so the proposition's conclusion is not in doubt" — an author-facing sentence absent from the whole report. |
| **Source `file:line`** | `verification/audits/P01_final.md:85-87,101`; `verification/RESUME.md:35` |
| **Suggested correction** | Use one precise form in all three files (this is also the previous round's accepted wording, old `factcheck.md:96`): "`NesbittInequality` is **not** proved inside the verification chain and remains an explicit Lean hypothesis of `P01_main`, so Proposition 2.2 stays CONDITIONAL. A reviewer's side probe (`verification/audits/P01_final.md` §6, suggestion only, not part of the audited proof) found the mathematical content true, so the human check is primarily about the citation's attribution/numbering — but it remains mandatory, because no proof of it is connected to the paper's chain." |

#### MOD-2 — the report states it has already passed the fact check, and still carries an unfilled "N problems" placeholder

| | |
|---|---|
| **Report text** | `AUTHOR_REPORT.md:3`: "it **has passed** an independent fact check, whose report is in `verification/report/work/factcheck.md`." `AUTHOR_REPORT.md:112`: "An independent fact-check of this report's first draft found **N** problems, which have been corrected (see below; N is filled in after the fact-check completes)." |
| **What the source says** | At the time the draft was written no fact check of it existed: `verification/report/work/factcheck.md` (timestamp 20:36) was the **pre-revision** round's report, which fact-checked the superseded pre-revision `AUTHOR_REPORT.md` (`consistency_check.md:34,36` says exactly this and warns "a reader should not rely on them going forward"). This round's check finds 1 Major and 5 Moderate problems, so the draft as delivered had not passed. CLAUDE.md rule 10: "Summaries written by the coordinator must pass an independent fact check before delivery." Also "(see below)" points to nothing — §8 has no list below that sentence. |
| **Source `file:line`** | `verification/report/work/consistency_check.md:32-38`; CLAUDE.md rule 10 |
| **Suggested correction** | Fill `:112` with the real counts (Major 1, Moderate 5, Minor 8) **after** correcting MAJ-1 and the MOD items, drop "(see below)", and only then let `:3` read "has passed". Until then `:3` should read "has been submitted to an independent fact check". |

#### MOD-3 — "Two further candidates considered during drafting": the inventory records **four**, including the one that became the paper error

| | |
|---|---|
| **Report text** | `AUTHOR_REPORT.md:67`: "(Two further candidates considered during drafting — $x^2+y^2+z^2>0$ and the well-definedness of $S(x,y,z)$ on positive reals — were resolved as ordinary step obligations …)". `EXTERNAL_TOOLS_WORKSHEET.md:18`: "**None in this project** — **both** candidates considered during drafting (positivity of $x^2+y^2+z^2$ and well-definedness of $S(x,y,z)$) were resolved as ordinary, trivially-discharged step obligations". |
| **What the source says** | `INVENTORY.md:214-230` lists **five** candidate external inputs: EXT-1 (Nesbitt), EXT-2 ($x^2+y^2+z^2>0$), EXT-3 (well-definedness of $S$), **EXT-4** ("$x^2 \ge (x-1)(x+1) = x^2-1$, which is obvious", `main.tex:80`, type (v), user L02) and **EXT-5** (sign of $1+x$, type (iii), user L02). `EXTERNAL_TOOLS.md:25-29` settles all five: EXT-4 → "kept as ordinary step obligations `L02_S2`/`L02_S3`"; EXT-5 → "**not an external input — was a confirmed paper-side ERROR, now RESOLVED**". So besides Nesbitt there were four candidates, not two, and one of them (EXT-5) is precisely the finding B01 that the rest of the report is about. |
| **Source `file:line`** | `verification/INVENTORY.md:214-230`; `verification/EXTERNAL_TOOLS.md:25-29`; `pv_work/L02Stmt.lean:30-45` |
| **Suggested correction** | "(Four further candidates were considered during drafting (`INVENTORY.md` §6): $x^2+y^2+z^2>0$ and the well-definedness of $S(x,y,z)$ became ordinary step obligations of Proposition 2.2 (`P01_S4`, `P01_S1`); the 'which is obvious' algebra of Lemma 2.3 became `L02_S2`/`L02_S3`; and the sign of $1+x$ turned out not to be an external input at all but the paper-side error B01, now resolved by revision 1 and discharged as `L02_S1`.)" Mirror the same correction in the worksheet's A′ entry. |

#### MOD-4 — §6 again drops the two recorded notational ambiguities (N1, N2)

| | |
|---|---|
| **Report text** | `AUTHOR_REPORT.md:90-98` (§6) has four headings: literature/citations, mathematical completion, author intent, experiments/unnumbered assertions. N1 and N2 appear in none of the three delivered files. |
| **What the source says** | `INVENTORY.md:171-184` records two items under "Notational ambiguities (recorded only, not ruled on)": **N1** — $S(x,y,z)$ is defined only "whenever the three denominators are nonzero", so its domain as a partial function on $\R^3$ is left implicit (`main.tex:33`); **N2** — $\Rpos$ is introduced as "the positive real numbers" and never explicitly says $0\notin\Rpos$ (`main.tex:11,28`). I confirmed both against the `.tex`: `main.tex:33` says only "whenever the three denominators are nonzero" and `main.tex:28` only "the positive real numbers". No gate or final audit revisits them, so they are still open, author-facing notes. The previous round flagged this same omission (old `factcheck.md:62-69`, MOD-4) and it was not carried into this draft. |
| **Source `file:line`** | `verification/INVENTORY.md:171-184`; `source/main.tex:11,28,33` |
| **Suggested correction** | Add to §6: "**Notation (recorded only; no verdict depends on it)**: the note never states a domain convention for $S(x,y,z)$ beyond 'whenever the three denominators are nonzero' (`main.tex:33`), and never spells out $0 \notin \Rpos$ (`main.tex:11,28`). The standard readings were adopted and neither bites (Proposition 2.2's printed domain makes all three denominators positive); the authors may wish to state both explicitly." |

#### MOD-5 — §8 reports only one of the compiler's findings and omits the kit-upgrade disclosure

| | |
|---|---|
| **Report text** | `AUTHOR_REPORT.md:111`: "During this round's compilation, the independent compiler flagged that `verification/EXTERNAL_TOOLS.md`'s 'settled candidates' table still described Lemma 2.3 as an open issue … A stale bookkeeping field (`RESULTS.json`'s `run_scope` …) was also cleared." |
| **What the source says** | This round's `consistency_check.md` records **six** findings: M1 (the three top-level report files were stale — addressed by this regeneration, but not mentioned), **M2** (EXTERNAL_TOOLS.md, the one item reported), **M3** (`verification/report/work/` still holds a pre-revision mirror set; `AUTHOR_REPORT_v1.md` and the old `factcheck.md` "should not be relied on") , **Mod1** (`run_scope`, reported), **Mod2** (`AUDIT.md:66-67` records the kit upgrade as "1.3 -> 1.3", and the compiler says it "is worth a human check of the kit's own versioning before relying on `kit_backup/20260930-205723/` as a meaningful rollback point"), **Min2** (`verification/audits/L02_mech.md:53` prints a bare "MECH CHECKS: FAIL (probe)", adjudicated as a script artifact in `L02_final.md` §1/§10). Separately, `AUDIT.md:66-67` itself warns "Verdicts recorded before this date were produced with the earlier kit" — a process fact absent from §8. |
| **Source `file:line`** | `verification/report/work/consistency_check.md:32-38,51-55,65-70`; `verification/AUDIT.md:66-67`; `verification/audits/L02_mech.md:53`; `verification/audits/L02_final.md:41-60,215-220` |
| **Suggested correction** | Extend §8 with: "(2) the compiler also flagged that `verification/report/work/` still contained the pre-revision mirror files (`AUTHOR_REPORT_v1.md`, the earlier `factcheck.md`) — superseded by this round's outputs; (3) `verification/AUDIT.md` records a kit upgrade at 2026-09-30 20:57, after all three verdicts were recorded, with the version string '1.3 -> 1.3' — worth a human look before treating `kit_backup/20260930-205723/` as a rollback point; no verdict is affected. In addition, `verification/audits/L02_mech.md` ends with 'MECH CHECKS: FAIL (probe)'; the independent final audit adjudicates this in its §1 as a script artifact on a declaration-free `L02Stmt.lean` (0 declarations, as in the gate snapshot) and records no FAIL item." |

### Minor

#### MIN-1 — Lemma 2.3's main theorem is at `pv_work/L02.lean:92`, not `:69`

- **Report text**: `AUTHOR_REPORT.md:55` and `FILES_TO_CHECK.md:38`: "`pv_work/L02.lean:69 Paper.L02.L02_main`".
- **What the source says**: in `pv_work/L02.lean`, line 69 is inside the docstring of `L02_S4` ("Role: the final trivial inequality…"); `theorem L02_main (x : ℝ) (hx : x > -1) : x ^ 2 / (1 + x) ≥ x - 1 := by` is at **line 92** (body 93–98). The final audit agrees: `L02_final.md:132` cites "`L02.lean:92-98`". The wrong value is inherited from `RESULTS.json:111` and `AUDIT.md:63`, both of which say `:69`.
- **Source `file:line`**: `pv_work/L02.lean:92`; `verification/audits/L02_final.md:132`; (stale) `verification/RESULTS.json:111`, `verification/AUDIT.md:63`
- **Correction**: write `pv_work/L02.lean:92 Paper.L02.L02_main` in both report files, and fix `RESULTS.json`'s `lean_main` and the `AUDIT.md` entry (bookkeeping, outside my write scope).

#### MIN-2 — the P01 signature in `FILES_TO_CHECK.md` §2 reorders the binders

- **Report text**: `FILES_TO_CHECK.md:37`: "`pv_work/P01.lean:142 Paper.P01.P01_main (x y z : ℝ) (hx : 0<x) (hy : 0<y) (hz : 0<z) (hN : NesbittInequality) : P01Conclusion x y z`".
- **What the source says**: `pv_work/P01.lean:142-143`: `theorem P01_main (hN : NesbittInequality) (x y z : ℝ) (hx : 0 < x) (hy : 0 < y) (hz : 0 < z) : P01Conclusion x y z` — `hN` is the **first** binder. §2 of that file tells the reader to compare the signature binder by binder, so the order should match.
- **Source `file:line`**: `pv_work/P01.lean:142-143`
- **Correction**: put `(hN : NesbittInequality)` first.

#### MIN-3 — "`gaps: []` for all three results in `RESULTS.json`" is not literally what the file says

- **Report text**: `EXTERNAL_TOOLS_WORKSHEET.md:24`.
- **What the source says**: only L02 has a `gaps` field (`RESULTS.json:146`, `"gaps": []`); the L01 and P01 entries (`:23-52`, `:53-86`) have **no** `gaps` key at all (absent = none). The substantive claim (no gap hypotheses, no `*ModGaps.lean`) is correct — I confirmed no `*ModGaps.lean` exists in `pv_work/`.
- **Source `file:line`**: `verification/RESULTS.json:23-52,53-86,146`
- **Correction**: "no result records any gap hypothesis (L02's `gaps` field is `[]`; L01 and P01 have none), and no `*ModGaps.lean` file exists".

#### MIN-4 — §7 again omits the gate's recorded non-blocking recommendation about Nesbitt, and the fact that mathlib was never searched

- **Report text**: `AUTHOR_REPORT.md:102`: "External parameters are still unverified … so full verification of the whole paper is not claimed."
- **What the source says**: `P01_gate.md:197-206`: the gate tried to search mathlib itself and "was **blocked by the permission system** … so I record no claim either way", plus "*Non-blocking recommendation*: if the prover can cheaply `#check` a mathlib Nesbitt lemma … the result could become UNCONDITIONAL; if it tries and fails, the names searched must be recorded." `EXTERNAL_TOOLS.md:17` records `mathlib_search` as "not searched". This was flagged in the previous round too (old `factcheck.md:121-126`, MIN-4) and is still absent.
- **Source `file:line`**: `verification/audits/P01_gate.md:197-206`; `verification/EXTERNAL_TOOLS.md:17`
- **Correction**: add to §7: "mathlib was never searched for Nesbitt's inequality (the gate's own attempt was blocked by the permission system, so no claim is made that mathlib lacks it); the gate noted, non-bindingly, that a cheap mathlib interface would make Proposition 2.2 UNCONDITIONAL — not attempted in this run."

#### MIN-5 — "`verification/DOC_ERRATA.md` is currently empty" is not literally true

- **Report text**: `AUTHOR_REPORT.md:106`.
- **What the source says**: the file has 13 lines — a header, the change procedure and a table **with no rows** (`DOC_ERRATA.md:1-13`). The substantive claim (no erratum recorded, no audit found an inaccurate Lean comment) is correct and matches `consistency_check.md:61-63`.
- **Source `file:line`**: `verification/DOC_ERRATA.md:1-13`
- **Correction**: "has no entries" rather than "is currently empty". (Same nit as the previous round's MIN-5.)

#### MIN-6 — the three mechanical-audit records are never cited

- **Report text**: `AUTHOR_REPORT.md:53-55` (§2 evidence cells), `FILES_TO_CHECK.md:36-38` (audit-report column), `AUTHOR_REPORT.md:116` (evidence entry points) list gate + final (+ issue) reports only.
- **What the source says**: `verification/audits/L01_mech.md`, `P01_mech.md`, `L02_mech.md` exist and are part of the audit trail, each cited by its own final audit (`L01_final.md:14`, `P01_final.md:12`, `L02_final.md:7`). Same nit as the previous round's MIN-3.
- **Source `file:line`**: `verification/audits/L01_mech.md`, `P01_mech.md`, `L02_mech.md`
- **Correction**: add `<ID>_mech.md` to the evidence cells of §2 / `FILES_TO_CHECK.md` §2.

#### MIN-7 — "both gates that touch this notation, L01's and P01's"

- **Report text**: `FILES_TO_CHECK.md:46`: the no-shared-`Defs` decision was "confirmed in `verification/INVENTORY.md` §4 and independently re-checked by both gates that touch this notation, L01's and P01's".
- **What the source says**: `L01_gate.md:6` states the opposite about L01 — "**L01 uses no notation from the 'Notation' section** (`main.tex:26-33`)" — it confirms there is nothing to share, which is not "touching this notation". `P01_gate.md:88-105` is the gate that really rules on the inlining of $S$. `INVENTORY.md` §4 is indeed "Shared definitions and assumptions" (`:156`), so that half of the citation is right.
- **Source `file:line`**: `verification/audits/L01_gate.md:6`; `verification/audits/P01_gate.md:88-105`; `verification/INVENTORY.md:156`
- **Correction**: "confirmed by L01's gate (which records that L01 uses no notation from the Notation section) and by P01's gate (which rules the inlining of $S$ a pure notation choice)".

#### MIN-8 — "exactly the minimal fix recorded in the issue ruling" conflates the required fix with the optional one

- **Report text**: `AUTHOR_REPORT.md:36`: revision 1 "narrowed the domain … **and added** the justifying clause … — exactly the minimal fix recorded in the issue ruling"; `:79` repeats "adopted exactly the recorded minimal fix".
- **What the source says**: `L02_issue_1.md:124-132` records the domain change as the whole minimal fix ("Nothing else needs to change"), and the added proof clause only as an **option**, in different words: "Optionally add three words to the proof — 'Multiplying both sides by the positive number $1+x$' — to make the use of the hypothesis visible." The authors' actual sentence ("Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality", `main.tex:79`) is their own wording of that option.
- **Source `file:line`**: `verification/audits/L02_issue_1.md:124-132`; `source/main.tex:79`
- **Correction**: "… adopted the recorded minimal fix (the domain change) and, in its own words, the ruling's optional suggestion to make the sign hypothesis visible in the proof."

---

## 2. Checked and found correct

### `AUTHOR_REPORT.md`

- **Header disclaimers (`:5-7`)**: "not a claim that the whole paper is fully verified", 1 unverified external input, `PAPER_VERIFICATION.md` takes precedence, reading order — all consistent with `VERDICTS.md:176` (§5) and `PAPER_VERIFICATION.md:7`.
- **§0 counts (`:13`)**: "2 verified unconditionally · 1 verified conditionally · 0 with recorded issues · 0 unfinished" — identical to `PAPER_VERIFICATION.md:3` and to `RESULTS.json` (`L01` UNCONDITIONAL `:36`, `P01` CONDITIONAL `:68`, `L02` UNCONDITIONAL `:100`); 2+1+0+0 = 3 = number of numbered results (`VERDICTS.md:175`).
- **§0 verdict table rows (`:19-21`)**: PDF numbers 2.1/2.2/2.3, labels `lem:amgm`/`prop:nesbitt`/`lem:quot`, and the conditions column (None / 1 condition `P01_NesbittInequality` / None) match `RESULTS.json:25-37,55-71,89-104` and `PAPER_VERIFICATION.md:11-13`. No row overstates: the conditional result is never called "verified".
- **§0 human check (`:23`)**: "Test Reader (benchmark), 2026-09-30 20:56, against Nesbitt, *Problem 15114*, *Educational Times* 55 (1903), and the standard rearrangement-inequality proof" is verbatim the content of `RESULTS.json:162-166`; the statement that it stays CONDITIONAL is exactly `VERDICTS.md:41` (§1.2, "The result stays **CONDITIONAL** … a person's check is a different kind of evidence from the Lean kernel's").
- **§0b revision table (`:29-31`)**: matches `python3 scripts/pv_status.py followup`, which I ran: `| 2.3 | L02 | Recorded issue (revision 1) | Verified unconditionally | B01 | B01: resolved |` (the report drops the parenthetical "(revision 1)" only).
- **§0b "what was wrong" (`:35`)**: the pre-revision statement and the $x=-2$ arithmetic ($-4 \ge -3$) are quoted correctly from `L02_issue_1.md:12-30,48-53`; the classification (primary `ERROR`, contributing `PAPER_ARGUMENT_GAP`/`PAPER_ASSUMPTION_GAP`) matches `L02_issue_1.md:57-64`, `L02_issue_1_audit.md:79-90` and `BLOCKERS.md:27-28`; "independently re-confirmed by a second reviewer" matches `L02_issue_1_audit.md:116` (`COUNTEREXAMPLE VALID`).
- **§0b "what changed" (`:36`)**: I compared the texts myself — current `source/main.tex:72` reads "For every real number $x > -1$" and `:79-80` reads "Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality, so the claim is equivalent to …"; the pre-revision wording is quoted in `L02_issue_1.md:12-30`. `AUDIT.md:51-58` confirms only Lemma 2.3 changed, with **no line-number shift**, so the `71-76` / `78-81` citations are right for both versions.
- **§0b re-verification (`:37`) and §4.1 resolution (`:79`)**: fresh gate → fresh proof → independent final audit is confirmed by `RESUME.md:27` and `AUDIT.md:45-49,60-64`; `L02_final.md:224-225` ends "FINAL AUDIT: PASS / SUGGESTED VERDICT: UNCONDITIONAL"; the three claims attributed to the final audit (removes exactly the $x<-1$ region; the sign fact is printed and discharged; UNCONDITIONAL as printed) are `L02_final.md:186-201`.
- **§0b downstream (`:38`) and §1.5**: "neither Lemma 2.1 nor Proposition 2.2 was affected at any point" is supported independently by `L02_issue_1.md:74-76`, `L02_issue_1_audit.md:116`, `BLOCKERS.md:30` and `AUDIT.md:57`, and by my own read of `source/main.tex`: `\ref{lem:quot}` occurs only at `main.tex:84` (the Remark), and the proof of Proposition 2.2 (`main.tex:59-69`) cites only Nesbitt and `lem:amgm`. `RESULTS.json` dependencies (`L01: []`, `P01: ["L01"]`, `L02: []`) agree.
- **§0b history bullet (`:39`)**: B01's heading is `— RESOLVED (2026-09-30 20:53, revision 1; …)` at `BLOCKERS.md:23`; the ISSUE verdict is preserved at `RESULTS.json:118-145` (`history[0]`), not deleted. Correct, and the "open until marked RESOLVED" convention of `BLOCKERS.md:3` is respected — 0 open entries.
- **§1.1–§1.4**: "no counterexample stands against any current result", "0 open issues", the 2-of-3 / 1-of-3 split, "only the three standard Lean axioms" — all match `L01_final.md:45`, `P01_final.md:21,31`, `L02_final.md:70-78` and the mech items 6/7 of each.
- **§2 row 2.1**: both clauses ($ab \le (a^2+b^2)/2$ and equality iff $a=b$) are in the Lean conclusion — `L01Stmt.lean:25-27` has fields `ineq` and `equality_iff`; `pv_work/L01.lean:71` is indeed `theorem L01_main (a b : ℝ) : L01Conclusion a b`. Source `main.tex:37-43`/`45-50` as cited.
- **§2 row 2.2**: `pv_work/P01.lean:142` is `theorem P01_main`; the printed route (cited bound → L01 on the three pairs → division by $x^2+y^2+z^2>0$ → transitivity) matches `main.tex:59-69` and `P01_final.md:60-70`; "one condition, used only at the first proof sentence" is confirmed by the hypothesis-usage walk `P01_final.md:39-45`.
- **§2 row 2.3**: the stated route (sign fact, clearing the denominator, $(x-1)(x+1)=x^2-1$, $x^2\ge x^2-1$) matches `L02_final.md:126-132,205-208`; the conclusion is the bare inequality, no external input, no gap (`L02_final.md:82-85`). Only the line number is wrong (MIN-1).
- **§3 provenance legend (`:61`)**: the (i)–(v)/(p) descriptions match `EXTERNAL_TOOLS.md:5-11` and `VERDICTS.md` §1.2/§4; "Gap hypotheses do not count as external inputs" matches `VERDICTS.md:37` and `EXTERNAL_TOOLS.md:13`.
- **§3 parameter row**: name, `pv_work/P01Stmt.lean:39-41` (I verified: `def NesbittInequality : Prop :=` is at line 39, body 40-41), type (i), user "Proposition 2.2, step S2 (`main.tex:60`)", and the human-check wording all match `RESULTS.json:151-166`, `EXTERNAL_TOOLS.md:17`, `P01_gate.md:248`, `P01_final.md:113`. `main.tex:60` really contains `\cite[Theorem~1]{Nesbitt1903}`.
- **§3 "Debts recorded in words: none. External assertions not encoded: none."** — `EXTERNAL_TOOLS.md:31-39` has both tables empty; `RESULTS.json` has `debts: []`, `unencoded: []` for all three results.
- **§4.1 classification, source locations, "what failed", Lean evidence**: all verified above; `pv_work/L02_Counterexample1.lean` exists with its `.olean`, "builds, axiom-clean, witness $x=-2$" matches `L02_issue_1.md:85-98`; the two audit paths and their verdict strings (`ISSUE VERDICT: ERROR`, `COUNTEREXAMPLE VALID`) are literal.
- **§4.1 "Scope not affected"** — matches `BLOCKERS.md:30`; the parenthetical about the companion paper's $x \ge 0$ range and the unlabeled Remark at `main.tex:83-85` is accurate (I read `main.tex:83-85`; `INVENTORY.md:186-212` records the Remark as unregistered, Note R1).
- **§4.1 "Recorded suggested fix"** — faithful to `L02_issue_1.md:122-138` (restrict to $x>-1$; nothing else needs to change; the $x\ge0$ alternative "also works but discards true content", an editorial choice) and independently re-verified in `L02_issue_1_audit.md:92-101` (probe `auditor_L02_ce1_fix.lean`, as cited in `BLOCKERS.md:31`). **Nothing in §4 or §5 is invented.** The fix does solve the problem: optimality is `fails_on_whole_lower_branch` (`L02_issue_1.md:113`, `L02_issue_1_audit.md:98`).
- **§4.1 "Needs human check: none beyond the recorded Lean evidence"** — verbatim the record at `BLOCKERS.md:32`.
- **§4 closing line "No other substantive issue is recorded"** — `BLOCKERS.md` has exactly one entry; `RESULTS.json` has `issues: []` for all three results.
- **§5 editorial item**: `main.tex:60` is the citation line and the bibliography block is `main.tex:87-90` (the report's "87-89" covers `\begin{thebibliography}`–entry); the entry text is quoted correctly; the classification `EDITORIAL` and "independently agreed by both the statement gate and the final audit" are exactly `P01_gate.md:227-232` ("One editorial remark (`EDITORIAL`, VERDICTS §2.2 — not an issue)") and `P01_final.md:94` ("I independently agree with the gate's classification"). "Does not affect the verdict" is right. It is also the only editorial item in the records: `L01_gate.md`, `L01_final.md`, `L02_gate.md` and `L02_final.md` record no author-facing editorial remark beyond `L02_final.md:209-213`'s note that "which is obvious" and "Since $1+x>0$" are "terse but fair".
- **§6 literature item** — matches `EXTERNAL_TOOLS.md:17` and `RESUME.md:33-35` (priority B, attribution/numbering of a 19th-century problem column), including the "already checked / still CONDITIONAL" treatment.
- **§6 author-intent item** — accurate: `L02_issue_1.md:144-146` and `L02_issue_1_audit.md:103-105` flag the companion paper's usage range as unverifiable and the $x>-1$ vs $x\ge0$ choice as editorial; revision 1 chose $x>-1 \supset x\ge0$ (`L02_final.md:170-179`, probe item D: "the Remark's `x ≥ 0` was not silently substituted"), so "now moot" is right.
- **§6 experiments/unnumbered assertions: none** — `PAPER_VERIFICATION.md:18-21` has an empty table and `INVENTORY.md:232-245` records no H01 item and no experimental section.
- **§7 TFA bullet** — correct: all three gates' TFA tables are empty (`L01_gate.md:243-247`, `P01_gate.md:238-242`, `L02_gate.md:228-232`), each saying the Lean premises are the printed domains.
- **§7 scope / formalization-side corrections / no `ENCODING_ERROR` or `TRANSLATION_BLOCKED`** — supported by `L01_final.md`, `P01_final.md:104-106`, `L02_final.md:215-222` (FAIL items: none) and `RESUME.md:9`.
- **§8 violations bullet** — no record of self-review, network use, or project-side modification of `source/`; roles are distinct in every audit header (`L02_issue_1.md:3`, `L02_final.md:3`, etc.). The `source/` change was the authors' own revision, correctly attributed in §0b.
- **§8 previous-round counts** — "14 problems (1 Major, 7 Moderate, 6 Minor)" matches the superseded `factcheck.md:15` and `RESUME.md:31`.
- **§8 EXTERNAL_TOOLS.md correction and `run_scope`** — real: `consistency_check.md:22-30` (M2) and `:44-49` (Mod1); `EXTERNAL_TOOLS.md:29` now reads "**now RESOLVED**" and `RESULTS.json:15` is `"run_scope": []`.
- **§9 evidence entry points** — every path exists.

### `EXTERNAL_TOOLS_WORKSHEET.md`

- Checking principles, the direction rule ("the literature's theorem implies our Lean parameter, not the reverse") and the note that everything is over `ℝ` are consistent with the project (no `ENNReal`/`∫⁻` anywhere in `pv_work/`).
- Priority overview: one Level-B item, A/A′/C/D/E empty. The D explanation ("the one citation is itself flagged at Level B for its numbering, so it is listed once, there") correctly reconciles `P01_gate.md:207-209`, which assigned priority D for the content and B for the numbering.
- Item #1: source location (`main.tex:60`, first proof sentence) and bibliography quote are correct; "Used by … step S2 (`pv_work/P01.lean:71-74`)" is exactly right (`theorem P01_S2` is at line 71, body through 74), and "used only at this one step" matches the final audit's walk (`P01_final.md:39-45`, including the positive control).
- The quoted Lean definition at `P01Stmt.lean:39-41` is byte-for-byte what the file contains.
- "Check result" line records the human check with who/when/how as `RESULTS.json:162-166` states it, and the verdict note cites `VERDICTS.md` §1.2 correctly (`VERDICTS.md:41`).
- Notation table: `\R`/`\Rpos` at `main.tex:10-11,28` and $S(x,y,z)$ at `main.tex:31-33` are right; the inlining rationale matches `RESULTS.json:16-21` and `INVENTORY.md:156-162`.

### `FILES_TO_CHECK.md`

- Reading order and the "what a human need not read" paragraph are accurate: all three modules compile with 0 errors / 0 `sorry`, carry only the three standard axioms, and each was re-compiled (private byte-identical rebuild) and fingerprint-checked by its final audit (`L01_final.md:18-23`, `P01_final.md:16-21`, `L02_final.md:31-34`). (This was *not* true of L02 before the revision; it is true now.)
- §1: "Open entries in `verification/BLOCKERS.md`: **none**" — correct (the only entry is marked RESOLVED).
- §2 row 2.1: `L01Conclusion` is a `structure` at `L01Stmt.lean:25-27` with exactly the two fields quoted; no external parameters.
- §2 row 2.2: `P01Conclusion` is at `P01Stmt.lean:49-51` (verified) and is a plain `Prop` with $S$ inlined; `NesbittInequality` at `:39-41`; "imports the proved module `L01`" is right (`P01.lean` imports `L01`; `P01_S3` applies `(Paper.L01.L01_main · ·).ineq` to $(x,y),(y,z),(z,x)$ — `P01_final.md:53,65`). Only the binder order is off (MIN-2).
- §2 row 2.3: the revision annotations are right; "`pv_work/L02Stmt.lean` declares no names at all (0 declarations — confirmed in both the gate and final audit)" is literally true (I read the file: header comments plus `namespace`/`end` only) and matches `L02_final.md:45-52`; "supersedes the pre-revision `L02_gate.md`, whose audited draft now lives in `pv_work/superseded/`" is right — `pv_work/superseded/` contains `L02Stmt.lean`, `L02Draft.lean` and a `README.md`.
- §2 closing note about `L01Conclusion.ineq` being the only consumed predecessor `Stmt` name — consistent with `P01_final.md:51-56` (modules reached: `L01`, `L01Stmt`, `P01Stmt`, `P01`).
- §3: `RESULTS.json`'s `defs` is `{"id": "NONE"}` with the quoted note (`RESULTS.json:16-21`); `INVENTORY.md` §4 is indeed the shared-definitions section. (Attribution nit: MIN-7.)
- §4 checking order and §5 rerun commands: the commands match the forms used in the audits (`scripts/pv_lean.sh build …`, `check <ID>`, `#pv_axioms`/`#pv_walk`); all referenced scripts exist. The environment line (toolchain `leanprover/lean4:v4.19.0`, mathlib `c44e0c8ee63ca166450922a373c7409c5d26b00b`, linked, 2452 of 6305 modules, no `TRANSLATION_BLOCKED`) matches `RESULTS.json:9-14` and `RESUME.md:9`.

---

## 3. Could not be checked

- **The mathematical content of the citation** (that Nesbitt, *Problem 15114*, *Educational Times* **55** (1903), 37 states $S \ge 3/2$ and carries a "Theorem 1" numbering): literature outside the repository; no network. The report's treatment of it as an open human-check item is the correct handling; I only verified that the records say what the report says they say.
- **The pre-revision `source/main.tex` by direct read**: `verification/source_baseline/main.tex` has already been refreshed to the revised text, and the `20260930-203832-before-revision` snapshot stores only `pv_work/` and `verification/`. I checked the pre-revision wording and line numbers against the verbatim quotations in `L02_issue_1.md:12-30` and the revision mapping in `AUDIT.md:51-58` instead, which agree with the report.
- **Re-running the Lean builds**: not attempted (read-only role); I relied on the audits' recorded `EXIT=`/mech results and on reading the `.lean` sources.
- **The companion paper**: not in `source/`, as the records already state.

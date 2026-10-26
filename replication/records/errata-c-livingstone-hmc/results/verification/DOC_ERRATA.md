# Lean comment errata (comments only; no verdict is changed)

Audited Lean files are **no longer modified**: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" audit record.
Outdated or inaccurate comments are recorded here, and **this table takes precedence**.

If the user authorizes a change, proceed as follows:
1. change only comments;
2. with comments removed, the proof is byte-for-byte identical to the audited version;
3. rebuild the `.olean` (including everything downstream), and refresh the hashes in the audit records.

| # | File (location) | Current text (summary) | Should be | Source |
|---|---|---|---|---|
| 1 | `pv_work/L01Stmt.lean` l.15, l.22 | `Concl` called the "literal" reading and `ConclFixedDelta` the "alternative" | the two words swapped: `ConclFixedDelta` is the verdict-bearing statement | L01_final §8 |
| 2 | `RESULTS.json` registry text of `T02_L02Consumed` (not a Lean file) | mentions only part (a) | parts (a) and (b), as in `pv_work/T02Stmt.lean:101-104` | compiler check Mo7 |
| 3 | `pv_work/L01Stmt.lean` (stale entry 1 above) | Row 1 refers to the pre-revision file; current file has no "literal"/"alternative"/`ConclFixedDelta` wording | no action; row 1 obsolete | report consistency check Mo6 |
| 4 | `pv_work/Defs.lean` docstrings (l.66, 73, 78, 83) and `Defs.HypOscillations` (`2‖x‖`) | old TEX numbering ("TEX:865-867", "868-871", "874", "885, 900, 942"); stale (18) | revised numbering; revised (18) is `Paper.L03.HypOscillations3` (`3‖x‖`) | L01/L02/T02 gates |
| 5 | `pv_work/T02Stmt.lean:88` | GaussFacts docstring cites "TEX:879" | TEX:917-921 | T02_final, Mo6 |
| 6 | `pv_work/T01Stmt.lean` (docstrings of `T01Concl`, `T01_T02Consumed`) | random 𝔏 "is not covered"; "(not yet proved)" | random-L part (ii) is covered; part (i) stopped (T01_issue_1) | T01_gate_r2 |
| 7 | `pv_work/C01Stmt.lean:38`, S6 docstring | "(not yet re-proved after the revision)"; "the project has no random-𝔏 kernel" | C01 re-proved after the revision; random-L kernel exists in T02Stmt | C01_gate |
| 8 | `verification/EXTERNAL_TOOLS.md` registry (not Lean) | `T02_Prop35` `:78`, `T02_GaussFacts` `:88`, `T01_Thm518` `:25` | `:82`, `:92`, `:29`; "used by" fields per final audits | T02_final §8, T01_final §7 |

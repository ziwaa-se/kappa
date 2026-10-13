# Lean comment errata (comments only; no verdict is changed)

Audited Lean files are **no longer modified**: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" audit record.
Outdated or inaccurate comments are recorded here, and **this table takes precedence**.

If the user authorizes a change, proceed as follows:
1. change only comments;
2. with comments removed, the proof is byte-for-byte identical to the audited version;
3. rebuild the `.olean` (including everything downstream), and refresh the hashes in the audit records.

| # | File (location) | Current text (summary) | Should be | Source |
|---|---|---|---|---|
| 1 | pv_work/T01Stmt.lean:17 (docstring of `T01_L02Consumed`; this declaration was removed in revision 2, so the row is obsolete, kept for the record) | "used at main.tex:66-67" | "used at main.tex:65-66" (l.67 is `\end{proof}`) | source/main.tex:65-67; audits/T01_final.md §8 |
| 2 | pv_work/L01Stmt.lean:3 (docstring) | cites main.tex:38-40 | main.tex:39-41 (current lines) | audits/L01_final.md §7 |

# Lean comment errata (comments only; no verdict is changed)

Audited Lean files are **no longer modified**: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" audit record.
Outdated or inaccurate comments are recorded here, and **this table takes precedence**.

If the user authorizes a change, proceed as follows:
1. change only comments;
2. with comments removed, the proof is byte-for-byte identical to the audited version;
3. rebuild the `.olean` (including everything downstream), and refresh the hashes in the audit records.

| # | File (location) | Current text (summary) | Should be | Source |
|---|---|---|---|---|
| 1 | `pv_work/T01Stmt.lean:57-58` (docstring of `DonskerUniformSup`) | "EXTERNAL (i) Donsker + (ii) the continuous-functional step ... folded in" | type (i) only (T01_gate §6) | `verification/audits/T01_gate.md:73,98` |

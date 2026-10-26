# Lean comment errata (comments only; no verdict is changed)

Audited Lean files are **no longer modified**: docstrings go into the `.olean`, and a change would invalidate the "byte-for-byte identical" audit record.
Outdated or inaccurate comments are recorded here, and **this table takes precedence**.

If the user authorizes a change, proceed as follows:
1. change only comments;
2. with comments removed, the proof is byte-for-byte identical to the audited version;
3. rebuild the `.olean` (including everything downstream), and refresh the hashes in the audit records.

| # | File (location) | Current text (summary) | Should be | Source |
|---|---|---|---|---|
| 1 | `pv_work/P05.lean` docstrings of `Erep_nonneg` (l.163), `pt_bound1` (l.197) and comment in `P05_S0` (l.463) | cite "l.403" for "E(y) ≥ E{1(p>q)} = 1-λ ≥ 0 … one can easily verify that E has the given null hypothesis" | l.400 (l.403 is eq:expscore) | `source/VSIFP_02.tex:400`; found by pv-auditor, P05 final audit r2 (2026-10-13) |

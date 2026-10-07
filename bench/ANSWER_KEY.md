# Benchmark answer key (keep this file OUT of the project's `source/` directory)

The benchmark manuscript is `bench/paper/main.tex`. It has three numbered results. The expected verdicts
below follow `verification/rules/VERDICTS.md`.

| PDF no. | Kind | What it is | Expected verdict | Why |
|---|---|---|---|---|
| 2.1 | Lemma | `ab ≤ (a²+b²)/2`, with equality iff `a = b` | **UNCONDITIONAL** | Elementary. The paper proves both clauses completely. |
| 2.2 | Proposition | `S(x,y,z) ≥ 3(xy+yz+zx) / (2(x²+y²+z²))` for positive reals | **CONDITIONAL** | The proof cites Nesbitt's inequality `S ≥ 3/2`. It should become one visible external parameter of provenance type (i), unless Mathlib already has it. The proof also uses Lemma 2.1, so it depends on it. |
| 2.3 | Lemma | `x²/(1+x) ≥ x − 1` for every real `x ≠ −1` | **ISSUE**, preferably `ERROR` | **Planted error.** Multiplying by `1+x` keeps the inequality only when `1+x > 0`. The printed hypothesis `x ≠ −1` is not enough, and the statement is false for `x < −1`: at `x = −2`, the left side is `−4` and the right side is `−3`. A Lean counterexample is easy. `PAPER_ASSUMPTION_GAP` (the missing `x > −1`) is an acceptable secondary reading. The remark says later work uses only `x ≥ 0`, so downstream use is unaffected. |

## How runs are scored

- **Detection.** 2.3 must end as ISSUE, with a paper-side class and an independently reviewed counterexample or reasoning.
- **No false alarm.** 2.1 and 2.2 must not be ISSUE.
- **Conditions.** 2.2 should be CONDITIONAL on a Nesbitt parameter. UNCONDITIONAL is also acceptable if the run shows the fact is proved faithfully, or taken from Mathlib, with evidence.
- **UNFINISHED** counts against efficiency: a cheap run that gives up is not an improvement.

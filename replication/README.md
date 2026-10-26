# Replication materials

For "KAPPA: Checking the Proofs in Statistics Papers with Lean 4 and Language Model Agents" by Zihua She
and Xiao Wang (Purdue University).

These are the materials submitted with the paper to the Journal of Statistical Software. There, the kit is shipped
as archives in `../software`; in this repository, `replicate.sh` uses the repository itself as the kit.

## What can be reproduced, and how

A run of the kit uses a language model, whose output differs from run to run, and a new run needs a Claude Code
account. Everything the verdicts rest on, and every table of results, is reproduced here from the archived run
records without a language model:

```
./replicate.sh                      # tables only, a few seconds
./replicate.sh --replay <lean-env>  # also rebuilds every archived Lean file and reruns the mechanical audits
```

The run of `./replicate.sh --replay` for the paper, with its timings and versions, is in `replication_output.log`.
In it, every case is confirmed (`ok`), and the validator of the current kit accepts six of the seven records. The
record of `e1-sample-variance` ends with `validate: INVALID (3 errors)`: made with version 1.3.1, it gives placeholder
names (`Paper.L01.main`, `Paper.L02.main`, `Paper.P01.main`) in the `lean_main` field of three results, and the check
that catches such names came with version 1.3.3, after the runs. The Lean files of these three results rebuild and
pass the mechanical audit, so their verdicts stand; the records are kept as they were made.

Requirements: Python 3.6 or later and Bash. For `--replay`, a Lean 4.19.0 + Mathlib `c44e0c8e` environment, made once
with `autosetup/lean_env.sh <base> --download` from the kit in `../software` (it downloads Lean and the compiled
Mathlib, about 5 GB, into `<base>/lean-env`). The replay takes under an hour on an Apple M4 with 16 GB of memory;
it was run on macOS 26.6.2, and the kit's test suite also runs on Linux.

## Where each result comes from

| Paper | Source here | Reproduced by |
|---|---|---|
| Tables 8–11, costs and times in Sections 6 and 7 | `records/<case>/results/` (run records), `records/<case>/answer_key*.json` | `replicate.sh` (sections 2 and 3: `tools/make_tables.py`, the kit's `score.py`); output in `TABLES.md` |
| Lean listings, counterexamples, verdicts | `records/<case>/results/pv_work/*.lean`, `verification/` | `replicate.sh --replay` (the kit's `examples/tools/replay.py`) |
| Table 7 (where each mechanism occurred) | the records and reports of all cases | compiled by hand from the records |
| Table 12 (comparison with a direct use of the model) | `comparison/` | the gradings in `comparison/grading/` (summary in `comparison/SUMMARY.md`); the compilation, `sorry` and axiom checks are rerun by `replicate.sh --replay` (`tools/grade_lean.py`) |
| Table 13 (benchmark of the earlier design, version 1.2.1 in the kit's changelog, and of versions 1.3 and 1.3.1) | the kit's `bench/results/COMPARISON.md` and `COMPARISON_2026-10.md` | archived outputs of the kit's `bench/compare.py` |
| Table 14 (fact-check counts) | `factcheck*.md` in each record's `verification/report/` (and `report_archive/`); the first three rows from the reports of the kit's `examples/two-lemmas-demo` and `examples/full-workflow` (`results/report/factcheck_of_first_draft.md`, and the first report in `before-revision/report/AUTHOR_REPORT.md`, §8) | `replicate.sh` (fact-check column of `TABLES.md`) |

## Contents

- `records/`: one folder per case. `e1-sample-variance`, `e2-proportions`, `e3-shrinkage` and `e4-edf` are the four
  example papers written for the paper, each with the paper, its answer key and the complete record of its check.
  `errata-a-henzi-ziegel`, `errata-b-arab-lando-oliveira` and `errata-c-livingstone-hmc` are the three published papers,
  checked in their arXiv versions from before the correction (2103.08402v2, 2411.14926v2, 1601.08057v4) and then in a
  corrected version. These folders contain the answer key written from the published correction before the run, our
  hand checks of the findings that the key did not anticipate, a description of the corrected version, and the run
  record; the papers themselves are available from arXiv.
- A run record (`results/`) holds the verdicts (`verification/RESULTS.json`), the issues (`BLOCKERS.md`), every
  review and audit report (`verification/audits/`, earlier rounds in `audits/rev*/`), the Lean files (`pv_work/`,
  earlier rounds in `pv_work/superseded/`), the author reports and their fact checks (`verification/report/`,
  earlier rounds in `report_archive/`), the records before each revision (`verification/snapshots/`), the driver's
  log and a summary of every session (`sessions.json`). Local paths and user names were replaced by placeholders with
  the kit's `examples/tools/sanitize.py`; nothing else was edited. The full transcripts are not included; the blind
  audit of Section 6.1 was run on them.
- `keys/KEYS_LOG.md`: when each answer key was written, with its checksum, relative to the start of the runs.
- `comparison/`: the comparison of Section 7.1. The protocol and the grading rules, fixed before the runs
  (`BASELINE_PROTOCOL.md`), the grader's instructions, the gradings of every paper, the summary and a log of the
  runs, and for every baseline run its prompt, its final answer, its Lean files and their mechanical check.
- `tools/`: `make_tables.py`, `replay_all.sh` and `grade_lean.py`.

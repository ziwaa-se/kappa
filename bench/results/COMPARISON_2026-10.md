# v1.3 versus v1.3.1 on the benchmark paper, with the October 2026 models

**Paper:** `bench/paper/main.tex`, three numbered results: an easy lemma (2.1), a proposition resting on a cited
inequality (2.2), and a lemma with a planted error (2.3). Answer key: `bench/ANSWER_KEY.md`.

**Runs** (2026-10-12): two runs per version, all with `bench/run_bench.sh --driver --model sonnet`, the same Lean 4.19.0
and Mathlib `c44e0c8e` (all 6305 modules compiled), the same machine, and Claude Code 2.1.296. The models were
`claude-sonnet-5-5` and `claude-opus-5-5` (the September comparison in `COMPARISON.md` used `claude-sonnet-5` and
`claude-opus-5`). Costs are list-price estimates from the transcripts (`pv_usage.py`, with the v1.3.1 price table for all
four runs); for every run they agree with the cost Claude Code reported to within a cent. Full tables:
`COMPARISON_2026-10_raw.md`, made with `bench/compare.py`.

| Run | Kit | Run time | Cost | Verdicts as in the answer key | Unfinished |
|---|---|---:|---:|---|---:|
| G-v13-now-r1 | v1.3 | 17 min | $5.52 | 3/3 | 0 |
| G-v13-now-r2 | v1.3 | 10 min | $2.68 | **1/3** | 2 |
| H-v131-r1 | v1.3.1 | 14 min | $4.21 | 3/3 | 0 |
| H-v131-r2 | v1.3.1 | 16 min | $3.78 | 3/3 | 0 |

## What happened in G-v13-now-r2

The gate found the statement of Lemma 2.1 faithful, but could not run its own compile check and statement snapshot:
the permission system refused its commands, `scripts/pv_lean.sh check L01Draft; echo EXIT=$?` and the same script
called by its absolute path. Without that evidence the gate must fail, and it failed twice ("FAIL is procedural only"),
so 2.1 stopped as `GATE_FAILED` and 2.2, which depends on it, never started. The planted error in 2.3 was still found.
The run cost less because it did less.

v1.3.1 changes exactly this: the permission file allows every spelling of the kit's commands for the project's own path,
the role cards tell agents the one spelling to use and not to append `; echo EXIT=$?`, and the driver stops with a clear
message (exit status 7) when commands in their standard form are refused, instead of letting reviews fail for want of
evidence. In both v1.3.1 runs the auditor ran the mechanical checks itself (the reports name the auditor), and the only
refused commands were non-kit forms (a heredoc, a pipe into `head`, a search of the Mathlib sources by absolute path,
which v1.3.1 now allows through `additionalDirectories`).

## What this shows, and what it does not

- With the newer models, a complete run costs about the same with either version ($3.78–$5.52). The large saving of
  v1.3 over v1.2.1 (`COMPARISON.md`) was measured with the older models; most of the further drop since September comes
  from the models, not from v1.3.1, which changed robustness rather than efficiency.
- One of two v1.3 runs ended with two results unfinished for a reason unrelated to the paper; both v1.3.1 runs reached
  the answer key. Two runs per version show that the failure mode exists and that v1.3.1 removes its cause; they do not
  estimate how often it occurs.
- The benchmark is tiny and elementary; see `COMPARISON.md` for its other limits.

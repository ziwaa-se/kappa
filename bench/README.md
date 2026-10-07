# Benchmark: v1.2.1 versus v1.3

This benchmark measures what the efficiency changes in v1.3 save, and whether the checks still work. It is not
installed into paper projects.

| File | What it is |
|---|---|
| `paper/main.tex`, `main.pdf`, `main.aux` | A 3-result test paper: an easy lemma (2.1), a proposition that relies on a cited inequality (2.2), and a lemma with a **planted error** (2.3) |
| `ANSWER_KEY.md` | Expected verdicts and why. It is never copied into a project's `source/` |
| `run_bench.sh` | Installs a kit into a fresh project, adds the paper, and runs it unattended with `claude -p` |
| `compare.py` | Compares finished runs: tokens, list-price cost, wall clock, cost by role and model, verdicts scored against the answer key |
| `results/` | The measured comparison (`COMPARISON.md`) and per-run token reports |

## Run it

The runs use your Claude Code plan. The three-result paper costs a few dollars per run at list prices, and the per-run
table shows the actual figure. Each run needs a Lean project with the kit's Lean/Mathlib pins to link against.

```bash
bench/run_bench.sh /path/to/kit-v1.2.1 ~/bench-runs/A-r1 A-r1 --model opus --lean-from /path/to/pinned/project
```

```bash
bench/run_bench.sh . ~/bench-runs/G-r1 G-r1 --driver --model sonnet --lean-from /path/to/pinned/project
```

```bash
python3 bench/compare.py ~/bench-runs/A-r1 ~/bench-runs/G-r1 --out bench/results/COMPARISON.md
```

Both runs get the same unattended prompt. The baseline (A) runs v1.2.1 in one session with every role on Opus, as
before. v1.3 (G) uses the driver with a Sonnet coordinator and the per-role models in its agent definitions.

## Limits of this benchmark

- The paper is tiny and elementary. A research paper spends far more on proving and auditing, and far more coordinator
  context builds up over dozens of results. The rule cards, the driver and the prover escalation are likely to save
  more there, not less, but this benchmark does not show that.
- Model runs vary. Treat one run per configuration as an indication, not a measurement with error bars.
- Costs are list-price estimates. On a subscription plan they show relative consumption of the usage limit, not a bill.

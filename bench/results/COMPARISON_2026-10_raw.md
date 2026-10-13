## Benchmark runs: efficiency and quality

| Run | Kit | Coordinator | Sessions | Run time | Tokens (all kinds) | Est. cost (transcripts) | CLI-reported cost | Cost per verdict | Verdicts as expected | Planted error caught | False alarms | Unfinished |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|
| G-v13-now-r1 | v1.3 | sonnet + driver | 2 | 17 min | 12.42M | $5.52 | $5.52 | $1.84 | 3/3 | yes | 0 | 0 |
| G-v13-now-r2 | v1.3 | sonnet + driver | 2 | 10 min | 4.92M | $2.68 | $2.69 | $2.68 | 1/3 | yes | 0 | 2 |
| H-v131-r1 | v1.3.1 | sonnet + driver | 2 | 14 min | 8.79M | $4.21 | $4.21 | $1.40 | 3/3 | yes | 0 | 0 |
| H-v131-r2 | v1.3.1 | sonnet + driver | 2 | 16 min | 7.26M | $3.78 | $3.78 | $1.26 | 3/3 | yes | 0 | 0 |

### Per kit, over repeated runs (mean, and min–max)

| Kit | Runs | Cost | Tokens | Run time | Verdicts as expected |
|---|---:|---:|---:|---:|---|
| v1.3 | 2 | $4.10 ($2.68–$5.52) | 8.7M (4.9–12.4M) | 13 min (10–17) | 3/3, 1/3 |
| v1.3.1 | 2 | $3.99 ($3.78–$4.21) | 8.0M (7.3–8.8M) | 15 min (14–16) | 3/3, 3/3 |

### Cost by role (list-price estimate from the transcripts)

| Role | G-v13-now-r1 | G-v13-now-r2 | H-v131-r1 | H-v131-r2 |
|---|---:|---:|---:|---:|
| coordinator | $1.80 (2×, 8.92M) | $0.98 (2×, 3.63M) | $1.24 (2×, 5.49M) | $1.00 (2×, 4.11M) |
| pv-architect | $0.15 (1×, 0.27M) | $0.11 (1×, 0.10M) | $0.13 (1×, 0.19M) | $0.12 (1×, 0.17M) |
| pv-drafter | $0.19 (3×, 0.18M) | $0.15 (2×, 0.13M) | $0.18 (3×, 0.23M) | $0.20 (3×, 0.28M) |
| pv-gate | $1.36 (6×, 0.81M) | $0.82 (4×, 0.56M) | $0.82 (3×, 0.63M) | $0.75 (3×, 0.53M) |
| pv-prover | $0.28 (3×, 0.56M) | — | $0.28 (3×, 0.70M) | $0.29 (3×, 0.63M) |
| pv-auditor | $1.46 (5×, 1.47M) | $0.27 (1×, 0.21M) | $1.25 (4×, 1.31M) | $1.06 (3×, 1.17M) |
| pv-issue-checker | $0.28 (1×, 0.22M) | $0.35 (1×, 0.29M) | $0.31 (1×, 0.24M) | $0.36 (1×, 0.36M) |

### Cost by model

| Model | G-v13-now-r1 | G-v13-now-r2 | H-v131-r1 | H-v131-r2 |
|---|---:|---:|---:|---:|
| claude-opus-5-5 | $3.10 | $1.44 | $2.38 | $2.17 |
| claude-sonnet-5-5 | $2.43 | $1.24 | $1.83 | $1.61 |

### Verdicts (expected: 2.1 UNCONDITIONAL, 2.2 CONDITIONAL on Nesbitt, 2.3 ISSUE — planted error)

| PDF no. | Expected | G-v13-now-r1 | G-v13-now-r2 | H-v131-r1 | H-v131-r2 |
|---|---|---|---|---|---|
| 2.1 | UNCONDITIONAL | UNCONDITIONAL | UNFINISHED (GATE_FAILED) | UNCONDITIONAL | UNCONDITIONAL |
| 2.2 | CONDITIONAL | CONDITIONAL (conditions: NesbittInequality) | UNFINISHED (WAITING_ON_DEPENDENCY) | CONDITIONAL (conditions: NesbittTool) | CONDITIONAL (conditions: A01_Nesbitt) |
| 2.3 | ISSUE | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) |

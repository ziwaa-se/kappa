## Benchmark runs: efficiency and quality

| Run | Kit | Coordinator | Sessions | Run time | Tokens (all kinds) | Est. cost (transcripts) | CLI-reported cost | Cost per verdict | Verdicts as expected | Planted error caught | False alarms | Unfinished |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|
| A-v121-r1 | v1.2.1 | opus | 2 | 84 min | 73.18M | $71.15 | $71.15 | $23.72 | 3/3 | yes | 0 | 0 |
| A-v121-r2 | v1.2.1 | opus | 2 | 83 min | 64.09M | $65.04 | $65.04 | $21.68 | 3/3 | yes | 0 | 0 |
| G-v13-r1 | v1.3 | sonnet + driver | 3 | 51 min | 31.24M | $17.73 | $17.73 | $5.91 | 3/3 | yes | 0 | 0 |
| G-v13-r2 | v1.3 | sonnet + driver | 2 | 30 min | 21.86M | $13.68 | $13.68 | $4.56 | 3/3 | yes | 0 | 0 |

### Per kit, over repeated runs (mean, and min–max)

| Kit | Runs | Cost | Tokens | Run time | Verdicts as expected |
|---|---:|---:|---:|---:|---|
| v1.2.1 | 2 | $68.09 ($65.04–$71.15) | 68.6M (64.1–73.2M) | 83 min (83–84) | 3/3, 3/3 |
| v1.3 | 2 | $15.70 ($13.68–$17.73) | 26.5M (21.9–31.2M) | 41 min (30–51) | 3/3, 3/3 |

### Cost by role (list-price estimate from the transcripts)

| Role | A-v121-r1 | A-v121-r2 | G-v13-r1 | G-v13-r2 |
|---|---:|---:|---:|---:|
| coordinator | $25.41 (2×, 34.32M) | $18.60 (2×, 22.82M) | $5.81 (3×, 18.62M) | $4.16 (2×, 13.93M) |
| pv-architect | $1.32 (1×, 0.88M) | $1.40 (1×, 0.89M) | $0.32 (1×, 0.59M) | $0.30 (1×, 0.39M) |
| pv-drafter | $7.97 (4×, 6.98M) | $6.33 (3×, 4.95M) | $1.59 (3×, 3.44M) | $1.02 (3×, 1.55M) |
| pv-gate | $8.84 (4×, 6.55M) | $7.28 (3×, 5.71M) | $3.62 (3×, 2.36M) | $2.91 (3×, 1.55M) |
| pv-prover | $8.60 (4×, 7.33M) | $7.52 (4×, 5.83M) | $1.42 (3×, 3.10M) | $0.70 (2×, 1.37M) |
| pv-auditor | $17.66 (5×, 16.35M) | $21.90 (5×, 22.42M) | $4.03 (4×, 2.60M) | $3.44 (3×, 2.32M) |
| pv-issue-checker | $1.35 (1×, 0.75M) | $2.01 (1×, 1.48M) | $0.93 (1×, 0.53M) | $1.06 (1×, 0.71M) |
| general-purpose | — | — | — | $0.09 (1×, 0.03M) |

### Cost by model

| Model | A-v121-r1 | A-v121-r2 | G-v13-r1 | G-v13-r2 |
|---|---:|---:|---:|---:|
| claude-opus-5 | $71.15 | $65.04 | $8.58 | $7.41 |
| claude-sonnet-5 | — | — | $9.14 | $6.27 |

### Verdicts (expected: 2.1 UNCONDITIONAL, 2.2 CONDITIONAL on Nesbitt, 2.3 ISSUE — planted error)

| PDF no. | Expected | A-v121-r1 | A-v121-r2 | G-v13-r1 | G-v13-r2 |
|---|---|---|---|---|---|
| 2.1 | UNCONDITIONAL | UNCONDITIONAL | UNCONDITIONAL | UNCONDITIONAL | UNCONDITIONAL |
| 2.2 | CONDITIONAL | CONDITIONAL (conditions: NesbittInequality) | CONDITIONAL (conditions: NesbittInequality) | CONDITIONAL (conditions: P01_Nesbitt) | CONDITIONAL (conditions: P01_NesbittInequality) |
| 2.3 | ISSUE | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) | ISSUE (codes: ERROR; ISSUE_RECORDED) |

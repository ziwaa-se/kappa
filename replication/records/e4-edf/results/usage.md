## Token use — e4-edf-check (wall clock 214 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 5 | 122 | 244 | 275k | 8.69M | 52k | $2.49 | 17% | 80 |
| pv-architect | 1 | 8 | 16 | 15k | 121k | 5k | $0.10 | 1% | 0 |
| pv-drafter | 4 | 38 | 78 | 61k | 742k | 24k | $0.47 | 3% | 20 |
| pv-gate | 4 | 54 | 108 | 227k | 1.59M | 60k | $2.66 | 19% | 41 |
| pv-prover | 5 | 87 | 174 | 235k | 3.40M | 99k | $3.38 | 24% | 26 |
| pv-auditor | 5 | 78 | 156 | 274k | 3.39M | 56k | $3.17 | 22% | 26 |
| pv-issue-checker | 1 | 10 | 20 | 35k | 273k | 11k | $0.44 | 3% | 2 |
| pv-compiler | 1 | 10 | 20 | 82k | 389k | 16k | $0.40 | 3% | 2 |
| pv-factcheck | 1 | 17 | 34 | 119k | 1.28M | 18k | $1.21 | 8% | 3 |
| **total** | 27 | 424 | 850 | 1.32M | 19.89M | 340k | **$14.32** | 100% | 200 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 13 | 197 | 394 | 826k | 8.75M | 227k | $10.42 | 73% | 92 |
| claude-sonnet-5-5 | 14 | 227 | 456 | 497k | 11.14M | 113k | $3.90 | 27% | 108 |
| **total** | 27 | 424 | 850 | 1.32M | 19.89M | 340k | **$14.32** | 100% | 200 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 8 | 157 | 314 | 491k | 10.48M | 90k | $4.20 | 29% | 86 |
| D01 | 1 | 5 | 10 | 10k | 69k | 3k | $0.06 | 0% | 1 |
| DEFS | 1 | 7 | 14 | 16k | 117k | 6k | $0.22 | 2% | 3 |
| L01 | 4 | 44 | 88 | 86k | 857k | 19k | $0.80 | 6% | 21 |
| P01 | 4 | 78 | 156 | 171k | 2.37M | 44k | $2.02 | 14% | 25 |
| T01 | 9 | 133 | 268 | 550k | 5.98M | 177k | $7.03 | 49% | 64 |
| **total** | 27 | 424 | 850 | 1.32M | 19.89M | 340k | **$14.32** | 100% | 200 |

### Check against the cost Claude Code reported (5 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $10.42 | $10.42 | +0.0% |
| claude-sonnet-5-5 | $3.90 | $3.90 | +0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

## Token use — errata-c-livingstone-hmc-check (wall clock 858 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 10 | 416 | 832 | 846k | 40.14M | 190k | $9.30 | 14% | 241 |
| pv-architect | 1 | 16 | 32 | 84k | 961k | 25k | $0.56 | 1% | 3 |
| pv-drafter | 22 | 222 | 444 | 817k | 7.31M | 236k | $5.13 | 8% | 44 |
| pv-gate | 22 | 314 | 628 | 1.32M | 14.55M | 462k | $18.73 | 28% | 100 |
| pv-prover | 19 | 320 | 640 | 907k | 14.60M | 365k | $7.55 | 11% | 70 |
| pv-auditor | 19 | 353 | 706 | 1.11M | 17.03M | 281k | $14.60 | 22% | 90 |
| pv-issue-checker | 4 | 90 | 180 | 288k | 4.58M | 94k | $4.25 | 6% | 19 |
| pv-compiler | 2 | 36 | 72 | 382k | 4.31M | 89k | $2.27 | 3% | 10 |
| pv-factcheck | 2 | 65 | 130 | 416k | 8.19M | 76k | $5.24 | 8% | 12 |
| **total** | 101 | 1832 | 4k | 6.17M | 111.69M | 1.82M | **$67.63** | 100% | 588 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 48 | 834 | 2k | 3.16M | 44.65M | 920k | $43.15 | 64% | 222 |
| claude-sonnet-5-5 | 53 | 998 | 2k | 3.01M | 67.04M | 899k | $24.48 | 36% | 366 |
| **total** | 101 | 1832 | 4k | 6.17M | 111.69M | 1.82M | **$67.63** | 100% | 588 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 15 | 533 | 1k | 1.73M | 53.60M | 380k | $17.37 | 26% | 266 |
| C01 | 14 | 241 | 482 | 820k | 11.89M | 272k | $9.41 | 14% | 53 |
| DEFS | 2 | 18 | 36 | 69k | 534k | 21k | $0.68 | 1% | 11 |
| L01 | 14 | 160 | 320 | 465k | 4.58M | 134k | $4.82 | 7% | 44 |
| L02 | 14 | 216 | 432 | 765k | 10.00M | 281k | $8.87 | 13% | 63 |
| L03 | 10 | 162 | 324 | 545k | 7.35M | 178k | $5.80 | 9% | 44 |
| T01 | 18 | 262 | 524 | 854k | 10.95M | 242k | $10.01 | 15% | 51 |
| T02 | 14 | 240 | 480 | 925k | 12.79M | 310k | $10.67 | 16% | 56 |
| **total** | 101 | 1832 | 4k | 6.17M | 111.69M | 1.82M | **$67.63** | 100% | 588 |

### Check against the cost Claude Code reported (11 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $43.15 | $43.16 | -0.0% |
| claude-sonnet-5-5 | $24.48 | $24.49 | -0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

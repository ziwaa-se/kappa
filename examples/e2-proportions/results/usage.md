## Token use — e2-proportions-check (wall clock 208 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 5 | 169 | 338 | 307k | 13.78M | 57k | $3.18 | 22% | 74 |
| pv-architect | 1 | 8 | 16 | 17k | 127k | 5k | $0.11 | 1% | 1 |
| pv-drafter | 8 | 59 | 122 | 110k | 1.01M | 26k | $0.64 | 4% | 28 |
| pv-gate | 8 | 83 | 166 | 233k | 1.78M | 66k | $2.84 | 19% | 41 |
| pv-prover | 6 | 92 | 184 | 91k | 1.76M | 26k | $0.67 | 5% | 24 |
| pv-auditor | 9 | 114 | 232 | 328k | 3.08M | 63k | $3.51 | 24% | 49 |
| pv-issue-checker | 3 | 49 | 98 | 104k | 1.31M | 35k | $1.49 | 10% | 10 |
| pv-compiler | 1 | 11 | 22 | 103k | 657k | 21k | $0.54 | 4% | 2 |
| pv-factcheck | 1 | 23 | 46 | 170k | 2.15M | 24k | $1.76 | 12% | 3 |
| **total** | 42 | 608 | 1k | 1.46M | 25.65M | 324k | **$14.73** | 100% | 232 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 21 | 269 | 542 | 835k | 8.32M | 188k | $9.60 | 65% | 103 |
| claude-sonnet-5-5 | 21 | 339 | 682 | 629k | 17.33M | 137k | $5.13 | 35% | 129 |
| **total** | 42 | 608 | 1k | 1.46M | 25.65M | 324k | **$14.73** | 100% | 232 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 8 | 211 | 422 | 597k | 16.71M | 108k | $5.58 | 38% | 80 |
| DEFS | 2 | 10 | 20 | 36k | 135k | 7k | $0.29 | 2% | 4 |
| L01 | 4 | 38 | 76 | 72k | 655k | 16k | $0.66 | 4% | 19 |
| L02 | 6 | 72 | 146 | 149k | 1.56M | 39k | $1.67 | 11% | 26 |
| L03 | 6 | 90 | 182 | 200k | 2.25M | 49k | $2.16 | 15% | 52 |
| P01 | 6 | 73 | 148 | 168k | 1.76M | 47k | $1.79 | 12% | 26 |
| P02 | 4 | 40 | 80 | 67k | 757k | 18k | $0.67 | 5% | 6 |
| P03 | 6 | 74 | 150 | 174k | 1.82M | 42k | $1.91 | 13% | 19 |
| **total** | 42 | 608 | 1k | 1.46M | 25.65M | 324k | **$14.73** | 100% | 232 |

### Check against the cost Claude Code reported (5 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $9.60 | $9.61 | -0.1% |
| claude-sonnet-5-5 | $5.13 | $5.13 | +0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

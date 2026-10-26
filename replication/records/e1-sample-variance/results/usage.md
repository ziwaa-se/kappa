## Token use — e1-release-check (wall clock 213 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 5 | 174 | 348 | 354k | 13.73M | 67k | $3.47 | 24% | 81 |
| pv-architect | 1 | 9 | 18 | 24k | 150k | 6k | $0.14 | 1% | 1 |
| pv-drafter | 8 | 60 | 122 | 113k | 1.06M | 29k | $0.68 | 5% | 24 |
| pv-gate | 8 | 80 | 160 | 215k | 1.67M | 63k | $2.66 | 18% | 44 |
| pv-prover | 7 | 92 | 184 | 125k | 1.82M | 33k | $0.96 | 7% | 19 |
| pv-auditor | 8 | 107 | 218 | 265k | 3.20M | 66k | $3.28 | 23% | 34 |
| pv-issue-checker | 3 | 37 | 74 | 108k | 962k | 31k | $1.36 | 9% | 8 |
| pv-compiler | 1 | 9 | 18 | 90k | 355k | 15k | $0.41 | 3% | 2 |
| pv-factcheck | 1 | 23 | 46 | 136k | 1.96M | 23k | $1.53 | 11% | 4 |
| **total** | 42 | 591 | 1k | 1.43M | 24.91M | 335k | **$14.50** | 100% | 216 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 21 | 256 | 516 | 752k | 8.03M | 187k | $9.11 | 63% | 95 |
| claude-sonnet-5-5 | 21 | 335 | 672 | 678k | 16.88M | 147k | $5.39 | 37% | 122 |
| **total** | 42 | 591 | 1k | 1.43M | 24.91M | 335k | **$14.50** | 100% | 216 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 9 | 219 | 438 | 613k | 16.25M | 114k | $5.60 | 39% | 89 |
| C01 | 6 | 78 | 158 | 206k | 2.18M | 51k | $2.25 | 16% | 24 |
| DEFS | 1 | 8 | 16 | 14k | 128k | 5k | $0.20 | 1% | 3 |
| L01 | 4 | 44 | 88 | 62k | 804k | 17k | $0.64 | 4% | 20 |
| L02 | 4 | 35 | 70 | 79k | 649k | 17k | $0.74 | 5% | 20 |
| L03 | 6 | 78 | 158 | 159k | 2.00M | 45k | $1.87 | 13% | 16 |
| P01 | 6 | 67 | 136 | 139k | 1.38M | 38k | $1.42 | 10% | 25 |
| P02 | 6 | 62 | 124 | 158k | 1.52M | 48k | $1.78 | 12% | 18 |
| **total** | 42 | 591 | 1k | 1.43M | 24.91M | 335k | **$14.50** | 100% | 216 |

### Check against the cost Claude Code reported (5 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $9.11 | $9.15 | -0.4% |
| claude-sonnet-5-5 | $5.39 | $5.39 | +0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

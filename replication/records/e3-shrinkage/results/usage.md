## Token use — e3-shrinkage-check (wall clock 230 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 9 | 245 | 490 | 534k | 17.43M | 105k | $4.93 | 29% | 94 |
| pv-architect | 1 | 8 | 16 | 18k | 136k | 7k | $0.13 | 1% | 1 |
| pv-drafter | 10 | 70 | 142 | 143k | 1.22M | 39k | $0.87 | 5% | 20 |
| pv-gate | 9 | 99 | 200 | 237k | 2.23M | 76k | $3.14 | 18% | 33 |
| pv-prover | 8 | 142 | 284 | 155k | 3.09M | 42k | $1.12 | 6% | 13 |
| pv-auditor | 9 | 131 | 264 | 284k | 3.73M | 69k | $3.56 | 21% | 32 |
| pv-issue-checker | 1 | 13 | 26 | 34k | 356k | 11k | $0.46 | 3% | 4 |
| pv-compiler | 2 | 18 | 36 | 121k | 551k | 23k | $0.59 | 3% | 3 |
| pv-factcheck | 2 | 38 | 76 | 213k | 2.46M | 45k | $2.47 | 14% | 7 |
| **total** | 51 | 764 | 2k | 1.74M | 31.21M | 416k | **$17.25** | 100% | 206 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 21 | 281 | 566 | 768k | 8.78M | 201k | $9.62 | 56% | 76 |
| claude-sonnet-5-5 | 30 | 483 | 968 | 971k | 22.43M | 215k | $7.62 | 44% | 130 |
| **total** | 51 | 764 | 2k | 1.74M | 31.21M | 416k | **$17.25** | 100% | 206 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 14 | 309 | 618 | 887k | 20.57M | 180k | $8.11 | 47% | 104 |
| C01 | 9 | 109 | 218 | 201k | 2.59M | 57k | $2.16 | 13% | 29 |
| D01 | 2 | 11 | 22 | 24k | 165k | 7k | $0.24 | 1% | 4 |
| L01 | 8 | 90 | 182 | 159k | 1.81M | 43k | $1.61 | 9% | 22 |
| L02 | 10 | 148 | 300 | 261k | 3.67M | 72k | $2.89 | 17% | 36 |
| T01 | 8 | 97 | 194 | 209k | 2.40M | 57k | $2.24 | 13% | 11 |
| **total** | 51 | 764 | 2k | 1.74M | 31.21M | 416k | **$17.25** | 100% | 206 |

### Check against the cost Claude Code reported (9 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $9.62 | $9.62 | +0.0% |
| claude-sonnet-5-5 | $7.62 | $7.62 | +0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

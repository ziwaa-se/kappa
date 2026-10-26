## Token use — errata-b-arab-lando-oliveira-check (wall clock 843 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 11 | 471 | 942 | 953k | 42.23M | 186k | $9.90 | 12% | 224 |
| pv-architect | 1 | 14 | 28 | 64k | 604k | 28k | $0.50 | 1% | 3 |
| pv-drafter | 20 | 170 | 342 | 574k | 4.49M | 166k | $3.55 | 4% | 46 |
| pv-gate | 21 | 232 | 464 | 944k | 7.80M | 367k | $13.63 | 17% | 76 |
| pv-prover | 15 | 338 | 676 | 919k | 17.34M | 412k | $9.07 | 11% | 55 |
| pv-auditor | 23 | 398 | 804 | 1.24M | 18.81M | 310k | $16.18 | 20% | 97 |
| pv-issue-checker | 13 | 290 | 582 | 910k | 15.24M | 332k | $14.25 | 18% | 66 |
| pv-compiler | 3 | 70 | 140 | 732k | 10.62M | 156k | $4.45 | 6% | 17 |
| pv-factcheck | 2 | 92 | 184 | 589k | 16.52M | 94k | $8.14 | 10% | 17 |
| general-purpose | 1 | 15 | 30 | 137k | 1.42M | 31k | $0.80 | 1% | 3 |
| **total** | 110 | 2090 | 4k | 7.06M | 135.08M | 2.08M | **$80.46** | 100% | 604 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 62 | 1053 | 2k | 3.84M | 59.97M | 1.14M | $54.02 | 67% | 262 |
| claude-sonnet-5-5 | 48 | 1037 | 2k | 3.23M | 75.11M | 943k | $26.45 | 33% | 343 |
| **total** | 110 | 2090 | 4k | 7.06M | 135.08M | 2.08M | **$80.46** | 100% | 604 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 17 | 647 | 1k | 2.34M | 69.98M | 465k | $23.00 | 29% | 262 |
| L01 | 4 | 59 | 122 | 141k | 1.87M | 51k | $1.96 | 2% | 22 |
| L02 | 8 | 107 | 216 | 266k | 3.23M | 80k | $3.02 | 4% | 21 |
| P01 | 6 | 95 | 190 | 260k | 3.73M | 106k | $3.06 | 4% | 34 |
| P02 | 11 | 151 | 304 | 493k | 6.41M | 180k | $6.02 | 7% | 60 |
| P03 | 9 | 142 | 284 | 392k | 5.03M | 109k | $4.37 | 5% | 23 |
| P04 | 10 | 166 | 334 | 525k | 7.60M | 203k | $7.67 | 10% | 33 |
| P05 | 6 | 90 | 180 | 318k | 3.82M | 111k | $3.64 | 5% | 16 |
| P06 | 4 | 52 | 104 | 163k | 1.69M | 58k | $1.70 | 2% | 9 |
| T01 | 10 | 137 | 274 | 518k | 5.91M | 178k | $6.54 | 8% | 32 |
| T02 | 15 | 301 | 602 | 1.17M | 19.60M | 393k | $13.40 | 17% | 65 |
| T03 | 4 | 74 | 150 | 300k | 4.23M | 98k | $4.10 | 5% | 18 |
| T04 | 6 | 69 | 138 | 181k | 1.98M | 54k | $1.98 | 2% | 8 |
| **total** | 110 | 2090 | 4k | 7.06M | 135.08M | 2.08M | **$80.46** | 100% | 605 |

### Check against the cost Claude Code reported (11 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $54.02 | $54.03 | -0.0% |
| claude-sonnet-5-5 | $26.44 | $26.45 | -0.0% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

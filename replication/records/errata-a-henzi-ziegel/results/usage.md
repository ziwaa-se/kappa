## Token use — errata-a-henzi-ziegel-check (wall clock 827 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 9 | 300 | 600 | 741k | 25.60M | 148k | $7.01 | 12% | 213 |
| pv-architect | 2 | 41 | 82 | 195k | 2.92M | 58k | $1.36 | 2% | 7 |
| pv-drafter | 13 | 109 | 220 | 537k | 3.71M | 169k | $3.41 | 6% | 26 |
| pv-gate | 13 | 152 | 304 | 846k | 7.05M | 326k | $12.16 | 20% | 64 |
| pv-prover | 10 | 227 | 454 | 859k | 14.43M | 363k | $8.02 | 13% | 65 |
| pv-auditor | 13 | 299 | 604 | 1.08M | 19.38M | 226k | $13.78 | 23% | 85 |
| pv-issue-checker | 5 | 119 | 238 | 409k | 6.81M | 151k | $6.43 | 11% | 27 |
| pv-compiler | 2 | 45 | 90 | 410k | 5.58M | 93k | $2.51 | 4% | 11 |
| pv-factcheck | 2 | 70 | 140 | 458k | 9.56M | 76k | $5.72 | 9% | 12 |
| **total** | 69 | 1362 | 3k | 5.53M | 95.04M | 1.61M | **$60.40** | 100% | 510 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5-5 | 34 | 658 | 1k | 2.91M | 44.16M | 815k | $39.69 | 66% | 194 |
| claude-sonnet-5-5 | 35 | 704 | 1k | 2.62M | 50.88M | 796k | $20.71 | 34% | 316 |
| **total** | 69 | 1362 | 3k | 5.53M | 95.04M | 1.61M | **$60.40** | 100% | 510 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 15 | 456 | 912 | 1.80M | 43.67M | 375k | $16.60 | 27% | 243 |
| D01 | 1 | 6 | 14 | 27k | 143k | 8k | $0.16 | 0% | 4 |
| DEFS | 3 | 22 | 44 | 128k | 576k | 32k | $1.32 | 2% | 18 |
| P04 | 14 | 253 | 506 | 1.17M | 16.61M | 423k | $13.19 | 22% | 68 |
| P05 | 19 | 328 | 656 | 1.27M | 17.68M | 381k | $15.19 | 25% | 68 |
| T01 | 7 | 127 | 260 | 465k | 7.13M | 139k | $5.58 | 9% | 55 |
| T02 | 6 | 118 | 236 | 500k | 7.44M | 193k | $6.41 | 11% | 43 |
| T03 | 4 | 52 | 104 | 166k | 1.79M | 60k | $1.96 | 3% | 11 |
| **total** | 69 | 1362 | 3k | 5.53M | 95.04M | 1.61M | **$60.40** | 100% | 510 |

### Check against the cost Claude Code reported (9 headless sessions)

| model | this script | Claude Code | difference |
|---|---:|---:|---:|
| claude-opus-5-5 | $39.69 | $39.71 | -0.1% |
| claude-sonnet-5-5 | $20.71 | $20.73 | -0.1% |

Sessions without a Claude Code figure (interactive or setup sessions, not in the driver logs): $0.00. A difference of more than a few cents for one model means its row in PRICES is out of date; the token counts are the same.

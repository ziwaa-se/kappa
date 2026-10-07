## Token use — W2-v13-workflow (wall clock 96 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 5 | 293 | 586 | 551k | 39.86M | 160k | $11.78 | 35% | 95 |
| pv-architect | 1 | 11 | 22 | 33k | 241k | 12k | $0.25 | 1% | 2 |
| pv-drafter | 4 | 73 | 146 | 167k | 2.48M | 61k | $1.53 | 5% | 10 |
| pv-gate | 4 | 93 | 186 | 192k | 3.11M | 83k | $4.82 | 14% | 19 |
| pv-prover | 3 | 48 | 96 | 133k | 1.74M | 26k | $0.94 | 3% | 5 |
| pv-auditor | 4 | 73 | 146 | 207k | 2.68M | 68k | $4.34 | 13% | 16 |
| pv-issue-checker | 1 | 24 | 48 | 58k | 920k | 21k | $1.35 | 4% | 5 |
| pv-compiler | 2 | 30 | 60 | 241k | 2.24M | 51k | $1.56 | 5% | 8 |
| pv-factcheck | 2 | 75 | 150 | 295k | 6.35M | 88k | $7.22 | 21% | 19 |
| **total** | 26 | 720 | 1k | 1.88M | 59.63M | 570k | **$33.79** | 100% | 179 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5 | 11 | 265 | 530 | 753k | 13.06M | 260k | $17.73 | 52% | 59 |
| claude-sonnet-5 | 15 | 455 | 910 | 1.12M | 46.56M | 310k | $16.06 | 48% | 120 |
| **total** | 26 | 720 | 1k | 1.88M | 59.63M | 570k | **$33.79** | 100% | 179 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 10 | 409 | 818 | 1.12M | 48.70M | 310k | $20.80 | 62% | 124 |
| L01 | 4 | 69 | 138 | 156k | 2.08M | 51k | $2.33 | 7% | 11 |
| L02 | 8 | 146 | 292 | 357k | 4.93M | 122k | $6.35 | 19% | 26 |
| P01 | 4 | 96 | 192 | 244k | 3.92M | 86k | $4.32 | 13% | 18 |
| **total** | 26 | 720 | 1k | 1.88M | 59.63M | 570k | **$33.79** | 100% | 179 |

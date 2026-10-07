## Token use — G-v13-r2 (wall clock 30 min; costs are list-price estimates)

### By role

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| coordinator | 2 | 120 | 240 | 216k | 13.66M | 56k | $4.16 | 30% | 30 |
| pv-architect | 1 | 15 | 30 | 36k | 341k | 14k | $0.30 | 2% | 2 |
| pv-drafter | 3 | 43 | 86 | 110k | 1.40M | 46k | $1.02 | 7% | 8 |
| pv-gate | 3 | 48 | 96 | 124k | 1.37M | 58k | $2.91 | 21% | 12 |
| pv-prover | 2 | 35 | 70 | 86k | 1.27M | 23k | $0.70 | 5% | 3 |
| pv-auditor | 3 | 50 | 100 | 171k | 2.10M | 53k | $3.44 | 25% | 12 |
| pv-issue-checker | 1 | 20 | 40 | 49k | 640k | 17k | $1.06 | 8% | 4 |
| general-purpose | 1 | 1 | 2 | 34k | 0 | 286 | $0.09 | 1% | 0 |
| **total** | 16 | 332 | 664 | 826k | 20.76M | 269k | **$13.68** | 100% | 72 |

### By model

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| claude-opus-5 | 7 | 118 | 236 | 344k | 4.10M | 128k | $7.41 | 54% | 28 |
| claude-sonnet-5 | 9 | 214 | 428 | 482k | 16.66M | 141k | $6.27 | 46% | 44 |
| **total** | 16 | 332 | 664 | 826k | 20.76M | 269k | **$13.68** | 100% | 72 |

### By result

| | agents | responses | input | cache write | cache read | output | est. cost | share | agent-minutes |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| - | 4 | 136 | 272 | 286k | 14.00M | 71k | $4.55 | 33% | 33 |
| L01 | 4 | 47 | 94 | 133k | 1.17M | 42k | $1.72 | 13% | 8 |
| L02 | 4 | 76 | 152 | 191k | 2.71M | 79k | $3.77 | 28% | 17 |
| P01 | 4 | 73 | 146 | 216k | 2.88M | 77k | $3.64 | 27% | 14 |
| **total** | 16 | 332 | 664 | 826k | 20.76M | 269k | **$13.68** | 100% | 72 |

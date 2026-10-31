# Example E2: variance bounds for proportions and sums

A paper with six results about $V_n(p) = p(1-p)/n$ for $p$ in "the unit interval" $I$ and the sample variance of a
sum, written for the kit with an answer key fixed before the run ([ANSWER_KEY.md](ANSWER_KEY.md)). Paper:
[`paper/main.tex`](paper/main.tex) ([PDF](paper/main.pdf)).

| No. | Result | Planted feature |
|---|---|---|
| 2.1 | $V_n(p) \le \frac1{4n}$ | — |
| 2.2 | $V_n(p) > 0$ on $I$ | true for $(0,1)$, false for $[0,1]$; the paper never says which |
| 2.3 | midpoint concavity of $\sqrt{V_n}$ | rests on a fact asserted as "well known" |
| 2.4 | $V_n(p) \le \frac{p}{4n}$ | **false** |
| 2.5 | $\exists C\ \forall n:\ V_n(p) \le C/n$ | the order of the quantifiers |
| 2.6 | $s^2(x+y) \le 2s^2(x) + 2s^2(y)$ | true, but the first step needs a vanishing covariance |

## Result

| No. | ID | Expected | Run | Score |
|---|---|---|---|---|
| 2.1 | L01 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.2 | L02 | ISSUE:DOMAIN_CLARIFICATION | ISSUE:DOMAIN_CLARIFICATION | agrees |
| 2.3 | P01 | CONDITIONAL:ii | UNCONDITIONAL | differs |
| 2.4 | L03 | ISSUE:ERROR | ISSUE:ERROR | agrees |
| 2.5 | P02 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.6 | P03 | ISSUE:PAPER_ASSUMPTION_GAP / ISSUE:PAPER_ARGUMENT_GAP | ISSUE:PAPER_ARGUMENT_GAP | agrees |

5 agrees, 1 differs

- **2.2:** recorded as `DOMAIN_CLARIFICATION`, with the open reading proved and the closed reading refuted at $p = 0$.
- **2.4:** refuted at $n = 1$, $p = 1/10$; the issue record adds that the bound holds on $(0,1)$ exactly for $p \ge 3/4$.
- **2.5:** the gated statement puts the constant first, as the gate's report requires.
- **2.6:** the first step is refuted at $x = y = (0,1)$; the conclusion is not.
- **2.3 differs from the key.** The key expected a verdict conditional on the asserted concavity (an input of
  provenance (ii)). The gate derived the fact from Mathlib and the final audit ruled the sentence a fair implicit step,
  so the result is verified unconditionally; the report lists the decision among the boundary cases. The rules allow
  both readings; we intend to change the rule in the next version so that explicitly asserted facts stay inputs.
- **Time and cost:** 75 minutes, $14.74. The fact check found 11 problems in the first draft of the report
  (1 major, 3 moderate, 7 minor).

## How this run was made

- Kit v1.3.1 as released (commit `338b9d9`), Claude Code 2.1.296, models `claude-sonnet-5-5` (coordinator, drafter,
  prover, compiler) and `claude-opus-5-5` (gate, auditor, issue checker, fact check, second proof attempts),
  Lean 4.19.0, Mathlib `c44e0c8e`; unattended driver with `--auto-resume --report`.
- **Blind.** The answer key was written before the run and kept outside the run folder; the project's permission
  file denied reads of the folders that held the keys and the kit's repository, and network access was denied.
  After the run, `examples/tools/blind_audit.py` scanned every transcript (coordinator and all agents): 42 transcripts, 875 tool calls.
  No tool call touched a forbidden location, named an answer file or used the network.
- **Scored** with `python3 ../tools/score.py results answer_key.json` (run in this folder).
- **Replayed offline** with `examples/tools/replay.py` (no language model): all six results rebuilt and their verdicts confirmed in 127 s.
- `results/` is the run's record, copied with `examples/tools/sanitize.py` (local paths and user names replaced by
  placeholders; nothing else edited), with two later additions: `results/verification/report/CHECK_SUMMARY.md` and
  `VERIFICATION_GRAPH.html` were made from these records on 2026-10-30 by kit v1.5.0 (`scripts/pv_summary.py`,
  `scripts/pv_graph.py`, without a language model). Costs are those Claude Code reported for each session, at list prices (`results/sessions.json`); the
  estimates from the transcripts (`results/usage.md`) agree to within five cents. Times exclude waits for usage limits.

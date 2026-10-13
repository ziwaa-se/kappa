# Example E1: elementary bounds on the sample variance

A one-page paper with six results about the sample mean $\bar x$ and variance $s^2$, written for the kit with an
answer key fixed before the run ([ANSWER_KEY.md](ANSWER_KEY.md)). Paper: [`paper/main.tex`](paper/main.tex)
([PDF](paper/main.pdf)).

| No. | Result | Planted feature |
|---|---|---|
| 2.1 | $\sum_i (x_i - \bar x) = 0$ | — |
| 2.2 | $\sum_i (x_i - \bar x)^2 = \sum_i x_i^2 - n\bar x^2$ | an expansion left to the reader (a fair implicit step) |
| 2.3 | $s^2 \le \frac{n}{n-1}\frac{(b-a)^2}{4}$ on $[a,b]$ | rests on Popoviciu's inequality, cited |
| 2.4 | Samuelson's inequality | the proof divides by $s$ without treating $s = 0$ |
| 2.5 | $s^2 \le \frac1n \sum x_i^2$ | **false**: the proof divides by $n$ instead of $n-1$ |
| 2.6 | $\lvert x_i\rvert \le 1 \Rightarrow s^2 \le 2$ | true, but the proof uses 2.5 |

## Result

| No. | ID | Expected | Run | Score |
|---|---|---|---|---|
| 2.1 | L01 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.2 | L02 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.3 | P01 | CONDITIONAL:i | CONDITIONAL:i | agrees |
| 2.4 | P02 | ISSUE:EXPOSITION_GAP | UNCONDITIONAL | accepted |
| 2.5 | L03 | ISSUE:ERROR | ISSUE:ERROR | agrees |
| 2.6 | C01 | CONDITIONAL:iv | ISSUE:PAPER_ARGUMENT_GAP | differs |

1 accepted, 4 agrees, 1 differs

- **2.5** is refuted by a reviewed Lean counterexample, $n = 2$, $x = (1,-1)$
  ([`results/pv_work/L03_Counterexample1.lean`](results/pv_work/L03_Counterexample1.lean)).
- **2.6 differs from the key.** The key expected a verdict conditional on the false clause of 2.5. The kit recorded
  an issue of the corollary's own proof: its chain $s^2 \le \frac1n\sum x_i^2 \le 1 \le 2$ asserts $s^2 \le 1$,
  which is false under the corollary's hypotheses ($x = (1,-1)$ gives $s^2 = 2$), and no correction of 2.5 alone
  makes the chain true. On inspection we agree with the kit; the key's reason for excluding an issue was too
  generous. Keys are not changed after a run, so the score stays "differs". (A pilot run on a pre-release version gave
  the key's verdict for 2.6.)
- **Time and cost:** 82 minutes of unattended running, $14.54 at list prices. The independent fact check found
  13 problems in the first draft of the report (1 major, 3 moderate, 9 minor), which were corrected before delivery.

## How this run was made

- Kit v1.3.1 as released (commit `338b9d9`), Claude Code 2.1.296, models `claude-sonnet-5-5` (coordinator, drafter,
  prover, compiler) and `claude-opus-5-5` (gate, auditor, issue checker, fact check, second proof attempts),
  Lean 4.19.0, Mathlib `c44e0c8e`; unattended driver with `--auto-resume --report`.
- **Blind.** The answer key was written before the run and kept outside the run folder; the project's permission
  file denied reads of the folders that held the keys and the kit's repository, and network access was denied.
  After the run, `examples/tools/blind_audit.py` scanned every transcript (coordinator and all agents): 42 transcripts, 871 tool calls.
  No tool call touched a forbidden location, named an answer file or used the network.
- **Scored** with `python3 ../tools/score.py results answer_key.json` (run in this folder).
- **Replayed offline** with `examples/tools/replay.py` (no language model): all five results with Lean evidence rebuilt and their verdicts confirmed in 134 s; the issue of 2.6 rests on a reviewed Lean probe that the replay does not pick up.
- `results/` is the run's record, copied with `examples/tools/sanitize.py` (local paths and user names replaced by
  placeholders; nothing else edited). Costs are those Claude Code reported for each session, at list prices (`results/sessions.json`); the
  estimates from the transcripts (`results/usage.md`) agree to within five cents. Times exclude waits for usage limits.

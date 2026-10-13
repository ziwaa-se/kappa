# Example E4: three facts about the empirical distribution function

A paper written to test the edge of the pinned Mathlib, with an answer key fixed before the run
([ANSWER_KEY.md](ANSWER_KEY.md)). Paper: [`paper/main.tex`](paper/main.tex) ([PDF](paper/main.pdf)).

| No. | Result | Planted feature |
|---|---|---|
| 2.1 | $F_n$ is nondecreasing and $nF_n(t) \in \{0,\dots,n\}$ | — |
| 2.2 | Glivenko-Cantelli | the proof only names the theorem |
| 2.3 | Kolmogorov-Smirnov limit law | the statement needs a Brownian bridge, which Mathlib does not have |

## Result

| No. | ID | Expected | Run | Score |
|---|---|---|---|---|
| 2.1 | L01 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.2 | P01 | CONDITIONAL:v / CONDITIONAL:ii | CONDITIONAL:i | accepted |
| 2.3 | T01 | UNFINISHED:TRANSLATION_BLOCKED | CONDITIONAL:i | accepted |

2 accepted, 1 agrees

- **2.3** took the route the key allows as an alternative: the drafter defined a Brownian bridge by its properties
  (measurable, continuous paths, centred Gaussian finite-dimensional laws with covariance $\min(s,t) - st$), stated
  the theorem for every such process, and took Donsker's theorem and Kolmogorov's formula as cited inputs. The first
  proof pass stopped on the measurability of $D_n$ (`BUDGET_EXHAUSTED`); the driver's second pass, on the stronger
  model, proved it. The report asks a person to check that the encoded property is the standard Brownian bridge and
  that such a process exists, since otherwise the statement would hold vacuously.
- **2.2** is conditional on the Glivenko-Cantelli theorem, labelled as cited (i); the key accepts this.
- **Time and cost:** 81 minutes, $14.32. The fact check found 10 problems in the first draft of the report (0/2/8).

## How this run was made

- Kit v1.3.1 as released (commit `338b9d9`), Claude Code 2.1.296, models `claude-sonnet-5-5` (coordinator, drafter,
  prover, compiler) and `claude-opus-5-5` (gate, auditor, issue checker, fact check, second proof attempts),
  Lean 4.19.0, Mathlib `c44e0c8e`; unattended driver with `--auto-resume --report`.
- **Blind.** The answer key was written before the run and kept outside the run folder; the project's permission
  file denied reads of the folders that held the keys and the kit's repository, and network access was denied.
  After the run, `examples/tools/blind_audit.py` scanned every transcript (coordinator and all agents): 27 transcripts, 631 tool calls.
  No tool call touched a forbidden location, named an answer file or used the network.
- **Scored** with `python3 ../tools/score.py results answer_key.json` (run in this folder).
- **Replayed offline** with `examples/tools/replay.py` (no language model): all three results rebuilt and confirmed in 132 s.
- `results/` is the run's record, copied with `examples/tools/sanitize.py` (local paths and user names replaced by
  placeholders; nothing else edited). Costs are those Claude Code reported for each session, at list prices (`results/sessions.json`); the
  estimates from the transcripts (`results/usage.md`) agree to within five cents. Times exclude waits for usage limits.

# Example E3: the oracle risk of linear shrinkage, with a revision

A paper with four results about the risk $R(c) = c^2\sigma^2 + (1-c)^2\theta^2$ of the estimator $cX$, checked
twice: the original version, then a revised version through the revision workflow. Answer key for both rounds, fixed
before the runs: [ANSWER_KEY.md](ANSWER_KEY.md). Papers: [`paper/`](paper/main.pdf), [`paper-revised/`](paper-revised/main.pdf).

| No. | Result | Planted feature |
|---|---|---|
| 2.1 | $R(c) - \rho = (\theta^2+\sigma^2)(c - c^*)^2$ | — |
| 2.2 | $\rho \le \min\{\theta^2, \sigma^2\}$ | true, but the proof claims that a harmonic mean is at most the smaller value |
| 2.3 | $R(c) \ge \rho$, and $\rho \le \min\{R(0), R(1)\}$ | uses 2.2 for its second clause |
| 2.4 | $R(c^*) \le R(1/2)$ | cites 2.2 without needing it |

The revision rewrites the proofs of 2.1 and 2.2 (statements unchanged) and adds a sentence inside the definition of
$R$, $c^*$ and $\rho$, which moves every later line.

## Round 1

| No. | ID | Expected | Run | Score |
|---|---|---|---|---|
| 2.1 | L01 | UNCONDITIONAL | UNCONDITIONAL | agrees |
| 2.2 | L02 | ISSUE:PAPER_ARGUMENT_GAP | ISSUE:PAPER_ARGUMENT_GAP | agrees |
| 2.3 | T01 | CONDITIONAL:iv | CONDITIONAL:iv, CONDITIONAL:p | agrees |
| 2.4 | C01 | UNCONDITIONAL | UNCONDITIONAL | agrees |

4 agrees

2.2 is a `PAPER_ARGUMENT_GAP` with both false assertions refuted in Lean; 2.3 is conditional on 2.2's clause; for 2.4
the trace of hypothesis usage showed that the cited clause is not used, so it was recorded as a remark, not a
condition. 71 minutes, $9.85; the fact check found 16 problems in the first draft of the report (1/5/10).

## Round 2: the revision

All four definitions were compared by identifier and found unchanged although their lines moved; only 2.1 and 2.2
were reset; 2.3 and 2.4 kept their verdicts, marked for re-checking. Outcome (from `pv_status.py followup`):

| No. | Before | Now | Issues before | Status |
|---|---|---|---|---|
| 2.1 | Verified unconditionally | Verified unconditionally | — | — |
| 2.2 | Issue recorded | Verified unconditionally | B1 | resolved by the new final audit |
| 2.3 | Verified conditionally | Verified unconditionally | — | — |
| 2.4 | Verified unconditionally | Verified unconditionally | — | — |

The end state is the key's. The route differs in one respect: the key expected 2.3 and 2.4 only to be rebuilt,
because the statements of 2.1 and 2.2 did not change. The statement file of 2.2 had, however, lost two auxiliary
definitions used only by the old, wrong proof, and the kit compares every definition of the file, so it redid 2.3 and
2.4 in full. Safe, but more work than needed; the next version will compare only what dependents consume.
23 minutes, $7.40; the fact check of the new report found 14 problems (1/4/9). The round-1 audits and Lean files are
kept in `results/verification/audits/rev2/` and `results/pv_work/superseded/rev2/`.

## How this run was made

- Kit v1.3.1 as released (commit `338b9d9`), Claude Code 2.1.296, models `claude-sonnet-5-5` (coordinator, drafter,
  prover, compiler) and `claude-opus-5-5` (gate, auditor, issue checker, fact check, second proof attempts),
  Lean 4.19.0, Mathlib `c44e0c8e`; unattended driver with `--auto-resume --report`.
- **Blind.** The answer key was written before the run and kept outside the run folder; the project's permission
  file denied reads of the folders that held the keys and the kit's repository, and network access was denied.
  After the run, `examples/tools/blind_audit.py` scanned every transcript (coordinator and all agents): 28 transcripts and 649 tool calls for round 1, 51 and 1175 cumulatively after round 2.
  No tool call touched a forbidden location, named an answer file or used the network.
- **Scored** with `python3 ../tools/score.py results answer_key.json` (run in this folder).
- **Replayed offline** with `examples/tools/replay.py` (no language model): all four results rebuilt and confirmed after each round (154 s and 120 s).
- `results/` is the run's record, copied with `examples/tools/sanitize.py` (local paths and user names replaced by
  placeholders; nothing else edited). Costs are those Claude Code reported for each session, at list prices (`results/sessions.json`); the
  estimates from the transcripts (`results/usage.md`) agree to within five cents. Times exclude waits for usage limits.

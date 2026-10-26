# Baseline comparison: summary of the grading (2026-10-16)

Per-paper gradings: `grading/<case>.md` (graded by Claude subagents with `GRADER_PROMPT.md`; not blind to the arm).
Kit: first-round runs on v1.3.1. Agent: `claude-opus-5-5` in Claude Code with Lean, prompt P1. Chat: `claude-opus-5-5`,
no tools, prompt P0. One run per arm and paper.

| Paper (results) | Correctly classified K / A / C | False alarms K / A / C | Faithful Lean-backed K / A / C | Inputs hidden K / A / C | Verdicts without Lean evidence K / A / C | Cost USD K / A / C | Minutes K / A / C |
|---|---|---|---|---|---|---|---|
| E1 (6) | 6 / 6 / 6 | 0 / 0 / 0 | 5 / 6 / 3 | 0 / 0 / 0 | 0 / 0 / 1 | 14.54 / 0.47 / 0.46 | 82 / 2.1 / 3.2 |
| E2 (6) | 6 / 6 / 6 | 0 / 0 / 0 | 6 / 6 / 5 | 0 / 0 / 0 | 0 / 0 / 0 | 14.74 / 0.37 / 0.21 | 75 / 1.8 / 1.4 |
| E3 (4) | 4 / 4 / 4 | 0 / 0 / 0 | 3 / 1 / 1 (4 / 4 / 4 counting disclosed stronger statements) | 0 / 0 / 0 | 0 / 0 / 0 | 9.85 / 0.23 / 3.39 | 71 / 1.4 / 14.3 |
| E4 (3) | 3 / 2 / 2 (3 / 3 / 3 lenient) | 0 / 1 / 1 (0 / 0 / 0 lenient) | 1 / 1 / 1 | 0 / 0 / 0 | 0 / 1 / 2 | 14.32 / 1.78 / 0.16 | 81 / 9.8 / 1.0 |
| A (5) | 5 / 5 / 5 | 0 / 0 / 0 | 3 / 3 / 0 | 0 / 2 / 0 | 0 / 0 / 3 | 36.36 / 5.66 / 1.54 | 130 / 21.0 / 8.8 |
| B (12) | 12 / 9 / 10 | 0 / 0 / 0 | 10 / 5 / 0 | 0 / 1 / 1 | 0 / 3 / 7 | 65.24 / 4.08 / 1.49 | 171 / 19.7 / 9.4 |
| C (6) | 6 / 6 / 6 | 0 / 0 / 0 | 2 / 4 / 0 (6 / 4 / 1 counting disclosed conditions) | 0 / 0 / 0 | 0 / 0 / 2 | 36.37 / 3.24 / 1.45 | 154 / 11.6 / 4.6 |
| **Total (42)** | **42 / 38 / 39** | **0 / 1 / 1** | **30 / 26 / 10** | **0 / 3 / 1** | **0 / 4 / 15** | **191.42 / 15.83 / 8.70** | **764 / 67 / 43** |

Notes.
- Published and planted problems: every arm found all of them (E1–E3 planted; A, B, C published).
- B: the Agent missed the omissions in 4.6, 4.10 and 5.2, the Chat those in 4.6 and 4.10 (found by the kit, confirmed by
  hand). The reference for B's extra findings comes from the kit's own run (hand-checked), which favours the kit.
- A: the Agent reported Theorem 3.2 as proved in Lean but proved only the case p < q; Theorem 3.3 only for p < q and
  π₁ < 1; Proposition 3.4 in a version with bounded abstract factors, with the input asserted at l.106 assumed.
- The Agent proved more cited inputs itself than the kit, which keeps them as explicit hypotheses by design (E4
  Glivenko–Cantelli from the strong law; A Grünwald et al.; C the final steps).
- Chat: no tools, so its Lean code was never compiled by the arm; E1's code has compile errors in 2.2, 2.3, 2.6.
- E2 chat: a first attempt failed technically ($0.09, not graded) and was rerun.
- Kit times are active running times from the run records (sessions in sequence); baseline times are single sessions.

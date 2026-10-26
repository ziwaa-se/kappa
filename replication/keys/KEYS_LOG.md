# Answer keys: when they were fixed

The Markdown keys were written before their runs started; the JSON files transcribe them for examples/tools/score.py. E1–E4 JSON files and the errata JSON files were written at 21:45 on 2026-10-12, one or two minutes after the runs had started (21:43–21:44) and before any result existed. The E1 key (20:12) also predates the pilot run (20:23). Runs started: E1–E4 21:43, errata A and C 21:44 (2026-10-12).

| File | Modified | sha256 |
|---|---|---|
| `examples-design/E1/ANSWER_KEY.md` | 2026-10-12 20:12 | `2cbbdb99e763a1e0…` |
| `examples-design/E2/ANSWER_KEY.md` | 2026-10-12 20:32 | `64017f2a31f7b9f5…` |
| `examples-design/E3/ANSWER_KEY.md` | 2026-10-12 20:30 | `9d2417c785b2c1b1…` |
| `examples-design/E4/ANSWER_KEY.md` | 2026-10-12 20:38 | `517f72b58f187160…` |
| `examples-design/E1/answer_key.json` | 2026-10-12 21:45 | `c8b7b354a79fafe2…` |
| `examples-design/E2/answer_key.json` | 2026-10-12 21:45 | `b1e3eac26fa53bba…` |
| `examples-design/E3/answer_key.json` | 2026-10-12 21:45 | `5ccaa4f9bdaa6902…` |
| `examples-design/E4/answer_key.json` | 2026-10-12 21:45 | `c13525517ff57da5…` |
| `references/errata/A-henzi-ziegel/ANSWER_KEY.md` | 2026-10-12 21:43 | `0cbe43d025194697…` |
| `references/errata/C-livingstone-hmc/ANSWER_KEY.md` | 2026-10-12 21:43 | `78cb4f34a251b65d…` |
| `references/errata/A-henzi-ziegel/answer_key.json` | 2026-10-12 21:45 | `afb7328351216fe5…` |
| `references/errata/C-livingstone-hmc/answer_key.json` | 2026-10-12 21:45 | `322a1d143a9baf61…` |
| `references/errata/B-arab-lando-oliveira/ANSWER_KEY.md` | 2026-10-12 21:48 | `816bdda9a51eeea4…` |
| `references/errata/B-arab-lando-oliveira/answer_key.json` | 2026-10-12 21:48 | `21a0242df0b9291a…` |
B run started at 21:48 (keys written before)

Case A: the key was written from the correction as summarised in CANDIDATES.md and from arXiv v3; the correction PDF itself (downloaded by the user) was read on 2026-10-12 after the run had started, and it agrees with the key (Proposition 2 = v2 Proposition 3.5 false for h > 1, counterexample with h = 2). The key was not changed.

`examples-design/E3/answer_key_round2.json` was transcribed on 2026-10-13 (after the round-2 run) from the round-2
table of `E3/ANSWER_KEY.md`, which was written on 2026-10-12 before any run; it adds nothing to that table. The
errata cases had no round-2 answer keys; their round 2 is reported as observed, not scored.

Baseline comparison: `examples-design/baselines/BASELINE_PROTOCOL.md` (prompts, arms, grading rules) fixed on
2026-10-16 14:54, sha256 `ec2f48692a3becee…`, before any baseline run.
Addition to BASELINE_PROTOCOL.md (cited inputs disclosed) appended 2026-10-16 20:36, before any grading; new sha256 31ce5b1e9325da49…
E4 added to the comparison on 2026-10-16 20:37 with the authors' approval; same prompts and grading.

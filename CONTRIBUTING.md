# Contributing

Thank you for helping. Bug reports, questions and pull requests are all welcome.

## Reporting a problem

Open an issue with the "Bug report" template, and include:
- the output of `autosetup/doctor.sh <your folder>`;
- the kit version (`cat <project>/KIT_VERSION`);
- the newest relevant log from `<project>/pv_work/logs/`.

Do not attach unpublished papers or confidential material. A small LaTeX example that reproduces the problem is ideal.

## Changing the kit

The kit's guarantees come from its rules and its independent reviews, so changes should keep them intact:

- **The rules are authoritative.** `template/verification/rules/` (POLICY, VERDICTS, PIPELINE, VERIFICATION_METHODS, LESSONS) bind every agent. When you change a rule, update the rule cards in `template/.claude/agents/` that cite it, and run `python3 template/scripts/pv_cards_check.py`.
- **Do not weaken the independence.** The gate checks statements before proving, the final auditor works after proving, and issue rulings get a second review. Each runs as a separate agent; no agent may review its own work.
- **Do not change `template/pv_work/PVTools.lean` lightly.** Projects record its sha256, and `validate` rejects a changed audit tool.
- **Test.** At least: a fresh `install.sh` into a scratch folder, `scripts/pv_lean.sh build PVTools` (`exit=0`), and `python3 scripts/pv_status.py validate`. For changes to agents, skills or scripts that affect a run, run `examples/two-lemmas-demo` or `bench/`, and compare the verdicts with `bench/ANSWER_KEY.md`.
- **Document** the change in `CHANGELOG.md`, and in `docs/GUIDE_EN.md` if users see it.

---
name: pv-resume
description: Resume faithful proof checking after an interruption or a usage-limit reset — read RESUME.md, reconcile half-finished agent outputs, validate state, then continue the /pv-run coordinator loop.
disable-model-invocation: true
---

# /pv-resume — Resume after an interruption

Use this command to continue after the user's usage quota ran out, the window was closed or the session was interrupted. **Do not rely on chat memory**; the files are authoritative for everything.

1. Run `date '+%Y-%m-%d %H:%M'`. Read `CLAUDE.md`, `verification/RESUME.md` and `verification/RESULTS.json`, and run `python3 scripts/pv_status.py validate`. If it warns that `source/` changed or holds a different paper, stop and ask the user before continuing (`python3 scripts/pv_status.py source-check`).
2. **First give the user a progress table** (`python3 scripts/pv_status.py table`), and say in one sentence where things stopped last time.
3. **Check the "running" subagents.** They have very likely stopped after the interruption. For each one listed in `RESUME.md`:
   - check whether the files it should produce exist and are complete (`python3 scripts/pv_status.py outputs <ID>` shows the verdict lines of its reports and the `EXIT=` of its logs);
   - if it **finished**, fill in the records per `/pv-run` §3;
   - if it left **partial output**: if the agent can still be continued in the same session, use SendMessage to have it continue; otherwise start a new agent, and write in the task description "continue from <path of partial output>; do not start over";
   - if **files are missing or damaged**: run `python3 scripts/pv_snapshot.py list`, restore from the most recent snapshot into `restored_<name>/`, check, and then copy back.
4. Update `RESUME.md`, then **continue with the `/pv-run` procedure** (read and follow `.claude/skills/pv-run/SKILL.md`). Keep the scope from `run_scope` in `RESULTS.json`; do not widen it on your own.

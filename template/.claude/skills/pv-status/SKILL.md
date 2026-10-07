---
name: pv-status
description: Report current verification progress — the progress table for screenshots, verdict counts, open issues, running agents and what is next. Use whenever the user asks how far along the check is.
---

# /pv-status — Progress

1. Run `python3 scripts/pv_status.py validate`. If it is INVALID, first tell the user truthfully where the inconsistency is; **do not** cover it up in the report.
2. Run `python3 scripts/pv_status.py table`, and give the output to the user **verbatim**. The table can be screenshotted and shared directly. If the paper has been revised (`/pv-revise`), also run `python3 scripts/pv_status.py followup` and give its table verbatim.
3. Read from `verification/RESUME.md`:
   - the running subagents: role, target. If they may have been interrupted, say so truthfully.
   - the next step.
4. From `verification/BLOCKERS.md`, count the issues that are still open, by classification, and list the 3 most important ones.
5. Run `python3 scripts/pv_status.py next`, and list the next batch of results that can be advanced.
6. End with a one-sentence summary in the form "N numbered results: a verified unconditionally / b verified conditionally / c with recorded issues / d unfinished".

Read-only; do not modify any file.

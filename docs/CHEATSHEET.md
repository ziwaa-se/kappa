# KAPPA: one-page cheat sheet

Everything starts in the same place, the folder that contains the kit (here `~/proofcheck/kappa`). In VS Code (connected to the cluster, if you use one) or the Claude app, **File → Open Folder → `~/proofcheck`**, open the Claude panel, start a **new** chat, and send:

```
Read kappa/CLAUDE_START_HERE.md and follow it.
```

Then add, in your own words, what you want. Claude does the rest and tells you each step.

| You want to | Add to that sentence |
|---|---|
| Check a new paper | "I have a new paper; call it `<short-name>`." Then drag the paper's files (`.tex`, inputs, PDF, `.aux`) into the `source/` folder Claude names, and say "done". |
| Re-check a corrected version | "My paper `<short-name>` has a revised version." Drag the new files into its `source/` (replace the old ones; the original is backed up). |
| Continue after a pause (usage limit, closed window) | "Continue `<short-name>`." |
| Record that you checked a condition yourself | "For `<short-name>`, I checked `<condition>` against `<source>`." |
| Get the report | "Make the report for `<short-name>`." |

**Then Claude asks you to open the paper's own folder.**
1. File → Open Folder → `~/proofcheck/papers/<short-name>-check`.
2. Open the Claude panel and start a **new** chat; choose **Sonnet** (or type `/model`). If asked whether to trust the folder: yes.
3. Open `START_PROMPT.txt` (or `NEXT_PROMPT.txt`), copy all, paste, send.

The check runs in this chat and needs no attention. Only a question about the paper's notation would stop it.

**While it runs, in that chat:**
- `/pv-status` shows the progress table.
- `/pv-resume` continues after a usage-limit pause or a disconnect; nothing is lost. (A check started in the background with Claude's help continues by itself after the limit resets; keep the computer on and the lid open.)
- `/clear` then `/pv-resume` every few results keeps the cost down.

**The results** are in `~/proofcheck/papers/<short-name>-check/verification/report/`. Read `AUTHOR_REPORT.md` first; it has a summary table at the top. Open `VERIFICATION_GRAPH.html` in a browser to see every result and its dependencies; `CHECK_SUMMARY.md` is one page you can pass on.

| Verdict | Meaning |
|---|---|
| Verified unconditionally | The paper's proof compiles in Lean with no unproved input |
| Verified conditionally | It compiles, but relies on cited or unproved results, listed explicitly |
| Recorded issue | A confirmed problem, with its exact place in the paper and whose fault it is |
| Unfinished | Stopped with a reason; never counted as an error in the paper |

**What only you can check:** that the cited results are true; that the basic definitions match the paper; that each Lean statement says what the paper says (`FILES_TO_CHECK.md` shows where).

**Never:**
- make or copy folders under `papers/` by hand;
- put a second paper into an existing paper's folder;
- allow downloads other than the Lean setup Claude asked about.

Full guide: `~/proofcheck/kappa/docs/GUIDE_EN.md`.

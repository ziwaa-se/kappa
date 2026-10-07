# Instructions for Claude: guided setup of the TeX proof-check kit

You are helping a mathematician check the proofs in a LaTeX paper with the TeX proof-check kit (v1.3: the folder that contains this file). They may not be used to managing folders, so **you** keep the files in order: one paper, one project folder, never mixed. Speak the language they write in. Be brief, ask one question at a time, and say what you are about to do before you do it.

**Hard rules for this session**
- Download or install nothing without asking first, in this chat; this covers the elan installer and the Lean/Mathlib download. Say how big it is.
- Never put a second paper into an existing project, never reuse a project folder for another paper, never delete anything, and never overwrite a file in a project's `source/` without asking.
- Never change the kit's files, the user's global settings, or files outside the base folder (except elan's own install in the home directory, if they agree).
- Do not run the checking itself in this session: the kit's reviewers are defined inside each project folder and are loaded only by a Claude session opened **in** that folder. Step E explains how to start it.

**Words used below**
- **kit**: the folder that contains this file: a clone of the repository, or the unpacked ZIP from GitHub, e.g. `<base>/tex-proof-check-kit/`.
- **base**: the folder open in this chat, normally the parent of the kit, e.g. `~/proofcheck`. The shared Lean environment (`<base>/lean-env/`) and the paper projects (`<base>/papers/`) go there. On a cluster it needs about 10 GB. **If the chat was opened inside the kit folder itself, use its parent as the base**, and say so: projects must never be created inside the kit.

Run every script from the kit: `<kit>/autosetup/<script>`.

---

## A. Find the kit, then look around

1. If the user pointed you to a ZIP (for example `tex-proof-check-kit-main.zip` from GitHub) rather than a folder, unpack it into `<base>` without overwriting: `unzip -n <zip> -d <base>`, or `python3 -m zipfile -e <zip> <base>` if `unzip` is missing. The kit is the unpacked top folder. If an older kit folder also exists, use the newer one (compare `template/KIT_VERSION`); existing projects are upgraded in step D.4.
2. Run `<kit>/autosetup/doctor.sh <base>`, `python3 <kit>/autosetup/projects.py <base>` and, if `<base>/lean-env` exists, `<kit>/autosetup/lean_env.sh <base> --check`. If that prints `INCOMPLETE`, your summary must say so, with its consequence: proof steps needing a missing Mathlib part will stop as `TRANSLATION_BLOCKED`. See step B. Summarize for the user in a few lines: what is ready, what is missing, and which paper projects exist.

## B. Fix what is missing (only once per machine)

- **python3 older than 3.6:** suggest `module load python` (or whatever the cluster offers) and run doctor again.
- **git, curl or unzip missing:** ask the user to install them or load a module.
- **elan missing.** Ask: "May I install Lean's installer, elan, into your home folder? It downloads about 200 MB from elan.lean-lang.org." If yes:

  ```bash
  curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y
  ```

  Then add `~/.elan/bin` to PATH for this session (`export PATH="$HOME/.elan/bin:$PATH"`), and tell the user that new terminals will have it.
- **No shared Lean environment** (`<kit>/autosetup/lean_env.sh <base> --check` fails). Explain that Lean 4.19.0 and Mathlib are needed once for all papers: a few GB, typically 5–20 minutes. Then offer two ways:
  - (a) If the user names an existing Lean project with the same versions: `lean_env.sh <base> --from <that project>`, which needs no download.
  - (b) Otherwise, after a clear yes: `lean_env.sh <base> --download`.

  If `lean_env.sh` reports `INCOMPLETE`, tell the user plainly: proof steps that need a missing Mathlib part will stop as `TRANSLATION_BLOCKED`, because paper projects never compile Mathlib themselves. Offer to complete it with `lake exe cache get` in `<base>/lean-env`, which is a download, so ask first.

  On a cluster, downloads usually work only on a login node. If the login node limits long jobs, say so, and suggest running the download in a terminal under `tmux`.

## C. Ask what they want to do

Unless their first message already says it, ask:

1. **check a new paper** → step D;
2. **continue a check that stopped** (usage limit, closed window) → step F with `resume`;
3. **the paper was corrected; re-check it** → step F with `revise`; first help them put the new version into that project's `source/` (show the files, ask before replacing);
4. **they checked one of the conditions themselves** → step F, and tell them to state in the project chat which condition, against what source, and who checked it (GUIDE section 8.4);
5. **make or refresh the report** → step F with `report`.

If they are unsure which project, show the list from `projects.py`: the paper title, the status and the last update.

## D. A new paper

1. **Name.** Ask for a short name: lowercase letters, digits and `-`, for example `ladder-gate`. Run `<kit>/autosetup/new_project.sh <base> <name>`.
   - If it prints `EXISTS`, that folder already belongs to another check. Read them its paper title. If it is the same paper, go to C2 or C3; otherwise ask for another name. **Never reuse it.**
   - It prints `CREATED: <project>`.
2. **The paper's files.** Ask where the paper is on this machine (a folder path), or tell them they can drag the files into `<project>/source/` in the VS Code explorer and then tell you.
   - If they give a path: list what you would copy, which is everything needed to compile (`.tex`, `.bib`/`.bbl`, `.sty`/`.cls`, the figures it includes, the **PDF** and the **`.aux`**), keeping sub-folders. Leave out old drafts and backups. Copy only after they agree.
   - Then run `python3 <kit>/autosetup/check_paper.py <project>`. Tell them its result in one line: `READY` with the title, or what is missing. Fix the gaps with them until it says `READY`.
   - A missing PDF or `.aux` is not fatal, but they give exact theorem numbers. If `pdflatex` exists, offer to compile a copy in `<project>/pv_work/latex_build/` and copy back only the `.pdf` and `.aux`.
   - If there are several main files, ask which one is the paper; the others go out of `source/`.
3. **Unattended permissions.** Explain in two lines that `.claude/settings.example.json` lets the kit run its own scripts without asking each time, and forbids internet access and edits to the paper. Ask whether to enable it; if yes: `cp <project>/.claude/settings.example.json <project>/.claude/settings.json`.
4. **Older projects, if this kit is newer than some project** (compare `<kit>/template/KIT_VERSION` with the kit version shown by `projects.py`). Offer, and run only with a yes and only while no Claude session works in that project: `<kit>/install.sh <project> --upgrade`.
5. **The start prompt.** Run `python3 <kit>/autosetup/write_prompt.py <project> start`. It writes `<project>/START_PROMPT.txt`, the guide's tested prompt with this paper's file names, and prints it.

## E. Start the check (choose with the user)

- **In VS Code (recommended).** Tell them exactly:
  1. File → Open Folder… → `<project>` (on the cluster).
  2. Open the Claude Code panel and start a **new** chat there.
  3. Choose **Sonnet** (the model picker, or type `/model`). The reviewing roles use Opus by themselves.
  4. If Claude asks whether to trust the folder, answer yes.
  5. Paste the text of `START_PROMPT.txt` and send.
  6. During the run they can type `/pv-status` for the progress table. After a usage-limit pause, they type `/pv-resume`.
- **Unattended in the background.** Only if doctor found the `claude` command and step D.3 enabled the permissions. Run `<kit>/autosetup/start_unattended.sh <project>`. It keeps running after VS Code closes (`tmux` or `nohup`). Tell them how to look at progress: run `python3 scripts/pv_status.py table` in the project, or ask any Claude chat to run it. On a cluster, mention that long processes on a login node may be against the rules; if so, run it inside an interactive job.

## F. An existing project

Run `python3 <kit>/autosetup/write_prompt.py <project> <resume|revise|report>`. It writes `<project>/NEXT_PROMPT.txt` and prints it. Then give the VS Code steps of E (open that folder, new chat, Sonnet, paste the prompt).

- For `resume`, typing `/pv-resume` in the new chat is enough.
- For a human check (C4), they write the message themselves, from GUIDE section 8.4.

## G. Finish

Tell them in three lines:
- where the project is;
- what to paste or type next;
- that `<kit>/docs/GUIDE_EN.md` explains the whole workflow, and that the reports end up in `<project>/verification/report/`.

**The demo paper.** If the user wants to try the kit first, the two-lemma demo is in `<kit>/examples/two-lemmas-demo/paper/` (one lemma is correct, one has a planted error). Treat it like a new paper named `demo`, copying from that folder. `<kit>/examples/two-lemmas-demo/README.md` shows the expected result, and `DEMO_PROMPT_no_report.txt` there is a shorter start prompt that skips the report. A longer example, which also shows a revision and a human check, is in `<kit>/examples/full-workflow/` (its paper is in `paper/`, the corrected version in `paper-revised/`).

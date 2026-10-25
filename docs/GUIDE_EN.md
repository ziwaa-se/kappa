# KAPPA v1.4.0: the complete workflow

This guide takes you from a new computer to a finished report. It also covers what to do when the paper changes or when you check a condition yourself. The prompts in 8.1, 8.3, 8.4 and 8.5 were sent verbatim, in this order, in an end-to-end test on the test paper `bench/paper`; the record is `bench/results/WORKFLOW_TEST.md`. Slash commands such as `/pv-status` are Claude Code's standard way to start the same steps.

---

## 1. What the kit does, in one minute

You give it a LaTeX paper whose proofs are already written. For every numbered result (theorem, proposition, lemma, corollary), it translates the paper's own proof into Lean 4, has the Lean kernel check it, and gives one of four verdicts:

| Verdict | Meaning |
|---|---|
| **Verified unconditionally** | The paper's proof compiles in Lean with no unproved input |
| **Verified conditionally** | It compiles, but relies on results the paper cites or does not prove. These are named, explicit Lean hypotheses, never hidden |
| **Issue recorded** | A confirmed problem in the paper, classified by whose fault it is: `ERROR` (the statement is false), `PAPER_ARGUMENT_GAP` (the given reason does not work), `PAPER_ASSUMPTION_GAP` (a needed hypothesis is missing), `EXPOSITION_GAP`, `DOMAIN_CLARIFICATION` |
| **Unfinished** | Stopped, with the reason recorded. **Never counted as an error in the paper** |

It never repairs a proof, never searches for a different proof, and never edits the paper: this version only **verifies proofs that are already written**. A mode that also proposes and verifies corrections after an issue is found is planned (see the README's Roadmap). Every statement is checked by an independent reviewer before it is proved, and every proof by an independent auditor afterwards.

### Two ways to set up

- **Guided (easiest; recommended on a cluster).** Make a folder for your paper checks, for example `~/proofcheck`, and put the kit inside it, either with `git clone https://github.com/ziwaa-se/kappa.git` or by downloading the ZIP from GitHub and unzipping it there. Open `~/proofcheck` in VS Code or the Claude app, start a new Claude chat, and send:

  ```
  Read kappa/CLAUDE_START_HERE.md and follow it.
  ```

  (If you downloaded a ZIP from GitHub, the unzipped folder is called `kappa-main`, or `kappa-1.4.0` for a release. Rename it to `kappa`, or use its actual name in the sentence.)

  Claude checks the machine and sets up Lean once (it asks before downloading anything). It then makes a **new folder for each paper** (`papers/<name>-check`), helps you put the paper's files in, checks that nothing is missing, and tells you how to start. Send the same sentence again whenever you want to check another paper, continue, re-check a corrected version, or make a report. It finds your existing projects and never mixes two papers in one folder.
- **By hand:** sections 2–4 below.

**One paper, one project.** Never drop a different paper into a project that was already used: the records and audits of the two papers would mix. `python3 scripts/pv_status.py source-check` tells whether `source/` still holds the paper the project was set up for. `/pv-setup` and `/pv-resume` stop when it does not.

---

## 2. One-time setup on a computer

Needed: macOS or Linux; internet access for the first download; a Claude plan that includes Claude Code; about 10 GB of disk space.

1. **Install git** (on macOS, `git --version` offers to install it) and **elan**, Lean's installer. Then open a new terminal window.

   ```bash
   curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
   ```

2. **Install Claude Code**: the Claude desktop app, whose **Code** tab is Claude Code. The terminal command `claude` is needed only for the unattended driver in section 4B; install it following the official Claude Code documentation.
3. **Get the kit** into a folder for your checks:

   ```bash
   mkdir -p ~/proofcheck && cd ~/proofcheck && git clone https://github.com/ziwaa-se/kappa.git
   ```

   (Or download the ZIP from GitHub and unzip it into `~/proofcheck`, then rename the folder to `kappa`.)

---

## 3. Create a project for a paper (one paper, one project)

```bash
~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check --pinned
```

```bash
cd ~/proofcheck/papers/mypaper-check && lake exe cache get
```

```bash
scripts/pv_lean.sh build PVTools
```

- The second command downloads Lean 4.19.0 and Mathlib once: a few GB, 5–20 minutes. On macOS 26 or later it can fail with a `dyld` message about `SG_READ_ONLY`; the guided setup's `autosetup/lean_env.sh <base> --download` works around this (it relinks Mathlib's cache tool with the system compiler).
- The third must end with `exit=0`.
- If this computer already has a project with the same Lean version, use `--lean-from <that project>` instead of `--pinned`, which skips the download.

**Add the paper.** Copy into `~/proofcheck/papers/mypaper-check/source/`: the main `.tex`, every file it `\input`s, the macro files, and the compiled **PDF and `.aux`**. The `.aux` gives exact theorem numbers.

**Allow unattended running** (recommended). Read `.claude/settings.example.json` first: it allows only the kit's own commands, it forbids network access and edits to the paper, and its hook (`scripts/pv_guard.py`) refuses writes outside the project, proof edits by the coordinator and edits by reviewers of what they review (MANUAL, section 2, step 4).

```bash
cd ~/proofcheck/papers/mypaper-check && cp .claude/settings.example.json .claude/settings.json
```

---

## 4. Run the check

### 4A. In the Claude desktop app (recommended)

1. Open the folder `mypaper-check` in the Code tab. If asked whether to **trust** the folder, say yes; otherwise the permission file is ignored.
2. Choose **Sonnet** in the model picker. The main session only dispatches, checks and records; the reviewing roles run on Opus by their own definitions.
3. Send the **start prompt** (section 8.1), with your file names.

The run is unattended: it records problems and keeps going. It reports briefly after each step and shows an English progress table after each verdict.

### 4B. From a terminal, fully unattended

```bash
cd ~/proofcheck/papers/mypaper-check && scripts/pv_drive.sh --setup source/main.tex --auto-resume --report
```

It runs the setup, then every result in short fresh sessions of at most 3 results each, which keeps the cost down, and finally the report. The results are the same as with 4A.
- `--auto-resume`: when the usage limit is reached, it sleeps until the reset time and continues by itself. Keep the computer on and the lid open (on macOS it prevents idle sleep while it runs).
- The last line of its output says why it stopped, and `python3 scripts/pv_drive_status.py show` prints the same (MANUAL, section 3, lists the exit statuses).
- `autosetup/start_unattended.sh ~/proofcheck/papers/mypaper-check` starts it in the background, so that you can close the terminal.

### 4C. In VS Code connected to a cluster

The Claude Code extension for VS Code works the same way as the app; only the setup around it differs.

1. **Connect** with Remote-SSH, and make sure the Claude Code extension is installed **on the remote side** (VS Code installs extensions per host). Sign in in the Claude panel. The cluster must be able to reach Anthropic's servers.
2. **Do sections 2–3 in VS Code's terminal on the cluster** (Terminal → New Terminal). No administrator rights are needed: elan installs into `~/.elan`. If `python3` is older than 3.6, try `module load python`.
3. **Space.** Lean and Mathlib take 5–8 GB. Home folders on clusters often have small quotas, so put the projects under a work or project directory. The guided setup shares one Lean installation between all papers.
4. **Where things run.** The downloads (elan, `lake exe cache get`) need internet access, which usually only login nodes have. The checks start Lean processes of 1–3 GB each, at most 3 at a time. If your cluster forbids that on login nodes, connect VS Code to an interactive compute allocation instead; ask your administrators.
5. **Open the project folder itself** (File → Open Folder… → `mypaper-check`), then open the Claude panel and start a **new** chat. The kit's reviewers are defined in that folder; a chat opened in a parent folder does not see them.
6. Choose **Sonnet** in the panel's model picker (or type `/model`). If Claude asks whether to trust the folder, answer yes. Then send the start prompt (8.1). The slash commands (`/pv-status`, `/pv-resume`, `/clear`) work in the panel.
7. **Connection drops.** If VS Code disconnects, the chat stops, but nothing is lost: reconnect, open the project folder, start a new chat, and type `/pv-resume`. For long unattended runs that should survive disconnects, start the driver (4B) inside `tmux` on the cluster. That needs the terminal `claude` command there, which the VS Code extension alone may not provide; install it following the official Claude Code documentation.

The kit's scripts are written for macOS and Linux, but they have so far been run only on macOS. On the first cluster setup, check that `scripts/pv_lean.sh build PVTools` ends with `exit=0`, and report anything that fails.

### While it runs

| You want to | Do |
|---|---|
| See progress | `/pv-status` |
| Continue after the usage limit, a closed window or a restart | `/pv-resume` (nothing is lost; all state is in files) |
| Keep a long run cheap | Every few verdicts: `/clear`, then `/pv-resume` |
| See where the tokens went | `python3 scripts/pv_usage.py` (in a terminal) |

When the usage limit runs out, an interactive run (4A, 4C) stops, and it does not restart by itself when the limit resets; type `/pv-resume`. The driver with `--auto-resume` (4B) continues by itself.

---

## 5. What you get

After every result has a verdict, send the **report prompt** (8.5). You then get, in `verification/report/`:

| Read in this order | File | What it is |
|---|---|---|
| 1 | `AUTHOR_REPORT.md` | Summary table at the top, then each result's verdict, all external inputs, the issues for the authors with their exact location, typos, and the human-check list |
| 2 | `FILES_TO_CHECK.md` | For each result: paper location ↔ Lean theorem (file:line) ↔ audit report |
| 3 | `EXTERNAL_TOOLS_WORKSHEET.md` | Each cited or unproved input, with its exact Lean text, sorted by risk, with check boxes |

The report is checked by an independent fact-checker before you see it.

**What a person still has to do:**
1. Check that the external inputs are true, for example cited theorems against their sources.
2. Check that the basic definitions match the paper.
3. Check that each Lean statement says what the paper says; `FILES_TO_CHECK.md` shows where.

The Lean proofs themselves need no reading: the Lean kernel checked them, and an independent audit rebuilt them.

---

## 6. After the run: the two follow-ups

### 6.1 You corrected the paper → re-check only what changed

1. Replace the files in `source/` with the corrected version, including the new PDF and `.aux`. The original is safe: setup keeps a copy in `verification/source_baseline/`.
2. Send the **revision prompt** (8.3), with your main file's name in place of `source/main.tex`.

**With the guided-setup package**, you can let Claude do the bookkeeping. In the root folder, start a new chat and send the usual sentence, adding "my paper <name> has a revised version". Claude finds the project, tells you which `source/` to drag the new files into, checks them, and writes `NEXT_PROMPT.txt` with your file names already filled in. Then open the project folder, start a new chat and paste it.

What happens:
- The kit compares the new source with the copy saved at setup, and resets only the results whose statement, proof or definitions changed, plus the results that depend on them. The others keep their verdicts.
- The reset results are drafted, gated, proved and audited again. An earlier issue is marked resolved **only** when the new audit verifies the result; the old audit never counts.
- `python3 scripts/pv_status.py followup` shows, for each re-checked result, its verdict before and after, and the status of each earlier issue. The next report has a section "What the revision changed".
- The previous manuscript is kept as `verification/source_baseline_v1/` (then `_v2`, …), so every version stays comparable.

In the test, correcting the planted error in Lemma 2.3 reset only that lemma. The re-check took one session and cost $5, and turned "Issue recorded" into "Verified unconditionally".

### 6.2 You checked a condition yourself → record it

Send the **human-check prompt** (8.4), saying which condition, who checked it, and against what.
- The result **stays "verified conditionally"**: the Lean proof still assumes the condition, and a person's check is different evidence from the Lean kernel's.
- The progress table and the report now say "conditions checked by a person", with who, when and how.
- Only a Lean proof of the condition itself can make the result "verified unconditionally".

---

## 7. Prompts: what a good one contains

Every prompt to the kit should:
- **name the files**: the main `.tex`, and the PDF or `.aux` for numbering;
- **say which skill to follow** (`.claude/skills/<name>/SKILL.md`) or type the slash command, so that the defined procedure runs rather than an improvised one;
- **give the scope** when you want only some results (IDs such as `L01 P02`, from the progress table);
- **say whether you will be away** ("do not wait for me; record problems and continue");
- **restate the two hard rules**: faithful translation only (no repairs, no new proofs); no internet, no downloads.

It should **not** ask Claude to fix the paper's proofs, try another proof, allow downloads, or "make everything pass". Those break the guarantees the verdicts rely on.

---

## 8. Prompt templates (copy, then replace the file names)

### 8.1 Start: set up and check every result

```
Please check the proofs already written in this paper with this project's KAPPA kit.
First read CLAUDE.md.
The main file is source/main.tex; the compiled PDF is source/main.pdf and source/main.aux (use them for theorem numbers).

1. Initialise by following .claude/skills/pv-setup/SKILL.md with source/main.tex. Report the number
   of numbered results, the cited results the proofs rely on, and any global notation question that
   only I can decide.
2. If there is no such question, do not wait for me: follow .claude/skills/pv-run/SKILL.md until every
   result has a verdict or a recorded reason. Translate the paper's proofs faithfully; do not repair
   them or find new proofs. No internet, no downloads. Record problems and continue. Report briefly
   after each stage, with the progress table after each verdict. Keep verification/RESUME.md current.
3. When every result has a verdict, follow .claude/skills/pv-report/SKILL.md, including the
   independent fact-check.
```

To check only some results, add to step 2: "Scope: L01 P02 (their unfinished predecessors are included automatically)."

### 8.2 Continue after an interruption

```
/pv-resume
```

### 8.3 The paper was corrected

```
I have replaced the files in source/ with a corrected version of the paper (main file source/main.tex,
new PDF and .aux included). Follow .claude/skills/pv-revise/SKILL.md: find what changed, reset only the
affected results, and keep the other verdicts. Then follow .claude/skills/pv-run/SKILL.md for the reset
results until each has a verdict. Mark an earlier issue resolved only if the new final audit verifies the
result. Faithful translation only; no internet, no downloads. Finally show the table of
python3 scripts/pv_status.py followup.
```

What gets redone (v1.3.1): the results whose statement, proof or used definitions changed. The results that use them keep their verdicts until a changed result has passed its gate again; if its statement turned out the same, they are only rebuilt and re-checked mechanically, otherwise they are redone too. The MANUAL, section 4, has the details.

### 8.4 You checked a condition

```
I checked the external input <ID from the tools table, e.g. P01_Nesbitt> myself: <what you compared it
with, e.g. "Nesbitt (1903), and the proof in Hardy–Littlewood–Pólya, Inequalities, §2.4">.
Checked by: <name>. Record this with python3 scripts/pv_status.py human-check, then show the progress
table. Do not change any verdict.
```

The IDs are listed by `python3 scripts/pv_status.py tools`.

### 8.5 Report

```
Read .claude/skills/pv-report/SKILL.md and carry out its steps yourself, including the independent
fact-check. No internet, no downloads.
```

### 8.6 Status, in any language

```
/pv-status
```


---

## 9. Updating the kit to a new version

Get the new version: `cd ~/proofcheck/kappa && git pull` (or download the new ZIP).

- **New paper:** nothing else to do; new projects get the new version.
- **A paper already in progress:** close Claude Code in that project, run the command below, then continue with `/pv-resume`.

  ```bash
  ~/proofcheck/kappa/install.sh ~/proofcheck/papers/mypaper-check --upgrade
  ```

  It replaces only the kit's own files and keeps backups in `kit_backup/<date>/`. It never touches the paper, the records, the Lean files, the audit tool or your permission settings, and it never changes Lean or Mathlib. It lists any new permission entries for you to add, notes the upgrade in `verification/AUDIT.md` and runs `validate`. `cat KIT_VERSION` shows a project's version.

Do **not** install a new version over an existing project without `--upgrade`: existing files are skipped, so the project would silently stay on the old version.

---

## 10. Cost, and how to keep it down

On the 3-result test paper, v1.3 cost about a quarter of v1.2.1, with the same verdicts (two runs per version; `bench/results/COMPARISON.md`). The complete workflow test cost, at list prices:

| Step | Cost |
|---|---:|
| 8.1: setup, 3 verdicts and the report | $21 |
| 8.3: revision | $5 |
| 8.4: human check | $0.15 |
| 8.5: report again | $7 |

A research paper costs far more than the test paper. To keep it down:
- run the main session on **Sonnet** (section 4A);
- use `/clear` + `/pv-resume` every few verdicts, or the driver (4B);
- check the numbers with `python3 scripts/pv_usage.py`.

---

## 11. Troubleshooting

| Symptom | Fix |
|---|---|
| Every step asks for approval | `.claude/settings.json` is missing, or the folder was not trusted when opened |
| `install.sh: permission denied` | Run it as `bash ~/proofcheck/kappa/install.sh …` |
| `lake: command not found` | Open a new terminal, or run `source ~/.elan/env` |
| `lake exe cache get` fails | Retry (usually the network). On macOS 26 or later with a `dyld … SG_READ_ONLY` message: `autosetup/lean_env.sh <base> --download`. As a last resort, `lake build` (slow, hours) |
| A step is `TRANSLATION_BLOCKED` with a missing Mathlib module | The project links another project's Mathlib; install with `--pinned`, or with `--lean-from` without `--link-packages` |
| The run stopped after the usage limit | `/pv-resume` after the limit resets; the driver with `--auto-resume` continues by itself |
| The driver stopped with exit status 7 (`permissions`) | Kit commands were refused: open the folder once in Claude Code, accept the trust dialog, run the driver again |
| A write was refused with `pv_guard: …` | The guard hook (MANUAL, section 2, step 4). Working by hand: `PV_GUARD=warn` |
| You are unsure what a verdict or code means | `verification/rules/VERDICTS.md`, or ask Claude in the project |
| `validate` warns that `source/` changed or holds a different paper | New version of the same paper: `/pv-revise` (8.3). A different paper: put the original files back and make a new project |
| In VS Code the kit's commands (`/pv-status` …) are unknown | The chat was not opened in the project folder: File → Open Folder… → the project, then a new chat |
| On a cluster: `python3` too old, or no space | `module load python`; put the projects in a directory with enough quota |

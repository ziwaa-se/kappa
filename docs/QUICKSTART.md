# TeX Proof-Check Kit v1.3.4: quick start

The kit checks the proofs **already written** in a LaTeX paper. It translates them into Lean 4, compiles them, and gives each numbered result one of four verdicts. It never repairs a proof, never searches for a new one, and never edits the paper. (A repair mode is planned; see the README's Roadmap.)

Setup takes about 30 minutes. After that the run is unattended.

## 1. Install once

1. Install Lean's installer (elan) in a terminal, then open a new terminal window:

   ```bash
   curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
   ```

2. Install **Claude Code**: either the Claude desktop app, which has a Code tab, or the `claude` terminal command. Your plan must include Claude Code.
3. Get the kit:

   ```bash
   mkdir -p ~/proofcheck && cd ~/proofcheck && git clone https://github.com/ziwaa-se/tex-proof-check-kit.git
   ```

   Or download the ZIP from GitHub, unzip it into `~/proofcheck`, and rename the folder to `tex-proof-check-kit`.

> **Easier:** in `~/proofcheck`, start a new Claude chat and send "Read tex-proof-check-kit/CLAUDE_START_HERE.md and follow it." Claude then does steps 2–4 with you (see `GUIDE_EN.md`, section 1).

## 2. Create a project for your paper

```bash
~/proofcheck/tex-proof-check-kit/install.sh ~/proofcheck/papers/mypaper-check --pinned
```

```bash
cd ~/proofcheck/papers/mypaper-check && lake exe cache get
```

```bash
scripts/pv_lean.sh build PVTools
```

- The second command downloads Lean 4.19.0 and Mathlib once, a few GB.
- The last command checks the environment. It must end with `exit=0`.

## 3. Add the paper

Copy the main `.tex` file, every file it `\input`s, the macro and style files, and the compiled PDF into `~/proofcheck/papers/mypaper-check/source/`. Keep the paper's relative paths.

## 4. Allow unattended running (recommended)

Read `.claude/settings.example.json`. It allows only the kit's own scripts, and it blocks network access and edits to `source/`. If you agree with it, enable it:

```bash
cp .claude/settings.example.json .claude/settings.json
```

## 5. Start

Open the folder `mypaper-check` in Claude Code, **choose Sonnet in the model picker** (the main session only dispatches, checks and records; the reviewing roles run on Opus by their own definitions), and send the prompt below. Replace the two file names first.

```
Please check the proofs already written in this paper with this project's tex-proof-check-kit.
First read CLAUDE.md; each skill below says which rules to read.
The main file is source/MAIN.tex; the compiled PDF is source/PAPER.pdf (use it for theorem numbers).

1. Initialise by following .claude/skills/pv-setup/SKILL.md with source/MAIN.tex. Report the number
   of numbered results, the cited results the proofs rely on, and any global notation question that
   only I can decide.
2. If there is no such question, do not wait for me: follow .claude/skills/pv-run/SKILL.md until every
   result has a verdict or a recorded reason. Translate the paper's proofs faithfully; do not repair
   them or find new proofs. No internet, no downloads. Record problems and continue. Report briefly
   after each stage, with the progress table after each verdict. Keep verification/RESUME.md current.
3. When every result has a verdict, follow .claude/skills/pv-report/SKILL.md, including the
   independent fact-check.
```

**While it runs:**

| To | Type |
|---|---|
| See progress | `/pv-status` |
| Continue after a usage limit or a closed window | `/pv-resume` |
| Handle a new version of the paper (only affected results are redone) | Put it in `source/`, then `/pv-revise` |
| Keep the session cheap: every few verdicts, start a fresh context (nothing is lost) | `/clear`, then `/pv-resume` |
| See where the tokens went | `python3 scripts/pv_usage.py` (in a terminal) |

**Alternative: fully unattended from a terminal (v1.3.1: it also waits out usage limits and makes the report).** After steps 1–4, this does setup and every result in fresh short sessions:

```bash
cd ~/proofcheck/papers/mypaper-check && scripts/pv_drive.sh --setup source/MAIN.tex --auto-resume --report
```

## 6. Read the results

**The verdicts:**

| Verdict | Meaning |
|---|---|
| Verified unconditionally | The paper's proof compiles with no unproved input. |
| Verified conditionally | It compiles, but relies on cited results that are named explicitly. |
| Recorded issue | A confirmed problem, classified as a false claim, argument gap, missing assumption, exposition gap or ambiguity. |
| Unfinished | Stopped with a stated reason. This is never counted as a paper error. |

**The files,** in `verification/report/`, read in this order:

1. `AUTHOR_REPORT.md`: what was found, and suggested fixes.
2. `FILES_TO_CHECK.md`: where each result lives in the paper and in Lean.
3. `EXTERNAL_TOOLS_WORKSHEET.md`: the cited results, each with its exact Lean statement.

**What still needs a person:**
- the cited results are true;
- the basic definitions match the paper;
- each Lean statement says what the paper says.

The Lean proofs themselves need no reading. The Lean kernel checked them, and an independent audit rebuilt them.

## After correcting the paper, or checking a condition yourself

- **Corrected paper:** replace the files in `source/` (with the new PDF and `.aux`), then type `/pv-revise`. Only the changed results, and those depending on them, are re-checked; `python3 scripts/pv_status.py followup` shows before and after.
- **You checked a condition** (for example a cited theorem, against the book): tell Claude which one, against what, and who checked it; it records this. The result stays "verified conditionally", now marked "conditions checked by a person".

## When a new version of the kit arrives

- **New paper:** after `git pull` in `~/proofcheck/tex-proof-check-kit` (or a new download), repeat step 2.
- **Paper already in progress:** close Claude Code in that project, run the line below, then continue with `/pv-resume`. It replaces only the kit's own files (the old ones go to `kit_backup/`), never the paper, the records or the Lean files.

```bash
~/proofcheck/tex-proof-check-kit/install.sh ~/proofcheck/papers/mypaper-check --upgrade
```

## Try Lean in two minutes

After step 2, run this inside `mypaper-check`:

```bash
lake env lean ~/proofcheck/tex-proof-check-kit/docs/lean-demo/LeanDemo.lean
```

It prints the axioms each small theorem depends on. `LeanDemoError.lean` shows what Lean prints for a false claim and for an unfinished `sorry`.

Full manual: `README.md`. Diagrams: `docs/diagrams/`.

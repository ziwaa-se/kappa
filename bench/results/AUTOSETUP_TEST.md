# Guided-setup test (2026-09-30, macOS)

This test used the first packaging of the guided setup: a zip with the kit in `kit/`, started with "Read tex-proof-check-kit-v1.3-autosetup.zip … and follow CLAUDE_START_HERE.md inside it." The repository now ships the same scripts and instructions at its top level; the conversation flow is unchanged.

**Conversation test.** A real multi-turn chat (Claude Opus, headless, every command approved as a user would) was started in a folder containing only the zip. Paper fixtures:
- a 3-result paper whose main file `\input`s a section file, sitting next to an old draft that also has `\documentclass`;
- later, a second paper with a different title.

| Turn | The user said | What Claude did | Cost |
|---|---|---|---:|
| 1 | "Read tex-proof-check-kit-v1.3-autosetup.zip in this folder and follow CLAUDE_START_HERE.md inside it." | Unpacked, ran doctor and projects, reported what was ready, asked how to get Lean (download, or reuse an existing project) | $0.48 |
| 2 | Reuse an existing Lean project; check a new paper | Built the shared `lean-env` by copying, with no download, and asked for a short name | $0.76 |
| 3 | Name and folder of the paper | Created `papers/elementary-note-check`. Listed the 4 files to copy, kept the sub-folder, and **left out the old draft** after reading its title. Asked before copying | $0.94 |
| 4 | "Yes, copy them" | Copied; `check_paper.py`: READY. Explained the permissions file and asked | $1.16 |
| 5 | "Yes; I will use VS Code" | Enabled permissions, wrote `START_PROMPT.txt`, gave the VS Code steps (open the folder, new chat, Sonnet, trust, paste) | $1.70 |
| 6 | New chat, same sentence, plus: "a new paper, call it elementary-note" | **Refused to reuse the folder**, recognised the other paper by its title, and asked: new name, or a revision of the same paper? | $0.51 |
| 7 | "A new paper, call it sharp-constants" | Created a second project and left the first untouched. READY, but no PDF/`.aux`; offered to compile them | $0.72 |
| 8 | "Yes, compile it" | Compiled in `pv_work/latex_build/` and copied back only `.pdf` and `.aux`: exact theorem numbers | $0.96 |
| | | **Total** | **$7.23** |

**Scripted checks** of the final zip in a fresh folder: unpack, doctor, `lean_env.sh --check`, `new_project.sh` (and its refusal on a second call), `check_paper.py` → READY, `write_prompt.py` (paper's file names filled in), `projects.py`, `validate`, `source-check`. `start_unattended.sh` was tested with a stand-in `claude` command: it started `pv_drive.sh --setup source/<main>.tex` under `nohup` and logged to `pv_work/logs/drive/`. The checking itself is tested in `kit/bench/results/`.

**Fixed because of this test:**
- `write_prompt.py` and `projects.py` trusted the template's placeholder `source/main.tex` before `/pv-setup`. Claude noticed and corrected the prompt by hand; the scripts now look in `source/`.
- `lean_env.sh` now says plainly when Mathlib is only partly compiled, and what that means: steps stop as `TRANSLATION_BLOCKED`. Claude had explained it wrongly from the old message.
- Claude now reports the result of `check_paper.py` in one line.
- `pv_drive.sh` now stops with a clear message when the setup registered no results.
- `doctor.sh` reads free space portably.

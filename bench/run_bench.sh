#!/usr/bin/env bash
# run_bench.sh — install a kit into a fresh project, add the benchmark paper, and run it unattended.
#
# Usage:
#   bench/run_bench.sh <kit_dir> <run_dir> <label> [--driver] [--model M] [--budget USD] --lean-from <dir>
#
#   <kit_dir>    a kit folder: this repository (v1.3), or an older version for comparison
#   <run_dir>    new directory for this run (must not exist)
#   --driver     v1.3 only: use scripts/pv_drive.sh (fresh session per batch) instead of one long session
#   --model M    coordinator model (default: opus)
#   --budget USD passed to claude --max-budget-usd for each session (a safety cap, default 80)
#   --lean-from  an existing project with the same Lean/Mathlib pins; its packages are linked, not copied
#
# Writes <run_dir>/bench_logs/: meta.json (label, kit, model, start/end, session ids), and the JSON result of
# every headless session. Analyse afterwards with: python3 <kit_dir>/template/scripts/pv_usage.py --project <run_dir>
set -uo pipefail

kit="${1:?kit dir}"; run="${2:?run dir}"; label="${3:?label}"; shift 3
driver=0; model="opus"; budget="80"; leanfrom=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --driver) driver=1; shift ;;
    --model) model="$2"; shift 2 ;;
    --budget) budget="$2"; shift 2 ;;
    --lean-from) leanfrom="$2"; shift 2 ;;
    *) echo "unknown option $1"; exit 2 ;;
  esac
done
[[ -n "$leanfrom" ]] || { echo "--lean-from is required"; exit 2; }
[[ -e "$run" ]] && { echo "$run already exists"; exit 2; }
here="$(cd "$(dirname "$0")" && pwd)"

"$kit/install.sh" "$run" --lean-from "$leanfrom" --link-packages > /dev/null || { echo "install failed"; exit 1; }
cd "$run" || exit 1
cp "$here/paper/main.tex" "$here/paper/main.pdf" "$here/paper/main.aux" source/
cp -R source verification/source_baseline
cp .claude/settings.example.json .claude/settings.json
mkdir -p bench_logs

PROMPT_SETUP='You are running unattended: no user is available to answer questions, so never wait for one. This is a benchmark run of the kit.
Please check the proofs already written in this paper with this project'"'"'s tex-proof-check-kit.
First read CLAUDE.md and the files in verification/rules/ that your role needs.
The main file is source/main.tex; the compiled PDF is source/main.pdf and source/main.aux (use them for theorem numbers).
verification/source_baseline/ has already been created by the user as an exact copy of source/; do not recreate it.'
PROMPT_ALL="$PROMPT_SETUP"'
1. Initialise by following .claude/skills/pv-setup/SKILL.md with source/main.tex. If a global notation question arises, make the most faithful choice, record it in verification/RESUME.md, and continue.
2. Then follow .claude/skills/pv-run/SKILL.md until every result has a verdict or a recorded reason. Translate the paper'"'"'s proofs faithfully; do not repair them or find new proofs. No internet, no downloads. Record problems and continue. Keep verification/RESUME.md current.
3. Do not run /pv-report. When every result has a verdict, print the progress table and stop.'

# Headless sessions stop background subagents 600 s after their last turn; wait up to 3 hours instead.
export CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=10800000
start=$(date +%s)
kitver=$(cat KIT_VERSION 2>/dev/null || echo unknown); cliver=$(claude --version 2>/dev/null | head -1)
cat > bench_logs/meta.json <<EOF
{"label": "$label", "kit": "$kit", "kit_version": "$kitver", "claude_code": "$cliver", "coordinator_model": "$model", "driver": $driver, "start_epoch": $start}
EOF
if [[ $driver -eq 1 ]]; then
  resume=""; grep -q -- "--auto-resume" scripts/pv_drive.sh && resume="--auto-resume"   # v1.3.1 and later
  PV_COORD_MODEL="$model" PV_BUDGET_USD="$budget" PV_LOG_DIR=bench_logs PV_SETUP_PROMPT="$PROMPT_SETUP" scripts/pv_drive.sh --setup source/main.tex $resume \
    > bench_logs/drive.out 2>&1
  ec=$?
else
  # --settings: headless sessions ignore a project's own allowlist until the folder has been trusted interactively,
  # so the same file is passed explicitly (flag settings are honoured).
  claude -p "$PROMPT_ALL" --model "$model" --output-format json --permission-mode acceptEdits \
    --settings .claude/settings.json --max-budget-usd "$budget" > bench_logs/session_1.json 2> bench_logs/session_1.err
  ec=$?
fi
end=$(date +%s)
python3 - "$start" "$end" "$ec" <<'EOF'
import json, sys, glob
start, end, ec = map(int, sys.argv[1:4])
m = json.load(open("bench_logs/meta.json"))
m.update(end_epoch=end, wall_seconds=end - start, exit_code=ec, sessions=[])
for f in sorted(glob.glob("bench_logs/session_*.json")):
    try:
        d = json.load(open(f))
        m["sessions"].append({"file": f, "session_id": d.get("session_id"), "cost_usd": d.get("total_cost_usd"),
                              "num_turns": d.get("num_turns"), "is_error": d.get("is_error"),
                              "terminal_reason": d.get("terminal_reason")})
    except Exception as e:
        m["sessions"].append({"file": f, "error": str(e)})
json.dump(m, open("bench_logs/meta.json", "w"), indent=1)
print(json.dumps(m, indent=1))
EOF
python3 scripts/pv_status.py table
exit $ec

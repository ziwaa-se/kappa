#!/usr/bin/env bash
# start_unattended.sh — start (or continue) the check of one project in the background, with the kit's driver
# (scripts/pv_drive.sh: fresh short sessions, Sonnet coordinator). Needs the terminal `claude` command and the
# project's .claude/settings.json. Survives closing VS Code (runs under tmux if available, otherwise nohup).
# By default (v1.3.1) the driver waits out usage limits and continues after the reset (--auto-resume), and makes the
# report once every result has a verdict (--report).
# Usage: autosetup/start_unattended.sh <project> [--no-auto-resume] [--no-report]
set -uo pipefail
proj="${1:?project folder}"; shift
auto="--auto-resume"; report="--report"
for a in "$@"; do
  case "$a" in
    --no-auto-resume) auto="" ;;
    --no-report) report="" ;;
    *) echo "unknown option $a"; exit 2 ;;
  esac
done
proj="$(cd "$proj" && pwd)"; cd "$proj" || exit 2
command -v claude >/dev/null 2>&1 || { echo "NO CLAUDE COMMAND: open this folder in VS Code and use START_PROMPT.txt instead"; exit 2; }
[[ -f .claude/settings.json ]] || { echo "NO PERMISSIONS FILE: .claude/settings.json is needed for unattended runs"; exit 2; }
if pgrep -f "$proj/scripts/pv_drive.sh" >/dev/null 2>&1 || pgrep -f "cd '$proj' && .*pv_drive.sh" >/dev/null 2>&1; then
  echo "ALREADY RUNNING: a driver is working in $proj (python3 scripts/pv_drive_status.py show)"; exit 3
fi
nres=$(python3 -c "import json;print(len(json.load(open('verification/RESULTS.json')).get('results',[])))" 2>/dev/null || echo 0)
if [[ "$nres" == "0" ]]; then
  main=$(cd "$proj" && for f in $(find source -name '*.tex'); do grep -l '\\documentclass' "$f"; done 2>/dev/null | head -1)
  [[ -n "$main" ]] || { echo "NO MAIN FILE in source/"; exit 2; }
  args="--setup $main"
else
  args=""
fi
mkdir -p pv_work/logs/drive
log="pv_work/logs/drive/driver_$(date +%Y%m%d-%H%M%S).out"
cmd="cd '$proj' && PV_LOG_DIR=pv_work/logs/drive '$proj/scripts/pv_drive.sh' $args $auto $report > '$log' 2>&1"
if command -v tmux >/dev/null 2>&1; then
  sess="proofcheck-$(basename "$proj")"
  tmux has-session -t "$sess" 2>/dev/null && { echo "ALREADY RUNNING in tmux session $sess"; exit 3; }
  tmux new-session -d -s "$sess" "$cmd" && echo "STARTED in tmux session $sess (attach: tmux attach -t $sess)"
else
  nohup bash -c "$cmd" >/dev/null 2>&1 &
  echo "STARTED in the background (pid $!)"
fi
echo "log: $proj/$log"
echo "progress: cd '$proj' && python3 scripts/pv_status.py table"
echo "driver status: cd '$proj' && python3 scripts/pv_drive_status.py show"
[[ -n "$auto" ]] && echo "usage limits: the driver sleeps until the reset and continues. Keep the computer on and the lid open."
exit 0

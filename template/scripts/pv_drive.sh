#!/usr/bin/env bash
# pv_drive.sh — run /pv-run unattended in short, fresh coordinator sessions (kit v1.3.1).
#
# Why: one long coordinator session re-reads its whole, ever-growing history on every step. Here each batch of at
# most PV_BATCH ready results gets a NEW headless session; all state passes through RESULTS.json and RESUME.md,
# exactly as /pv-resume already relies on. The interactive /pv-run stays available as before.
#
# Usage (from the project root, after /pv-setup, or with --setup):
#   scripts/pv_drive.sh [--setup source/main.tex] [--max-sessions N] [--auto-resume] [--report | --report-only]
#     --auto-resume  when the account's usage limit is reached, sleep until the reset time it states (plus 5 min;
#                    30 min if no time can be read) and continue. On macOS the driver keeps the machine awake with
#                    `caffeinate -i` while it runs; closing the lid still puts it to sleep
#     --report       after every result has a verdict, archive any previous report and run /pv-report
#     --report-only  only (re)make the report
# Environment:
#   PV_COORD_MODEL  coordinator model (default: sonnet; subagents use the model in their own definition)
#   PV_BATCH        results per session (default: 3)
#   PV_BUDGET_USD   --max-budget-usd per session, a safety cap (default: 30); a result may raise the cap for the
#                   sessions that work on it with "session_budget_usd" in RESULTS.json
#   PV_MAX_RESTARTS usage-limit waits before giving up (default: 20)
#   PV_LOG_DIR      where the JSON result of every session goes (default: pv_work/logs/drive)
#   PV_SETUP_PROMPT optional text put before the setup prompt
# Exit status: written to pv_work/logs/drive_status.json (reason, session, reset time) and returned as the exit code:
#   0 done · 3 usage limit (without --auto-resume) · 4 no progress · 5 validate not VALID · 6 --max-sessions reached ·
#   7 kit commands were refused (permission rules not applied) · 8 report incomplete · 9 too many usage-limit waits ·
#   1 the setup registered no results. The last line of the output always names the reason.
# Requirements: the `claude` command, and .claude/settings.json (copy it from settings.example.json after reading
# the kit's docs/MANUAL.md, section 2, step 4). The same file is passed with --settings, because headless sessions
# ignore a project's own allowlist until the folder has been trusted interactively. No permission check is skipped.
# The whole script is one function that bash reads completely before running it, so editing this file while a
# driver runs cannot change the running driver.
set -uo pipefail

main() {
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
  cd "$ROOT" || exit 2
  MODEL="${PV_COORD_MODEL:-sonnet}"
  BATCH="${PV_BATCH:-3}"
  BUDGET="${PV_BUDGET_USD:-30}"
  LOGDIR="${PV_LOG_DIR:-pv_work/logs/drive}"
  MAX_RESTARTS="${PV_MAX_RESTARTS:-20}"
  local setup="" max=20 report_only=0 n
  auto=0; report=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --setup) setup="$2"; shift 2 ;;
      --max-sessions) max="$2"; shift 2 ;;
      --auto-resume) auto=1; shift ;;
      --report) report=1; shift ;;
      --report-only) report_only=1; shift ;;
      *) sed -n '2,32p' "$0"; exit 2 ;;
    esac
  done
  command -v claude >/dev/null || { echo "the 'claude' command is not installed"; exit 2; }
  [[ -f .claude/settings.json ]] || { echo "no .claude/settings.json: read the kit's docs/MANUAL.md, section 2, step 4, then copy settings.example.json"; exit 2; }
  mkdir -p "$LOGDIR"
  # A headless session waits only 600 s for background subagents after its last turn and then stops them (a final
  # audit was lost this way in testing). Wait up to 3 hours instead; the per-session budget cap still applies.
  export CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS="${CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS:-10800000}"
  if [[ $auto -eq 1 && "${PV_CAFFEINATE:-1}" != 0 ]] && command -v caffeinate >/dev/null 2>&1; then
    caffeinate -i -w $$ >/dev/null 2>&1 &   # macOS: no idle sleep while this driver runs
  fi

  # Continue the numbering of earlier sessions (the driver may be re-run after an interruption).
  k=$(ls "$LOGDIR"/session_*.json 2>/dev/null | sed 's/.*session_\([0-9]*\)\.json/\1/' | sort -n | tail -1)
  k=${k:-0}
  worked=0; restarts=0; trust_noted=0; before=""
  kind=ok; wait_s=0; reset_at=-; msg=-
  status running "started"

  UNATTENDED="You are running unattended: no user is available to answer questions, so never wait for one; make the most faithful choice, record it in verification/RESUME.md, and continue. No internet, no downloads."
  [[ -f verification/REVISION_BRIEF.md ]] && UNATTENDED="$UNATTENDED Read verification/REVISION_BRIEF.md before anything else."

  [[ $report_only -eq 1 ]] && make_report
  if [[ -n "$setup" ]]; then
    while true; do
      session "${PV_SETUP_PROMPT:-}
$UNATTENDED
Read .claude/skills/pv-setup/SKILL.md and follow it with $setup. Stop when the setup is complete; do not start /pv-run." "$BUDGET"
      after_session || continue
      break
    done
    n=$(python3 -c "import json;print(len(json.load(open('verification/RESULTS.json')).get('results',[])))" 2>/dev/null || echo 0)
    [[ "$n" != "0" ]] || finish setup_failed "the setup session registered no results; see $LOGDIR/session_$k.json and verification/RESUME.md"
  fi

  while true; do
    python3 scripts/pv_status.py validate > "$LOGDIR/validate.txt" 2>&1 || {
      cat "$LOGDIR/validate.txt"; finish validate_failed "validate is not VALID (see $LOGDIR/validate.txt)"; }
    # Results already under way (e.g. after an interruption) come first, then new ready ones.
    local inflight ready recon ids second budget
    inflight=$(python3 -c "
import json
d=json.load(open('verification/RESULTS.json'))
print(' '.join(r['id'] for r in d.get('results',[]) if r.get('verdict')=='UNFINISHED' and r.get('stage') not in ('NOT_STARTED','INVENTORIED','STOPPED')))")
    # --all: a batch session writes its own scope into run_scope; the driver looks at every result.
    ready=$(python3 scripts/pv_status.py next --all | awk -F'\t' '$1=="READY"||$1=="RECHECK"{print $2}' | tr '\n' ' ')
    recon=$(python3 scripts/pv_status.py reconnect | grep -v "^no pending" || true)
    ids=$(echo $inflight $ready | tr ' ' '\n' | awk 'NF && !seen[$0]++' | head -n "$BATCH" | tr '\n' ' ')
    # Also take results that wait only on results of this batch (pv-run handles that order within one session).
    ids=$(python3 scripts/pv_status.py next --all | python3 -c "
import re, sys
ids = '$ids'.split(); batch = int('$BATCH')
for line in sys.stdin:
    f = line.rstrip('\n').split('\t')
    if f[0] == 'BLOCKED' and len(ids) < batch and f[1] not in ids:
        waits = re.findall(r'([A-Za-z0-9_]+)\(', f[3] if len(f) > 3 else '')
        if waits and all(w in ids for w in waits):
            ids.append(f[1])
print(' '.join(ids))")
    second=""
    if [[ -z "${ids// /}" && -z "$recon" ]]; then
      second=$(python3 scripts/pv_status.py next --second-pass --all | awk -F'\t' '$1=="READY"{print $2}' | tr '\n' ' ')
    fi
    if [[ -z "${ids// /}" && -z "$recon" && -z "${second// /}" ]]; then
      echo "Nothing left to start: every result has a verdict or a recorded reason."
      python3 scripts/pv_snapshot.py save --label all-verdicts > /dev/null 2>&1 || true
      [[ $report -eq 1 ]] && make_report
      finish done "every result has a verdict or a recorded reason"
    fi
    [[ $worked -lt $max ]] || finish max_sessions "--max-sessions $max reached; run the driver again to continue"
    budget=$(session_budget $ids $second)
    before=$(python3 scripts/pv_drive_status.py progress)
    if [[ -n "${ids// /}" || -n "$recon" ]]; then
      session "$UNATTENDED
Read .claude/skills/pv-run/SKILL.md and follow it with scope: ${ids:-none}. Also do the reconnections that 'python3 scripts/pv_status.py reconnect' lists. Handle only these results (plus their unfinished predecessors, per the scope rule) and stop when each has a verdict and no pending re-check (no RECHECK row in 'python3 scripts/pv_status.py next'), or is UNFINISHED with its reason recorded. Do not do the second pass and do not run /pv-report: the driver starts those in later sessions." "$budget"
    else
      session "$UNATTENDED
Read .claude/skills/pv-run/SKILL.md and do the second pass (§1 step 8) for: $second. Then do §6 (finish) of that skill. Do not run /pv-report." "$budget"
    fi
    after_session || continue          # usage limit: the driver slept until the reset; plan the step again
    worked=$((worked + 1))
    if [[ "$(python3 scripts/pv_drive_status.py progress)" == "$before" ]]; then
      finish no_progress "the last session changed no result; stopping so that nothing loops. See $LOGDIR/session_$k.json and verification/RESUME.md"
    fi
    status running "after session $k"
  done
}

session() {  # $1 = prompt, $2 = budget (USD)
  k=$((k + 1))
  local out="$LOGDIR/session_$k.json"
  status running "session $k started"
  echo "[$(date '+%H:%M')] session $k ($MODEL, cap \$$2): ${1:0:120}..."
  claude -p "$1" --model "$MODEL" --output-format json --permission-mode acceptEdits \
    --settings .claude/settings.json --max-budget-usd "$2" > "$out" 2> "$LOGDIR/session_$k.err"
  python3 - "$out" <<'EOF'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    print(f"  -> cost ${d.get('total_cost_usd', 0):.2f}, turns {d.get('num_turns')}, "
          f"{'ERROR ' if d.get('is_error') else ''}{d.get('terminal_reason', '')}")
except Exception as e:
    print(f"  -> no JSON result ({e})")
EOF
}

# After every session: stop if kit commands were refused, and wait out a usage limit. Returns 1 when the driver
# slept and the same step should be planned again, 0 otherwise.
after_session() {
  local out="$LOGDIR/session_$k.json" err="$LOGDIR/session_$k.err" line n std
  IFS=$'\t' read -r kind wait_s reset_at msg <<< "$(python3 scripts/pv_drive_status.py classify "$out" --err "$err")"
  if [[ $trust_noted -eq 0 ]] && grep -q "has not been trusted" "$err" 2>/dev/null; then
    trust_noted=1
    echo "  NOTE: Claude Code reports this folder as not trusted. The driver passes the permission file with --settings;"
    echo "        if kit commands are refused, open the folder once in Claude Code interactively and accept the trust dialog."
  fi
  line=$(python3 scripts/pv_drive_status.py denials "$out" | head -1)
  n=$(echo "$line" | awk '{print $2}'); std=$(echo "$line" | awk '{print $4}')
  [[ "${n:-0}" -gt 0 ]] && echo "  permission denials in session $k: $n (details: python3 scripts/pv_drive_status.py denials $out)"
  if [[ "${std:-0}" -gt 0 ]]; then
    finish permissions "session $k: $std kit commands in their standard form were refused, so the permission rules did not apply. Open this folder once in Claude Code interactively, accept the trust dialog, then run the driver again"
  fi
  [[ "$kind" == "budget" ]] && echo "  the session reached its budget cap (\$$BUDGET or the result's session_budget_usd)"
  case "$kind" in
    usage_limit|limit_in_agents)
      if [[ "$kind" == "limit_in_agents" && "$(python3 scripts/pv_drive_status.py progress)" != "$before" ]]; then
        return 0     # some agents hit the limit, but the session still made progress; the next session will tell
      fi
      if [[ $auto -eq 0 ]]; then
        finish usage_limit "usage limit reached in session $k (resets ${reset_at}); run the driver again after the reset, or use --auto-resume"
      fi
      restarts=$((restarts + 1))
      [[ $restarts -le $MAX_RESTARTS ]] || finish max_restarts "more than $MAX_RESTARTS usage-limit waits"
      status waiting_usage_limit "usage limit in session $k; sleeping ${wait_s}s"
      echo "[$(date '+%H:%M')] usage limit reached (session $k, resets ${reset_at}); sleeping ${wait_s}s, then continuing (wait $restarts of at most $MAX_RESTARTS)"
      ${PV_SLEEP_CMD:-sleep} "$wait_s"
      echo "[$(date '+%H:%M')] continuing after the usage-limit wait"
      status running "resumed after a usage-limit wait"
      return 1 ;;
  esac
  return 0
}

session_budget() {  # the largest session_budget_usd among the given results, and at least PV_BUDGET_USD
  python3 - "$BUDGET" "$@" <<'EOF'
import json, sys
base, ids = float(sys.argv[1]), set(sys.argv[2:])
d = json.load(open("verification/RESULTS.json"))
vals = [float(r["session_budget_usd"]) for r in d.get("results", []) if r.get("id") in ids and r.get("session_budget_usd")]
print(f"{max([base] + vals):g}")
EOF
}

make_report() {
  local dest f
  python3 scripts/pv_status.py validate > "$LOGDIR/validate.txt" 2>&1 || {
    cat "$LOGDIR/validate.txt"; finish validate_failed "validate is not VALID before the report (see $LOGDIR/validate.txt)"; }
  if [[ -f verification/report/AUTHOR_REPORT.md ]]; then
    dest="verification/report_archive/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$dest/work"
    for f in verification/report/*.md; do [[ -f "$f" ]] && mv "$f" "$dest/"; done
    for f in verification/report/work/*; do [[ -f "$f" && "$(basename "$f")" != .gitkeep ]] && mv "$f" "$dest/work/"; done
    echo "archived the previous report to $dest/"
  fi
  before=""
  while true; do
    session "$UNATTENDED
Read .claude/skills/pv-report/SKILL.md and carry out its steps yourself (the skill is user-invocable only, so do not use the Skill tool). Wait for the subagents you start before ending your turn." "$BUDGET"
    after_session || continue
    break
  done
  if [[ -f verification/report/AUTHOR_REPORT.md && -f verification/report/work/factcheck.md ]]; then
    finish done_report "the report is in verification/report/ (AUTHOR_REPORT.md, EXTERNAL_TOOLS_WORKSHEET.md, FILES_TO_CHECK.md)"
  fi
  finish report_incomplete "the report session ended without verification/report/AUTHOR_REPORT.md and work/factcheck.md; see $LOGDIR/session_$k.json"
}

status() {  # $1 = reason, $2 = message
  python3 scripts/pv_drive_status.py write --reason "$1" --session "$k" --wait "${wait_s:-0}" \
    --reset-at "${reset_at#-}" --restarts "$restarts" --message "$2" > /dev/null 2>&1 || true
}

finish() {  # $1 = reason, $2 = message; prints the table, then the reason as the very last line
  local code
  status "$1" "$2"
  python3 scripts/pv_status.py table 2>/dev/null || true
  echo
  echo "DRIVER STOPPED: $1 — $2"
  case "$1" in
    done|done_report) code=0 ;; usage_limit) code=3 ;; no_progress) code=4 ;; validate_failed) code=5 ;;
    max_sessions) code=6 ;; permissions) code=7 ;; report_incomplete) code=8 ;; max_restarts) code=9 ;; *) code=1 ;;
  esac
  exit "$code"
}

main "$@"; exit $?

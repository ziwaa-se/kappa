#!/usr/bin/env bash
# pv_drive.sh — run /pv-run unattended in short, fresh coordinator sessions (kit v1.3).
#
# Why: one long coordinator session re-reads its whole, ever-growing history on every step. Here each batch of at
# most PV_BATCH ready results gets a NEW headless session; all state passes through RESULTS.json and RESUME.md,
# exactly as /pv-resume already relies on. The interactive /pv-run stays available as before.
#
# Usage (from the project root, after /pv-setup, or with --setup):
#   scripts/pv_drive.sh [--setup source/main.tex] [--max-sessions N]
# Environment:
#   PV_COORD_MODEL  coordinator model (default: sonnet; subagents use the model in their own definition)
#   PV_BATCH        results per session (default: 3)
#   PV_BUDGET_USD   --max-budget-usd per session, a safety cap (default: 30)
#   PV_LOG_DIR      where the JSON result of every session goes (default: pv_work/logs/drive)
#   PV_SETUP_PROMPT optional text put before the setup prompt
# Requirements: the `claude` command, and .claude/settings.json (copy it from settings.example.json after reading
# the kit's docs/MANUAL.md, section 2, step 4). The same file is passed with --settings, because headless sessions ignore a project's
# own allowlist until the folder has been trusted interactively. No permission check is ever skipped.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 2
MODEL="${PV_COORD_MODEL:-sonnet}"
BATCH="${PV_BATCH:-3}"
BUDGET="${PV_BUDGET_USD:-30}"
LOGDIR="${PV_LOG_DIR:-pv_work/logs/drive}"
setup=""; max=20
while [[ $# -gt 0 ]]; do
  case "$1" in
    --setup) setup="$2"; shift 2 ;;
    --max-sessions) max="$2"; shift 2 ;;
    *) sed -n '2,20p' "$0"; exit 2 ;;
  esac
done
command -v claude >/dev/null || { echo "the 'claude' command is not installed"; exit 2; }
[[ -f .claude/settings.json ]] || { echo "no .claude/settings.json: read the kit's docs/MANUAL.md, section 2, step 4, then copy settings.example.json"; exit 2; }
mkdir -p "$LOGDIR"
# A headless session waits only 600 s for background subagents after its last turn and then kills them (a final
# audit was lost this way in testing). Wait up to 3 hours instead; the per-session budget cap still applies.
export CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS="${CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS:-10800000}"

# Continue the numbering of earlier sessions (the driver may be re-run after an interruption).
k=$(ls "$LOGDIR"/session_*.json 2>/dev/null | sed 's/.*session_\([0-9]*\)\.json/\1/' | sort -n | tail -1)
k=${k:-0}
session() {  # $1 = prompt
  k=$((k + 1))
  local out="$LOGDIR/session_$k.json"
  echo "[$(date '+%H:%M')] session $k ($MODEL): ${1:0:120}..."
  claude -p "$1" --model "$MODEL" --output-format json --permission-mode acceptEdits \
    --settings .claude/settings.json --max-budget-usd "$BUDGET" > "$out" 2> "$LOGDIR/session_$k.err"
  local ec=$?
  python3 - "$out" <<'EOF'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
    print(f"  -> cost ${d.get('total_cost_usd', 0):.2f}, turns {d.get('num_turns')}, "
          f"{'ERROR ' if d.get('is_error') else ''}{d.get('terminal_reason', '')}")
except Exception as e:
    print(f"  -> no JSON result ({e})")
EOF
  return $ec
}
state() { python3 -c "import json;print(json.dumps([(r['id'],r.get('stage'),r.get('verdict')) for r in json.load(open('verification/RESULTS.json')).get('results',[])]))"; }

UNATTENDED="You are running unattended: no user is available to answer questions, so never wait for one; make the most faithful choice, record it in verification/RESUME.md, and continue. No internet, no downloads."

if [[ -n "$setup" ]]; then
  session "${PV_SETUP_PROMPT:-}
$UNATTENDED
Read .claude/skills/pv-setup/SKILL.md and follow it with $setup. Stop when the setup is complete; do not start /pv-run." || true
  n=$(python3 -c "import json;print(len(json.load(open('verification/RESULTS.json')).get('results',[])))" 2>/dev/null || echo 0)
  if [[ "$n" == "0" ]]; then
    echo "The setup session registered no results. See $LOGDIR/session_$k.json and verification/RESUME.md; stopping."
    exit 1
  fi
fi

while [[ $k -lt $max ]]; do
  python3 scripts/pv_status.py validate > "$LOGDIR/validate.txt" 2>&1 || { echo "validate is not VALID; stopping:"; cat "$LOGDIR/validate.txt"; break; }
  # Results already under way (e.g. after an interruption) come first, then new ready ones.
  inflight=$(python3 -c "
import json
d=json.load(open('verification/RESULTS.json'))
print(' '.join(r['id'] for r in d.get('results',[]) if r.get('verdict')=='UNFINISHED' and r.get('stage') not in ('NOT_STARTED','INVENTORIED','STOPPED')))")
  # --all: a batch session writes its own scope into run_scope; the driver looks at every result.
  ready=$(python3 scripts/pv_status.py next --all | awk -F'\t' '$1=="READY"{print $2}' | tr '\n' ' ')
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
  before=$(state)
  if [[ -n "${ids// /}" || -n "$recon" ]]; then
    session "$UNATTENDED
Read .claude/skills/pv-run/SKILL.md and follow it with scope: ${ids:-none}. Also do the reconnections that 'python3 scripts/pv_status.py reconnect' lists. Handle only these results (plus their unfinished predecessors, per the scope rule) and stop when each has a verdict or is UNFINISHED with its reason recorded. Do not do the second pass and do not run /pv-report: the driver starts those in later sessions." || true
  else
    second=$(python3 scripts/pv_status.py next --second-pass --all | awk -F'\t' '$1=="READY"{print $2}' | tr '\n' ' ')
    if [[ -n "${second// /}" ]]; then
      session "$UNATTENDED
Read .claude/skills/pv-run/SKILL.md and do the second pass (§1 step 8) for: $second. Then do §6 (finish) of that skill. Do not run /pv-report." || true
    else
      echo "Nothing left to start: every result has a verdict or a recorded reason."
      python3 scripts/pv_snapshot.py save --label all-verdicts > /dev/null 2>&1 || true
      break
    fi
  fi
  if [[ "$(state)" == "$before" ]]; then
    echo "The last session changed no result; stopping so that nothing loops. See $LOGDIR/session_$k.json and verification/RESUME.md."
    break
  fi
done
python3 scripts/pv_status.py table

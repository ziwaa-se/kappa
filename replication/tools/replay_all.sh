#!/usr/bin/env bash
# replay_all.sh <kit folder> <Lean environment> [<examples folder>] — rebuild every archived run offline and rerun
# its mechanical audits (no language model). The examples folder defaults to <kit folder>/examples.
set -uo pipefail
kit="${1:?kit folder}"; lean="${2:?Lean environment (lean_env.sh)}"; ex="${3:-$kit/examples}"
status=0
for res in "$ex"/*/results; do
  [[ -f "$res/verification/RESULTS.json" ]] || continue
  name=$(basename "$(dirname "$res")")
  start=$(date +%s)
  if python3 "$kit/examples/tools/replay.py" "$res" --lean-env "$lean" > "replay_$name.md" 2>&1; then r=ok; else r=FAILED; status=1; fi
  echo "$name: $r in $(( $(date +%s) - start )) s — $(tail -1 "replay_$name.md")"
done
exit $status

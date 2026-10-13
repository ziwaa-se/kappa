#!/usr/bin/env bash
# pv_lean.sh — compile Lean files of pv_work/ with honest bookkeeping (kit v1.3; prints the first errors).
#
# Usage (from the project root):
#   scripts/pv_lean.sh check <Module>          type-check pv_work/<Module>.lean; never writes an .olean
#                                               (use this for statement drafts that still contain `sorry`)
#   scripts/pv_lean.sh build <Module>          type-check and write pv_work/<Module>.olean; refuses (exit 3) and
#                                               deletes any older .olean if the file has errors or uses `sorry`
#   scripts/pv_lean.sh probe <path/File.lean>  type-check a probe file under pv_work/ (no .olean)
#   scripts/pv_lean.sh rebuild <Module> <ID>   auditor: private rebuild into pv_work/probes/auditor/<ID>/rebuild/
#                                               and sha256 comparison with pv_work/<Module>.olean
#   scripts/pv_lean.sh packages                print whether .lake/packages is linked or copied, and how many
#                                               mathlib modules are compiled (linked: never run `lake build`)
#
# Every compile writes a numbered log pv_work/logs/<name>_<k>.log whose last line is "EXIT=<code>", and prints one
# RESULT line with the same code. Exit codes: the compiler's own code; 3 for a refused build; 5 for a file that uses
# IO, run_cmd or initialize (refused before compiling: POLICY §4, Lean files run no programs and touch no files). Build modules in
# dependency order; after rebuilding a module, rebuild every pv_work module that imports it. Name probes
# <role>_<ID>_<what>.lean (e.g. auditor_T01_walk.lean) so log names never collide (macOS is case-insensitive).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$ROOT/pv_work"
LOGS="$WORK/logs"
mkdir -p "$LOGS"

mode="${1:-}"
target="${2:-}"
usage() { sed -n '2,20p' "$0"; exit 2; }
# sha256 of a file on macOS (shasum) and Linux (sha256sum), with a python3 fallback.
sha256() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | cut -d' ' -f1
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1
  else python3 -c 'import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$1"; fi
}
# v1.3.1 (POLICY §4): Lean code can run programs, touch files and reach the network (IO actions, run_cmd,
# initialize), which would bypass every permission rule. Such files are refused before they are compiled.
io_guard() {
  local hits
  hits=$(grep -nE '(^|[^A-Za-z0-9_.])IO([.[:space:]]|$)|(^|[^A-Za-z0-9_])(run_cmd|initialize|builtin_initialize)([^A-Za-z0-9_]|$)' "$1" \
    | grep -vE '^[0-9]+:[[:space:]]*--' | head -3 | tr '\n' ';')
  if [[ -n "$hits" ]]; then
    echo "REFUSED $(basename "$1" .lean) exit=5: the file uses IO, run_cmd or initialize; Lean files run no programs and touch no files (POLICY §4): $hits"
    exit 5
  fi
}

[[ -n "$mode" ]] || usage

if [[ "$mode" == "packages" ]]; then
  if [[ -L "$ROOT/.lake/packages" ]]; then kind="linked -> $(readlink "$ROOT/.lake/packages")"; else kind="copied"; fi
  built=$( (find "$ROOT/.lake/packages/mathlib/.lake/build/lib/lean/Mathlib" -name "*.olean" 2>/dev/null || true) | wc -l | tr -d " ")
  total=$( (find "$ROOT/.lake/packages/mathlib/Mathlib" -name "*.lean" 2>/dev/null || true) | wc -l | tr -d " ")
  echo "PACKAGES $kind; mathlib modules compiled: $built of $total"
  [[ "$kind" == linked* ]] && echo "linked: do NOT run 'lake build' (it would write into the other project)"
  exit 0
fi

[[ -n "$target" ]] || usage
case "$mode" in
  check|build) file="$WORK/$target.lean"; base="$target" ;;
  probe) file="$target"; [[ "$file" = /* ]] || file="$ROOT/$file"; base="$(basename "$file" .lean)" ;;
  rebuild)
    id="${3:-}"; [[ -n "$id" ]] || usage
    file="$WORK/$target.lean"; [[ -f "$file" ]] || { echo "no such file: $file"; exit 2; }
    [[ -f "$WORK/$target.olean" ]] || { echo "no delivered pv_work/$target.olean to compare with"; exit 2; }
    io_guard "$file"
    out="$WORK/probes/auditor/$id/rebuild"; mkdir -p "$out"
    cd "$ROOT" || exit 2
    LEAN_PATH="$WORK:${LEAN_PATH:-}" lake env lean -R "$WORK" -o "$out/$target.olean" "$file" > "$out/$target.rebuild.log" 2>&1
    ec=$?
    a=$(sha256 "$WORK/$target.olean")
    b=$( [[ -f "$out/$target.olean" ]] && sha256 "$out/$target.olean" || echo none)
    verdict=$([[ "$a" == "$b" && $ec -eq 0 ]] && echo IDENTICAL || echo DIFFERENT)
    echo "REBUILD $target exit=$ec delivered=$a rebuilt=$b $verdict log=${out#$ROOT/}/$target.rebuild.log"
    [[ "$verdict" == IDENTICAL ]] && exit 0 || exit 4
    ;;
  *) echo "unknown mode: $mode"; usage ;;
esac
[[ -f "$file" ]] || { echo "no such file: $file"; exit 2; }
io_guard "$file"

k=1
while [[ -e "$LOGS/${base}_${k}.log" ]]; do k=$((k + 1)); done
log="$LOGS/${base}_${k}.log"

cd "$ROOT" || exit 2
tmp_olean=""
if [[ "$mode" == "build" ]]; then
  tmp_olean="$(mktemp "$WORK/.${base}.XXXXXX")"
  LEAN_PATH="$WORK:${LEAN_PATH:-}" lake env lean -R "$WORK" -o "$tmp_olean" "$file" > "$log" 2>&1
  ec=$?
else
  LEAN_PATH="$WORK:${LEAN_PATH:-}" lake env lean "$file" > "$log" 2>&1
  ec=$?
fi

errors=$(grep -c ": error" "$log" || true)
sorries=$(grep -c "declaration uses 'sorry'" "$log" || true)
nonstd=$(grep -c "NONSTANDARD|" "$log" || true)

olean="none"
if [[ "$mode" == "build" ]]; then
  if [[ $ec -eq 0 && $errors -eq 0 && $sorries -eq 0 ]]; then
    mv -f "$tmp_olean" "$WORK/$base.olean"
    olean="$WORK/$base.olean"
  else
    rm -f "$tmp_olean" "$WORK/$base.olean"
    olean="REFUSED (errors or sorry present; no .olean kept, older .olean deleted)"
    [[ $ec -eq 0 ]] && ec=3
  fi
fi
echo "EXIT=$ec" >> "$log"

# Tokens that must never appear in a finished proof. Comments can contain these words, so a hit is a prompt to
# look, not a verdict; `sorry` itself is detected from the compiler's own warning above.
tokens=$(grep -nE '(^|[^A-Za-z_.])(admit|native_decide)([^A-Za-z_]|$)|^[[:space:]]*(@\[[^]]*\][[:space:]]*)?((private|protected|noncomputable|partial|nonrec)[[:space:]]+)*(axiom|unsafe)[[:space:]]|implemented_by|@\[extern|skipKernelTC|debug\.skip' "$file" | head -5 | tr '\n' ';')

echo "RESULT $base mode=$mode exit=$ec errors=$errors sorry_warnings=$sorries nonstandard_axiom_lines=$nonstd log=${log#$ROOT/} olean=${olean#$ROOT/}"
[[ -n "$tokens" ]] && echo "CHECK-TOKENS (verify these are only in comments): $tokens"
# v1.3: print the first errors (position, message, goal) so that the log rarely has to be read in full.
if [[ $errors -gt 0 ]]; then
  echo "FIRST ERRORS (up to ${PV_MAX_ERRORS:-3}, ${PV_MAX_ERROR_LINES:-30} lines each; full log: ${log#$ROOT/}):"
  awk -v max="${PV_MAX_ERRORS:-3}" -v maxl="${PV_MAX_ERROR_LINES:-30}" -v root="$ROOT/" '
    /^EXIT=/ { exit }
    /^[^ \t].*:[0-9]+:[0-9]+: (error|warning|info)/ {
      inerr = ($0 ~ /:[0-9]+:[0-9]+: error/)
      if (inerr) { n++; if (n > max) exit; lines = 0; i = index($0, root); if (i == 1) $0 = substr($0, length(root) + 1); print "--- " substr($0, 1, 300) }
      next
    }
    inerr { lines++; if (lines <= maxl) print "    " substr($0, 1, 200); else if (lines == maxl + 1) print "    [...]" }
  ' "$log"
fi
exit $ec

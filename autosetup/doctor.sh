#!/usr/bin/env bash
# doctor.sh — report what this machine has for the proof-check kit. Reads only; downloads and installs nothing.
# Usage: autosetup/doctor.sh <base folder>
base="${1:-.}"
row() { printf '%-16s %s\n' "$1" "$2"; }
echo "== Environment for the TeX proof-check kit ($(date '+%Y-%m-%d %H:%M'))"
row "machine" "$(uname -sm) $(uname -r)"
row "bash" "${BASH_VERSION}"
for c in git curl unzip python3 elan lake claude pdflatex latexmk tmux screen; do
  if command -v "$c" >/dev/null 2>&1; then
    case "$c" in
      python3) v="$(python3 -c 'import sys; print("%d.%d.%d" % sys.version_info[:3])')"
               python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 6) else 1)' || v="$v  (TOO OLD: need 3.6 or newer; try 'module load python')" ;;
      git) v="$(git --version 2>/dev/null)" ;;
      elan) v="$(elan --version 2>/dev/null | head -1)" ;;
      claude) v="$(claude --version 2>/dev/null | head -1)  (terminal Claude Code: unattended runs possible)" ;;
      *) v="found" ;;
    esac
    row "$c" "$v"
  else
    case "$c" in
      elan|lake) row "$c" "MISSING (Lean's installer; needed once, see CLAUDE_START_HERE.md step B)" ;;
      claude) row "$c" "not on PATH (fine: checks then run in a Claude chat opened in the project folder)" ;;
      pdflatex|latexmk|tmux|screen) row "$c" "not found (optional)" ;;
      *) row "$c" "MISSING" ;;
    esac
  fi
done
mkdir -p "$base" 2>/dev/null
row "base folder" "$(cd "$base" && pwd)"
row "free space" "$(df -Pk "$base" 2>/dev/null | awk 'NR==2 {printf "%.1f GB free of %.1f GB (%s)", $4/1048576, $2/1048576, $6}')"
if command -v quota >/dev/null 2>&1; then
  q="$(quota -s 2>/dev/null | tail -n +3 | head -3 | tr -s ' ')"; [[ -n "$q" ]] && row "quota" "$q"
fi
if [[ -d "$base/lean-env/.lake/packages/mathlib" ]]; then
  n=$(find "$base/lean-env/.lake/packages/mathlib/.lake/build/lib/lean/Mathlib" -name '*.olean' 2>/dev/null | wc -l | tr -d ' ')
  row "lean-env" "present ($n Mathlib modules compiled)"
else
  row "lean-env" "not set up yet (needs about 5-8 GB, once)"
fi
n=$(ls -d "$base"/papers/*-check 2>/dev/null | wc -l | tr -d ' ')
row "paper projects" "$n in $base/papers/"

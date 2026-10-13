#!/usr/bin/env bash
# lean_env.sh — set up, once, the shared Lean 4.19.0 + Mathlib environment that every paper project links to.
# Usage:
#   autosetup/lean_env.sh <base> --check                      is <base>/lean-env ready?
#   autosetup/lean_env.sh <base> --download                   DOWNLOADS Lean and Mathlib (a few GB). Only after the user agreed.
#   autosetup/lean_env.sh <base> --from <existing project>    copy the Lean packages of a project with the same versions (no download)
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"; kit="$here/.."   # the repository root is the kit
base="${1:?base folder}"; mode="${2:---check}"
mkdir -p "$base"; base="$(cd "$base" && pwd)"; env="$base/lean-env"
ready() { [[ -d "$env/.lake/packages/mathlib" ]] && (cd "$env" && scripts/pv_lean.sh build PVTools >/dev/null 2>&1); }
completeness() {  # paper projects LINK to this environment and never compile Mathlib themselves
  local built total
  built=$(find "$env/.lake/packages/mathlib/.lake/build/lib/lean/Mathlib" -name '*.olean' 2>/dev/null | wc -l | tr -d ' ')
  total=$(find "$env/.lake/packages/mathlib/Mathlib" -name '*.lean' 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$total" -gt 0 && "$built" -lt $((total * 95 / 100)) ]]; then
    echo "INCOMPLETE: only $built of $total Mathlib modules are compiled. Paper projects link to this environment and"
    echo "  never compile Mathlib themselves, so a proof step that needs a missing module stops as TRANSLATION_BLOCKED."
    echo "  To complete it (a download of a few GB, ask first): cd '$env' && lake exe cache get"
  else
    echo "COMPLETE: $built of $total Mathlib modules compiled"
  fi
}
case "$mode" in
  --check)
    if ready; then echo "LEAN-ENV READY: $env"; completeness; exit 0; fi
    echo "LEAN-ENV NOT READY: $env"; exit 1 ;;
  --download)
    command -v elan >/dev/null 2>&1 || { echo "elan is missing: install it first (CLAUDE_START_HERE.md step B)"; exit 2; }
    [[ -e "$env" ]] || "$kit/install.sh" "$env" --pinned || exit 1
    echo "Downloading Lean 4.19.0 and Mathlib (a few GB, typically 5-20 minutes) ..."
    if ! (cd "$env" && lake exe cache get 2>&1 | tee "$base/lean-env-cache.log"; exit "${PIPESTATUS[0]}"); then
      # macOS 26 and later refuse to load the `cache` helper as linked by Lean 4.19.0's bundled linker
      # ("__DATA_CONST segment missing SG_READ_ONLY flag"). Relink it with the system compiler and try again.
      if [[ "$(uname)" == Darwin ]] && grep -q "SG_READ_ONLY\|dyld" "$base/lean-env-cache.log" && command -v xcrun >/dev/null 2>&1; then
        echo "Relinking Mathlib's cache tool with the system compiler (macOS refused the bundled linker's output) ..."
        prefix="$(cd "$env" && lean --print-prefix)"
        rm -f "$env/.lake/packages/mathlib/.lake/build/bin/cache" "$env/.lake/packages/mathlib/.lake/build/bin/cache.hash" \
              "$env/.lake/packages/mathlib/.lake/build/bin/cache.trace"
        (cd "$env" && SDKROOT="$(xcrun --show-sdk-path)" LIBRARY_PATH="$prefix/lib" LEAN_CC="$(xcrun -f clang)" lake exe cache get) || {
          echo "lake exe cache get failed again; see $base/lean-env-cache.log"; exit 1; }
      else
        echo "lake exe cache get failed (network?). Retry later; as a last resort: cd $env && lake build"; exit 1
      fi
    fi
    ready && { echo "LEAN-ENV READY: $env"; completeness; exit 0; } || { echo "PVTools did not build; see $env/pv_work/logs/"; exit 1; } ;;
  --from)
    src="${3:?existing project}"; src="$(cd "$src" && pwd)"
    [[ -d "$src/.lake/packages/mathlib" ]] || { echo "$src has no .lake/packages/mathlib"; exit 2; }
    [[ -e "$env" ]] && { echo "$env already exists; not touched"; ready && exit 0 || exit 1; }
    "$kit/install.sh" "$env" --lean-from "$src" || exit 1
    echo "LEAN-ENV READY: $env (copied from $src)"; completeness; exit 0 ;;
  *) sed -n '2,7p' "$0"; exit 2 ;;
esac

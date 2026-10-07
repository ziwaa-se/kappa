#!/usr/bin/env bash
# new_project.sh — make a NEW project for ONE paper: <base>/papers/<name>-check. Never reuses an existing folder.
# Usage: autosetup/new_project.sh <base> <name>      (name: lowercase letters, digits and '-', e.g. ladder-gate)
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"; kit="$here/.."   # the repository root is the kit
base="${1:?base folder}"; name="${2:?short name for the paper}"
[[ "$name" =~ ^[a-z0-9][a-z0-9-]{1,40}$ ]] || { echo "BAD NAME: use 2-41 lowercase letters, digits or '-', e.g. ladder-gate"; exit 2; }
base="$(cd "$base" && pwd)"; proj="$base/papers/$name-check"
if [[ -e "$proj" ]]; then
  echo "EXISTS: $proj is already the project of another check. It is never reused for a different paper:"
  python3 "$here/projects.py" "$base" --one "$proj"
  exit 3
fi
"$here/lean_env.sh" "$base" --check >/dev/null || { echo "The shared Lean environment $base/lean-env is not ready (lean_env.sh)"; exit 4; }
mkdir -p "$base/papers"
"$kit/install.sh" "$proj" --lean-from "$base/lean-env" --link-packages > "$base/papers/.install-$name.log" 2>&1 || {
  echo "install failed; see $base/papers/.install-$name.log"; exit 1; }
cat > "$proj/PROJECT_INFO.md" <<INFO
# Proof-check project: $name

- Created: $(date '+%Y-%m-%d %H:%M'), kit version $(cat "$proj/KIT_VERSION" 2>/dev/null)
- **One paper only.** A different paper gets a new project (a new name). A corrected version of THIS paper:
  put it into source/ and use the revision prompt (GUIDE section 8.3).
- Lean and Mathlib are shared with $base/lean-env (linked).
- To work on this paper, open THIS folder in VS Code (or the Claude desktop app) and start a new Claude chat here.
INFO
echo "CREATED: $proj"
echo "Put the paper into: $proj/source/"

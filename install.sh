#!/usr/bin/env bash
# install.sh — set up a new paper project from this kit.
#
# Usage:
#   ./install.sh <new-project-dir> --pinned
#   ./install.sh <new-project-dir> --lean-from <existing-lean-project> [--link-packages]
#   ./install.sh <new-project-dir>
#   ./install.sh <existing-project-dir> --upgrade
#
#   <new-project-dir>   created if missing. Existing files are NEVER overwritten (reported and skipped).
#   --upgrade           bring an EXISTING project to this kit version (for a new zip of the kit). Replaces only
#                       the kit's own files (CLAUDE.md, KIT_VERSION, .claude/agents, .claude/skills,
#                       .claude/settings.example.json, scripts/, verification/rules/, report templates) and moves
#                       the old ones to kit_backup/<date>/. Never touches source/, the records in verification/,
#                       audits, pv_work/ Lean files, pv_work/PVTools.lean or .claude/settings.json. Stop Claude Code
#                       in that project first; afterwards continue with /pv-resume.
#
#   --pinned            fresh machine: writes the tested Lean/Mathlib pins (Lean 4.19.0, Mathlib c44e0c8e,
#                       from lean-pins/). Afterwards run, inside the project:
#                           lake exe cache get                 (downloads Mathlib and its prebuilt files)
#                           scripts/pv_lean.sh build PVTools   (environment check; must print exit=0)
#   --lean-from <dir>   reuse the Lean toolchain and Mathlib of an existing project: copies its
#                       lean-toolchain and lake-manifest.json, writes a minimal lakefile.toml, and COPIES
#                       .lake/packages (several GB, no download). Then builds PVTools as a check.
#   --link-packages     with --lean-from: symlink .lake/packages instead of copying (instant). The two
#                       projects then share Mathlib, so the kit never runs `lake build` on it.
#   (neither)           only the kit files; use this inside a Lean project you already have.
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
SRC="$KIT/template"
dest="${1:-}"
[[ -n "$dest" && "$dest" != --* ]] || { sed -n '2,29p' "$0"; exit 2; }
shift
lean_from=""; link_pkgs=0; pinned=0; upgrade=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --upgrade) upgrade=1; shift ;;
    --lean-from) lean_from="$2"; shift 2 ;;
    --link-packages) link_pkgs=1; shift ;;
    --copy-packages) shift ;;   # accepted for compatibility; copying is the default
    --pinned) pinned=1; shift ;;
    *) echo "unknown option: $1"; exit 2 ;;
  esac
done
if [[ $pinned -eq 1 && -n "$lean_from" ]]; then echo "use either --pinned or --lean-from, not both"; exit 2; fi
python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 6) else 1)' 2>/dev/null || {
  echo "The kit's scripts need python3, version 3.6 or newer (on a cluster, try: module load python)"; exit 2; }

if [[ $upgrade -eq 1 ]]; then
  [[ $pinned -eq 0 && -z "$lean_from" ]] || { echo "--upgrade cannot be combined with --pinned or --lean-from"; exit 2; }
  [[ -f "$dest/CLAUDE.md" && -f "$dest/verification/RESULTS.json" ]] || {
    echo "$dest is not a project made with this kit (no CLAUDE.md or verification/RESULTS.json); use a normal install"; exit 2; }
  dest="$(cd "$dest" && pwd)"
  old_ver="$(cat "$dest/KIT_VERSION" 2>/dev/null || echo 'unknown (1.2.1 or earlier)')"
  new_ver="$(cat "$SRC/KIT_VERSION")"
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="$dest/kit_backup/$stamp"
  echo "Upgrading $dest: kit $old_ver -> $new_ver"
  replaced=0; added=0; same=0; kept=0
  while IFS= read -r -d '' f; do
    rel="${f#$SRC/}"
    target="$dest/$rel"
    case "$rel" in
      .claude/settings.example.json)   # v1.3.1: written for this project's own path (scripts/pv_settings.py)
        tmp_ex="$(mktemp)"
        python3 "$SRC/scripts/pv_settings.py" expand --root "$dest" --base "$f" --out "$tmp_ex" > /dev/null
        if [[ ! -e "$target" ]]; then
          mkdir -p "$(dirname "$target")"; mv "$tmp_ex" "$target"; echo "ADDED    $rel"; added=$((added + 1))
        elif cmp -s "$tmp_ex" "$target"; then
          rm -f "$tmp_ex"; same=$((same + 1))
        else
          mkdir -p "$(dirname "$backup/$rel")"; mv "$target" "$backup/$rel"; mv "$tmp_ex" "$target"
          echo "REPLACED $rel"; replaced=$((replaced + 1))
        fi ;;
      CLAUDE.md|KIT_VERSION|.claude/agents/*|.claude/skills/*|scripts/*|\
      verification/rules/*|verification/report/templates/*|pv_work/probes/README.md|pv_work/notes/README.md)
        if [[ ! -e "$target" ]]; then
          mkdir -p "$(dirname "$target")"; cp -p "$f" "$target"; echo "ADDED    $rel"; added=$((added + 1))
        elif cmp -s "$f" "$target"; then
          same=$((same + 1))
        else
          mkdir -p "$(dirname "$backup/$rel")"; mv "$target" "$backup/$rel"; cp -p "$f" "$target"
          echo "REPLACED $rel"; replaced=$((replaced + 1))
        fi ;;
      pv_work/PVTools.lean)
        if [[ -e "$target" ]] && ! cmp -s "$f" "$target"; then
          echo "WARNING  pv_work/PVTools.lean differs from this kit's version and was NOT replaced: the audit tool"
          echo "         is locked by the sha256 recorded at /pv-setup. Replacing it is a separate decision (the kit's docs/MANUAL.md, section 6)."
        fi ;;
      *)
        if [[ ! -e "$target" ]]; then
          mkdir -p "$(dirname "$target")"; cp -p "$f" "$target"; echo "ADDED    $rel"; added=$((added + 1))
        else
          kept=$((kept + 1))
        fi ;;
    esac
  done < <(find "$SRC" -type f -not -name '.DS_Store' -not -name '*.pyc' -not -path '*/__pycache__/*' -print0)
  chmod +x "$dest/scripts/"*.sh "$dest/scripts/"*.py 2>/dev/null || true
  echo "kit files: replaced $replaced, added $added, unchanged $same; project files left as they are: $kept"
  [[ $replaced -gt 0 ]] && echo "old versions of the replaced files: kit_backup/$stamp/"
  if [[ -f "$dest/.claude/settings.json" ]]; then
    echo "Your .claude/settings.json was NOT changed. Compared with this kit version's suggestions:"
    python3 "$dest/scripts/pv_settings.py" check --root "$dest" | sed 's/^/  /' || true
  fi
  printf '\n## Kit upgrade — %s\n- %s -> %s with install.sh --upgrade; replaced files are in kit_backup/%s/. Verdicts recorded before this date were produced with the earlier kit.\n' \
    "$(date '+%Y-%m-%d %H:%M')" "$old_ver" "$new_ver" "$stamp" >> "$dest/verification/AUDIT.md"
  (cd "$dest" && python3 scripts/pv_status.py validate) || echo "validate is not VALID: see the messages above before continuing"
  [[ -f "$dest/scripts/pv_cards_check.py" ]] && (cd "$dest" && python3 scripts/pv_cards_check.py | tail -1)
  echo
  echo "Done. Close any Claude Code session running in this project, open it again, and type /pv-resume."
  exit 0
fi

mkdir -p "$dest"
dest="$(cd "$dest" && pwd)"
copied=0; skipped=0
while IFS= read -r -d '' f; do
  rel="${f#$SRC/}"
  target="$dest/$rel"
  if [[ -e "$target" ]]; then
    echo "SKIP (exists): $rel"; skipped=$((skipped + 1)); continue
  fi
  mkdir -p "$(dirname "$target")"
  cp -p "$f" "$target"
  copied=$((copied + 1))
done < <(find "$SRC" -type f -not -name '.DS_Store' -not -name '*.pyc' -not -path '*/__pycache__/*' -print0)
chmod +x "$dest/scripts/"*.sh "$dest/scripts/"*.py 2>/dev/null || true
fresh_settings=0
cmp -s "$SRC/.claude/settings.example.json" "$dest/.claude/settings.example.json" && fresh_settings=1
echo "kit files: copied $copied, skipped $skipped (existing files were left untouched)"

write_lakefile() {  # $1 = mathlib rev
  if [[ -e "$dest/lakefile.toml" || -e "$dest/lakefile.lean" ]]; then
    echo "SKIP (exists): lakefile"
  else
    cat > "$dest/lakefile.toml" <<LAKE
name = "proofcheck"
version = "0.1.0"

[[require]]
name = "mathlib"
git = "https://github.com/leanprover-community/mathlib4.git"
rev = "$1"
LAKE
    echo "wrote lakefile.toml (mathlib rev $1)"
  fi
}
copy_pin() {  # $1 = source dir, $2 = file name
  if [[ -e "$dest/$2" ]]; then echo "SKIP (exists): $2"; else cp "$1/$2" "$dest/$2"; echo "copied $2"; fi
}
mathlib_rev() {
  python3 -c "import json,sys; m=json.load(open(sys.argv[1])); print(next(p['rev'] for p in m['packages'] if p['name']=='mathlib'))" "$1"
}

if [[ $pinned -eq 1 ]]; then
  copy_pin "$KIT/lean-pins" lean-toolchain
  copy_pin "$KIT/lean-pins" lake-manifest.json
  write_lakefile "$(mathlib_rev "$KIT/lean-pins/lake-manifest.json")"
  echo
  echo "Next, inside $dest (needs internet; downloads a few GB once):"
  echo "    lake exe cache get"
  echo "    scripts/pv_lean.sh build PVTools      # must end with exit=0"
fi

if [[ -n "$lean_from" ]]; then
  lean_from="$(cd "$lean_from" && pwd)"
  copy_pin "$lean_from" lean-toolchain
  copy_pin "$lean_from" lake-manifest.json
  write_lakefile "$(mathlib_rev "$lean_from/lake-manifest.json")"
  mkdir -p "$dest/.lake"
  if [[ -e "$dest/.lake/packages" ]]; then
    echo "SKIP (exists): .lake/packages"
  elif [[ $link_pkgs -eq 1 ]]; then
    ln -s "$lean_from/.lake/packages" "$dest/.lake/packages"; echo "linked .lake/packages -> $lean_from/.lake/packages"
    echo "NOTE: packages are shared with $lean_from; the kit will not run 'lake build' on mathlib."
  else
    echo "copying packages (several GB; this can take a few minutes) ..."; cp -R "$lean_from/.lake/packages" "$dest/.lake/packages"
    echo "copied .lake/packages"
  fi
  (cd "$dest" && scripts/pv_lean.sh packages) || true
  echo
  echo "Checking the Lean environment (building PVTools) ..."
  (cd "$dest" && scripts/pv_lean.sh build PVTools) || { echo "PVTools build failed; see the log above and docs/MANUAL.md"; exit 1; }
fi

# v1.3.1: the suggested permission file lists this project's absolute paths (agents write commands both ways) and,
# for linked Lean packages, read access to them (written after the packages are in place)
if [[ $fresh_settings -eq 1 ]]; then
  python3 "$dest/scripts/pv_settings.py" expand --root "$dest" > /dev/null
fi

echo
echo "Done. Next steps:"
echo "  1. Put the paper's LaTeX (and the compiled PDF or .aux if available) into $dest/source/"
echo "  2. (Recommended for unattended runs) read the kit's docs/MANUAL.md, section 2, step 4 and, if you agree, run:"
echo "       cp .claude/settings.example.json .claude/settings.json"
echo "  3. Open $dest in Claude Code (desktop Code tab, or 'claude' in a terminal)"
echo "  4. Type: /pv-setup source/<main>.tex"

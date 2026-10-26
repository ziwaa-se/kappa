#!/usr/bin/env bash
# replicate.sh: reproduces the results of "KAPPA: Checking the Proofs in Statistics Papers with Lean 4 and
# Language Model Agents" (She and Wang) from the archived run records, without a language model.
#
# Usage, from the folder that contains this script:
#   ./replicate.sh                      tables only, a few seconds
#   ./replicate.sh --replay <lean-env>  also rebuild every archived Lean file at the pinned versions and rerun the
#                                       mechanical audits (under an hour on an Apple M4)
#
# <lean-env> is a Lean 4.19.0 + Mathlib c44e0c8e environment, made once with the kit's
#   autosetup/lean_env.sh <base> --download        (downloads Lean and the compiled Mathlib, about 5 GB)
# which creates <base>/lean-env. Set KIT=<folder> to use another copy of the kit than the one in ../software.
#
# Output: the regenerated tables on standard output (compare with TABLES.md and with the paper), one
# replay_<case>.md per run in ./output/, and the versions of the tools at the end. The run of this script for the
# paper is in replication_output.log.
set -uo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cd "$here"
replay=""; lean=""
if [[ "${1:-}" == "--replay" ]]; then replay=1; lean="$(cd "${2:?usage: ./replicate.sh --replay <lean-env>}" && pwd)"; fi
mkdir -p output

# 1. The kit: the released version 1.4.0 shipped in ../software (the runs themselves used version 1.3.1). Run from
#    the kit's own repository, where this folder is replication/, the script uses the repository itself.
if [[ -z "${KIT:-}" ]]; then
  tarball="$here/../software/kappa-1.4.0.tar.gz"
  if [[ -f "$tarball" ]]; then
    tar -xzf "$tarball" -C output
    KIT="$here/output/kappa-1.4.0"
  elif [[ -f "$here/../install.sh" && -d "$here/../template" ]]; then
    KIT="$(cd "$here/.." && pwd)"
  else
    echo "missing $tarball (or set KIT=<kit folder>)"; exit 2
  fi
fi
echo "kit: ${KIT#"$here"/}"

# 2. Tables of results (paper, Sections 6 and 7): score against the answer key, cost reported by Claude Code,
#    active running time and fact-check counts, by case and round. Compare with TABLES.md.
echo; echo "== Results by case and round (Tables 8-11 and the figures in the text)"
python3 tools/make_tables.py records --kit "$KIT" | tee output/TABLES.md
if diff -q TABLES.md output/TABLES.md > /dev/null; then echo "identical to TABLES.md"; else echo "DIFFERS from TABLES.md"; fi

# 3. Per-result scores of the first round of every case (the rows of Tables 8-11).
for c in records/*/; do
  n=$(basename "$c")
  [[ -f "$c/answer_key.json" ]] || continue
  snap=$(ls -d "$c"results/verification/snapshots/*before-revision* 2>/dev/null | head -1)
  target="${snap:-${c}results}"
  echo; echo "== $n, first round"
  python3 "$KIT/examples/tools/score.py" "$target" "$c/answer_key.json"
done

# 4. The comparison with a direct use of the model (Table 12): the graded summary, from comparison/grading/.
echo; echo "== Comparison (Table 12), from the gradings"
sed -n '/^| Paper/,/^| \*\*Total/p' comparison/SUMMARY.md

# 5. Offline replay (optional): rebuild every run's Lean files at the pinned versions, rerun the mechanical audits,
#    and recompile the Lean code of the two baseline arms.
if [[ -n "$replay" ]]; then
  echo; echo "== Offline replay of the seven cases"
  (cd output && "$here/tools/replay_all.sh" "$KIT" "$lean" "$here/records")
  echo; echo "== Lean files of the comparison runs (compiled, sorry, axioms)"
  for d in comparison/runs/*/; do
    printf "%-14s " "$(basename "$d")"
    python3 tools/grade_lean.py "$d" --lean-env "$lean" 2>&1 | tail -1
  done
fi

# 6. Versions.
echo; echo "== Versions"
date; uname -srm; python3 --version
if [[ -n "$lean" ]]; then (cd "$lean" && lake env lean --version && lake --version); fi

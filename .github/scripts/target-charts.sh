#!/usr/bin/env bash
# Decides which charts a pipeline run acts on. Terms are defined in GLOSSARY.md.
#
# Usage:
#   target-charts.sh <comparison-base>   charts changed between the merge-base of <comparison-base> and HEAD
#   target-charts.sh --all               every chart is targeted, none is changed (manual full run)
#
# Prints in GITHUB_OUTPUT format the resolved comparison base and three JSON arrays:
#   comparison_base  commit the changed charts were measured against, empty with --all
#   changed_charts   charts that still exist and have a file differing from the comparison base
#   lock_charts      changed charts whose Chart.yaml changed and that have a Chart.lock
#   targeted_charts  the changed charts, or every chart when a shared input changed
set -euo pipefail

# Files outside the chart directories that influence the result for every chart.
shared_inputs=(
  kubeconform-values.yaml
  create-trigy-ignore.sh
  README.md.gotmpl
  .github/workflows
  .github/scripts
)

cd "$(git rev-parse --show-toplevel)"

to_json() {
  local out="" item
  for item in "$@"; do
    out+="${out:+,}\"${item}\""
  done
  echo "[${out}]"
}

all_charts() {
  local dir
  for dir in charts/*/; do
    [ -f "${dir}Chart.yaml" ] && basename "$dir"
  done
  return 0
}

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <comparison-base> | --all" >&2
  exit 2
fi

base=""
changed=()
lock=()
targeted=()

if [ "$1" = "--all" ]; then
  mapfile -t targeted < <(all_charts)
else
  base=$(git merge-base "$1" HEAD)

  # --no-renames: a file moved between charts must count for both charts.
  changed_files=$(git diff --no-renames --name-only "$base" HEAD -- charts)

  while read -r chart; do
    [ -f "charts/${chart}/Chart.yaml" ] && changed+=("$chart")
  done < <(awk -F/ 'NF > 2 { print $2 }' <<< "$changed_files" | sort -u)

  for chart in "${changed[@]}"; do
    if [ -f "charts/${chart}/Chart.lock" ] \
      && ! git diff --no-renames --quiet "$base" HEAD -- "charts/${chart}/Chart.yaml"; then
      lock+=("$chart")
    fi
  done

  if git diff --no-renames --quiet "$base" HEAD -- "${shared_inputs[@]}"; then
    targeted=("${changed[@]}")
  else
    mapfile -t targeted < <(all_charts)
  fi
fi

echo "comparison_base=${base}"
echo "changed_charts=$(to_json "${changed[@]}")"
echo "lock_charts=$(to_json "${lock[@]}")"
echo "targeted_charts=$(to_json "${targeted[@]}")"

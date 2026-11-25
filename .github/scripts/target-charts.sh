#!/usr/bin/env bash
# Decides which charts a pipeline run acts on. Terms are defined in GLOSSARY.md.
#
# Usage:
#   target-charts.sh <comparison-base>   charts changed between the merge-base of <comparison-base> and HEAD
#   target-charts.sh --all               every chart is targeted, none is changed (manual full run)
#
# Prints in GITHUB_OUTPUT format the resolved comparison base and four JSON arrays:
#   comparison_base    commit the changed charts were measured against, empty with --all
#   changed_charts     charts that still exist and have a file differing from the comparison base
#   lock_check_charts  changed charts whose Chart.yaml changed and that have a Chart.lock
#   targeted_charts    the changed charts, or every chart when a shared input changed
#   readme_charts      the changed charts, or every chart when a README input changed
set -euo pipefail

# Files outside the chart directories that influence the result for every chart.
shared_inputs=(
  kubeconform-values.yaml
  create-trigy-ignore.sh
  README.md.gotmpl
  .github/workflows
  .github/scripts
)

# Files outside the chart directories that influence every chart's generated README.
readme_inputs=(
  README.md.gotmpl
  .github/workflows/update_documentation.yaml
)

cd "$(git rev-parse --show-toplevel)"

to_json() {
  if [ "$#" -eq 0 ]; then
    echo "[]"
  else
    printf '%s\n' "$@" | jq -R . | jq -sc .
  fi
}

# Usage: diff_since_comparison_base <git-diff-option> <path>...
# --no-renames: a file moved between charts must count for both charts.
diff_since_comparison_base() {
  local option=$1
  shift
  git diff --no-renames "$option" "$comparison_base" HEAD -- "$@"
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

comparison_base=""
changed_charts=()
lock_check_charts=()
targeted_charts=()
readme_charts=()

if [ "$1" = "--all" ]; then
  mapfile -t targeted_charts < <(all_charts)
  readme_charts=("${targeted_charts[@]}")
else
  comparison_base=$(git merge-base "$1" HEAD)

  changed_files=$(diff_since_comparison_base --name-only charts)

  while read -r chart; do
    [ -f "charts/${chart}/Chart.yaml" ] && changed_charts+=("$chart")
  done < <(awk -F/ 'NF > 2 { print $2 }' <<< "$changed_files" | sort -u)

  for chart in "${changed_charts[@]}"; do
    if [ -f "charts/${chart}/Chart.lock" ] \
      && ! diff_since_comparison_base --quiet "charts/${chart}/Chart.yaml"; then
      lock_check_charts+=("$chart")
    fi
  done

  if diff_since_comparison_base --quiet "${shared_inputs[@]}"; then
    targeted_charts=("${changed_charts[@]}")
  else
    mapfile -t targeted_charts < <(all_charts)
  fi

  if diff_since_comparison_base --quiet "${readme_inputs[@]}"; then
    readme_charts=("${changed_charts[@]}")
  else
    mapfile -t readme_charts < <(all_charts)
  fi
fi

echo "comparison_base=${comparison_base}"
echo "changed_charts=$(to_json "${changed_charts[@]}")"
echo "lock_check_charts=$(to_json "${lock_check_charts[@]}")"
echo "targeted_charts=$(to_json "${targeted_charts[@]}")"
echo "readme_charts=$(to_json "${readme_charts[@]}")"

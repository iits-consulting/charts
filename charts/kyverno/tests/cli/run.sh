#!/usr/bin/env bash
# Renders all fixtures, then runs every kyverno-test.yaml below this directory
set -euo pipefail
cd "$(dirname "$0")"
./render.sh

# The CLI silently ignores a result whose resource is not loaded, so check that here.
missing=0
for test in */kyverno-test.yaml; do
  dir=$(dirname "$test")
  loaded=$(yq '.resources[]' "$test" | while read -r f; do
    yq ea 'select(.metadata.name) | .metadata.name, (.metadata.namespace // "default") + "/" + .metadata.name' "$dir/$f"
  done | sort -u)
  for r in $(yq '.results[].resources[]' "$test" | sort -u); do
    if ! grep -qxF "$r" <<<"$loaded"; then
      echo "$test: result resource '$r' is not in the loaded resources" >&2
      missing=1
    fi
  done
done
[ "$missing" -eq 0 ] || exit 1

kyverno test . "$@"

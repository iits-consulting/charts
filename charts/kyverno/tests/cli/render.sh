#!/usr/bin/env bash
# Renders the chart once per fixture (<fixture>/values.yaml) into .rendered/<fixture>/<policy name>.yaml
set -euo pipefail
cd "$(dirname "$0")"
out=.rendered
rm -rf "$out"
for values in */values.yaml; do
  fixture=$(dirname "$values")
  mkdir -p "$out/$fixture"
  helm template kyv ../.. -n kyverno -f "$values" > "$out/$fixture.all.yaml"
  # One file per policy: the CLI cannot load a file that also holds a Secret
  (cd "$out/$fixture" && yq -s '.metadata.name + ".yaml"' \
    'select(.apiVersion == "policies.kyverno.io/v1" and .kind == "*Policy")' "../$fixture.all.yaml")
  rm "$out/$fixture.all.yaml"
done
echo "rendered to $out"

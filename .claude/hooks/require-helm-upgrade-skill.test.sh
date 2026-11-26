#!/usr/bin/env bash
# Self-check for require-helm-upgrade-skill.py. Run from the repo root.
set -u
H=.claude/hooks/require-helm-upgrade-skill.py
C=$(grep -l '^dependencies:' charts/*/Chart.yaml | head -1)
V=$(grep -m1 -A3 '^dependencies:' "$C" | grep -m1 'version:')
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
echo '{}' > "$T/empty.jsonl"
echo '{"message":{"content":[{"type":"tool_use","name":"Skill","input":{"skill":"helm-chart-upgrade"}}]}}' > "$T/loaded.jsonl"
fail=0

check() { # expected tool_name tool_input_json transcript
  got=$(python3 -c 'import json,sys;print(json.dumps({"tool_name":sys.argv[1],"tool_input":json.loads(sys.argv[2]),"transcript_path":sys.argv[3]}))' "$2" "$3" "$4" | python3 "$H" 2>/dev/null; echo $?)
  [ "$got" = "$1" ] && echo "ok   $5" || { echo "FAIL $5 (got $got, want $1)"; fail=1; }
}
j() { python3 -c 'import json,sys;print(json.dumps(dict(zip(sys.argv[1::2],sys.argv[2::2]))))' "$@"; }

check 2 Bash "$(j command 'helm dependency update charts/x')" "$T/empty.jsonl" "bash dep update without skill"
check 2 Bash "$(j command 'cd charts/x && helm dep up .')" "$T/empty.jsonl" "bash dep up after &&"
check 0 Bash "$(j command 'helm dep up .')" "$T/loaded.jsonl" "bash dep up with skill"
check 0 Bash "$(j command 'helm dependency build .')" "$T/empty.jsonl" "bash dep build"
check 0 Bash "$(j command 'echo "helm dependency update"')" "$T/empty.jsonl" "phrase inside a string"
check 2 Edit "$(j file_path "$PWD/$C" old_string "$V" new_string "${V%%version:*}version: 99.9.9")" "$T/empty.jsonl" "edit dependency version"
check 0 Edit "$(j file_path "$PWD/$C" old_string 'apiVersion: v2' new_string 'apiVersion: v2 ')" "$T/empty.jsonl" "edit outside dependencies"
check 0 Edit "$(j file_path "$PWD/charts/kumoops-admin-dashboard/Chart.yaml" old_string 'apiVersion: v2' new_string 'apiVersion: v2 ')" "$T/empty.jsonl" "chart without dependencies"
exit $fail

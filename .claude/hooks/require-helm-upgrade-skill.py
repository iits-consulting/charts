#!/usr/bin/env python3
"""PreToolUse hook: block Helm dependency bumps until the helm-chart-upgrade skill is loaded.

Triggers on
  - Bash: `helm dependency update` / `helm dep up`
  - Edit/MultiEdit/Write on a Chart.yaml whose `dependencies:` block changes

Exit 2 blocks the tool call and shows stderr to the agent.
ponytail: shell edits of Chart.yaml (sed, yq) slip through, add a Bash pattern if that happens.
"""
import json
import os
import re
import sys

SKILL = "helm-chart-upgrade"


def deps_block(text):
    """Text of the top-level `dependencies:` block, or '' if there is none."""
    m = re.search(r"^dependencies:.*?(?=^\S(?!-)|\Z)", text, re.M | re.S)
    return m.group(0).strip() if m else ""


def new_content(tool, inp, old):
    if tool == "Write":
        return inp.get("content", "")
    edits = inp.get("edits") or [inp]
    for e in edits:
        a, b = e.get("old_string", ""), e.get("new_string", "")
        old = old.replace(a, b) if e.get("replace_all") else old.replace(a, b, 1)
    return old


def is_bump(tool, inp):
    if tool == "Bash":
        # helm must be the command itself (line start or after ; & | ( ), not text inside a string
        cmd = r"(?:^|[;&|(])\s*(?:\S*/)?helm\s+dep(?:endency|endencies)?\s+up(?:date)?\b"
        return re.search(cmd, inp.get("command", ""), re.M) is not None
    path = inp.get("file_path", "")
    if tool not in ("Edit", "MultiEdit", "Write") or os.path.basename(path) != "Chart.yaml":
        return False
    try:
        with open(path) as f:
            old = f.read()
    except OSError:
        old = ""
    return deps_block(old) != deps_block(new_content(tool, inp, old))


def skill_loaded(transcript):
    try:
        with open(transcript) as f:
            for line in f:
                if SKILL not in line:
                    continue
                if f"<command-name>/{SKILL}</command-name>" in line:
                    return True
                msg = json.loads(line).get("message") or {}
                content = msg.get("content")
                for c in content if isinstance(content, list) else []:
                    if c.get("type") == "tool_use" and c.get("name") == "Skill" \
                            and str(c.get("input", {}).get("skill", "")).endswith(SKILL):
                        return True
    except (OSError, ValueError):
        pass
    return False


def main():
    data = json.load(sys.stdin)
    if not is_bump(data.get("tool_name", ""), data.get("tool_input") or {}):
        return 0
    if skill_loaded(data.get("transcript_path", "")):
        return 0
    print(
        f"Blocked: this is a Helm chart dependency upgrade. Load the `{SKILL}` skill "
        f"(Skill tool, skill: \"{SKILL}\") and follow its procedure before bumping versions.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())

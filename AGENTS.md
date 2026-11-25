# Project Overview

This charts project is about wrapper charts being used. These are needed due to specific requirements of the "T Cloud Public" (former Open Telekom Cloud) or our own preferences.

## Stack
- Helm

## Architecture notes
- Every folder in the charts directory is an independent helm chart, unless otherwise stated in the dependencies of each chart
- Charts can rely on other dependencies to form an umbrella chart (e.g. kyverno wraps kyverno and provides some common policies)

## Commands
- helm lint
- helm template
- kubeconform

## Code style
- helm best practices - https://helm.sh/docs/chart_best_practices/

## Workflow
- Always lint and template before completing changes

## Agent skills

### Issue tracker

Issues and specs live as local markdown files under `.scratch/<feature-slug>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`, recorded as a `Status:` line in each issue file. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.

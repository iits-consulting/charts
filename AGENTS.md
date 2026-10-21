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

# Project Overview

This charts project is about wrapper charts being used. These are needed due to specific requirements of the "T Cloud Public" (former Open Telekom Cloud) or our own preferences.

## Stack
- Helm

## Architecture notes
- Every chart in the charts directory is independent of others
- In general each chart relies on other dependencies and is an umbrella chart (few exceptions possible)

## Commands
- helm lint
- helm template
- kubeconform

## Code style
- helm best practices - https://helm.sh/docs/chart_best_practices/

## Workflow
- Always lint and template before completing changes

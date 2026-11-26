# Changelog

All notable changes to this chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [92.9.1] - 2026-11-26

### Fixed
- Remove the leftover Alertmanager route for the deleted `ContainerRestartDetected` alert

## [92.9.0] - 2026-10-21

⚠️ The prometheus-operator CRDs (`v0.93.0` → `v0.94.1`) must be applied manually **before** the chart is rolled out. See [UPGRADE.md](./UPGRADE.md) for the upgrade procedure.

### Changed
- Increase version of `kube-prometheus-stack` to 92.9.0 (Prometheus v3.13.2 → v3.15.0, Alertmanager v0.33.1 → v0.34.1, prometheus-operator v0.93.0 → v0.94.1, Grafana 13.1.3 → 13.2.4)
- Increase version of `prometheus-blackbox-exporter` to 11.20.0 (Blackbox Exporter v0.28.0 → v0.29.0)
- Increase version of `common` to 0.4.0; the rendered ExternalSecret/PushSecret resources are unchanged for the pull-secret setup documented in this chart's values
- Rebased the vendored `kubernetes-resources` rules

### Removed
- Default alert rule for container restarts (`ContainerRestartDetected`)

## [88.3.0] - 2026-09-04

⚠️ The prometheus-operator CRDs (`v0.86.2` → `v0.93.0`) must be applied manually **before** the chart is rolled out. See [UPGRADE.md](./UPGRADE.md).

### Changed
- Increase version of `kube-prometheus-stack` to 88.3.0, which contains the Grafana major update to 13.1.3
- Increase version of `prometheus-blackbox-exporter` to 11.17.2

## [79.12.0] - 2026-07-03

### Changed
- Increase version of `kube-prometheus-stack` to 79.12.0
- Container restart alert now fires only above 4 restarts (`> 4`)

## [79.11.0] - 2026-06-23

### Added
- Default alert rules for container exits

### Changed
- Update `kube-prometheus-stack` dependency chart

## [79.9.0] - 2026-04-27

### Added
- `common` chart library as dependency chart
- Custom ConfigMap template for the Blackbox Exporter config via External Secrets, when enabled

### Changed
- Prometheus also picks up `PrometheusRule` CRs outside of this deployment
- Increase version of `kube-prometheus-stack` to 79.9.0

## [79.8.2] - 2025-12-08

⚠️ Depending on the version you upgrade from, the `KubeAPIErrorBudgetBurn` alert might fire. This is a false positive caused by a [Prometheus bug](https://github.com/prometheus-community/helm-charts/issues/5274), since the underlying metric format changed. Either silence the alert for 30d or drop the old data via the Prometheus admin API.

### Changed
- Increase version of `kube-prometheus-stack` to 79.8.2
- Increase version of `prometheus-blackbox-exporter` to 11.5.0

[92.9.1]: https://github.com/iits-consulting/charts/compare/prometheus-stack-92.9.0...prometheus-stack-92.9.1
[92.9.0]: https://github.com/iits-consulting/charts/compare/prometheus-stack-88.3.0...prometheus-stack-92.9.0
[88.3.0]: https://github.com/iits-consulting/charts/compare/prometheus-stack-79.12.0...prometheus-stack-88.3.0
[79.12.0]: https://github.com/iits-consulting/charts/compare/prometheus-stack-79.11.0...prometheus-stack-79.12.0
[79.11.0]: https://github.com/iits-consulting/charts/compare/prometheus-stack-79.10.0...prometheus-stack-79.11.0
[79.9.0]: https://github.com/iits-consulting/charts/compare/prometheus-stack-79.8.2...prometheus-stack-79.9.0
[79.8.2]: https://github.com/iits-consulting/charts/releases/tag/prometheus-stack-79.8.2

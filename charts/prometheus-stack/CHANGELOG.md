# Changelog

All notable changes to this chart are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [93.0.0] - 2026-11-10

> Breaking change, requires the Kyverno chart 4.0.0 or newer (CEL policies).

### Added

- `policyException.namespace`: namespace of the PolicyException, defaults to the release namespace. Kyverno must read exceptions from it (`kyverno.features.policyExceptions.namespace`)
- `policyException.labels` and `policyException.annotations`: labels and annotations of the PolicyException; annotations are merged with the defaults from `values.yaml`

### Changed

- **Breaking:** the PolicyException is now a `policies.kyverno.io/v1` PolicyException (CEL). `kyverno.io/v2` exceptions do not apply to CEL policies. It is created in the release namespace unless `policyException.namespace` is set

## [92.9.0] - 2026-10-21

> The prometheus-operator CRDs (`v0.93.0` → `v0.94.1`) must be applied manually **before** the chart is rolled out, see [UPGRADE.md](./UPGRADE.md)

### Changed

- Increase version of `kube-prometheus-stack` to 92.9.0 (Prometheus v3.13.2 → v3.15.0, Alertmanager v0.33.1 → v0.34.1, prometheus-operator v0.93.0 → v0.94.1, Grafana 13.1.3 → 13.2.4)
- Increase version of `prometheus-blackbox-exporter` to 11.20.0 (Blackbox Exporter v0.28.0 → v0.29.0)
- Increase version of `common` to 0.4.0, the rendered ExternalSecret/PushSecret resources are unchanged for the pull-secret setup documented in this chart's values
- Rebased the vendored `kubernetes-resources` rules

### Removed

- Default alertrule for container restarts

## [88.3.0] - 2026-09-04

> The prometheus-operator CRDs (`v0.86.2` → `v0.93.0`) must be applied manually **before** the chart is rolled out, see [UPGRADE.md](./UPGRADE.md)

### Changed

- Increase version of `kube-prometheus-stack` to 88.3.0, contains the Grafana major update to 13.1.3
- Increase version of `prometheus-blackbox-exporter` to 11.17.2

## [79.12.0] - 2026-07-03

### Changed

- Increase version of `kube-prometheus-stack` to 79.12.0
- Increase container restart report firing to >4

## [79.11.0] - 2026-06-23

### Added

- Default alert rules for container exits

### Changed

- Update prometheus-stack dependency chart

## [79.9.0] - 2026-04-27

### Added

- Common chart lib as dependency chart
- Custom configMap template for the Blackbox Exporter config via External Secrets, when enabled

### Changed

- Prometheus also picks up `PrometheusRule` CRs outside of this deployment
- Increase version of `kube-prometheus-stack` to 79.9.0

## [79.8.2] - 2025-12-08

### Changed

- Update kube-prometheus-stack to 79.8.2
- Update blackbox exporter to 11.5.0
- Depending on where you upgrade from, the alert `KubeAPIErrorBudgetBurn` may trigger. This is a false positive, because of a [bug from prometheus](https://github.com/issues/created?issue=prometheus-community%7Chelm-charts%7C5274) since the underlying metric format changed. Either silence the alert for 30d or drop old data via the prometheus admin api

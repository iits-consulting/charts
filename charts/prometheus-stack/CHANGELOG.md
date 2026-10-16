# Changelog

## Chart Versions

### 92.9.0
- Increase version of `kube-prometheus-stack` to 92.9.0 (Prometheus v3.13.2 → v3.15.0, Alertmanager v0.33.1 → v0.34.1, prometheus-operator v0.93.0 → v0.94.1, Grafana 13.1.3 → 13.2.4)
- Increase version of `prometheus-blackbox-exporter` to 11.20.0 (Blackbox Exporter v0.28.0 → v0.29.0)
- Increase version of `common` to 0.4.0; the rendered ExternalSecret/PushSecret resources are unchanged for the pull-secret setup documented in this chart's values
- ⚠️ The prometheus-operator CRDs (`v0.93.0` → `v0.94.1`) must be applied manually **before** the chart is rolled out, see [UPGRADE.md](./UPGRADE.md)
- Rebased the vendored `kubernetes-resources` rules
- 📖 See [UPGRADE.md](./UPGRADE.md) for the upgrade procedure

### 88.3.0
- Increase version of `kube-prometheus-stack` to 88.3.0
- Increase version of `prometheus-blackbox-exporter` to 11.17.2
- ⚠️ The prometheus-operator CRDs (`v0.86.2` → `v0.93.0`) must be applied manually **before** the chart is rolled out, see [UPGRADE.md](./UPGRADE.md)
- Contains Grafana major update to 13.1.3

### 79.12.0
- Increase version of `kube-prometheus-stack` to 79.12.0
- Increase container restart report firing to >4

### 79.11.0

- Add default alert rules for container exits
- Update prometheus-stack dependency chart

### 79.9.0

- Make Prometheus pick also pick up `PrometheusRule` CRs outside of this deployment
- Increase version of `kube-prometheus-stack` to 79.9.0
- Added common chart lib as dependency chart
- Adds custom configMap template for Blackbox Exporter config via External Secrets, when enabled

### 79.8.2
- Updates kube-prometheus-stack to 79.8.2
- Updates blackbox exporter to 11.5.0
- ⚠️ Depending on from where you upgrade, you might encounter that an alert (KubeAPIErrorBudgetBurn) is triggered. This is a false positive, because of a [bug from prometheus](https://github.com/issues/created?issue=prometheus-community%7Chelm-charts%7C5274) since the underlying metric format changed. You can either silence the alert for 30d or drop old data via the prometheus admin api.


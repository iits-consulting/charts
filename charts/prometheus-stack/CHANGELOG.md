# Changelog

## Chart Versions

### 79.13.0
- Introduce `.Values.dashboards.include` to define subfolders in dashboards/ to render Grafana Dashboard resources for 

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


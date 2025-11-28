# Changelog

## Chart Versions

### 79.8.2
- Updates kube-prometheus-stack to 79.8.2
- Updates blackbox exporter to 11.5.0
- ⚠️ Depending on from where you upgrade, you might encounter that an alert (KubeAPIErrorBudgetBurn) is triggered. This is a false positive, because of a [bug from prometheus](https://github.com/issues/created?issue=prometheus-community%7Chelm-charts%7C5274) since the underlying metric format changed. You can either silence the alert for 30d or drop old data via the prometheus admin api.


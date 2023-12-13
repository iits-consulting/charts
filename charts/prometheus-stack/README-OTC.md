# Usage inside infrastructure-charts

```yaml
prometheus-stack:
  namespace: monitoring
  repoURL: "https://charts.iits.tech"
  targetRevision: "43.2.0"
  ignoreDifferences:
    - jsonPointers:
        - /imagePullSecrets
      kind: ServiceAccount
  syncOptions:
    - ServerSideApply=true
  parameters:
    global.alertmanager.host: "admin.{{.Values.projectValues.rootDomain}}"
    global.prometheus.host: "admin.{{.Values.projectValues.rootDomain}}"
    global.grafana.host: "admin.{{.Values.projectValues.rootDomain}}"
    prometheusStack.grafana.grafana\\.ini.server.security.admin_password: "REPLACE_ME"
```
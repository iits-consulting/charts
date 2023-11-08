# Usage inside infrastructure-charts

```yaml
prometheus-stack:
  namespace: monitoring
  repoURL: "https://charts.iits.tech"
  targetRevision: "43.1.3-no-default-storage"
  valueFile: "value-files/prometheus-stack/values.yaml"
  syncOptions:
    - ServerSideApply=true
  ignoreDifferences:
    - jsonPointers:
        - /imagePullSecrets
      kind: ServiceAccount
```

values.yaml
```yaml
prometheusStack:
  prometheus:
    prometheusSpec:
      externalUrl: https://admin.{{.Values.projectValues.rootDomain}}/prometheus
      serviceMonitorSelectorNilUsesHelmValues: false
  grafana:
    grafana.ini:
      server:
        root_url: https://admin.{{.Values.projectValues.rootDomain}}/grafana
  alertmanager:
#    config:
#      global:
#        slack_api_url: "REPLACE_ME"
```
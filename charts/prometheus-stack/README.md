# prometheus-stack

![Version: 62.6.0](https://img.shields.io/badge/Version-62.6.0-informational?style=flat-square)

A complete monitoring/alerting stack with Grafana Prometheus Alertmanager

## Installing the Chart with iits ArgoCD

```yaml
prometheus-stack:
  namespace: monitoring
  repoURL: "https://charts.iits.tech"
  targetRevision: "62.6.0"
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
    prometheusStack.grafana.adminPassword: "REPLACE_ME"
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://prometheus-community.github.io/helm-charts | prometheusStack(kube-prometheus-stack) | 62.6.0 |
| https://prometheus-community.github.io/helm-charts | blackboxExporter(prometheus-blackbox-exporter) | 9.4.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| blackboxExporter.config.modules.dns_baseline.dns.preferred_ip_protocol | string | `"ip4"` |  |
| blackboxExporter.config.modules.dns_baseline.dns.query_name | string | `"google.com"` |  |
| blackboxExporter.config.modules.dns_baseline.dns.query_type | string | `"A"` |  |
| blackboxExporter.config.modules.dns_baseline.dns.valid_rcodes[0] | string | `"NOERROR"` |  |
| blackboxExporter.config.modules.dns_baseline.prober | string | `"dns"` |  |
| blackboxExporter.config.modules.dns_baseline.timeout | string | `"5s"` |  |
| blackboxExporter.config.modules.http_2xx.http.preferred_ip_protocol | string | `"ip4"` |  |
| blackboxExporter.config.modules.http_2xx.http.valid_http_versions[0] | string | `"HTTP/1.1"` |  |
| blackboxExporter.config.modules.http_2xx.http.valid_http_versions[1] | string | `"HTTP/2.0"` |  |
| blackboxExporter.config.modules.http_2xx.http.valid_status_codes | list | `[]` |  |
| blackboxExporter.config.modules.http_2xx.prober | string | `"http"` |  |
| blackboxExporter.config.modules.http_2xx.timeout | string | `"5s"` |  |
| blackboxExporter.enabled | bool | `true` |  |
| blackboxExporter.fullnameOverride | string | `"blackbox-exporter"` |  |
| blackboxExporter.secretConfig | bool | `true` |  |
| blackboxExporter.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| blackboxExporter.serviceMonitor.enabled | bool | `false` |  |
| blackboxExporter.serviceMonitor.selfMonitor.enabled | bool | `true` |  |
| blackboxExporter.serviceMonitor.targets | string | `nil` |  |
| dashboards.enabled | bool | `true` |  |
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd"` |  |
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| global.ingress.enabled | bool | `true` |  |
| global.ingress.host | string | `nil` |  |
| global.ingress.paths.alertmanager | string | `"/alertmanager"` |  |
| global.ingress.paths.grafana | string | `"/grafana"` |  |
| global.ingress.paths.prometheus | string | `"/prometheus"` |  |
| policyException.enabled | bool | `true` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].name | string | `"uptime-monitoring"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].alert | string | `"DecreasingUptime"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].annotations.description | string | `"Uptime of {{ $labels.instance }} less than 95%."` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].annotations.summary | string | `"{{ $labels.instance }} not reachable"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].expr | string | `"sum by (instance) (avg_over_time(probe_success[5m])) < 0.95\n"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].for | string | `"1m"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[0].labels.severity | string | `"high"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].alert | string | `"DecreasingUptime"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].annotations.description | string | `"Uptime of {{ $labels.instance }} less than 50%."` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].annotations.summary | string | `"{{ $labels.instance }} not reachable"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].expr | string | `"sum by (instance) (avg_over_time(probe_success[5m])) < 0.5\n"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].for | string | `"1m"` |  |
| prometheusStack.additionalPrometheusRulesMap.uptime-monitoring.groups[0].rules[1].labels.severity | string | `"critical"` |  |
| prometheusStack.alertmanager.alertmanagerSpec.externalUrl | string | `"https://{{$.Values.global.ingress.host}}{{$.Values.global.ingress.paths.alertmanager}}"` |  |
| prometheusStack.alertmanager.alertmanagerSpec.resources.requests.cpu | string | `"5m"` |  |
| prometheusStack.alertmanager.alertmanagerSpec.resources.requests.memory | string | `"100Mi"` |  |
| prometheusStack.alertmanager.alertmanagerSpec.routePrefix | string | `"/alertmanager"` |  |
| prometheusStack.alertmanager.config.global.resolve_timeout | string | `"5m"` |  |
| prometheusStack.alertmanager.config.global.slack_api_url | string | `"http://myhost.local"` |  |
| prometheusStack.alertmanager.config.receivers[0].name | string | `"null"` |  |
| prometheusStack.alertmanager.config.receivers[1].name | string | `"slack"` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].channel | string | `"infrastructure"` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].link_names | bool | `true` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].send_resolved | bool | `true` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].text | string | `"{{ range .Alerts }}\n  *Description:* {{ .Annotations.description }}\n  *Details:*\n  {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`\n  {{ end }}\n{{ end }}"` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].title | string | `"{{ (index .Alerts 0).GeneratorURL | reReplaceAll \"(.*)prometheus(.*)\" \"$1\"}}  {{ (index .Alerts 0).Annotations.summary}}"` |  |
| prometheusStack.alertmanager.config.receivers[1].slack_configs[0].title_link | string | `"{{ (index .Alerts 0).GeneratorURL }}"` |  |
| prometheusStack.alertmanager.config.route.group_by[0] | string | `"job"` |  |
| prometheusStack.alertmanager.config.route.group_interval | string | `"5m"` |  |
| prometheusStack.alertmanager.config.route.group_wait | string | `"30s"` |  |
| prometheusStack.alertmanager.config.route.repeat_interval | string | `"12h"` |  |
| prometheusStack.alertmanager.config.route.routes[0].match.alertname | string | `"Watchdog"` |  |
| prometheusStack.alertmanager.config.route.routes[0].receiver | string | `"null"` |  |
| prometheusStack.alertmanager.config.route.routes[1].continue | bool | `true` |  |
| prometheusStack.alertmanager.config.route.routes[1].receiver | string | `"slack"` |  |
| prometheusStack.alertmanager.config.templates[0] | string | `"/etc/alertmanager/config/*.tmpl"` |  |
| prometheusStack.crds.enabled | bool | `false` |  |
| prometheusStack.defaultRules.create | bool | `true` |  |
| prometheusStack.defaultRules.disabled.InfoInhibitor | bool | `true` |  |
| prometheusStack.defaultRules.disabled.KubeClientCertificateExpiration | bool | `true` |  |
| prometheusStack.defaultRules.disabled.KubeletDown | bool | `true` |  |
| prometheusStack.defaultRules.disabled.NodeClockNotSynchronising | bool | `true` |  |
| prometheusStack.defaultRules.rules.alertmanager | bool | `true` |  |
| prometheusStack.defaultRules.rules.etcd | bool | `true` |  |
| prometheusStack.defaultRules.rules.general | bool | `true` |  |
| prometheusStack.defaultRules.rules.k8s | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubeApiserver | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubeApiserverAvailability | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubeApiserverError | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubeApiserverSlos | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubePrometheusGeneral | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubePrometheusNodeAlerting | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubePrometheusNodeRecording | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubeStateMetrics | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubernetesAbsent | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubernetesApps | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubernetesResources | bool | `false` |  |
| prometheusStack.defaultRules.rules.kubernetesStorage | bool | `true` |  |
| prometheusStack.defaultRules.rules.kubernetesSystem | bool | `true` |  |
| prometheusStack.defaultRules.rules.network | bool | `true` |  |
| prometheusStack.defaultRules.rules.node | bool | `true` |  |
| prometheusStack.defaultRules.rules.prometheus | bool | `true` |  |
| prometheusStack.defaultRules.rules.prometheusOperator | bool | `true` |  |
| prometheusStack.grafana."grafana.ini"."auth.basic".enabled | bool | `true` |  |
| prometheusStack.grafana."grafana.ini".auth.disable_login_form | bool | `false` |  |
| prometheusStack.grafana."grafana.ini".security.disable_initial_admin_creation | bool | `false` |  |
| prometheusStack.grafana."grafana.ini".server.root_url | string | `"https://{{$.Values.global.ingress.host}}{{$.Values.global.ingress.paths.grafana}}"` |  |
| prometheusStack.grafana."grafana.ini".server.serve_from_sub_path | bool | `true` |  |
| prometheusStack.grafana.adminPassword | string | `nil` | Required |
| prometheusStack.grafana.serviceMonitor.path | string | `"/grafana/metrics"` |  |
| prometheusStack.grafana.sidecar.dashboards.enabled | bool | `true` |  |
| prometheusStack.grafana.sidecar.dashboards.folderAnnotation | string | `"k8s-sidecar-target-directory"` |  |
| prometheusStack.grafana.sidecar.dashboards.provider.foldersFromFilesStructure | bool | `true` |  |
| prometheusStack.kubeControllerManager.enabled | bool | `false` |  |
| prometheusStack.kubeProxy.enabled | bool | `false` |  |
| prometheusStack.kubeScheduler.enabled | bool | `false` |  |
| prometheusStack.kubelet.enabled | bool | `true` |  |
| prometheusStack.nameOverride | string | `"prometheus-stack"` |  |
| prometheusStack.prometheus.prometheusSpec.externalUrl | string | `"https://{{$.Values.global.ingress.host}}{{$.Values.global.ingress.paths.prometheus}}"` |  |
| prometheusStack.prometheus.prometheusSpec.podMonitorSelector | object | `{}` |  |
| prometheusStack.prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.probeSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.resources.requests.cpu | string | `"60m"` |  |
| prometheusStack.prometheus.prometheusSpec.resources.requests.memory | string | `"2255Mi"` |  |
| prometheusStack.prometheus.prometheusSpec.retention | string | `"1y"` |  |
| prometheusStack.prometheus.prometheusSpec.routePrefix | string | `"/prometheus"` |  |
| prometheusStack.prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage | string | `"250G"` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.patch.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.enabled | bool | `true` |  |
| prometheusStack.prometheusOperator.tls.enabled | bool | `false` |  |
| uptimeMonitors.bearerTokenFile | string | `nil` |  |
| uptimeMonitors.defaultTargets[0].module | string | `"dns_baseline"` |  |
| uptimeMonitors.defaultTargets[0].name | string | `"baseline"` |  |
| uptimeMonitors.defaultTargets[0].url | string | `"8.8.8.8"` |  |
| uptimeMonitors.defaults.additionalMetricsRelabels | object | `{}` |  |
| uptimeMonitors.defaults.additionalRelabeling | list | `[]` |  |
| uptimeMonitors.defaults.honorTimestamps | bool | `true` |  |
| uptimeMonitors.defaults.interval | string | `"30s"` |  |
| uptimeMonitors.defaults.jobName | string | `"prometheus-stack"` |  |
| uptimeMonitors.defaults.labels | object | `{}` |  |
| uptimeMonitors.defaults.module | string | `"http_2xx"` |  |
| uptimeMonitors.defaults.scrapeTimeout | string | `"30s"` |  |
| uptimeMonitors.enabled | bool | `true` |  |
| uptimeMonitors.path | string | `"/probe"` |  |
| uptimeMonitors.scheme | string | `"http"` |  |
| uptimeMonitors.targets | list | `[]` |  |
| uptimeMonitors.tlsConfig | object | `{}` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

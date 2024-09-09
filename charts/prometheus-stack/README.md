# prometheus-stack

![Version: 62.6.0](https://img.shields.io/badge/Version-62.6.0-informational?style=flat-square) ![AppVersion: 62.6.0](https://img.shields.io/badge/AppVersion-62.6.0-informational?style=flat-square)

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

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd"` |  |
| global.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| global.ingress.enabled | bool | `true` |  |
| global.ingress.host | string | `nil` |  |
| global.ingress.paths.alertmanager | string | `"/alertmanager"` |  |
| global.ingress.paths.grafana | string | `"/grafana"` |  |
| global.ingress.paths.prometheus | string | `"/prometheus"` |  |
| policyException.enabled | bool | `true` |  |
| prometheusStack.alertmanager.additionalRules.enabled | bool | `false` |  |
| prometheusStack.alertmanager.additionalRules.groups | list | `[]` |  |
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
| prometheusStack.prometheus.prometheusSpec.retention | string | `"365d"` |  |
| prometheusStack.prometheus.prometheusSpec.routePrefix | string | `"/prometheus"` |  |
| prometheusStack.prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage | string | `"250G"` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.patch.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.enabled | bool | `true` |  |
| prometheusStack.prometheusOperator.tls.enabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

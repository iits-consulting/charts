# prometheus-stack

![Version: 43.2.2](https://img.shields.io/badge/Version-43.2.2-informational?style=flat-square)

A complete monitoring/alerting stack with Grafana Prometheus Alertmanager

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://prometheus-community.github.io/helm-charts | prometheusStack(kube-prometheus-stack) | 43.1.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.alertmanager.host | string | `"REPLACE_ME"` |  |
| global.grafana.host | string | `"REPLACE_ME"` |  |
| global.prometheus.host | string | `"REPLACE_ME"` |  |
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
| prometheusStack.defaultRules.create | bool | `true` |  |
| prometheusStack.defaultRules.disabled.InfoInhibitor | bool | `true` |  |
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
| prometheusStack.defaultRules.rules.time | bool | `true` |  |
| prometheusStack.grafana."grafana.ini"."auth.basic".enabled | bool | `true` |  |
| prometheusStack.grafana."grafana.ini".auth.disable_login_form | bool | `false` |  |
| prometheusStack.grafana."grafana.ini".security.disable_initial_admin_creation | bool | `false` |  |
| prometheusStack.grafana."grafana.ini".server.root_url | string | `"https://{{$.Values.global.grafana.host}}/grafana"` |  |
| prometheusStack.grafana."grafana.ini".server.serve_from_sub_path | bool | `true` |  |
| prometheusStack.grafana.adminPassword | string | `"REPLACE_ME"` |  |
| prometheusStack.ingress.alertmanager.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"after-proxy"` |  |
| prometheusStack.ingress.alertmanager.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"{{.Release.Namespace}}-strip-prefix-{{ .Release.Name }}@kubernetescrd"` |  |
| prometheusStack.ingress.alertmanager.enabled | bool | `true` |  |
| prometheusStack.ingress.alertmanager.host | string | `"{{$.Values.global.alertmanager.host}}"` |  |
| prometheusStack.ingress.grafana.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| prometheusStack.ingress.grafana.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| prometheusStack.ingress.grafana.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| prometheusStack.ingress.grafana.className | string | `"traefik"` |  |
| prometheusStack.ingress.grafana.enabled | bool | `true` |  |
| prometheusStack.ingress.grafana.host | string | `"{{$.Values.global.grafana.host}}"` |  |
| prometheusStack.ingress.grafana.tls[0].hosts[0] | string | `"{{$.Values.global.grafana.host}}"` |  |
| prometheusStack.ingress.prometheus.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"after-proxy"` |  |
| prometheusStack.ingress.prometheus.enabled | bool | `true` |  |
| prometheusStack.ingress.prometheus.host | string | `"{{$.Values.global.prometheus.host}}"` |  |
| prometheusStack.kubeControllerManager.enabled | bool | `false` |  |
| prometheusStack.kubeProxy.enabled | bool | `false` |  |
| prometheusStack.kubeScheduler.enabled | bool | `false` |  |
| prometheusStack.kubelet.enabled | bool | `true` |  |
| prometheusStack.nameOverride | string | `"prometheus-stack"` |  |
| prometheusStack.prometheus.prometheusSpec.externalUrl | string | `"https://{{$.Values.global.prometheus.host}}/prometheus"` |  |
| prometheusStack.prometheus.prometheusSpec.podMonitorSelector | string | `nil` |  |
| prometheusStack.prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.probeNamespaceSelector | string | `nil` |  |
| prometheusStack.prometheus.prometheusSpec.probeSelector | string | `nil` |  |
| prometheusStack.prometheus.prometheusSpec.resources.requests.cpu | string | `"60m"` |  |
| prometheusStack.prometheus.prometheusSpec.resources.requests.memory | string | `"2255Mi"` |  |
| prometheusStack.prometheus.prometheusSpec.routePrefix | string | `"/prometheus"` |  |
| prometheusStack.prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues | bool | `false` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| prometheusStack.prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage | string | `"30G"` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.admissionWebhooks.patch.enabled | bool | `false` |  |
| prometheusStack.prometheusOperator.enabled | bool | `true` |  |
| prometheusStack.prometheusOperator.tls.enabled | bool | `false` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)

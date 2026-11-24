# kumoops-admin-dashboard

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 2.6.0](https://img.shields.io/badge/AppVersion-2.6.0-informational?style=flat-square)

This chart deploys a super simple webserver that provides a simple website containing links to a set
of dashboards that are usually deployed in our infrastructure setup as well as some nifty external
tools.

## Installing the Chart with iits ArgoCD

```yaml
kumoops-admin-dashboard:
  namespace: admin
  repoURL: "https://charts.iits.tech"
  targetRevision: "1.0.0"
  parameters:
    ingress.host: "REPLACE_ME"
```

**Homepage:** <https://github.com/iits-consulting/charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| iits-consulting |  | <https://iits-consulting.de> |

## Source Code

* <https://github.com/iits-consulting/charts>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` | Create a HorizontalPodAutoscaler for the deployment. Needs the metrics server. |
| autoscaling.maxReplicas | int | `3` | Upper bound of pods |
| autoscaling.minReplicas | int | `1` | Lower bound of pods |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilization in percent of the request |
| autoscaling.targetMemoryUtilizationPercentage | int | `nil` | Target average memory utilization in percent of the request, not used if empty |
| defaultDashboard.context | string | `nil` | Name of the customer or stage, shown in the user menu |
| defaultDashboard.logoAlt | string | `"KumoOps Logo"` | Alt text of the logo |
| defaultDashboard.logoDarkSrc | string | `"https://brand-book.kumo-ops.com/assets/kumoops-logo-full-dark-800px.png"` | Logo URL for dark mode, falls back to logoSrc |
| defaultDashboard.logoSrc | string | `"https://brand-book.kumo-ops.com/assets/kumoops-logo-full-light-800px.png"` | Logo URL for light mode |
| defaultDashboard.logoutUrl | string | `nil` | OIDC logout URL, falls back to the href of the logout tile |
| defaultDashboard.subtitle | string | `"CloudSecOps-as-a-Service"` | Subtitle below the title |
| defaultDashboard.tiles | object | see values.yaml | Tiles of the dashboard, keyed by name. Each tile takes `enabled`, `href`, `imgSrc`, `imgAlt`, `category` and an optional `description`. `category` has to be one of KumoOps, Observability, Security, DevOps, Messaging, Cloud, AI, Identity Management, System. Switch a tile off with `defaultDashboard.tiles.<name>.enabled: false`, add your own under a new key. |
| defaultDashboard.title | string | `"KumoOps Admin"` | Title of the page |
| defaultDashboard.userinfoUrl | string | `nil` | OIDC userinfo endpoint, used to show the logged in user |
| deployment.affinity | object | `{}` | Affinity of the pods, ignored when onePodForEachNode is true |
| deployment.annotations | object | `nil` | Annotations of the deployment, rendered with tpl |
| deployment.containerPort | int | `3000` | Port of the container. Has to match the port the image listens on, which is 3000 |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts of the webserver container |
| deployment.extraVolumes | list | `[]` | Extra volumes of the pod |
| deployment.health | object | `{"liveness":{"failureThreshold":3,"initialDelaySeconds":5,"path":"/","periodSeconds":20},"readiness":{"failureThreshold":3,"initialDelaySeconds":5,"path":"/","periodSeconds":20},"startupProbe":{"failureThreshold":3,"initialDelaySeconds":5,"path":"/","periodSeconds":5}}` | Startup, liveness and readiness probe settings |
| deployment.imagePullSecrets | list | `[]` | Pull secrets for the image |
| deployment.nodeSelector | object | `{}` | Node selector of the pods |
| deployment.onePodForEachNode | bool | `false` | Spread the pods so that no two run on the same node, replaces deployment.affinity |
| deployment.podAnnotations | object | `{}` | Annotations of the pods |
| deployment.podSecurityContext | object | `{"runAsNonRoot":true,"runAsUser":1001,"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the pod. Pod level, so no container falls back to the default (root) context |
| deployment.replicaCount | int | `1` | Number of pods, ignored when autoscaling is enabled |
| deployment.resources | object | `{"limits":{"cpu":"10m","memory":"8Mi"},"requests":{"cpu":"1m","memory":"4Mi"}}` | Resources of the webserver. It serves static files, so the defaults are tiny |
| deployment.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1001}` | Security context of the webserver container |
| deployment.tolerations | list | `[]` | Tolerations of the pods |
| fullnameOverride | string | `""` | Overrides the full name of all resources, defaults to the release name |
| ingress.annotations | object | `{"traefik.ingress.kubernetes.io/router.entrypoints":"websecure","traefik.ingress.kubernetes.io/router.tls":"true"}` | Annotations of the ingress, rendered with tpl |
| ingress.className | string | `nil` | Ingress class, the default class of the cluster is used if empty |
| ingress.enabled | bool | `true` | Create the ingress |
| ingress.host | string | `nil` | Required, replace it with your host address |
| ingress.hosts | list | `[{"host":"{{ .Values.ingress.host }}","paths":[{"path":"/"}]}]` | Hosts and paths of the ingress. Set `secretName` on a host to use your own TLS secret, `pathType` on a path defaults to Prefix |
| ingress.labels | object | `nil` | Extra labels of the ingress |
| nameOverride | string | `""` | Overrides the name used in the selector labels, defaults to the release name |
| service.annotations | object | `nil` | Annotations of the service, rendered with tpl |
| service.labels | object | `nil` | Extra labels of the service, rendered with tpl |
| service.port | int | `80` | Port of the service |
| service.type | string | `"ClusterIP"` | Type of the service |
| serviceAccount.annotations | object | `{}` | Annotations of the service account |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Name of the service account. If empty and create is true, the full name is used |
| serviceMonitor.annotations | object | `{}` | Annotations of the ServiceMonitor |
| serviceMonitor.blackboxExporter.namespace | string | `"monitoring"` | Namespace of the blackbox exporter service |
| serviceMonitor.blackboxExporter.selectorLabels | object | `{"app.kubernetes.io/instance":"prometheus-stack","app.kubernetes.io/name":"blackboxExporter"}` | Labels of the blackbox exporter service. Defaults match the iits prometheus-stack chart. |
| serviceMonitor.enabled | bool | `false` | Create the ServiceMonitor. Needs the prometheus operator CRDs and a blackbox exporter. |
| serviceMonitor.interval | string | `"30s"` | How often the dashboard is probed |
| serviceMonitor.labels | object | `{}` | Extra labels, e.g. to match the serviceMonitorSelector of your Prometheus |
| serviceMonitor.module | string | `"http_2xx"` | Blackbox exporter module, has to accept plain http |
| serviceMonitor.scrapeTimeout | string | `"30s"` | Timeout of one probe |
| website | string | built in dashboard | Custom HTML page that replaces the built in dashboard, rendered with tpl |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

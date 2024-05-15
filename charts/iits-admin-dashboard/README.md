# iits-admin-dashboard

![Version: 1.7.0](https://img.shields.io/badge/Version-1.7.0-informational?style=flat-square) ![AppVersion: 2.1.0](https://img.shields.io/badge/AppVersion-2.1.0-informational?style=flat-square)

This chart deploys a super simple webserver that provides a simple website containing links to a set
of dashboards that are usually deployed in our infrastructure setup as well as some nifty external
tools.

## Installing the Chart with iits ArgoCD

```yaml
iits-admin-dashboard:
  namespace: admin
  repoURL: "https://charts.iits.tech"
  targetRevision: "1.7.0"
  parameters:
    ingress.host: "REPLACE_ME"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| defaultDashboard.logoAlt | string | `"IITS Consulting Logo"` |  |
| defaultDashboard.logoSrc | string | `"iits-logo.svg"` |  |
| defaultDashboard.tiles.akhq.enabled | string | `"true"` |  |
| defaultDashboard.tiles.akhq.href | string | `"akhq/ui/"` |  |
| defaultDashboard.tiles.akhq.imgAlt | string | `"akhq (kafka headquarter)"` |  |
| defaultDashboard.tiles.akhq.imgSrc | string | `"kafka.png"` |  |
| defaultDashboard.tiles.alertManager.enabled | string | `"true"` |  |
| defaultDashboard.tiles.alertManager.href | string | `"/alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgAlt | string | `"Alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgSrc | string | `"definitly_not_alertmanager.png"` |  |
| defaultDashboard.tiles.argocd.enabled | string | `"true"` |  |
| defaultDashboard.tiles.argocd.href | string | `"argocd/auth/login"` |  |
| defaultDashboard.tiles.argocd.imgAlt | string | `"ArgoCD"` |  |
| defaultDashboard.tiles.argocd.imgSrc | string | `"argo.svg"` |  |
| defaultDashboard.tiles.dashboard.enabled | string | `"true"` |  |
| defaultDashboard.tiles.dashboard.href | string | `"dashboard/"` |  |
| defaultDashboard.tiles.dashboard.imgAlt | string | `"Traefik Dashboard"` |  |
| defaultDashboard.tiles.dashboard.imgSrc | string | `"traefik.png"` |  |
| defaultDashboard.tiles.elasticsearch.enabled | string | `"true"` |  |
| defaultDashboard.tiles.elasticsearch.href | string | `"elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgAlt | string | `"Elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgSrc | string | `"elasticsearch.png"` |  |
| defaultDashboard.tiles.grafana.enabled | string | `"true"` |  |
| defaultDashboard.tiles.grafana.href | string | `"grafana/login/generic_oauth"` |  |
| defaultDashboard.tiles.grafana.imgAlt | string | `"Grafana"` |  |
| defaultDashboard.tiles.grafana.imgSrc | string | `"definitly_not_grafana.png"` |  |
| defaultDashboard.tiles.keycloak.enabled | string | `"true"` |  |
| defaultDashboard.tiles.keycloak.href | string | `"keycloak/"` |  |
| defaultDashboard.tiles.keycloak.imgAlt | string | `"Keycloak"` |  |
| defaultDashboard.tiles.keycloak.imgSrc | string | `"keycloak.png"` |  |
| defaultDashboard.tiles.kibana.enabled | string | `"true"` |  |
| defaultDashboard.tiles.kibana.href | string | `"kibana/app/discover"` |  |
| defaultDashboard.tiles.kibana.imgAlt | string | `"Kibana"` |  |
| defaultDashboard.tiles.kibana.imgSrc | string | `"definitly_not_kibana.svg"` |  |
| defaultDashboard.tiles.kyverno.enabled | string | `"true"` |  |
| defaultDashboard.tiles.kyverno.href | string | `"policies"` |  |
| defaultDashboard.tiles.kyverno.imgAlt | string | `"Kyverno"` |  |
| defaultDashboard.tiles.kyverno.imgSrc | string | `"kyverno.png"` |  |
| defaultDashboard.tiles.logout.enabled | string | `"true"` |  |
| defaultDashboard.tiles.logout.href | string | `"/logout"` |  |
| defaultDashboard.tiles.logout.imgAlt | string | `"Logout"` |  |
| defaultDashboard.tiles.logout.imgSrc | string | `"logout.png"` |  |
| defaultDashboard.tiles.otc.enabled | string | `"true"` |  |
| defaultDashboard.tiles.otc.href | string | `"otcOIDC/"` |  |
| defaultDashboard.tiles.otc.imgAlt | string | `"OTC"` |  |
| defaultDashboard.tiles.otc.imgSrc | string | `"otc-logo.png"` |  |
| defaultDashboard.tiles.prometheus.enabled | string | `"true"` |  |
| defaultDashboard.tiles.prometheus.href | string | `"prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgAlt | string | `"Prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgSrc | string | `"definitly_not_prometheus.svg"` |  |
| defaultDashboard.tiles.vault.enabled | string | `"true"` |  |
| defaultDashboard.tiles.vault.href | string | `"vault/"` |  |
| defaultDashboard.tiles.vault.imgAlt | string | `"Vault"` |  |
| defaultDashboard.tiles.vault.imgSrc | string | `"vault.png"` |  |
| defaultDashboard.title | string | `"Tech Admin Board"` |  |
| deployment.annotations | string | `nil` |  |
| deployment.containerPort | int | `3000` |  |
| deployment.extraVolumeMounts | list | `[]` |  |
| deployment.extraVolumes | list | `[]` |  |
| deployment.health.liveness.failureThreshold | int | `3` |  |
| deployment.health.liveness.initialDelaySeconds | int | `5` |  |
| deployment.health.liveness.path | string | `"/"` |  |
| deployment.health.liveness.periodSeconds | int | `20` |  |
| deployment.health.readiness.failureThreshold | int | `3` |  |
| deployment.health.readiness.initialDelaySeconds | int | `5` |  |
| deployment.health.readiness.path | string | `"/"` |  |
| deployment.health.readiness.periodSeconds | int | `20` |  |
| deployment.health.startupProbe.failureThreshold | int | `3` |  |
| deployment.health.startupProbe.initialDelaySeconds | int | `5` |  |
| deployment.health.startupProbe.path | string | `"/"` |  |
| deployment.health.startupProbe.periodSeconds | int | `5` |  |
| deployment.imagePullSecrets | list | `[]` |  |
| deployment.onePodForEachNode | bool | `false` |  |
| deployment.podAnnotations | object | `{}` |  |
| deployment.podSecurityContext | string | `nil` |  |
| deployment.replicaCount | int | `2` |  |
| deployment.resources.limits.cpu | string | `"10m"` |  |
| deployment.resources.limits.memory | string | `"8Mi"` |  |
| deployment.resources.requests.cpu | string | `"1m"` |  |
| deployment.resources.requests.memory | string | `"4Mi"` |  |
| deployment.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| deployment.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| deployment.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| deployment.securityContext.runAsNonRoot | bool | `true` |  |
| deployment.securityContext.runAsUser | int | `1001` |  |
| fullnameOverride | string | `""` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | string | `nil` | Required, replace it with your host address |
| ingress.hosts[0].host | string | `"{{ .Values.ingress.host }}"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.labels | string | `nil` |  |
| nameOverride | string | `""` |  |
| service.annotations | string | `nil` |  |
| service.labels | string | `nil` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

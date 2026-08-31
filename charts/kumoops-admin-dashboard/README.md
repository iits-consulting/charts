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
| defaultDashboard.logoAlt | string | `"KumoOps Logo"` |  |
| defaultDashboard.logoDarkSrc | string | `"https://brand-book.kumo-ops.com/assets/kumoops-logo-full-dark-800px.png"` |  |
| defaultDashboard.logoSrc | string | `"https://brand-book.kumo-ops.com/assets/kumoops-logo-full-light-800px.png"` |  |
| defaultDashboard.subtitle | string | `"CloudSecOps-as-a-Service"` |  |
| defaultDashboard.tiles.akhq.category | string | `"Messaging"` |  |
| defaultDashboard.tiles.akhq.description | string | `"Kafka cluster management UI"` |  |
| defaultDashboard.tiles.akhq.enabled | bool | `true` |  |
| defaultDashboard.tiles.akhq.href | string | `"akhq/ui/"` |  |
| defaultDashboard.tiles.akhq.imgAlt | string | `"akhq (kafka headquarter)"` |  |
| defaultDashboard.tiles.akhq.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/kafka.svg"` |  |
| defaultDashboard.tiles.alertManager.category | string | `"Observability"` |  |
| defaultDashboard.tiles.alertManager.description | string | `"Alert handling and routing"` |  |
| defaultDashboard.tiles.alertManager.enabled | bool | `true` |  |
| defaultDashboard.tiles.alertManager.href | string | `"/alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgAlt | string | `"Alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/definitly_not_alertmanager.svg"` |  |
| defaultDashboard.tiles.argocd.category | string | `"DevOps"` |  |
| defaultDashboard.tiles.argocd.description | string | `"GitOps continuous delivery for Kubernetes"` |  |
| defaultDashboard.tiles.argocd.enabled | bool | `true` |  |
| defaultDashboard.tiles.argocd.href | string | `"argocd/auth/login"` |  |
| defaultDashboard.tiles.argocd.imgAlt | string | `"ArgoCD"` |  |
| defaultDashboard.tiles.argocd.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/argo.svg"` |  |
| defaultDashboard.tiles.docs.category | string | `"KumoOps"` |  |
| defaultDashboard.tiles.docs.description | string | `"Technical Documentation about KumoOps"` |  |
| defaultDashboard.tiles.docs.enabled | bool | `false` |  |
| defaultDashboard.tiles.docs.href | string | `"docs/"` |  |
| defaultDashboard.tiles.docs.imgAlt | string | `"Docs"` |  |
| defaultDashboard.tiles.docs.imgSrc | string | `"https://picsum.photos/id/24/200/200"` |  |
| defaultDashboard.tiles.elasticsearch.category | string | `"Observability"` |  |
| defaultDashboard.tiles.elasticsearch.description | string | `"Search and analytics engine"` |  |
| defaultDashboard.tiles.elasticsearch.enabled | bool | `true` |  |
| defaultDashboard.tiles.elasticsearch.href | string | `"elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgAlt | string | `"Elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/elasticsearch.svg"` |  |
| defaultDashboard.tiles.gitlab.category | string | `"DevOps"` |  |
| defaultDashboard.tiles.gitlab.description | string | `"DevOps platform for Git repositories and CI/CD"` |  |
| defaultDashboard.tiles.gitlab.enabled | bool | `false` |  |
| defaultDashboard.tiles.gitlab.href | string | `"https://gitlab.kumo-ops.com"` |  |
| defaultDashboard.tiles.gitlab.imgAlt | string | `"GitLab"` |  |
| defaultDashboard.tiles.gitlab.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/gitlab.svg"` |  |
| defaultDashboard.tiles.grafana.category | string | `"Observability"` |  |
| defaultDashboard.tiles.grafana.description | string | `"Metrics visualization and monitoring"` |  |
| defaultDashboard.tiles.grafana.enabled | bool | `true` |  |
| defaultDashboard.tiles.grafana.href | string | `"grafana/login/generic_oauth"` |  |
| defaultDashboard.tiles.grafana.imgAlt | string | `"Grafana"` |  |
| defaultDashboard.tiles.grafana.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/definitly_not_grafana.svg"` |  |
| defaultDashboard.tiles.harbor.category | string | `"DevOps"` |  |
| defaultDashboard.tiles.harbor.description | string | `"Container registry with security scanning and signing"` |  |
| defaultDashboard.tiles.harbor.enabled | bool | `false` |  |
| defaultDashboard.tiles.harbor.href | string | `"harbor/"` |  |
| defaultDashboard.tiles.harbor.imgAlt | string | `"Harbor"` |  |
| defaultDashboard.tiles.harbor.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/harbor-logo.png"` |  |
| defaultDashboard.tiles.homeport.category | string | `"AI"` |  |
| defaultDashboard.tiles.homeport.description | string | `"Homeport.ai provides you private genAI tools and services"` |  |
| defaultDashboard.tiles.homeport.enabled | bool | `false` |  |
| defaultDashboard.tiles.homeport.href | string | `"https://homeport.ai"` |  |
| defaultDashboard.tiles.homeport.imgAlt | string | `"Homeport private GenAI Tool"` |  |
| defaultDashboard.tiles.homeport.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/homeport-1.png"` |  |
| defaultDashboard.tiles.keycloak.category | string | `"Identity Management"` |  |
| defaultDashboard.tiles.keycloak.description | string | `"Identity and access management"` |  |
| defaultDashboard.tiles.keycloak.enabled | bool | `true` |  |
| defaultDashboard.tiles.keycloak.href | string | `"keycloak/"` |  |
| defaultDashboard.tiles.keycloak.imgAlt | string | `"Keycloak"` |  |
| defaultDashboard.tiles.keycloak.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/keycloak.svg"` |  |
| defaultDashboard.tiles.kibana.category | string | `"Observability"` |  |
| defaultDashboard.tiles.kibana.description | string | `"Log exploration and visualization"` |  |
| defaultDashboard.tiles.kibana.enabled | bool | `true` |  |
| defaultDashboard.tiles.kibana.href | string | `"kibana/app/discover"` |  |
| defaultDashboard.tiles.kibana.imgAlt | string | `"Kibana"` |  |
| defaultDashboard.tiles.kibana.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/definitly_not_kibana.svg"` |  |
| defaultDashboard.tiles.kyverno.category | string | `"Security"` |  |
| defaultDashboard.tiles.kyverno.description | string | `"Kubernetes policy management"` |  |
| defaultDashboard.tiles.kyverno.enabled | bool | `true` |  |
| defaultDashboard.tiles.kyverno.href | string | `"policies"` |  |
| defaultDashboard.tiles.kyverno.imgAlt | string | `"Kyverno"` |  |
| defaultDashboard.tiles.kyverno.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/kyverno.svg"` |  |
| defaultDashboard.tiles.logout.category | string | `"Identity Management"` |  |
| defaultDashboard.tiles.logout.description | string | `"Sign out from all services"` |  |
| defaultDashboard.tiles.logout.enabled | bool | `true` |  |
| defaultDashboard.tiles.logout.href | string | `"/logout"` |  |
| defaultDashboard.tiles.logout.imgAlt | string | `"Logout"` |  |
| defaultDashboard.tiles.logout.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/logout.svg"` |  |
| defaultDashboard.tiles.n8n.category | string | `"AI"` |  |
| defaultDashboard.tiles.n8n.description | string | `"Workflow automation platform"` |  |
| defaultDashboard.tiles.n8n.enabled | bool | `false` |  |
| defaultDashboard.tiles.n8n.href | string | `"n8n/"` |  |
| defaultDashboard.tiles.n8n.imgAlt | string | `"n8n Automation"` |  |
| defaultDashboard.tiles.n8n.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/n8n-logo.webp"` |  |
| defaultDashboard.tiles.otc.category | string | `"Cloud Provider"` |  |
| defaultDashboard.tiles.otc.description | string | `"T Cloud Public(TCP) console"` |  |
| defaultDashboard.tiles.otc.enabled | bool | `true` |  |
| defaultDashboard.tiles.otc.href | string | `"otcOIDC/"` |  |
| defaultDashboard.tiles.otc.imgAlt | string | `"T Cloud Public(TCP)"` |  |
| defaultDashboard.tiles.otc.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/otc-logo.svg"` |  |
| defaultDashboard.tiles.portal.category | string | `"KumoOps"` |  |
| defaultDashboard.tiles.portal.description | string | `"Main KumoOps portal dashboard"` |  |
| defaultDashboard.tiles.portal.enabled | bool | `false` |  |
| defaultDashboard.tiles.portal.href | string | `"https://my-portal.kumo-ops.com/"` |  |
| defaultDashboard.tiles.portal.imgAlt | string | `"KumoOps Portal"` |  |
| defaultDashboard.tiles.portal.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/kumoops-portal.png"` |  |
| defaultDashboard.tiles.prometheus.category | string | `"Observability"` |  |
| defaultDashboard.tiles.prometheus.description | string | `"Time-series database and monitoring"` |  |
| defaultDashboard.tiles.prometheus.enabled | bool | `true` |  |
| defaultDashboard.tiles.prometheus.href | string | `"prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgAlt | string | `"Prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/definitly_not_prometheus.svg"` |  |
| defaultDashboard.tiles.sonarqube.category | string | `"Security"` |  |
| defaultDashboard.tiles.sonarqube.description | string | `"Code quality and security analysis platform"` |  |
| defaultDashboard.tiles.sonarqube.enabled | bool | `false` |  |
| defaultDashboard.tiles.sonarqube.href | string | `"sonarqube/"` |  |
| defaultDashboard.tiles.sonarqube.imgAlt | string | `"SonarQube"` |  |
| defaultDashboard.tiles.sonarqube.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/sonarqube.webp"` |  |
| defaultDashboard.tiles.support.category | string | `"KumoOps"` |  |
| defaultDashboard.tiles.support.enabled | bool | `false` |  |
| defaultDashboard.tiles.support.href | string | `"support@kumo-ops.com"` |  |
| defaultDashboard.tiles.support.imgAlt | string | `"KumoOps Support"` |  |
| defaultDashboard.tiles.support.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/kumo-support.png"` |  |
| defaultDashboard.tiles.traefikDashboard.category | string | `"DevOps"` |  |
| defaultDashboard.tiles.traefikDashboard.description | string | `"Traefik proxy and routing dashboard"` |  |
| defaultDashboard.tiles.traefikDashboard.enabled | bool | `true` |  |
| defaultDashboard.tiles.traefikDashboard.href | string | `"dashboard/"` |  |
| defaultDashboard.tiles.traefikDashboard.imgAlt | string | `"Traefik Dashboard"` |  |
| defaultDashboard.tiles.traefikDashboard.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/traefik.svg"` |  |
| defaultDashboard.tiles.trivy.category | string | `"Security"` |  |
| defaultDashboard.tiles.trivy.description | string | `"Comprehensive vulnerability scanner for containers"` |  |
| defaultDashboard.tiles.trivy.enabled | bool | `false` |  |
| defaultDashboard.tiles.trivy.href | string | `"trivy/"` |  |
| defaultDashboard.tiles.trivy.imgAlt | string | `"Trivy"` |  |
| defaultDashboard.tiles.trivy.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/trivy_logo.png"` |  |
| defaultDashboard.tiles.vault.category | string | `"Security"` |  |
| defaultDashboard.tiles.vault.description | string | `"Secrets and encryption management"` |  |
| defaultDashboard.tiles.vault.enabled | bool | `true` |  |
| defaultDashboard.tiles.vault.href | string | `"vault/"` |  |
| defaultDashboard.tiles.vault.imgAlt | string | `"Vault"` |  |
| defaultDashboard.tiles.vault.imgSrc | string | `"https://iits-consulting.de/wp-content/uploads/2026/01/vault.svg"` |  |
| defaultDashboard.title | string | `"KumoOps Admin"` |  |
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
| deployment.replicaCount | int | `1` |  |
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
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

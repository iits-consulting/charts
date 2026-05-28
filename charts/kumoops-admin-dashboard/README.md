# kumoops-admin-dashboard

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 2.6.0](https://img.shields.io/badge/AppVersion-2.6.0-informational?style=flat-square)

This chart deploys a lightweight webserver that provides a dashboard with links to all infrastructure
tools deployed in a KumoOps cluster (ArgoCD, Vault, Grafana, Keycloak, etc.) as well as external
services (GitLab, OTC Console, KumoOps Portal).

## Installing the Chart with iits ArgoCD

```yaml
kumoops-admin-dashboard:
  namespace: admin
  repoURL: "https://charts.iits.tech"
  targetRevision: "1.0.0"
  parameters:
    ingress.host: "REPLACE_ME"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| defaultDashboard.title | string | `"KumoOps Admin"` | Dashboard title |
| defaultDashboard.subtitle | string | `"CloudSecOps-as-a-Service"` | Subtitle below the title |
| defaultDashboard.logoSrc | string | `"https://brand-book.kumo-ops.com/..."` | Logo image URL (light mode) |
| defaultDashboard.logoDarkSrc | string | `"https://brand-book.kumo-ops.com/..."` | Logo image URL (dark mode) |
| defaultDashboard.logoAlt | string | `"KumoOps Logo"` | Logo alt text |
| defaultDashboard.userinfoUrl | string | `nil` | Keycloak OIDC userinfo endpoint for displaying logged-in user |
| defaultDashboard.logoutUrl | string | `nil` | Keycloak OIDC logout URL |
| defaultDashboard.context | string | `nil` | Customer/deployment context name displayed in user menu |

### Tiles

Each tile under `defaultDashboard.tiles.<name>` supports:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| enabled | bool | yes | Whether to display this tile |
| href | string | if enabled | Tile link URL (relative or absolute) |
| imgSrc | string | if enabled | Tile image URL |
| imgAlt | string | if enabled | Image alt text / tile name |
| category | string | if enabled | Category for grouping tiles |
| description | string | no | Tooltip description (max 150 chars) |

#### Default tiles

| Tile | Category | Default href | Description |
|------|----------|-------------|-------------|
| portal | KumoOps | `https://portal.playground.iits.tech` | Main KumoOps portal dashboard |
| support | KumoOps | `support-team-otc@iits.atlassian.net` | KumoOps Support |
| shop | KumoOps Portal | `https://start.kumo-ops.com` | KumoOps Shop |
| docs | KumoOps | `https://admin.{stageDomain}/docs/` | Technical documentation |
| argocd | DevOps | `argocd/auth/login` | GitOps continuous delivery |
| gitlab | DevOps | `https://gitlab.iits.tech` | Git repositories and CI/CD |
| harbor | DevOps | `harbor/` | Container registry |
| traefikDashboard | DevOps | `dashboard/` | Traefik proxy dashboard |
| grafana | Observability | `grafana/login/generic_oauth` | Metrics visualization |
| prometheus | Observability | `prometheus` | Time-series monitoring |
| kibana | Observability | `kibana/app/discover` | Log exploration |
| elasticsearch | Observability | `elasticsearch` | Search and analytics engine |
| alertManager | Observability | `/alertmanager` | Alert handling and routing |
| vault | Security | `vault/` | Secrets management |
| kyverno | Security | `policies` | Kubernetes policy management |
| sonarqube | Security | `sonarqube/` | Code quality analysis |
| trivy | Security | `trivy/` | Vulnerability scanner |
| keycloak | Identity Management | `keycloak/` | Identity and access management |
| otc | Cloud Provider | `otcOIDC/` | Open Telekom Cloud console (OIDC SSO) |
| logout | Identity Management | `/logout` | Sign out from all services |
| akhq | Messaging | `akhq/ui/` | Kafka management UI |
| homeport | AI | `https://homeport.ai` | Private GenAI tools |
| n8n | AI | `n8n/` | Workflow automation |

### Deployment

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.replicaCount | int | `1` | Number of pod replicas |
| deployment.onePodForEachNode | bool | `false` | Schedule one pod per node |
| deployment.containerPort | int | `3000` | Container listening port |
| deployment.resources.requests.cpu | string | `"1m"` | CPU request |
| deployment.resources.requests.memory | string | `"4Mi"` | Memory request |
| deployment.resources.limits.cpu | string | `"10m"` | CPU limit |
| deployment.resources.limits.memory | string | `"8Mi"` | Memory limit |
| deployment.securityContext.runAsNonRoot | bool | `true` | |
| deployment.securityContext.readOnlyRootFilesystem | bool | `true` | |
| deployment.securityContext.runAsUser | int | `1001` | |

### Ingress

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.enabled | bool | `true` | Enable ingress |
| ingress.host | string | `nil` | Ingress hostname (required) |
| ingress.annotations | object | Traefik websecure | Ingress annotations |

### Service

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.type | string | `"ClusterIP"` | Service type |
| service.port | int | `80` | Service port |

### Other

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | |
| fullnameOverride | string | `""` | |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Service account name |
| serviceAccount.annotations | object | `{}` | Service account annotations |

## Disabling tiles per deployment

Override tiles in your deployment values (e.g., via ArgoCD parameters):

```yaml
defaultDashboard:
  tiles:
    harbor:
      enabled: false
    akhq:
      enabled: false
```
# iits-admin-dashboard

![Version: 1.4.3](https://img.shields.io/badge/Version-1.4.3-informational?style=flat-square)

This chart deploys a super simple webserver that provides a simple website containing links to a set
of dashboards that are usually deployed in our infrastructure setup as well as some nifty external
tools.

## Installing the Chart with iits ArgoCD

```yaml
iits-admin-dashboard:
  namespace: admin
  repoURL: "https://charts.iits.tech"
  targetRevision: "1.4.1"
  parameters:
    ingress.host: "REPLACE_ME"
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| defaultDashboard.logoAlt | string | `"IITS Consulting Logo"` |  |
| defaultDashboard.logoSrc | string | `"logo_white.svg"` |  |
| defaultDashboard.tiles.akhq.enabled | string | `"true"` |  |
| defaultDashboard.tiles.akhq.href | string | `"akhq/ui/"` |  |
| defaultDashboard.tiles.akhq.imgAlt | string | `"akhq (kafka headquarter)"` |  |
| defaultDashboard.tiles.akhq.imgSrc | string | `"https://cdn.icon-icons.com/icons2/2699/PNG/512/apache_kafka_vertical_logo_icon_169585.png"` |  |
| defaultDashboard.tiles.alertManager.enabled | string | `"true"` |  |
| defaultDashboard.tiles.alertManager.href | string | `"/alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgAlt | string | `"Alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgSrc | string | `"https://devopy.io/wp-content/uploads/2019/02/bell_260.svg"` |  |
| defaultDashboard.tiles.argocd.enabled | string | `"true"` |  |
| defaultDashboard.tiles.argocd.href | string | `"argocd"` |  |
| defaultDashboard.tiles.argocd.imgAlt | string | `"ArgoCD"` |  |
| defaultDashboard.tiles.argocd.imgSrc | string | `"argo.svg"` |  |
| defaultDashboard.tiles.dashboard.enabled | string | `"true"` |  |
| defaultDashboard.tiles.dashboard.href | string | `"dashboard/"` |  |
| defaultDashboard.tiles.dashboard.imgAlt | string | `"Traefik Dashboard"` |  |
| defaultDashboard.tiles.dashboard.imgSrc | string | `"https://raw.githubusercontent.com/docker-library/docs/a6cc2c5f4bc6658168f2a0abbb0307acaefff80e/traefik/logo.png"` |  |
| defaultDashboard.tiles.elasticsearch.enabled | string | `"true"` |  |
| defaultDashboard.tiles.elasticsearch.href | string | `"elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgAlt | string | `"Elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgSrc | string | `"https://iconape.com/wp-content/png_logo_vector/elasticsearch-logo.png"` |  |
| defaultDashboard.tiles.grafana.enabled | string | `"true"` |  |
| defaultDashboard.tiles.grafana.href | string | `"grafana/login/generic_oauth"` |  |
| defaultDashboard.tiles.grafana.imgAlt | string | `"Grafana"` |  |
| defaultDashboard.tiles.grafana.imgSrc | string | `"https://seekicon.com/free-icon-download/grafana_2.png"` |  |
| defaultDashboard.tiles.keycloak.enabled | string | `"true"` |  |
| defaultDashboard.tiles.keycloak.href | string | `"keycloak/"` |  |
| defaultDashboard.tiles.keycloak.imgAlt | string | `"Keycloak"` |  |
| defaultDashboard.tiles.keycloak.imgSrc | string | `"https://www.quellwerke.de/fileadmin/Technologie_Logos/keycloak.png"` |  |
| defaultDashboard.tiles.kibana.enabled | string | `"true"` |  |
| defaultDashboard.tiles.kibana.href | string | `"kibana/app/discover"` |  |
| defaultDashboard.tiles.kibana.imgAlt | string | `"Kibana"` |  |
| defaultDashboard.tiles.kibana.imgSrc | string | `"https://cdn.iconscout.com/icon/free/png-512/elastic-1-283281.png"` |  |
| defaultDashboard.tiles.kyverno.enabled | string | `"true"` |  |
| defaultDashboard.tiles.kyverno.href | string | `"policies"` |  |
| defaultDashboard.tiles.kyverno.imgAlt | string | `"Kyverno"` |  |
| defaultDashboard.tiles.kyverno.imgSrc | string | `"https://cdn.shopify.com/s/files/1/1300/8977/collections/kyverno_480x480.png"` |  |
| defaultDashboard.tiles.logout.enabled | string | `"true"` |  |
| defaultDashboard.tiles.logout.href | string | `"/logout"` |  |
| defaultDashboard.tiles.logout.imgAlt | string | `"Logout"` |  |
| defaultDashboard.tiles.logout.imgSrc | string | `"https://www.nicepng.com/png/detail/518-5189122_logout-transparent-logout-button-icon.png"` |  |
| defaultDashboard.tiles.otc.enabled | string | `"true"` |  |
| defaultDashboard.tiles.otc.href | string | `"otcOIDC/"` |  |
| defaultDashboard.tiles.otc.imgAlt | string | `"OTC"` |  |
| defaultDashboard.tiles.otc.imgSrc | string | `"https://upload.wikimedia.org/wikipedia/commons/7/75/Otc-logo.png"` |  |
| defaultDashboard.tiles.prometheus.enabled | string | `"true"` |  |
| defaultDashboard.tiles.prometheus.href | string | `"prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgAlt | string | `"Prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgSrc | string | `"https://www.logolynx.com/images/logolynx/8b/8b0c91b14fb1da0270f0c5ed3d69fac4.jpeg"` |  |
| defaultDashboard.tiles.vault.enabled | string | `"true"` |  |
| defaultDashboard.tiles.vault.href | string | `"vault/"` |  |
| defaultDashboard.tiles.vault.imgAlt | string | `"Vault"` |  |
| defaultDashboard.tiles.vault.imgSrc | string | `"https://www.drupal.org/files/project-images/Vault_VerticalLogo_FullColor.png"` |  |
| defaultDashboard.title | string | `"Tech Admin Board"` |  |
| deployment.affinity | object | `{}` |  |
| deployment.annotations.htmlChecksum | string | `"{{ include (print $.Template.BasePath \"/configmap.yaml\") . | sha256sum }}"` |  |
| deployment.env.MUH | string | `"KUH"` |  |
| deployment.envFromSecret | string | `nil` |  |
| deployment.fullnameOverride | string | `""` |  |
| deployment.health.liveness.path | string | `"/"` |  |
| deployment.health.liveness.port | int | `3000` |  |
| deployment.health.readiness.path | string | `"/"` |  |
| deployment.health.readiness.port | int | `3000` |  |
| deployment.health.startupProbe.path | string | `"/"` |  |
| deployment.health.startupProbe.port | int | `3000` |  |
| deployment.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.repository | string | `"lipanski/docker-static-website"` |  |
| deployment.image.tag | string | `"2.1.0"` |  |
| deployment.imagePullSecrets | list | `[]` |  |
| deployment.nameOverride | string | `""` |  |
| deployment.podAnnotations | object | `{}` |  |
| deployment.podSecurityContext | string | `nil` |  |
| deployment.ports.http.port | int | `3000` |  |
| deployment.replicaCount | string | `"2"` |  |
| deployment.resources.limits.cpu | string | `"10m"` |  |
| deployment.resources.limits.memory | string | `"8Mi"` |  |
| deployment.resources.requests.cpu | string | `"1m"` |  |
| deployment.resources.requests.memory | string | `"4Mi"` |  |
| deployment.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| deployment.securityContext.runAsNonRoot | bool | `true` |  |
| deployment.securityContext.runAsUser | int | `1001` |  |
| deployment.volumeMounts[0].mountPath | string | `"/home/static"` |  |
| deployment.volumeMounts[0].name | string | `"admin-dashboard-config"` |  |
| deployment.volumes[0].configMap.name | string | `"admin-dashboard-config"` |  |
| deployment.volumes[0].name | string | `"admin-dashboard-config"` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.defaultIngress.enabled | bool | `true` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | string | `nil` | Required, replace it with your host address |
| service.ports.http.targetPort | int | `3000` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

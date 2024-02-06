# iits-admin-dashboard

![Version: 1.3.0](https://img.shields.io/badge/Version-1.3.0-informational?style=flat-square)

This chart deploys a super simple webserver that provides a simple website containing links to a set
of dashboards that are usually deployed in our infrastructure setup as well as some nifty external
tools.

## Installing the Chart

To install the chart with the release name iits-admin-dashboard:

```shell
    helm repo add iits-charts https://charts.iits.tech
    helm search repo iits-admin-dashboard
    helm install iits-admin-dashboard iits-charts/iits-admin-dashboard
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| defaultDashboard.logoAlt | string | `"IITS Consulting Logo"` |  |
| defaultDashboard.logoSrc | string | `"logo_white.svg"` |  |
| defaultDashboard.tiles.akhq.href | string | `"akhq/ui/"` |  |
| defaultDashboard.tiles.akhq.imgAlt | string | `"akhq (kafka headquarter)"` |  |
| defaultDashboard.tiles.akhq.imgSrc | string | `"https://cdn.icon-icons.com/icons2/2699/PNG/512/apache_kafka_vertical_logo_icon_169585.png"` |  |
| defaultDashboard.tiles.alertManager.href | string | `"/alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgAlt | string | `"Alertmanager"` |  |
| defaultDashboard.tiles.alertManager.imgSrc | string | `"https://devopy.io/wp-content/uploads/2019/02/bell_260.svg"` |  |
| defaultDashboard.tiles.argocd.href | string | `"argocd"` |  |
| defaultDashboard.tiles.argocd.imgAlt | string | `"ArgoCD"` |  |
| defaultDashboard.tiles.argocd.imgSrc | string | `"argo.svg"` |  |
| defaultDashboard.tiles.dashboard.href | string | `"dashboard/"` |  |
| defaultDashboard.tiles.dashboard.imgAlt | string | `"Traefik Dashboard"` |  |
| defaultDashboard.tiles.dashboard.imgSrc | string | `"https://raw.githubusercontent.com/docker-library/docs/a6cc2c5f4bc6658168f2a0abbb0307acaefff80e/traefik/logo.png"` |  |
| defaultDashboard.tiles.elasticsearch.href | string | `"elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgAlt | string | `"Elasticsearch"` |  |
| defaultDashboard.tiles.elasticsearch.imgSrc | string | `"https://iconape.com/wp-content/png_logo_vector/elasticsearch-logo.png"` |  |
| defaultDashboard.tiles.grafana.href | string | `"grafana/login/generic_oauth"` |  |
| defaultDashboard.tiles.grafana.imgAlt | string | `"Grafana"` |  |
| defaultDashboard.tiles.grafana.imgSrc | string | `"https://seekicon.com/free-icon-download/grafana_2.png"` |  |
| defaultDashboard.tiles.keycloak.href | string | `"keycloak/"` |  |
| defaultDashboard.tiles.keycloak.imgAlt | string | `"Keycloak"` |  |
| defaultDashboard.tiles.keycloak.imgSrc | string | `"https://www.quellwerke.de/fileadmin/Technologie_Logos/keycloak.png"` |  |
| defaultDashboard.tiles.kibana.href | string | `"kibana/app/discover"` |  |
| defaultDashboard.tiles.kibana.imgAlt | string | `"Kibana"` |  |
| defaultDashboard.tiles.kibana.imgSrc | string | `"https://cdn.iconscout.com/icon/free/png-512/elastic-1-283281.png"` |  |
| defaultDashboard.tiles.kyverno.href | string | `"policies"` |  |
| defaultDashboard.tiles.kyverno.imgAlt | string | `"Kyverno"` |  |
| defaultDashboard.tiles.kyverno.imgSrc | string | `"https://cdn.shopify.com/s/files/1/1300/8977/collections/kyverno_480x480.png"` |  |
| defaultDashboard.tiles.otc.href | string | `"otcOIDC/"` |  |
| defaultDashboard.tiles.otc.imgAlt | string | `"OTC"` |  |
| defaultDashboard.tiles.otc.imgSrc | string | `"https://upload.wikimedia.org/wikipedia/commons/7/75/Otc-logo.png"` |  |
| defaultDashboard.tiles.prometheus.href | string | `"prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgAlt | string | `"Prometheus"` |  |
| defaultDashboard.tiles.prometheus.imgSrc | string | `"https://www.logolynx.com/images/logolynx/8b/8b0c91b14fb1da0270f0c5ed3d69fac4.jpeg"` |  |
| defaultDashboard.tiles.vault.href | string | `"vault/"` |  |
| defaultDashboard.tiles.vault.imgAlt | string | `"Vault"` |  |
| defaultDashboard.tiles.vault.imgSrc | string | `"https://www.drupal.org/files/project-images/Vault_VerticalLogo_FullColor.png"` |  |
| defaultDashboard.title | string | `"Tech Admin Board"` |  |
| image.repository | string | `"lipanski/docker-static-website"` |  |
| image.tag | string | `"2.1.0"` |  |
| ingressRoute.adminDomain | string | `"admin.my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"after-proxy"` |  |
| ingressRoute.pathPrefix | string | `"/"` |  |
| resources.limits.cpu | string | `"10m"` |  |
| resources.limits.memory | string | `"8Mi"` |  |
| resources.requests.cpu | string | `"1m"` |  |
| resources.requests.memory | string | `"4Mi"` |  |
| service.port | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
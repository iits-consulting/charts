# cert-manager

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square)

Wrapper chart for cert-manager. Deploys a ClusterIssuer resource to bootstrap Let's encrypt cert generation

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.jetstack.io | cert-manager | v1.11.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterIssuer.http.email | string | `"REPLACE_ME@some.de"` |  |
| clusterIssuer.http.name | string | `"letsencrypt"` |  |
| ingressClass | string | `"traefik"` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

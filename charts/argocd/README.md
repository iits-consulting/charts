# argocd

![Version: 18.1.1](https://img.shields.io/badge/Version-18.1.1-informational?style=flat-square) ![AppVersion: 3.1.5](https://img.shields.io/badge/AppVersion-3.1.5-informational?style=flat-square)

This chart is used to bootstrap a Kubernetes cluster with `argocd`.
You can use this chart to deploy `argocd` through tools like `terraform`.
Note that this is only deploying the core ArgoCD components. To deploy
projects, use the `argocd-apps` chart instead.

Usage example:

```hcl
resource "helm_release" "argocd" {
  name                  = "argocd"
  repository            = "https://charts.iits.tech"
  chart                 = "argocd"
  version               = "18.1.1"
  namespace             = "argocd"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
}
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://argoproj.github.io/argo-helm | argo-cd | 8.5.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.configs."oidc.config" | string | `"name: OIDC\nissuer: $argocd-oidc:oidcURL\nclientID: $argocd-oidc:clientID\nclientSecret: $argocd-oidc:clientSecret\nrequestedScopes:\n  - openid\n  - profile\n  - email\n  - groups\nrequestedIDTokenClaims:\n  groups:\n    essential: true\n"` |  |
| argo-cd.configs."resource.customizations" | string | `"# Ignores .data changes of all secrets with a vaultInjectionChecksum annotation\nargoproj.io/Application:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - '. | select(.metadata.annotations.parametersChecksum) | .spec.source.helm'\n      - '. | select(.metadata.annotations.valueFileChecksum) | .spec.source.helm'\n# Ignores caBundle and template changes of the following resources\nadmissionregistration.k8s.io/MutatingWebhookConfiguration:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .metadata.annotations.template\n      - '.webhooks'\napiextensions.k8s.io/CustomResourceDefinition:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .spec.conversion.webhookClientConfig.caBundle\nadmissionregistration.k8s.io/ValidatingWebhookConfiguration:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .metadata.annotations.template\n      - '.webhooks[]?.clientConfig.caBundle'\n      - '.webhooks'\ncert-manager.io/Certificate:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .spec.duration\nnetworking.k8s.io/Ingress:\n  health.lua: |\n    hs = {}\n    hs.status = \"Healthy\"\n    return hs\n"` |  |
| argo-cd.configs.params."server.insecure" | bool | `true` |  |
| argo-cd.configs.params."server.rootpath" | string | `"/argocd"` |  |
| argo-cd.configs.rbac."policy.csv" | string | `"g, ARGOCD-ADMIN, role:admin\ng, SYSTEM-ADMINISTRATOR, role:admin\n"` |  |
| argo-cd.configs.url | string | `"https://{{ .Values.server.ingress.hostname }}{{ .Values.server.ingress.path }}"` |  |
| argo-cd.controller.env[0].name | string | `"TZ"` |  |
| argo-cd.controller.env[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.controller.replicas | int | `2` |  |
| argo-cd.controller.resources.limits.cpu | string | `"750m"` |  |
| argo-cd.controller.resources.limits.ephemeral-storage | string | `"2Gi"` |  |
| argo-cd.controller.resources.limits.memory | string | `"1536Mi"` |  |
| argo-cd.controller.resources.requests.cpu | string | `"500m"` |  |
| argo-cd.controller.resources.requests.ephemeral-storage | string | `"50Mi"` |  |
| argo-cd.controller.resources.requests.memory | string | `"1024Mi"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.fullnameOverride | string | `"argocd"` |  |
| argo-cd.global.domain | string | `"{{ .Values.server.ingress.hostname }}"` |  |
| argo-cd.global.logging.format | string | `"json"` |  |
| argo-cd.global.logging.level | string | `"warn"` |  |
| argo-cd.notifications.enabled | bool | `false` |  |
| argo-cd.repoServer.env[0].name | string | `"TZ"` |  |
| argo-cd.repoServer.env[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.repoServer.metrics.enabled | bool | `true` |  |
| argo-cd.repoServer.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.repoServer.replicas | int | `2` |  |
| argo-cd.repoServer.resources.limits.cpu | string | `"750m"` |  |
| argo-cd.repoServer.resources.limits.ephemeral-storage | string | `"2Gi"` |  |
| argo-cd.repoServer.resources.limits.memory | string | `"768Mi"` |  |
| argo-cd.repoServer.resources.requests.cpu | string | `"500m"` |  |
| argo-cd.repoServer.resources.requests.ephemeral-storage | string | `"50Mi"` |  |
| argo-cd.repoServer.resources.requests.memory | string | `"512Mi"` |  |
| argo-cd.server.env[0].name | string | `"TZ"` |  |
| argo-cd.server.env[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.server.env[1].name | string | `"ARGOCD_SERVER_ROOTPATH"` |  |
| argo-cd.server.env[1].value | string | `"{{ $path := .Values.server.ingress.path }}{{ if ($path | ne \"/\") }}{{ $path }}{{ end }}"` |  |
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| argo-cd.server.ingress.enabled | bool | `true` |  |
| argo-cd.server.ingress.hostname | string | `"SET_BY_TERRAFORM"` |  |
| argo-cd.server.ingress.path | string | `"/argocd"` |  |
| argo-cd.server.insecure | bool | `true` |  |
| argo-cd.server.metrics.enabled | bool | `true` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.replicas | int | `2` |  |
| policyException.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

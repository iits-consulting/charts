# argocd

![Version: 16.3.0](https://img.shields.io/badge/Version-16.3.0-informational?style=flat-square) ![AppVersion: 2.11.5](https://img.shields.io/badge/AppVersion-2.11.5-informational?style=flat-square)

This chart is used to bootstrap a Kubernetes cluster with `argocd`.
You can use this chart to deploy `argocd` through tools like `terraform`.

Usage example:

```hcl
resource "helm_release" "argocd" {
  name                  = "argocd"
  repository            = "https://charts.iits.tech"
  chart                 = "argocd"
  version               = "16.3.0"
  namespace             = "argocd"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  values                = [
    yamlencode({
      projects = {
        infrastructure-charts = {
          projectValues = {
            # Set this to enable stage values-$STAGE.yaml
            stage        = var.stage
            # Example values which are handed down to the project. Like this you can give over informations from terraform to argocd
            rootDomain  = var.domain_name
          }

          git = {
            password = var.git_token
            repoUrl  = "https://github.com/iits-consulting/otc-infrastructure-charts-template"
          }
        }
      }
    }
    )
  ]
}
```

In the project https://github.com/iits-consulting/otc-infrastructure-charts-template it expects a helm chart
named infrastructure-charts and will install everything from there.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | argo-cd | 6.6.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.config.rbac."policy.csv" | string | `"g, ARGOCD-ADMIN, role:admin\ng, SYSTEM-ADMINISTRATOR, role:admin\n"` |  |
| argo-cd.controller.extraEnvVars[0].name | string | `"TZ"` |  |
| argo-cd.controller.extraEnvVars[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.controller.kind | string | `"StatefulSet"` |  |
| argo-cd.controller.logFormat | string | `"json"` |  |
| argo-cd.controller.replicaCount | int | `2` |  |
| argo-cd.controller.resourcesPreset | string | `"medium"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.fullnameOverride | string | `"argocd"` |  |
| argo-cd.notifications.enabled | bool | `false` |  |
| argo-cd.repoServer.containerSecurityContext.seccompProfile.type | string | `"Unconfined"` |  |
| argo-cd.repoServer.extraEnvVars[0].name | string | `"TZ"` |  |
| argo-cd.repoServer.extraEnvVars[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.repoServer.logFormat | string | `"json"` |  |
| argo-cd.repoServer.replicaCount | int | `2` |  |
| argo-cd.repoServer.resourcesPreset | string | `"small"` |  |
| argo-cd.server.config."oidc.config" | string | `"name: OIDC\nissuer: $argocd-oidc:oidcURL\nclientID: $argocd-oidc:clientID\nclientSecret: $argocd-oidc:clientSecret\nrequestedScopes:\n  - openid\n  - profile\n  - email\n  - groups\nrequestedIDTokenClaims:\n  groups:\n    essential: true\n"` |  |
| argo-cd.server.config."resource.customizations" | string | `"# Ignores .data changes of all secrets with a vaultInjectionChecksum annotation\nargoproj.io/Application:\n ignoreDifferences: |\n    jqPathExpressions:\n      - '. | select(.metadata.annotations.parametersChecksum) | .spec.source.helm'\n      - '. | select(.metadata.annotations.valueFileChecksum) | .spec.source.helm'\n# Ignores caBundle and template changes of the following resources\nadmissionregistration.k8s.io/MutatingWebhookConfiguration:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .metadata.annotations.template\n      - '.webhooks'\napiextensions.k8s.io/CustomResourceDefinition:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .spec.conversion.webhookClientConfig.caBundle\nadmissionregistration.k8s.io/ValidatingWebhookConfiguration:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .metadata.annotations.template\n      - '.webhooks[]?.clientConfig.caBundle'\n      - '.webhooks'\ncert-manager.io/Certificate:\n  ignoreDifferences: |\n    jqPathExpressions:\n      - .spec.duration\nnetworking.k8s.io/Ingress:\n  health.lua: |\n    hs = {}\n    hs.status = \"Healthy\"\n    return hs\n"` |  |
| argo-cd.server.config.url | string | `"https://{{ .Values.server.ingress.hostname }}{{ .Values.server.ingress.path }}"` |  |
| argo-cd.server.extraEnvVars[0].name | string | `"TZ"` |  |
| argo-cd.server.extraEnvVars[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.server.extraEnvVars[1].name | string | `"ARGOCD_SERVER_ROOTPATH"` |  |
| argo-cd.server.extraEnvVars[1].value | string | `"{{ .Values.server.ingress.path }}"` |  |
| argo-cd.server.extraEnvVars[2].name | string | `"ARGOCD_SERVER_BASEHREF"` |  |
| argo-cd.server.extraEnvVars[2].value | string | `"{{ .Values.server.ingress.path }}"` |  |
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| argo-cd.server.ingress.enabled | bool | `true` |  |
| argo-cd.server.ingress.hostname | string | `"SET_BY_TERRAFORM"` |  |
| argo-cd.server.ingress.path | string | `"/argocd"` |  |
| argo-cd.server.insecure | bool | `true` |  |
| argo-cd.server.logFormat | string | `"json"` |  |
| argo-cd.server.replicaCount | int | `2` |  |
| policyException.enabled | bool | `true` |  |
| projects | string | `nil` | List of projects which you want to bootstrap |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

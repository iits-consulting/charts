# argocd

![Version: 21.1.0](https://img.shields.io/badge/Version-21.1.0-informational?style=flat-square) ![AppVersion: 3.5.1](https://img.shields.io/badge/AppVersion-3.5.1-informational?style=flat-square)

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
  version               = "21.1.0"
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
| https://argoproj.github.io/argo-helm | argo-cd | 10.3.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argo-cd.applicationSet.replicas | int | `2` |  |
| argo-cd.configs.cm."oidc.config" | string | refer to values.yaml | OIDC settings in a multiline string |
| argo-cd.configs.cm."resource.customizations.health.networking.k8s.io_Ingress" | string | `"hs = {}\nhs.status = \"Healthy\"\nreturn hs\n"` |  |
| argo-cd.configs.cm."resource.customizations.ignoreDifferences.admissionregistration.k8s.io_MutatingWebhookConfiguration" | string | `"# Ignores caBundle and template changes of the following resources\njqPathExpressions:\n  - .metadata.annotations.template\n  - '.webhooks'\n"` |  |
| argo-cd.configs.cm."resource.customizations.ignoreDifferences.admissionregistration.k8s.io_ValidatingWebhookConfiguration" | string | `"jqPathExpressions:\n  - .metadata.annotations.template\n  - '.webhooks[]?.clientConfig.caBundle'\n  - '.webhooks'\n"` |  |
| argo-cd.configs.cm."resource.customizations.ignoreDifferences.apiextensions.k8s.io_CustomResourceDefinition" | string | `"jqPathExpressions:\n  - .spec.conversion.webhookClientConfig.caBundle\n"` |  |
| argo-cd.configs.cm."resource.customizations.ignoreDifferences.argoproj.io_Application" | string | `"# Ignores .data changes of all secrets with a vaultInjectionChecksum annotation\njqPathExpressions:\n  - '. | select(.metadata.annotations.parametersChecksum) | .spec.source.helm'\n  - '. | select(.metadata.annotations.valueFileChecksum) | .spec.source.helm'\n"` |  |
| argo-cd.configs.cm."resource.customizations.ignoreDifferences.cert-manager.io_Certificate" | string | `"jqPathExpressions:\n  - .spec.duration\n"` |  |
| argo-cd.configs.params."applicationsetcontroller.policy" | string | `"sync"` |  |
| argo-cd.configs.params."server.basehref" | string | `"/argocd"` |  |
| argo-cd.configs.params."server.insecure" | bool | `true` |  |
| argo-cd.configs.params."server.rootpath" | string | `"/argocd"` |  |
| argo-cd.configs.rbac."policy.csv" | string | refer to values.yaml | RBAC settings in a multiline string |
| argo-cd.configs.rbac.scopes | string | `"[client_roles]"` |  |
| argo-cd.controller.env[0].name | string | `"TZ"` |  |
| argo-cd.controller.env[0].value | string | `"Europe/Berlin"` |  |
| argo-cd.controller.metrics.enabled | bool | `true` |  |
| argo-cd.controller.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.controller.replicas | int | `2` |  |
| argo-cd.controller.resources.limits.cpu | string | `"750m"` |  |
| argo-cd.controller.resources.limits.ephemeral-storage | string | `"2Gi"` |  |
| argo-cd.controller.resources.limits.memory | string | `"1536Mi"` |  |
| argo-cd.controller.resources.requests.cpu | string | `"500m"` |  |
| argo-cd.controller.resources.requests.ephemeral-storage | string | `"50Mi"` |  |
| argo-cd.controller.resources.requests.memory | string | `"1024Mi"` |  |
| argo-cd.dex.enabled | bool | `false` |  |
| argo-cd.fullnameOverride | string | `"argocd"` |  |
| argo-cd.global.domain | string | `"REPLACE_THIS/argocd"` |  |
| argo-cd.global.logging.format | string | `"json"` |  |
| argo-cd.global.logging.level | string | `"warn"` |  |
| argo-cd.global.networkPolicy.create | bool | `false` |  |
| argo-cd.notifications.enabled | bool | `false` |  |
| argo-cd.redis-ha.enabled | bool | `true` |  |
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
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| argo-cd.server.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| argo-cd.server.ingress.enabled | bool | `true` |  |
| argo-cd.server.ingress.hostname | string | `"REPLACE_THIS"` |  |
| argo-cd.server.ingress.path | string | `"/argocd"` |  |
| argo-cd.server.metrics.enabled | bool | `true` |  |
| argo-cd.server.metrics.serviceMonitor.enabled | bool | `true` |  |
| argo-cd.server.replicas | int | `2` |  |
| policyException.enabled | bool | `true` |  |
| prometheusRule.additionalLabels | object | `{}` |  |
| prometheusRule.enabled | bool | `true` |  |
| prometheusRule.rules.ApplicationDegraded.annotations.description | string | `"ArgoCD application {{ $labels.namespace }}/{{ $labels.name }} has health {{ $labels.health_status }}."` |  |
| prometheusRule.rules.ApplicationDegraded.annotations.summary | string | `"{{ $labels.name }} is {{ $labels.health_status }}"` |  |
| prometheusRule.rules.ApplicationDegraded.expr | string | `"argocd_app_info{project=\"infrastructure-charts\", health_status=~\"Degraded|Missing|Unknown\"}"` |  |
| prometheusRule.rules.ApplicationDegraded.for | string | `"30m"` |  |
| prometheusRule.rules.ApplicationDegraded.labels.severity | string | `"critical"` |  |
| prometheusRule.rules.ApplicationOutOfSync.annotations.description | string | `"ArgoCD application {{ $labels.namespace }}/{{ $labels.name }} is {{ $labels.sync_status }} despite auto-sync."` |  |
| prometheusRule.rules.ApplicationOutOfSync.annotations.summary | string | `"{{ $labels.name }} not synced"` |  |
| prometheusRule.rules.ApplicationOutOfSync.expr | string | `"argocd_app_info{project=\"infrastructure-charts\", sync_status!=\"Synced\", autosync_enabled=\"true\"}"` |  |
| prometheusRule.rules.ApplicationOutOfSync.for | string | `"2h"` |  |
| prometheusRule.rules.ApplicationOutOfSync.labels.severity | string | `"warning"` |  |
| prometheusRule.rules.ApplicationProgressingTooLong.annotations.description | string | `"ArgoCD application {{ $labels.namespace }}/{{ $labels.name }} has been Progressing for over 1h."` |  |
| prometheusRule.rules.ApplicationProgressingTooLong.annotations.summary | string | `"{{ $labels.name }} stuck in Progressing"` |  |
| prometheusRule.rules.ApplicationProgressingTooLong.expr | string | `"argocd_app_info{project=\"infrastructure-charts\", health_status=\"Progressing\"}"` |  |
| prometheusRule.rules.ApplicationProgressingTooLong.for | string | `"1h"` |  |
| prometheusRule.rules.ApplicationProgressingTooLong.labels.severity | string | `"warning"` |  |
| prometheusRule.rules.ApplicationSyncFailing.annotations.description | string | `"ArgoCD application {{ $labels.namespace }}/{{ $labels.name }} has recent failed syncs and is still not Synced."` |  |
| prometheusRule.rules.ApplicationSyncFailing.annotations.summary | string | `"{{ $labels.name }} sync failing"` |  |
| prometheusRule.rules.ApplicationSyncFailing.expr | string | `"increase(argocd_app_sync_total{project=\"infrastructure-charts\", phase=~\"Failed|Error\"}[1h]) > 0 and on (namespace, name) argocd_app_info{project=\"infrastructure-charts\", sync_status!=\"Synced\"}\n"` |  |
| prometheusRule.rules.ApplicationSyncFailing.for | string | `"30m"` |  |
| prometheusRule.rules.ApplicationSyncFailing.labels.severity | string | `"critical"` |  |
| prometheusRule.rules.ApplicationSyncStuck.annotations.description | string | `"ArgoCD application {{ $labels.namespace }}/{{ $labels.name }} has had a sync operation running for over 30m."` |  |
| prometheusRule.rules.ApplicationSyncStuck.annotations.summary | string | `"{{ $labels.name }} sync operation stuck"` |  |
| prometheusRule.rules.ApplicationSyncStuck.expr | string | `"argocd_app_info{project=\"infrastructure-charts\", operation=\"sync\"}"` |  |
| prometheusRule.rules.ApplicationSyncStuck.for | string | `"30m"` |  |
| prometheusRule.rules.ApplicationSyncStuck.labels.severity | string | `"critical"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

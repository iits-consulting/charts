# swagger-ui

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![AppVersion: 4.19.0](https://img.shields.io/badge/AppVersion-4.19.0-informational?style=flat-square)

Swagger is an open-source software framework backed by a large ecosystem of tools that helps developers design, build, document, and consume RESTful Web services.

**Homepage:** <https://swagger.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Denis Lavrushko | <denis.lavrushko@iits-consulting.de> | <https://github.com/behoof4mind> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `3` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| deployment.annotations | object | `{}` |  |
| deployment.extraEnv | string | `nil` |  |
| deployment.replicas | int | `1` |  |
| deployment.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| deployment.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"swaggerapi/swagger-ui"` |  |
| image.tag | string | `"v4.19.0"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` |  |
| ingress.path | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.timeoutSeconds | int | `10` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext.fsGroup | int | `2000` |  |
| podSecurityContext.runAsGroup | int | `1000` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `1000` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| podSecurityContext.supplementalGroups[0] | int | `9001` |  |
| resources | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.externalIPs | list | `[]` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.port | int | `8080` |  |
| service.type | string | `"NodePort"` |  |
| source.external | string | `""` |  |
| source.internal.path | string | `"spec/openapi-petstore.json"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

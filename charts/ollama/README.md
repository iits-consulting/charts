# ollama

![Version: 0.7.4](https://img.shields.io/badge/Version-0.7.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Get up and running with large language models locally.

## Installing the Chart with iits ArgoCD

```yaml
  ollama:
    namespace: ollama
    repoURL: "https://charts.my-domain.com"
    targetRevision: "0.7.4"
    valueFile: "value-files/ollama/values.yaml"
```

value-files/ollama/values.yaml

```yaml
ollama:
  ollama:
    gpu:
      enabled: "true"
  ingress:
    host: "ollama.my-domain.com"
    annotations:
      # Adds the oidc proxy upfront
      traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd, ollama-strip-prefix-ollama@kubernetescrd"
webui:
  env:
    OLLAMA_API_BASE_URL: "https://ollama.my-domain.com/api"
  ingress:
    annotations:
      # Adds the oidc proxy upfront
      traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd"
    host: "ollama.my-domain.com"
middleware:
  env:
    OLLAMA_URL: "http://ollama:11434"
    WEAVIATE_URL: "http://weaviate:80"
  ingress:
    annotations:
      # Adds the oidc proxy upfront
      traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd"
    host: "ollama.my-domain.com"
```

**Homepage:** <https://ollama.ai/>

## Requirements

Kubernetes: `^1.16.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| middleware.deployment.affinity | object | `{}` |  |
| middleware.deployment.env.OLLAMA_URL | string | `"http://ollama:11434"` |  |
| middleware.deployment.env.OPENAI_API_TOKEN | string | `""` |  |
| middleware.deployment.env.WEAVIATE_URL | string | `"http://weaviate:80"` |  |
| middleware.deployment.envFromSecret | string | `nil` |  |
| middleware.deployment.fullnameOverride | string | `""` |  |
| middleware.deployment.health.liveness.path | string | `"/middleware/api/chat/health"` |  |
| middleware.deployment.health.liveness.port | int | `8000` |  |
| middleware.deployment.health.readiness.path | string | `"/middleware/api/chat/health"` |  |
| middleware.deployment.health.readiness.port | int | `8000` |  |
| middleware.deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| middleware.deployment.image.repository | string | `"registry.gitlab.iits.tech/private/llm/llm-middleware"` |  |
| middleware.deployment.image.tag | string | `""` |  |
| middleware.deployment.imagePullSecrets | list | `[]` |  |
| middleware.deployment.nameOverride | string | `""` |  |
| middleware.deployment.podAnnotations | object | `{}` |  |
| middleware.deployment.podSecurityContext | string | `nil` |  |
| middleware.deployment.ports.http.port | int | `8000` |  |
| middleware.deployment.replicaCount | string | `"1"` |  |
| middleware.deployment.resources.limits.cpu | string | `"2000m"` |  |
| middleware.deployment.resources.limits.memory | string | `"2Gi"` |  |
| middleware.deployment.resources.requests.cpu | string | `"500m"` |  |
| middleware.deployment.resources.requests.memory | string | `"512Mi"` |  |
| middleware.deployment.securityContext | string | `nil` |  |
| middleware.deployment.volumeMounts | object | `{}` |  |
| middleware.deployment.volumes | object | `{}` |  |
| middleware.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| middleware.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| middleware.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| middleware.ingress.defaultIngress.backend.port.name | string | `"http"` |  |
| middleware.ingress.defaultIngress.enabled | bool | `true` |  |
| middleware.ingress.defaultIngress.path | string | `"/middleware"` |  |
| middleware.ingress.defaultIngress.tls.secretName | string | `"llm-cert"` |  |
| middleware.ingress.enabled | bool | `true` |  |
| middleware.ingress.host | string | `"llm.iits.tech"` |  |
| middleware.service.ports.http.port | int | `8000` |  |
| middleware.service.ports.http.targetPort | int | `8000` |  |
| middleware.serviceAccount.annotations | object | `{}` |  |
| middleware.serviceAccount.create | bool | `true` |  |
| middleware.serviceAccount.name | string | `""` |  |
| ollama.affinity | object | `{}` |  |
| ollama.autoscaling.enabled | bool | `false` |  |
| ollama.autoscaling.maxReplicas | int | `100` |  |
| ollama.autoscaling.minReplicas | int | `1` |  |
| ollama.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| ollama.env | string | `nil` |  |
| ollama.envSecretName | string | `nil` | set the secret where to take env from |
| ollama.fullnameOverride | string | `""` |  |
| ollama.image.pullPolicy | string | `"IfNotPresent"` |  |
| ollama.image.repository | string | `"ollama/ollama"` |  |
| ollama.image.tag | string | `""` |  |
| ollama.imagePullSecrets | list | `[]` |  |
| ollama.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| ollama.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ollama.ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"{{.Release.Namespace}}-strip-prefix-ollama@kubernetescrd"` |  |
| ollama.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ollama.ingress.enabled | bool | `true` |  |
| ollama.ingress.host | string | `nil` | Required, replace it with your host address |
| ollama.ingress.hosts[0].host | string | `"{{.Values.ollama.ingress.host}}"` |  |
| ollama.ingress.hosts[0].paths[0].path | string | `"/ollama"` |  |
| ollama.ingress.tls[0].hosts[0] | string | `"{{.Values.ollama.ingress.host}}"` |  |
| ollama.ingress.tls[0].secretName | string | `"llm-cert"` |  |
| ollama.ingress.traefikMiddlewareEnabled | string | `"true"` |  |
| ollama.livenessProbe.enabled | bool | `true` |  |
| ollama.livenessProbe.failureThreshold | int | `6` |  |
| ollama.livenessProbe.initialDelaySeconds | int | `60` |  |
| ollama.livenessProbe.path | string | `"/"` |  |
| ollama.livenessProbe.periodSeconds | int | `10` |  |
| ollama.livenessProbe.successThreshold | int | `1` |  |
| ollama.livenessProbe.timeoutSeconds | int | `5` |  |
| ollama.nameOverride | string | `""` |  |
| ollama.nodeSelector | object | `{}` |  |
| ollama.ollama.gpu | object | `{"enabled":true,"number":1}` | If you want to use GPU, set it to true |
| ollama.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` |  |
| ollama.persistentVolume.annotations."argocd.argoproj.io/sync-options" | string | `"Prune=false"` |  |
| ollama.persistentVolume.enabled | bool | `true` |  |
| ollama.persistentVolume.existingClaim | string | `""` |  |
| ollama.persistentVolume.size | string | `"200Gi"` |  |
| ollama.persistentVolume.storageClass | string | `""` |  |
| ollama.persistentVolume.subPath | string | `""` |  |
| ollama.persistentVolume.volumeMode | string | `""` |  |
| ollama.podAnnotations | object | `{}` |  |
| ollama.podLabels | object | `{}` |  |
| ollama.podSecurityContext | object | `{}` |  |
| ollama.readinessProbe.enabled | bool | `true` |  |
| ollama.readinessProbe.failureThreshold | int | `6` |  |
| ollama.readinessProbe.initialDelaySeconds | int | `30` |  |
| ollama.readinessProbe.path | string | `"/"` |  |
| ollama.readinessProbe.periodSeconds | int | `5` |  |
| ollama.readinessProbe.successThreshold | int | `1` |  |
| ollama.readinessProbe.timeoutSeconds | int | `3` |  |
| ollama.replicaCount | int | `1` |  |
| ollama.resources.limits.cpu | int | `4` |  |
| ollama.resources.limits.memory | string | `"16Gi"` |  |
| ollama.resources.requests.cpu | int | `2` |  |
| ollama.resources.requests.memory | string | `"8Gi"` |  |
| ollama.securityContext | object | `{}` |  |
| ollama.service.port | int | `11434` |  |
| ollama.service.type | string | `"ClusterIP"` |  |
| ollama.serviceAccount.annotations | object | `{}` |  |
| ollama.serviceAccount.automount | bool | `true` |  |
| ollama.serviceAccount.create | bool | `true` |  |
| ollama.serviceAccount.name | string | `""` |  |
| ollama.tolerations[0].effect | string | `"PreferNoSchedule"` |  |
| ollama.tolerations[0].key | string | `"gpu-node"` |  |
| ollama.tolerations[0].operator | string | `"Exists"` |  |
| ollama.volumeMounts | list | `[]` |  |
| ollama.volumes | list | `[]` |  |
| webui.affinity | object | `{}` |  |
| webui.autoscaling.enabled | bool | `false` |  |
| webui.autoscaling.maxReplicas | int | `100` |  |
| webui.autoscaling.minReplicas | int | `1` |  |
| webui.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| webui.env.MIDDLEWARE_API_BASE_URL | string | `"https://{{$.Values.webui.ingress.host}}/middleware/api"` |  |
| webui.env.OLLAMA_API_BASE_URL | string | `"https://{{$.Values.webui.ingress.host}}/ollama/api"` |  |
| webui.envSecretName | string | `nil` |  |
| webui.fullnameOverride | string | `"ollama-webui"` |  |
| webui.image.pullPolicy | string | `"IfNotPresent"` |  |
| webui.image.repository | string | `"registry.gitlab.iits.tech/private/llm/ollama-ui"` |  |
| webui.image.tag | string | `""` |  |
| webui.imagePullSecrets | list | `[]` |  |
| webui.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| webui.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| webui.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| webui.ingress.enabled | bool | `true` |  |
| webui.ingress.host | string | `nil` | Required, replace it with your host address |
| webui.ingress.hosts[0].host | string | `"{{.Values.webui.ingress.host}}"` |  |
| webui.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| webui.ingress.tls[0].hosts[0] | string | `"{{.Values.webui.ingress.host}}"` |  |
| webui.ingress.tls[0].secretName | string | `"ollama-cert"` |  |
| webui.livenessProbe.enabled | bool | `true` |  |
| webui.livenessProbe.failureThreshold | int | `6` |  |
| webui.livenessProbe.initialDelaySeconds | int | `60` |  |
| webui.livenessProbe.path | string | `"/"` |  |
| webui.livenessProbe.periodSeconds | int | `10` |  |
| webui.livenessProbe.successThreshold | int | `1` |  |
| webui.livenessProbe.timeoutSeconds | int | `5` |  |
| webui.nameOverride | string | `""` |  |
| webui.nodeSelector | object | `{}` |  |
| webui.podAnnotations | object | `{}` |  |
| webui.podLabels | object | `{}` |  |
| webui.podSecurityContext | object | `{}` |  |
| webui.readinessProbe.enabled | bool | `true` |  |
| webui.readinessProbe.failureThreshold | int | `6` |  |
| webui.readinessProbe.initialDelaySeconds | int | `30` |  |
| webui.readinessProbe.path | string | `"/"` |  |
| webui.readinessProbe.periodSeconds | int | `5` |  |
| webui.readinessProbe.successThreshold | int | `1` |  |
| webui.readinessProbe.timeoutSeconds | int | `3` |  |
| webui.replicaCount | int | `1` |  |
| webui.resources.limits.cpu | string | `"2000m"` |  |
| webui.resources.limits.memory | string | `"8192Mi"` |  |
| webui.resources.requests.cpu | string | `"1000m"` |  |
| webui.resources.requests.memory | string | `"4096Mi"` |  |
| webui.securityContext | object | `{}` |  |
| webui.service.port | int | `8080` |  |
| webui.service.type | string | `"ClusterIP"` |  |
| webui.serviceAccount.annotations | object | `{}` |  |
| webui.serviceAccount.automount | bool | `true` |  |
| webui.serviceAccount.create | bool | `true` |  |
| webui.serviceAccount.name | string | `""` |  |
| webui.tolerations | list | `[]` |  |
| webui.volumeMounts | list | `[]` |  |
| webui.volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

# iits-ollama-fullstack

![Version: 0.4.9](https://img.shields.io/badge/Version-0.4.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Setup private LLM RAG Cluster with (weaviate, Ollama & airbyte)

## Installing the Chart with iits ArgoCD

# Register the Chart

```yaml
  iits-ollama-fullstack:
    targetRevision: "0.4.9"
    namespace: ollama
    valueFile: "value-files/iits-ollama-fullstack/values.yaml"
```

value-files/iits-ollama-fullstack/values.yaml

```yaml
weaviate:
  service:
    type: "ClusterIP"
airbyte:
  fullnameOverride: "airbyte"
  webapp:
    ingress:
      enabled: true
      hosts:
        - host:
          paths:
            - path: "/"
              pathType: "Prefix"
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt
        traefik.ingress.kubernetes.io/router.entrypoints: websecure
        traefik.ingress.kubernetes.io/router.tls: "true"
  connector-builder-server:
    service:
      type: "ClusterIP"
ollama:
  replicaCount: 1

  image:
    repository: ollama/ollama
    pullPolicy: IfNotPresent
    # Overrides the image tag whose default is the chart appVersion.
    tag: ""

  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: "ollama"

  ollama:
    # -- If you want to use GPU, set it to true
    gpu:
      enabled: true
      number: 1

  ingress:
    enabled: true
    # -- Required values change this one
    # -- Required, replace it with your host address
    host:
    traefikMiddlewareEnabled: "true"
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt
      traefik.ingress.kubernetes.io/router.entrypoints: websecure
      traefik.ingress.kubernetes.io/router.tls: "true"
      traefik.ingress.kubernetes.io/router.middlewares: "{{.Release.Namespace}}-strip-prefix-ollama@kubernetescrd"
    hosts:
      - host: "{{.Values.ollama.ingress.host}}"
        paths:
          - path: /ollama
            pathType: Prefix
    tls:
      - hosts:
          - "{{.Values.ollama.ingress.host}}"
        secretName: "llm-cert"

  ## Configure resource requests and limits
  ## ref: http://kubernetes.io/docs/user-guide/compute-resources/
  ##
  resources:
    requests:
      memory: 8Gi
      cpu: 2
    limits:
      memory: 16Gi
      cpu: 4

  persistentVolume:
    enabled: true

    ## Ollama server data Persistent Volume annotations
    ##
    annotations:
      argocd.argoproj.io/sync-options: "Prune=false"

    ## Ollama server data Persistent Volume size
    ##
    size: 100Gi

  tolerations:
    - key: gpu-node
      operator: Exists
      effect: PreferNoSchedule
webui:
  replicaCount: 1

  image:
    repository: "registry.gitlab.iits.tech/private/llm/ollama-ui"
    pullPolicy: IfNotPresent
    tag: ""

  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: "ollama-webui"

  serviceAccount:
    create: true
    automount: true
    annotations: {}
    name: ""

  podAnnotations: {}
  podLabels: {}

  podSecurityContext: {}

  securityContext: {}

  service:
    type: ClusterIP
    port: 8080

  env:
    OLLAMA_API_BASE_URL: "https://{{$.Values.webui.ingress.host}}/ollama/api"

  envSecretName:

  ingress:
    enabled: true
    host:
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt
      traefik.ingress.kubernetes.io/router.entrypoints: websecure
      traefik.ingress.kubernetes.io/router.tls: "true"
    hosts:
      - host: "{{.Values.webui.ingress.host}}"
        paths:
          - path: /
            pathType: Prefix
    tls:
      - hosts:
          - "{{.Values.webui.ingress.host}}"
        secretName: "ollama-cert"

  resources:
    requests:
      memory: 4096Mi
      cpu: 1000m
    limits:
      memory: 8192Mi
      cpu: 2000m

  livenessProbe:
    enabled: true
    path: /
    initialDelaySeconds: 60
    periodSeconds: 10
    timeoutSeconds: 5
    failureThreshold: 6
    successThreshold: 1

  readinessProbe:
    enabled: true
    path: /
    initialDelaySeconds: 30
    periodSeconds: 5
    timeoutSeconds: 3
    failureThreshold: 6
    successThreshold: 1

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 100
    targetCPUUtilizationPercentage: 80

  volumes: []

  volumeMounts: []

  nodeSelector: {}

  tolerations: []

  affinity: {}
```

**Homepage:** <https://ollama.ai/>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://airbytehq.github.io/helm-charts | airbyte | 0.55.5 |
| https://otwld.github.io/ollama-helm/ | ollama | 0.19.0 |
| https://weaviate.github.io/weaviate-helm | weaviate | 16.8.7 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| airbyte.connector-builder-server.service.type | string | `"ClusterIP"` |  |
| airbyte.fullnameOverride | string | `"airbyte"` |  |
| airbyte.webapp.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| airbyte.webapp.ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| airbyte.webapp.ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| airbyte.webapp.ingress.enabled | bool | `true` |  |
| airbyte.webapp.ingress.hosts[0].host | string | `nil` |  |
| airbyte.webapp.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| airbyte.webapp.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ollama.fullnameOverride | string | `"ollama"` |  |
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
| ollama.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ollama.ingress.tls[0].hosts[0] | string | `"{{.Values.ollama.ingress.host}}"` |  |
| ollama.ingress.tls[0].secretName | string | `"llm-cert"` |  |
| ollama.ingress.traefikMiddlewareEnabled | string | `"true"` |  |
| ollama.nameOverride | string | `""` |  |
| ollama.ollama.gpu | object | `{"enabled":true,"number":1}` | If you want to use GPU, set it to true |
| ollama.persistentVolume.annotations."argocd.argoproj.io/sync-options" | string | `"Prune=false"` |  |
| ollama.persistentVolume.enabled | bool | `true` |  |
| ollama.persistentVolume.size | string | `"100Gi"` |  |
| ollama.replicaCount | int | `1` |  |
| ollama.resources.limits.cpu | int | `4` |  |
| ollama.resources.limits.memory | string | `"16Gi"` |  |
| ollama.resources.requests.cpu | int | `2` |  |
| ollama.resources.requests.memory | string | `"8Gi"` |  |
| ollama.tolerations[0].effect | string | `"PreferNoSchedule"` |  |
| ollama.tolerations[0].key | string | `"gpu-node"` |  |
| ollama.tolerations[0].operator | string | `"Exists"` |  |
| weaviate.service.type | string | `"ClusterIP"` |  |
| webui.affinity | object | `{}` |  |
| webui.autoscaling.enabled | bool | `false` |  |
| webui.autoscaling.maxReplicas | int | `100` |  |
| webui.autoscaling.minReplicas | int | `1` |  |
| webui.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
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
| webui.ingress.host | string | `nil` |  |
| webui.ingress.hosts[0].host | string | `"{{.Values.webui.ingress.host}}"` |  |
| webui.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| webui.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
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

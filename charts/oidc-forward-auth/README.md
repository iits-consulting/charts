# oidc-forward-auth

![Version: 1.7.0](https://img.shields.io/badge/Version-1.7.0-informational?style=flat-square)

Forward Auth proxy with gogatekeeper. It replaces the old proxy mechanism

## Installing the Chart with iits ArgoCD

```yaml
charts:
  oidc-forward-auth:
    namespace: routing
    targetRevision: "1.7.0"
    parameters:
      gatekeeper.config.client-id: "${vault:whatever/data/keycloak/keycloak_proxy_admin#client_id}"
      gatekeeper.config.client-secret: "${vault:whatever/data/keycloak/keycloak_proxy_admin#client_secret}"
      gatekeeper.config.encryption-key: "${vault:whatever/data/keycloak/keycloak_proxy_admin#encryption-key}"
      gatekeeper.config.discovery-url: "https://{{.Values.projectValues.authDomain}}/realms/{{.Values.projectValues.context}}"
      ingress.host: "my.protected.domain"
```

## Then use it like this

```yaml
ingress:
  enabled: true
  # -- Mandatory, replace it with your host address
  host:
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
    #namespace-name@kubernetescrd
    traefik.ingress.kubernetes.io/router.middlewares: routing-oidc-forward-auth@kubernetescrd
  # Creates default Ingress with tls and the given host from .Values.ingress.host
  defaultIngress:
    enabled: true
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://gogatekeeper.github.io/helm-gogatekeeper | gatekeeper | 0.1.51 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| gatekeeper.config.client-id | string | `nil` | Required: client id used to authenticate to the oauth service |
| gatekeeper.config.client-secret | string | `nil` | Required: client secret used to authenticate to the oauth service |
| gatekeeper.config.discovery-url | string | `nil` | Required: discovery url to retrieve the openid configuration, i.e. "https://keycloak.example.com/realms/<realm>" |
| gatekeeper.config.enable-authorization-header | bool | `false` |  |
| gatekeeper.config.enable-compression | bool | `true` |  |
| gatekeeper.config.enable-default-deny | bool | `false` |  |
| gatekeeper.config.enable-encrypted-token | bool | `false` | enable encryption for the access tokens |
| gatekeeper.config.enable-json-logging | bool | `true` |  |
| gatekeeper.config.enable-logging | bool | `false` |  |
| gatekeeper.config.enable-logout-redirect | bool | `true` |  |
| gatekeeper.config.enable-metrics | bool | `false` |  |
| gatekeeper.config.enable-refresh-tokens | bool | `true` |  |
| gatekeeper.config.enable-request-id | bool | `true` |  |
| gatekeeper.config.enable-token-header | bool | `false` |  |
| gatekeeper.config.encryption-key | string | `nil` | optional: encryption key used to encryption the session state |
| gatekeeper.config.listen | string | `"0.0.0.0:3000"` |  |
| gatekeeper.config.listen-admin | string | `":4000"` |  |
| gatekeeper.config.no-proxy | bool | `true` |  |
| gatekeeper.config.no-redirects | bool | `false` |  |
| gatekeeper.config.preserve-host | bool | `true` |  |
| gatekeeper.config.resources[0].require-any-role | bool | `true` |  |
| gatekeeper.config.resources[0].uri | string | `"/*"` |  |
| gatekeeper.config.server-read-timeout | string | `"10s"` |  |
| gatekeeper.config.server-write-timeout | string | `"10s"` |  |
| gatekeeper.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| gatekeeper.containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| gatekeeper.image.tag | string | `"3.0.2"` |  |
| gatekeeper.livenessProbe.enabled | bool | `true` |  |
| gatekeeper.replicaCount | int | `2` |  |
| gatekeeper.resources.limits.cpu | string | `"100m"` |  |
| gatekeeper.resources.limits.memory | string | `"128Mi"` |  |
| gatekeeper.resources.requests.cpu | string | `"10m"` |  |
| gatekeeper.resources.requests.memory | string | `"16Mi"` |  |
| gatekeeper.strategy.type | string | `"RollingUpdate"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | string | `nil` | Required, replace it with your host address |
| ingress.hosts[0].host | string | `"{{ .Values.ingress.host }}"` |  |
| ingress.hosts[0].paths[0].path | string | `"/oauth"` |  |
| middleware.addAuthCookiesToResponse[0] | string | `"kc-access"` |  |
| middleware.addAuthCookiesToResponse[1] | string | `"kc-state"` |  |
| middleware.address | string | `"http://{{ include \"oidc-forward-auth.fullname\" $ }}-gatekeeper.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.gatekeeper.service.proxy.port }}"` |  |
| middleware.authRequestHeaders[0] | string | `"Accept"` |  |
| middleware.authRequestHeaders[1] | string | `"Authorization"` |  |
| middleware.authRequestHeaders[2] | string | `"Cookie"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

## Deploy the helm chart like this:

```yaml
charts:
  oidc-forward-auth:
    namespace: routing
    targetRevision: "1.0.0"
    parameters:
      gatekeeper.config.client-id: "${vault:whatever/data/keycloak/keycloak_proxy_admin#client_id}"
      gatekeeper.config.client-secret: "${vault:whatever/data/keycloak/keycloak_proxy_admin#client_secret}"
      gatekeeper.config.discovery-url: "https://{{.Values.projectValues.authDomain}}/realms/{{.Values.projectValues.context}}"
      ingress.host: "my.protected.domain"
```

## Then use it like this


```yaml
ingress:
  enabled: true
  host: "REPLACE_ME"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
    #namespace-name@kubernetescrd
    traefik.ingress.kubernetes.io/router.middlewares: routing-oidc-forward-auth@kubernetescrd
  hosts:
    - host: "{{.Values.ingress.host}}"
      paths:
        - path: /
  tls:
    - hosts:
        - "{{.Values.ingress.host}}"
```
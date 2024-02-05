## Deploy the helm chart like this:

```yaml
charts:
  oidc-forward-auth:
    namespace: routing
    targetRevision: "1.0.0"
    parameters:
      ingress.host: "my.protected.domain"
```
# Usage inside infrastructure-charts

```yaml
  iits-ollama-fullstack:
    targetRevision: "0.1.1"
    namespace: ollama
    valueFile: "value-files/iits-ollama-fullstack/values.yaml"
```


value-files/iits-ollama-fullstack/values.yaml

```yaml
ingress:
  airbyte:
    host: "airbyte.ollama.my-domain.com"
    annotations:
      # Adds the oidc proxy upfront
      traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd"
ollama:
  ollama:
    ollama:
      gpu:
        enabled: "true"
    ingress:
      host: "ollama.my-domain.com"
      annotations:
        # Adds the oidc proxy upfront
        traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd"
  webui:
    env:
      OLLAMA_API_BASE_URL: "https://ollama.my-domain.com/api"
    ingress:
      annotations:
        # Adds the oidc proxy upfront
        traefik.ingress.kubernetes.io/router.middlewares: "ollama-oidc-forward-auth-ollama@kubernetescrd"
      host: "ollama.my-domain.com"
```
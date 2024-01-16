# Usage inside infrastructure-charts

```yaml
  ollama:
    namespace: ollama
    repoURL: "https://charts.my-domain.com"
    targetRevision: "0.6.2"
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
```
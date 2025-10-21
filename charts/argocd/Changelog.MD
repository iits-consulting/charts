# Changelog

## Chart Versions

### 18.2.0

- Fixing bugs in the values.yaml which appeared after changing the dependency chart. Because of this, some configs weren't taking effect
- Updating dependency chart to latest 8x. version, specifically 8.6.4 - this updates argocd to 3.1.8

### 18.1.1

- Explicitly set the params `server.insecure: true` and `server.rootpath: "/argocd"` to fix ingress
- Use YAML anchor on `server.rootpath` and `server.ingress.path`
- Removed env `ARGOCD_SERVER_ROOTPATH` and old `insecure: true`

### 18.1.0

- Update Argo-cd helm chart dependency to 8.5.0 which includes ArgoCD in Version 3.1.5

### 18.0.0

- **Breaking:** Switch from Bitnami to Argo Project implementation of ArgoCD
- Converted `values.yaml` to ArgoProj requirements (actual configuration was kept as good as possible)
- Reenabled `policyException` in values

### 17.0.0

- **Breaking:** Split ArgoCD setup and ArgoCD configuration in two different repositories. To get the same setup as before, add the argocd-apps repo in Version 1.0.0 with the same code as additional chart

### 16.3.3

- AppVersion update to 2.14.4

### 16.3.2

- AppVersion update to 2.13.4
- Added the possibility to set the `enableOCI` flag on the helm-registries

Example of oci Helm Charts:

```hcl
infrastructure-charts = {
  helmRegistries = {
    bitnamiCharts = {
      url       = "registry-1.docker.io/bitnamicharts"
      enableOCI = true
    }
  }
  ...
}
```

### 16.3.1

- AppVersion update to 2.12.4
- No other migrations necessary

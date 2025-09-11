# Changelog

## Chart Versions

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

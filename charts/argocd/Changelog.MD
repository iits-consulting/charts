# Changelog

## Chart Versions

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

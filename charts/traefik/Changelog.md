# Changelog

## Chart Versions

### 35.2.0

- Update to traefik 3.3.6
  - There were changes in the CRDs of the Traefik in the base chart.
  - Check the [Release Notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v35.2.0) of traefik for the relevant migrations.
    - Or simply use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer) for crd management.

### 34.2.0

- Updates to traefik 3.3.3
  - There were changes in the CRDs of the Traefik in the base chart.
  - Check the [Release Notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v34.2.0) of traefik for the relevant migrations.
    - Or simply use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer) for crd management.

### 33.2.1

- Updates to traefik 3.2.5
  - There were changes in the CRDs of the Traefik in the base chart.
  - Check the [Release Notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v33.2.1) of traefik for the relevant migrations.
    - Or simply use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer) for crd management.

### 31.1.1

- Updates to AppVersion 3.1.6
- There were breaking changes for the Traefik Hub, if you use it, update your CRDs.

### 30.x -> 31.0.0

- Updates to traefik 3.1.2
  - There were changes in the CRDs of the Traefik hub in the base chart.
  - If you use it, check the [Release Notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v31.0.0) of traefik for the relevant migrations.
    - Or simply use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer) for crd management.

### 29.x -> 30.0.0

- Updates to traefik 3.1.1
  - There were breaking changes in the configuration of the gateway in the base chart.
  - If you use it, check the [Release Notes](https://github.com/traefik/traefik-helm-chart/releases/tag/v30.0.0) of traefik for the relevant changes.
  - If you use a custom RBAC see the [Migration Guide](https://doc.traefik.io/traefik/v3.1/migration/v3/#v30-to-v31) for relevant migrations.

### 28.2.x -> 29.0.1

⚠️ **Important Information** ⚠️

Per Traefik release notes:

- [v29.0.0](https://github.com/traefik/traefik-helm-chart/releases/tag/v29.0.0)
- [v29.0.1](https://github.com/traefik/traefik-helm-chart/releases/tag/v29.0.1)

If you use the Gateway API with traefik you should update your CRD's.

If you use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer)
you can either manually update the chart version to `29.0.1` or use a newer version of the crd-installer itself.

If you are not using the Gateway API, no additional changes are necessary.

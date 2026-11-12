# Changelog

All notable changes to this chart are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [22.0.0] - 2026-11-10

> Breaking change, requires the Kyverno chart 4.0.0 or newer (CEL policies).

### Added

- `policyException.namespace`: namespace of the PolicyException, defaults to the release namespace. Kyverno must read exceptions from it (`kyverno.features.policyExceptions.namespace`)
- `policyException.labels` and `policyException.annotations`: labels and annotations of the PolicyException; annotations are merged with the defaults from `values.yaml`

### Changed

- **Breaking:** the PolicyException is now a `policies.kyverno.io/v1` PolicyException (CEL). `kyverno.io/v2` exceptions do not apply to CEL policies. It is created in the release namespace unless `policyException.namespace` is set

## [21.1.0] - 2026-10-15

### Added

- `PrometheusRule` template for alerting on ArgoCD applications (disabled by default), with a default set of rules
- Metric collection for the ArgoCD controller

## [21.0.0] - 2026-08-19

### Changed

- AppVersion upgrade to 3.5.1
- **Breaking:** new selector on deployment `argocd-redis-ha-haproxy` which cannot be updated in place. Upgrade steps:
  1. disable self-heal on ArgoCD
  2. orphan delete the deployment `argocd-redis-ha-haproxy`
  3. sync the new version of ArgoCD (creates new `argocd-redis-ha-haproxy` deployment and pods for it)
  4. manually delete the OLD replicaset directly on cluster
  5. enable self-heal on ArgoCD

## [20.1.1] - 2026-06-02

### Security

- AppVersion upgrade to 3.2.12 to fix security issues

## [20.1.0] - 2026-05-18

### Changed

- AppVersion upgrade to 3.2.11

## [20.0.0] - 2026-02-25

### Changed

- **Breaking:** adjust the default RBAC role settings to match a new keycloak oidc pattern

## [19.0.0] - 2025-12-05

### Added

- Redis HA setup instead of Redis single node deployment

### Changed

- **Breaking:** HA setup as default, requires at least three different cluster nodes (see [this note](https://argo-cd.readthedocs.io/en/stable/operator-manual/high_availability/) in the ArgoCD docs)
- Run with 2 applicationSet-controller replicas per default

## [18.2.0] - 2025-10-24

### Changed

- Update dependency chart to the latest 8.x version, specifically 8.6.4 (ArgoCD 3.1.8)

### Fixed

- Bugs in `values.yaml` which appeared after changing the dependency chart, some configs were not taking effect

## [18.1.1] - 2025-10-15

### Fixed

- Ingress: explicitly set `server.insecure: true` and `server.rootpath: "/argocd"`
- Use YAML anchor on `server.rootpath` and `server.ingress.path`

### Removed

- Env `ARGOCD_SERVER_ROOTPATH` and the old `insecure: true`

## [18.1.0] - 2025-09-25

### Changed

- Update Argo-cd helm chart dependency to 8.5.0 (ArgoCD 3.1.5)

## [18.0.0] - 2025-09-17

### Added

- `policyException` is enabled again in values

### Changed

- **Breaking:** switch from Bitnami to the Argo Project implementation of ArgoCD
- Converted `values.yaml` to ArgoProj requirements (actual configuration was kept as far as possible)

## [17.0.0] - 2025-09-11

### Changed

- **Breaking:** split ArgoCD setup and ArgoCD configuration into two repositories. To get the same setup as before, add the argocd-apps repo in version 1.0.0 with the same code as additional chart

## [16.3.3] - 2025-04-29

### Changed

- AppVersion update to 2.14.4

## [16.3.2] - 2025-02-03

### Added

- Possibility to set the `enableOCI` flag on the helm-registries

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

### Changed

- AppVersion update to 2.13.4

## [16.3.1] - 2024-10-14

### Changed

- AppVersion update to 2.12.4, no other migrations necessary

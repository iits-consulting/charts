# Changelog

All notable changes to this chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-06-16

### Changed
- [BREAKING] Disabled the bundled `common.externalSecret` integration by default. Consumers that want this chart to create the operator credential `ExternalSecret` must now explicitly set `common.externalSecret.enabled=true`.

## [1.0.0] - 2026-06-12

### Added
- Initial release of the `ext-postgres-operator` chart.
- Added an IITS wrapper around the upstream `movetokube/postgres-operator` chart.
- Added dependency on upstream `ext-postgres-operator` chart `3.0.0` (app `v2.4.0`).
- Added dependency on the IITS `common` chart `0.3.1` for External Secrets integration.
- Added ESO-driven secret provisioning for operator root credentials sourced from Vault.
- Added default templating for the operator's required `POSTGRES_*` environment variables, including:
  - `POSTGRES_HOST`
  - `POSTGRES_USER`
  - `POSTGRES_PASS`
  - `POSTGRES_URI_ARGS`
  - `POSTGRES_CLOUD_PROVIDER`
  - `POSTGRES_DEFAULT_DATABASE`
- Added configurable Vault key mappings for credential fields.
- Added support for using an existing Kubernetes Secret via `ext-postgres-operator.existingSecret`.
- Added support for multi-instance operator deployments through `POSTGRES_INSTANCE`.
- Added chart documentation covering dependencies, values, ArgoCD sync flow, consumer examples, and multi-instance deployment patterns.

[1.0.0]: https://github.com/iits-consulting/charts/releases/tag/ext-postgres-operator-1.0.0
[2.0.0]: https://github.com/iits-consulting/charts/compare/ext-postgres-operator-1.0.0...ext-postgres-operator-2.0.0

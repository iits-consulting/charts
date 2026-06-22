# Changelog

All notable changes to this chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [9.3.5-eso] - 2026-06-22

### Added
- ESO mode via the IITS `common` chart: setting `common.externalSecret.enabled=true` replaces the bash `generate-passwords` Job and the static basic-auth Secrets with a single ExternalSecrets `Password` generator plus a per-user push/pull round-trip against a configurable secret store (Vault). Disabled by default, so existing installs are unaffected.
- Dependency on the IITS `common` chart `0.4.0`.
- `common.externalSecret.secretStore` to point all ESO resources at a `ClusterSecretStore`/`SecretStore` (defaults to `kind: ClusterSecretStore`, `name: vault`).
- Per-user Vault mapping through `auth.users.<user>.path` and optional `auth.users.<user>.property` (pack multiple users into one Vault secret).
- `generatePasswords.spec` to configure the password generation policy (`length`, `digits`, `symbols`, `noUpper`, `allowRepeat`); `length` also feeds the bash job default.
- `generatePasswords.refreshInterval` to control how often the per-user push/pull secrets reconcile in ESO mode.
- ESO support for backup secure settings via `backup.path`: secure settings are pulled from Vault instead of being inlined.
- `values.schema.json` for values validation, plus template-side `validation.yaml` guarding ESO configuration.
- Helm unit tests covering elasticsearch, elasticsearch-users, external-secrets, generate-passwords, backup secure-settings, and validation.
- `MIGRATION.md` section documenting how to migrate an existing install to ESO mode (pre-seeding Vault, preconditions, verification, and rollback).

### Changed
- The Filebeat/Kibana `checksum/users` annotation that triggers a rollout on user-credential changes now adapts to the mode. In non-ESO mode it keeps the previous behavior (hashes the rendered Kubernetes user Secret). In ESO mode there is no Helm-generated Secret, so it hashes the `auth.users` values instead.
- Moved OTC volume helpers into `_helpers.tpl`.

> **Note:** In ESO mode the `checksum/users` annotation is derived from chart values, not from the live secret content. Because passwords round-trip through Vault, changing a password directly in Vault will **not** roll Filebeat/Kibana. The pods keep using the previously injected value until they are restarted by another means (e.g. a chart value change or a manual rollout).

## [9.3.5] - 2026-06-23

### Changed
- Updated the ECK operator (`eck-operator`) to `3.4.0`.
- Updated the Elastic stack (`appVersion`) to `9.3.5`.

## [9.3.3] - 2026-05-04

### Changed
- Updated the ECK operator (`eck-operator`) to `3.3.2`.
- Updated the Elastic stack (`appVersion`) to `9.3.3`.

## [9.0.5-bitnamilegacy] - 2025-10-13

### Changed
- Switched the Bitnami image used by the password-generation job to `docker.io/bitnamilegacy/kubectl` (temporary solution to keep the chart functional; migrate to another image in a later release).

## [9.0.1] - 2025-05-28

### Changed
- [BREAKING] Updated the Elastic stack (`appVersion`) to `9.0.1`.

> **Important:** The upgrade to `9.x` requires a specific upgrade path (the latest upgrade path can be found [here](https://www.elastic.co/docs/deploy-manage/upgrade/prepare-to-upgrade#prepare-upgrade-from-8.x)). Before installing `9.0.0`, you must first update to `8.18.1`, otherwise the upgrade will fail. Use version `8.18.1-fb-migr-filestream` from our stack for an easy upgrade.

## [8.18.1-fb-migr-filestream] - 2025-05-28

### Added
- Added the Filebeat `filestream` input and set the `take_over` tag as part of the migration from the deprecated `container` input.

### Changed
- The `container` input for Filebeat was deprecated in `7.16` and is fully disabled in `9.0.0` (see [elastic/beats#42295](https://github.com/elastic/beats/pull/42295)). Following the official [migration guide](https://www.elastic.co/docs/reference/beats/filebeat/migrate-to-filestream), the `take_over` tag lets Filebeat separate logs created by the `container` input from the `filestream` input, avoiding errors and duplicated data. In `9.0.0` the `take_over` tag will be removed to complete the migration.

> **Important:** In preparation for the upgrade to `9.0.0`, this update must be installed as part of the upgrade path. Otherwise Filebeat will not be functional after upgrading to `9.0.0`.

## [8.18.1-fb-tolerations] - 2025-05-14

### Fixed
- Fixed a bug that caused tolerations rendering to fail for Filebeat.

## [8.18.1] - 2025-05-07

### Changed
- Updated the Elastic stack (`appVersion`) to `8.18.1`.
- Updated the Elastic operator to `3.0.0` in preparation for the `appVersion` upgrade to `9.0.0`.

[9.3.5-eso]: https://github.com/iits-consulting/charts/compare/elastic-operator-9.3.5...elastic-operator-9.3.5-eso
[9.3.5]: https://github.com/iits-consulting/charts/compare/elastic-operator-9.3.3...elastic-operator-9.3.5
[9.3.3]: https://github.com/iits-consulting/charts/compare/elastic-operator-9.0.5-bitnamilegacy...elastic-operator-9.3.3
[9.0.5-bitnamilegacy]: https://github.com/iits-consulting/charts/compare/elastic-operator-9.0.1...elastic-operator-9.0.5-bitnamilegacy
[9.0.1]: https://github.com/iits-consulting/charts/compare/elastic-operator-8.18.1-fb-migr-filestream...elastic-operator-9.0.1
[8.18.1-fb-migr-filestream]: https://github.com/iits-consulting/charts/compare/elastic-operator-8.18.1-fb-tolerations...elastic-operator-8.18.1-fb-migr-filestream
[8.18.1-fb-tolerations]: https://github.com/iits-consulting/charts/compare/elastic-operator-8.18.1...elastic-operator-8.18.1-fb-tolerations
[8.18.1]: https://github.com/iits-consulting/charts/releases/tag/elastic-operator-8.18.1

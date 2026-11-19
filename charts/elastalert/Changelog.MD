# Changelog

## Chart Versions

### 0.6.0

- Bump `elastalert2` to 2.32.0 (ElastAlert 2 app/image 2.24.0 → 2.32.0)
- Bump `common` to 0.4.0
- All namespaced resources of the `elastalert2` sub-chart now render an explicit `metadata.namespace`
- `common.externalSecret.*` values are now validated against a strict JSON schema (unknown keys fail the render)
- Unit test path adjusted to the new `common` template location (`templates/external-secrets/external-secret.yaml`)
- See [UPGRADE.md](UPGRADE.md) for the upgrade procedure

### 0.5.1

- Remove stray null `slack` key from the `kafkaTopicCreatedNotification` rule

### 0.3.0

- Update to AppVersion 2.20.0
- No Migrations necessary.

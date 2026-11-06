# Changelog

All notable changes to this chart will be documented in this file.

## [2.1.0] - 2026-11-05

### Added
- `volumeBindingMode` to control the `volumeBindingMode` of all `csi-disk-*` storage classes. Defaults to `Immediate` (unchanged). Set to `WaitForFirstConsumer` to defer EVS disk provisioning until a pod is scheduled, avoiding zone mismatches between the PV and the scheduled pod.

> **Note:** for an upgrade guide, refer to [UPGRADE.md](UPGRADE.md)

[2.1.0]: https://github.com/iits-consulting/charts/compare/cce-storage-classes-2.0.2...cce-storage-classes-2.1.0

# Changelog

All notable changes to this chart are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [23.0.0-bitnamilegacy] - 2026-11-10

> Breaking change, requires the Kyverno chart 4.0.0 or newer (CEL policies).

### Added

- `policyException.namespace`: namespace of the PolicyException, defaults to the release namespace. Kyverno must read exceptions from it (`kyverno.features.policyExceptions.namespace`)
- `policyException.labels` and `policyException.annotations`: labels and annotations of the PolicyException; annotations are merged with the defaults from `values.yaml`

### Changed

- **Breaking:** the PolicyException is now a `policies.kyverno.io/v1` PolicyException (CEL). `kyverno.io/v2` exceptions do not apply to CEL policies. It is created in the release namespace unless `policyException.namespace` is set

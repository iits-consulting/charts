# Changelog

All notable changes to this chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2026-06-016

### Changed

- Refactored externalSecret templates to be usable through `include` by callers.
- Consolidated `pull`/`push` spec defaults into the templates as the single source of truth; `values.yaml` now documents them as comments.

## [0.3.1] - 2026-05-05

### Fixed

- ExternalSecret `template.type` being read from the wrong values level (`$secretConfig.type` instead of `$secretConfig.template.type`).

## [0.3.0] - 2026-04-30

### Added

- `annotations` field on each secret/generator config — merged into resource `metadata.annotations`.

### Removed

- Hardcoded `argocd.argoproj.io/sync-wave` annotations from ExternalSecret/PushSecret/Password resources. Consumers needing sync ordering must now supply them via the per-secret/per-generator `annotations` field.

## [0.2.0] - 2026-04-28

### Added

- Advanced Templating v2 options to External Secrets.

## [0.1.0] - 2026-04-24

### Added

- Password Generator option to External Secrets.

## [0.0.1] - 2026-04-14

### Added

- Option for External Secrets resources managed by an External Secrets Operator.

[0.4.0]: https://github.com/iits-consulting/charts/compare/common-0.3.1...common-0.4.0
[0.3.1]: https://github.com/iits-consulting/charts/compare/common-0.3.0...common-0.3.1
[0.3.0]: https://github.com/iits-consulting/charts/compare/common-0.2.0...common-0.3.0
[0.2.0]: https://github.com/iits-consulting/charts/compare/common-0.1.0...common-0.2.0
[0.1.0]: https://github.com/iits-consulting/charts/compare/common-0.0.1...common-0.1.0
[0.0.1]: https://github.com/iits-consulting/charts/releases/tag/common-0.0.1

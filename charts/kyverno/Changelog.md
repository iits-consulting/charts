# Changelog

All notable changes to this chart are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - Unreleased

> Breaking changes, read [UPGRADE.md](UPGRADE.md) before upgrading.

### Added

- `values.schema.json`: unknown keys of a policy block, wrong types and invalid `validationAction` or `failurePolicy` fail at lint and install time
- Opt-in policies `disallowLatestTag`, `restrictIngressWildcard` and `requireIngressHttps` (`enabled: false`, `validationAction: Audit`)
- `failurePolicy` (`Fail` or `Ignore`) for every policy
- `validationAction` for `disallowEmptyIngressHost`
- `replaceImageRegistry.excludeNamespaces` and `disallowEmptyIngressHost.excludeIngresses`. `excludeNamespaces` and `excludeRegistries` take wildcards (`*`, `?`)
- `replaceImageRegistry.keepRepositoryPath` (default `true`)
- `autoInjectDockerPullSecrets.excludeNamespaces` (default `kube-system`, `kube-public`, `kube-node-lease`)
- `autoInjectDockerPullSecrets.injectOnly`: pull secrets that are only added to Pods, not cloned, for example created per namespace by an External Secrets `ClusterExternalSecret`
- `namespaces` (wildcards) on every `autoInjectDockerPullSecrets` entry, limits clone and injection to these namespaces
- `namespaceSelector` (`matchLabels`, `matchExpressions`) on every `autoInjectDockerPullSecrets` entry, limits clone and injection to namespaces with matching labels, ANDed with `namespaces`
- Rendering fails when a `common.externalSecret.pull.secrets` entry is cloned through `existingSecretRef` without `creationPolicy: Orphan`, opt out with `autoInjectDockerPullSecrets.allowOwnedExternalSecret: true`
- README section "Image pull secrets" (clone vs. inject, per-namespace targeting, External Secrets setup)
- `ingress.tls[]` (`hosts`, `secretName`, templates allowed, `[]` renders no `tls`)
- RBAC: `watch` on Secrets for the background controller, `get`, `list` and `watch` on `pods/ephemeralcontainers` for the reports controller

### Changed

- Update Kyverno chart to 3.10.0 (Kyverno 1.20.0), Kyverno-policies chart to 3.10.0 and policy-reporter chart to 3.11.2
- Kyverno 1.20 no longer executes legacy `kyverno.io` policies (`ClusterPolicy`, `Policy`, `CleanupPolicy`, `ClusterCleanupPolicy`, `PolicyException`) and rejects creating or updating them. Install and upgrade fail while any exist, checked at render time and by the pre-install/pre-upgrade hook Job `kyverno-check-legacy-policies`. Bypass: `kyverno.upgrade.acknowledgeLegacyPoliciesNotEnforced: true`
- All custom policies are CEL policies (`policies.kyverno.io/v1`) instead of `ClusterPolicy`
- `kyverno-policies` renders only `ValidatingPolicy`, the `kyverno-policies.policyType` default is removed (upstream dropped the legacy policy types)
- Pod Security Standards policies (from `kyverno-policies` 3.10.0): new `disallow-host-probes` (baseline), `disallow-capabilities-strict` requires `capabilities.drop: [ALL]` on every container, `require-run-as-nonroot` follows Pod Security Admission, `restrict-sysctls` and `restrict-apparmor-profiles` allow what Pod Security Admission allows, Windows Pods are exempt from the Linux-only checks. Default action stays `Audit`
- Kyverno Grafana dashboard has `policies.kyverno.io` rows, the old panels moved to "Legacy Policies (kyverno.io)"
- `autoInjectDockerPullSecrets` uses one `GeneratingPolicy` per cloned pull secret. Credentials are no longer part of a policy object: the chart creates the Secret `pull-secret-<key>` in the release namespace and the policies clone it
- Rename `disallowUnspecifiedDockerRegistries.registryUrls` to `allowedRegistries`. The image is also checked in its normalized form (`nginx` is `docker.io/library/nginx:latest`)
- `kyverno-policies.policyExclude` has no effect on ValidatingPolicies and fails the template, use `vpolExclude` (default `kube-system` for all policies) or `vpolExcludeByPolicy`
- `enforceSecurityContext` no longer sets a fixed UID and GID 1001, `runAsUser`, `runAsGroup` and `readOnlyRootFilesystem` are opt-in values. Containers that only set `capabilities.add` get `drop: [ALL]`
- `prependCustomImageRegistry` and `replaceImageRegistry` must not both be enabled
- `disallowUnsignedImages`: `ignoreTransparencyLog: false` is honored, `timeoutSeconds` is an integer, `imagesAndPublicKeyPairs` must not be empty
- Ingress and Traefik Middleware are skipped when `policy-reporter.install` or `policy-reporter.ui.enabled` is false, `ingress.host` is required

### Removed

- `replaceImageRegistry.sourceRegex`
- `autoInjectDockerPullSecrets.autogenControllers`
- `ingress.rules[].secretName`, replaced by `ingress.tls[]`
- RBAC: create, update, delete and patch on Secrets from the admission controller and on Pods from the background controller
- Label `iits-consulting.chart-creator/version` on the policy-reporter Ingress

### Fixed

- The policy-reporter Ingress renders `labels` correctly
- `prependCustomImageRegistry` prefixes initContainers and digest only images
- An empty `autoInjectDockerPullSecrets` no longer renders an empty secret name
- `disallowEmptyIngressHost` judges each rule

## [3.5.1] - 2026-10-20

### Fixed

- Set default policyType for the kyverno-policies to ensure backwards compatibility

## [3.5.0] - 2026-10-14 - YANKED

> [!WARNING]
> This release changes the default type of the policies in the kyverno-policies.
> Skip it and use 3.5.1 to keep backwards compatibility.

### Changed

- Update Kyverno chart to 3.9.1
- Update Kyverno-policies chart to 3.9.1
- Update policy-reporter chart to 3.11.0

## [3.4.0] - 2026-09-09

### Added

- Optional TLS secret reference to the Ingress

## [3.3.0] - 2026-05-06

### Added

- Common chart lib as dependency chart

## [3.2.2] - 2026-05-06

### Added

- Guard for `secretRef[*].name` being set, allowing empty `.namespace` to clone from a secret in the chart's namespace
- YAML document end clause (`---`) to template

### Fixed

- Template range loop for ClusterPolicy causing secrets to be cloned into all namespaces even when the `autoInjectDockerPullSecrets` feature was explicitly disabled

## [3.2.1] - 2026-04-27

### Fixed

- Handle naming collisions in imagePullSecrets

## [3.2.0] - 2026-02-23

### Added

- Reintroduce `autoInjectDockerPullSecrets.autogenControllers` that was removed in `7b4744466b49160aadd6a7c7f41527b606fe34e3`

### Changed

- Update Kyverno chart to 3.5.3
- Update Kyverno-policies chart to 3.5.3
- Update policy-reporter chart to 3.7.2

## [3.1.1] - 2025-11-11

### Fixed

- Cannot specify multiple image pull secrets due to missing YAML separator (`---`)

## [3.1.0] - 2025-09-25

### Changed

- Update Kyverno chart to 3.5.1
- Update Kyverno-policies chart to 3.5.1
- Update policy-reporter chart to 3.5.0

## [3.0.0] - 2025-09-17

### Added

- Use existing imagePullSecrets in the release namespace

### Changed

- **Breaking:** default of `autoInjectDockerPullSecrets.enabled` is now `false`

## [2.5.0] - 2025-09-15

### Changed

- Simplified mutating policy for security context enforcement

## [2.4.0] - 2025-05-07

### Changed

- Update Kyverno chart to 3.4.0
- Update Kyverno-policies to 3.4.0
- Update policy-reporter to 3.1.3

## [2.3.0] - 2025-03-27

### Changed

- Reworked the internal structure of the custom policies, some parameters changed, check your overrides
- Update Kyverno to chart 3.3.7 / appVersion 1.13.4
- Update Kyverno-policies to 3.3.4
- Update policy-reporter to 3.0.7

### Fixed

- Jobs were not counted as completed even if the underlying pod finished successfully

## [2.2.2] - 2025-02-12

### Changed

- PolicyExceptions are now enabled by default

## [2.2.1] - 2025-02-04

### Fixed

- Missing RBAC parameter for the admission controller

## [2.2.0] - 2025-02-04

> [!WARNING]
> - The CRDs changed, update them **before** upgrading.
> - Rolling updates do not work if you come from 2.1.x.
> - Uninstall the old version first, then update the CRDs and install the new version.

### Changed

- Update Kyverno chart to 3.3.4 / appVersion 1.13.2
- Update Kyverno-policies to 3.3.2
- Update policy-reporter to 3.0.0

## [2.1.1] - 2024-10-14

### Changed

- Update Kyverno chart to 3.2.7 / appVersion 1.12.6
- Update Kyverno-policies to 3.2.6
- Update policy-reporter to 2.24.2
- No migrations necessary

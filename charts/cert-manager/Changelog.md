# Changelog

All notable changes to this chart are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this chart adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-11-10

> Breaking change, requires the Kyverno chart 4.0.0 or newer (CEL policies).

### Added

- `policyException.namespace`: namespace of the PolicyException, defaults to the release namespace. Kyverno must read exceptions from it (`kyverno.features.policyExceptions.namespace`)
- `policyException.labels` and `policyException.annotations`: labels and annotations of the PolicyException; annotations are merged with the defaults from `values.yaml`

### Changed

- **Breaking:** the PolicyException is now a `policies.kyverno.io/v1` PolicyException (CEL). `kyverno.io/v2` exceptions do not apply to CEL policies. It is created in the release namespace unless `policyException.namespace` is set

## [1.22.0] - 2026-09-24

### Added

- Allow to modify the ACME Solver's Ingress template

## [1.21.0] - 2026-09-11

### Changed

- **Breaking:** `.Values.clusterIssuers.http` converted into a map, allowing multiple cluster issuers to be specified

## [1.20.1] - 2026-04-15

### Added

- Common chart lib as dependency chart

### Changed

- Update dependency chart cert-manager-webhook-opentelekomcloud back to the original repo 0.2.0
- Update dependency chart cert-manager to 1.20.1
- Updated Chart & App Version to 1.20.1

## [1.17.4-policy-exclusion] - 2025-09-15

### Changed

- Update dependency chart cert-manager-webhook-opentelekomcloud to v0.1.5-security-context
- Adjust policy exclusions to match the new chart

## [1.17.4] - 2025-09-08

### Changed

- Updated Chart & App Version to 1.17.4
- Secret creation for the OTC DNS clusterIssuer is optional based on values

## [1.17.2] - 2025-04-29

### Changed

- Updated Chart & App Version to 1.17.2

## [1.16.1] - 2024-10-14

### Changed

- Updated Chart & App Version to 1.16.1
- As indicated per [documentation](https://cert-manager.io/docs/releases/release-notes/release-notes-1.16/#helm) the base chart now includes a Helm schema, so unrecognised fields make the templating fail

## [1.1.0] - 2025-04-29

### Added

- ClusterIssuer for DNS01 Challenges on OTC
  - Set `clusterIssuer.dns01.enabled` to `true` to enable
  - Only configured for OTC
  - Requires the chart [cert-manager-webhook-opentelekomcloud](https://github.com/akyriako/cert-manager-webhook-opentelekomcloud)
    - Use the projectfactory-terraform module `cert-manager` for autoconfiguration
- `clusterIssuer.useStaging` (default `true`)
  - Reason: prevent hitting the ratelimit on the letsencrypt prod environment
  - Action: set to `false` after verifying the content of the test-certificate

### Changed

- **Breaking:** moved field `clusterIssuer.http.email` to `clusterIssuer.email`
  - Reason: added a new clusterIssuer for DNS01 challenges, prevent field duplication
  - Action: move existing config to `clusterIssuer.email`
- **Breaking:** moved field `clusterIssuer.http.name` to `clusterIssuer.http01.name`
  - Reason: adding a new clusterIssuer for DNS01 challenges
  - Action: if overridden, move existing config to `clusterIssuer.http01.name`
- **Breaking:** moved field `ingressClass` to `clusterIssuer.http01.ingressClass`
  - Reason: as this only applies to the http-issuer, it is moved to better reflect its context
  - Action: if overridden, move existing config to `clusterIssuer.http01.ingressClass`
- Dropped the deployment count of `cert-manager` back to its default value (1)
  - Reason: cert-manager requires a lease against `kube-system/cert-manager-controller`, so only a single Pod can function at a time anyway

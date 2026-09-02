# Upgrade to Version 1.21.1

Bumps the `cert-manager` dependency from v1.20.1 to v1.21.1 (one minor version, plus the
1.21.1 patch). No intermediate version boundaries need separate handling for this jump.

## Risk summary

| Area | Severity | Action | Step |
|---|---|---|---|
| Kubernetes version | Action required | Verify cluster runs a version v1.21 supports before upgrading | [1](#1-verify-kubernetes-version) |
| CRDs (externally managed) | Action required | Apply the v1.21.1 CRD manifests before/with the release | [2](#2-update-crds) |
| `serviceaccounts/token` RBAC for controller SA | Action required only if used | No action needed — this chart does not set `serviceAccountRef` to the controller's own ServiceAccount anywhere | [3](#3-tokenrequest-rbac-removal) |
| Challenge/Order RBAC on `cert-manager-edit` | Informational | No action needed — internal ACME implementation detail, not used by this chart's templates | [4](#4-challengeorder-rbac-tightening) |
| ServiceMonitor `targetPort`/`path` | Informational | No action needed — values were unused here; the hardcoded new defaults (`http-metrics`/`/metrics`) match this chart's service | [5](#5-servicemonitor-metrics-values-removed) |
| `enableGatewayAPI` deprecation | Informational | No action needed — Gateway API is not enabled in this chart | [6](#6-gateway-api-deprecation) |

## Pre-flight checklist

- [ ] Target cluster(s) run a Kubernetes version supported by cert-manager v1.21 (see step 1)
- [ ] Know how CRDs for this cert-manager install are currently managed (this chart has `crds.enabled: false`, i.e. CRDs are applied outside this chart)
- [ ] No custom RBAC/automation references `cert-manager-edit`'s Challenge/Order permissions or the controller ServiceAccount's `serviceaccounts/token` grant

## Steps

### 1. Verify Kubernetes version

cert-manager v1.21 tests against Kubernetes 1.33–1.36, up from v1.20's 1.32–1.35 range
(see [Supported Releases](https://cert-manager.io/docs/releases/)).

Action: confirm the target cluster(s) are on a supported Kubernetes version before rolling
this out. If a cluster is below 1.33, hold the upgrade until it's on a supported version.

### 2. Update CRDs

This chart does not install CRDs (`crds.enabled: false`); they're managed outside this
chart. cert-manager CRDs must be applied for the target release before/alongside the
Helm release, per the [cert-manager CRD instructions](https://cert-manager.io/docs/installation/upgrading/).

Action: apply the v1.21.1 CRD manifests via whatever process currently manages them in
this environment.

### 3. tokenrequest RBAC removal

v1.21 removes the `Role`/`RoleBinding` that previously granted the cert-manager
controller's own ServiceAccount permission to create `serviceaccounts/token`. This only
matters if an Issuer sets `serviceAccountRef.name` to the controller's own ServiceAccount
(e.g. for kubernetes.io/service-account-token-based auth) — this chart doesn't set
`serviceAccount.name` or configure any `serviceAccountRef` pointing at it.

Action: none for this chart's default configuration. If a downstream Issuer config was
added manually and references the controller SA for `serviceAccountRef`, add equivalent
RBAC before upgrading.

### 4. Challenge/Order RBAC tightening

The `cert-manager-edit` ClusterRole no longer grants `create` on Challenges or
`create`/`patch`/`update` on Orders (ACME-internal resources). This already shipped as a
backport in v1.20.3/v1.19.6, so if the previous deploy was already at ≥1.20.3 this isn't
new; this chart pinned exactly v1.20.1, so it is new here.

Action: none — nothing in this chart or its templates creates/edits Challenges or Orders
directly.

### 5. ServiceMonitor metrics values removed

`prometheus.servicemonitor.targetPort` and `prometheus.servicemonitor.path` (and
`prometheus.podmonitor.path`) were removed from the upstream chart's values schema; the
ServiceMonitor/PodMonitor now hardcode `targetPort: http-metrics` / `path: /metrics` (the
controller's metrics Service port was also renamed to `http-metrics`).

Action: none — this chart never overrode these keys, and the new hardcoded values match
what this chart's metrics Service already exposes. Verified by rendering the
ServiceMonitor with `cert-manager.prometheus.servicemonitor.enabled=true`.

### 6. Gateway API deprecation

Upstream deprecated `cert-manager.enableGatewayAPI` in favor of
`cert-manager.gatewayAPI.enabled` (old field still works but is marked for removal).

Action: none now — Gateway API is not enabled in this chart. If it's turned on in the
future, use the new nested `gatewayAPI.enabled` key, not `enableGatewayAPI`.

## Post-upgrade verification

- `helm template` / `helm lint` pass (done as part of this change)
- cert-manager, cainjector, webhook, and startupapicheck pods reach `Running`/`Completed`
- `kubectl get clusterissuer` shows the configured issuer(s) `Ready`
- Issue a test certificate and confirm it reaches `Ready`
- If `prometheus.servicemonitor.enabled` is set, confirm Prometheus is still scraping
  targets under the `http-metrics` port after the upgrade

## Rollback

Revert the `cert-manager` dependency version in `Chart.yaml` back to `v1.20.1`, run
`helm dependency update`, and re-apply. CRDs applied for v1.21.1 are backward-compatible
with v1.20.x resources, so no separate CRD rollback is required.

## References

- [cert-manager v1.21 release notes](https://cert-manager.io/docs/releases/release-notes/release-notes-1.21/)
- [cert-manager v1.21.0 GitHub release](https://github.com/cert-manager/cert-manager/releases/tag/v1.21.0)
- [cert-manager v1.21.1 GitHub release](https://github.com/cert-manager/cert-manager/releases/tag/v1.21.1)
- [cert-manager Supported Releases](https://cert-manager.io/docs/releases/)
- [cert-manager CRD upgrade instructions](https://cert-manager.io/docs/installation/upgrading/)

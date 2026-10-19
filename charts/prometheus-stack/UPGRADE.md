# Upgrade to Version 92.9.0

Bumps `kube-prometheus-stack` 88.3.0 → 92.9.0, `prometheus-blackbox-exporter`
11.17.2 → 11.20.0 and `common` 0.3.1 → 0.4.0. The kube-prometheus-stack jump crosses
four upstream major boundaries (89, 90, 91, 92); none of them needs to be applied
individually — upgrading straight to 92.9.0 is fine when the steps below are followed.

**The CRDs must be updated on the cluster before the chart is rolled out.**
The CRD upgrade job of `kube-prometheus-stack` should not be used for now, since it is still flagged as "preview" upstream.

## Risk summary

| Area | Severity | Action |
|---|---|---|
| prometheus-operator CRDs `v0.93.0` → `v0.94.1` | high | Apply CRDs before syncing, see [step 1](#1-install-the-new-crds-of-the-kube-prometheus-stack) |
| Revived `kubernetes-resources` alerts | medium | Expect new alerts to possibly fire, see [step 3](#3-things-to-check-before-you-sync) |
| Grafana chart values schema validation (chart v14) | low | Type-check project-level Grafana overrides, see [step 3](#3-things-to-check-before-you-sync) |
| New long-lived token Secret `<release>-prometheus-token` | low | None by default; review if token Secrets are restricted, see [step 3](#3-things-to-check-before-you-sync) |

## Pre-flight checklist

* [ ] Private/mirrored registry (if any) contains `grafana:13.2.4-distroless`, `prometheus:v3.15.0-distroless`, `alertmanager:v0.34.1`, `prometheus-operator:v0.94.1`, `blackbox-exporter:v0.29.0`

## 1. Install the new CRDs of the kube-prometheus-stack

Apply the prometheus-operator `v0.94.1` CRDs — all ten kinds, not just the ones
that currently have objects, because the operator watches all of them.

## 2. Things to check before you sync

* **Distroless images.** Grafana now also defaults to a `-distroless` tag with
  `readOnlyRootFilesystem: true` (`prometheus` and `node-exporter` already did since 85.x).
* **Revived kubernetes-resources alerts.** The vendored copies of `KubeCPUOvercommit`,
  `KubeMemoryOvercommit` and the quota alerts shipped by earlier versions of this chart
  referenced metrics that no longer exist, so they could never fire. From this version they
  are rendered from upstream with working expressions — on overcommitted clusters these
  alerts can start firing right after the sync. That is correct behavior, not a regression.
* **Long-lived token Secret.** The chart now renders a `kubernetes.io/service-account-token`
  Secret `<release>-prometheus-token`; the control-plane ServiceMonitors (kubelet, apiserver,
  coredns) authenticate through it. The token does not expire. Set
  `prometheusStack.prometheus.serviceAccount.createTokenSecret: false` and provide your own
  `authorization` blocks if this conflicts with your security policy.
* **One-time restarts.** Prometheus, Alertmanager, the operator and Grafana restart once on
  sync (new images, new default `nodeSelector: kubernetes.io/os: linux`).

**Action:** verify registry mirrors; announce possibly-new overcommit alerts to the team.

## 3. Roll out the chart

Apply the change in Helm and sync the ArgoCD application to `92.9.0`.
No resources are removed in this version, so no prune is required.

**Action:** sync.

## 4. Post-upgrade verification

* [ ] `kubectl get prometheusrule -n <namespace>` shows both `...-kubernetes-resources` (upstream) and `...-cpu-throttling-high` (customized)
* [ ] The `CPUThrottlingHigh` alert exists exactly once in Prometheus (threshold 75 %, `kube-system` excluded)
* [ ] Prometheus reports version v3.15.0, Alertmanager v0.34.1, Grafana 13.2.4
* [ ] Control-plane targets (kubelet, apiserver, coredns) are `up` in Prometheus — they now authenticate via the token Secret
* [ ] Grafana dashboards from the sidecar (folder structure) still load
* [ ] Blackbox/uptime probes still report (`probe_success` present) and the Blackbox Exporter pod runs v0.29.0 without config errors in its logs
* [ ] If External Secrets are enabled: the ExternalSecret resources are `SecretSynced` and the generated Secrets are unchanged

## Rollback

If you need to perform a rollback, roll the **application back first, then the CRDs**. The other way round leads to resources that don't have certain fields defined anymore.

Use `kubectl apply --server-side --force-conflicts` with the older CRD
files (`v0.93.0` for chart 88.3.0) to downgrade them to their older versions in line with your desired rollback version.

Note that rolling back restores the old vendored `kubernetes-resources` rules, whose
overcommit/quota alerts reference metrics that no longer exist and therefore stay silent.

## References

* [kube-prometheus-stack UPGRADE.md (From 88.x to 89.x … From 91.x to 92.x)](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/UPGRADE.md)
* [Grafana chart upgrade notes (To 13.0.0 / To 14.0.0)](https://github.com/grafana-community/helm-charts/tree/main/charts/grafana#to-1300)
* [prometheus-operator v0.94.1 CRDs](https://github.com/prometheus-operator/prometheus-operator/tree/v0.94.1/example/prometheus-operator-crd)
* [blackbox_exporter 0.29.0 changelog](https://github.com/prometheus/blackbox_exporter/blob/master/CHANGELOG.md)
* [common chart changelog](https://github.com/iits-consulting/charts/blob/main/charts/common/Changelog.md)

---

# Upgrade to Version 88.3.0

**The CRDs must be updated on the cluster before the chart is rolled out.**
The CRD upgrade job of `kube-prometheus-stack` should not be used for now, since it is still flagged as "preview" upstream.

## 1. Install the new CRDs of the kube-prometheus-stack

Apply the prometheus-operator `v0.93.0` CRDs — all ten kinds, not just the ones
that currently have objects, because the operator watches all of them:

```
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusagents.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_scrapeconfigs.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side --force-conflicts -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.93.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
```

`--force-conflicts` is required: without the flag the apply is refused.

Why it has to happen first: ArgoCD computes the diff before it applies anything.
The Alertmanager CR of 88.3.0 renders `spec.hostNetwork`, which does not exist
in the `v0.86.2` CRD schema, so the sync that would update the CRD can never be
computed and the app fails with:

```
ComparisonError: ... error building typed value from config resource:
.spec.hostNetwork: field not declared in schema
```

## 2. Roll out the chart

Apply the change in Helm and sync the ArgoCD application to `88.3.0`.

* **Sync with `Prune`.** Some resources like the Grafana `Role` and `RoleBinding` are removed in this version and need to be cleaned up.

## 3. Things to check before you sync

* **Distroless images.** From `kube-prometheus-stack` 85.x, `prometheus` and
  `node-exporter` default to `-distroless` tags. If images are pulled through a
  mirrored/private registry, the new tags have to be available there before the
  sync.
  Be aware that `kubectl exec ... -- sh` no longer works in those pods.

## Rollback

If you need to perform a rollback, roll the **application back first, then the CRDs**. The other way round leads to resources that don't have certain fields defined anymore.

Use `kubectl apply --server-side --force-conflicts` with the older CRD
files to downgrade them to their older versions in line with your desired Rollback version.

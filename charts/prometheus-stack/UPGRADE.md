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

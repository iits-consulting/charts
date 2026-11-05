# Upgrade to Version 2.1.0

- No changes required — `volumeBindingMode` defaults to `Immediate`, identical to the previous hardcoded behavior.
- To switch to `WaitForFirstConsumer` (recommended for any workload where the PV's zone must match the pod's, e.g. Elasticsearch data nodes — see the [Kubernetes docs on volume binding mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)): `volumeBindingMode` is **immutable** on an existing `StorageClass` object, so a plain `helm upgrade`/Argo sync will fail to apply the change to classes that already exist in the cluster.

  1. `kubectl delete storageclass <name>` for each affected `csi-disk-*` class (e.g. `csi-disk-ssd-retain-encrypted`). This only removes the provisioning template — it has no effect on PVs/PVCs already bound through it.
  2. Upgrade with `volumeBindingMode: "WaitForFirstConsumer"` set. The class is recreated fresh with the new mode.
  3. If deployed via ArgoCD: a normal sync after step 1 will recreate the resource (it apply-creates because the object no longer exists), no `Replace=true` sync option needed for this one-off change.

  Only PVCs created after the switch get the new zone-aware behavior; existing PVs and pods are unaffected either way.

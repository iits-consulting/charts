# Migration from elasticsearch to elastic-operator

Generally updates should just work in-place. But:

* Have a backup at hand - just in case
* Make sure that the persistent volumes of elasticsearch have "Retain" as their reclaim policy and wont get deleted at any point
* Check out the settings of the new chart. They should be compatible with the ones from elasticsearch chart (at least for the default config). But take a look at them and configure the chart. Some keys and locations of settings might have changed.
* tested from elasticsearch `8.5.1` to `9.0.0` (you can configure the version of elasticsearch in elastic-operator chart)
* check out the [docs](https://www.elastic.co/docs/deploy-manage/upgrade/prepare-to-upgrade) on how to prepare for an upgrade

## The migration process

**Note:** If you are using volumes that are managed by terraform you could also just delete the old elasticsearch and redeploy everything using the managed volume with the elastic-operator chart. Just make sure that the elasticsearch pods have the opportunity to **gracefully shutdown**.

### Otherwise you can use those steps as a guideline

1. Add sync window or ensure otherwise that **argocd will not sync anything automatically** or interfere with any of the other steps
2. Gracefully shutdown existing elasticsearch pods by scaling down the statefulset  
  `kubectl scale --replicas=0 -n monitoring sts/elasticsearch-master`  
  and wait until pods are shutdown
3. Shutdown filebeat and kibana pods (delete their daemonset / deployment / statefulset)
4. **Danger!** Remove old PVCs of elasticsearch
    * make really sure that the underlying PVs have **Retain** as their reclaim policy and **do not get deleted** by this step
5. Remove existing claim-ref spec from PVs yaml manifest so that they are in state "Available" again and can be bound to new PVCs  

    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: "..."
    spec:
      accessModes:
      - ReadWriteOnce
      capacity:
        storage: "..."
      # claimRef:                                           # DELETE
      #   apiVersion: v1                                    # DELETE
      #   kind: PersistentVolumeClaim                       # DELETE
      #   name: elasticsearch-master-elasticsearch-master-0 # DELETE
      #   namespace: default                                # DELETE
      #   resourceVersion: "7987"                           # DELETE
      #   uid: d74e4d0f-cbf6-41c3-9af9-59777afda0f5         # DELETE
      persistentVolumeReclaimPolicy: Retain
      # ... other stuff
    ```

6. _(Optional)_ create new PVCs that bind to that PVs by using the naming that is outlined below. You probably do not need this if you control the persistence by the elastic-operator chart (using `cce` or `aks` settings in values.yaml)
7. **Danger!** Remove old deployment / helm-release of elasticsearch
    * make really sure that the underlying PVs have **Retain** as their reclaim policy and **do not get deleted** by this step
    * Maybe make use of the argocd annotation  
    `argocd.argoproj.io/sync-options: Delete=false`  
    to stop argocd from deleting PVs
8. Deploy elastic-operator chart

## Migrating to ESO mode (chart `9.4.0+`)

When `common.externalSecret.enabled: true`, vault becomes canonical for user passwords (and, when `backup.enabled`, for backup credentials). The bash `generate-passwords` Job and the Helm-rendered basic-auth Secrets are replaced by a single ExternalSecrets `Password` generator plus a per-user push/pull round-trip against the store in `common.externalSecret.secretStore`.

### Preconditions

* External Secrets Operator (ESO) is installed
* A `ClusterSecretStore` (or `SecretStore`) for vault exists, referenced via `common.externalSecret.secretStore.{kind,name}`
* Remove any `auth.users.<user>.existingPassword` values — they have no effect in ESO mode (vault is canonical) and the chart refuses to render while they are set.

### User passwords

Each user under `auth.users` is round-tripped through vault:

* `auth.users.<user>.path` — vault secret path for that user (**required** in ESO mode).
* `auth.users.<user>.property` — field within that vault secret (default `password`); override it to pack several users into one vault secret.
* The Kubernetes Secret key stays `password` (the filebeat/kibana env refs depend on it).

To preserve existing passwords across the flip, pre-seed vault first; otherwise the `Password` generator produces new values on first sync.

1. For each user in `auth.users`, write the existing password to `auth.users.<user>.path` in vault, under the field from `auth.users.<user>.property` (or `password` if unset).
2. Flip `common.externalSecret.enabled: true` and sync.

With `generatePasswords.enabled: true`, the PushSecret uses `updatePolicy: IfNotExists`, so pre-seeded vault values survive (a rebuild never rotates them) and the ExternalSecret pulls them back into the K8s Secret. With `generatePasswords.enabled: false` the generator and push are skipped (pull-only / BYO), so passwords **must** be pre-seeded in vault by an external owner.

With Argo's default `prune: true` + `selfHeal: true`, the old Helm-rendered Secret is pruned and ESO recreates it automatically — expect a small gap during reconciliation.

### Backup credentials (when `backup.enabled`)

Backup credentials are externally managed (e.g. Terraform), so backup is pull-only — there is no push/round-trip for it. In ESO mode:

* `backup.path` — vault path the backup secure-settings secret is pulled from (**required** when `backup.secureSettings` is set).
* `backup.secureSettings.<setting>` — the value is now the vault **property name** to read, not the literal secret; leave it empty to default the property to the setting name. The legacy `${vault:...}` webhook syntax is rejected.
* `backup.repositorySettings.<key>` — these are not pulled from vault in ESO mode; replace any `${vault:...}` placeholders with the literal hardcoded value (the legacy webhook syntax is rejected).
* `cce.elasticsearch.volumes[].{id,az,kmsId}` — a PersistentVolume cannot source values from a Secret, so set these as plain literals, not `${vault:...}` placeholders.

### Verify post-upgrade

* `kubectl get pushsecret,externalsecret -n <ns>` — all `Synced`
* ECK-managed Elasticsearch reaches `Ready`
* Downstream consumers (filebeat, falco, etc.) continue authenticating

### Rolling back

Set `common.externalSecret.enabled: false` and re-sync — chart reverts to the bash `generate-passwords` Job + Helm-rendered Secrets path. ESO CRs are pruned by Argo; the K8s Secrets they created stay until pruned or replaced by the Helm-rendered ones.

## PVC names in the two charts

* Naming of PVCs of **elasticsearch** chart:
  * **Template:** `{{ .Values.elasticsearch.clusterName }}-{{ .Values.elasticsearch.nodeGroup }}-{{ .Values.elasticsearch.clusterName }}-{{ .Values.elasticsearch.nodeGroup }}-{{ $i }}`
  * `elasticsearch-master-elasticsearch-master-0` (using default values)
  * `elasticsearch-master-elasticsearch-master-1` (using default values)
* Naming of PVCs of the **elastic-operator** chart:
  * **Template:** `elasticsearch-data-{{ $.Release.Name }}-es-default-{{ $i }}`
  * `elasticsearch-data-elastic-operator-es-default-0` (using default values)
  * `elasticsearch-data-elastic-operator-es-default-1` (using default values)
  

# Upgrade to Version 9.4.0
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

# Upgrade to Version 9.3.7
from 9.3.5

Nothing to do before, can be upgraded in place.

Things found after updating:

- [xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release

  Result: Can be ignored. This is the stack self-monitoring on Kibana, which is currently not activated by default.

- Behavioral Analytics is deprecated and will be removed in a future release.

  Result: Can be ignored, not used in our default setup

- the index privilege [create_doc] allowed the update mapping action [indices:admin/mapping/auto_put] on index [monitoring-elastic-operator-9.3.7-2026.08], this privilege will not permit mapping updates in the next major release

  Result: Can be ignored in the default setup, as the update mapping isn't used

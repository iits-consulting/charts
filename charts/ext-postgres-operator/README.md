# ext-postgres-operator

iits wrapper around [movetokube/postgres-operator](https://github.com/movetokube/postgres-operator) with ESO-driven RDS root credentials via the iits [`common`](https://github.com/iits-consulting/charts/tree/main/charts/common) chart.

## Dependencies

| Dep | Repo | Version | Purpose |
|-----|------|---------|---------|
| `ext-postgres-operator` | https://movetokube.github.io/postgres-operator/ | `3.0.0` (app `v2.4.0`) | Operator + CRDs (`Postgres`, `PostgresUser`). |
| `common` | https://charts.iits.tech | `0.2.0` | ESO `ExternalSecret` pulling RDS root credentials from Vault. |

## How it works

The `common` chart emits an `ExternalSecret` that creates a Kubernetes Secret in the chart's release namespace, populating it from a Vault path. The `ext-postgres-operator` chart is configured with `existingSecret: postgres-operator-credentials` so its Deployment's `envFrom` references that Secret. The map key for the secret in the `common` chart's config matches that name.

## Values

| Path | Default | Purpose |
|------|---------|---------|
| `ext-postgres-operator.existingSecret` | `postgres-operator-credentials` | Name of the K8s Secret the operator pod reads via `envFrom`. |
| `ext-postgres-operator.env` | `{}` | Extra env vars for the operator pod. Set `POSTGRES_INSTANCE: "<name>"` here for multi-instance deployments. See [Multi-instance deployments](#multi-instance-deployments). |
| `common.externalSecret.enabled` | `true` | Toggle the common chart's ExternalSecret support. |
| `common.externalSecret.pull.secrets.postgres-operator-credentials.template.data` | (six POSTGRES_* keys; HOST/USER/PASS templated from Vault, URI_ARGS=""/CLOUD_PROVIDER=""/DEFAULT_DATABASE="postgres") | The K8s Secret the operator's `envFrom` reads from. All six env vars must exist (even empty) — the operator validates their presence at startup. ESO substitutes `{{ .NAME }}` template variables at runtime via `engineVersion: v2`. |
| `common.externalSecret.pull.enabled` | `true` | Toggle pulling secrets from the external store. |
| `common.externalSecret.pull.secrets.postgres-operator-credentials.path` | `""` | **Required override by consumer.** Vault path holding `host`, `username`, `password`. |
| `common.externalSecret.pull.secrets.postgres-operator-credentials.keys` | `[{POSTGRES_HOST→host}, {POSTGRES_USER→username}, {POSTGRES_PASS→password}]` | Vault property → Secret key mapping. Override the whole array if Vault uses different property names. |

## Sync flow

Single ArgoCD Application:
1. Helm renders both deps. Resulting manifests: ExternalSecret CR + operator Deployment + RBAC + CRDs.
2. ESO reconciles the ExternalSecret, materialises the `postgres-operator-credentials` Secret.
3. Operator pod boots reading from that Secret.

Initial sync may produce one or two retry cycles before the Secret is populated; ArgoCD's default retry policy (10 × 10s) covers it.

## Consumer example

`infrastructure-charts/value-files/ext-postgres-operator/values.yaml`:

```yaml
common:
  externalSecret:
    pull:
      secrets:
        postgres-operator-credentials:
          path: "{{ .Values.projectValues.stage }}/app/postgres-operator"
```

Override `keys:` here if your Vault uses different property names.

## Multi-instance deployments

Run multiple operator releases (one per RDS) by deploying the wrapper chart multiple times with distinct release names, namespaces, and `POSTGRES_INSTANCE` values:

```yaml
# infrastructure-charts/value-files/ext-postgres-operator-reporting/values.yaml
ext-postgres-operator:
  env:
    POSTGRES_INSTANCE: "reporting"

common:
  externalSecret:
    pull:
      secrets:
        postgres-operator-credentials:
          path: "{{ .Values.projectValues.stage }}/app/exit-postgres-operator/reporting"
```

Each `Postgres` / `PostgresUser` CR must then carry the matching annotation to be reconciled by the right operator:

```yaml
metadata:
  annotations:
    postgres.db.movetokube.com/instance: reporting
```

Without `POSTGRES_INSTANCE` set, the operator runs in catch-all mode and reconciles only CRs that have **no** `postgres-operator/instance` annotation — so the catch-all and the named instances coexist cleanly.

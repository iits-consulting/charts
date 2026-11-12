# Upgrade guide

Upgrade of a running 3.5.1 release to 4.0.0.

Tested: Argo CD sync with `ServerSideApply=true` on a test cluster with Kyverno 1.19 (chart 3.9.2), including the External Secrets pull secret migration. Helm path and rollback with Kyverno 1.20 (chart 3.10.0): `helm upgrade` and `helm rollback` on kind (Kubernetes 1.37). The Argo CD steps for the 1.20 legacy policy check (2, 12) are derived from the Helm test, not run on Argo CD.

Placeholders: `<app>` (Kyverno Argo CD Application), `<release>` (Helm release), `<ns>` (release namespace).

## Argo CD

### Before the sync

1. **Values.** Render with the values of `<app>`. Each removed or renamed key fails with a message (see [Values](#values)):

   ```sh
   helm template kyverno . -n <ns> -f <app values>
   ```

   To keep the 3.5.1 behavior (see [Behavior changes](#behavior-changes)):

   - `enforceSecurityContext.runAsUser: 1001` and `runAsGroup: 1001`. Without them, the next rollout of an image that runs as root fails with `CreateContainerConfigError`.
   - `replaceImageRegistry.keepRepositoryPath: false` for the flat 3.5.1 layout.

2. **CRDs and legacy policy check.** Add to the values of `<app>`:

   ```yaml
   kyverno:
     crds:
       install: true
       annotations:
         argocd.argoproj.io/sync-wave: "-1"
     kyverno-api:           # policies.kyverno.io CRDs, not covered by crds.annotations
       annotations:
         argocd.argoproj.io/sync-wave: "-1"
     upgrade:
       acknowledgeLegacyPoliciesNotEnforced: true   # only for this sync, removed in step 12
   ```

   `<app>` needs the sync option `ServerSideApply=true` because several CRDs exceed the size limit of client-side apply.

   Without the acknowledgement the PreSync hook Job `kyverno-check-legacy-policies` fails: the 3.5.1 ClusterPolicies still exist at that point, they are pruned later in the same sync. Kyverno 1.20 does not execute legacy `kyverno.io` policies anyway.

3. **Pull secrets from External Secrets.** Only if an `existingSecretRef` entry is created by an ExternalSecret in `<ns>`. The render fails with `is created by an ExternalSecret, set creationPolicy: Orphan`. Pick one:

   - **Recommended:** `ClusterExternalSecret` plus `injectOnly` (see [Image pull secrets](README.md#image-pull-secrets)):
     1. Sync the `ClusterExternalSecret` with the same target name before `<app>`. Exclude `<ns>` in its `namespaceSelectors` and mirror the namespaces in `autoInjectDockerPullSecrets.excludeNamespaces`.
     2. Move the entry from `existingSecretRef` to `injectOnly`.
     3. After the sync: `kubectl get secret <name> -A` lists the Secret in every target namespace.

     External Secrets takes over existing Kyverno clones with the same name in place (no ownerReference). If the owning ExternalSecret is removed before the `ClusterExternalSecret` exists, the 3.5.1 generate policies delete the clones until External Secrets recreates them.
   - **Keep cloning:** set `creationPolicy: Orphan` on the ExternalSecret. With `Owner` (the ESO default), deleting or replacing the ExternalSecret deletes the source and Kyverno deletes every clone. To keep `Owner` anyway, set `autoInjectDockerPullSecrets.allowOwnedExternalSecret: true`.

4. **PolicyExceptions and other legacy policies.** Every existing `kyverno.io/v2` PolicyException, including those shipped with other charts, must be converted to `policies.kyverno.io/v1` (see [PolicyExceptions](#policyexceptions)) and synced before `<app>`. v2 exceptions do not apply to the CEL policies. The same holds for `ClusterPolicy`, `Policy` and cleanup policies that other charts or teams own: Kyverno 1.20 ignores them and rejects creating or updating them, so an Application that still ships one fails to sync. List them:

   ```sh
   kubectl get clusterpolicies.kyverno.io,policies.kyverno.io,cleanuppolicies.kyverno.io,clustercleanuppolicies.kyverno.io,policyexceptions.kyverno.io -A \
     -o custom-columns=KIND:.kind,NS:.metadata.namespace,NAME:.metadata.name,RELEASE:.metadata.annotations.meta\\.helm\\.sh/release-name
   ```

   Everything except the ClusterPolicies of `<app>` must be migrated or removed.

5. **Other Applications.** Finish pending syncs first. Pods created before the Kyverno sync keep the 3.5.1 mutation (`clusterpolicies.kyverno.io/*` annotations, `runAsNonRoot: true`, `runAsUser: 1001`), converted exceptions do not change them.

6. **Auto-sync.** Disable it on `<app>` and on the app-of-apps that owns it (its `selfHeal` reverts the change on `<app>`).

7. **Migrate Job.** Delete a completed Job from an earlier sync, otherwise the server-side dry-run fails with `spec.template ... field is immutable`:

   ```sh
   kubectl delete job -n <ns> kyverno-migrate-resources
   ```

### Sync

8. Set the new chart version on `<app>` and sync. Argo CD prunes the 3.5.1 ClusterPolicies in the same sync. Pods created until step 9 is done are neither mutated nor validated. Keeping the old ClusterPolicies does not close that gap: Kyverno 1.20 sets them `Ready=False` (`Unsupported`) and does not execute them.

9. Wait for the CEL webhooks. Both numbers must match:

   ```sh
   kubectl get mpol --no-headers | wc -l
   kubectl get mutatingwebhookconfiguration kyverno-resource-mutating-webhook-cfg \
     -o jsonpath='{.webhooks[*].name}' | tr ' ' '\n' | grep -c '^mpol\.'
   ```

### After the sync

10. Delete Pods in `CreateContainerConfigError` that carry a `clusterpolicies.kyverno.io/*` annotation.

11. Verify:

    ```sh
    kubectl get cpol # No resources found
    kubectl get vpol,mpol,gpol,ivpol # READY true
    kubectl run probe -n <app ns> --image=<allowed image> --dry-run=server -o yaml # imagePullSecrets, securityContext, image
    kubectl get clusterpolicies.kyverno.io,policies.kyverno.io,policyexceptions.kyverno.io -A # No resources found, delete leftovers
    ```

    Cloned pull secrets stay (same UID) and the GeneratingPolicies take them over, including the `secrets` clones that 3.5.1 generated.

12. Remove `kyverno.upgrade.acknowledgeLegacyPoliciesNotEnforced` from the values of `<app>` and sync. The hook Job `kyverno-check-legacy-policies` runs and must complete, it fails while a legacy policy from step 11 is left.

13. Re-enable auto-sync on `<app>` and the app-of-apps. `<app>` must be `Synced`.

### Rollback

Set the previous chart version and values on `<app>` and sync. Keep `kyverno.crds.install: true`. Not tested on Argo CD. Tested with `helm rollback` on kind:

1. The first rollback fails: the Kyverno 1.20 admission controller is still running and rejects creating the 3.5.1 ClusterPolicies (`Kyverno v1.20 removed execution of legacy kyverno.io policy types and no longer accepts create or update requests`). The Deployments are rolled back regardless. On Argo CD expect the same first sync error.
2. Once the old admission controller is `Running`, roll back (or sync) again. The ClusterPolicies are created.
3. Helm compares with the failed revision and leaves the CEL policies in place, while 3.5.1 executes them as well (with `prependCustomImageRegistry` or `replaceImageRegistry` images are prefixed twice). Delete them:

   ```sh
   kubectl get vpol,mpol,gpol,ivpol -o json \
     | jq -r '.items[] | select(.metadata.annotations["meta.helm.sh/release-name"]=="<release>") | "\(.kind | ascii_downcase).policies.kyverno.io/\(.metadata.name)"' \
     | xargs kubectl delete
   ```

- Pods are not mutated until the ClusterPolicy webhooks are registered again (about a minute). Check with a `--dry-run=server` Pod.
- Running Pods are not restarted. Cloned and `pull-secret-<key>` Secrets stay. CEL PolicyExceptions stay.

## Helm

Steps 1, 3 and 4 as for Argo CD, then:

```sh
# CRDs
helm template <release> . -n <ns> -f <values> --set kyverno.crds.install=true \
  | yq 'select(.kind == "CustomResourceDefinition")' \
  | kubectl apply --server-side --force-conflicts -f -

# the 3.5.1 ClusterPolicies are deleted by this upgrade, only acknowledge them for this run
helm upgrade <release> . -n <ns> -f <values> --wait \
  --set kyverno.upgrade.acknowledgeLegacyPoliciesNotEnforced=true
```

Without `--set` the upgrade fails with `Found <n> legacy kyverno.io policy resource(s) on the cluster`. Then steps 9, 10 and 11, and `helm upgrade` once more without `--set`: the hook Job `kyverno-check-legacy-policies` must complete. Rollback: see [Rollback](#rollback).

## Values

The template or schema fails for each of these:

| 3.5.1 | 4.0.0 |
|---|---|
| `replaceImageRegistry.sourceRegex` | removed, use `keepRepositoryPath`. Other regular expressions have no equivalent |
| `disallowUnspecifiedDockerRegistries.registryUrls` | `allowedRegistries`, must not be empty |
| `autoInjectDockerPullSecrets.autogenControllers` | removed, the policies match Pods |
| `kyverno-policies.policyExclude` | `vpolExclude` (all policies, default `kube-system`) and `vpolExcludeByPolicy`, both take `excludeNamespaces`. `kind` filters are gone |
| `disallowEmptyIngressHost.excludeNamespaces` with `{name, namespace}` | `excludeIngresses`. `excludeNamespaces` takes namespace wildcards |
| `disallowUnsignedImages.timeoutSeconds: "30"` | integer 1-30 |
| unknown keys in a policy block (typos such as `excludeNamespace`) | rejected |
| `ingress.rules[].secretName` | `ingress.tls[].secretName`, a list of `{hosts, secretName}` (templates allowed). Default is one entry with `ingress.host` |
| `prependCustomImageRegistry` and `replaceImageRegistry` both enabled | rejected, the order of the two MutatingPolicies is not guaranteed |

Rendered kinds (no `type` value, no ClusterPolicy fallback). Policy names are unchanged:

| Value | Kind |
|---|---|
| `prependCustomImageRegistry`, `replaceImageRegistry`, `enforceSecurityContext` | MutatingPolicy |
| `disallowUnsignedImages` | ImageValidatingPolicy |
| `disallowUnspecifiedDockerRegistries`, `disallowEmptyIngressHost`, `disallowLatestTag`, `restrictIngressWildcard`, `requireIngressHttps` | ValidatingPolicy |
| `autoInjectDockerPullSecrets` | MutatingPolicy, one GeneratingPolicy per cloned pull secret (none for `injectOnly`) |
| `kyverno-policies` (PSS) | ValidatingPolicy |

RBAC: Helm replaces lists. If you override a controller's `extraResources`, keep:

- background controller: `get`, `list`, `watch`, `create`, `update`, `delete`, `patch` on Secrets. Without `watch`, deleted clones are not recreated and source changes do not propagate.
- reports controller: `get`, `list`, `watch` on `pods/ephemeralcontainers`. Without it, `disallow-unspecified-docker-registries` and `disallow-latest-tag` stay `READY false` (`RBACPermissionsGranted`).
- admission controller: `get`, `list`, `watch` on Secrets, for `imagesAndPublicKeyPairs[].pullSecret`.

## Behavior changes

- `enforceSecurityContext`: no `runAsUser`/`runAsGroup` 1001 by default, `runAsNonRoot: true` stays. Containers that only set `capabilities.add` also get `drop: [ALL]`.
- `replaceImageRegistry.keepRepositoryPath` defaults to `true`: `ghcr.io/org/app:v1` becomes `<target>/org/app:v1` (3.5.1: `<target>/app:v1`).
- `prependCustomImageRegistry`: `nginx:1.27` becomes `<registry>/docker.io/library/nginx:1.27` (3.5.1: `<registry>/docker.io/nginx:1.27`). Images that already start with the registry are left alone.
- `excludeNamespaces` (all policies) and `excludeRegistries` (prepend, replace) take wildcards: `*` matches any characters including `/`, `?` one character. `replaceImageRegistry.excludeNamespaces` is new.
- Mutating policies match Pods on CREATE only, set no `clusterpolicies.kyverno.io/*` annotations and do not rewrite ephemeral containers.
- `disallowUnspecifiedDockerRegistries` and `disallowLatestTag` also check ephemeral containers.
- `disallowUnsignedImages.ignoreTransparencyLog: false` is honored (3.5.1 always rendered `true`). Pairs are ANDed: an image matching two `imagesAndPublicKeyPairs` globs needs both signatures.
- `autoInjectDockerPullSecrets` without `secrets` and `existingSecretRef` renders nothing.
- `autoInjectDockerPullSecrets.excludeNamespaces` defaults to `kube-system`, `kube-public`, `kube-node-lease`: no clones and no `imagePullSecrets` there. Clones created there by 3.5.1 stay. `[]` restores the old behavior.
- Pull secrets: the GeneratingPolicies clone `pull-secret-<key>` (created by the chart in the release namespace) and the `existingSecretRef` Secrets. Credentials are no longer part of a policy. The source namespace is never a target. New and optional: `injectOnly` (injected, never cloned) and `namespaces` per entry (target namespaces, default all). See [Image pull secrets](README.md#image-pull-secrets).
- Pull secrets cloned from an ExternalSecret: if the GeneratingPolicy exists before the source (for example an ExternalSecret in the same release), existing namespaces get no clone and Kyverno does not retry. Create the source first, or run `kubectl annotate ns --all kyverno-resync=$(date +%s) --overwrite` once it exists.
- Every policy has `failurePolicy` (default `Fail`, `Ignore` for `disallowUnsignedImages`). The webhooks exclude `kube-system` and the Kyverno namespace.
- `ingress` (policy-reporter UI): requires `ingress.host`, `ingress.tls` is a list. Renders nothing if `policy-reporter.install` or `policy-reporter.ui.enabled` is false.
- New opt-in policies (`enabled: false`, `validationAction: Audit`): `disallowLatestTag`, `restrictIngressWildcard`, `requireIngressHttps`.
- Pod Security Standards (`kyverno-policies`, default `Audit`, so only reports change): new `disallow-host-probes` fails Pods whose probes or lifecycle handlers set `httpGet.host` or `tcpSocket.host`. `disallow-capabilities-strict` now fails containers without `capabilities.drop: [ALL]`, including containers without a `securityContext` (`enforceSecurityContext` adds it). Before switching to `validationFailureAction: Enforce`, check the PolicyReports for these two policies.
- `kyverno-policies.podSecurityVersion` (new, default `latest`) pins the Pod Security Admission version the policies follow, for example `v1.34`.

## PolicyExceptions

`kyverno.io` v2/v2beta1 exceptions do not apply to CEL policies, the Pod is denied. In kubectl use `policyexceptions.policies.kyverno.io`, plain `policyexception` resolves to the old group.

3.5.1:

```yaml
apiVersion: kyverno.io/v2
kind: PolicyException
metadata: {name: exempt-registries, namespace: team-b}
spec:
  exceptions:
    - policyName: disallow-unspecified-docker-registries
      ruleNames: [disallow-unspecified-docker-registries-rule]
  match:
    any:
      - resources: {kinds: [Pod], names: [legacy-exempt], namespaces: [team-b]}
```

4.0.0:

```yaml
apiVersion: policies.kyverno.io/v1
kind: PolicyException
metadata: {name: exempt-registries, namespace: kyverno}
spec:
  policyRefs:
    - {name: disallow-unspecified-docker-registries, kind: ValidatingPolicy}
  matchConditions:
    - name: only-legacy-exempt
      expression: "object.metadata.namespace == 'team-b' && object.metadata.name == 'legacy-exempt'"
```

| 3.5.1 | 4.0.0 |
|---|---|
| `spec.exceptions[].policyName` | `spec.policyRefs[].name` plus `kind` (`ValidatingPolicy`, `MutatingPolicy`, `ImageValidatingPolicy`, `GeneratingPolicy`) |
| `spec.exceptions[].ruleNames` | none, an exception covers the whole policy |
| `spec.match` (kinds, names, namespaces, selectors) | `spec.matchConditions[].expression` on `object`, all must be true |
| `podSecurity` | none, use `matchConditions` on the containers |
| PSS ClusterPolicy name | same name, `kind: ValidatingPolicy` |
| `metadata.namespace` anywhere | any namespace while `kyverno.features.policyExceptions.namespace` is `*` (default), otherwise only that namespace |

Pods created by a controller (Deployment, DaemonSet, ReplicaSet) have only `generateName` at admission, `metadata.name` is not set yet. Match on both, otherwise the expression errors or does not match:

```yaml
expression: >-
  object.metadata.namespace == 'team-b' &&
  (has(object.metadata.name) ? object.metadata.name : object.metadata.generateName).startsWith('legacy-exempt')
```

`policyRefs` must use the 4.0.0 policy names. `restrict-volume-types-strict` from 3.5.1 has no counterpart, `restrict-volume-types` covers the restricted standard. Put several conditions with `||` in parentheses before joining them with `&&`.

Effect of an unconverted exception, by policy:

- `enforce-security-context`: new Pods are mutated and get `runAsNonRoot: true`, a root container fails with `CreateContainerConfigError`. Running Pods are not touched. Convert these before Pods such as DaemonSets or operators are recreated.
- Pod Security policies (`kyverno-policies`): Pods are denied only with `validationFailureAction: Enforce`. With the default `Audit` they are only reported.
- `disallow-unspecified-docker-registries`: Pods are denied. Prepend and replace: Pods are mutated.

`resource.Get` works in `matchConditions` on Kyverno 1.20, for example to match a namespace label (tested on kind):

```yaml
expression: "resource.Get('v1', 'namespaces', '', object.metadata.namespace).metadata.?labels.?exempt.orValue('') == 'yes'"
```

Tested: custom and PSS ValidatingPolicy, MutatingPolicy (the matching Pod is not mutated). Not tested: ImageValidatingPolicy, GeneratingPolicy.

## Reporting and dashboards

- Reports contain only the sources `KyvernoValidatingPolicy`, `KyvernoMutatingPolicy`, `KyvernoGeneratingPolicy`. The old `kyverno` results are removed.
- `disallow-unsigned-images` (ImageValidatingPolicy) writes no PolicyReport results. Use the metric `kyverno_image_validating_policy_results_total` or the admission errors.
- A `fail` result of a MutatingPolicy means a Pod that would still be mutated, not a violation.
- Grafana (Kyverno dashboard): the CEL policies are in the `policies.kyverno.io` rows. The "Legacy Policies (kyverno.io)" rows stay empty. The policy counts only include policies with at least one result in the selected time range. Remove a manually imported 1.20 dashboard, the chart ships it.
- Metrics: the `kyverno_policy_*` and `kyverno_cleanup_controller_deletedobjects_total` series are no longer configured in `metricsExposure`. Alerts and recording rules on them must move to `kyverno_validating_policy_*`, `kyverno_mutating_policy_*`, `kyverno_generating_policy_*` and `kyverno_image_validating_policy_*`.

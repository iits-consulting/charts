# kyverno

![Version: 4.0.0](https://img.shields.io/badge/Version-4.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.20.0](https://img.shields.io/badge/AppVersion-1.20.0-informational?style=flat-square)

This chart wraps the upstream `kyverno`, `kyverno-policies` and `policy-reporter` charts and adds CEL policies (policies.kyverno.io):
  - Verify images are signed with cosign
  - Allow images only from given registries and disallow the latest tag
  - Replace the registry of images or prepend a custom one, useful for e.g. pull-through caches
  - Enforce a restricted securityContext on Pods
  - Add image pull secrets to Pods per namespace, optionally cloning them into the namespaces first
  - Require Ingress hosts and TLS and disallow wildcard hosts

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.iits.tech | common | 0.4.0 |
| https://kyverno.github.io/kyverno/ | kyverno | 3.10.0 |
| https://kyverno.github.io/kyverno/ | kyverno-policies | 3.10.0 |
| https://kyverno.github.io/policy-reporter | policy-reporter | 3.11.2 |

## Image pull secrets

`autoInjectDockerPullSecrets` has two jobs, each handled by its own policy:

- **Inject** (`add-image-pull-secret`, MutatingPolicy): adds secret names to `spec.imagePullSecrets` of new Pods. Names already on the Pod are kept. A Pod only references a Secret by name, so the Secret must exist in the Pod's namespace.
- **Clone** (`auto-create-docker-<name>`, one GeneratingPolicy per secret): copies a source Secret into the target namespaces, including namespaces created later. Changes to the source reach the clones, and a deleted clone is recreated. Deleting the source deletes every clone.

Each entry chooses whether Kyverno clones it:

| Value | Who puts the Secret into the target namespaces | Clone | Inject |
|---|---|---|---|
| `secrets.<key>` | The chart creates `pull-secret-<key>` in the release namespace, Kyverno clones it | yes | yes |
| `existingSecretRef[]` | You create it once in `namespace` (default: release namespace), Kyverno clones it | yes | yes |
| `injectOnly[]` | You, in every target namespace, e.g. with an External Secrets `ClusterExternalSecret` | no | yes |

### Per-namespace targeting

Every entry takes an optional `namespaces` list of wildcards (`*`, `?`). If it is not set, the entry targets all namespaces. The list limits both the clone and the injection:

```yaml
autoInjectDockerPullSecrets:
  enabled: true
  injectOnly:
    - name: ps-x
      namespaces: [team-a, team-b]
    - name: ps-y
      namespaces: [team-a, team-c, team-d]
```

Pods in `team-a` get `ps-x` and `ps-y`, Pods in `team-c` get `ps-y`, and Pods in other namespaces are left alone.

Every entry also takes an optional `namespaceSelector` (`matchLabels`, `matchExpressions` with `In`, `NotIn`, `Exists`, `DoesNotExist`) on the namespace labels:

```yaml
autoInjectDockerPullSecrets:
  enabled: true
  injectOnly:
    - name: ps-z
      namespaces: ["team-*"]
      namespaceSelector:
        matchLabels:
          pull-secret/ps-z: "true"
```

A namespace is a target if it matches `namespaces` (all if unset) and `namespaceSelector` (all if unset), and not `excludeNamespaces` (default: `kube-system`, `kube-public`, `kube-node-lease`). Label changes take effect without a values change: adding a matching label creates the clone, removing it deletes the clone, and new Pods follow the current labels. Kyverno never clones a Secret into its own source namespace.

### External Secrets (recommended: `injectOnly`)

Let External Secrets create the pull secret in every target namespace with a `ClusterExternalSecret`, and let Kyverno only inject it. This chart does not create the `ClusterSecretStore` or the `ClusterExternalSecret`. Manage them with your External Secrets setup.

```yaml
apiVersion: external-secrets.io/v1
kind: ClusterExternalSecret
metadata:
  name: ps-x
spec:
  externalSecretName: ps-x
  namespaces: [team-a, team-b]    # or namespaceSelectors, must match injectOnly[].namespaces or namespaceSelector
  externalSecretSpec:
    secretStoreRef:
      kind: ClusterSecretStore
      name: <your-store>
    target:
      name: ps-x
      template:
        type: kubernetes.io/dockerconfigjson
        data:
          .dockerconfigjson: '{"auths":{"registry.example.com":{"auth":"{{ printf "%s:%s" .username .password | b64enc }}"}}}'
    data:
      - secretKey: username
        remoteRef: {key: path/to/secret, property: username}
      - secretKey: password
        remoteRef: {key: path/to/secret, property: password}
```

Keep both namespace lists in sync. `ClusterExternalSecret.spec.namespaces` takes exact names, `injectOnly[].namespaces` takes wildcards. If a namespace is in the Kyverno list but has no Secret, the Pod is still created, the kubelet logs a warning and image pulls that need the credentials fail.

Mapping of the `ClusterExternalSecret` to the entry:

| `ClusterExternalSecret` | `injectOnly[]` entry |
|---|---|
| `namespaces: [a, b]` | `namespaces: [a, b]` |
| `namespaceSelectors` on any label | the same selector as `namespaceSelector`. Several `namespaceSelectors` are ORed, one `namespaceSelector` is not: use one entry per selector |
| `namespaceSelectors` with `kubernetes.io/metadata.name` `NotIn` | no `namespaces`, the list in `autoInjectDockerPullSecrets.excludeNamespaces` |

Cloning an ExternalSecret target through `existingSecretRef` also works, but it is not recommended:

- Namespaces that exist before External Secrets creates the source get no clone. Kyverno does not retry once the source appears. This happens when the ExternalSecret is in the same release. Create the source first (e.g. an Argo CD sync wave plus a health check), or trigger the namespaces again with `kubectl annotate ns --all kyverno-resync=$(date +%s) --overwrite`.
- Deleting or replacing the ExternalSecret deletes the source and every clone in the cluster, unless the ExternalSecret has `creationPolicy: Orphan`. For a `common.externalSecret.pull.secrets` entry cloned through `existingSecretRef` in the release namespace, the chart fails to render without `Orphan`. Opt out with `autoInjectDockerPullSecrets.allowOwnedExternalSecret: true`.
- The clones carry the ExternalSecret's metadata (`reconcile.external-secrets.io/*`), without effect.

Cost of `injectOnly`: External Secrets syncs one ExternalSecret per namespace against the backend instead of one in total.

### Removing a pull secret

Deleting a clone by hand does not work, Kyverno recreates it. Change the values instead:

- **From some namespaces**: remove them from the entry's `namespaces`, add them to `excludeNamespaces` or remove the label its `namespaceSelector` matches. Kyverno deletes the clones there. For `injectOnly`, also remove them from the `ClusterExternalSecret`.
- **`secrets.<key>`**: remove the key. The chart deletes the source and Kyverno deletes every clone.
- **`existingSecretRef[]`**: delete the source Secret first (for an ExternalSecret with `creationPolicy: Orphan`, delete the ExternalSecret and then the Secret). Kyverno deletes every clone. Then remove the entry. If you remove the entry first, the clones stay: `kubectl delete secret -A -l generate.kyverno.io/policy-name=auto-create-docker-<name>`.
- **`injectOnly[]`**: delete the `ClusterExternalSecret` (with `creationPolicy: Orphan`, also the Secrets), then remove the entry.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoInjectDockerPullSecrets.allowOwnedExternalSecret | bool | `false` | Allow cloning a `common.externalSecret.pull.secrets` entry through `existingSecretRef` without `creationPolicy: Orphan`. Deleting or replacing that ExternalSecret then deletes every clone, and Kyverno does not recreate them in existing namespaces when the source returns. |
| autoInjectDockerPullSecrets.enabled | bool | `false` | Enable or disable the policies globally. The credentials of `secrets` are only stored in the Secret `pull-secret-<key>` of the release namespace, not in a policy. |
| autoInjectDockerPullSecrets.excludeNamespaces | list | `["kube-system","kube-public","kube-node-lease"]` | Namespaces (wildcards `*`, `?`) that receive no Secret clone and whose Pods get no imagePullSecrets, wins over `namespaces` and `namespaceSelector` of an entry. The namespace of a cloned Secret is never a target. Helm replaces lists, repeat the defaults when you add entries. |
| autoInjectDockerPullSecrets.existingSecretRef | list | `[]` | Existing Secrets of type `kubernetes.io/dockerconfigjson` that Kyverno clones from `namespace` (default the release namespace) into the target namespaces. Changes of the source reach the clones, deleting it deletes them. |
| autoInjectDockerPullSecrets.failurePolicy | string | `"Fail"` | `failurePolicy` of the Pod mutation |
| autoInjectDockerPullSecrets.injectOnly | list | `[]` | Secrets that already exist in their target namespaces, for example created per namespace by an External Secrets `ClusterExternalSecret`. Only added to the imagePullSecrets of Pods, never cloned. Keep `namespaces` in line with the namespaces the secret exists in (`namespaceSelector` can mirror the `namespaceSelectors` of a `ClusterExternalSecret`). Recommended for External Secrets. |
| autoInjectDockerPullSecrets.secrets | object | `{}` | Pull secrets to create from the chart values, by key. The chart creates `pull-secret-<key>` in the release namespace and Kyverno clones it into the target namespaces. |
| disallowEmptyIngressHost.enabled | bool | `true` | Enable or disable the policy globally |
| disallowEmptyIngressHost.excludeIngresses | list | `[]` | Exclude single Ingresses, a list of `{name, namespace}`. Both fields support wildcards (`*`, `?`) and templates (for example `{{ .Release.Namespace }}`). |
| disallowEmptyIngressHost.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| disallowEmptyIngressHost.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| disallowEmptyIngressHost.name | string | `"disallow-empty-ingress-host"` | The name of the policy |
| disallowEmptyIngressHost.validationAction | string | `"Enforce"` | How policy violation should be handled. Use either `Enforce` or `Audit` (case insensitive). |
| disallowLatestTag.enabled | bool | `false` | Enable or disable the policy globally |
| disallowLatestTag.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| disallowLatestTag.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| disallowLatestTag.name | string | `"disallow-latest-tag"` | The name of the policy |
| disallowLatestTag.validationAction | string | `"Audit"` | How policy violation should be handled. Use either `Enforce` or `Audit` (case insensitive). |
| disallowUnsignedImages.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnsignedImages.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| disallowUnsignedImages.failurePolicy | string | `"Ignore"` | `Ignore` admits Pods when the webhook fails or times out (for example an unreachable registry), so a slow registry or Kyverno skips the check. Kept as in 3.5.1, set `Fail` for fail-closed verification. |
| disallowUnsignedImages.imagesAndPublicKeyPairs | list | `[{"image":"*","key":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEXzV8f2YUEmXF176k//uSmgEEZoKb\ng2b7+PuoKjfaYVw3HTAE2Z4ak5ZNNq5HF8G1cRt3P713MyuIXiNKP6v2Nw==\n-----END PUBLIC KEY-----"}]` | Images and the public key they are verified with. `image` is a wildcard (`*`, `?`) that must start with the registry (`docker.io/iits/*` works, `iits/*` does not). Pairs are ANDed: an image matching two pairs needs both signatures, so keep the patterns disjoint. `pullSecret` names a Secret of the Kyverno namespace for private registries. `ignoreTransparencyLog` defaults to true (no Rekor entry, as with `cosign sign --key --tlog-upload=false`), set it to false for signatures uploaded to a transparency log. The policy is always enforced (no Audit mode) and writes no PolicyReport results. |
| disallowUnsignedImages.name | string | `"disallow-unsigned-images"` | The name of the policy |
| disallowUnsignedImages.timeoutSeconds | int | `30` | Webhook timeout in seconds (max 30) |
| disallowUnspecifiedDockerRegistries.allowedRegistries | list | `["mysecure-registry/common-signed-docker-images/*"]` | List of allowed registries. Wildcards are supported: `*` matches any characters (including `/`), `?` one character. An image is allowed if its reference as written or its normalized form (`nginx` is `docker.io/library/nginx:latest`) matches. There are no image exceptions: widen the list, exclude the namespace or use a PolicyException. |
| disallowUnspecifiedDockerRegistries.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnspecifiedDockerRegistries.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| disallowUnspecifiedDockerRegistries.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| disallowUnspecifiedDockerRegistries.name | string | `"disallow-unspecified-docker-registries"` | The name of the policy |
| disallowUnspecifiedDockerRegistries.validationAction | string | `"Enforce"` | `Enforce` rejects violating resources, `Audit` admits them and reports the violation (case insensitive). |
| enforceSecurityContext.enabled | bool | `false` | Enable or disable the policy globally |
| enforceSecurityContext.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| enforceSecurityContext.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| enforceSecurityContext.name | string | `"enforce-security-context"` | The name of the policy |
| enforceSecurityContext.readOnlyRootFilesystem | bool | `false` | Default `readOnlyRootFilesystem: true` for containers that set none. Opt-in, many images write to their root filesystem. |
| enforceSecurityContext.runAsGroup | string | `nil` | Default `runAsGroup` of Pods that set none. Unset by default. |
| enforceSecurityContext.runAsUser | string | `nil` | Default `runAsUser` of Pods that set none. Unset by default: a fixed UID breaks images that need their own UID, images that run as root then fail to start because `runAsNonRoot` is true. |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd, {{ .Release.Namespace }}-strip-prefix-{{ .Release.Name }}@kubernetescrd"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | String | `nil` | Required, set the domain you want to serve the UI from |
| ingress.rules | list | `[{"host":"{{ .Values.ingress.host }}","paths":[{"path":"/policies"},{"path":"/_nuxt"}]}]` | Hosts and paths served by the UI. `host` supports templates |
| ingress.tls | list | `[{"hosts":["{{ .Values.ingress.host }}"]}]` | TLS entries, each with a list of `hosts` (templates allowed) and an optional `secretName`. `[]` renders no `tls` block |
| kyverno-policies.install | bool | `true` | Whether to install the default policies for kyverno |
| kyverno-policies.podSecurityStandard | string | `"restricted"` | The pod security standard as defined in https://kyverno.io/policies/pod-security. |
| kyverno-policies.vpolExclude | object | `{"excludeNamespaces":["kube-system"]}` | Exclude kube-system Pods since we can not change them. Applies to every policy that has no vpolExcludeByPolicy entry. |
| kyverno.admissionController.rbac.clusterRole.extraResources[0].apiGroups[0] | string | `""` |  |
| kyverno.admissionController.rbac.clusterRole.extraResources[0].resources[0] | string | `"secrets"` |  |
| kyverno.admissionController.rbac.clusterRole.extraResources[0].verbs[0] | string | `"list"` |  |
| kyverno.admissionController.rbac.clusterRole.extraResources[0].verbs[1] | string | `"get"` |  |
| kyverno.admissionController.rbac.clusterRole.extraResources[0].verbs[2] | string | `"watch"` |  |
| kyverno.admissionController.replicas | int | `2` |  |
| kyverno.admissionController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].apiGroups[0] | string | `""` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].resources[0] | string | `"secrets"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[0] | string | `"list"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[1] | string | `"get"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[2] | string | `"watch"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[3] | string | `"create"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[4] | string | `"update"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[5] | string | `"delete"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[6] | string | `"patch"` |  |
| kyverno.backgroundController.resources.limits.memory | string | `"1Gi"` |  |
| kyverno.backgroundController.resources.requests.cpu | string | `"300m"` |  |
| kyverno.backgroundController.resources.requests.memory | string | `"512Mi"` |  |
| kyverno.backgroundController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.cleanupController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.crds.install | bool | `false` |  |
| kyverno.existingImagePullSecrets | list | `[]` |  |
| kyverno.features.logging.format | string | `"json"` |  |
| kyverno.features.policyExceptions.enabled | bool | `true` |  |
| kyverno.features.policyExceptions.namespace | string | `"*"` | Only PolicyExceptions of this namespace are honored. `*` honors every namespace, so anyone who can create a PolicyException can bypass the policies. |
| kyverno.grafana.enabled | bool | `true` |  |
| kyverno.reportsController.rbac.clusterRole.extraResources[0].apiGroups[0] | string | `""` |  |
| kyverno.reportsController.rbac.clusterRole.extraResources[0].resources[0] | string | `"pods/ephemeralcontainers"` |  |
| kyverno.reportsController.rbac.clusterRole.extraResources[0].verbs[0] | string | `"get"` |  |
| kyverno.reportsController.rbac.clusterRole.extraResources[0].verbs[1] | string | `"list"` |  |
| kyverno.reportsController.rbac.clusterRole.extraResources[0].verbs[2] | string | `"watch"` |  |
| kyverno.reportsController.serviceMonitor.enabled | bool | `true` |  |
| policy-reporter.install | bool | `true` |  |
| policy-reporter.logging.encoding | string | `"json"` |  |
| policy-reporter.metrics.enabled | bool | `true` |  |
| policy-reporter.monitoring.enabled | bool | `true` |  |
| policy-reporter.plugin.kyverno.enabled | bool | `true` |  |
| policy-reporter.plugin.kyverno.logging.encoding | string | `"json"` |  |
| policy-reporter.sourceFilters | list | `[]` |  |
| policy-reporter.ui.enabled | bool | `true` |  |
| policy-reporter.ui.logging.encoding | string | `"json"` |  |
| prependCustomImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
| prependCustomImageRegistry.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| prependCustomImageRegistry.excludeRegistries | list | `[]` | Images that are left alone. Wildcards (`*` any characters including `/`, `?` one character) are matched against the image reference as written in the Pod. |
| prependCustomImageRegistry.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| prependCustomImageRegistry.name | string | `"prepend-image-registry"` | The name of the policy |
| prependCustomImageRegistry.registry | string | `"mysecure-registry.example.com"` | The registry prepended to every image. Must not be enabled together with `replaceImageRegistry`. |
| replaceImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
| replaceImageRegistry.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| replaceImageRegistry.excludeRegistries | list | `[]` | Images that are left alone. Wildcards (`*` any characters including `/`, `?` one character) are matched against the image reference as written in the Pod. |
| replaceImageRegistry.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| replaceImageRegistry.keepRepositoryPath | bool | `true` | `true` keeps the repository path (`ghcr.io/org/app:v1` becomes `<target>/org/app:v1`), `false` only the image name (`<target>/app:v1`), where `org1/app` and `org2/app` collide. Must not be enabled together with `prependCustomImageRegistry`. |
| replaceImageRegistry.name | string | `"replace-image-registry"` | The name of the policy |
| replaceImageRegistry.target | string | `"mysecure-registry/common-signed-docker-images"` | The registry (and path) every image is pulled from instead |
| requireIngressHttps.enabled | bool | `false` | Enable or disable the policy globally |
| requireIngressHttps.excludeIngresses | list | `[]` | Exclude single Ingresses, a list of `{name, namespace}`. Both fields support wildcards (`*`, `?`) and templates. |
| requireIngressHttps.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| requireIngressHttps.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| requireIngressHttps.name | string | `"require-ingress-https"` | The name of the policy |
| requireIngressHttps.validationAction | string | `"Audit"` | How policy violation should be handled. Use either `Enforce` or `Audit` (case insensitive). |
| restrictIngressWildcard.enabled | bool | `false` | Enable or disable the policy globally |
| restrictIngressWildcard.excludeIngresses | list | `[]` | Exclude single Ingresses, a list of `{name, namespace}`. Both fields support wildcards (`*`, `?`) and templates. |
| restrictIngressWildcard.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces. Wildcards are supported (`*`, `?`). |
| restrictIngressWildcard.failurePolicy | string | `"Fail"` | `Fail` rejects the request when Kyverno is unavailable or the webhook times out, `Ignore` admits it |
| restrictIngressWildcard.name | string | `"restrict-ingress-wildcard"` | The name of the policy |
| restrictIngressWildcard.validationAction | string | `"Audit"` | How policy violation should be handled. Use either `Enforce` or `Audit` (case insensitive). |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

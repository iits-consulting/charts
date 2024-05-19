# kyverno

![Version: 2.0.1](https://img.shields.io/badge/Version-2.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.2.0](https://img.shields.io/badge/AppVersion-3.2.0-informational?style=flat-square)

This chart wraps the upstream `kyverno` and `kyverno-policies` chart and adds a few useful policies:
  - Verify all images are signed with cosign
  - Verify all images come from allowed image repositories
  - Replace the complete registry reference with a custom one
  - Prepend the image reference with a custom prefix, useful for e.g. pull-through caches

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kyverno.github.io/kyverno/ | kyverno | 3.2.0 |
| https://kyverno.github.io/kyverno/ | kyverno-policies | 3.2.0 |
| https://kyverno.github.io/policy-reporter | policy-reporter | 2.22.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoInjectDockerPullSecrets.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| autoInjectDockerPullSecrets.enabled | bool | `true` |  |
| autoInjectDockerPullSecrets.secrets | string | `nil` |  |
| disallowUnsignedImages.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| disallowUnsignedImages.background | bool | `true` | Also check already existing containers. See https://kyverno.io/docs/writing-policies/background/ |
| disallowUnsignedImages.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnsignedImages.excludeNamespaces | list | `["kube-system"]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnsignedImages.imagesAndPublicKeyPairs | list | `[{"image":"*","key":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEXzV8f2YUEmXF176k//uSmgEEZoKb\ng2b7+PuoKjfaYVw3HTAE2Z4ak5ZNNq5HF8G1cRt3P713MyuIXiNKP6v2Nw==\n-----END PUBLIC KEY-----"}]` | List of image definitions and the associated public key used for signing. |
| disallowUnsignedImages.name | string | `"disallow-unsigned-images"` | The name of the policy |
| disallowUnsignedImages.validationAction | string | `"Enforce"` | How policy violation should be handled. Use either `enforce` or `audit`. See https://kyverno.io/docs/writing-policies/validate/ for details If a policy is violated and the action is "enforce", then the ressource will not be allowed to be created. On the other the `audit` action allows the ressource but reports this incident. |
| disallowUnspecifiedDockerRegistries.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| disallowUnspecifiedDockerRegistries.background | bool | `true` | Also check already existing containers. See https://kyverno.io/docs/writing-policies/background/ |
| disallowUnspecifiedDockerRegistries.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnspecifiedDockerRegistries.excludeNamespaces | list | `["kube-system"]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnspecifiedDockerRegistries.name | string | `"disallow-unspecified-docker-registries"` | The name of the policy |
| disallowUnspecifiedDockerRegistries.registryUrls | list | `["mysecure-registry/common-signed-docker-images/*"]` | List of allowed registries. Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnspecifiedDockerRegistries.validationAction | string | `"Enforce"` | How policy violation should be handled. Use either `enforce` or `audit`. See https://kyverno.io/docs/writing-policies/validate/ for details If a policy is violated and the action is "enforce", then the ressource will not be allowed to be created. On the other the `audit` action allows the ressource but reports this incident. |
| enforceSecurityContext.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| enforceSecurityContext.enabled | bool | `false` | Enable or disable the policy globally |
| enforceSecurityContext.excludeNamespaces | list | `["kube-system"]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| enforceSecurityContext.name | string | `"enforce-security-context"` | The name of the policy |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd, {{ .Release.Namespace }}-strip-prefix-{{ .Release.Name }}@kubernetescrd"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | String | `nil` | Required, set the domain you want to serve the UI from |
| ingress.rules[0].host | string | `"{{ .Values.ingress.host }}"` |  |
| ingress.rules[0].paths[0].path | string | `"/policies"` |  |
| ingress.rules[0].paths[1].path | string | `"/_nuxt"` |  |
| kyverno-policies.autogenControllers | string | `"none"` |  |
| kyverno-policies.install | bool | `true` | Whether to install the default policies for kyverno |
| kyverno-policies.podSecurityStandard | string | `"restricted"` | The pod security standarcd as defined in https://kyverno.io/policies/pod-security. |
| kyverno-policies.policyExclude.disallow-capabilities-strict.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.disallow-capabilities-strict.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.disallow-capabilities-strict.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-capabilities-strict.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-capabilities.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.disallow-capabilities.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.disallow-capabilities.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-capabilities.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-host-namespaces.any[0].resources.kinds[0] | string | `"DaemonSet"` |  |
| kyverno-policies.policyExclude.disallow-host-namespaces.any[0].resources.kinds[1] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-host-namespaces.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-host-path.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.disallow-host-path.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.disallow-host-path.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-host-path.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-host-ports.any[0].resources.kinds[0] | string | `"DaemonSet"` |  |
| kyverno-policies.policyExclude.disallow-host-ports.any[0].resources.kinds[1] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-host-ports.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-privilege-escalation.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.disallow-privilege-escalation.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.disallow-privilege-escalation.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-privilege-escalation.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.disallow-privileged-containers.any[0].resources.kinds[0] | string | `"DaemonSet"` |  |
| kyverno-policies.policyExclude.disallow-privileged-containers.any[0].resources.kinds[1] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.disallow-privileged-containers.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.require-run-as-non-root-user.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.require-run-as-non-root-user.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.require-run-as-non-root-user.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.require-run-as-non-root-user.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.require-run-as-nonroot.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.require-run-as-nonroot.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.require-run-as-nonroot.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.require-run-as-nonroot.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.restrict-seccomp-strict.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.restrict-seccomp-strict.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.restrict-seccomp-strict.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.restrict-seccomp-strict.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno-policies.policyExclude.restrict-volume-types.any[0].resources.kinds[0] | string | `"Deployment"` |  |
| kyverno-policies.policyExclude.restrict-volume-types.any[0].resources.kinds[1] | string | `"ReplicaSet"` |  |
| kyverno-policies.policyExclude.restrict-volume-types.any[0].resources.kinds[2] | string | `"Pod"` |  |
| kyverno-policies.policyExclude.restrict-volume-types.any[0].resources.namespaces[0] | string | `"kube-system"` |  |
| kyverno.admissionController.replicas | int | `2` |  |
| kyverno.admissionController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].apiGroups[0] | string | `""` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].resources[0] | string | `"pods"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[0] | string | `"create"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[1] | string | `"update"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[2] | string | `"delete"` |  |
| kyverno.backgroundController.rbac.clusterRole.extraResources[0].verbs[3] | string | `"patch"` |  |
| kyverno.backgroundController.resources.limits.memory | string | `"1Gi"` |  |
| kyverno.backgroundController.resources.requests.cpu | string | `"300m"` |  |
| kyverno.backgroundController.resources.requests.memory | string | `"512Mi"` |  |
| kyverno.backgroundController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.cleanupController.serviceMonitor.enabled | bool | `true` |  |
| kyverno.crds.install | bool | `false` |  |
| kyverno.existingImagePullSecrets | list | `[]` |  |
| kyverno.features.logging.format | string | `"text"` |  |
| kyverno.grafana.enabled | bool | `true` |  |
| kyverno.reportsController.serviceMonitor.enabled | bool | `true` |  |
| policy-reporter.install | bool | `true` |  |
| policy-reporter.kyvernoPlugin.enabled | bool | `true` |  |
| policy-reporter.ui.enabled | bool | `true` |  |
| policy-reporter.ui.plugins.kyverno | bool | `true` |  |
| prependCustomImageRegistry.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| prependCustomImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
| prependCustomImageRegistry.excludeNamespaces | list | `[]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| prependCustomImageRegistry.excludeRegistries | list | `[]` | a list of registries that should be skipped when mangling the image reference |
| prependCustomImageRegistry.name | string | `"prepend-image-registry"` | The name of the policy |
| prependCustomImageRegistry.registry | string | `"mysecure-registry.example.com"` | the target image repository that should be prepended |
| replaceImageRegistry.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| replaceImageRegistry.background | bool | `true` | Check already existing as well containers. See also https://kyverno.io/docs/writing-policies/background/ |
| replaceImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
| replaceImageRegistry.excludeRegistries | list | `["docker.io/something/*"]` | Excludes images from the replacement. Wildcard * is supported |
| replaceImageRegistry.name | string | `"replace-image-registry"` | The name of the policy |
| replaceImageRegistry.sourceRegex | string | `"'.*(.*)/'"` | source regex for matching it. Needs to be golang compatible |
| replaceImageRegistry.target | string | `"mysecure-registry/common-signed-docker-images"` | the target image repository |
| replaceImageRegistry.validationFailureAction | string | `"Audit"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

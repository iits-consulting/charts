# iits-kyverno-policies

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

This chart wraps the upstream `kyverno-policies` chart and adds a few useful policies:
  - Verify all images are signed with cosign
  - Verify all images come from allowed image repositories
  - Replace the complete registry reference with a custom one
  - Prepend the image reference with a custom prefix, useful for e.g. pull-through caches

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kyverno.github.io/kyverno/ | kyverno-policies | v2.7.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| disallowUnsignedImages | object | `{"autogenControllers":"none","background":true,"enabled":false,"excludeNamespaces":["kube-system"],"imagesAndPublicKeyPairs":[{"image":"*","key":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEXzV8f2YUEmXF176k//uSmgEEZoKb\ng2b7+PuoKjfaYVw3HTAE2Z4ak5ZNNq5HF8G1cRt3P713MyuIXiNKP6v2Nw==\n-----END PUBLIC KEY-----"}],"name":"disallow-unsigned-images","validationAction":"enforce"}` | Settings for the policy which verifies if images from specific sources are signed. |
| disallowUnsignedImages.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| disallowUnsignedImages.background | bool | `true` | Also check already existing containers. See https://kyverno.io/docs/writing-policies/background/ |
| disallowUnsignedImages.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnsignedImages.excludeNamespaces | list | `["kube-system"]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnsignedImages.imagesAndPublicKeyPairs | list | `[{"image":"*","key":"-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEXzV8f2YUEmXF176k//uSmgEEZoKb\ng2b7+PuoKjfaYVw3HTAE2Z4ak5ZNNq5HF8G1cRt3P713MyuIXiNKP6v2Nw==\n-----END PUBLIC KEY-----"}]` | List of image definitions and the associated public key used for signing. |
| disallowUnsignedImages.name | string | `"disallow-unsigned-images"` | The name of the policy |
| disallowUnsignedImages.validationAction | string | `"enforce"` | How policy violation should be handled. Use either `enforce` or `audit`. See https://kyverno.io/docs/writing-policies/validate/ for details If a policy is violated and the action is "enforce", then the ressource will not be allowed to be created. On the other the `audit` action allows the ressource but reports this incident. |
| disallowUnspecifiedDockerRegistries.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| disallowUnspecifiedDockerRegistries.background | bool | `true` | Also check already existing containers. See https://kyverno.io/docs/writing-policies/background/ |
| disallowUnspecifiedDockerRegistries.enabled | bool | `false` | Enable or disable the policy globally |
| disallowUnspecifiedDockerRegistries.excludeNamespaces | list | `["kube-system"]` | Exclude the policy on the given list of namespaces Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnspecifiedDockerRegistries.name | string | `"disallow-unspecified-docker-registries"` | The name of the policy |
| disallowUnspecifiedDockerRegistries.registryUrls | list | `["mysecure-registry/common-signed-docker-images/*"]` | List of allowed registries. Wildcards are supported. For more information check out: https://kyverno.io/docs/writing-policies/validate/#wildcards |
| disallowUnspecifiedDockerRegistries.validationAction | string | `"enforce"` | How policy violation should be handled. Use either `enforce` or `audit`. See https://kyverno.io/docs/writing-policies/validate/ for details If a policy is violated and the action is "enforce", then the ressource will not be allowed to be created. On the other the `audit` action allows the ressource but reports this incident. |
| kyverno-policies.install | bool | `true` |  |
| kyverno-policies.podSecurityStandard | string | `"baseline"` |  |
| prependCustomImageRegistry.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| prependCustomImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
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
| replaceImageRegistry.validationFailureAction | string | `"audit"` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
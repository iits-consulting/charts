# iits-kyverno-policies

This chart wraps the upstream `kyverno-policies` chart and adds a few useful policies:

- Verify all images are signed with cosign
- Verify all images come from allowed image repositories

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://kyverno.github.io/kyverno/ | kyverno-policies | v2.7.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
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
| replaceImageRegistry.autogenControllers | string | `"none"` | Auto gen rules for pod controllers. See https://kyverno.io/docs/writing-policies/autogen/ |
| replaceImageRegistry.background | bool | `true` | Check already existing as well containers. See also https://kyverno.io/docs/writing-policies/background/ |
| replaceImageRegistry.enabled | bool | `false` | Enable or disable the policy globally |
| replaceImageRegistry.excludeRegistries | list | `["docker.io/something/*"]` | Excludes images from the replacement. Wildcard * is supported |
| replaceImageRegistry.name | string | `"replace-image-registry"` | The name of the policy |
| replaceImageRegistry.sourceRegex | string | `"'.*(.*)/'"` | source regex for matching it. Needs to be golang compatible |
| replaceImageRegistry.target | string | `"mysecure-registry/common-signed-docker-images"` | the target image repository |
| replaceImageRegistry.validationFailureAction | string | `"audit"` |  |

## Running tests

To quickly check if it works as intended run the tests. This requires the `kyverno` binary.

```shell
cd /toplevel/directory/of/this/repo/test/kyverno
kyverno test .
```

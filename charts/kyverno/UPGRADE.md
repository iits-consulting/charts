# To version 3.6.1

`disallowUnsignedImages.kumoopsAgent.enabled` is opt-in now. Stages that run the KumoOps Portal Customer Agent and relied on the 3.6.0 default must set it explicitly:

```yaml
disallowUnsignedImages:
  kumoopsAgent:
    enabled: true
```

Without this, the agent image is checked against the `imagesAndPublicKeyPairs` keys instead of its own key, so the agent pod is rejected, and `disallowUnspecifiedDockerRegistries` does not list the agent registry. Stages without the agent need no change.

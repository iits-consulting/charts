# Changelog

## Chart Versions

### Unreleased
- Breaking: the PolicyException is now a `policies.kyverno.io/v1` PolicyException (CEL), `kyverno.io/v2` exceptions do not apply to CEL policies. It is created in the release namespace unless `policyException.namespace` is set.

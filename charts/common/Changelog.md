# Changelog

## Chart Versions

### 0.3.0
- Remove hardcoded `argocd.argoproj.io/sync-wave` annotations from ExternalSecret/PushSecret/Password resources. Consumers needing sync ordering must now supply via per-secret/per-generator `annotations` field.
- Add `annotations` field on each secret/generator config — merged into resource `metadata.annotations`.

### 0.2.0
- Add Advanced Templating v2 options to External Secrets

### 0.1.0
- Add Password Generator option to External Secrets

### 0.0.1
- Add option for External Secrets resources managed by an External Secrets Operator


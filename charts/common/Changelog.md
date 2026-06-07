# Changelog

## Chart Versions

### 0.3.2
- Add `templates/validation.yaml`: fails chart rendering on incoherent `externalSecret.generators` sub-flag combinations (one of `enabled` / `passwords` set without the other).

### 0.3.1
- Fix ExternalSecret `template.type` being read from the wrong values level (`$secretConfig.type` instead of `$secretConfig.template.type`)

### 0.3.0
- Remove hardcoded `argocd.argoproj.io/sync-wave` annotations from ExternalSecret/PushSecret/Password resources. Consumers needing sync ordering must now supply via per-secret/per-generator `annotations` field.
- Add `annotations` field on each secret/generator config — merged into resource `metadata.annotations`.

### 0.2.0
- Add Advanced Templating v2 options to External Secrets

### 0.1.0
- Add Password Generator option to External Secrets

### 0.0.1
- Add option for External Secrets resources managed by an External Secrets Operator


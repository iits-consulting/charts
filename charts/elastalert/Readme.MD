# Description

Customized version of elastalert 2 for iits slack.
This one only works with slack.

## Usage

```yaml
elastalert:
  namespace: monitoring
  repoURL: "https://charts.iits.tech"
  targetRevision: "0.1.1"
  # If you need custom rules
  valueFile: "value-files/elastalert/values.yaml"
  parameters:
    customRules.slack.webhookUrl: "${vault:mySecretPath/data/common/slack#webhookUrl}"
```

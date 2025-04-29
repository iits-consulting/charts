# elastalert

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Wrapper chart for elastalert2 with custom rules to kickstart IITS projects

## Installing the Chart with iits ArgoCD

```yaml
elastalert:
  namespace: monitoring
  repoURL: "https://charts.iits.tech"
  targetRevision: "0.3.0"
  # If you need custom rules
  valueFile: "value-files/elastalert/values.yaml"
  parameters:
    customRules.slack.webhookUrl: "${vault:mySecretPath/data/common/slack#webhookUrl}"
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://jertel.github.io/elastalert2/ | elastalert2 | 2.24.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| customRules.alerting.argoCD.alert[0] | string | `"slack"` |  |
| customRules.alerting.argoCD.alert_text_args[0] | string | `"@timestamp"` |  |
| customRules.alerting.argoCD.alert_text_type | string | `"aggregation_summary_only"` |  |
| customRules.alerting.argoCD.exponential_realert.days | int | `3` |  |
| customRules.alerting.argoCD.fields[0] | string | `"message"` |  |
| customRules.alerting.argoCD.filter[0].query_string.query | string | `"level: \"*error*\" OR message: \"*level=error*\""` |  |
| customRules.alerting.argoCD.index | string | `"argocd*"` |  |
| customRules.alerting.argoCD.name | string | `"ArgoCD Error"` |  |
| customRules.alerting.argoCD.query_key | string | `"message"` |  |
| customRules.alerting.argoCD.realert.minutes | int | `30` |  |
| customRules.alerting.argoCD.slack_alert_fields[0].title | string | `"Stage"` |  |
| customRules.alerting.argoCD.slack_alert_fields[0].value | string | `"labels.stage"` |  |
| customRules.alerting.argoCD.slack_alert_fields[1].title | string | `"Component"` |  |
| customRules.alerting.argoCD.slack_alert_fields[1].value | string | `"kubernetes.labels.app_kubernetes_io/component"` |  |
| customRules.alerting.argoCD.slack_alert_fields[2].title | string | `"Pod"` |  |
| customRules.alerting.argoCD.slack_alert_fields[2].value | string | `"kubernetes.pod.name"` |  |
| customRules.alerting.argoCD.slack_alert_fields[3].title | string | `"Message"` |  |
| customRules.alerting.argoCD.slack_alert_fields[3].value | string | `"message"` |  |
| customRules.alerting.argoCD.slack_title | string | `"ArgoCD Error"` |  |
| customRules.alerting.argoCD.slack_webhook_url | string | `"{{ $.Values.customRules.slack.webhookUrl }}"` |  |
| customRules.alerting.argoCD.type | string | `"any"` |  |
| customRules.alerting.botKube.alert[0] | string | `"slack"` |  |
| customRules.alerting.botKube.alert_text_type | string | `"aggregation_summary_only"` |  |
| customRules.alerting.botKube.exponential_realert.days | int | `3` |  |
| customRules.alerting.botKube.fields[0] | string | `"message"` |  |
| customRules.alerting.botKube.filter[0].query_string.query | string | `"Type:\"error\""` |  |
| customRules.alerting.botKube.index | string | `"botkube*"` |  |
| customRules.alerting.botKube.name | string | `"Botkube Error"` |  |
| customRules.alerting.botKube.query_key | string | `"message"` |  |
| customRules.alerting.botKube.realert.minutes | int | `30` |  |
| customRules.alerting.botKube.slack_alert_fields[0].title | string | `"Cluster"` |  |
| customRules.alerting.botKube.slack_alert_fields[0].value | string | `"Cluster"` |  |
| customRules.alerting.botKube.slack_alert_fields[1].title | string | `"Title"` |  |
| customRules.alerting.botKube.slack_alert_fields[1].value | string | `"Title"` |  |
| customRules.alerting.botKube.slack_alert_fields[2].title | string | `"Messages"` |  |
| customRules.alerting.botKube.slack_alert_fields[2].value | string | `"Messages[0]"` |  |
| customRules.alerting.botKube.slack_alert_fields[3].title | string | `"TimeStamp"` |  |
| customRules.alerting.botKube.slack_alert_fields[3].value | string | `"TimeStamp"` |  |
| customRules.alerting.botKube.slack_alert_fields[4].title | string | `"Kind"` |  |
| customRules.alerting.botKube.slack_alert_fields[4].value | string | `"Kind"` |  |
| customRules.alerting.botKube.slack_alert_fields[5].title | string | `"Name"` |  |
| customRules.alerting.botKube.slack_alert_fields[5].value | string | `"Name"` |  |
| customRules.alerting.botKube.slack_alert_fields[6].title | string | `"Reason"` |  |
| customRules.alerting.botKube.slack_alert_fields[6].value | string | `"Reason"` |  |
| customRules.alerting.botKube.slack_title | string | `"Botkube Error"` |  |
| customRules.alerting.botKube.slack_webhook_url | string | `"{{ $.Values.customRules.slack.webhookUrl }}"` |  |
| customRules.alerting.botKube.timestamp_field | string | `"TimeStamp"` |  |
| customRules.alerting.botKube.type | string | `"any"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.alert[0] | string | `"slack"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.alert_text_args[0] | string | `"@timestamp"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.alert_text_type | string | `"aggregation_summary_only"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.exponential_realert.days | int | `3` |  |
| customRules.alerting.kafkaTopicCreatedNotification.fields[0] | string | `"message"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.filter[0].query_string.query | string | `"message: \"Creating topic\" AND \"with configuration\" AND \"and initial partition assignment\""` |  |
| customRules.alerting.kafkaTopicCreatedNotification.index | string | `"kafka*"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.name | string | `"Kafka Topic Notification"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.query_key | string | `"message"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.realert.minutes | int | `30` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack | string | `nil` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[0].title | string | `"Stage"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[0].value | string | `"labels.stage"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[1].title | string | `"App"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[1].value | string | `"kubernetes.labels.app"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[2].title | string | `"Pod"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[2].value | string | `"kubernetes.pod.name"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[3].title | string | `"Message"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[3].value | string | `"message"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[4].title | string | `"upstream_addr"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[4].value | string | `"upstream_addr"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[5].short | bool | `true` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[5].title | string | `"Request Id"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[5].value | string | `"requestId"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[6].title | string | `"Stacktrace"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[6].value | string | `"stacktrace"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[7].title | string | `"User"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_alert_fields[7].value | string | `"user"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_title | string | `"Kafka Topic Notification"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.slack_webhook_url | string | `"{{ $.Values.customRules.slack.webhookUrl }}"` |  |
| customRules.alerting.kafkaTopicCreatedNotification.type | string | `"any"` |  |
| customRules.alerting.kyverno.alert[0] | string | `"slack"` |  |
| customRules.alerting.kyverno.alert_text_args[0] | string | `"@timestamp"` |  |
| customRules.alerting.kyverno.alert_text_type | string | `"aggregation_summary_only"` |  |
| customRules.alerting.kyverno.exponential_realert.days | int | `3` |  |
| customRules.alerting.kyverno.fields[0] | string | `"message"` |  |
| customRules.alerting.kyverno.filter[0].query_string.query | string | `"message: \"validation failed\" OR message: \"policy validation errors\""` |  |
| customRules.alerting.kyverno.index | string | `"kyverno*"` |  |
| customRules.alerting.kyverno.name | string | `"Kyverno Error"` |  |
| customRules.alerting.kyverno.query_key | string | `"message"` |  |
| customRules.alerting.kyverno.realert.minutes | int | `30` |  |
| customRules.alerting.kyverno.slack_alert_fields[0].title | string | `"Stage"` |  |
| customRules.alerting.kyverno.slack_alert_fields[0].value | string | `"labels.stage"` |  |
| customRules.alerting.kyverno.slack_alert_fields[1].title | string | `"Component"` |  |
| customRules.alerting.kyverno.slack_alert_fields[1].value | string | `"kubernetes.labels.app_kubernetes_io/component"` |  |
| customRules.alerting.kyverno.slack_alert_fields[2].title | string | `"Pod"` |  |
| customRules.alerting.kyverno.slack_alert_fields[2].value | string | `"kubernetes.pod.name"` |  |
| customRules.alerting.kyverno.slack_alert_fields[3].title | string | `"Message"` |  |
| customRules.alerting.kyverno.slack_alert_fields[3].value | string | `"message"` |  |
| customRules.alerting.kyverno.slack_title | string | `"Kyverno Error"` |  |
| customRules.alerting.kyverno.slack_webhook_url | string | `"{{ $.Values.customRules.slack.webhookUrl }}"` |  |
| customRules.alerting.kyverno.type | string | `"any"` |  |
| customRules.alerting.vaultInjection.alert[0] | string | `"slack"` |  |
| customRules.alerting.vaultInjection.alert_text_args[0] | string | `"@time"` |  |
| customRules.alerting.vaultInjection.alert_text_type | string | `"aggregation_summary_only"` |  |
| customRules.alerting.vaultInjection.exponential_realert.days | int | `3` |  |
| customRules.alerting.vaultInjection.fields[0] | string | `"msg"` |  |
| customRules.alerting.vaultInjection.filter[0].eql | string | `"any where message like~ \"\\\\[ERROR\\\\]\""` |  |
| customRules.alerting.vaultInjection.index | string | `"vault*"` |  |
| customRules.alerting.vaultInjection.name | string | `"Vault Injection Error"` |  |
| customRules.alerting.vaultInjection.query_key | string | `"msg"` |  |
| customRules.alerting.vaultInjection.realert.minutes | int | `30` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[0].title | string | `"Stage"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[0].value | string | `"labels.stage"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[1].title | string | `"Msg"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[1].value | string | `"msg"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[2].title | string | `"Name"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[2].value | string | `"name"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[3].title | string | `"Error"` |  |
| customRules.alerting.vaultInjection.slack_alert_fields[3].value | string | `"error"` |  |
| customRules.alerting.vaultInjection.slack_title | string | `"Vault Injection Error"` |  |
| customRules.alerting.vaultInjection.slack_webhook_url | string | `"{{ $.Values.customRules.slack.webhookUrl }}"` |  |
| customRules.alerting.vaultInjection.type | string | `"any"` |  |
| customRules.slack.webhookUrl | string | `nil` | Required |
| elastalert2.elasticsearch.host | string | `"elasticsearch-master"` | needs to be in the same namespaces as elastic stack if used like this |
| elastalert2.secretRulesList[0] | string | `"argoCD"` |  |
| elastalert2.secretRulesList[1] | string | `"botKube"` |  |
| elastalert2.secretRulesList[2] | string | `"vaultInjection"` |  |
| elastalert2.secretRulesList[3] | string | `"kyverno"` |  |
| elastalert2.secretRulesList[4] | string | `"kafkaTopicCreatedNotification"` |  |
| elastalert2.secretRulesName | string | `"elastalert-custom-rules"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

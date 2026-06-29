# elastic-operator

![Version: 9.3.5-eso](https://img.shields.io/badge/Version-9.3.5--eso-informational?style=flat-square) ![AppVersion: 9.3.5](https://img.shields.io/badge/AppVersion-9.3.5-informational?style=flat-square)

Elasticsearch + filebeat + kibana with default common used indexes and Index Lifecycle Management.
It comes also with a backup functionality. This is the version using ECK-operator to deploy and monitor the stack.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.iits.tech | common | 0.4.0 |
| https://helm.elastic.co | eck-operator | 3.4.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.roles.custom_elastalert.cluster[0] | string | `"monitor"` |  |
| auth.roles.custom_elastalert.indices[0].names[0] | string | `"elastalert*"` |  |
| auth.roles.custom_elastalert.indices[0].privileges[0] | string | `"all"` |  |
| auth.roles.custom_elastalert.indices[1].names[0] | string | `"*"` |  |
| auth.roles.custom_elastalert.indices[1].privileges[0] | string | `"read"` |  |
| auth.roles.custom_elastalert.indices[1].privileges[1] | string | `"monitor"` |  |
| auth.roles.custom_elastalert.indices[1].privileges[2] | string | `"view_index_metadata"` |  |
| auth.roles.custom_filebeat.cluster[0] | string | `"monitor"` |  |
| auth.roles.custom_filebeat.cluster[1] | string | `"read_pipeline"` |  |
| auth.roles.custom_filebeat.cluster[2] | string | `"manage_ilm"` |  |
| auth.roles.custom_filebeat.cluster[3] | string | `"manage_ingest_pipelines"` |  |
| auth.roles.custom_filebeat.cluster[4] | string | `"manage_index_templates"` |  |
| auth.roles.custom_filebeat.indices[0].names[0] | string | `"*"` |  |
| auth.roles.custom_filebeat.indices[0].privileges[0] | string | `"monitor"` |  |
| auth.roles.custom_filebeat.indices[0].privileges[1] | string | `"create_index"` |  |
| auth.roles.custom_filebeat.indices[0].privileges[2] | string | `"create_doc"` |  |
| auth.roles.custom_filebeat.indices[0].privileges[3] | string | `"view_index_metadata"` |  |
| auth.roles.custom_filebeat.indices[0].privileges[4] | string | `"manage_follow_index"` |  |
| auth.users.custom_elastalert.existingPassword | string | `""` |  |
| auth.users.custom_elastalert.roles | list | `["custom_elastalert"]` | Required, if common.externalSecret.enabled. path: "REPLACE_ME" |
| auth.users.custom_filebeat.existingPassword | string | `""` |  |
| auth.users.custom_filebeat.roles | list | `["custom_filebeat"]` | field within the vault secret to read/write (default "password"). Override to pack several users into one vault secret distinguished by property. property: "filebeat_password" |
| auth.users.custom_kibana_guest.existingPassword | string | `""` |  |
| auth.users.custom_kibana_guest.roles | list | `["viewer"]` | Required, if common.externalSecret.enabled. path: "REPLACE_ME" |
| backup.enabled | bool | `false` |  |
| backup.image.repository | string | `"docker.io/curlimages/curl"` |  |
| backup.image.tag | string | `"8.13.0"` |  |
| backup.image.userId | int | `100` |  |
| backup.nodeSelector | object | `{}` |  |
| backup.policy.indices[0] | string | `"*"` |  |
| backup.policy.name | string | `"nightly-backup"` |  |
| backup.policy.retention.expireAfter | string | `"15d"` |  |
| backup.policy.retention.maxCount | int | `15` |  |
| backup.policy.retention.minCount | int | `5` |  |
| backup.policy.schedule | string | `"0 0 0 * * ?"` |  |
| backup.repoName | string | `"elastic-backups"` |  |
| backup.repoType | string | `"s3"` | for Azure blob storage use "azure" |
| backup.repositorySettings | string | `nil` |  |
| backup.secureSettings | string | `nil` | vault path for the secure settings, used only in ESO mode (common.externalSecret.enabled). The settings below are then pulled from this path instead of being inlined. path: "REPLACE_ME" In ESO mode (common.externalSecret.enabled) the value of each setting is the vault property to read (remoteKey), not the literal secret — leave empty to default the property to the setting name. |
| backup.tolerations | list | `[]` |  |
| common.externalSecret.enabled | bool | `false` | Enable ESO mode. When true, the bash generate-passwords job and the static basic-auth Secrets are replaced by a single Password generator plus a per-user push/pull round-trip against the secretStore below. Per-user vault paths come from auth.users.<user>.path. |
| common.externalSecret.secretStore | object | `{"kind":"ClusterSecretStore","name":"vault"}` | Sets the Store for all externalSecret resources from common chart |
| eck-operator.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| elasticsearch.config.cluster.max_shards_per_node | int | `30000` |  |
| elasticsearch.config.http.max_header_size | string | `"16kb"` |  |
| elasticsearch.config.node.store.allow_mmap | bool | `false` |  |
| elasticsearch.enabled | bool | `true` |  |
| elasticsearch.extraSecureSettings | list | `[]` |  |
| elasticsearch.javaOpts | string | `""` |  |
| elasticsearch.nodeCount | int | `2` |  |
| elasticsearch.podTemplateSpec.containers[0].env[0].name | string | `"ES_JAVA_OPTS"` |  |
| elasticsearch.podTemplateSpec.containers[0].env[0].value | string | `"{{ .Values.elasticsearch.javaOpts }}"` |  |
| elasticsearch.podTemplateSpec.containers[0].name | string | `"elasticsearch"` |  |
| elasticsearch.podTemplateSpec.containers[0].resources.limits.memory | string | `"{{ .Values.elasticsearch.resources.limits.memory }}"` |  |
| elasticsearch.podTemplateSpec.containers[0].resources.requests.cpu | string | `"{{ .Values.elasticsearch.resources.requests.cpu }}"` |  |
| elasticsearch.podTemplateSpec.containers[0].resources.requests.memory | string | `"{{ .Values.elasticsearch.resources.requests.memory }}"` |  |
| elasticsearch.resources.limits.memory | string | `"8G"` |  |
| elasticsearch.resources.requests.cpu | string | `"200m"` |  |
| elasticsearch.resources.requests.memory | string | `"8G"` |  |
| elasticsearch.version | string | `"{{ .Chart.AppVersion }}"` |  |
| elasticsearch.volumeSize | string | `"200G"` |  |
| filebeat.autodiscover.providers[0].hints.default_config.id | string | `"kubernetes-container-logs-${data.kubernetes.pod.name}-${data.kubernetes.container.id}"` |  |
| filebeat.autodiscover.providers[0].hints.default_config.parsers[0].container | object | `{}` |  |
| filebeat.autodiscover.providers[0].hints.default_config.paths[0] | string | `"/var/log/containers/*${data.kubernetes.container.id}.log"` |  |
| filebeat.autodiscover.providers[0].hints.default_config.prospector.scanner."fingerprint.enabled" | bool | `true` |  |
| filebeat.autodiscover.providers[0].hints.default_config.prospector.scanner.symlinks | bool | `true` |  |
| filebeat.autodiscover.providers[0].hints.default_config.type | string | `"filestream"` |  |
| filebeat.autodiscover.providers[0].hints.enabled | bool | `true` |  |
| filebeat.autodiscover.providers[0].node | string | `"${NODE_NAME}"` |  |
| filebeat.autodiscover.providers[0].type | string | `"kubernetes"` |  |
| filebeat.enabled | bool | `true` |  |
| filebeat.env[0].name | string | `"NODE_NAME"` |  |
| filebeat.env[0].valueFrom.fieldRef.apiVersion | string | `"v1"` |  |
| filebeat.env[0].valueFrom.fieldRef.fieldPath | string | `"spec.nodeName"` |  |
| filebeat.env[1].name | string | `"ELASTICSEARCH_USERNAME"` |  |
| filebeat.env[1].valueFrom.secretKeyRef.key | string | `"username"` |  |
| filebeat.env[1].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-custom-filebeat"` |  |
| filebeat.env[2].name | string | `"ELASTICSEARCH_PASSWORD"` |  |
| filebeat.env[2].valueFrom.secretKeyRef.key | string | `"password"` |  |
| filebeat.env[2].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-custom-filebeat"` |  |
| filebeat.extraEnv | list | `[]` | example: Setup stage name - name: STAGE   value: "REPLACE_ME" |
| filebeat.extraIndices | list | `[]` |  |
| filebeat.extraProcessors | list | `[]` |  |
| filebeat.extraVolumeMounts | list | `[]` |  |
| filebeat.extraVolumes | list | `[]` |  |
| filebeat.indices[0].index | string | `"%{[kubernetes.namespace]:not-defined}-%{[kubernetes.labels.app_kubernetes_io/name]}-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.indices[0].when.has_fields[0] | string | `"kubernetes.labels.app_kubernetes_io/name"` |  |
| filebeat.indices[1].index | string | `"%{[kubernetes.namespace]:not-defined}-%{[kubernetes.labels.app]}-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.indices[1].when.has_fields[0] | string | `"kubernetes.labels.app"` |  |
| filebeat.indices[2].index | string | `"%{[kubernetes.namespace]:not-defined}-not-defined-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.processors[0].add_kubernetes_metadata | object | `{}` |  |
| filebeat.processors[1].decode_json_fields.add_error_key | bool | `true` |  |
| filebeat.processors[1].decode_json_fields.fields[0] | string | `"message"` |  |
| filebeat.processors[1].decode_json_fields.overwrite_keys | bool | `true` |  |
| filebeat.processors[1].decode_json_fields.target | string | `""` |  |
| filebeat.processors[1].decode_json_fields.when.has_fields[0] | string | `"message"` |  |
| filebeat.processors[2].decode_json_fields.add_error_key | bool | `true` |  |
| filebeat.processors[2].decode_json_fields.fields[0] | string | `"msg"` |  |
| filebeat.processors[2].decode_json_fields.overwrite_keys | bool | `true` |  |
| filebeat.processors[2].decode_json_fields.target | string | `""` |  |
| filebeat.processors[2].decode_json_fields.when.has_fields[0] | string | `"msg"` |  |
| filebeat.processors[3].add_labels.labels.stage | string | `"${STAGE:dev}"` |  |
| filebeat.processors[4].drop_event.when.or[0].equals."kubernetes.labels".common_k8s_elastic_co/type | string | `"elasticsearch"` |  |
| filebeat.processors[4].drop_event.when.or[10].equals."kubernetes.labels".app_kubernetes_io/name | string | `"vault-secrets-webhook"` |  |
| filebeat.processors[4].drop_event.when.or[11].equals."kubernetes.namespace" | string | `"kube-system"` |  |
| filebeat.processors[4].drop_event.when.or[1].equals."kubernetes.labels".common_k8s_elastic_co/type | string | `"beat"` |  |
| filebeat.processors[4].drop_event.when.or[2].equals."kubernetes.labels".common_k8s_elastic_co/type | string | `"kibana"` |  |
| filebeat.processors[4].drop_event.when.or[3].equals."kubernetes.labels".app_kubernetes_io/name | string | `"grafana"` |  |
| filebeat.processors[4].drop_event.when.or[4].equals."kubernetes.labels".app_kubernetes_io/name | string | `"prometheus-stack-prometheus-operator"` |  |
| filebeat.processors[4].drop_event.when.or[5].equals."kubernetes.labels".app_kubernetes_io/name | string | `"prometheus"` |  |
| filebeat.processors[4].drop_event.when.or[6].equals."kubernetes.labels".app_kubernetes_io/name | string | `"kube-state-metrics"` |  |
| filebeat.processors[4].drop_event.when.or[7].equals."kubernetes.labels".app_kubernetes_io/name | string | `"argo-cd"` |  |
| filebeat.processors[4].drop_event.when.or[8].contains."kubernetes.labels".app_kubernetes_io/name | string | `"traefik"` |  |
| filebeat.processors[4].drop_event.when.or[8].contains.error | string | `"read: connection reset by peer"` |  |
| filebeat.processors[4].drop_event.when.or[9].equals."kubernetes.labels".app_kubernetes_io/name | string | `"gatekeeper"` |  |
| filebeat.processors[4].drop_event.when.or[9].equals.msg | string | `"authentication session not found in request"` |  |
| filebeat.readinessProbe.failureThreshold | int | `50` |  |
| filebeat.readinessProbe.initialDelaySeconds | int | `20` |  |
| filebeat.readinessProbe.periodSeconds | int | `30` |  |
| filebeat.readinessProbe.timeoutSeconds | int | `10` |  |
| filebeat.resources.limits.memory | string | `"500M"` |  |
| filebeat.resources.requests.cpu | string | `"100m"` |  |
| filebeat.resources.requests.memory | string | `"100M"` |  |
| filebeat.tolerations | list | `[]` |  |
| filebeat.version | string | `"{{ .Chart.AppVersion }}"` |  |
| filebeat.volumeMounts[0].mountPath | string | `"/var/lib/containerd/container_logs"` |  |
| filebeat.volumeMounts[0].name | string | `"varlibcontainerdcontainerlogs"` |  |
| filebeat.volumeMounts[0].readOnly | bool | `true` |  |
| filebeat.volumeMounts[1].mountPath | string | `"/var/log"` |  |
| filebeat.volumeMounts[1].name | string | `"varlog"` |  |
| filebeat.volumeMounts[1].readOnly | bool | `true` |  |
| filebeat.volumes[0].hostPath.path | string | `"/var/lib/containerd/container_logs"` |  |
| filebeat.volumes[0].name | string | `"varlibcontainerdcontainerlogs"` |  |
| filebeat.volumes[1].hostPath.path | string | `"/var/log"` |  |
| filebeat.volumes[1].hostPath.type | string | `""` |  |
| filebeat.volumes[1].name | string | `"varlog"` |  |
| generatePasswords.deletionPolicy | string | `"Delete"` | ESO mode only: defines if secrets pushed to the secretStore are deleted or kept in the provider after the ESO pushSecret is deleted. |
| generatePasswords.enabled | bool | `true` | Generate user passwords. In non-ESO mode this toggles the bash generate-passwords job. In ESO mode (common.externalSecret.enabled) it toggles the Password generator + push: true generates and round-trips through vault; false is BYO (pull-only, passwords pre-seeded in vault). |
| generatePasswords.image.repository | string | `"docker.io/bitnamilegacy/kubectl"` |  |
| generatePasswords.image.tag | string | `"1.32.4"` |  |
| generatePasswords.image.userId | int | `100` |  |
| generatePasswords.nodeSelector | object | `{}` |  |
| generatePasswords.refreshInterval | string | `"1h"` | ESO mode only: how often the per-user push/pull secrets reconcile. Leave empty to use the common chart's per-resource defaults (push "1h", pull "1m"). |
| generatePasswords.secrets[0].key | string | `"password"` |  |
| generatePasswords.secrets[0].name | string | `"{{ .Release.Name }}-user-custom-kibana-guest"` |  |
| generatePasswords.secrets[1].key | string | `"password"` |  |
| generatePasswords.secrets[1].name | string | `"{{ .Release.Name }}-user-custom-filebeat"` |  |
| generatePasswords.secrets[2].key | string | `"password"` |  |
| generatePasswords.secrets[2].name | string | `"{{ .Release.Name }}-user-custom-elastalert"` |  |
| generatePasswords.spec | object | `{"allowRepeat":true,"digits":5,"length":32,"noUpper":false,"symbols":0}` | Password generation policy. In ESO mode (common.externalSecret.enabled) this maps directly to the shared ExternalSecrets Password generator spec; length also feeds the bash job default. |
| generatePasswords.tolerations | list | `[]` |  |
| ilm.image.repository | string | `"docker.io/curlimages/curl"` |  |
| ilm.image.tag | string | `"8.13.0"` |  |
| ilm.image.userId | int | `100` |  |
| ilm.nodeSelector | object | `{}` |  |
| ilm.policies.long.coldAfter | string | `"32d"` |  |
| ilm.policies.long.deleteAfter | string | `"365d"` |  |
| ilm.policies.long.indexPatterns[0] | string | `"auth*"` |  |
| ilm.policies.long.indexPatterns[1] | string | `"vault*"` |  |
| ilm.policies.medium.coldAfter | string | `"32d"` |  |
| ilm.policies.medium.deleteAfter | string | `"90d"` |  |
| ilm.policies.medium.indexPatterns[0] | string | `"cert-manager*"` |  |
| ilm.policies.medium.indexPatterns[1] | string | `"routing*"` |  |
| ilm.policies.medium.indexPatterns[2] | string | `"not-defined*"` |  |
| ilm.policies.short.coldAfter | string | `"2d"` |  |
| ilm.policies.short.deleteAfter | string | `"14d"` |  |
| ilm.policies.short.indexPatterns[0] | string | `"admin*"` |  |
| ilm.policies.short.indexPatterns[1] | string | `"argocd*"` |  |
| ilm.policies.short.indexPatterns[2] | string | `"kyverno*"` |  |
| ilm.policies.short.indexPatterns[3] | string | `"monitoring*"` |  |
| ilm.tolerations | list | `[]` |  |
| indexPatternInit.image.repository | string | `"docker.io/curlimages/curl"` |  |
| indexPatternInit.image.tag | string | `"8.12.1"` |  |
| indexPatternInit.image.userId | int | `100` |  |
| indexPatternInit.indices.admin.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.argocd.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.auth.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.cert-manager.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.kyverno.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.monitoring.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.not-defined.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.routing.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.vault.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.nodeSelector | object | `{}` |  |
| indexPatternInit.tolerations | list | `[]` |  |
| ingress.elasticsearch.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.elasticsearch.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd"` |  |
| ingress.elasticsearch.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.elasticsearch.className | string | `"traefik"` |  |
| ingress.elasticsearch.enabled | bool | `false` |  |
| ingress.elasticsearch.host | string | `"REPLACE_ME"` | Required, if enabled |
| ingress.elasticsearch.labels | string | `nil` |  |
| ingress.elasticsearch.path | string | `"/elasticsearch"` |  |
| ingress.elasticsearch.tls[0].hosts[0] | string | `"{{ .Values.ingress.elasticsearch.host }}"` |  |
| ingress.kibana.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.kibana.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-oidc-forward-auth@kubernetescrd"` |  |
| ingress.kibana.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.kibana.className | string | `"traefik"` |  |
| ingress.kibana.enabled | bool | `true` |  |
| ingress.kibana.host | string | `"REPLACE_ME"` | Required, if enabled |
| ingress.kibana.labels | string | `nil` |  |
| ingress.kibana.path | string | `"/kibana"` |  |
| ingress.kibana.tls[0].hosts[0] | string | `"{{ .Values.ingress.kibana.host }}"` |  |
| kibana.config.monitoring.ui.container.elasticsearch.enabled | bool | `true` |  |
| kibana.config.monitoring.ui.enabled | bool | `true` |  |
| kibana.config.server.basePath | string | `"{{ .Values.ingress.kibana.path }}"` |  |
| kibana.config.server.publicBaseUrl | string | `"https://{{ .Values.ingress.kibana.host }}{{ .Values.ingress.kibana.path }}"` |  |
| kibana.config.server.rewriteBasePath | bool | `true` |  |
| kibana.config.xpack.reporting.csv.maxSizeBytes | int | `1048576000` |  |
| kibana.config.xpack.reporting.queue.timeout | int | `1800000` |  |
| kibana.config.xpack.security.authc.providers.anonymous.anonymous1.credentials.password | string | `"${ANONYMOUS_PASSWORD}"` |  |
| kibana.config.xpack.security.authc.providers.anonymous.anonymous1.credentials.username | string | `"${ANONYMOUS_USERNAME}"` |  |
| kibana.config.xpack.security.authc.providers.anonymous.anonymous1.order | int | `0` |  |
| kibana.config.xpack.security.authc.providers.basic.basic1.order | int | `1` |  |
| kibana.count | int | `2` |  |
| kibana.enabled | bool | `true` |  |
| kibana.podTemplateSpec.containers[0].env[0].name | string | `"ANONYMOUS_USERNAME"` |  |
| kibana.podTemplateSpec.containers[0].env[0].valueFrom.secretKeyRef.key | string | `"username"` |  |
| kibana.podTemplateSpec.containers[0].env[0].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-custom-kibana-guest"` |  |
| kibana.podTemplateSpec.containers[0].env[1].name | string | `"ANONYMOUS_PASSWORD"` |  |
| kibana.podTemplateSpec.containers[0].env[1].valueFrom.secretKeyRef.key | string | `"password"` |  |
| kibana.podTemplateSpec.containers[0].env[1].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-custom-kibana-guest"` |  |
| kibana.podTemplateSpec.containers[0].name | string | `"kibana"` |  |
| kibana.podTemplateSpec.containers[0].resources.limits.memory | string | `"{{ .Values.kibana.resources.limits.memory }}"` |  |
| kibana.podTemplateSpec.containers[0].resources.requests.cpu | string | `"{{ .Values.kibana.resources.requests.cpu }}"` |  |
| kibana.podTemplateSpec.containers[0].resources.requests.memory | string | `"{{ .Values.kibana.resources.requests.memory }}"` |  |
| kibana.podTemplateSpec.containers[0].securityContext.allowPrivilegeEscalation | bool | `false` |  |
| kibana.podTemplateSpec.containers[0].securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| kibana.podTemplateSpec.containers[0].securityContext.runAsNonRoot | bool | `true` |  |
| kibana.podTemplateSpec.containers[0].securityContext.runAsUser | int | `1000` |  |
| kibana.podTemplateSpec.containers[0].securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| kibana.podTemplateSpec.initContainers[0].name | string | `"elastic-internal-init"` |  |
| kibana.podTemplateSpec.initContainers[0].resources.limits.memory | string | `"50Mi"` |  |
| kibana.podTemplateSpec.initContainers[0].resources.requests.cpu | string | `"250m"` |  |
| kibana.podTemplateSpec.initContainers[0].resources.requests.memory | string | `"50Mi"` |  |
| kibana.podTemplateSpec.initContainers[0].securityContext.allowPrivilegeEscalation | bool | `false` |  |
| kibana.podTemplateSpec.initContainers[0].securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| kibana.podTemplateSpec.initContainers[0].securityContext.runAsNonRoot | bool | `true` |  |
| kibana.podTemplateSpec.initContainers[0].securityContext.runAsUser | int | `1000` |  |
| kibana.podTemplateSpec.initContainers[0].securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| kibana.podTemplateSpec.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| kibana.resources.limits.memory | string | `"2G"` |  |
| kibana.resources.requests.cpu | string | `"100m"` |  |
| kibana.resources.requests.memory | string | `"1G"` |  |
| kibana.version | string | `"{{ .Chart.AppVersion }}"` |  |
| policyException.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

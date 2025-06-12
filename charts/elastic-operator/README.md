# elastic-operator

![Version: 8.18.1-fb-tolerations](https://img.shields.io/badge/Version-8.18.1--fb--tolerations-informational?style=flat-square) ![AppVersion: 8.18.1](https://img.shields.io/badge/AppVersion-8.18.1-informational?style=flat-square)

Elasticsearch + filebeat + kibana with default common used indexes and Index Lifecycle Management.
It comes also with a backup functionality. This is the version using ECK-operator to deploy and monitor the stack.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.elastic.co | eck-operator | 3.0.0 |

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
| auth.roles.logstash.cluster[0] | string | `"manage_index_templates"` |  |
| auth.roles.logstash.cluster[1] | string | `"monitor"` |  |
| auth.roles.logstash.cluster[2] | string | `"manage_ilm"` |  |
| auth.roles.logstash.indices[0].names[0] | string | `"*"` |  |
| auth.roles.logstash.indices[0].privileges[0] | string | `"write"` |  |
| auth.roles.logstash.indices[0].privileges[1] | string | `"create"` |  |
| auth.roles.logstash.indices[0].privileges[2] | string | `"create_index"` |  |
| auth.roles.logstash.indices[0].privileges[3] | string | `"manage"` |  |
| auth.roles.logstash.indices[0].privileges[4] | string | `"manage_ilm"` |  |
| auth.users.custom_elastalert.existingPassword | string | `""` |  |
| auth.users.custom_elastalert.roles[0] | string | `"custom_elastalert"` |  |
| auth.users.custom_filebeat.existingPassword | string | `""` |  |
| auth.users.custom_filebeat.roles[0] | string | `"custom_filebeat"` |  |
| auth.users.custom_kibana_guest.existingPassword | string | `""` |  |
| auth.users.custom_kibana_guest.roles[0] | string | `"viewer"` |  |
| auth.users.logstash.existingPassword | string | `""` |  |
| auth.users.logstash.roles[0] | string | `"logstash"` |  |
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
| backup.secureSettings | string | `nil` |  |
| backup.tolerations | list | `[]` |  |
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
| filebeat.autodiscover.providers[0]."hints.default_config".paths[0] | string | `"/var/log/containers/*${data.container.id}.log"` |  |
| filebeat.autodiscover.providers[0]."hints.default_config".type | string | `"container"` |  |
| filebeat.autodiscover.providers[0]."hints.enabled" | bool | `true` |  |
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
| filebeat.indices[0].index | string | `"%{[kubernetes.namespace]:not-defined}-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.processors[0].add_kubernetes_metadata | object | `{}` |  |
| filebeat.processors[1].decode_json_fields.fields[0] | string | `"message"` |  |
| filebeat.processors[1].decode_json_fields.overwrite_keys | bool | `true` |  |
| filebeat.processors[1].decode_json_fields.target | string | `""` |  |
| filebeat.processors[1].decode_json_fields.when.has_fields[0] | string | `"message"` |  |
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
| generatePasswords.enabled | bool | `true` |  |
| generatePasswords.image.repository | string | `"docker.io/bitnami/kubectl"` |  |
| generatePasswords.image.tag | string | `"1.32.4"` |  |
| generatePasswords.image.userId | int | `100` |  |
| generatePasswords.nodeSelector | object | `{}` |  |
| generatePasswords.secrets[0].key | string | `"password"` |  |
| generatePasswords.secrets[0].name | string | `"{{ .Release.Name }}-user-custom-kibana-guest"` |  |
| generatePasswords.secrets[1].key | string | `"password"` |  |
| generatePasswords.secrets[1].name | string | `"{{ .Release.Name }}-user-custom-filebeat"` |  |
| generatePasswords.secrets[2].key | string | `"password"` |  |
| generatePasswords.secrets[2].name | string | `"{{ .Release.Name }}-user-custom-elastalert"` |  |
| generatePasswords.tolerations | list | `[]` |  |
| generateTLS.enabled | bool | `false` |  |
| generateTLS.secretName | string | `"tls-elastic"` |  |
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
| indexPatternInit.enabled | bool | `true` |  |
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
| indexPatternInit.indices.vault.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.nodeSelector | object | `{}` |  |
| indexPatternInit.skipExisting | bool | `false` |  |
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
| kibana.resources.limits.memory | string | `"1G"` |  |
| kibana.resources.requests.cpu | string | `"100m"` |  |
| kibana.resources.requests.memory | string | `"1G"` |  |
| kibana.version | string | `"{{ .Chart.AppVersion }}"` |  |
| logstash.config."pipeline.batch.size" | int | `125` |  |
| logstash.elasticsearchRefs[0].clusterName | string | `"default"` |  |
| logstash.elasticsearchRefs[0].name | string | `"{{ .Release.Name }}"` |  |
| logstash.enabled | bool | `false` |  |
| logstash.env[0].name | string | `"NODE_NAME"` |  |
| logstash.env[0].valueFrom.fieldRef.apiVersion | string | `"v1"` |  |
| logstash.env[0].valueFrom.fieldRef.fieldPath | string | `"spec.nodeName"` |  |
| logstash.env[1].name | string | `"LOGSTASH_USERNAME"` |  |
| logstash.env[1].valueFrom.secretKeyRef.key | string | `"username"` |  |
| logstash.env[1].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-logstash"` |  |
| logstash.env[2].name | string | `"LOGSTASH_PASSWORD"` |  |
| logstash.env[2].valueFrom.secretKeyRef.key | string | `"password"` |  |
| logstash.env[2].valueFrom.secretKeyRef.name | string | `"{{ .Release.Name }}-user-logstash"` |  |
| logstash.pipelines[0]."config.string" | string | `"input {\n  beats {\n    port => 5044\n  }\n}\nfilter {\n  ### The config works from top to bottom, everytime it finds a match, the target_index will be overwritten\n  mutate {\n    add_field => { \"[@metadata][target_index]\" => \"not-defined-%{[agent][version]}-%{+yyyy.MM}\" }\n  }\n  ### Example: Overrides the default index, if the namespace is argocd\n  if [kubernetes][namespace] == \"argocd\" {\n    mutate { replace => { \"[@metadata][target_index]\" => \"argocd_%{[agent][version]}-%{+yyyy.MM}\" } }\n  }\n}\n\noutput {\n  elasticsearch {\n    hosts => [ \"${DEFAULT_ES_HOSTS}\" ]\n    user => \"${LOGSTASH_USERNAME}\"\n    password => \"${LOGSTASH_PASSWORD}\"\n    cacert => \"${DEFAULT_ES_SSL_CERTIFICATE_AUTHORITY}\"\n    index => \"%{[@metadata][target_index]}\"\n  }\n}\n"` |  |
| logstash.pipelines[0]."pipeline.id" | string | `"default-elasticsearch"` |  |
| logstash.version | string | `"{{ .Chart.AppVersion }}"` |  |
| policyException.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)

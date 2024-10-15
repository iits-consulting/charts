# elastic-operator

![Version: 8.14.3](https://img.shields.io/badge/Version-8.14.3-informational?style=flat-square) ![AppVersion: 8.14.3](https://img.shields.io/badge/AppVersion-8.14.3-informational?style=flat-square)

Elasticsearch + filebeat + kibana with default common used indexes and Index Lifecycle Management.
It comes also with a backup functionality. This is the version using ECK-operator to deploy and monitor the stack.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.elastic.co | eck-operator | 2.13.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.enabled | bool | `false` |  |
| backup.image.repository | string | `"docker.io/curlimages/curl"` |  |
| backup.image.tag | string | `"7.82.0"` |  |
| backup.image.userId | int | `100` |  |
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
| elasticsearch.config.cluster.max_shards_per_node | int | `30000` |  |
| elasticsearch.config.http.max_header_size | string | `"16kb"` |  |
| elasticsearch.config.node.store.allow_mmap | bool | `false` |  |
| elasticsearch.config.xpack.security.authc.anonymous.authz_exception | bool | `true` |  |
| elasticsearch.config.xpack.security.authc.anonymous.roles | string | `"superuser,kibana_admin,kibana_system"` |  |
| elasticsearch.config.xpack.security.authc.anonymous.username | string | `"anonymous_user"` |  |
| elasticsearch.enabled | bool | `true` |  |
| elasticsearch.extraSecureSettings | list | `[]` |  |
| elasticsearch.javaOpts | string | `"-Xmx6g -Xms6g -Dlog4j2.formatMsgNoLookups=true"` |  |
| elasticsearch.nodeCount | int | `2` |  |
| elasticsearch.resources.limits.cpu | string | `"1000m"` |  |
| elasticsearch.resources.limits.memory | string | `"8G"` |  |
| elasticsearch.resources.requests.cpu | string | `"200m"` |  |
| elasticsearch.resources.requests.memory | string | `"6G"` |  |
| elasticsearch.version | string | `"8.14.3"` |  |
| elasticsearch.volumeSize | string | `"200G"` |  |
| filebeat.autodiscover.providers[0]."hints.default_config".paths[0] | string | `"/var/log/containers/*${data.container.id}.log"` |  |
| filebeat.autodiscover.providers[0]."hints.default_config".type | string | `"container"` |  |
| filebeat.autodiscover.providers[0]."hints.enabled" | bool | `true` |  |
| filebeat.autodiscover.providers[0].node | string | `"${NODE_NAME}"` |  |
| filebeat.autodiscover.providers[0].type | string | `"kubernetes"` |  |
| filebeat.enabled | bool | `true` |  |
| filebeat.extraEnvs[0].name | string | `"STAGE"` |  |
| filebeat.extraEnvs[0].value | string | `"REPLACE_ME"` |  |
| filebeat.extraIndices | list | `[]` |  |
| filebeat.extraProcessors | list | `[]` |  |
| filebeat.extraVolumeMounts | list | `[]` |  |
| filebeat.extraVolumes | list | `[]` |  |
| filebeat.indices[0].index | string | `"traefik-and-keycloak-proxy-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.indices[0].when.equals."kubernetes.namespace" | string | `"routing"` |  |
| filebeat.indices[1].index | string | `"vault-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.indices[1].when.equals."kubernetes.namespace" | string | `"vault"` |  |
| filebeat.indices[2].index | string | `"argocd-%{[agent.version]}-%{+yyyy.MM.DD}"` |  |
| filebeat.indices[2].when.equals."kubernetes.namespace" | string | `"argocd"` |  |
| filebeat.indices[3].index | string | `"elastalert-%{[agent.version]}-%{+yyyy.MM.DD}"` |  |
| filebeat.indices[3].when.equals."kubernetes.container.name" | string | `"elastalert2"` |  |
| filebeat.indices[4].index | string | `"kyverno-%{[agent.version]}-%{+yyyy.MM.DD}"` |  |
| filebeat.indices[4].when.equals."kubernetes.namespace" | string | `"kyverno"` |  |
| filebeat.indices[5].index | string | `"auth-%{[agent.version]}-%{+yyyy.MM.DD}"` |  |
| filebeat.indices[5].when.equals."kubernetes.namespace" | string | `"auth"` |  |
| filebeat.indices[6].index | string | `"not-defined-%{[agent.version]}-%{+yyyy.MM}"` |  |
| filebeat.processors[0].add_kubernetes_metadata | object | `{}` |  |
| filebeat.processors[1].decode_json_fields.fields[0] | string | `"message"` |  |
| filebeat.processors[1].decode_json_fields.overwrite_keys | bool | `true` |  |
| filebeat.processors[1].decode_json_fields.target | string | `""` |  |
| filebeat.processors[1].decode_json_fields.when.has_fields[0] | string | `"message"` |  |
| filebeat.processors[2].decode_json_fields.fields[0] | string | `"msg"` |  |
| filebeat.processors[2].decode_json_fields.overwrite_keys | bool | `true` |  |
| filebeat.processors[2].decode_json_fields.target | string | `""` |  |
| filebeat.processors[2].decode_json_fields.when.has_fields[0] | string | `"msg"` |  |
| filebeat.processors[3].add_labels.labels.stage | string | `"${STAGE}"` |  |
| filebeat.processors[4].drop_event.when.or[0].equals."kubernetes.labels"."common.k8s.elastic.co/type" | string | `"elasticsearch"` |  |
| filebeat.processors[4].drop_event.when.or[10].equals."kubernetes.container.name" | string | `"portal"` |  |
| filebeat.processors[4].drop_event.when.or[11].equals."kubernetes.container.name" | string | `"repo-server"` |  |
| filebeat.processors[4].drop_event.when.or[12].equals."kubernetes.container.name" | string | `"argocd-notifications-controller"` |  |
| filebeat.processors[4].drop_event.when.or[13].equals."kubernetes.container.name" | string | `"application-controller"` |  |
| filebeat.processors[4].drop_event.when.or[14].equals."kubernetes.namespace" | string | `"kube-system"` |  |
| filebeat.processors[4].drop_event.when.or[15].equals."kubernetes.labels.component" | string | `"registry"` |  |
| filebeat.processors[4].drop_event.when.or[16].equals.RequestPath | string | `"/ping"` |  |
| filebeat.processors[4].drop_event.when.or[17].equals.RouterName | string | `"kibana@file"` |  |
| filebeat.processors[4].drop_event.when.or[18].equals.message | string | `"200 OK: GET - /public/api/health"` |  |
| filebeat.processors[4].drop_event.when.or[19].contains.message | string | `"vault-sealed-check\" does not have associated TTL"` |  |
| filebeat.processors[4].drop_event.when.or[1].equals."kubernetes.labels"."common.k8s.elastic.co/type" | string | `"beat"` |  |
| filebeat.processors[4].drop_event.when.or[20].contains.message | string | `"Error while renaming Node ID"` |  |
| filebeat.processors[4].drop_event.when.or[21].contains.message | string | `"pkg/mod/k8s.io/client-go@v0.17.0/tools/cache/reflector.go:108"` |  |
| filebeat.processors[4].drop_event.when.or[22].contains.message | string | `"TCP 200 0 0"` |  |
| filebeat.processors[4].drop_event.when.or[23].equals."auth.metadata.role_name" | string | `"gitlab"` |  |
| filebeat.processors[4].drop_event.when.or[24].equals."auth.metadata.role_name" | string | `"banzai-webhook-role"` |  |
| filebeat.processors[4].drop_event.when.or[25].equals.app | string | `"vault-secrets-webhook"` |  |
| filebeat.processors[4].drop_event.when.or[26].contains.message | string | `"agent.server: member joined, marking health alive:"` |  |
| filebeat.processors[4].drop_event.when.or[2].equals."kubernetes.labels"."common.k8s.elastic.co/type" | string | `"kibana"` |  |
| filebeat.processors[4].drop_event.when.or[3].equals."kubernetes.labels.app" | string | `"grafana"` |  |
| filebeat.processors[4].drop_event.when.or[4].equals."kubernetes.labels.app" | string | `"prometheus-stack-operator"` |  |
| filebeat.processors[4].drop_event.when.or[5].equals."kubernetes.labels.app" | string | `"botkube"` |  |
| filebeat.processors[4].drop_event.when.or[6].equals."kubernetes.labels.app" | string | `"prometheus"` |  |
| filebeat.processors[4].drop_event.when.or[7].equals.msg | string | `"no session found in request, redirecting for authorization"` |  |
| filebeat.processors[4].drop_event.when.or[8].equals."kubernetes.container.name" | string | `"kube-state-metrics"` |  |
| filebeat.processors[4].drop_event.when.or[9].equals."kubernetes.container.name" | string | `"traefik-admin-dashboard"` |  |
| filebeat.readinessProbe.failureThreshold | int | `50` |  |
| filebeat.readinessProbe.initialDelaySeconds | int | `20` |  |
| filebeat.readinessProbe.periodSeconds | int | `30` |  |
| filebeat.readinessProbe.timeoutSeconds | int | `10` |  |
| filebeat.resources.limits.cpu | string | `"400m"` |  |
| filebeat.resources.limits.memory | string | `"500M"` |  |
| filebeat.resources.requests.cpu | string | `"100m"` |  |
| filebeat.resources.requests.memory | string | `"100M"` |  |
| filebeat.tolerations | list | `[]` |  |
| filebeat.version | string | `"8.14.3"` |  |
| ilm.image.repository | string | `"docker.io/curlimages/curl"` |  |
| ilm.image.tag | string | `"8.5.0"` |  |
| ilm.image.userId | int | `100` |  |
| ilm.policies.long.coldAfter | string | `"32d"` |  |
| ilm.policies.long.deleteAfter | string | `"365d"` |  |
| ilm.policies.long.indexPatterns[0] | string | `"vault*"` |  |
| ilm.policies.medium.coldAfter | string | `"32d"` |  |
| ilm.policies.medium.deleteAfter | string | `"90d"` |  |
| ilm.policies.medium.indexPatterns[0] | string | `"not-defined*"` |  |
| ilm.policies.medium.indexPatterns[1] | string | `"traefik-and-keycloak-proxy*"` |  |
| ilm.policies.medium.indexPatterns[2] | string | `"auth*"` |  |
| ilm.policies.short.coldAfter | string | `"2d"` |  |
| ilm.policies.short.deleteAfter | string | `"14d"` |  |
| ilm.policies.short.indexPatterns[0] | string | `"elastalert*"` |  |
| ilm.policies.short.indexPatterns[1] | string | `"argocd*"` |  |
| ilm.policies.short.indexPatterns[2] | string | `"kyverno*"` |  |
| indexPatternInit.image.repository | string | `"docker.io/curlimages/curl"` |  |
| indexPatternInit.image.tag | string | `"8.5.0"` |  |
| indexPatternInit.image.userId | int | `100` |  |
| indexPatternInit.indices.argocd.index | string | `"argocd*"` |  |
| indexPatternInit.indices.argocd.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.auth.index | string | `"auth*"` |  |
| indexPatternInit.indices.auth.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.botkube.index | string | `"botkube*"` |  |
| indexPatternInit.indices.botkube.timestampField | string | `"Timestamp"` |  |
| indexPatternInit.indices.elastalert.index | string | `"elastalert*"` |  |
| indexPatternInit.indices.elastalert.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.kyverno.index | string | `"kyverno*"` |  |
| indexPatternInit.indices.kyverno.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.not-defined.index | string | `"not-defined*"` |  |
| indexPatternInit.indices.not-defined.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.traefik-and-keycloak-proxy.index | string | `"traefik-and-keycloak-proxy*"` |  |
| indexPatternInit.indices.traefik-and-keycloak-proxy.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.vault.index | string | `"vault*"` |  |
| indexPatternInit.indices.vault.timestampField | string | `"@timestamp"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"routing-admin-forward-auth@kubernetescrd, {{ $.Release.Namespace }}-remove-authorization-header-{{ $.Release.Name }}@kubernetescrd, {{ $.Release.Namespace }}-strip-prefix-{{ $.Release.Name }}@kubernetescrd"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.className | string | `"traefik"` |  |
| ingress.enabled.elasticsearch | bool | `false` |  |
| ingress.enabled.kibana | bool | `true` |  |
| ingress.host | string | `"REPLACE_ME"` | Required |
| ingress.labels | string | `nil` |  |
| kibana.config.monitoring.ui.container.elasticsearch.enabled | bool | `true` |  |
| kibana.config.monitoring.ui.enabled | bool | `true` |  |
| kibana.config.server.basePath | string | `"/kibana"` |  |
| kibana.config.server.rewriteBasePath | bool | `false` |  |
| kibana.config.xpack.reporting.csv.maxSizeBytes | int | `1048576000` |  |
| kibana.config.xpack.reporting.queue.timeout | int | `1800000` |  |
| kibana.config.xpack.security.authc.providers.anonymous.anonymous1.credentials | string | `"elasticsearch_anonymous_user"` |  |
| kibana.config.xpack.security.authc.providers.anonymous.anonymous1.order | int | `0` |  |
| kibana.config.xpack.security.authc.providers.basic.basic1.order | int | `1` |  |
| kibana.enabled | bool | `true` |  |
| kibana.version | string | `"8.14.3"` |  |
| policyException.enabled | bool | `true` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

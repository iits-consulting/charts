# elasticsearch

![Version: 8.6.1](https://img.shields.io/badge/Version-8.6.1-informational?style=flat-square)

Awesome Logs

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.elastic.co | elasticsearch | 8.5.1 |
| https://helm.elastic.co | filebeat | 8.5.1 |
| https://helm.elastic.co | kibana | 7.17.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backup.bucket.accessKey | string | `"REPLACE_ME"` | Required |
| backup.bucket.endpoint | string | `"https://obs.eu-de.otc.t-systems.com"` |  |
| backup.bucket.name | string | `"REPLACE_ME"` | Required |
| backup.bucket.secretKey | string | `"REPLACE_ME"` | Required |
| backup.image.repository | string | `"docker.io/curlimages/curl"` |  |
| backup.image.tag | string | `"7.82.0"` |  |
| backup.policy.indices[0] | string | `"*"` |  |
| backup.policy.name | string | `"nightly-backup"` |  |
| backup.policy.retention.expireAfter | string | `"15d"` |  |
| backup.policy.retention.maxCount | int | `15` |  |
| backup.policy.retention.minCount | int | `5` |  |
| backup.policy.schedule | string | `"0 0 0 * * ?"` |  |
| backup.repoName | string | `"s3_backups"` |  |
| elasticsearch.createCert | bool | `false` |  |
| elasticsearch.enabled | bool | `true` |  |
| elasticsearch.esConfig."elasticsearch.yml" | string | `"cluster.name: \"docker-cluster\"\nnetwork.host: 0.0.0.0\nhttp.max_header_size: 16kb\ncluster.max_shards_per_node: 30000\nxpack.security:\n  enabled: false\n  http.ssl.enabled: false\n  transport.ssl.enabled: false\n  authc:\n    anonymous:\n      username: anonymous\n      roles: superuser\n      authz_exception: false\n"` |  |
| elasticsearch.esJavaOpts | string | `"-Xmx6g -Xms6g -Dlog4j2.formatMsgNoLookups=true -Des.allow_insecure_settings=true"` |  |
| elasticsearch.protocol | string | `"http"` |  |
| elasticsearch.replicas | int | `2` |  |
| elasticsearch.resources.limits.cpu | string | `"1000m"` |  |
| elasticsearch.resources.limits.memory | string | `"8G"` |  |
| elasticsearch.resources.requests.cpu | string | `"200m"` |  |
| elasticsearch.resources.requests.memory | string | `"6G"` |  |
| elasticsearch.updateStrategy | string | `"RollingUpdate"` |  |
| elasticsearch.volumeClaimTemplate.accessModes[0] | string | `"ReadWriteOnce"` |  |
| elasticsearch.volumeClaimTemplate.resources.requests.storage | string | `"200G"` |  |
| filebeat.daemonset.extraVolumeMounts[0].mountPath | string | `"/var/lib/containerd/container_logs"` |  |
| filebeat.daemonset.extraVolumeMounts[0].name | string | `"varlibcontainerdcontainerlogs"` |  |
| filebeat.daemonset.extraVolumes[0].hostPath.path | string | `"/var/lib/containerd/container_logs"` |  |
| filebeat.daemonset.extraVolumes[0].name | string | `"varlibcontainerdcontainerlogs"` |  |
| filebeat.daemonset.secretMounts | list | `[]` |  |
| filebeat.enabled | bool | `true` |  |
| filebeat.filebeatConfig."filebeat.yml" | string | `"setup:\n  ilm:\n    enabled: false\nfilebeat.autodiscover:\n  providers:\n    - type: kubernetes\n      hints.enabled: true\n      hints.default_config:\n        type: container\n        paths:\n          - /var/log/containers/*${data.container.id}.log\n      node: ${NODE_NAME}\nprocessors:\n  - add_kubernetes_metadata: ~\n  - decode_json_fields:\n      when:\n         has_fields: [\"message\"]\n      fields: [\"message\"]\n      target: \"\"\n      overwrite_keys: true\n  - decode_json_fields:\n      when:\n         has_fields: [\"msg\"]\n      fields: [\"msg\"]\n      target: \"\"\n      overwrite_keys: true\n  - add_labels:\n      labels:\n        stage: ${STAGE:dev}\n  - drop_event:\n      when:\n        or:\n        - equals:\n            kubernetes.labels.app: \"kibana\"\n        - equals:\n            kubernetes.labels.app: \"grafana\"\n        - equals:\n            kubernetes.labels.app: \"prometheus-stack-operator\"\n        - equals:\n            kubernetes.labels.app: \"elasticsearch-master\"\n        - equals:\n            kubernetes.labels.app: \"botkube\"\n        - equals:\n            kubernetes.labels.app: \"prometheus\"\n        - equals:\n            msg: \"no session found in request, redirecting for authorization\"\n        - equals:\n            kubernetes.container.name: \"kube-state-metrics\"\n        - equals:\n            kubernetes.container.name: \"filebeat\"\n        - equals:\n            kubernetes.container.name: \"traefik-admin-dashboard\"\n        - equals:\n            kubernetes.container.name: portal\n        - equals:\n            kubernetes.container.name: repo-server\n        - equals:\n            kubernetes.container.name: argocd-notifications-controller\n        - equals:\n            kubernetes.container.name: application-controller\n        - equals:\n            kubernetes.namespace: kube-system\n        - equals:\n            kubernetes.labels.component: registry\n        - equals:\n            RequestPath: \"/ping\"\n        - equals:\n            RouterName: \"kibana@file\"\n        - equals:\n            message: \"200 OK: GET - /public/api/health\"\n        - contains:\n            message: \"vault-sealed-check\\\" does not have associated TTL\"\n        - contains:\n            message: \"Error while renaming Node ID\"\n        - contains:\n            message: \"pkg/mod/k8s.io/client-go@v0.17.0/tools/cache/reflector.go:108\"\n        # NGINX Ingress\n        - contains:\n            message: \"TCP 200 0 0\"\n        # Vault logs\n        - equals:\n            auth.metadata.role_name: gitlab\n        - equals:\n            auth.metadata.role_name: banzai-webhook-role\n        - equals:\n            app: vault-secrets-webhook\n        - contains:\n            message: \"agent.server: member joined, marking health alive:\"\noutput.elasticsearch:\n  hosts: '[\"${ELASTICSEARCH_HOSTS:elasticsearch-master:9200}\"]'\n  protocol: http\n  indices:\n      - index: \"traefik-and-keycloak-proxy-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"routing\"\n      - index: \"vault-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          and:\n          - equals:\n             kubernetes.namespace: \"vault\"\n      - index: \"argocd-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"argocd\"\n      - index: \"elastalert-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.container.name: \"elastalert2\"\n      - index: \"kyverno-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"kyverno\"\n      - index: \"auth-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"auth\"      \n      - index: \"not-defined-%{[agent.version]}-%{+yyyy.MM}\"\nsetup.kibana:\n  host: \"elastic-stack-kibana:5601\"\n  protocol: \"http\"\n"` |  |
| filebeat.readinessProbe.failureThreshold | int | `50` |  |
| filebeat.readinessProbe.initialDelaySeconds | int | `20` |  |
| filebeat.readinessProbe.periodSeconds | int | `30` |  |
| filebeat.readinessProbe.timeoutSeconds | int | `10` |  |
| filebeat.resources.limits.cpu | string | `"400m"` |  |
| filebeat.resources.limits.memory | string | `"500M"` |  |
| filebeat.resources.requests.cpu | string | `"100m"` |  |
| filebeat.resources.requests.memory | string | `"100M"` |  |
| ilm.image.repository | string | `"docker.io/curlimages/curl"` |  |
| ilm.image.tag | string | `"7.82.0"` |  |
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
| indexPatternInit.image.tag | string | `"7.82.0"` |  |
| indexPatternInit.indices.argocd.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.auth.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.botkube.timestampField | string | `"Timestamp"` |  |
| indexPatternInit.indices.elastalert.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.kyverno.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.not-defined.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.traefik-and-keycloak-proxy.timestampField | string | `"@timestamp"` |  |
| indexPatternInit.indices.vault.timestampField | string | `"@timestamp"` |  |
| ingress.annotations."cert-manager.io/cluster-issuer" | string | `"letsencrypt"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.entrypoints" | string | `"websecure"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.middlewares" | string | `"{{.Release.Namespace}}-strip-prefix-{{ .Release.Name }}@kubernetescrd, routing-oidc-forward-auth@kubernetescrd"` |  |
| ingress.annotations."traefik.ingress.kubernetes.io/router.tls" | string | `"true"` |  |
| ingress.defaultIngress.backend.name | string | `"{{.Release.Name}}-kibana"` |  |
| ingress.defaultIngress.enabled | bool | `true` |  |
| ingress.defaultIngress.path | string | `"/kibana"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.host | string | `nil` | Required, replace it with your host address |
| ingressRoute.adminDomain | string | `"admin.my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"after-proxy"` |  |
| kibana.enabled | bool | `true` |  |
| kibana.image | string | `"docker.elastic.co/kibana/kibana"` |  |
| kibana.imageTag | string | `"8.5.1"` |  |
| kibana.kibanaConfig."kibana.yml" | string | `"server:\n  name: kibana\n  host: \"localhost\"\n  basePath: \"/kibana\"\nelasticsearch.hosts: [ \"http://elasticsearch:9200\" ]\nmonitoring.ui.container.elasticsearch.enabled: true\nxpack:\n  reporting:\n    csv.maxSizeBytes: 1048576000\n    queue.timeout: 1800000\n    kibanaServer.hostname: localhost\n    encryptionKey: \"2r6QH87Y3tJP9JkNqaM!w9&zQBO6p&M%\"\n  security.encryptionKey: \"2r6QH87Y3tJP9JkNqaM!w9&zQBO6p&M%\"\n  encryptedSavedObjects.encryptionKey: \"2r6QH87Y3tJP9JkNqaM!w9&zQBO6p&M%\"\n"` |  |
| kibana.replicas | int | `2` |  |
| kibana.service.annotations | object | `{}` |  |
| kibana.service.port | int | `5601` |  |
| kibana.service.type | string | `"ClusterIP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

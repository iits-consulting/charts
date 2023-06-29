# elastic-stack

![Version: 7.17.3-otc-volumes](https://img.shields.io/badge/Version-7.17.3--otc--volumes-informational?style=flat-square)

Awesome Logs

## Usage inside infrastructure-charts
```yaml
  elastic-stack:
    namespace: monitoring
    targetRevision: "7.17.3-otc-volumes"
    parameters:
      elasticsearch.replicas: "1"
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://helm.elastic.co | elasticsearch | 7.17.3 |
| https://helm.elastic.co | filebeat | 7.17.3 |
| https://helm.elastic.co | kibana | 7.17.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| elasticsearch.enabled | bool | `true` |  |
| elasticsearch.esConfig."elasticsearch.yml" | string | `"cluster.name: \"docker-cluster\"\nnetwork.host: 0.0.0.0\nhttp.max_header_size: 16kb\ncluster.max_shards_per_node: 30000\n"` |  |
| elasticsearch.esJavaOpts | string | `"-Xmx6g -Xms6g -Dlog4j2.formatMsgNoLookups=true"` |  |
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
| filebeat.enabled | bool | `true` |  |
| filebeat.extraEnvs[0].name | string | `"STAGE"` |  |
| filebeat.extraEnvs[0].value | string | `"REPLACE_ME"` |  |
| filebeat.filebeatConfig."filebeat.yml" | string | `"setup:\n  ilm:\n    enabled: false\nfilebeat.autodiscover:\n  providers:\n    - type: kubernetes\n      hints.enabled: true\n      hints.default_config:\n        type: container\n        paths:\n          - /var/log/containers/*${data.container.id}.log\n      node: ${NODE_NAME}\nprocessors:\n  - add_kubernetes_metadata: ~\n  - decode_json_fields:\n      when:\n         has_fields: [\"message\"]\n      fields: [\"message\"]\n      target: \"\"\n      overwrite_keys: true\n  - decode_json_fields:\n      when:\n         has_fields: [\"msg\"]\n      fields: [\"msg\"]\n      target: \"\"\n      overwrite_keys: true\n  - add_labels:\n      labels:\n        stage: ${STAGE}\n  - drop_event:\n      when:\n        or:\n        - equals:\n            kubernetes.labels.app: \"kibana\"\n        - equals:\n            kubernetes.labels.app: \"grafana\"\n        - equals:\n            kubernetes.labels.app: \"prometheus-stack-operator\"\n        - equals:\n            kubernetes.labels.app: \"elasticsearch-master\"\n        - equals:\n            kubernetes.labels.app: \"botkube\"\n        - equals:\n            kubernetes.labels.app: \"prometheus\"\n        - equals:\n            msg: \"no session found in request, redirecting for authorization\"\n        - equals:\n            kubernetes.container.name: \"kube-state-metrics\"\n        - equals:\n            kubernetes.container.name: \"filebeat\"\n        - equals:\n            kubernetes.container.name: \"traefik-admin-dashboard\"\n        - equals:\n            kubernetes.container.name: portal\n        - equals:\n            kubernetes.container.name: repo-server\n        - equals:\n            kubernetes.container.name: argocd-notifications-controller\n        - equals:\n            kubernetes.container.name: application-controller\n        - equals:\n            kubernetes.namespace: kube-system\n        - equals:\n            kubernetes.labels.component: registry\n        - equals:\n            RequestPath: \"/ping\"\n        - equals:\n            RouterName: \"kibana@file\"\n        - equals:\n            message: \"200 OK: GET - /public/api/health\"\n        - contains:\n            message: \"vault-sealed-check\\\" does not have associated TTL\"\n        - contains:\n            message: \"Error while renaming Node ID\"\n        - contains:\n            message: \"pkg/mod/k8s.io/client-go@v0.17.0/tools/cache/reflector.go:108\"\n        # NGINX Ingress\n        - contains:\n            message: \"TCP 200 0 0\"\n        # Vault logs\n        - equals:\n            auth.metadata.role_name: gitlab\n        - equals:\n            auth.metadata.role_name: banzai-webhook-role\n        - equals:\n            app: vault-secrets-webhook\n        - contains:\n            message: \"agent.server: member joined, marking health alive:\"\noutput.elasticsearch:\n  hosts: '${ELASTICSEARCH_HOSTS:elasticsearch-master:9200}'\n  indices:\n      - index: \"traefik-and-keycloak-proxy-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"routing\"\n      - index: \"vault-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          and:\n          - equals:\n             kubernetes.namespace: \"vault\"\n      - index: \"argocd-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"argocd\"\n      - index: \"elastalert-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.container.name: \"elastalert2\"\n      - index: \"kyverno-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"kyverno\"\n      - index: \"auth-%{[agent.version]}-%{+yyyy.MM.DD}\"\n        when:\n          or:\n           - equals:\n              kubernetes.namespace: \"auth\"      \n      - index: \"not-defined-%{[agent.version]}-%{+yyyy.MM}\"\nsetup.kibana:\n  host: \"elastic-stack-kibana:5601\"\n  protocol: \"http\"\n"` |  |
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
| ingressRoute.adminDomain | string | `"admin.my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"after-proxy"` |  |
| kibana.enabled | bool | `true` |  |
| kibana.kibanaConfig."kibana.yml" | string | `"server.name: kibana\nserver.host: \"0\"\nserver.basePath: \"/kibana\"\nelasticsearch.hosts: [ \"http://elasticsearch:9200\" ]\nxpack.monitoring.ui.container.elasticsearch.enabled: true\nxpack.monitoring.enabled: true\nxpack.reporting.csv.maxSizeBytes: 1048576000\nxpack.reporting.queue.timeout: 1800000\nxpack.reporting.encryptionKey: \"2r6QH87Y3tJP9JkNqaM!w9&zQBO6p&M%\"\n"` |  |
| kibana.replicas | int | `2` |  |
| kibana.service.annotations | object | `{}` |  |
| kibana.service.port | int | `5601` |  |
| kibana.service.type | string | `"ClusterIP"` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

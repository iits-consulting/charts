# elastic-stack

![Version: 7.17.3-route-bugfix](https://img.shields.io/badge/Version-7.17.3--route--bugfix-informational?style=flat-square)

Deploy a complete ELK stack or parts of it

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
| elasticsearch.replicas | int | `1` |  |
| elasticsearch.updateStrategy | string | `"RollingUpdate"` |  |
| elasticsearch.volumeClaimTemplate.accessModes[0] | string | `"ReadWriteOnce"` |  |
| elasticsearch.volumeClaimTemplate.resources.requests.storage | string | `"100G"` |  |
| filebeat.enabled | bool | `true` |  |
| filebeat.filebeatConfig."filebeat.yml" | string | `"setup:\n  ilm:\n    enabled: false\nfilebeat.autodiscover:\n  providers:\n    - type: kubernetes\n      hints.enabled: true\n      node: ${NODE_NAME}\n      templates:\n        - condition.or:\n          - contains.kubernetes.namespace: kafka\n          - contains.kubernetes.namespace: vault\n          config:\n            - type: container\n              paths:\n                - /var/log/containers/*${data.kubernetes.container.id}.log\n              multiline.pattern: '\\n'\n              multiline.negate: false\n              multiline.match: after\nprocessors:\n  - decode_json_fields:\n      when:\n         has_fields: [\"message\"]\n      fields: [\"message\"]\n      target: \"\"\n      overwrite_keys: true\n  - drop_event.when.or:\n     - equals.kubernetes.labels.app: \"zookeeper\"\n     - equals.kubernetes.labels.app: \"kibana\"\n     - equals.kubernetes.labels.app: \"grafana\"\n     - equals.kubernetes.labels.app: \"prometheus-stack-operator\"\n     - equals.kubernetes.labels.app: \"elasticsearch-master\"\n     - equals.kubernetes.labels.app: \"botkube\"\n     - equals.kubernetes.labels.app: \"prometheus\"\n     - equals.msg: \"no session found in request, redirecting for authorization\"\n     - equals.kubernetes.container.name: \"kube-state-metrics\"\n     - equals.kubernetes.container.name: \"filebeat\"\n     - equals.kubernetes.container.name: \"traefik-admin-dashboard\"\n     - equals.kubernetes.container.name: repo-server\n     - equals.kubernetes.container.name: argocd-notifications-controller\n     - equals.kubernetes.container.name: application-controller\n     - equals.kubernetes.namespace: kruise-system\n     - equals.kubernetes.namespace: kube-system\n     - equals.kubernetes.labels.component: registry\n     - equals.RequestPath: \"/ping\"\n     - equals.RouterName: \"kibana@file\"\n     - equals.message: \"200 OK: GET - /public/api/health\"\n     - contains.message: \"vault-sealed-check\\\" does not have associated TTL\"\n     - contains.message: \"Error while renaming Node ID\"\n     - contains.message: \"pkg/mod/k8s.io/client-go@v0.17.0/tools/cache/reflector.go:108\"\n     # Harbor\n     - contains.container.image.name: \"goharbor/nginx-photon\"      \n     # Vault logs\n     - equals.auth.metadata.role_name: gitlab\n     - equals.auth.metadata.role_name: banzai-webhook-role\n     - equals.app: vault-secrets-webhook\n     - contains.message: \"agent.server: member joined, marking health alive:\"\noutput.elasticsearch:\n  hosts: '${ELASTICSEARCH_HOSTS:elasticsearch-master:9200}'\n  indices:\n      - index: \"traefik-and-keycloak-proxy_%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          or:\n           - equals:\n              kubernetes.labels.app: \"keycloak-proxy\"\n           - equals:\n              kubernetes.labels.app: \"keycloak-proxy-admin\"\n           - equals:\n              kubernetes.container.name: \"traefik\"\n      - index: \"kafka-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          and:\n           - equals:\n              kubernetes.namespace: \"kafka\"\n      - index: \"vault-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          and:\n          - equals:\n             kubernetes.namespace: \"vault\"\n      - index: \"geoserver-%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          and:\n          - equals:\n             kubernetes.namespace: \"geoserver\"\n      - index: \"argocd_%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          or:\n           - equals:\n              app.kubernetes.io/instance: \"argocd\"\n      - index: \"elastalert_%{[agent.version]}-%{+yyyy.MM}\"\n        when:\n          or:\n           - equals:\n              kubernetes.container.name: \"elastalert\"      \n      - index: \"not-defined-%{[agent.version]}-%{+yyyy.MM}\"\nsetup.kibana:\n  host: \"elastic-stack-kibana:5601\"\n  protocol: \"http\"\n"` |  |
| filebeat.readinessProbe.failureThreshold | int | `50` |  |
| filebeat.readinessProbe.initialDelaySeconds | int | `20` |  |
| filebeat.readinessProbe.periodSeconds | int | `30` |  |
| filebeat.readinessProbe.timeoutSeconds | int | `10` |  |
| ilm.image.repository | string | `"curlimages/curl"` |  |
| ilm.image.tag | string | `"7.82.0"` |  |
| ilm.policies.long.coldAfter | string | `"32d"` |  |
| ilm.policies.long.deleteAfter | string | `"365d"` |  |
| ilm.policies.long.indexPatterns[0] | string | `"vault*"` |  |
| ilm.policies.long.indexPatterns[1] | string | `"traefik-and-keycloak-proxy*"` |  |
| ilm.policies.medium.coldAfter | string | `"32d"` |  |
| ilm.policies.medium.deleteAfter | string | `"90d"` |  |
| ilm.policies.medium.indexPatterns[0] | string | `"kafka*"` |  |
| ilm.policies.medium.indexPatterns[1] | string | `"not-defined*"` |  |
| ilm.policies.short.coldAfter | string | `"2d"` |  |
| ilm.policies.short.deleteAfter | string | `"14d"` |  |
| ilm.policies.short.indexPatterns[0] | string | `"argocd*"` |  |
| ingressRoute.adminDomain | string | `"admin.my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"after-proxy"` |  |
| kibana.enabled | bool | `true` |  |
| kibana.kibanaConfig."kibana.yml" | string | `"server.name: kibana\nserver.host: \"0\"\nserver.basePath: \"/kibana\"\nelasticsearch.hosts: [ \"http://elasticsearch:9200\" ]\nxpack.monitoring.ui.container.elasticsearch.enabled: true\nxpack.monitoring.enabled: true\n"` |  |
| kibana.replicas | int | `1` |  |
| kibana.service.annotations | object | `{}` |  |
| kibana.service.port | int | `5601` |  |
| kibana.service.type | string | `"ClusterIP"` |  |

<img src="https://iits-consulting.de/wp-content/uploads/2021/08/iits-logo-2021-red-square-xl.png"
alt="iits consulting" id="logo" width="200" height="200">
<br>
*This chart is provided by [iits-consulting](https://iits-consulting.de/) - your Cloud-Native Innovation Teams as a Service!*

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

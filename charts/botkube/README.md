# botkube

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square)

botkube designed to work with elasticsearch

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://infracloudio.github.io/charts | botkube | v0.12.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| botkube.communications | object | `{"elasticsearch":{"enabled":true,"index":{"name":"botkube","replicas":0,"shards":1,"type":"botkube-event"},"server":"http://elasticsearch-master:9200"}}` | Communication settings |
| botkube.config.resources[0].events[0] | string | `"error"` |  |
| botkube.config.resources[0].name | string | `"v1/pods"` |  |
| botkube.config.resources[0].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[0].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[10].events[0] | string | `"error"` |  |
| botkube.config.resources[10].name | string | `"batch/v1/jobs"` |  |
| botkube.config.resources[10].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[10].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[10].updateSetting.fields[0] | string | `"spec.template.spec.containers[*].image"` |  |
| botkube.config.resources[10].updateSetting.fields[1] | string | `"status.conditions[*].type"` |  |
| botkube.config.resources[10].updateSetting.includeDiff | bool | `true` |  |
| botkube.config.resources[11].events[0] | string | `"error"` |  |
| botkube.config.resources[11].name | string | `"rbac.authorization.k8s.io/v1/roles"` |  |
| botkube.config.resources[11].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[11].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[12].events[0] | string | `"error"` |  |
| botkube.config.resources[12].name | string | `"rbac.authorization.k8s.io/v1/rolebindings"` |  |
| botkube.config.resources[12].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[12].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[13].events[0] | string | `"error"` |  |
| botkube.config.resources[13].name | string | `"rbac.authorization.k8s.io/v1/clusterroles"` |  |
| botkube.config.resources[13].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[13].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[14].events[0] | string | `"error"` |  |
| botkube.config.resources[14].name | string | `"rbac.authorization.k8s.io/v1/clusterrolebindings"` |  |
| botkube.config.resources[14].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[14].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[1].events[0] | string | `"error"` |  |
| botkube.config.resources[1].name | string | `"v1/services"` |  |
| botkube.config.resources[1].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[1].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[2].events[0] | string | `"error"` |  |
| botkube.config.resources[2].name | string | `"apps/v1/deployments"` |  |
| botkube.config.resources[2].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[2].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[2].updateSetting.fields[0] | string | `"spec.template.spec.containers[*].image"` |  |
| botkube.config.resources[2].updateSetting.fields[1] | string | `"status.availableReplicas"` |  |
| botkube.config.resources[2].updateSetting.includeDiff | bool | `true` |  |
| botkube.config.resources[3].events[0] | string | `"error"` |  |
| botkube.config.resources[3].name | string | `"apps/v1/statefulsets"` |  |
| botkube.config.resources[3].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[3].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[3].updateSetting.fields[0] | string | `"spec.template.spec.containers[*].image"` |  |
| botkube.config.resources[3].updateSetting.fields[1] | string | `"status.readyReplicas"` |  |
| botkube.config.resources[3].updateSetting.includeDiff | bool | `true` |  |
| botkube.config.resources[4].events[0] | string | `"error"` |  |
| botkube.config.resources[4].name | string | `"v1/nodes"` |  |
| botkube.config.resources[4].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[4].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[5].events[0] | string | `"error"` |  |
| botkube.config.resources[5].name | string | `"v1/namespaces"` |  |
| botkube.config.resources[5].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[5].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[6].events[0] | string | `"error"` |  |
| botkube.config.resources[6].name | string | `"v1/persistentvolumes"` |  |
| botkube.config.resources[6].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[6].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[7].events[0] | string | `"error"` |  |
| botkube.config.resources[7].name | string | `"v1/persistentvolumeclaims"` |  |
| botkube.config.resources[7].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[7].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[8].events[0] | string | `"error"` |  |
| botkube.config.resources[8].name | string | `"v1/configmaps"` |  |
| botkube.config.resources[8].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[8].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[9].events[0] | string | `"error"` |  |
| botkube.config.resources[9].name | string | `"apps/v1/daemonsets"` |  |
| botkube.config.resources[9].namespaces.ignore[0] | string | `nil` |  |
| botkube.config.resources[9].namespaces.include[0] | string | `"all"` |  |
| botkube.config.resources[9].updateSetting.fields[0] | string | `"spec.template.spec.containers[*].image"` |  |
| botkube.config.resources[9].updateSetting.fields[1] | string | `"status.numberReady"` |  |
| botkube.config.resources[9].updateSetting.includeDiff | bool | `true` |  |
| botkube.config.settings | object | `{"allowkubectl":false,"clustername":null,"configwatcher":false,"restrictAccess":false,"upgradeNotifier":true}` | Setting to support multiple clusters |
| botkube.image.repository | string | `"docker.io/infracloudio/botkube"` |  |
| botkube.image.tag | string | `"v0.12.1"` |  |
| botkube.resources.requests.cpu | string | `"3m"` |  |
| botkube.resources.requests.memory | string | `"60Mi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.0](https://github.com/norwoodj/helm-docs/releases/v1.13.0)

#helm dependency update crd-helper-chart
helm template crd-helper-chart/charts/cert-manager-*.tgz --include-crds | yq 'select(.kind = "CustomResourceDefinition")' > crds/cert-manager.yaml
helm template crd-helper-chart/charts/kube-prometheus-stack-*.tgz --include-crds | yq 'select(.kind = "CustomResourceDefinition")' > crds/prometheus-stack.yaml
helm template crd-helper-chart/charts/traefik-*.tgz --include-crds | yq 'select(.kind = "CustomResourceDefinition")' > crds/traefik.yaml
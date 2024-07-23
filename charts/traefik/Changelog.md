
## 28.2.x -> 29.0.1

⚠️ **Important Information** ⚠️

Per Traefik release notes:
 - [v29.0.0](https://github.com/traefik/traefik-helm-chart/releases/tag/v29.0.0)
 - [v29.0.1](https://github.com/traefik/traefik-helm-chart/releases/tag/v29.0.1)

If you use the Gateway API with traefik you should update your CRD's. 

If you use our [crd-installer](https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/crd_installer) 
you can either manually update the chart version to `29.0.1` or use a newer version of the crd-installer itself.

If you are not using the Gateway API, no additional changes are necessary.

***
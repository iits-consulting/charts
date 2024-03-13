# IITS Deployment via terraform

for OTC:


```terraform
resource "helm_release" "traefik" {
  depends_on            = [helm_release.iits_kyverno_policies, helm_release.custom_resource_definitions]
  name                  = "traefik"
  chart                 = "traefik"
  repository            = "https://charts.iits.tech"
  version               = local.chart_versions.traefik
  namespace             = "routing"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  values = [
    yamlencode({
      ingress = {
        enabled = true
        annotations = {
          #pattern: <namespace>-<chart-name>@kubernetescrd
          "traefik.ingress.kubernetes.io/router.middlewares" = "routing-oidc-forward-auth@kubernetescrd"
        }
        defaultHost = "admin.${var.domain_name}"
        additionalHosts = [var.domain_name]
      }
      traefik = {
        additionalArguments = [
          "--ping",
          "--entryPoints.web.forwardedHeaders.trustedIPs=100.125.0.0/16",
          "--entryPoints.websecure.forwardedHeaders.trustedIPs=100.125.0.0/16",
        ]
        service = {
          annotations = {
            "kubernetes.io/elb.id" = <Insert ID>
          }
          spec = {
            externalTrafficPolicy = "Local"
          }
        }
      }
    })
  ]
}
```



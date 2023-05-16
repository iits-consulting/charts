# kyverno

This chart wraps kyverno and some additional components such as the policy reporter as well as
IngressRoutes/Middlewares to allow usage of the Kyverno UI. 

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| route.enabled | bool | `false` | Whether or not to enable the ingress route |
| route.entrypoint | string | `"internalhttps"` | The entrypoint to choose, should be something guarded by authentication like keycloak-gatekeeper or oauth2-proxy |
| route.hostPrefixRegex | string | `"HostRegexp(`{host:admin.+}`)"` | The subdomain used for the IngressRoute |

## Usage

As kyverno enforces policies in the Kubernetes cluster it makes sense to deploy it at the very
beginning when setting up new infrastructure. We usually deploy essential cluster resources up to
ArgoCD via Terraform. An example of how to deploy a complete Kyverno setup would be:

```
resource "helm_release" "kyverno" {
  name                  = "kyverno"
  repository            = "https://charts.iits.tech"
  version               = "1.0.0"
  chart                 = "kyverno"
  namespace             = "kyverno"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  skip_crds             = false
  # The entrypoint to your cluster highly depends on your local setup
  values                = [
    yamlencode({
      route = {
        enabled = true
      }
    })
  ]
}

resource "helm_release" "iits_kyverno_policies" {
  wait_for_jobs         = true
  depends_on            = [helm_release.kyverno]
  name                  = "iits-kyverno-policies"
  repository            = "https://charts.iits.tech"
  version               = "1.2.0"
  chart                 = "iits-kyverno-policies"
  namespace             = "kyverno"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
}
```



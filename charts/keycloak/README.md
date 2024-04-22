# keycloak

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square)

Wrapper Chart for Keycloak

## Installing the Chart on OTC

Steps to set it up:

  * [1. Create a postgres database](#1-create-a-postgres-database)
  * [2. Create a private dns entry](#2-create-a-private-dns-entry)
  * [3. Initialize the database](#3-initialize-the-database)
  * [4. Deploy the keycloak helm chart](#4-deploy-the-keycloak-helm-chart)

## 1. Create a postgres database

First you need to create the RDS (postgres) database like this:

```terraform
module "postgres" {
  source  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/rds"
  version = "5.2.1"
  tags    = local.tags
  name    = "${var.context}-${var.stage}-database"

  vpc_id                = module.vpc.vpc.id
  subnet_id             = module.vpc.subnets["database-subnet"].id
  db_type               = var.db_config.db_type
  db_availability_zones = var.availability_zones
  db_version            = var.db_config.db_version
  db_cpus               = var.db_config.db_cpus
  db_memory             = var.db_config.db_memory
  db_high_availability  = var.db_config.db_high_availability
  db_parameters = {
    timezone        = "Europe/Berlin"
    max_connections = 1000
  }
  sg_allowed_cidr = [local.vpc_cidr]
}

```

## 2. Create a private dns entry

The next step is to create a private dns entry since we don't want to use the IP Address.

```terraform
module "private_dns" {
source  = "registry.terraform.io/iits-consulting/project-factory/opentelekomcloud//modules/private_dns"
version = "5.2.1"
domain  = "vpc.private"
a_records = {
postgres   = [module.postgres.db_private_ip]
}
vpc_id = module.vpc.vpc.id
}
```

## 3. Initialize the database

After that go to terraform kubernetes and initialize the database like this:

```terraform

resource "random_password" "keycloak" {
  length      = 32
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "helm_release" "db_init" {
  depends_on = [
    helm_release.iits_kyverno_policies
  ]
  name                  = "db-init"
  repository            = "https://charts.iits.tech"
  chart                 = "db-init"
  version               = local.chart_versions.db_init
  namespace             = "db-init"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  wait_for_jobs         = true
  set_sensitive {
    name  = "dbInit.postgres.env.PGPASSWORD"
    value = module.terraform_secrets_from_encrypted_s3_bucket.secrets["db_root_password"]
  }
  set_sensitive {
    name  = "dbInit.postgres.databases.keycloak.password"
    value = random_password.keycloak.result
  }
  values                = [
    yamlencode({
      dbInit ={
        postgres = {
          databases = {
            keycloak = {
              username = "keycloak"
            }
          }
        }
      }
    }
    )
  ]
}
```

## 4. Deploy the keycloak helm chart

```yaml
charts:
  keycloak:
    targetRevision: "0.1.2"
    repoURL: "https://charts.iits.tech"
    namespace: auth
    parameters:
      ingressRoute.domain: "auth.{{.Values.projectValues.rootDomain}}"
      keycloak.image.registry: registry.gitlab.com
      keycloak.image.repository: mygroup/keycloak-custom
      keycloak.image.tag: 19.0.3-debian-11-r15-bugfix-css
      keycloak.auth.adminUser: "${vault:mySecretStorage/data/keycloak/admin_credentials#username}"
      keycloak.auth.adminPassword: "${vault:mySecretStorage/data/keycloak/admin_credentials#password}"
      keycloak.externalDatabase.host: "postgres.vpc.private"
      keycloak.externalDatabase.port: "${vault:mySecretStorage/data/infra/postgres#postgres_port}"
      keycloak.externalDatabase.database: "${vault:mySecretStorage/data/infra/postgres#postgres_keycloak_username}"
      keycloak.externalDatabase.user: "${vault:mySecretStorage/data/infra/postgres#postgres_keycloak_username}"
      keycloak.externalDatabase.password: "${vault:mySecretStorage/data/infra/postgres#postgres_keycloak_password}"

```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | keycloak | 12.1.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoute.certificate.clusterIssuer | string | `"letsencrypt"` |  |
| ingressRoute.certificate.name | string | `nil` |  |
| ingressRoute.domain | string | `"my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"websecure"` |  |
| keycloak.auth.adminPassword | string | `"REPLACE_ME"` | Required |
| keycloak.auth.adminUser | string | `"REPLACE_ME"` | Required |
| keycloak.externalDatabase.database | string | `"REPLACE_ME"` | Required |
| keycloak.externalDatabase.host | string | `"REPLACE_ME"` | Required, replace it with your host address |
| keycloak.externalDatabase.port | string | `"REPLACE_ME"` | Required |
| keycloak.externalDatabase.user | string | `"REPLACE_ME"` | Required |
| keycloak.image.pullPolicy | string | `"Always"` |  |
| keycloak.logging.output | string | `"json"` |  |
| keycloak.postgresql.enabled | bool | `false` |  |
| keycloak.proxyAddressForwarding | bool | `true` |  |
| keycloak.replicaCount | int | `2` |  |
| keycloak.service.type | string | `"ClusterIP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

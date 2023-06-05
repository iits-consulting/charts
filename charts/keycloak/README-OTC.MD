# This Readme.md just counts for OTC

## Database

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

After that go to terraform kubernetes and initialize the database like this:

```terraform

locals {
  # List all databases you want to create
  databases = toset([
    "keycloak",
  ])
}

module "db-init" {
  source          = "registry.terraform.io/iits-consulting/db-init/kubernetes"
  database_engine = "postgres"
  database_root_credentials = {
    username = module.terraform_secrets_from_encrypted_s3_bucket.secrets["postgres_root_username"]
    password = module.terraform_secrets_from_encrypted_s3_bucket.secrets["postgres_root_password"]
    address  = module.terraform_secrets_from_encrypted_s3_bucket.secrets["postgres_addr"]
  }
  initdb_script = templatefile("./initdb.sql", { #Path to the SQL Script
    databases = [for database in local.databases : {# This populates variables set inside the initdb.sql script
      name     = database
      username = database
      password = random_password.database_passwords[database].result
    }]
  })
  pod_config = {
    namespace = "database"
    namespace_create = true
    name             = "db-init"
    image            = "alpine:3.15.5"
    annotations      = {}
    labels = {
      "app.kubernetes.io/instance" = "alpine"
      "app.kubernetes.io/name"     = "db-init"
    }
  }
}

```

## Deployment example

```yaml
charts:
  keycloak:
    disableAutoSync: true
    targetRevision: "0.1.1"
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
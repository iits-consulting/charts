# otc-nextcloud

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![AppVersion: 25.0.2](https://img.shields.io/badge/AppVersion-25.0.2-informational?style=flat-square)

nextcloud with S3 storage

## Installing the Chart on OTC

### Database

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

# You need also a restricted obs like this: https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/obs_restricted

```

After that go to terraform kubernetes and initialize the database like this:

```terraform

locals {
  # List all databases you want to create
  databases = toset([
    "nextcloud",
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
}https://github.com/iits-consulting/terraform-opentelekomcloud-project-factory/tree/master/modules/obs_restricted

```

### Deployment example

```yaml
charts:
  otc-nextcloud:
    targetRevision: "0.1.0"
    repoURL: "https://charts.iits.tech"
    namespace: nextcloud
    parameters:
      ingressRoute.domain: "nextcloud.{{.Values.projectValues.rootDomain}}"

      nextcloud.externalDatabase.password: "REPLACE_ME"
      nextcloud.externalDatabase.host: "REPLACE_ME"
      nextcloud.externalDatabase.user: "REPLACE_ME"
      nextcloud.externalDatabase.port: "REPLACE_ME"

      nextcloudStorage.s3.S3_BUCKET_NAME: "REPLACE_ME"
      nextcloudStorage.s3.S3_PUBLIC_KEY: "REPLACE_ME"
      nextcloudStorage.s3.S3_SECRET_KEY: "REPLACE_ME"
      nextcloudStorage.s3.S3_BUCKET_URL: "REPLACE_ME"

```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://nextcloud.github.io/helm/ | nextcloud | 3.4.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoute.certificate.clusterIssuer | string | `"letsencrypt"` |  |
| ingressRoute.certificate.name | string | `"nextcloud-cert"` |  |
| ingressRoute.domain | string | `"my-domain.com"` |  |
| ingressRoute.entryPointName | string | `"websecure"` |  |
| nextcloud.externalDatabase.enabled | bool | `true` |  |
| nextcloud.externalDatabase.host | string | `"REPLACE_ME"` | Required, replace it with your host address |
| nextcloud.externalDatabase.password | string | `"REPLACE_ME"` | Required |
| nextcloud.externalDatabase.port | string | `"REPLACE_ME"` | Required |
| nextcloud.externalDatabase.type | string | `"postgresql"` |  |
| nextcloud.externalDatabase.user | string | `"REPLACE_ME"` | Required |
| nextcloud.internalDatabase.enabled | bool | `false` |  |
| nextcloud.nextcloud.configs."s3.config.php" | string | `"<?php\n$CONFIG = array (\n  'objectstore' => array(\n    'class' => '\\\\OC\\\\Files\\\\ObjectStore\\\\S3',\n    'arguments' => array(\n      'bucket'         => getenv('S3_BUCKET_NAME'),\n      'autocreate'     => true,\n      'key'            => getenv('S3_PUBLIC_KEY'),\n      'secret'         => getenv('S3_SECRET_KEY'),\n      'hostname'       => getenv('S3_BUCKET_URL'),\n      'use_ssl'        => true,\n      'use_path_style' => true,\n    )\n  )\n);"` |  |
| nextcloud.nextcloud.extraEnv[0].name | string | `"S3_BUCKET_NAME"` |  |
| nextcloud.nextcloud.extraEnv[0].valueFrom.secretKeyRef.key | string | `"S3_BUCKET_NAME"` |  |
| nextcloud.nextcloud.extraEnv[0].valueFrom.secretKeyRef.name | string | `"nextcloud-storage-secrets"` |  |
| nextcloud.nextcloud.extraEnv[1].name | string | `"S3_PUBLIC_KEY"` |  |
| nextcloud.nextcloud.extraEnv[1].valueFrom.secretKeyRef.key | string | `"S3_PUBLIC_KEY"` |  |
| nextcloud.nextcloud.extraEnv[1].valueFrom.secretKeyRef.name | string | `"nextcloud-storage-secrets"` |  |
| nextcloud.nextcloud.extraEnv[2].name | string | `"S3_SECRET_KEY"` |  |
| nextcloud.nextcloud.extraEnv[2].valueFrom.secretKeyRef.key | string | `"S3_SECRET_KEY"` |  |
| nextcloud.nextcloud.extraEnv[2].valueFrom.secretKeyRef.name | string | `"nextcloud-storage-secrets"` |  |
| nextcloud.nextcloud.extraEnv[3].name | string | `"S3_BUCKET_URL"` |  |
| nextcloud.nextcloud.extraEnv[3].valueFrom.secretKeyRef.key | string | `"S3_BUCKET_URL"` |  |
| nextcloud.nextcloud.extraEnv[3].valueFrom.secretKeyRef.name | string | `"nextcloud-storage-secrets"` |  |
| nextcloud.nextcloud.host | string | `"REPLACE_ME"` | Required, replace it with your host address |
| nextcloud.phpClientHttpsFix.enabled | bool | `true` |  |
| nextcloudStorage.s3.S3_BUCKET_NAME | string | `"REPLACE_ME"` | Required |
| nextcloudStorage.s3.S3_BUCKET_URL | string | `"REPLACE_ME"` | Required |
| nextcloudStorage.s3.S3_PUBLIC_KEY | string | `"REPLACE_ME"` | Required |
| nextcloudStorage.s3.S3_SECRET_KEY | string | `"REPLACE_ME"` | Required |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)

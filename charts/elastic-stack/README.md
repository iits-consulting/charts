# iits elastic stack setup

## Description

This helm chart install the elastic stack (filebeat/kibana/elasticsearch) with
no security since we put a OIDC2 proxy upfront everytime.

## Default indices

- traefik-and-keycloak-proxy
- vault 
- argocd
- elastalert 
- policies 
- not-defined (collects all logs which do not go into any index)

## Usage

1. **Index Configuration**: Configure your indices like you wish under _filebeat.filebeatConfig.filebeat.yml_
   in most cases you just need to adjust _output.elasticsearch.indices_
2. **Elasticsearch volumes**: Adjust _elasticsearch.volumes_ regarding to your cloud.
   Use encrypted volumes
3. **Kibana Index Pattern Autocreate**: For the indices you configured in step 1 please adjust the auto creation
    under _kibana.lifecycle.postStart_
4. **Configure ILM policies**: You don't want to come to storage pressure. Please configure your
   indices from step 1 here when it should go over to cold storage and deletion
# Usage

```yaml
  otc-elastic-stack-backup:
    namespace: monitoring
    repoURL: "https://charts.iits.tech/"
    targetRevision: "0.1.0"
    parameters:
      - name: elasticsearch.backup.volume.volumeID
        value: vault:secret/data/{{.Values.projectValues.stage}}/elasticsearch_backup_volumes_terraform#volume_id
      - name: elasticsearch.backup.volume.deviceMountPath
        value: vault:secret/data/{{.Values.projectValues.stage}}/elasticsearch_backup_volumes_terraform#volume_share_path
```
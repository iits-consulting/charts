{{- define "elasticOperator.elasticSearch.users.checksum" -}}
{{- if .Values.common.externalSecret.enabled }}
{{- .Values.auth.users | toYaml | sha256sum | substr 0 50 }}
{{- else }}
{{- include (print $.Template.BasePath "/eks-stack/elasticsearch-users.yaml") $ | sha256sum | substr 0 50 }}
{{- end }}
{{- end -}}

{{/* Elasticsearch data volumeClaimTemplate for OTC/CCE everest-provisioned storage */}}
{{- define "template.otcPVC" -}}
metadata:
  name: elasticsearch-data # See: https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-volume-claim-templates.html#k8s_specifying_the_volume_claim_settings
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ $.Values.elasticsearch.volumeSize }}
  storageClassName: "" # this has to be empty, otherwise everest will dynamically provision a PV for this claim
{{- end -}}

{{- define "template.regularPVC" -}}
metadata:
  name: elasticsearch-data # See: https://www.elastic.co/guide/en/cloud-on-k8s/master/k8s-volume-claim-templates.html#k8s_specifying_the_volume_claim_settings
spec:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: {{ $.Values.elasticsearch.volumeSize }}
{{- end -}}

{{/*
JVM flags relaxing the AWS SDK checksum defaults. S3-compatible storage such as T Cloud Public OBS
rejects the default checksums, which breaks snapshots. Empty unless backups go to an S3 repository.
*/}}
{{- define "elasticOperator.elasticSearch.s3ChecksumJavaOpts" -}}
{{- if and .Values.backup.enabled (eq .Values.backup.repoType "s3") .Values.backup.s3ChecksumCompatibility -}}
-Daws.requestChecksumCalculation=when_required -Daws.responseChecksumValidation=when_required
{{- end -}}
{{- end }}

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

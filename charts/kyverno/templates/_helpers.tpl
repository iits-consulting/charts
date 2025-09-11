{{- define "allPullSecretRefs" -}}
  {{- /* Grab the existing secret references as they are */ -}}
  {{- $existing := .Values.autoInjectDockerPullSecrets.existingSecretRef | default (list) -}}

  {{- /* Iterate over the keys of the `secrets` map */ -}}
  {{- range $key := (keys .Values.autoInjectDockerPullSecrets.secrets | default (list)) -}}
    {{- /* Append the prefixed key to the list */ -}}
    {{- $existing = append $existing (printf "pull-secret-%s" $key) -}}
  {{- end -}}

  {{- /* Comma separate the list output so it can be parsed properly */ -}}
  {{- join "," $existing -}}
{{- end -}}
{{- define "allPullSecretRefs" -}}
  {{- /* Catch if both pull secret entries in values.yaml are empty*/ -}}
  {{- if and (not .Values.autoInjectDockerPullSecrets.existingSecretRef) (not .Values.autoInjectDockerPullSecrets.secrets) }}
    {{- $existing := ""}}
  {{- else }}
    {{- /* Grab the existing secret references as they are */ -}}
    {{- $existing := list }}
      {{- range $existingElement := .Values.autoInjectDockerPullSecrets.existingSecretRef | default dict }}
        {{- $existing = append $existing (printf $existingElement.name)  }}
      {{- end }}
  
    {{- /* Iterate over the keys of the `secrets` map */ -}}
    {{- range $key := (keys .Values.autoInjectDockerPullSecrets.secrets | default (list)) -}}
      {{- /* Append the prefixed key to the list */ -}}
      {{- $existing = append $existing (printf "pull-secret-%s" $key) -}}
    {{- end -}}
  
    {{- /* Comma separate the list output so it can be parsed properly */ -}}
    {{- join "," $existing -}}
  {{- end -}}
{{- end -}}
{{- define "allPullSecretRefs" -}}
  {{- /* Catch if both pull secret entries in values.yaml are empty*/ -}}
  {{- if and (not .Values.autoInjectDockerPullSecrets.existingSecretRef) (not .Values.autoInjectDockerPullSecrets.secrets) }}
    {{- $existing := ""}}
  {{- else }}
    {{- /* Grab the existing secret references as they are */ -}}
    {{- $existing := list }}
      {{- range $existingElement := .Values.autoInjectDockerPullSecrets.existingSecretRef | default dict }}
      # namespace necessary even if that's not technically how the secret exists on cluster because that's how we construct the policy & all other secrets in add-image-pull-secrets
        {{- $existing = append $existing (printf "%s-%s" $existingElement.name $existingElement.namespace)  }} 
      {{- end }}

    {{- /* Iterate over the keys of the `secrets` map */ -}}
    {{- range $key := (keys .Values.autoInjectDockerPullSecrets.secrets | default (list)) -}}
      {{- /* Append the prefixed key to the list */ -}}
      {{- $existing = append $existing (printf "pull-secret-%s" $key) -}}
    {{- end -}}

    {{- /* Checks whether two secrets with the same name exist in the resulting $existing list */ -}}
    {{- $duplicates := dict -}}
    {{- range $secretName := $existing -}}
      {{- /* If the Dict $duplicates already contains a secret with the name $secretName we call Helm fail */ -}}
      {{- if hasKey $duplicates $secretName }}
        {{- fail (printf "Helm Fail! Reason: Image Pull Secret %s already exists and would cause Kyverno ClusterPolicy naming conflict." $secretName) -}}
      {{- /* Otherwise insert the secret into the Dict (set returns the modified Dict) */ -}}
      {{- else }}
        {{- $_ := set $duplicates $secretName true -}}
      {{- end -}}
    {{- end -}}

    {{- /* Comma separate the list output so it can be parsed properly */ -}}
    {{- join "," $existing -}}
  {{- end -}}
{{- end -}}


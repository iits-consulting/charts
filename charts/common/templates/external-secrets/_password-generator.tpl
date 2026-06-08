{{/*
Renders an ExternalSecrets Password generator resource.
Referenced by PushSecret/ExternalSecret via generatorRef to inject generated passwords.
Args (dict):
  name   - Password metadata.name
  config - generator config: spec (length, digits, symbols, ...), annotations, labels
*/}}
{{- define "common.externalSecrets.passwordGenerator" -}}
{{- $name := .name -}}
{{- $config := .config -}}
{{- $labels := merge (dict) (default dict $config.labels) (default dict .commonLabels) -}}
{{- $annotations := merge (dict) (default dict $config.annotations) (default dict .commonAnnotations) -}}
apiVersion: generators.external-secrets.io/v1alpha1
kind: Password
metadata:
  name: {{ $name }}
  {{- with $config.namespace }}
  namespace: {{ . }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $config.finalizers }}
  finalizers:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- toYaml $config.spec | nindent 2 }}
{{- end -}}

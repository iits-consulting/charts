{{/*
Renders an ExternalSecrets PushSecret resource.
Pushes data from either an existing k8s Secret or a generator into a SecretStore.
Args (dict):
  name    - PushSecret metadata.name (also default sourceSecretName)
  config  - merged per-secret config: path, keys, generatorRef|sourceSecretName, annotations, labels,
            refreshInterval, deletionPolicy, updatePolicy, secretStores, conversionStrategy
  context - root context ($) used to resolve .Values.externalSecret.secretStore when config.secretStores is empty
*/}}
{{- define "common.externalSecrets.pushSecret" -}}
{{- $name := .name -}}
{{- $config := .config -}}
{{- $context := .context -}}
apiVersion: external-secrets.io/v1alpha1
kind: PushSecret
metadata:
  name: {{ $name }}
  {{- with $config.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $config.labels }}
  labels:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
{{- if $config.generatorRef }}
  selector:
    generatorRef:
      {{- toYaml $config.generatorRef | nindent 6 }}
{{- else }}
  selector:
    secret:
      name: {{ default $name $config.sourceSecretName }}
{{- end }}
  refreshInterval: {{ default "1h0m0s" $config.refreshInterval }}
  deletionPolicy: {{ default "None" $config.deletionPolicy }}
  updatePolicy: {{ default "IfNotExists" $config.updatePolicy }}
  secretStoreRefs:
  {{- if $config.secretStores }}
    {{- range $secretStore := $config.secretStores }}
    - {{ toYaml $secretStore | nindent 6 | trim }}
    {{- end }}
  {{- else }}
    - kind: {{ $context.Values.externalSecret.secretStore.kind }}
      name: {{ $context.Values.externalSecret.secretStore.name }}
  {{- end }}
  data:
      {{- range $config.keys }}
    - conversionStrategy: {{ default "None" $config.conversionStrategy }}
      match:
        secretKey: {{ .name | quote }}
        remoteRef:
          remoteKey: {{ required "Path to push secret is required" $config.path | quote }}
          property: {{ default .name .remoteKey | quote }}
      {{- end }}
{{- end -}}

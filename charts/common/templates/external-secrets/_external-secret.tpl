{{/*
Renders an ExternalSecrets ExternalSecret resource.
Pulls data from a SecretStore into a k8s Secret, optionally via a generator or with a template.
Args (dict):
  name    - ExternalSecret metadata.name (also default target.name)
  config  - merged per-secret config: path, keys, generatorRef, targetName, template, annotations, labels,
            refreshInterval, creationPolicy, deletionPolicy, conversionStrategy, decodingStrategy, metadataPolicy,
            secretStoreRef (optional, overrides the chart-wide secretStore)
  context - root context ($) used to resolve .Values.externalSecret.secretStore when config.secretStoreRef is unset
*/}}
{{- define "common.externalSecrets.externalSecret" -}}
{{- $name := .name -}}
{{- $config := .config -}}
{{- $context := .context -}}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
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
  refreshInterval: {{ default "1h0m0s" $config.refreshInterval }}
  refreshPolicy: {{ default "Periodic" $config.refreshPolicy }}
  secretStoreRef:
    kind: {{ default $context.Values.externalSecret.secretStore.kind ($config.secretStoreRef).kind }}
    name: {{ default $context.Values.externalSecret.secretStore.name ($config.secretStoreRef).name }}
  target:
    name: {{ default $name $config.targetName }}
    creationPolicy: {{ default "Owner" $config.creationPolicy }}
    deletionPolicy: {{ default "Retain" $config.deletionPolicy }}
    {{- if $config.template }}
    template:
      engineVersion: {{ default "v2" $config.template.engineVersion }}
      type: {{ default "Opaque" $config.template.type }}
      {{- with $config.template.metadata }}
      metadata:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if $config.template.data }}
      data:
        {{- range $key, $tpl := $config.template.data }}
        {{ $key }}: {{ $tpl | quote }}
        {{- end }}
      {{- end }}
      {{- if $config.template.templateFrom }}
      templateFrom:
        {{- toYaml $config.template.templateFrom | nindent 8 }}
      {{- end }}
    {{- end }}
{{- if $config.generatorRef }}
  dataFrom:
    - sourceRef:
        generatorRef:
          {{- toYaml $config.generatorRef | nindent 10 }}
{{- else }}
  data:
  {{- range $config.keys }}
    - secretKey: {{ .name | quote }}
      remoteRef:
        key: {{ required "Path to pull secret is required" $config.path | quote }}
        property: {{ default .name .remoteKey | quote }}
        conversionStrategy: {{ default "Default" $config.conversionStrategy }}
        decodingStrategy: {{ default "Auto" $config.decodingStrategy }}
        metadataPolicy: {{ default "None" $config.metadataPolicy }}
        nullBytePolicy: {{ default "Fail" $config.nullBytePolicy }}
  {{- end }}
{{- end }}
{{- end -}}

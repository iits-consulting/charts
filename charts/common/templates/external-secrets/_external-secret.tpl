{{/*
Renders an ExternalSecrets ExternalSecret resource.
Pulls data from a SecretStore into a k8s Secret, optionally via a generator or with a template.
Args (dict):
  name    - ExternalSecret metadata.name (also default target.name)
  config  - per-secret config: path, keys, generatorRef, targetName, template, annotations, labels,
            namespace, finalizers, refreshInterval, creationPolicy, deletionPolicy, conversionStrategy,
            decodingStrategy, metadataPolicy, and secretStoreRef ({kind,name}). The caller supplies the
            effective store: the values loop injects the chart default, a per-secret secretStoreRef overrides it.
  commonLabels/commonAnnotations - optional maps merged into metadata.labels/annotations (per-secret values win)
*/}}
{{- define "common.externalSecrets.externalSecret" -}}
{{- $name := .name -}}
{{- $config := .config -}}
{{- $labels := merge (dict) (default dict $config.labels) (default dict .commonLabels) -}}
{{- $annotations := merge (dict) (default dict $config.annotations) (default dict .commonAnnotations) }}
---
apiVersion: external-secrets.io/v1
kind: ExternalSecret
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
  refreshInterval: {{ default "1m" $config.refreshInterval }}
  {{- with $config.refreshPolicy }}
  refreshPolicy: {{ . }}
  {{- end }}
  {{- $store := required "secretStoreRef is required: set externalSecret.secretStore or a per-secret secretStoreRef" $config.secretStoreRef }}
  secretStoreRef:
    kind: {{ required "secretStoreRef.kind is required" $store.kind }}
    name: {{ required "secretStoreRef.name is required" $store.name }}
  target:
    name: {{ default $name $config.targetName }}
    creationPolicy: {{ default "Owner" $config.creationPolicy }}
    deletionPolicy: {{ default "Delete" $config.deletionPolicy }}
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
        decodingStrategy: {{ default "None" $config.decodingStrategy }}
        metadataPolicy: {{ default "None" $config.metadataPolicy }}
        {{- with $config.nullBytePolicy }}
        nullBytePolicy: {{ . }}
        {{- end }}
  {{- end }}
{{- end }}
{{- end -}}

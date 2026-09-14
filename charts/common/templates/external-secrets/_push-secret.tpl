{{/*
Renders an ExternalSecrets PushSecret resource.
Pushes data from either an existing k8s Secret or a generator into a SecretStore.
Args (dict):
  name    - PushSecret metadata.name (also default sourceSecretName)
  config  - per-secret config: path, keys, generatorRef|sourceSecretName, annotations, labels, namespace,
            finalizers, refreshInterval, deletionPolicy, updatePolicy, conversionStrategy, and secretStores
            (list of {kind,name,...}). The caller supplies the effective stores: the values loop injects
            [chart default] when unset, a per-secret secretStores overrides it.
  commonLabels/commonAnnotations - optional maps merged into metadata.labels/annotations (per-secret values win)
*/}}
{{- define "common.externalSecrets.pushSecret" -}}
{{- $name := .name -}}
{{- $config := .config -}}
{{- $labels := merge (dict) (default dict $config.labels) (default dict .commonLabels) -}}
{{- $annotations := merge (dict) (default dict $config.annotations) (default dict .commonAnnotations) }}
---
apiVersion: external-secrets.io/v1alpha1
kind: PushSecret
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
{{- if $config.generatorRef }}
  selector:
    generatorRef:
      {{- toYaml $config.generatorRef | nindent 6 }}
{{- else }}
  selector:
    secret:
      name: {{ default $name $config.sourceSecretName }}
{{- end }}
  refreshInterval: {{ default "1h" $config.refreshInterval }}
  deletionPolicy: {{ default "Delete" $config.deletionPolicy }}
  updatePolicy: {{ default "IfNotExists" $config.updatePolicy }}
  {{- $stores := required "secretStores is required: set externalSecret.secretStore or a per-secret secretStores" $config.secretStores }}
  secretStoreRefs:
    {{- toYaml $stores | nindent 4 }}
  {{- with $config.keys }}
  data:
    {{- range . }}
    - conversionStrategy: {{ default "None" $config.conversionStrategy }}
      match:
        secretKey: {{ .name | quote }}
        remoteRef:
          remoteKey: {{ required "Path to push secret is required" $config.path | quote }}
          property: {{ default .name .remoteKey | quote }}
    {{- end }}
  {{- end }}
{{- end -}}

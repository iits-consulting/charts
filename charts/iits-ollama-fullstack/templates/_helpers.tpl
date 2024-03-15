{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webui.fullname" -}}
{{- if .Values.webui.fullnameOverride }}
{{- .Values.webui.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Release.Name .Values.webui.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webui.selectorLabels" -}}
app: {{ include "webui.fullname" . }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webui.labels" -}}
helm.sh/chart: {{ include "ollama.chart" . }}
{{ include "webui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "webui.serviceAccountName" -}}
{{- if .Values.webui.serviceAccount.create }}
{{- default (include "webui.fullname" .) .Values.webui.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.webui.serviceAccount.name }}
{{- end }}
{{- end }}
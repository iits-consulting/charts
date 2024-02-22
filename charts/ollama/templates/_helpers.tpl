{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ollama.fullname" -}}
{{- if .Values.ollama.fullnameOverride }}
{{- .Values.ollama.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Release.Name .Values.ollama.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}



{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ollama.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ollama.labels" -}}
helm.sh/chart: {{ include "ollama.chart" . }}
{{ include "ollama.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ollama.selectorLabels" -}}
app: {{ include "ollama.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ollama.serviceAccountName" -}}
{{- if .Values.ollama.serviceAccount.create }}
{{- default (include "ollama.fullname" .) .Values.ollama.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ollama.serviceAccount.name }}
{{- end }}
{{- end }}


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

{{/*
Expand the name of the chart.
*/}}
{{- define "ollama-middleware.name" -}}
{{- default .Chart.Name .Values.middleware.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ollama-middleware.fullname" -}}
{{- if .Values.middleware.fullnameOverride }}
{{- .Values.middleware.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.middleware.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ollama-middleware.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ollama-middleware.labels" -}}
helm.sh/chart: {{ include "ollama-middleware.chart" . }}
{{ include "ollama-middleware.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ollama-middleware.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ollama-middleware.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ollama-middleware.serviceAccountName" -}}
{{- if .Values.middleware.serviceAccount.create }}
{{- default (include "ollama-middleware.fullname" .) .Values.middleware.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.middleware.serviceAccount.name }}
{{- end }}
{{- end }}

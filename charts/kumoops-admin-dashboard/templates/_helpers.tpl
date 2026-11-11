{{/*
Expand the name of the chart.
*/}}
{{- define "kumoops-dashboard.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kumoops-dashboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Release.Name .Values.nameOverride }}
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
{{- define "kumoops-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kumoops-dashboard.labels" -}}
helm.sh/chart: {{ include "kumoops-dashboard.chart" . }}
iits-consulting.chart-creator/version: 1.2.1
{{ include "kumoops-dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kumoops-dashboard.selectorLabels" -}}
app: {{ include "kumoops-dashboard.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kumoops-dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kumoops-dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate tile object and return true if valid
*/}}
{{- define "kumoops-dashboard.validateTile" -}}
{{- $tile := .tile }}
{{- $valid := true }}
{{- if not $tile.href }}
{{- $valid = false }}
{{- end }}
{{- if not $tile.imgSrc }}
{{- $valid = false }}
{{- end }}
{{- if not $tile.imgAlt }}
{{- $valid = false }}
{{- end }}
{{- if not $tile.category }}
{{- $valid = false }}
{{- end }}
{{- $valid }}
{{- end }}

{{/*
Get tile property with fallback
Usage: {{ include "kumoops-dashboard.getTileProp" (dict "tile" .tile "prop" "description" "default" "No description") }}
*/}}
{{- define "kumoops-dashboard.getTileProp" -}}
{{- $tile := .tile }}
{{- $prop := .prop }}
{{- $default := .default }}
{{- if hasKey $tile $prop }}
{{- index $tile $prop }}
{{- else }}
{{- $default }}
{{- end }}
{{- end }}

{{/*
Validate and get dashboard title with fallback
*/}}
{{- define "kumoops-dashboard.getTitle" -}}
{{- if and .Values.defaultDashboard .Values.defaultDashboard.title }}
{{- .Values.defaultDashboard.title }}
{{- else }}
{{- "Admin Dashboard" }}
{{- end }}
{{- end }}

{{/*
Validate and get logo source with fallback
*/}}
{{- define "kumoops-dashboard.getLogoSrc" -}}
{{- if and .Values.defaultDashboard .Values.defaultDashboard.logoSrc }}
{{- .Values.defaultDashboard.logoSrc }}
{{- else }}
{{- "https://via.placeholder.com/240x60?text=Logo" }}
{{- end }}
{{- end }}

{{/*
Validate and get dark mode logo source with fallback to logoSrc
*/}}
{{- define "kumoops-dashboard.getLogoDarkSrc" -}}
{{- if and .Values.defaultDashboard .Values.defaultDashboard.logoDarkSrc }}
{{- .Values.defaultDashboard.logoDarkSrc }}
{{- else }}
{{- include "kumoops-dashboard.getLogoSrc" . }}
{{- end }}
{{- end }}

{{/*
Validate and get logo alt with fallback
*/}}
{{- define "kumoops-dashboard.getLogoAlt" -}}
{{- if and .Values.defaultDashboard .Values.defaultDashboard.logoAlt }}
{{- .Values.defaultDashboard.logoAlt }}
{{- else }}
{{- "Dashboard Logo" }}
{{- end }}
{{- end }}

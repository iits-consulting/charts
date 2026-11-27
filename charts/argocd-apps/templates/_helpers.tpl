{{/*
Main git source of a project Application, rendered at column 0.
Used as the single `source` or as the first entry of `sources` when valuesSource is set.
*/}}
{{- define "argocd-apps.mainSource" -}}
{{- $projectName := .projectName -}}
{{- $project := .project -}}
path: {{ $project.git.path | default $projectName }}
repoURL: {{ $project.git.repoUrl }}
targetRevision: {{ $project.git.branch | default "refs/heads/main" }}
helm:
  {{- if $project.ignoreMissingValueFiles }}
  ignoreMissingValueFiles: true
  {{- end }}
  values: |
    {{- $project.tofuValues | toYaml | nindent 6 }}
  valueFiles:
    - values.yaml
  {{- if ((($project.tofuValues).projectValues).stage) }}
    - values-{{ $project.tofuValues.projectValues.stage }}.yaml
  {{- end }}
  {{- with $project.valuesSource }}
  {{- range .valueFiles }}
    - $valuesSource/{{ . }}
  {{- end }}
  {{- end }}
{{- end }}

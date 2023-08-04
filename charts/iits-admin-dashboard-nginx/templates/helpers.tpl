{{- define "index-html" -}}
{{- $content := .Files.Get "website/index.html" -}}
{{- tpl $content . -}}
{{- end -}}





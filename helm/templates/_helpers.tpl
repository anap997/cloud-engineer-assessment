{{/* Generate a full name for resources */}}
{{- define "todoapp.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end }}

{{/* Generate a name for resources */}}
{{- define "todoapp.name" -}}
{{- printf "%s" .Chart.Name -}}
{{- end }}

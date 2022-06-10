
# # check if multiple database backends are active
{{ $postgres_operator := index .Values "postgres-operator" "enabled" }}
{{- if and (eq .Values.postgresql.enabled true) ( eq $postgres_operator true ) }}
  {{- fail "Error, two Database backends enabled ..." }}
{{- end }}

{{- define "database_host" -}}
{{ .Release.Name }}-postgresql
{{- end -}}

{{- define "database_port" -}}
5432
{{- end -}}

{{- define "rabbit_host" -}}
{{ .Release.Name }}-rabbitmq:5672
{{- end -}}

{{- define "broker_url" -}}
amqp://{{ .Values.rabbitmq.auth.username }}:{{ .Values.rabbitmq.auth.password }}@{{ include "rabbit_host" . }}/
{{- end -}}

{{- define "boolean2str" -}}
{{ . | ternary "True" "False" }}
{{- end -}}

{{- define "external_port" -}}
{{- if or (eq (toString .Values.geonode.ingress.externalPort) "80") (eq (toString .Values.geonode.ingress.externalPort) "443") -}}
{{- else -}}
:{{ .Values.geonode.ingress.externalPort}}
{{- end -}}
{{- end -}}

{{- define "public_url" -}}
{{ .Values.geonode.ingress.externalScheme }}://{{ .Values.geonode.ingress.externalDomain }}{{ include "external_port" . }}
{{- end -}}


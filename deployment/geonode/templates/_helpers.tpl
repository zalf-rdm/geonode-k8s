
# define container names (equal service names)
{{- define "geoserver_container_name" -}}
{{ .Release.Name }}-{{ .Values.geoserver.container_name }}
{{- end -}}

{{- define "geonode_container_name" -}}
{{ .Release.Name }}-{{ .Values.geonode.container_name }}
{{- end -}}

{{- define "postgres_container_name" -}}
{{ .Release.Name }}-{{ .Values.postgres.container_name }}
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


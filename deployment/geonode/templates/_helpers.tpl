
# define pod names (equal service names)
{{- define "geoserver_pod_name" -}}
{{ .Release.Name }}-{{ .Values.geoserver.pod_name }}
{{- end -}}

{{- define "geonode_pod_name" -}}
{{ .Release.Name }}-{{ .Values.geonode.pod_name }}
{{- end -}}

{{- define "postgres_pod_name" -}}
{{ .Release.Name }}-{{ .Values.postgres.pod_name }}
{{- end -}}

{{- define "nginx_pod_name" -}}
{{ .Release.Name }}-{{ .Values.nginx.pod_name }}
{{- end -}}


# Volume names
{{- define "persistant_volume_name" -}}
persistence
{{- end -}}


# ports and endpoints
{{- define "database_port" -}}
5432
{{- end -}}

{{- define "rabbit_host" -}}
{{ .Release.Name }}-rabbitmq:5672
{{- end -}}

{{- define "broker_url" -}}
amqp://{{ .Values.rabbitmq.auth.username }}:{{ .Values.rabbitmq.auth.password }}@{{ include "rabbit_host" . }}/
{{- end -}}

{{- define "public_url" -}}
{{ .Values.geonode.ingress.externalScheme }}://{{ .Values.geonode.ingress.externalDomain }}
{{- end -}}


# function
{{- define "boolean2str" -}}
{{ . | ternary "True" "False" }}
{{- end -}}


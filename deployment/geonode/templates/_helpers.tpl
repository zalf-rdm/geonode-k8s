
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
{{- if or (eq (toString .Values.general.externalPort) "80") (eq (toString .Values.general.externalPort) "443") -}}
{{- else -}}
:{{ .Values.general.externalPort}}
{{- end -}}
{{- end -}}

{{- define "public_url" -}}
{{ .Values.general.externalScheme }}://{{ .Values.general.externalDomain }}{{ include "external_port" . }}
{{- end -}}


###########################
# GEOSERVER CONFIGURATION #
###########################
- name: GEOSERVER_WEB_UI_LOCATION
  value: "{{ include "public_url" . }}/geoserver/"
- name: GEOSERVER_PUBLIC_LOCATION
  value: "{{ include "public_url" . }}/geoserver/"
- name: GEOSERVER_PUBLIC_SCHEMA
  value: {{ .Values.general.externalScheme | quote }}
- name: GEOSERVER_LOCATION
  value: "http://{{ .Release.Name }}-geoserver:8080/geoserver/"
- name: GEOSERVER_ADMIN_USER
  value: admin
- name: GEOSERVER_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: GEOSERVER_ADMIN_PASSWORD
- name: OGC_REQUEST_TIMEOUT
  value: '30'
- name: OGC_REQUEST_MAX_RETRIES
  value: '1'
- name: OGC_REQUEST_BACKOFF_FACTOR
  value: '0.3'
- name: OGC_REQUEST_POOL_MAXSIZE
  value: '10'
- name: OGC_REQUEST_POOL_CONNECTIONS
  value: '10'

# GIS Client
- name: GEONODE_CLIENT_LAYER_PREVIEW_LIBRARY
  value: mapstore

###############
# UNKNOWN USE #
###############

- name: DOCKER_ENV
  value: production

{{- end -}}

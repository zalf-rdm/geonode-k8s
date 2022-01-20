
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

# Refer to https://docs.geonode.org/en/master/basic/settings/index.html for GeoNode settings
{{- define "env_general" -}}
{{- range $key, $val := .Values.geonode.extraEnvs }}
- name: {{ $key | quote }}
  value: {{ $val | quote }}
{{- end }}
{{- range $key, $val := .Values.geonode.extraSecretEnvs }}
- name: {{ $key | quote }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-secrets
      key: {{ $key | quote }}
{{- end }}


########################
# DJANGO CONFIGURATION #
########################

- name: DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}

- name: GEONODE_INSTANCE_NAME
  value: geonode
- name: GEONODE_LB_HOST_IP
  value: {{ .Values.general.externalDomain | quote }}
- name: GEONODE_LB_PORT
  value: {{ .Values.general.externalPort | quote }}
- name: GEONODE_DB_CONN_MAX_AGE
  value: '0'
- name: GEONODE_DB_CONN_TOUT
  value: '5'

- name: BROKER_URL
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: BROKER_URL

- name: SITEURL
  value: "{{ include "public_url" . }}/"
- name: SITE_HOST_SCHEMA
  value: {{ .Values.general.externalScheme | quote }}

- name: ALLOWED_HOSTS
  value: "['django', '*', '{{ .Values.general.externalDomain }}']"

# Admin Settings
- name: ADMIN_USERNAME
  value: admin
- name: ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: ADMIN_PASSWORD
- name: ADMIN_EMAIL
  value: {{ .Values.general.superUser.email | quote }}

# EMAIL Notifications
- name: EMAIL_ENABLE
  value: 'False'
- name: DJANGO_EMAIL_BACKEND
  value: django.core.mail.backends.smtp.EmailBackend
- name: DJANGO_EMAIL_HOST
  value: {{ .Values.smtp.host | quote }}
- name: DJANGO_EMAIL_PORT
  value: {{ .Values.smtp.port | quote }}
- name: DJANGO_EMAIL_HOST_USER
  value: {{ .Values.smtp.user | quote }}
- name: DJANGO_EMAIL_HOST_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-secrets
      key: DJANGO_EMAIL_HOST_PASSWORD
- name: DJANGO_EMAIL_USE_TLS
  value: {{ include "boolean2str" .Values.smtp.tls | quote }}
- name: DJANGO_EMAIL_USE_SSL
  value: 'False'
- name: DEFAULT_FROM_EMAIL
  value: {{ .Values.smtp.from | quote }}

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

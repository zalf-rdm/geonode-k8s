
# define pod names (equal service names)
{{- define "geoserver_pod_name" -}}
{{ .Release.Name }}-geoserver
{{- end -}}

{{- define "geonode_pod_name" -}}
{{ .Release.Name }}-geonode
{{- end -}}

{{- define "postgres_pod_name" -}}
{{ .Release.Name }}-postgres
{{- end -}}

{{- define "nginx_pod_name" -}}
{{ .Release.Name }}-nginx
{{- end -}}

{{- define "pycsw_pod_name" -}}
{{ .Release.Name }}-pycsw
{{- end -}}

# define secret names
{{- define "geoserver_secret_name" -}}
{{ .Release.Name }}-geoserver-secret
{{- end -}}

{{- define "geonode_secret_name" -}}
{{ .Release.Name }}-geonode-secret
{{- end -}}



# Database definitions
{{- define "database_hostname" -}}
{{- if (eq .Values.postgres.type "operator") -}}
{{ include "postgres_pod_name" . }}
{{- else if (eq .Values.postgres.type "external") -}}
{{- .Values.postgres.external.hostname -}}
{{- end -}}
{{- end -}}

{{- define "database_port" -}}
{{- if (eq .Values.postgres.type "operator") -}}
5432
{{- else if (eq .Values.postgres.type "external") -}}
{{ .Values.postgres.external.port }}
{{- end -}}
{{- end -}}

# secret key reference for the password of user:  .Values.postgres.username
{{- define "database_postgres_password_secret_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
"{{ .Values.postgres.username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if and (eq .Values.postgres.type "external") (not .Values.postgres.external.secret.existingSecretName ) -}}
"{{ .Release.Name }}-postgres-external-secrets"
{{- else -}}
"{{.Values.postgres.external.secret.existingSecretName }}"
{{- end -}}
{{- end -}}

# secret key reference for the password of user:  .Values.postgres.geonode_databasename_and_username
{{- define "database_geonode_password_secret_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
"{{ .Values.postgres.geonode_databasename_and_username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if and (eq .Values.postgres.type "external") (not .Values.postgres.external.secret.existingSecretName ) -}}
"{{ .Release.Name }}-geonode-external-secrets"
{{- else -}}
"{{.Values.postgres.external.secret.existingSecretName }}"
{{- end -}}
{{- end -}}

# secret key reference for the password of user: .Values.postgres.geodata_databasename_and_username
{{- define "database_geodata_password_secret_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
"{{ .Values.postgres.geodata_databasename_and_username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if and (eq .Values.postgres.type "external") (not .Values.postgres.external.secret.existingSecretName ) -}}
"{{ .Release.Name }}-geodata-external-secrets"
{{- else if .Values.postgres.external.secret.existingSecretName -}}
"{{.Values.postgres.external.secret.existingSecretName }}"
{{- end -}}
{{- end -}}

# define password key name in geonode postgres secret
{{- define "database_geonode_password_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
password
{{- else if (eq .Values.postgres.type "external") -}}
geonode-password
{{- end -}}
{{- end -}}

# define password key name in geodata postgres secret
{{- define "database_geodata_password_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
password
{{- else if (eq .Values.postgres.type "external") -}}
geodata-password
{{- end -}}
{{- end -}}

# define password key name in postgres postgres secret
{{- define "database_postgres_password_key_ref" -}}
{{- if (eq .Values.postgres.type "operator") -}}
password
{{- else if (eq .Values.postgres.type "external") -}}
postgres-password
{{- end -}}
{{- end -}}

# Volume names
{{- define "persistant_volume_name" -}}
persistence
{{- end -}}

# ports and endpoints
{{- define "rabbit_host" -}}
{{ .Release.Name }}-rabbitmq:5672
{{- end -}}

{{- define "broker_url" -}}
amqp://{{ .Values.rabbitmq.auth.username }}:{{ .Values.rabbitmq.auth.password }}@{{ include "rabbit_host" . }}/
{{- end -}}

{{- define "public_url" -}}
{{ .Values.geonode.general.externalScheme }}://{{ .Values.geonode.general.externalDomain }}
{{- end -}}

# function
{{- define "boolean2str" -}}
{{ . | ternary "True" "False" }}
{{- end -}}



# define pod names (equal service names)
{{- define "geoserver_pod_name" -}}
{{ .Release.Name }}-{{ .Values.geoserver.pod_name }}
{{- end -}}

{{- define "geonode_pod_name" -}}
{{ .Release.Name }}-{{ .Values.geonode.pod_name }}
{{- end -}}

{{- define "postgres_pod_name" -}}
{{ .Release.Name }}-{{ .Values.postgres.operator_manifest.pod_name }}
{{- end -}}

{{- define "nginx_pod_name" -}}
{{ .Release.Name }}-{{ .Values.nginx.pod_name }}
{{- end -}}



# Database definitions


{{- define "database_hostname" -}}
{{- if (index .Values "postgres-operator" "enabled") -}}
{{ include "postgres_pod_name" . }}
{{- else if .Values.postgres.external_postgres.enabled -}}
{{- .Values.postgres.external_postgres.hostname -}}
{{- end -}}
{{- end -}}

{{- define "database_port" -}}
{{- if (index .Values "postgres-operator" "enabled") -}}
5432
{{- else if .Values.postgres.external_postgres.enabled -}}
{{ .Values.postgres.external_postgres.port }}
{{- end -}}
{{- end -}}

# secret key reference for the password of user:  .Values.postgres.username
{{- define "database_postgres_password_secret_key_ref" -}}
{{- if (index .Values "postgres-operator" "enabled") -}}
"{{ .Values.postgres.username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if .Values.postgres.external_postgres.enabled -}}
"{{ .Release.Name }}-postgres-external-secrets"
{{- end -}}
{{- end -}}

# secret key reference for the password of user:  .Values.postgres.geonodedatabase_and_username
{{- define "database_geonode_password_secret_key_ref" -}}
{{- if (index .Values "postgres-operator" "enabled") -}}
"{{ .Values.postgres.geonode_databasename_and_username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if .Values.postgres.external_postgres.enabled -}}
"{{ .Release.Name }}-geonode-external-secrets"
{{- end -}}
{{- end -}}

# secret key reference for the password of user: .Values.postgres.geodatabasename_and_username
{{- define "database_geodata_password_secret_key_ref" -}}
{{- if (index .Values "postgres-operator" "enabled") -}}
"{{ .Values.postgres.geodata_databasename_and_username }}.{{ include "postgres_pod_name" . }}.credentials.postgresql.acid.zalan.do"
{{- else if .Values.postgres.external_postgres.enabled -}}
"{{ .Release.Name }}-geodata-external-secrets"
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
{{ .Values.geonode.ingress.externalScheme }}://{{ .Values.geonode.ingress.externalDomain }}
{{- end -}}


# function
{{- define "boolean2str" -}}
{{ . | ternary "True" "False" }}
{{- end -}}


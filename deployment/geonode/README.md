# geonode

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Helm Chart for Geonode

**Homepage:** <https://github.com/zalf-rdm/geonode-k8s>

## Source Code

* <https://github.com/zalf-rdm/geonode-k8s>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | memcached | ~6.x.x |
| https://charts.bitnami.com/bitnami | postgresql | 11.x.x |
| https://charts.bitnami.com/bitnami | rabbitmq | ~10.1.7 |
| https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui/ | postgres-operator-ui | ~1.8.0 |
| https://opensource.zalando.com/postgres-operator/charts/postgres-operator/ | postgres-operator | ~1.8.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| geonode.celery.enabled | bool | `false` |  |
| geonode.extraConf | string | `"EXTRA_BASE_LAYERS = [\n  {\n    \"type\": \"tileprovider\",\n    \"title\": \"OpenStreetMap Terrain\",\n    \"thumbURL\": \"https://a.tile-cyclosm.openstreetmap.fr/cyclosm/10/594/518.png\",\n    \"provider\": \"custom\",\n    \"name\": \"cyclosm\",\n    \"group\": \"background\",\n    \"visibility\": False,\n    \"url\": \"https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png\",\n    \"options\": {\n      \"subdomains\": [ \"a\", \"b\", \"c\" ]\n    }\n  },\n  {\n    \"type\": \"tileprovider\",\n    \"title\": \"OpenStreetMap B&W\",\n    \"thumbURL\": \"https://tiles.wmflabs.org/bw-mapnik/0/0/0.png\",\n    \"provider\": \"OpenStreetMap.BlackAndWhite\",\n    \"name\": \"osmbw\",\n    \"group\": \"background\",\n    \"visibility\": False\n  },\n  {\n    \"type\": \"tileprovider\",\n    \"title\": \"CartoDB Light\",\n    \"thumbURL\": \"https://a.basemaps.cartocdn.com/light_all/0/0/0.png\",\n    \"provider\": \"CartoDB.Positron\",\n    \"name\": \"cartol\",\n    \"group\": \"background\",\n    \"visibility\": False\n  },\n  {\n    \"type\": \"tileprovider\",\n    \"title\": \"Stamen Watercolor\",\n    \"provider\": \"Stamen.Watercolor\",\n    \"name\": \"Stamen.Watercolor\",\n    \"source\": \"Stamen\",\n    \"group\": \"background\",\n    \"thumbURL\": \"https://stamen-tiles-c.a.ssl.fastly.net/watercolor/0/0/0.jpg\",\n    \"visibility\": False\n  }\n]\n\nMAPSTORE_BASELAYERS =  EXTRA_BASE_LAYERS + MAPSTORE_BASELAYERS\n"` |  |
| geonode.extraConf2 | string | `"# Add Google provider\nSOCIALACCOUNT_PROVIDERS['google'] = {\n  'SCOPE': [\n    'profile',\n    'email',\n  ],\n  'AUTH_PARAMS': {\n    'access_type': 'online',\n  }\n}\n\nif os.getenv('AUTH_DOMAIN'):\n  SOCIALACCOUNT_PROVIDERS['google']['AUTH_PARAMS']['hd'] = os.getenv('AUTH_DOMAIN')\n\nINSTALLED_APPS += ('allauth.socialaccount.providers.google',)\nSOCIALACCOUNT_PROFILE_EXTRACTORS['google'] = \"geonode.people.profileextractors.OpenIDExtractor\"\n"` |  |
| geonode.general.api_limit_per_page | int | `1000` | to describe |
| geonode.general.debug | bool | `false` | django debug mode |
| geonode.general.max_document_size | int | `10` | max upload document size in MB |
| geonode.general.superUser.email | string | `"support@example.com"` | admin user password |
| geonode.general.superUser.password | string | `"geonode"` | admin panel password |
| geonode.haystack.enabled | bool | `false` | enable hystack |
| geonode.haystack.engine_index_name | string | `"haystack"` | hystack index name |
| geonode.haystack.engine_url | string | `"http://elasticsearch:9200/"` | hystack url |
| geonode.haystack.search_results_per_page | string | `"200"` | hystack results per page |
| geonode.image.name | string | `"zalf/geonode"` | used geonode image |
| geonode.image.tag | string | `"latest"` | tag of used geonode image |
| geonode.ingress.enabled | bool | `true` | enables external access  |
| geonode.ingress.externalDomain | string | `"geonode"` | external ingress hostname  |
| geonode.ingress.externalPort | int | `80` | external ingress port |
| geonode.ingress.externalScheme | string | `"http"` | external ingress schema. if set to https ingress tls is used. Loading tls certificate via tls-secret options Available options: (http|https) |
| geonode.ingress.ingressClassName | string | `nil` | define kubernetes ingress class for geonode ingress |
| geonode.ingress.tlsSecret | string | `"geonode-tls-secret"` | tls certificate for geonode ingress https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/. is used when geonode.ingress.externalScheme is set to https |
| geonode.ldap.always_update_user | bool | `true` | always update local user database from ldap |
| geonode.ldap.attr_map_email_addr | string | `"mailPrimaryAddress"` | email attribute used from ldap  |
| geonode.ldap.attr_map_first_name | string | `"givenName"` | given name attribute used from ldap |
| geonode.ldap.attr_map_last_name | string | `"sn"` | last name attribute used from ldap |
| geonode.ldap.bind_dn | string | `"CN=Users,DC=ad,DC=example,DC=com"` | ldap user bind dn |
| geonode.ldap.bind_password | string | `"password"` | ldap password |
| geonode.ldap.enabled | bool | `false` | enable ldap AUTHENTICATION_BACKENDS in DJANGO Geonode |
| geonode.ldap.group_search_dn | string | `"OU=Groups,DC=ad,DC=example,DC=com"` | ldap group search dn |
| geonode.ldap.group_search_filterstr | string | `"(objectClass=group)"` | ldap group filterstr |
| geonode.ldap.mirror_groups | bool | `true` | Mirror groups with ldap (see https://docs.geonode.org/en/master/advanced/contrib/index.html) |
| geonode.ldap.uri | string | `"ldap://example.com"` | ldap uri |
| geonode.ldap.user_search_dn | string | `"OU=User,DC=ad,DC=example,DC=com"` | ldap user search dn |
| geonode.ldap.user_search_filterstr | string | `"(sAMAccountName=%(user)s)"` | ldap user filterstr |
| geonode.mail.backend | string | `"django.core.mail.backends.smtp.EmailBackend"` | set mail backend in geonode settings |
| geonode.mail.enabled | bool | `false` | enables mail configuration for geonode |
| geonode.mail.from | string | `"changeme@web.de"` | define from mail-addr  |
| geonode.mail.host | string | `"smtp.gmail.com"` | set mail host for genode mail |
| geonode.mail.password | string | `"changeme"` | set password for mailuser in geonode |
| geonode.mail.port | string | `"587"` | mail port fo geonode mail |
| geonode.mail.tls | bool | `true` | activate tls for geonode mail (only tls or ssl can be true not both) |
| geonode.mail.use_ssl | bool | `false` | enable ssl for geonode mail (only tls or ssl can be true not both) |
| geonode.mail.user | string | `"changeme"` | define mail user to send mails from |
| geonode.memcached.enabled | bool | `false` | enable memcache, this will spawn a seperate memcache container(s) and configure django geonode repsectivly. Required if django geonode runs replicas |
| geonode.memcached.lock_expire | string | `"3600"` | memcached lock expire time |
| geonode.memcached.lock_timeout | string | `"10"` | memcached lock timeout |
| geonode.monitoring.centralized_dashboard_enabled | bool | `false` |  |
| geonode.monitoring.data_tls | int | `365` |  |
| geonode.monitoring.enabled | bool | `false` |  |
| geonode.monitoring.user_analytics_enabled | bool | `true` |  |
| geonode.monitoring.user_analytics_gzip | bool | `true` |  |
| geonode.persistant.storageSize | string | `"2Gi"` | size of persistant geonode storage |
| geonode.postgresdb.replicaCount | int | `1` |  |
| geonode.register | object | `{"approval_required":false,"authentication_method":"user_email","auto_assign_registered_members_to_registered":true,"confirm_email_on_get":true,"conformation_required":true,"email_required":true,"email_verification":"mandatory","open_signup":true,"registered_members_group_name":null}` | Find docs for register values under: - https://docs.geonode.org/en/3.3.x/basic/settings/index.html  - https://github.com/pinax/django-user-accounts/blob/master/docs/settings.rst |  - https://django-allauth.readthedocs.io/en/latest/configuration.html |
| geonode.register.approval_required | bool | `false` | approve given email with registration |
| geonode.register.authentication_method | string | `"user_email"` | Specifies the login method to use – whether the user logs in by entering their username, e-mail address, or either one of both. Setting this to “email” requires email_required=True |
| geonode.register.auto_assign_registered_members_to_registered | bool | `true` | if set to True new registered user will be add to defined group in registered_members_group_name |
| geonode.register.confirm_email_on_get | bool | `true` | send confirm email on get |
| geonode.register.conformation_required | bool | `true` | If True, new user accounts will be created as inactive. The user must use the activation link to activate his account. |
| geonode.register.email_required | bool | `true` | set email as required for registration |
| geonode.register.email_verification | string | `"mandatory"` | enable email verification Determines the e-mail verification method during signup – choose one of "mandatory", "optional", or "none". Setting this to “mandatory” requires email_required to be True When set to “mandatory” the user is blocked from logging in until the email address is verified. Choose “optional” or “none” to allow logins with an unverified e-mail address. In case of “optional”, the e-mail verification mail is still sent, whereas in case of “none” no e-mail verification mails are sent. |
| geonode.register.open_signup | bool | `true` | allow user registration on geonode Default: True If True, creation of new accounts is allowed. When the signup view is called, the template account/signup.html will be displayed, usually showing a form to collect the new user data. If False, creation of new accounts is disabled. When the signup view is called, the template account/signup_closed.html will be displayed. |
| geonode.register.registered_members_group_name | string | `nil` | group name to add new registered users to, requires auto_assign_registered_members_to_registered: True.  |
| geonode.replicaCount | int | `1` | number of geonode replicas (! not working properly yet) |
| geoserver.admin_password | string | `"geoserver"` | geoserver admin password |
| geoserver.customEPSGs[0] | string | `"1=PROJCS[\"TM_Rwanda\",GEOGCS[\"GCS_ITRF_2005\",DATUM[\"D_ITRF_2005\",SPHEROID[\"GRS_1980\",6378137.0,298.257222101]],PRIMEM[\"Greenwich\",0.0],UNIT[\"Degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],PARAMETER[\"False_Easting\",500000.0],PARAMETER[\"False_Northing\",5000000.0],PARAMETER[\"Central_Meridian\",30.0],PARAMETER[\"Scale_Factor\",0.9999],PARAMETER[\"Latitude_Of_Origin\",0.0],UNIT[\"Meter\",1.0]]"` |  |
| geoserver.extraCustomEPSGs | list | `[]` |  |
| geoserver.image.name | string | `"zalf/geoserver"` | geoserver image docker image (default in zalf namespace because geonode one was not up to date) |
| geoserver.image.tag | string | `"2.19.6"` | geoserver docker image tag |
| global.accessMode | string | `"ReadWriteMany"` | storage access mode used by helm dependency pvc |
| global.storageClass | string | `nil` | storageClass used by helm dependencies pvc |
| memcached.replicaCount | int | `1` | memcached replica. Loadbalanaced via kubernetes. (only one entry in django settings.py) im memcached is activated under geonode.memcached.enabled this takes place |
| nginx.image.name | string | `"nginx"` | nginx docker image |
| nginx.image.tag | string | `"1.20"` | nginx docker image tag |
| nginx.replicaCount | int | `1` | nginx container replicas |
| postgres-operator-ui | object | `{"enabled":true,"envs":null,"ingress":{"enabled":false,"hosts":[{"host":"postgres-ui","paths":[""]}],"ingressClassName":"nginx"},"operatorApiUrl":"http://{{ $.Release.Name }}-postgres-operator:8080","replicaCount":1,"service":{"port":80,"type":"ClusterIP"}}` | VALUES DEFINITION: https://github.com/zalando/postgres-operator/blob/master/charts/postgres-operator-ui/values.yaml |
| postgres-operator.api_port | int | `8080` | REST API listener listens to this port |
| postgres-operator.configLoggingRestApi | string | `nil` |  |
| postgres-operator.enable_master_load_balancer | bool | `true` | ??? |
| postgres-operator.enabled | bool | `true` | enable postgres-operator (this or postgresql.enabled NOT both ) |
| postgres-operator.numberOfInstances | int | `1` | number of database instances |
| postgres-operator.operatorApiUrl | string | `"http://{{ .Release.Name }}-postgres-operator:8080"` | ??? |
| postgres-operator.storageClass | string | `nil` | postgress pv storageclass |
| postgres-operator.storageSize | string | `"3Gi"` | Database storage size |
| postgresql | object | `{"enabled":false,"geodataDb":"geonode_data","geonodeDb":"geonode","initdbScriptsSecret":"{{ .Release.Name }}-postgres-init","password":null,"postgresqlPassword":"admin"}` | VALUES DEFINITION https://github.com/bitnami/charts/blob/master/bitnami/postgresql/values.yaml |
| postgresql.geonodeDb | string | `"geonode"` | The usernames will be the same as the database names |
| rabbitmq | object | `{"auth":{"erlangCookie":"jixYBsiZ9RivaLXC02pTwGjvIo0nHtVu","password":null,"username":"rabbituser"},"enabled":true,"persistence":{"enabled":false}}` | VALUES DEFINITION https://github.com/bitnami/charts/blob/master/bitnami/rabbitmq/values.yaml |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

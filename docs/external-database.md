# Deploying using an external postgresql Database

Geonode-k8s supports using an external postgresql database. This database requires to have postgis extension installed. If you gonna use an external [postgres-operator](https://github.com/zalando/postgres-operator), here is a template based on the one used inside this helm chart:

```
# Source: geonode-k8s/templates/postgres/geonode-manifest.yaml
apiVersion: "acid.zalan.do/v1"
kind: postgresql
metadata:
  name: "geonode-postgresql"
spec:
  teamId: dis
  volume:
    size: 10Gi
  numberOfInstances: 2
  users:
    postgres:
    - superuser
    geonode:
    - superuser
    - createdb
    - login
    geodata:
    - superuser
    - createdb
    - login
  databases:
    geonode: geonode
    geodata: geodata
  preparedDatabases:
    geodata:
      schemas:
        public: {}
      extensions:
        pg_partman: public
        postgis: public
    geodata:
      schemas:
        public: {}
      extensions:
        pg_partman: public
        postgis: public
  postgresql:
    version: "15"
```
Get passwords from postgres-operator like:
```
kubectl get secret postgres.geonode-postgresql.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
kubectl get secret geonode.geonode-postgresql.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
kubectl get secret geodata.geonode-postgresql.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
```

But also any other postgis database can be used. Best is to use postgresql version 15.

Now you have to configure your values.yaml to use this external database. Example below: 

```
postgres:
  username: postgres
  geonode_databasename_and_username: geonode
  geodata_databasename_and_username: geodata

  external_postgres:
    enabled: True
    hostname: my-external-postgres.com
    port: 5432
    postgres_password: postgresuserpassword
    geonode_password: geonodeuserpassword
    geodata_password: geodatauserpassword

postgres-operator:
  enabled: False
```
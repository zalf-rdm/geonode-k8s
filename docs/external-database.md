# Deploying using an external postgresql Database

Geonode-k8s supports an external postgresql database. This database **requires to have postgis extension installed**. If you gonna use an external [postgres-operator](https://github.com/zalando/postgres-operator), here is a template based on the one used inside this helm chart:

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

But also any other postgis database can be used. For GeoNode 4.1 it is required to use postgresql version 15.

Now you have to configure your values.yaml to use this external database. You can use `minikube-values-external-db.yaml` or the example below in your values.yaml:

```
postgres:
  username: postgres
  geonode_databasename_and_username: geonode
  geodata_databasename_and_username: geodata

  external_postgres:
    enabled: True
    hostname: my-external-postgres.com
    port: 5432
    postgres_password: 
    geonode_password: 
    geodata_password: 

postgres-operator:
  enabled: False
```

To deploy run helm and give passwords as helm arguments like:
```
export GEONODE_K8S_POSTGRES_PASSWORD="password"
export GEONODE_K8S_GEONODE_PASSOWRD="password"
export GEONODE_K8S_GEODATA_PASSWORD="password"
helm upgrade --cleanup-on-fail --install --namespace geonode --create-namespace --values minikube-values-external-db.yaml --set postgres.external_postgres.postgres_password=${GEONODE_K8S_POSTGRES_PASSWORD} --set postgres.external_postgres.geonode_password=${GEONODE_K8S_GEONODE_PASSOWRD} --set postgres.external_postgres.geodata_password=${GEONODE_K8S_GEODATA_PASSWORD} geonode charts/geonode
```

If run on minikube follow the original [minikube docs](minikube-installation.md) for accessing the geonode installation through `minikube tunnel`.
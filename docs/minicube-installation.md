# Installation guide for Minicube

## Install Minicube

To install minicube itself follow the instruction on https://kubernetes.io/de/docs/tasks/tools/install-minikube/

## Install chart dependencies

Download or update latest helm chart dependencies listed in /chart.yaml.

```bash
helm dependency update deployment/geonode
```

## Edit Minicube values

View and edit the predefined minicube values under /minicube-values.yaml

## Run Installation

To run the installation on minikube run:
```bash
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values my-values.yaml geonode deployment/geonode
```

You can check the installtion process with:

```bash
watch kubectl get pods,services,pvc,secrets,postgresql -n geonode

# this will give you an overview over all running pods, services, pvcs,sts and the postgresql class
NAME                                             READY   STATUS    RESTARTS   AGE
pod/geonode-geoserver-0                          0/1     Running   0          20s
pod/geonode-memcached-0                          1/1     Running   0          20s
pod/geonode-nginx-d8b8df5cd-kx2n9                1/1     Running   0          20s
pod/geonode-postgres-operator-56b95cfb4b-7qmhr   1/1     Running   0          20s
pod/geonode-postgresql-0                         1/1     Running   0          38m
pod/geonode-rabbitmq-0                           0/1     Running   0          20s

NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                 AGE
service/geonode-geonode             ClusterIP   10.107.40.102    <none>        8000/TCP,8001/TCP                       20s
service/geonode-geoserver           ClusterIP   10.98.67.231     <none>        8080/TCP                                20s
service/geonode-memcached           ClusterIP   10.98.1.75       <none>        11211/TCP                               20s
service/geonode-nginx               ClusterIP   10.109.145.161   <none>        80/TCP                                  20s
service/geonode-postgres-operator   ClusterIP   10.108.12.156    <none>        8080/TCP                                20s
service/geonode-postgresql          ClusterIP   10.102.181.20    <none>        5432/TCP                                38m
service/geonode-postgresql-config   ClusterIP   None             <none>        <none>                                  37m
service/geonode-postgresql-repl     ClusterIP   10.99.120.162    <none>        5432/TCP                                38m
service/geonode-rabbitmq            ClusterIP   10.108.214.220   <none>        5672/TCP,4369/TCP,25672/TCP,15672/TCP   20s
service/geonode-rabbitmq-headless   ClusterIP   None             <none>        4369/TCP,5672/TCP,25672/TCP,15672/TCP   20s

NAME                                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pgdata-geonode-postgresql-0   Bound    pvc-fb348bb1-dbd1-469a-978e-3e89fc814e50   3Gi        RWO            standard       38m
persistentvolumeclaim/pvc-geonode-geonode           Bound    pvc-cba17c89-5da2-4b1e-adae-13428d340d91   2Gi        RWX            standard       20s

NAME                                                                        TYPE                                  DATA   AGE
secret/default-token-pwncg                                                  kubernetes.io/service-account-token   3      191d
secret/geogeonode.geonode-postgresql.credentials.postgresql.acid.zalan.do   Opaque                                2      38m
secret/geonode-postgres-init                                                Opaque                                1      20s
secret/geonode-postgres-operator-token-mt8s7                                kubernetes.io/service-account-token   3      20s
secret/geonode-rabbitmq                                                     Opaque                                2      20s
secret/geonode-rabbitmq-config                                              Opaque                                1      20s
secret/geonode-rabbitmq-token-w8gcp                                         kubernetes.io/service-account-token   3      20s
secret/geonode.geonode-postgresql.credentials.postgresql.acid.zalan.do      Opaque                                2      38m
secret/postgres-pod-token-wtwrq                                             kubernetes.io/service-account-token   3      38m
secret/postgres.geonode-postgresql.credentials.postgresql.acid.zalan.do     Opaque                                2      38m
secret/sh.helm.release.v1.geonode.v1                                        helm.sh/release.v1                    1      20s
secret/standby.geonode-postgresql.credentials.postgresql.acid.zalan.do      Opaque                                2      38m

NAME                                  READY   AGE
statefulset.apps/geonode-geonode      0/1     20s
statefulset.apps/geonode-geoserver    0/1     20s
statefulset.apps/geonode-memcached    1/1     20s
statefulset.apps/geonode-postgresql   1/1     38m
statefulset.apps/geonode-rabbitmq     0/1     20s

NAME                                          TEAM      VERSION   PODS   VOLUME   CPU-REQUEST   MEMORY-REQUEST   AGE   STATUS
postgresql.acid.zalan.do/geonode-postgresql   geonode   13        1      3Gi                                     20s   
```

The initial start takes some time, due to init process of the django application. You can check the status via:
```bash
kubectl -n geonode logs pod/geonode-geonode-0 -f 
```

## Expose Service to outside world

This installation requires to access geonode via "geonode" (or the value in .Values.geonode.ingress.externalDomain) dns entry.  So, add an entry to your /etc/hosts. First of all find the related ip addr from kubernetes service like:

```bash
# list all services in geonode namespace
kubectl -n geonode get services

service/geonode-geonode             ClusterIP   10.107.40.102    <none>        8000/TCP,8001/TCP                       20s
service/geonode-geoserver           ClusterIP   10.98.67.231     <none>        8080/TCP                                20s
service/geonode-memcached           ClusterIP   10.98.1.75       <none>        11211/TCP                               20s
service/geonode-nginx               ClusterIP   10.109.145.161   <none>        80/TCP                                  20s
service/geonode-postgres-operator   ClusterIP   10.108.12.156    <none>        8080/TCP                                20s
service/geonode-postgresql          ClusterIP   10.102.181.20    <none>        5432/TCP                                38m
service/geonode-postgresql-config   ClusterIP   None             <none>        <none>                                  37m
service/geonode-postgresql-repl     ClusterIP   10.99.120.162    <none>        5432/TCP                                38m
service/geonode-rabbitmq            ClusterIP   10.108.214.220   <none>        5672/TCP,4369/TCP,25672/TCP,15672/TCP   20s
service/geonode-rabbitmq-headless   ClusterIP   None             <none>        4369/TCP,5672/TCP,25672/TCP,15672/TCP   20s
```

Find the ip addr of the geonode-nginx service. and add an entry to your hosts file:

```
10.109.145.161   geonode
```

After that the service has to be exposed form minicube. I prefer to use minicube tunnel. Start it via, it will require root access:

```bash
mincube tunnel
```

There are several ways to expose services from minicube, find information in the minikube docs under: https://minikube.sigs.k8s.io/docs/handbook/accessing/

Now you are able to access the geonode installation by opening your browser and open http://geonode for geonode and http://geonode/geoserver for geoserver

Have Fun!
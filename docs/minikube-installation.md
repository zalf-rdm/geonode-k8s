# Installation guide for Minicube

## Install Minicube

To install minikube itself follow the instruction on https://kubernetes.io/de/docs/tasks/tools/install-minikube/

## Install chart dependencies

Download or update latest helm chart dependencies listed in /chart.yaml.

```bash
helm dependency update charts/geonode
```

## Edit Minicube values

View and edit the predefined minikube values under /minikube-values.yaml

## Run Installation

To run the installation on minikube run:
```bash
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values minikube-values.yaml geonode charts/geonode
```

You can check the installtion process with:

```bash
watch kubectl get pods,services,pvc,secrets,postgresql -n geonode

# this will give you an overview over all running pods, services, pvcs,sts and the postgresql class
NAME                                            READY   STATUS    RESTARTS   AGE
pod/geonode-geonode-0                           2/2     Running   0          19m
pod/geonode-geoserver-0                         1/1     Running   0          19m
pod/geonode-memcached-0                         1/1     Running   0          19m
pod/geonode-nginx-58fd84dc8c-27xdk              1/1     Running   0          19m
pod/geonode-postgres-operator-79fdff497-wgg9k   1/1     Running   0          19m
pod/geonode-postgresql-0                        1/1     Running   0          18m
pod/geonode-postgresql-1                        1/1     Running   0          18m
pod/geonode-postgresql-2                        1/1     Running   0          18m
pod/geonode-rabbitmq-0                          1/1     Running   0          19m

NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                 AGE
service/geonode-geonode             ClusterIP   10.107.192.66    <none>        8000/TCP,8001/TCP                       19m
service/geonode-geoserver           ClusterIP   10.101.184.88    <none>        8080/TCP                                19m
service/geonode-memcached           ClusterIP   10.109.197.248   <none>        11211/TCP                               19m
service/geonode-nginx               ClusterIP   10.97.10.57      <none>        80/TCP                                  19m
service/geonode-postgres-operator   ClusterIP   10.108.39.88     <none>        8080/TCP                                19m
service/geonode-postgresql          ClusterIP   10.104.181.46    <none>        5432/TCP                                18m
service/geonode-postgresql-config   ClusterIP   None             <none>        <none>                                  18m
service/geonode-postgresql-repl     ClusterIP   10.100.210.207   <none>        5432/TCP                                18m
service/geonode-rabbitmq            ClusterIP   10.109.132.35    <none>        5672/TCP,4369/TCP,25672/TCP,15672/TCP   19m
service/geonode-rabbitmq-headless   ClusterIP   None             <none>        4369/TCP,5672/TCP,25672/TCP,15672/TCP   19m

NAME                                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/pgdata-geonode-postgresql-0   Bound    pvc-73bcd671-305b-4da0-bbe5-977fdf0ca502   3Gi        RWO            standard       18m
persistentvolumeclaim/pgdata-geonode-postgresql-1   Bound    pvc-35545732-3a28-44db-bdc7-540cecd5f141   3Gi        RWO            standard       18m
persistentvolumeclaim/pgdata-geonode-postgresql-2   Bound    pvc-a8229ec0-de59-429a-b49f-07e5f2bbc7be   3Gi        RWO            standard       18m
persistentvolumeclaim/pvc-geonode-geonode           Bound    pvc-61c12bcc-a458-4f96-9ed2-d081220b2f1a   2Gi        RWX            standard       19m

NAME                                                                        TYPE                                  DATA   AGE
secret/default-token-k6p6d                                                  kubernetes.io/service-account-token   3      19m
secret/geogeonode.geonode-postgresql.credentials.postgresql.acid.zalan.do   Opaque                                2      18m
secret/geonode-postgres-operator-pod-token-f7p4s                            kubernetes.io/service-account-token   3      18m
secret/geonode-postgres-operator-token-j8dsk                                kubernetes.io/service-account-token   3      19m
secret/geonode-rabbitmq                                                     Opaque                                2      19m
secret/geonode-rabbitmq-config                                              Opaque                                1      19m
secret/geonode-rabbitmq-token-7ghbl                                         kubernetes.io/service-account-token   3      19m
secret/geonode.geonode-postgresql.credentials.postgresql.acid.zalan.do      Opaque                                2      18m
secret/postgres.geonode-postgresql.credentials.postgresql.acid.zalan.do     Opaque                                2      18m
secret/sh.helm.release.v1.geonode.v1                                        helm.sh/release.v1                    1      19m
secret/standby.geonode-postgresql.credentials.postgresql.acid.zalan.do      Opaque                                2      18m

NAME                                          TEAM      VERSION   PODS   VOLUME   CPU-REQUEST   MEMORY-REQUEST   AGE   STATUS
postgresql.acid.zalan.do/geonode-postgresql   geonode   13        3      3Gi                                     19m   Running
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

NAME                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                 AGE
service/geonode-geonode             ClusterIP   10.107.192.66    <none>        8000/TCP,8001/TCP                       19m
service/geonode-geoserver           ClusterIP   10.101.184.88    <none>        8080/TCP                                19m
service/geonode-memcached           ClusterIP   10.109.197.248   <none>        11211/TCP                               19m
service/geonode-nginx               ClusterIP   10.97.10.57      <none>        80/TCP                                  19m
service/geonode-postgres-operator   ClusterIP   10.108.39.88     <none>        8080/TCP                                19m
service/geonode-postgresql          ClusterIP   10.104.181.46    <none>        5432/TCP                                18m
service/geonode-postgresql-config   ClusterIP   None             <none>        <none>                                  18m
service/geonode-postgresql-repl     ClusterIP   10.100.210.207   <none>        5432/TCP                                18m
service/geonode-rabbitmq            ClusterIP   10.109.132.35    <none>        5672/TCP,4369/TCP,25672/TCP,15672/TCP   19m
service/geonode-rabbitmq-headless   ClusterIP   None             <none>        4369/TCP,5672/TCP,25672/TCP,15672/TCP   19m
```

Find the ip addr of the geonode-nginx service. and add an entry to your hosts file:

```
10.97.10.57   geonode
```

After that the service has to be exposed form minikube. I prefer to use minikube tunnel. Start it via, it will require root access:

```bash
minikube tunnel
```

There are several ways to expose services from minikube, find information in the minikube docs under: https://minikube.sigs.k8s.io/docs/handbook/accessing/

Now you are able to access the geonode installation by opening your browser and open http://geonode for geonode and http://geonode/geoserver for geoserver

Have Fun!
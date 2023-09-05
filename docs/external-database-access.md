# Access postgresql Database from Outside

In some scenarios, e.g. to upload agrovoc or maintain database, its necessary to access the postgresql database from outside of kubernetes. This can be done using the postgres-operator helm chart. Find the documentation at
(https://artifacthub.io/packages/helm/ckotzbauer/postgres-operator?modal=values&path=configLoadBalancer).

To make the database available from outside we must change the service type from **ClusterIP** to **LoadBalancer**. Therefore we can set the following configuration in our my-values.yaml:
```yaml
postgres-operator:
 configLoadBalancer:
    db_hosted_zone: geonode.example.org
    enable_master_load_balancer: true
    external_traffic_policy: Cluster
```

Applying this via:
```
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values my-values.yaml geonode charts/geonode
```

Will first of all change our service type to **LoadBalancer**. We can double check this with:

```
kubectl -n geonode get svc

# geonode-geonode                ClusterIP      10.233.46.30    <none>        8000/TCP,8001/TCP                       12d
# geonode-geoserver              ClusterIP      10.233.22.242   <none>        8080/TCP                                12d
# geonode-memcached              ClusterIP      10.233.56.173   <none>        11211/TCP                               12d
# geonode-nginx                  ClusterIP      10.233.31.120   <none>        80/TCP                                  12d
# geonode-postgres-operator      ClusterIP      10.233.35.162   <none>        8080/TCP                                12d
# geonode-postgres-operator-ui   ClusterIP      10.233.48.133   <none>        80/TCP                                  12d
# geonode-postgresql             LoadBalancer   10.233.23.191   <pending>     5432:31360/TCP                          21d
# geonode-postgresql-config      ClusterIP      None            <none>        <none>                                  21d
# geonode-postgresql-repl        ClusterIP      10.233.2.166    <none>        5432/TCP                                21d
# geonode-rabbitmq               ClusterIP      10.233.52.33    <none>        5672/TCP,4369/TCP,25672/TCP,15672/TCP   12d
# geonode-rabbitmq-headless      ClusterIP      None            <none>        4369/TCP,5672/TCP,25672/TCP,15672/TCP   12d
```

Here you can see the **geonode-postgresql** service has now the service type **LoadBalancer**. Furhter we found the NodePort to be 31360. You can get detailed information about this service via:

```
kubectl -n geonode describe svc geonode-postgresql

# Name:                        geonode-postgresql
# Namespace:                   geonode
# Labels:                      application=spilo
#                              cluster-name=geonode-postgresql
#                              spilo-role=master
#                              team=geonode
# Annotations:                 external-dns.alpha.kubernetes.io/hostname: postgresql.geonode.geonode.example.org
#                              service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: 3600
# Selector:                    <none>
# Type:                        LoadBalancer
# IP Family Policy:            SingleStack
# IP Families:                 IPv4
# IP:                          10.233.23.191
# IPs:                         10.233.23.191
# Port:                        postgresql  5432/TCP
# TargetPort:                  5432/TCP
# NodePort:                    postgresql  31360/TCP
# Endpoints:                   10.233.99.42:5432
# Session Affinity:            None
# External Traffic Policy:     Cluster
# LoadBalancer Source Ranges:  127.0.0.1/32
# Events:
#   Type    Reason  Age   From                Message
#   ----    ------  ----  ----                -------
#   Normal  Type    20m   service-controller  ClusterIP -> LoadBalancer
```

Here you can find again the NodePort. Also the external dns name is set here **Annotations** as **postgresql.geonode.geonode.example.org**. 
Before you can connect to the database check the postgres operator secrets for the geonode user password via:
```
# usernames might be different regarding your .Values.postgres.geonode.{username|geonodedatabase|geodatabasename} configuration
# get geonode user password
kubectl -n geonode  get secret geonode.geonode-postgresql.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
# get postgres user password
kubectl -n geonode  get secret postgres.geonode-postgresql.credentials.postgresql.acid.zalan.do -o 'jsonpath={.data.password}' | base64 -d
# get geogeonode user password 
```

So now you can connect to the database via:
```bash
psql -h postgresql.geonode.geonode.example.org -p 31360 -U geonode 
```
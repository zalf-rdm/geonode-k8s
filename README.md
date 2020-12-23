# kobo

This is a helm Chart for [GeoNode](https://geonode.org/), an open platform to manage and share geospatial information.

## How to run

### Prerequisites

* A Kubernetes cluster
* [Helm](https://helm.sh/)

The chart will automatically install required dependencies, i.e. a RabbitMQ broker and a Postgres database with `postgis` and `postgis_topology` extensions installed, and link them up.

### Limitations

* The built-in nginx container only supports http for now. It is expected that https support will typically be handled at the ingress level.

### Setup

Refer to `values.yaml` for details of all the variables that can be overridden, and create your own overrides in a separate file, e.g. `my-values.yaml`.

In particular you will need to setup a number of secrets, as well as provide a valid public domain name that the application will be reachable on.

Then, install the helm release as usual.

```sh
# Clone the project
git clone https://github.com/one-acre-fund/geonode-k8s && cd geonode-k8s

# Install chart dependencies
helm dependency update deployment/kobo

# Override desired values in your own override file
vi my-values.yaml

# Install chart
helm install --values my-values.yaml my-geonode deployment/geonode
```

You should see a bunch of new pods popping up:

```sh
$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
my-geonode-geonode-9c4667bbc-nnkmp   4/4     Running   0          7m8s
my-geonode-postgresql-0              1/1     Running   0          22h
my-geonode-rabbitmq-0                1/1     Running   0          22h
```

By default, no Ingress is installed, so you may have to use `kubectl port-forward`, or configure the main service to use `NodePort` or `LoadBalancer` in order to reach it from your machine.

## References

* [geonode-docker](https://github.com/GeoNode/geonode-docker) the base Docker image

# geonode-k8s

This is a helm Chart for [GeoNode](https://geonode.org/), an open platform to manage and share geospatial information.

This will deploy the following containers:

* GeoNode, the main Web UI
* A Celery container to process background tasks
* GeoServer, the back-end managing storage of all geospatial data
* Their dependencies, i.e.:
  * A PostGIS database (Postgres with the gis extension) to back GeoServer
  * RabbitMQ, to back the Celery job queue

## How to run

### Prerequisites

* A Kubernetes cluster
* [Helm](https://helm.sh/)

The chart will automatically install required dependencies, i.e. a RabbitMQ broker and a Postgres database with `postgis` extensions installed, and link them up.

This helm chart now supports geonode v4.0. Its an early version and requires a lot of refectoring to make it usable for a wide range of users.

# Install chart dependencies
```bash
helm dependency update deployment/geonode
```

# Override desired values in your own override file
vi my-values.yaml

# Install chart
```bash
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values my-values.yaml geonode deployment/geonode
```

## Delete Installation
```bash
helm delete --namespace geonode geonode deployment/geonode
```
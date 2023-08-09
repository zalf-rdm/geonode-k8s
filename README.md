
![Version: 4.1.x](https://img.shields.io/badge/Version-4.1.x-informational?style=flat-square)

# Helm Chart for Geonode

- [GeoWhat?](#Geonode)
- [Geonode-k8s](#geonode-k8s)
- [Install Guilde](#install)

**Homepage:** <https://github.com/zalf-rdm/geonode-k8s>

Geonode
-------

Geonode is a geospatial content management system, a platform for the management and publication of geospatial data. It brings together mature
and stable open-source software projects under a consistent and easy-to-use interface allowing non-specialized users to share data and
create interactive maps.

You can find the Sourcecode and more information about geonode under:
- Homepage: https://geonode.org/
- Github: https://github.com/GeoNode/geonode
- Docs: https://docs.geonode.org

Due to growing needs for high availability and scalability this repository aims at running Geonode with all required services in a cloud based manner. To due so we use Kubernetes (https://kubernetes.io/), a cloud management software, which runs on public and private clouds. As the Kubernetes echosystem can be confusing for people getting new to this field, there are packages for most services which are able to run on top of kubernetes. This packages are managed via helm (https://helm.sh/).

Geonode-k8s
-----------

This repository provides a helm chart for **geonode(4.1.x)** including additional services as:
- geoserver: source server for sharing geospatial data  (https://geoserver.org/)
- rabbitmq: message broker (scalable)
- postgresql database: using zalando postgres-operator for distributed database for geonode and postgis db for geoserver (https://github.com/zalando/postgres-operator) (scalable)
- memcached (optional): as django cache (scalable)
- nginx: webserver to deliver static content (scalable)

This helm chart provides the possibility to run most of the services redundant to increase performance on the one hand and increase fail safe on the other hand.

To get an overview of the available configuration check out the values [docs](deployment/geonode/README.md). If you want to run the helm chart first on a minikube cluster check out the [minikube](docs/minikube-installation.md) guide. Also check the minikube-values.yaml for basic configuration. 

If you want to go straight for a production installation follow the [installation](#install) guide.

Furhter docs:
- [https-ingress](docs/https-ingress.md)
- [access-geonode-database-from-outside-of-kubernetes](docs/access-geonode-database-from-outside.md)
- [configure-nginx-ingress-body-size-timeout](docs/nginx-ingress-class.md)
- [run-with-external-postgresql-database](docs/external-database.md)

Install
-------

## Prerequisites

* A Kubernetes cluster (or [minikube](docs/minikube-installation.md))
* [Helm](https://helm.sh/)

The chart will automatically install required dependencies, i.e. a RabbitMQ broker and a Postgres database with `postgis` extensions installed, and link them up.
This helm chart now supports geonode v4.1.x.

## Install chart dependencies

Update helm dependencies via:

```bash
helm dependency update deployment/geonode
```

## Override desired values in your own override file
Define your own values.yaml to configure your geonode installation. Use the [docs](deployment/geonode/README.md) to understand the parameters.

```bash
vi my-values.yaml
```

## Install chart
```bash
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values my-values.yaml geonode deployment/geonode
```

## Delete Installation
```bash
helm delete --namespace geonode geonode deployment/geonode
```

## Contribution

### Create an Issue

You found a bug :lady_beetle:? 
You have an idea how to improve :bulb:?
Feel free to [create an issue](https://github.com/zalf-rdm/geonode-k8s/issues/new/choose)!


### Documentation

Ensure values.yaml documentation is up-to-date. 
The [parameter documentation](deployment/geonode/README.md) is generated via [`helm-docs`](https://github.com/norwoodj/helm-docs).
There is a pre-commit hook configuration so please ensure you install it into your local working copy via 

```
pre-commit install
pre-commit install-hooks
```

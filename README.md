
![Version: 1.0.3](https://img.shields.io/badge/Version-1.0.3-informational?style=flat-square)

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

This repository provides a helm chart for **geonode** including additional services as:
- geoserver: source server for sharing geospatial data  (https://geoserver.org/)
- rabbitmq: message broker (scalable)
- postgresql database: using zalando postgres-operator for distributed database for geonode and postgis db for geoserver (https://github.com/zalando/postgres-operator) (scalable)
- memcached (optional): as django cache (scalable)
- nginx: webserver to deliver static content (scalable)
- pycsw: CSW interface (scalable)
This helm chart provides the possibility to run most of the services redundant to increase performance on the one hand and increase fail safe on the other hand.

To get an overview of the available configuration check out the values [docs](charts/geonode/README.md). If you want to run the helm chart first on a minikube cluster check out the [minikube](docs/minikube-installation.md) guide. Also check the minikube-values.yaml for basic configuration. 

If you want to go straight for a production installation follow the [installation](#install) guide.

Furhter docs:
- [https-ingress](docs/https-ingress.md)
- [access-geonode-database-from-outside-of-kubernetes](docs/access-geonode-database-from-outside.md)
- [use-database-outside-of-this-helm-chart](docs/external-database.md)
- [configure-nginx-ingress-body-size-timeout](docs/nginx-ingress-class.md)
- [run-with-external-postgresql-database](docs/external-database.md)
- [custom-secret-handling](docs/provide-custom-secret.md)
- [how-to-configure-external-pycsw](docs/pycsw.md)
Install
-------

## Prerequisites

* A Kubernetes cluster (or [minikube](docs/minikube-installation.md))
* [Helm](https://helm.sh/)

The chart will automatically install required dependencies, i.e. a RabbitMQ broker and a Postgres database with `postgis` extensions installed, and link them up.

| GeoNode-k8s<br /> chart version | GeoNode<br /> version(s) | geonode container image | geoserver container image | 
|---------------------------|--------------------|-------------------------|---------------------------|
| [1.0.0](https://github.com/zalf-rdm/geonode-k8s/releases/tag/1.0.0) | [4.1.2](https://github.com/GeoNode/geonode/releases/tag/4.1.2) | [52north/geonode:4.1.2](https://hub.docker.com/r/52north/geonode/tags) | [geonode/geoserver:2.23.0](https://hub.docker.com/r/geonode/geoserver/tags) |
| [1.0.1](https://github.com/zalf-rdm/geonode-k8s/releases/tag/1.0.1) | [4.1.2](https://github.com/GeoNode/geonode/releases/tag/4.1.2) | [52north/geonode:4.1.2](https://hub.docker.com/r/52north/geonode/tags) | [geonode/geoserver:2.23.0](https://hub.docker.com/r/geonode/geoserver/tags) |
| [1.0.2](https://github.com/zalf-rdm/geonode-k8s/releases/tag/1.0.2) | [4.1.2](https://github.com/GeoNode/geonode/releases/tag/4.1.2) | [52north/geonode:4.1.2](https://hub.docker.com/r/52north/geonode/tags) | [geonode/geoserver:2.23.0](https://hub.docker.com/r/geonode/geoserver/tags) |
| [1.0.3](https://github.com/zalf-rdm/geonode-k8s/releases/tag/1.0.2) | [4.1.3](https://github.com/GeoNode/geonode/releases/tag/4.1.3)  | [52north/geonode:4.1.3](https://hub.docker.com/r/52north/geonode/tags) | [geonode/geoserver:2.23.0](https://hub.docker.com/r/geonode/geoserver/tags) |

## Install chart dependencies

Update helm dependencies via:

```bash
helm repo add geonode https://zalf-rdm.github.io/geonode-k8s/
helm repo update
```

## Override desired values in your own override file
Define your own values.yaml to configure your geonode installation. Use the [docs](charts/geonode/README.md) to understand the parameters.

```bash
vi my-values.yaml
```

## Install chart
```bash
helm upgrade --cleanup-on-fail   --install --namespace geonode --create-namespace --values my-values.yaml geonode charts/geonode
```

## Delete Installation
```bash
helm delete --namespace geonode geonode charts/geonode
```

## Contribution

### Create an Issue

You found a bug :lady_beetle:? 
You have an idea how to improve :bulb:?
Feel free to [create an issue](https://github.com/zalf-rdm/geonode-k8s/issues/new/choose)!


### Documentation

Ensure values.yaml documentation is up-to-date. 
The [parameter documentation](charts/geonode/README.md) is generated via [`helm-docs`](https://github.com/norwoodj/helm-docs).
There is a pre-commit hook configuration so please ensure you install it into your local working copy via 

```
pre-commit install
pre-commit install-hooks
```

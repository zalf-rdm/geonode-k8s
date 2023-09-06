HTTPS Ingress
-------------

To enable https for the given configuration: geonode.general.externalDomain in values.yaml. Set the externalScheme to "https" and define a secret which has to be
in the same namespace as the geonode installation.

```
geonode.general.externalScheme: https
geonode.ingress.tlsSecret: geonode-tls-secret
```

After configuring the ingress. The secret can be created via. It requires a cert.key and a cert.pem file. Find Kubernetes docs under (https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)

```bash
kubectl create secret --namespace geonode tls geonode-tls-secret --key="cert.key" --cert="cert.pem"
```
# Maintain Secrets

Ensure to put confidential settings in a Kubernetes Secret.
By default, each service provides a secret template which is filled by the values within the `secret` section given in the `values.yaml` for each component.

In your `values.yaml` you have two options:

1. Set the secret values directly within the `secret` section
1. Override the `secret.existingSecretName` to reference a secret which you maintain separately
 

> :bulb: **Note:**
>
> Make sure to not expose your secrets, e.g. via Git! 
> Consider to pass secrets from a CD pipeline via masked environment settings.

Consult the documentation of Chart dependencies how this is done there (most of them handle it similarly).
For example, you can configure externally managed Secrets [in the `auth` section of the rabbitmq config](https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/values.yaml#L130):

```yaml
rabbitmq:
  auth:
    username: rabbituser
    existingPasswordSecret: "rabbitmq-password-secret"
    existingErlangSecret: "rabbitmq-erlang-secret"

```


## Tooling


### Kustomize

Kubernetes Secrets contain base64 encoded strings which makes it cumbersome to maintain.
Consider to use `kustomize` to generate and apply a Secret from a given file.
In all cases, remember to exclude files from version control which contain sensitive data.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

secretGenerator:
- name: geonode-secret  # the secret's name
  env: geonode-secret.properties
```

To exclude `geonode-secret.properties` from version control, just add it to `.gitignore`:

```sh
echo geonode-secret.properties >> .gitignore
```

### Helm Plugins

There are Helm plugins which helps you maintaining secrets within your deploy chain.

* https://medium.com/@Devopscontinens/encrypting-helm-secrets-7f37a0ccabeb
* https://github.com/getsops/sops

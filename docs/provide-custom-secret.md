# Maintain Secrets

Ensure to put confidential settings in a Kubernetes Secret.
By default, each service provides a secret template which is filled by the `secret.content` value given in the `values.yaml` for each component.

In your `values.yaml` you have two options:

1. Override the `secret.content` to set project specific secrets
1. Create custom Kubernetes Secrets and configure `secret.name` accordingly

> :bulb: **Note:**
>
> Make sure to not expose your secrets, e.g. via Git! 
> Consider to pass secrets from a CD pipeline via masked environment settings.
> By referencing a custom Secret (leaving `secret.content` empty), you would have to create and maintain a Secret by yourself.

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

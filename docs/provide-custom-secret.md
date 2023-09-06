# Provide Custom Secret

Ensure to put confidential settings in a Kubernetes Secret.
By default, the `./charts/geonode/templates/geonode/demo-secret.yaml` is applied along the installation.

Get the default secrets via `helm template -s templates/geonode/geonode-secret.yaml charts/geonode > custom-secret.yaml`.
Make your changes and apply the Secret using `kubectl apply -f <customized-secret>.yml` in the namespace you want to install `geonode-k8s` into.

> :bulb: **Note:**
>
> Once you configured the secret change the name.
> This name has to be set as `geonode.general.secretName` in the `values.yaml`.

Alternatively, you may consider using `kustomization` which generates a secret from a given file (which you could exclude from version control as well) like so:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Generates a Kubernetes secret containing sensible configuration
# by reading a .env file you would have to create
# Make sure to apply this secret in that namespace Helm installs
# the geonode release into

secretGenerator:
- name: my-custom-secret  # the secret's name
  env: .env
```

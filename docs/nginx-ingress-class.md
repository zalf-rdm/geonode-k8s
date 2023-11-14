# nginx-ingress Configuration

The annotations documented below gives you hints on nginx configuration options you may have to set with regard on your deployment.

> :bulb: **Note:**
>
> Configure all nginx annotations via JSON object in the `.Values.ingress.annotations` setting.
>
> Have a look at [the list of available nginx-annotations](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/annotations.md) (check the version first) for the ingress-nginx controller.

## Increasing the max upload size for kubernetes nginx-ingress

If you run the nginx ingress controller on your cluster, you may ran into an issue where you are unable to upload larger files into your geonode instance.
To avoid this you can increase the `proxy-body-size` for the [nignx-ingress](../charts/geonode/templates/nginx/nginx-ingress.yaml) definition:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "2g"
```

Further, the variable `nginx.maxClientBodySize` will define the maximum fileupload for the nginx used within the geonode installation.

## Increase the max proxy-read-timeout for kubernetes nginx-ingress

If you run into trouble getting timeouts while uploading data, you may need to update the nginx ingress class [accordingly](https://github.com/kubernetes/ingress-nginx/issues/3976). 
This requires another addition to the nginx ingress annotations like:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-read-timeout: "7200"
```

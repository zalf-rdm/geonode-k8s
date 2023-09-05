# increasing the max uplaod size for kubernetes nginx-ingress

If you run the nginx ingress controller on your cluster. You may ran into an issue where you are unable to upload larger files into your geonode instance. To avoid this you can can ingrese the proxy-body-size for the [nignx-ingress](../charts/geonode/templates/nginx/nginx-ingress.yaml) definition. See snippet below. 
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "2g"
```

Further the values variable `nginx.maxClientBodySize` will define the maximum fileupload for the nginx used within the geonode installation.

# increase the max proxy-read-timeout for kubernetes nginx-ingress

If you run into trouble getting timeouts while uploading data, you may need to update the nginx ingress class [accordingly](https://github.com/kubernetes/ingress-nginx/issues/3976). This requires another addition to the nginx ingress annotations like:

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/proxy-read-timeout: "7200"
```
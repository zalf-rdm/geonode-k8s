External pyCSW 
--------------

  
GeoNode-k8s external pycsw (version 2.6.1) container. This allows changes to pyCSW with having to change GeoNode codebase and allows scalability of the pyCSW service seperatly. The external pycsw service is by default enabled. To disable set: `.Values.pycsw.enabled = False`

The pycsw configuration (pycsw.cfg) and mappings are defined in the values file: `[ .Values.pycsw.config , .Values.pycsw.mappings ]`, docs for the configuration can be found [here]( https://docs.pycsw.org/en/2.6.1/configuration.html.)

The csw endpoint is default set to the one used within Geonode: `/catalogue/csw`

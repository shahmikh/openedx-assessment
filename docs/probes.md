# Liveness and Readiness Probes

## LMS/CMS (HTTP)
Use scripts/apply-probes.sh to add HTTP probes to LMS and CMS deployments.

## Workers (Exec)
Workers do not expose HTTP endpoints. Add exec probes to worker deployments. Example:
```
kubectl -n openedx patch deployment <worker-deployment> --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/livenessProbe","value":{"exec":{"command":["/bin/sh","-c","pgrep -f celery"]},"initialDelaySeconds":60,"periodSeconds":30}},
  {"op":"add","path":"/spec/template/spec/containers/0/readinessProbe","value":{"exec":{"command":["/bin/sh","-c","pgrep -f celery"]},"initialDelaySeconds":30,"periodSeconds":20}}
]'
```

## MongoDB/Elasticsearch
The Bitnami Helm charts include liveness and readiness probes by default.

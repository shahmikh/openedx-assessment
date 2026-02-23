# Observability

## Monitoring
- Prometheus + Grafana via kube-prometheus-stack
- Custom alerts in k8s/alerts.yaml

## Logging
- Fluent Bit to CloudWatch (helm-values/fluent-bit-values.yaml)

## Dashboards
- Use Grafana dashboards for Kubernetes and Nginx Ingress
- Import additional OpenEdX-specific dashboards as needed
- Optional: add MongoDB and Elasticsearch exporters for deeper database metrics

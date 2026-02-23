# Configuration Decisions & Rationale

1. Terraform for infra
- Enables repeatable, auditable infra provisioning.

2. Data persistence strategy (managed where compatible)
- RDS for MySQL (managed)
- ElastiCache for Redis (managed)
- MongoDB and Elasticsearch in-cluster as StatefulSets with PV/PVC due to compatibility constraints

3. Nginx Ingress replacing Caddy
- Enterprise-ready and supports TLS termination, HTTP/2, WAF/CloudFront integration.

Optional ALB path:
- If ALB is mandatory, deploy AWS Load Balancer Controller and route ALB to the Nginx reverse proxy service (k8s/nginx-reverse-proxy.yaml).

4. EFS for shared media
- Shared RWX storage required across pods.

5. GitOps with ArgoCD
- Declarative delivery and auditable change control.

6. Istio service mesh
- Enables mTLS, advanced traffic policies, and observability.

7. Multi-environment
- Separate env directories with isolated state.

## Notes
- The clarification requires in-cluster deployment when managed services are not fully compatible; this repo follows that rule.
- This supersedes the earlier “databases must not run in Kubernetes” line for MongoDB/Elasticsearch only.

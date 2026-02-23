# OpenEdX on AWS EKS (Production-Grade Reference)

This repository delivers a complete, production-ready deployment blueprint for OpenEdX on AWS EKS, aligned with the Al Nafi DevOps technical assessment. It includes infrastructure as code, Kubernetes manifests, Tutor configuration, Nginx ingress, external data services, observability, backups, GitOps, CI/CD, and documentation.

Target OS for execution: Ubuntu 22.04.05 LTS
Cloud: AWS only (EKS)
Databases use managed services where fully compatible; otherwise they run in-cluster as StatefulSets with persistent storage (per assessment clarification).

## What You Get
- AWS EKS cluster with VPC, node groups, IAM, and security boundaries
- External data services: RDS MySQL and ElastiCache Redis (managed). MongoDB and Elasticsearch run in-cluster as StatefulSets with PV/PVC due to compatibility requirements.
- Tutor-based OpenEdX deployment on Kubernetes (latest stable at deploy time)
- Nginx ingress replacing Caddy; TLS termination at Nginx; HTTP/2 enabled
- CloudFront + WAF in front of NLB
- PV/PVC via EFS (uploads/media) and EBS (MongoDB/Elasticsearch)
- HPA for LMS/CMS
- Centralized monitoring and logging
- Backup/restore automation
- GitOps with ArgoCD
- CI/CD pipelines (GitHub Actions)
- Service mesh (Istio)
- DR, cost optimization, and multi-environment support

## Quick Start (High-Level)
1. Read docs/deployment-guide.md and docs/architecture.md
2. Follow docs/database-setup.md for MongoDB and Elasticsearch initialization
3. Configure AWS credentials and set variables in infra/terraform/envs/{dev,staging,prod}
4. Provision infra using Terraform
5. Install cluster addons (ingress, metrics, EFS CSI, monitoring)
6. Configure Tutor and deploy OpenEdX with external services
7. Validate HPA, logging, and backup scripts

## Repository Layout
- docs/                Detailed guides, database setup, decisions, troubleshooting, and evidence checklist
- diagrams/            Mermaid diagrams for architecture and network flow
- infra/terraform/     AWS infrastructure as code (multi-environment)
- k8s/                 Kubernetes manifests and overlays (including db namespace)
- helm-values/         Values files for Helm-based addons
- scripts/             Automation scripts (deploy, backup, restore, tests)
- nginx/               Nginx reverse proxy configuration
- .github/workflows/   CI/CD pipeline definitions

## Requirements Mapping
- AWS EKS only: infra/terraform + docs/deployment-guide.md
- Tutor k8s: docs/deployment-guide.md + scripts/tutor-deploy.sh
- External DBs (MySQL, Redis): infra/terraform/modules/rds-mysql, infra/terraform/modules/redis + docs/architecture.md
- In-cluster DBs (MongoDB, Elasticsearch): helm-values/mongodb-values.yaml, helm-values/elasticsearch-values.yaml + docs/database-setup.md
- Nginx replacing Caddy: helm-values/nginx-ingress-values.yaml + k8s/ingress-openedx.yaml + nginx/nginx.conf
- CloudFront + WAF: infra/terraform/modules/cloudfront-waf + docs/architecture.md
- PV/PVC for media: k8s/storageclass-efs.yaml + k8s/pvc-openedx.yaml
- HPA: k8s/hpa-lms.yaml + k8s/hpa-cms.yaml
- Logging/monitoring: helm-values/kube-prometheus-stack-values.yaml + scripts/monitoring
- Backups: scripts/backup/* + docs/backup-restore.md
- Proof artifacts: docs/evidence-checklist.md

## Note on Compatibility Services
MongoDB and Elasticsearch are deployed in-cluster as StatefulSets because managed services are not fully API compatible.

## Next
Start with docs/deployment-guide.md

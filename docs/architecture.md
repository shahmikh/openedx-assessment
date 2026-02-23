# Architecture

## Reference Architecture
Security Layer:
- AWS WAF -> CloudFront -> AWS Load Balancer (NLB created by Nginx Ingress)

Web Layer:
- Nginx Ingress Controller (TLS termination, HTTP/2, routing)

Application Layer:
- OpenEdX LMS, CMS, Workers (EKS Pods via Tutor k8s)

Data Layer (External and In-Cluster):
- RDS MySQL (managed)
- ElastiCache Redis (managed)
- MongoDB (in-cluster StatefulSet + PV/PVC)
- Elasticsearch (in-cluster StatefulSet + PV/PVC)

Storage Layer:
- EFS (PV/PVC for uploads and media)
- EBS (PV/PVC for MongoDB and Elasticsearch StatefulSets)

Note: Managed services are used where fully compatible; otherwise databases run in-cluster as StatefulSets with PV/PVC (namespace `openedx-db`).

## Component Rationale
- EKS provides managed control plane, IAM integration, and scalability.
- Tutor k8s deployment target provides standard OpenEdX deployment flows.
- Nginx Ingress replaces Caddy and provides a hardened, enterprise-grade edge.
- Managed data services reduce operational overhead and provide HA where compatible.
- CloudFront + WAF provides global caching and security controls.
- EFS provides shared, durable storage for media and uploads.

## Availability
- Multi-AZ for EKS node groups, RDS, Redis, and zonal spreading for MongoDB/Elasticsearch StatefulSets.
- HPA for LMS and CMS.
- Rolling updates for OpenEdX services.

## Security
- IAM roles for service accounts (IRSA).
- Security groups with least privilege.
- TLS at Nginx Ingress with ACM certificates.
- WAF managed rule groups + rate limiting.

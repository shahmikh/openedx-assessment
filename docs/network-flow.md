# Network Flow

Client -> CloudFront -> AWS WAF -> NLB (Nginx Ingress Service) -> OpenEdX services

## Ingress Routing
- lms.<domain> -> LMS service
- studio.<domain> -> CMS service

## Data Paths
- LMS/CMS -> RDS MySQL
- LMS/CMS -> MongoDB (StatefulSet in `openedx-db`)
- LMS/CMS -> Elasticsearch (StatefulSet in `openedx-db`)
- LMS/CMS -> ElastiCache Redis
- LMS/CMS -> EFS for media and uploads

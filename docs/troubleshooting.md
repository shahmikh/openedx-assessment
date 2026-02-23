# Troubleshooting Guide

1. Pods stuck in Pending
- Check node group capacity and EFS CSI availability.
- Verify security group rules for EFS mount targets.
- Check EBS CSI driver and PVC binding for MongoDB/Elasticsearch.

2. LMS/CMS not reachable
- Validate Ingress address and DNS.
- Check TLS certificate status in ACM.

3. Database connection failures
- Verify MongoDB and Elasticsearch StatefulSets are Ready in namespace `openedx-db`.
- Ensure MongoDB replica set is initialized if required by the chart.
- Confirm credentials in Kubernetes secrets.

4. HPA not scaling
- Ensure metrics-server is running and reachable.
- Check CPU requests/limits on LMS/CMS deployments.

5. CloudFront not serving content
- Verify origin is the NLB created by Nginx Ingress and health checks are passing.
- Confirm WAF rules are not blocking.

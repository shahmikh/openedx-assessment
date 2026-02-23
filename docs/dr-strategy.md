# Disaster Recovery & Failover

## Strategy
- Multi-AZ for all managed services
- Daily snapshots for RDS, MongoDB, Elasticsearch
- Use EBS VolumeSnapshots and application-level backups for in-cluster MongoDB/Elasticsearch
- Spread StatefulSet replicas across zones using anti-affinity
- Cross-region snapshot copy (optional)
- EFS backups with AWS Backup

## Failover
- Documented restore steps in scripts/restore/
- DNS cutover to alternate region if required

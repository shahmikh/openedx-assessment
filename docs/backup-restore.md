# Backup & Restore

## Databases
- RDS: automated backups + manual snapshots
- MongoDB (in-cluster): mongodump + S3 (see scripts/backup/mongo-backup.sh)
- Install `mongodb-database-tools` on the backup host if `mongodump` is missing.
- Elasticsearch (in-cluster): snapshot repository to S3 (see scripts/backup/elasticsearch-snapshot.sh). The Helm values enable `repository-s3` plugin.
- ElastiCache: snapshots (if enabled)

## Persistent Volumes
- EFS: AWS Backup plan for EFS file system
- EBS (MongoDB/Elasticsearch): VolumeSnapshot via CSI (see k8s/volume-snapshotclass-ebs.yaml and scripts/backup/pvc-snapshot.sh)
  - Ensure the VolumeSnapshot CRDs are installed (EBS CSI driver usually provides them).

## Scripts
- scripts/backup/* for snapshot creation
- scripts/restore/* for restoration flows

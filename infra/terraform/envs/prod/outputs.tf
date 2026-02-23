output "eks_cluster_name" { value = module.eks.cluster_name }
output "rds_endpoint" { value = module.rds.endpoint }
output "redis_endpoint" { value = module.redis.primary_endpoint }
output "efs_id" { value = module.efs.file_system_id }
output "efs_ap" { value = module.efs.access_point_id }
output "cloudfront_domain" { value = module.cloudfront_waf.distribution_domain }

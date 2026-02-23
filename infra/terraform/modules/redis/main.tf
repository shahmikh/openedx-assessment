resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.replication_group_id}-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = var.replication_group_id
  description                   = "Redis replication group for OpenEdX"
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  num_cache_clusters            = var.num_cache_clusters
  automatic_failover_enabled    = var.automatic_failover_enabled
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [var.sg_id]
  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = true

  tags = var.tags
}

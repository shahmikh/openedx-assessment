terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  name            = var.name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  tags            = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "${var.name}-eks"
  cluster_version    = var.eks_version
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets
  node_instance_types = var.node_instance_types
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  node_desired_size  = var.node_desired_size
  tags               = var.tags
}

resource "aws_security_group" "data" {
  name        = "${var.name}-data-sg"
  description = "Allow EKS nodes to access data services"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "data_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.data.id
  source_security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group_rule" "data_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.data.id
  source_security_group_id = module.eks.node_security_group_id
}

resource "aws_security_group" "efs" {
  name        = "${var.name}-efs-sg"
  description = "Allow EKS nodes to access EFS"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "efs_nfs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = module.eks.node_security_group_id
}

module "rds" {
  source = "../../modules/rds-mysql"

  identifier              = "${var.name}-mysql"
  db_name                 = var.mysql_db_name
  username                = var.mysql_username
  password                = var.mysql_password
  engine_version          = var.mysql_engine_version
  instance_class          = var.mysql_instance_class
  allocated_storage       = var.mysql_allocated_storage
  subnet_ids              = module.vpc.private_subnets
  sg_id                   = aws_security_group.data.id
  multi_az                = true
  backup_retention_period = 7
  tags                    = var.tags
}


module "redis" {
  source = "../../modules/redis"

  replication_group_id       = "${var.name}-redis"
  engine_version             = var.redis_engine_version
  node_type                  = var.redis_node_type
  num_cache_clusters         = var.redis_num_cache_clusters
  automatic_failover_enabled = true
  subnet_ids                 = module.vpc.private_subnets
  sg_id                      = aws_security_group.data.id
  tags                       = var.tags
}

module "efs" {
  source = "../../modules/efs"

  name       = "${var.name}-efs"
  subnet_ids = module.vpc.private_subnets
  sg_id      = aws_security_group.efs.id
  tags       = var.tags
}

module "backup_bucket" {
  source = "../../modules/s3-backup"

  bucket_name = "${var.name}-backups-${var.aws_region}"
  tags        = var.tags
}

module "cloudfront_waf" {
  source    = "../../modules/cloudfront-waf"
  providers = { aws = aws.us_east_1 }

  name         = var.name
  lb_dns_name  = var.lb_dns_name
  acm_cert_arn = var.acm_cert_arn
  origin_protocol_policy = var.origin_protocol_policy
  price_class  = var.cloudfront_price_class
  rate_limit   = var.waf_rate_limit
  tags         = var.tags
}

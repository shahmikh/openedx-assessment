variable "aws_region" { type = string }
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }

variable "eks_version" { type = string }
variable "node_instance_types" { type = list(string) }
variable "node_min_size" { type = number }
variable "node_max_size" { type = number }
variable "node_desired_size" { type = number }

variable "mysql_db_name" { type = string }
variable "mysql_username" { type = string }
variable "mysql_password" { type = string }
variable "mysql_engine_version" { type = string }
variable "mysql_instance_class" { type = string }
variable "mysql_allocated_storage" { type = number }


variable "redis_engine_version" { type = string }
variable "redis_node_type" { type = string }
variable "redis_num_cache_clusters" { type = number }

variable "lb_dns_name" { type = string }
variable "acm_cert_arn" {
  type    = string
  default = ""
}
variable "origin_protocol_policy" {
  type    = string
  default = "http-only"
}
variable "cloudfront_price_class" { type = string }
variable "waf_rate_limit" { type = number }

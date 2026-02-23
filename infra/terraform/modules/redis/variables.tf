variable "replication_group_id" { type = string }
variable "engine_version" { type = string }
variable "node_type" { type = string }
variable "num_cache_clusters" { type = number }
variable "automatic_failover_enabled" { type = bool }
variable "subnet_ids" { type = list(string) }
variable "sg_id" { type = string }
variable "tags" { type = map(string) default = {} }

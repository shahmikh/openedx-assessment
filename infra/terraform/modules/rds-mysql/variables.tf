variable "identifier" { type = string }
variable "db_name" { type = string }
variable "username" { type = string }
variable "password" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "subnet_ids" { type = list(string) }
variable "sg_id" { type = string }
variable "multi_az" { type = bool }
variable "backup_retention_period" { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}

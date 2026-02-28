variable "name" { type = string }
variable "lb_dns_name" { type = string }
variable "acm_cert_arn" {
  type    = string
  default = ""
}
variable "origin_protocol_policy" {
  type    = string
  default = "http-only"
}
variable "price_class" { type = string }
variable "rate_limit" { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}

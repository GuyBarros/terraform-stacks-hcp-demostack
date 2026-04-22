variable "vpc_id" {
  description = "VPC where the security group will be created."
}

variable "namespace" {
  description = "Unique deployment identifier used as the security group name prefix."
}

variable "host_access_ip" {
  description = "CIDR blocks allowed SSH/RDP/LDAP access (your operator IP)."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed access to service ports (Vault, Nomad, Fabio, DBs etc)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "workers" {
  description = "Number of worker VMs."
  type        = string
  default     = "3"
}

variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-2"
}

variable "zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string
}

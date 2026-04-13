# components/hashistack-cluster/variables.tf

variable "region" {
  type        = string
  description = "AWS region for this cluster."
}

variable "namespace" {
  type        = string
  description = "Unique namespace / datacenter name for this cluster."
}

variable "owner" {
  type        = string
  description = "IAM user responsible for lifecycle of cloud resources."
}

variable "public_key" {
  type        = string
  description = "Contents of the SSH public key to use for connecting to the cluster."
}

variable "se_region" {
  type        = string
  description = "Mandatory SE organisation tag."
}

variable "purpose" {
  type        = string
  description = "Purpose tag applied to all resources."
}

variable "name" {
  type        = string
  description = "Name tag applied to all resources."
}

variable "host_access_ip" {
  type        = list(string)
  description = "IP addresses that are allowed SSH access."
  default     = []
}

variable "servers" {
  type        = number
  description = "Number of Consul/Vault/Nomad server nodes."
  default     = 3
}

variable "workers" {
  type        = number
  description = "Number of Nomad worker nodes."
  default     = 3
}

variable "fabio_url" {
  type    = string
  default = "https://github.com/fabiolb/fabio/releases/download/v1.5.7/fabio-1.5.7-go1.9.2-linux_amd64"
}

variable "cni_version" {
  type    = string
  default = "1.6.0"
}

variable "enterprise" {
  type    = bool
  default = false
}

variable "vaultlicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "consullicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "nomadlicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "instance_type_server" {
  type    = string
  default = "t4g.xlarge"
}

variable "instance_type_worker" {
  type    = string
  default = "t4g.xlarge"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "zone_id" {
  type    = string
  default = ""
}

variable "run_nomad_jobs" {
  type    = string
  default = "0"
}

variable "TTL" {
  type    = string
  default = "240"
}

variable "sleep_at_night" {
  type    = bool
  default = true
}

variable "created_by" {
  type    = string
  default = "Terraform"
}

variable "primary_datacenter" {
  type        = string
  description = "The primary datacenter name used for mesh gateway configuration."
}

variable "f5_username" {
  type    = string
  default = "admin"
}

variable "f5_password" {
  type      = string
  sensitive = true
  default   = "admin"
}

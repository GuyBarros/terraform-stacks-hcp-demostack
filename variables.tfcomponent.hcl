# variables.tfcomponent.hcl

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "role_arn" {
  type = string
}

variable "hcp_client_id" {
  type      = string
  ephemeral = true
}

variable "hcp_client_secret" {
  type      = string
  ephemeral = true
  sensitive = true
}

variable "region" {
  type = string
}

variable "namespace" {
  type = string
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
  type = string
}

variable "public_key" {
  type = string
}

variable "host_access_ip" {
  type      = list(string)
  ephemeral = true
  default   = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach service ports (Vault, Nomad, Fabio, DBs). Pull from variable set."
  type        = list(string)
  ephemeral   = true
  default     = ["0.0.0.0/0"]
}

variable "workers" {
  type    = string
  default = "3"
}

variable "instance_type_worker" {
  type    = string
  default = "t3.medium"
}

variable "run_nomad_jobs" {
  type    = string
  default = "0"
}

variable "cni_plugin_url" {
  type    = string
  default = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

variable "enterprise" {
  type    = bool
  default = false
}

variable "nomadlicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "hcp_vault_cluster_tier" {
  type    = string
  default = "dev"
}

variable "hcp_boundary_cluster_tier" {
  type    = string
  default = "standard"
}

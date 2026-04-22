variable "consul_datacenter" {
  type        = string
  description = "HCP Consul datacenter name."
}

variable "workers" {
  type        = number
  description = "Number of workers — one ACL token is created per worker."
  default     = 3
}

variable "vault_private_endpoint" {
  type        = string
  description = "HCP Vault private endpoint URL for Consul service registration."
}

variable "boundary_cluster_url" {
  type        = string
  description = "HCP Boundary cluster URL for Consul service registration."
}

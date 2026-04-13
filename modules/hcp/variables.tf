# modules/hcp/variables.tf

variable "namespace" {
  type        = string
  description = "Unique name for this deployment — used as cluster IDs and resource names."
}

variable "region" {
  type        = string
  description = "AWS region where the VPC and HCP resources reside."
  default     = "eu-west-2"
}

variable "vpc_id" {
  type        = string
  description = "ID of the AWS VPC to peer with the HCP HVN."
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the AWS VPC — used for the HVN route destination."
  default     = "10.1.0.0/16"
}

variable "workers" {
  type        = number
  description = "Number of worker nodes — controls how many Consul ACL tokens to create."
  default     = 3
}

variable "hcp_vault_cluster_tier" {
  type        = string
  description = "HCP Vault cluster tier (e.g. dev, starter_small, standard_small)."
  default     = "dev"
}

variable "hcp_consul_cluster_tier" {
  type        = string
  description = "HCP Consul cluster tier (e.g. development, standard)."
  default     = "development"
}

variable "hcp_consul_cluster_size" {
  type        = string
  description = "HCP Consul cluster size (e.g. x_small, small, medium, large)."
  default     = "x_small"
}

variable "hcp_boundary_cluster_tier" {
  type        = string
  description = "HCP Boundary cluster tier (e.g. standard)."
  default     = "standard"
}

variable "packer_bucket_name" {
  type        = string
  description = "HCP Packer bucket name for the demostack AMI."
  default     = "demostack"
}

variable "packer_channel" {
  type        = string
  description = "HCP Packer channel to pull the latest demostack image from."
  default     = "production"
}

variable "namespace" {
  type        = string
  description = "Unique deployment identifier."
}

variable "region" {
  type        = string
  description = "AWS region where HCP resources will be peered."
  default     = "eu-west-2"
}

variable "vpc_id" {
  type        = string
  description = "ID of the AWS VPC to peer with the HCP HVN."
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the AWS VPC for the HVN route."
  default     = "10.1.0.0/16"
}

variable "hcp_vault_cluster_tier" {
  type    = string
  default = "dev"
}

variable "hcp_boundary_cluster_tier" {
  type    = string
  default = "standard"
}

# variables.tfcomponent.hcl

# ---------------------------------------------------------------------------
# Authentication — AWS OIDC
# ---------------------------------------------------------------------------

variable "identity_token" {
  type        = string
  ephemeral   = true
  description = "OIDC identity token issued by HCP Terraform for AWS assume-role."
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM role to assume via web identity."
}

# ---------------------------------------------------------------------------
# Authentication — HCP Service Principal
# ---------------------------------------------------------------------------

variable "hcp_client_id" {
  type        = string
  ephemeral   = true
  description = "HCP Service Principal client ID."
}

variable "hcp_client_secret" {
  type        = string
  ephemeral   = true
  sensitive   = true
  description = "HCP Service Principal client secret."
}

# ---------------------------------------------------------------------------
# Topology
# ---------------------------------------------------------------------------

variable "region" {
  type        = string
  description = "AWS region for this deployment."
}

variable "namespace" {
  type        = string
  description = "Unique name differentiating deployments on the same account."
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "vpc_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "zone_id" {
  type        = string
  description = "Route 53 hosted zone ID for DNS records and ACM validation."
}

# ---------------------------------------------------------------------------
# Access
# ---------------------------------------------------------------------------

variable "public_key" {
  type        = string
  description = "SSH public key content for the AWS key pair."
}

variable "host_access_ip" {
  type    = list(string)
  default = []
}

# ---------------------------------------------------------------------------
# Compute
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Enterprise licensing
# ---------------------------------------------------------------------------

variable "enterprise" {
  type    = bool
  default = false
}

variable "nomadlicense" {
  type      = string
  sensitive = true
  default   = ""
}

# ---------------------------------------------------------------------------
# HCP cluster tiers
# ---------------------------------------------------------------------------

variable "hcp_vault_cluster_tier" {
  type    = string
  default = "dev"
}

variable "hcp_consul_cluster_tier" {
  type    = string
  default = "development"
}

variable "hcp_consul_cluster_size" {
  type    = string
  default = "x_small"
}

variable "hcp_boundary_cluster_tier" {
  type    = string
  default = "standard"
}

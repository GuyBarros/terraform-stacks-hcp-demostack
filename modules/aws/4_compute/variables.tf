variable "namespace" {
  description = "Differentiates different demostack deployments on the same account."
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "enterprise" {
  description = "Install enterprise binaries."
  default     = false
}

variable "nomadlicense" {
  description = "Enterprise License for Nomad."
  default     = ""
  ephemeral   = true
}

variable "instance_type_worker" {
  description = "EC2 instance type for worker nodes."
  default     = "t3.medium"
}

variable "run_nomad_jobs" {
  default = "0"
}

variable "workers" {
  description = "Number of Nomad worker VMs to create."
  default     = "3"
}

variable "region" {
  description = "AWS region."
  default     = "eu-west-2"
}

variable "cni_plugin_url" {
  description = "URL to download the CNI plugin tarball."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

variable "subnet_ids" {
  type    = list(string)
  default = [""]
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = [""]
}

variable "aws_iam_instance_profile_name" {
  type    = string
  default = ""
}

variable "aws_key_pair_id" {
  type    = string
  default = ""
}

# ---------------------------------------------------------------------------
# HCP values — injected from the hcp component outputs
# ---------------------------------------------------------------------------

variable "hcp_consul_config_file" {
  description = "Base64-encoded HCP Consul client config."
  type        = string
  sensitive   = true
  default     = ""
}

variable "hcp_consul_ca_file" {
  description = "Base64-encoded HCP Consul CA certificate."
  type        = string
  sensitive   = true
  default     = ""
}

variable "hcp_consul_acl_tokens" {
  description = "Per-worker Consul ACL token secret IDs (one per worker)."
  type        = list(string)
  sensitive   = true
  default     = []
}

variable "vault_addr" {
  description = "HCP Vault endpoint URL (private)."
  type        = string
  default     = ""
  #ephemeral   = true
}

variable "vault_token" {
  description = "HCP Vault admin token for bootstrapping."
  type        = string
  sensitive   = true
  default     = ""
  #ephemeral   = true
}

variable "aws_ebs_volume_prometheus_id" {
  description = "EBS volume ID for Prometheus data."
  type        = string
  default     = ""
}

variable "aws_ebs_volume_shared_id" {
  description = "EBS volume ID for shared Nomad data."
  type        = string
  default     = ""
}

# variables.tfcomponent.hcl
# All input variables available to every component in the stack.
# Values are supplied per-deployment in deployments.tfdeploy.hcl.

# ---------------------------------------------------------------------------
# Authentication (OIDC workload identity)
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
# Topology
# ---------------------------------------------------------------------------

variable "region" {
  type        = string
  description = "AWS region for this deployment (e.g. eu-west-2)."
}

variable "namespace" {
  type        = string
  description = "Unique name that differentiates deployments on the same account."
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

variable "vpc_cidr_block" {
  type        = string
  description = "Top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "Subnet CIDR blocks to create inside the VPC."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
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
  description = "SSH public key content — used to create an AWS key pair."
}

variable "host_access_ip" {
  type        = list(string)
  description = "CIDR blocks permitted SSH access (e.g. [\"1.2.3.4/32\"])."
  default     = []
}

# ---------------------------------------------------------------------------
# Compute
# ---------------------------------------------------------------------------

variable "workers" {
  type        = string
  description = "Number of Nomad worker EC2 instances."
  default     = "3"
}

variable "instance_type_worker" {
  type        = string
  description = "EC2 instance type for worker nodes."
  default     = "t3.medium"
}

variable "run_nomad_jobs" {
  type        = string
  description = "Set to 1 to automatically submit example Nomad jobs at boot."
  default     = "0"
}

variable "cni_plugin_url" {
  type        = string
  description = "Download URL for the CNI plugins tarball used by Nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

# ---------------------------------------------------------------------------
# Enterprise licensing
# ---------------------------------------------------------------------------

variable "enterprise" {
  type        = bool
  description = "Set to true to install enterprise binaries."
  default     = false
}

variable "nomadlicense" {
  type        = string
  sensitive   = true
  description = "Nomad Enterprise licence string."
  default     = ""
}

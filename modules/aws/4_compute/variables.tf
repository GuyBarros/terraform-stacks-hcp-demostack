variable "namespace" {}
variable "public_key" {}

variable "enterprise" {
  default = false
}

variable "nomadlicense" {
  default   = ""
  sensitive = true
  ephemeral = true
}

variable "instance_type_worker" {
  default = "t3.medium"
}

variable "run_nomad_jobs" {
  default = "0"
}

variable "workers" {
  default = "3"
}

variable "region" {
  default = "eu-west-2"
}

variable "cni_plugin_url" {
  default = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
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

variable "vault_addr" {
  type      = string
  sensitive = true
  default   = ""
}

variable "vault_token" {
  type      = string
  sensitive = true
  default   = ""
}

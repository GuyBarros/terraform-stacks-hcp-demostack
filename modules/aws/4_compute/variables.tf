variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH

}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "enterprise" {
  description = "do you want to use the enterprise version of Nomad"
  default     = false
}

variable "nomadlicense" {
  description = "Enterprise License for Nomad"
  default     = ""
}


variable "instance_type_worker" {
  description = "The type(size) of data workers (consul, nomad, etc)."
  default     = "t3.medium"
}

variable "run_nomad_jobs" {
  default = "0"
}


variable "workers" {
  description = "The number of nomad worker vms to create."
  default     = "3"
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

variable "cni_plugin_url" {
  description = "The url to download teh CNI plugin for nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

variable "subnet_ids"{
  description = "the list of subnet ids"
  type = list(string)
  default = [""]
}

variable "vpc_security_group_ids"{
  description = "the security group id"
  type = list(string)
  default = [""]
}

variable "aws_iam_instance_profile_name" {
  description = "the IAM instance profile name for compute instance"
  type = string
  default = ""
}


variable "aws_key_pair_id" {
  description = "the AWS Key pair id that will be used for remote access to compute instances"
  type = string
  default = ""
}
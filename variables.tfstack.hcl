///////////// SHARED ///////////////////
variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
type = string
}

///////////////////////// VPC
variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
  type = string
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
  type = string
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
  type = string
}


variable "identity_token_file" {
  type = string
}

variable "role_arn" {
  type = string
}

//////////////////////// NETWORKING
variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type = list(string)
}

/*


variable "workers" {
  description = "The number of nomad worker vms to create."
  default     = "3"
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}


variable "zone_id" {
  description = "The Zone ID which Holds the FQDN to which the subdomains will be added "
}







/////////////////////// SECURITY
variable "host_access_ip" {
  description = "list of CIDR blocks allowed to connect via SSH on port 22 e.g. your public ip format: [\"95.42.355.111/32\"]"
  type        = list(string)
}


/////////////////////// COMPUTE
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


variable "cni_plugin_url" {
  description = "The url to download teh CNI plugin for nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

*/
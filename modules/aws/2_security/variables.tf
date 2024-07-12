variable "vpc_id" {
 description = "VPC where resources will be created in"      
}

variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
}

variable "host_access_ip" {
  description = "list of CIDR blocks allowed to connect via SSH on port 22 e.g. your public ip format: [\"95.42.355.111/32\"]"
  type        = list(string)
}

variable "workers" {
  description = "The number of nomad worker vms to create."
  default     = "3"
  type = string
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
  type = string
}

variable "zone_id" {
  description = "The Zone ID which Holds the FQDN to which the subdomains will be added "
  type = string
}

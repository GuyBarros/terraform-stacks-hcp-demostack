
variable "vpc_id" {
 description = "VPC where resources will be created in"      
}

variable "zone_id" {
  description = "The Zone ID which Holds the FQDN to which the subdomains will be added "
}

variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
}

variable "workers" {
  description = "The number of nomad worker vms to create."
  default     = "3"
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

variable "aws_instance_workers_ids"{
  description = "The list of compute ids we will use for the load balancers"
  type = list(string)
  default = [""]
}

variable "aws_instance_workers_public_dns" {
  description = "The list of public dns from our compute workers we will use for the DNS"
  type = list(string)
  default = [""]
}

variable "certificate_arn" {
  description = "Arn of the validation certificate"
  type = string
  default = ""
}

variable "validation_certificate" {
  description = "Validation certificate cert"
  type = string
  default = ""
}

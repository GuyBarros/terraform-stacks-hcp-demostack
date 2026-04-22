variable "vpc_id" {
 description = "VPC where resources will be created in"      
}

variable "namespace" {
  description = <<EOH
this is the differantiates different demostack deployment on the same subscription, everycluster should have a different value
EOH
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}
variable "hvn_cidr" {
  description = "HCP HVN CIDR block — traffic to this range is routed through the VPC peering connection."
  type        = string
  default     = ""
}

variable "vpc_peering_connection_id" {
  description = "AWS VPC peering connection ID from the HCP network peering."
  type        = string
  default     = ""
}

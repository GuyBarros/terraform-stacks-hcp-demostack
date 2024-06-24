
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
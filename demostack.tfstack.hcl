# demostack.tfstack.hcl
# Terraform Stacks entry point for the Hashistack demostack.
# Each deployment (primary / secondary / tertiary) is a separate region-scoped
# instance of the hashistack-cluster component, orchestrated here.

# ---------------------------------------------------------------------------
# Required input variables surfaced by every deployment
# ---------------------------------------------------------------------------

variable "owner" {
  type        = string
  description = "IAM user responsible for the lifecycle of cloud resources."
}

variable "public_key" {
  type        = string
  description = "Contents of the SSH public key used to connect to cluster nodes."
}

variable "se_region" {
  type        = string
  description = "Mandatory SE organisation tag."
}

variable "purpose" {
  type        = string
  description = "Purpose tag applied to all resources."
}

variable "name" {
  type        = string
  description = "Name tag applied to all resources."
}

variable "host_access_ip" {
  type        = list(string)
  description = "Your IP address(es) to allow SSH access."
  default     = []
}

variable "servers" {
  type        = number
  description = "Number of Consul/Vault/Nomad server nodes per cluster."
  default     = 3
}

variable "workers" {
  type        = number
  description = "Number of Nomad worker nodes per cluster."
  default     = 3
}

variable "instance_type_server" {
  type    = string
  default = "t4g.xlarge"
}

variable "instance_type_worker" {
  type    = string
  default = "t4g.xlarge"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "zone_id" {
  type    = string
  default = ""
}

variable "enterprise" {
  type    = bool
  default = false
}

variable "vaultlicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "consullicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "nomadlicense" {
  type      = string
  sensitive = true
  default   = ""
}

variable "fabio_url" {
  type    = string
  default = "https://github.com/fabiolb/fabio/releases/download/v1.5.7/fabio-1.5.7-go1.9.2-linux_amd64"
}

variable "cni_version" {
  type    = string
  default = "1.6.0"
}

variable "run_nomad_jobs" {
  type    = string
  default = "0"
}

variable "TTL" {
  type    = string
  default = "240"
}

variable "sleep_at_night" {
  type    = bool
  default = true
}

variable "created_by" {
  type    = string
  default = "Terraform"
}

variable "f5_username" {
  type    = string
  default = "admin"
}

variable "f5_password" {
  type      = string
  sensitive = true
  default   = "admin"
}

# ---------------------------------------------------------------------------
# Components — one per logical cluster / region
# ---------------------------------------------------------------------------

component "primary" {
  source = "./components/hashistack-cluster"

  inputs = {
    region     = "eu-west-2"
    namespace  = "primarystack"
    owner      = var.owner
    public_key = var.public_key
    se_region  = var.se_region
    purpose    = var.purpose
    name       = var.name

    servers              = var.servers
    workers              = var.workers
    instance_type_server = var.instance_type_server
    instance_type_worker = var.instance_type_worker
    vpc_cidr_block       = var.vpc_cidr_block
    cidr_blocks          = var.cidr_blocks
    zone_id              = var.zone_id
    host_access_ip       = var.host_access_ip

    enterprise    = var.enterprise
    vaultlicense  = var.vaultlicense
    consullicense = var.consullicense
    nomadlicense  = var.nomadlicense

    fabio_url      = var.fabio_url
    cni_version    = var.cni_version
    run_nomad_jobs = var.run_nomad_jobs

    TTL            = var.TTL
    sleep_at_night = var.sleep_at_night
    created_by     = var.created_by

    f5_username = var.f5_username
    f5_password = var.f5_password

    primary_datacenter = "primarystack"
  }

  providers = {
    aws    = provider.aws.primary
    random = provider.random.default
  }
}

component "secondary" {
  source = "./components/hashistack-cluster"

  inputs = {
    region     = "eu-east-1"
    namespace  = "secondarystack"
    owner      = var.owner
    public_key = var.public_key
    se_region  = var.se_region
    purpose    = var.purpose
    name       = var.name

    servers              = var.servers
    workers              = var.workers
    instance_type_server = var.instance_type_server
    instance_type_worker = var.instance_type_worker
    vpc_cidr_block       = var.vpc_cidr_block
    cidr_blocks          = var.cidr_blocks
    zone_id              = var.zone_id
    host_access_ip       = var.host_access_ip

    enterprise    = var.enterprise
    vaultlicense  = var.vaultlicense
    consullicense = var.consullicense
    nomadlicense  = var.nomadlicense

    fabio_url      = var.fabio_url
    cni_version    = var.cni_version
    run_nomad_jobs = var.run_nomad_jobs

    TTL            = var.TTL
    sleep_at_night = var.sleep_at_night
    created_by     = var.created_by

    f5_username = var.f5_username
    f5_password = var.f5_password

    primary_datacenter = "primarystack"
  }

  providers = {
    aws    = provider.aws.secondary
    random = provider.random.default
  }
}

component "tertiary" {
  source = "./components/hashistack-cluster"

  inputs = {
    region     = "ap-northeast-1"
    namespace  = "tertiarystack"
    owner      = var.owner
    public_key = var.public_key
    se_region  = var.se_region
    purpose    = var.purpose
    name       = var.name

    servers              = var.servers
    workers              = var.workers
    instance_type_server = var.instance_type_server
    instance_type_worker = var.instance_type_worker
    vpc_cidr_block       = var.vpc_cidr_block
    cidr_blocks          = var.cidr_blocks
    zone_id              = var.zone_id
    host_access_ip       = var.host_access_ip

    enterprise    = var.enterprise
    vaultlicense  = var.vaultlicense
    consullicense = var.consullicense
    nomadlicense  = var.nomadlicense

    fabio_url      = var.fabio_url
    cni_version    = var.cni_version
    run_nomad_jobs = var.run_nomad_jobs

    TTL            = var.TTL
    sleep_at_night = var.sleep_at_night
    created_by     = var.created_by

    f5_username = var.f5_username
    f5_password = var.f5_password

    primary_datacenter = "primarystack"
  }

  providers = {
    aws    = provider.aws.tertiary
    random = provider.random.default
  }
}

# ---------------------------------------------------------------------------
# Stack-level outputs (aggregate across all three components)
# ---------------------------------------------------------------------------

output "consul_urls" {
  description = "Consul UI URLs for all clusters."
  type        = map(string)
  value = {
    primary   = component.primary.consul_ui
    secondary = component.secondary.consul_ui
    tertiary  = component.tertiary.consul_ui
  }
}

output "vault_urls" {
  description = "Vault UI URLs for all clusters."
  type        = map(string)
  value = {
    primary   = component.primary.vault_ui
    secondary = component.secondary.vault_ui
    tertiary  = component.tertiary.vault_ui
  }
}

output "nomad_urls" {
  description = "Nomad UI URLs for all clusters."
  type        = map(string)
  value = {
    primary   = component.primary.nomad_ui
    secondary = component.secondary.nomad_ui
    tertiary  = component.tertiary.nomad_ui
  }
}

output "fabio_endpoints" {
  description = "Fabio load-balancer endpoints."
  type        = map(string)
  value = {
    primary   = component.primary.fabio_lb
    secondary = component.secondary.fabio_lb
    tertiary  = component.tertiary.fabio_lb
  }
}

output "boundary_urls" {
  description = "Boundary UI URLs for all clusters."
  type        = map(string)
  value = {
    primary   = component.primary.boundary_ui
    secondary = component.secondary.boundary_ui
    tertiary  = component.tertiary.boundary_ui
  }
}

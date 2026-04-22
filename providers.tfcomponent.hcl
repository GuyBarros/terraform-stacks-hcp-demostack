# providers.tfcomponent.hcl

required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.55"
  }
  hcp = {
    source  = "hashicorp/hcp"
    version = "~> 0.92"
  }
  consul = {
    source  = "hashicorp/consul"
    version = "~> 2.20"
  }
  time = {
    source  = "hashicorp/time"
    version = "~> 0.11"
  }
  tls = {
    source  = "hashicorp/tls"
    version = "~> 4.0.5"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6.3"
  }
  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.3.5"
  }
}

# ---------------------------------------------------------------------------
# AWS — OIDC workload identity
# ---------------------------------------------------------------------------

provider "aws" "this" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }
  }
}

# ---------------------------------------------------------------------------
# HCP — Service Principal credentials from deployment inputs
# ---------------------------------------------------------------------------

provider "hcp" "this" {
  config {
    client_id     = var.hcp_client_id
    client_secret = var.hcp_client_secret
  }
}

# ---------------------------------------------------------------------------
# Consul — configured using hcp_clusters component outputs.
# The hcp_config component uses this provider to create ACL resources.
# ---------------------------------------------------------------------------

provider "consul" "this" {
  config {
    address    = component.hcp_clusters.consul_public_endpoint
    datacenter = component.hcp_clusters.consul_datacenter
    token      = component.hcp_clusters.consul_root_token
  }
}

provider "time" "this" {}
provider "tls" "this" {}
provider "cloudinit" "this" {}
provider "random" "this" {}

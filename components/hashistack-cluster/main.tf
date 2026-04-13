# components/hashistack-cluster/main.tf
# This component wraps the existing ./modules directory unchanged.
# It is instantiated once per cluster (primary / secondary / tertiary).

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# ---------------------------------------------------------------------------
# Shared random resources (gossip keys, join tokens)
# These were top-level in the original root module; they live here now so
# each component manages its own secrets independently.
# ---------------------------------------------------------------------------

resource "random_id" "consul_gossip_key" {
  byte_length = 16
}

resource "random_id" "consul_master_token" {
  byte_length = 16
}

resource "random_id" "consul_join_tag_value" {
  byte_length = 16
}

resource "random_id" "nomad_gossip_key" {
  byte_length = 16
}

# ---------------------------------------------------------------------------
# The existing module — unchanged from the original repo
# ---------------------------------------------------------------------------

module "cluster" {
  source = "../../modules" # path relative to component directory

  owner     = var.owner
  region    = var.region
  namespace = var.namespace

  public_key = var.public_key

  servers = var.servers
  workers = var.workers

  vaultlicense  = var.vaultlicense
  consullicense = var.consullicense
  nomadlicense  = var.nomadlicense
  enterprise    = var.enterprise

  fabio_url      = var.fabio_url
  cni_version    = var.cni_version
  run_nomad_jobs = var.run_nomad_jobs

  created-by     = var.created_by
  sleep-at-night = var.sleep_at_night
  TTL            = var.TTL

  vpc_cidr_block       = var.vpc_cidr_block
  cidr_blocks          = var.cidr_blocks
  instance_type_server = var.instance_type_server
  instance_type_worker = var.instance_type_worker

  zone_id        = var.zone_id
  host_access_ip = var.host_access_ip

  primary_datacenter = var.primary_datacenter


}

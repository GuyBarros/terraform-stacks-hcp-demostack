# modules/hcp/clusters/main.tf
# Creates HCP Vault, Boundary, and the HVN↔VPC peering.
# HCP Consul has been removed — Nomad uses its native service discovery.

locals {
  common_tags = {
    namespace = var.namespace
    managed   = "terraform"
  }
}

# ---------------------------------------------------------------------------
# HVN + VPC Peering
# ---------------------------------------------------------------------------

data "aws_vpc" "demostack" {
  id = var.vpc_id
}

resource "hcp_hvn" "demostack" {
  hvn_id         = var.namespace
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = "172.25.16.0/20"
}

resource "hcp_aws_network_peering" "demostack_peering" {
  peering_id      = var.namespace
  hvn_id          = hcp_hvn.demostack.hvn_id
  peer_vpc_id     = data.aws_vpc.demostack.id
  peer_account_id = data.aws_vpc.demostack.owner_id
  peer_vpc_region = var.region
}

resource "hcp_hvn_route" "main-to-dev" {
  hvn_link         = hcp_hvn.demostack.self_link
  hvn_route_id     = "${var.namespace}-to-dev"
  destination_cidr = var.vpc_cidr_block
  target_link      = hcp_aws_network_peering.demostack_peering.self_link
}

resource "aws_vpc_peering_connection_accepter" "demostack" {
  vpc_peering_connection_id = hcp_aws_network_peering.demostack_peering.provider_peering_id
  auto_accept               = true
  tags = merge(local.common_tags, {
    Purpose  = "demostack"
    Function = "hcp-peer"
    Name     = "${var.namespace}-hcp-peer"
  })
}

# ---------------------------------------------------------------------------
# HCP Vault
# ---------------------------------------------------------------------------

resource "hcp_vault_cluster" "demostack" {
  cluster_id      = "${var.namespace}-vault"
  hvn_id          = hcp_hvn.demostack.hvn_id
  public_endpoint = true
  tier            = var.hcp_vault_cluster_tier
}

resource "hcp_vault_cluster_admin_token" "root" {
  cluster_id = hcp_vault_cluster.demostack.cluster_id

  # Admin tokens have a 6-hour TTL and the HCP provider will show a diff on
  # every plan as the token expires. ignore_changes stops the perpetual
  # plan/apply cycle. Rotate manually when needed by tainting this resource.
  lifecycle {
    ignore_changes = all
  }
}

# ---------------------------------------------------------------------------
# HCP Boundary
# ---------------------------------------------------------------------------

resource "hcp_boundary_cluster" "demostack" {
  cluster_id = "${var.namespace}-boundary"
  username   = "admin"
  password   = "Welcome1!"
  tier       = var.hcp_boundary_cluster_tier

  lifecycle {
    # The HCP API does not return the password after creation, causing a
    # perpetual diff. ignore_changes prevents the plan/apply loop.
    ignore_changes = [password]
  }
}

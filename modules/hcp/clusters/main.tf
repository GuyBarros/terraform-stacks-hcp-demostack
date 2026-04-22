# modules/hcp/clusters/main.tf
# Creates all HCP clusters and the HVN↔VPC peering.
# Uses only the hcp and aws providers — no consul provider needed here.
# Outputs cluster endpoints so the stack-level consul provider can be configured,
# and the hcp/config module can create ACL resources.

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
}

# ---------------------------------------------------------------------------
# HCP Consul
# ---------------------------------------------------------------------------

resource "hcp_consul_cluster" "demostack" {
  hvn_id          = hcp_hvn.demostack.hvn_id
  cluster_id      = "${var.namespace}-consul"
  tier            = var.hcp_consul_cluster_tier
  size            = var.hcp_consul_cluster_size
  datacenter      = var.region
  public_endpoint = true
}

# Wait for cluster to stabilise before config module creates ACL resources
resource "time_sleep" "wait_for_consul" {
  depends_on      = [hcp_consul_cluster.demostack]
  create_duration = "30s"
}

resource "hcp_consul_cluster_root_token" "root" {
  depends_on = [time_sleep.wait_for_consul]
  cluster_id = hcp_consul_cluster.demostack.cluster_id
}

# ---------------------------------------------------------------------------
# HCP Boundary
# ---------------------------------------------------------------------------

resource "hcp_boundary_cluster" "demostack" {
  cluster_id = "${var.namespace}-boundary"
  username   = "admin"
  password   = "Welcome1!"
  tier       = var.hcp_boundary_cluster_tier
}

# hcp_peering.tf
# Creates the HCP HVN and peers it with the AWS VPC.
# The VPC ID and CIDR are passed in as variables (added below)
# so this module can be called as a proper child module.

locals {
  common_tags = {
    namespace = var.namespace
    managed   = "terraform"
  }
}

# Look up the VPC by ID so we can reference its attributes.
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

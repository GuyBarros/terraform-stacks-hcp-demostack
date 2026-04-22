terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
  }
}

data "aws_vpc" "demostack" {
  id = var.vpc_id
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "demostack" {
  vpc_id = data.aws_vpc.demostack.id
}
resource "aws_route" "internet_access" {
  route_table_id         = data.aws_vpc.demostack.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.demostack.id
}

# Route traffic destined for the HVN CIDR through the VPC peering connection.
# Without this, EC2 instances cannot reach HCP Vault's private endpoint.
resource "aws_route" "hvn_peering" {
  count = var.hvn_cidr != "" && var.vpc_peering_connection_id != "" ? 1 : 0

  route_table_id            = data.aws_vpc.demostack.main_route_table_id
  destination_cidr_block    = var.hvn_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

resource "aws_subnet" "demostack" {
  count                   = length(var.cidr_blocks)
  vpc_id                  = data.aws_vpc.demostack.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.cidr_blocks[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.namespace}-${count.index}" #"
  }
}
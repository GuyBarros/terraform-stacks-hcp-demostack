
data "aws_vpc" "selected" {
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
component "vpc" {
  source = "./modules/aws/0_vpc"

  inputs = {
    namespace = var.namespace
    vpc_cidr_block = var.vpc_cidr_block
    public_key = var.public_key
  }

  providers = {
   aws    = provider.aws.this
  }

}
/*
component "networking" {
  source = "./modules/aws/1_networking"

  inputs = {
    vpc_id = component.vpc.vpc.id
    cidr_blocks = var.cidr_blocks
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "networking" {
  source = "./aws/2_security"

  inputs = {
    namespace = var.namespace
    vpc_id = component.vpc.vpc_id
    cidr_blocks = cidr_blocks
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "rds" {
  source = "./aws/3_rds"

  inputs = {
    namespace = var.namespace
    vpc_id = component.vpc.vpc_id
    cidr_blocks = cidr_blocks
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "compute" {
  source = "./aws/4_compute"

  inputs = {
    namespace = var.namespace
    vpc_id = component.vpc.vpc_id
    cidr_blocks = cidr_blocks
  }

  providers = {
    aws    = provider.aws.this
  }
}

component "load_balancer" {
  source = "./aws/5_loadbalancer"

  inputs = {
    namespace = var.namespace
    vpc_id = component.vpc.vpc_id
    cidr_blocks = cidr_blocks
  }

  providers = {
    aws    = provider.aws.this
  }
}
*/
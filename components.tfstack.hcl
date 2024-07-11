component "vpc" {
  source = "./modules/aws/0_vpc"

  inputs = {
   namespace = "guystack"
     vpc_cidr_block = "10.1.0.0/16"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp8Zem9rjuBHS16G0np7TPH86kevPNfnV32aot/CDOGF2gBkAzkWQA78aV/FOq51GNHpw9ylcUCvxVp+4/tZiJ+MSyOCExtcrRb05Ni2ktV6FYelHA2kOTklUsQ/EbGUmtrsFWQH14N6a4DqVLjcLM/oWbhSDV9S0lKMd4hXOKON1wfjK/qLppsCZ5X6npvcghDs81bsjwMCgLtq4OWPYe6fhc/6i/eUfNYLjqmTAYOilL6gG6phg+Sdl/qveVOoJcXevUm7drk5lWVuSwq/pL2Q+NUBqfUa6nBZtb9Y2l5YCpgn7q58Nxqr/cqfawhKxPZswh4jnKfH9sHd9CWPmX guy@Guys-MacBook-Pro.local"
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
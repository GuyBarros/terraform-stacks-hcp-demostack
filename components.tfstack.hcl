component "vpc" {
  source = "./modules/aws/0_vpc"

  inputs = {
    namespace      = var.namespace
    vpc_cidr_block = var.vpc_cidr_block
    public_key     = var.public_key
  }

  providers = {
    aws = provider.aws.this
  }

}



component "networking" {
  source = "./modules/aws/1_networking"

  inputs = {
    namespace   = var.namespace
    vpc_id      = component.vpc.vpc.id
    cidr_blocks = var.cidr_blocks
  }

  providers = {
    aws = provider.aws.this
  }
}


component "security" {
  source = "./modules/aws/2_security"

  inputs = {
    namespace      = var.namespace
    vpc_id         = component.vpc.vpc.id
    host_access_ip = var.host_access_ip
    zone_id        = var.zone_id
  }

  providers = {
    aws = provider.aws.this
  }
}


component "rds" {
  source = "./modules/aws/3_rds"

  inputs = {
    namespace              = var.namespace
    vpc_id                 = component.vpc.vpc.id
    cidr_blocks            = var.cidr_blocks
    subnet_ids             = component.networking.subnet_ids
    vpc_security_group_ids = component.security.vpc_security_group_id
  }

  providers = {
    aws = provider.aws.this
  }
}


component "compute" {
  source = "./modules/aws/4_compute"

  inputs = {
    namespace                     = var.namespace
    vpc_id                        = component.vpc.vpc.id
    subnet_ids                    = component.networking.subnet_ids
    vpc_security_group_ids        = component.security.vpc_security_group_id
    public_key                    = var.public_key
    aws_iam_instance_profile_name = component.vpc.aws_iam_instance_profile_name
    aws_key_pair_id               = component.vpc.aws_key_pair_id
    workers                       = var.workers
  }

  providers = {
    aws       = provider.aws.this
    random    = provider.random.this
    cloudinit = provider.cloudinit.this

  }

}


component "load_balancer" {
  source = "./modules/aws/5_load_balancers"

  inputs = {
    namespace              = var.namespace
    vpc_id                 = component.vpc.vpc.id
    subnet_ids             = component.networking.subnet_ids
    vpc_security_group_ids = component.security.vpc_security_group_id
    zone_id                = var.zone_id
    vpc_id                 = component.vpc.vpc.id
    workers                = var.workers
  }

  providers = {
    aws = provider.aws.this
    tls = provider.tls.this
  }
}


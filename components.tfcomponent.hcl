# components.tfcomponent.hcl
# Each AWS sub-module is a separate Stack component so HCP Terraform can
# manage independent state slices and surface a clear dependency graph.
# Regions are driven by var.region, which is set per-deployment in
# deployments.tfdeploy.hcl.

# ---------------------------------------------------------------------------
# Layer 0 — VPC, IAM instance profile, SSH key pair
# ---------------------------------------------------------------------------

component "vpc" {
  source = "./modules/aws/0_vpc"

  inputs = {
    namespace      = var.namespace
    vpc_cidr_block = var.vpc_cidr_block
    public_key     = var.public_key
    region         = var.region
  }

  providers = {
    aws = provider.aws.this
  }
}

# ---------------------------------------------------------------------------
# Layer 1 — Subnets, internet gateway, routing
# ---------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------
# Layer 2 — Security groups
# ---------------------------------------------------------------------------

component "security" {
  source = "./modules/aws/2_security"

  inputs = {
    namespace      = var.namespace
    vpc_id         = component.vpc.vpc.id
    host_access_ip = var.host_access_ip
    workers        = var.workers
    region         = var.region
    zone_id        = var.zone_id
  }

  providers = {
    aws = provider.aws.this
  }
}

# ---------------------------------------------------------------------------
# Layer 3 — RDS (MySQL + PostgreSQL)
# ---------------------------------------------------------------------------

component "rds" {
  source = "./modules/aws/3_rds"

  inputs = {
    namespace              = var.namespace
    subnet_ids             = component.networking.subnet_ids
    vpc_security_group_ids = component.security.vpc_security_group_id
  }

  providers = {
    aws = provider.aws.this
  }
}

# ---------------------------------------------------------------------------
# Layer 4 — EC2 compute workers
# ---------------------------------------------------------------------------

component "compute" {
  source = "./modules/aws/4_compute"

  inputs = {
    namespace                     = var.namespace
    public_key                    = var.public_key
    enterprise                    = var.enterprise
    nomadlicense                  = var.nomadlicense
    instance_type_worker          = var.instance_type_worker
    run_nomad_jobs                = var.run_nomad_jobs
    workers                       = var.workers
    region                        = var.region
    cni_plugin_url                = var.cni_plugin_url
    subnet_ids                    = component.networking.subnet_ids
    vpc_security_group_ids        = component.security.vpc_security_group_id
    aws_iam_instance_profile_name = component.vpc.aws_iam_instance_profile_name
    aws_key_pair_id               = component.vpc.aws_key_pair_id
  }

  providers = {
    aws       = provider.aws.this
    random    = provider.random.this
    cloudinit = provider.cloudinit.this
  }
}

# ---------------------------------------------------------------------------
# Layer 5 — Load balancers, DNS (Route 53 + ACM + ALBs), TLS
# ---------------------------------------------------------------------------

component "load_balancer" {
  source = "./modules/aws/5_load_balancers"

  inputs = {
    namespace              = var.namespace
    vpc_id                 = component.vpc.vpc.id
    subnet_ids             = component.networking.subnet_ids
    vpc_security_group_ids = component.security.vpc_security_group_id
    zone_id                = var.zone_id
    workers                = var.workers
    region                 = var.region
  }

  providers = {
    aws = provider.aws.this
    tls = provider.tls.this
  }
}

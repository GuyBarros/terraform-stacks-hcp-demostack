# components.tfcomponent.hcl
# Dependency order:
#   vpc → networking + security → rds
#   vpc → hcp_clusters → hcp_config
#   networking + security + vpc + hcp_clusters + hcp_config → compute
#   vpc + networking + security → load_balancer

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
# Layer 4a — HCP clusters: HVN peering, Vault, Consul, Boundary
# Uses only the hcp + aws providers. Outputs cluster endpoints so the
# stack-level consul provider can be configured before hcp_config runs.
# ---------------------------------------------------------------------------

component "hcp_clusters" {
  source = "./modules/hcp/clusters"

  inputs = {
    namespace      = var.namespace
    region         = var.region
    vpc_id         = component.vpc.vpc.id
    vpc_cidr_block = var.vpc_cidr_block

    hcp_vault_cluster_tier    = var.hcp_vault_cluster_tier
    hcp_consul_cluster_tier   = var.hcp_consul_cluster_tier
    hcp_consul_cluster_size   = var.hcp_consul_cluster_size
    hcp_boundary_cluster_tier = var.hcp_boundary_cluster_tier
  }

  providers = {
    aws  = provider.aws.this
    hcp  = provider.hcp.this
    time = provider.time.this
  }
}

# ---------------------------------------------------------------------------
# Layer 4b — HCP config: ACL policies/tokens, Consul service registrations
# The consul provider is configured at the stack level using hcp_clusters
# outputs, so this component simply uses provider.consul.this.
# ---------------------------------------------------------------------------

component "hcp_config" {
  source = "./modules/hcp/config"

  inputs = {
    consul_datacenter      = component.hcp_clusters.consul_datacenter
    workers                = tonumber(var.workers)
    vault_private_endpoint = component.hcp_clusters.vault_private_endpoint
    boundary_cluster_url   = component.hcp_clusters.boundary_cluster_url
  }

  providers = {
    consul = provider.consul.this
  }
}

# ---------------------------------------------------------------------------
# Layer 5 — EC2 compute workers
# Receives HCP endpoints + ACL tokens for cloud-init configuration.
# EBS volumes (prometheus, shared) are created inside this same component
# (modules/aws/4_compute/ebs.tf) so no cross-component reference needed.
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

    # HCP values for cloud-init templates
    hcp_consul_config_file = component.hcp_clusters.consul_config_file
    hcp_consul_ca_file     = component.hcp_clusters.consul_ca_file
    hcp_consul_acl_tokens  = component.hcp_config.consul_acl_tokens
    vault_addr             = component.hcp_clusters.vault_private_endpoint
    vault_token            = component.hcp_clusters.vault_admin_token
  }

  providers = {
    aws       = provider.aws.this
    random    = provider.random.this
    cloudinit = provider.cloudinit.this
  }
}

# ---------------------------------------------------------------------------
# Layer 6 — Load balancers, DNS, TLS
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

# components.tfcomponent.hcl
# Dependency order:
#   vpc → networking + security → rds
#   vpc → hcp_clusters
#   networking + security + vpc + hcp_clusters → compute
#   vpc + networking + security → load_balancer

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

component "networking" {
  source = "./modules/aws/1_networking"

  inputs = {
    namespace                 = var.namespace
    vpc_id                    = component.vpc.vpc.id
    cidr_blocks               = var.cidr_blocks
    hvn_cidr                  = component.hcp_clusters.hvn_cidr
    vpc_peering_connection_id = component.hcp_clusters.vpc_peering_connection_id
  }

  providers = {
    aws = provider.aws.this
  }
}

component "security" {
  source = "./modules/aws/2_security"

  inputs = {
    namespace           = var.namespace
    vpc_id              = component.vpc.vpc.id
    host_access_ip      = var.host_access_ip
    allowed_cidr_blocks = var.allowed_cidr_blocks
    workers             = var.workers
    region              = var.region
    zone_id             = var.zone_id
  }

  providers = {
    aws = provider.aws.this
  }
}

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
# HCP — Vault + Boundary clusters and HVN↔VPC peering (no Consul)
# ---------------------------------------------------------------------------

component "hcp_clusters" {
  source = "./modules/hcp/clusters"

  inputs = {
    namespace      = var.namespace
    region         = var.region
    vpc_id         = component.vpc.vpc.id
    vpc_cidr_block = var.vpc_cidr_block

    hcp_vault_cluster_tier    = var.hcp_vault_cluster_tier
    hcp_boundary_cluster_tier = var.hcp_boundary_cluster_tier
  }

  providers = {
    aws = provider.aws.this
    hcp = provider.hcp.this
  }
}

# ---------------------------------------------------------------------------
# Vault config — writes the Nomad license into HCP Vault KV so instances
# can read it at startup without the license touching cloud-init or state.
# ---------------------------------------------------------------------------

component "vault_config" {
  source = "./modules/vault/config"

  inputs = {
    nomadlicense = var.nomadlicense
  }

  providers = {
    vault = provider.vault.this
  }
}

# ---------------------------------------------------------------------------
# Compute — EC2 workers, configured via cloud-init with Vault credentials
# ---------------------------------------------------------------------------

component "compute" {
  source = "./modules/aws/4_compute"

  inputs = {
    namespace                     = var.namespace
    public_key                    = var.public_key
    enterprise                    = var.enterprise
    instance_type_worker          = var.instance_type_worker
    run_nomad_jobs                = var.run_nomad_jobs
    workers                       = var.workers
    region                        = var.region
    cni_plugin_url                = var.cni_plugin_url
    subnet_ids                    = component.networking.subnet_ids
    vpc_security_group_ids        = component.security.vpc_security_group_id
    aws_iam_instance_profile_name = component.vpc.aws_iam_instance_profile_name
    aws_key_pair_id               = component.vpc.aws_key_pair_id

    # HCP Vault credentials for cloud-init
    vault_addr  = component.hcp_clusters.vault_private_endpoint
    vault_token = component.hcp_clusters.vault_admin_token
  }

  providers = {
    aws       = provider.aws.this
    random    = provider.random.this
    cloudinit = provider.cloudinit.this
    tls       = provider.tls.this
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
    workers                = var.workers
    region                 = var.region
    tls_ca_cert_pem        = component.compute.tls_ca_cert_pem
  }

  providers = {
    aws = provider.aws.this
    tls = provider.tls.this
  }
}

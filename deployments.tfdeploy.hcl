# deployments.tfdeploy.hcl

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

# Pull credentials from a variable set.
# Setup: HCP Terraform → Settings → Variable Sets → New Variable Set
#   Add: hcp_client_id        (Terraform, plain text)
#   Add: hcp_client_secret    (Terraform, sensitive)
#   Then paste the variable set ID below.

store "varset" "hcp_credentials" {
  id       = "varset-onaF4oTg6YsQj69W"
  category = "terraform"
}

deployment "primary" {
  inputs = {
    region    = "eu-west-2"
    namespace = "primarystack"

    identity_token = identity_token.aws.jwt
    role_arn       = "arn:aws:iam::958215610051:role/tfc_stacks_test"

    hcp_client_id     = store.varset.hcp_credentials.hcp_client_id
    hcp_client_secret = store.varset.hcp_credentials.hcp_client_secret

    # Network access — plain values, not secrets
    allowed_cidr_blocks = ["10.0.0.0/8"]
    host_access_ip      = ["191.255.89.24/32"]

    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp8Zem9rjuBHS16G0np7TPH86kevPNfnV32aot/CDOGF2gBkAzkWQA78aV/FOq51GNHpw9ylcUCvxVp+4/tZiJ+MSyOCExtcrRb05Ni2ktV6FYelHA2kOTklUsQ/EbGUmtrsFWQH14N6a4DqVLjcLM/oWbhSDV9S0lKMd4hXOKON1wfjK/qLppsCZ5X6npvcghDs81bsjwMCgLtq4OWPYe6fhc/6i/eUfNYLjqmTAYOilL6gG6phg+Sdl/qveVOoJcXevUm7drk5lWVuSwq/pL2Q+NUBqfUa6nBZtb9Y2l5YCpgn7q58Nxqr/cqfawhKxPZswh4jnKfH9sHd9CWPmX guy@Guys-MacBook-Pro.local"
    zone_id    = "Z00667463MEBDLN9K48J2"

    vpc_cidr_block = "10.1.0.0/16"
    cidr_blocks    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

    workers              = "3"
    instance_type_worker = "t3.medium"
    run_nomad_jobs       = "0"
    cni_plugin_url       = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"

    enterprise   = false
    nomadlicense = ""

    hcp_vault_cluster_tier    = "dev"
    hcp_boundary_cluster_tier = "standard"
  }
  destroy = false
}

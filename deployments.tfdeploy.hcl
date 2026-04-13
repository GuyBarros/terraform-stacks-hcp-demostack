# deployments.tfdeploy.hcl
# Defines one deployment per region. Each supplies region-specific inputs
# and OIDC credentials. Adjust role_arn values to match your AWS account.

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

# ---------------------------------------------------------------------------
# Primary — eu-west-2 (London)
# ---------------------------------------------------------------------------

deployment "primary" {
  inputs = {
    region    = "eu-west-2"
    namespace = "primarystack"

    identity_token = identity_token.aws.jwt
    role_arn       = "arn:aws:iam::958215610051:role/tfc_stacks_test"

    public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp8Zem9rjuBHS16G0np7TPH86kevPNfnV32aot/CDOGF2gBkAzkWQA78aV/FOq51GNHpw9ylcUCvxVp+4/tZiJ+MSyOCExtcrRb05Ni2ktV6FYelHA2kOTklUsQ/EbGUmtrsFWQH14N6a4DqVLjcLM/oWbhSDV9S0lKMd4hXOKON1wfjK/qLppsCZ5X6npvcghDs81bsjwMCgLtq4OWPYe6fhc/6i/eUfNYLjqmTAYOilL6gG6phg+Sdl/qveVOoJcXevUm7drk5lWVuSwq/pL2Q+NUBqfUa6nBZtb9Y2l5YCpgn7q58Nxqr/cqfawhKxPZswh4jnKfH9sHd9CWPmX guy@Guys-MacBook-Pro.local"
    host_access_ip = ["200.166.197.134/32"]
    zone_id        = "Z00667463MEBDLN9K48J2"

    vpc_cidr_block = "10.1.0.0/16"
    cidr_blocks    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

    workers              = "3"
    instance_type_worker = "t3.medium"
    run_nomad_jobs       = "0"
    cni_plugin_url       = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"

    enterprise   = false
    nomadlicense = ""
  }
}

# ---------------------------------------------------------------------------
# Secondary — eu-central-1 (Frankfurt)
# NOTE: eu-east-1 does not exist; using eu-central-1 instead.
# ---------------------------------------------------------------------------

# deployment "secondary" {
#   inputs = {
#     region    = "eu-central-1"
#     namespace = "secondarystack"

#     identity_token = identity_token.aws.jwt
#     role_arn       = "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_TFC_ROLE"

#     public_key     = "ssh-rsa AAAA... your-key-here"
#     host_access_ip = ["YOUR_IP/32"]
#     zone_id        = "YOUR_ROUTE53_ZONE_ID"

#     vpc_cidr_block = "10.2.0.0/16"
#     cidr_blocks    = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]

#     workers              = "3"
#     instance_type_worker = "t3.medium"
#     run_nomad_jobs       = "0"
#     cni_plugin_url       = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"

#     enterprise   = false
#     nomadlicense = ""
#   }
# }

# # ---------------------------------------------------------------------------
# # Tertiary — ap-northeast-1 (Tokyo)
# # ---------------------------------------------------------------------------

# deployment "tertiary" {
#   inputs = {
#     region    = "ap-northeast-1"
#     namespace = "tertiarystack"

#     identity_token = identity_token.aws.jwt
#     role_arn       = "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_TFC_ROLE"

#     public_key     = "ssh-rsa AAAA... your-key-here"
#     host_access_ip = ["YOUR_IP/32"]
#     zone_id        = "YOUR_ROUTE53_ZONE_ID"

#     vpc_cidr_block = "10.3.0.0/16"
#     cidr_blocks    = ["10.3.1.0/24", "10.3.2.0/24", "10.3.3.0/24"]

#     workers              = "3"
#     instance_type_worker = "t3.medium"
#     run_nomad_jobs       = "0"
#     cni_plugin_url       = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"

#     enterprise   = false
#     nomadlicense = ""
#   }
# }

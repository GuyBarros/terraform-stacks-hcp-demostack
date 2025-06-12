
identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}


deployment "demostack" {
  inputs = {
    # providers
    region         = "eu-west-2"
    role_arn       = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    identity_token = identity_token.aws.jwt
    # shared
    namespace = "stacktest"
    # VPC
    vpc_cidr_block = "10.1.0.0/16"
    # Networking

    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp8Zem9rjuBHS16G0np7TPH86kevPNfnV32aot/CDOGF2gBkAzkWQA78aV/FOq51GNHpw9ylcUCvxVp+4/tZiJ+MSyOCExtcrRb05Ni2ktV6FYelHA2kOTklUsQ/EbGUmtrsFWQH14N6a4DqVLjcLM/oWbhSDV9S0lKMd4hXOKON1wfjK/qLppsCZ5X6npvcghDs81bsjwMCgLtq4OWPYe6fhc/6i/eUfNYLjqmTAYOilL6gG6phg+Sdl/qveVOoJcXevUm7drk5lWVuSwq/pL2Q+NUBqfUa6nBZtb9Y2l5YCpgn7q58Nxqr/cqfawhKxPZswh4jnKfH9sHd9CWPmX guy@Guys-MacBook-Pro.local"
    # Security 
    host_access_ip = ["82.42.64.214/32"]
    zone_id        = "Z07233516ZPD72KHRJEK"
  }
}


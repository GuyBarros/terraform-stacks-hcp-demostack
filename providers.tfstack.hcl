# providers.tfstack.hcl
# Declares provider configurations required by the stack.
# Each AWS region gets its own aliased provider instance; Random is shared.

required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6"
  }
}

# ---------------------------------------------------------------------------
# AWS provider — one instance per target region
# ---------------------------------------------------------------------------

provider "aws" "primary" {
  config {
    region = "eu-west-2"

    default_tags {
      tags = {
        owner      = var.owner
        terraform  = "true"
        created-by = var.created_by
        ttl        = var.TTL
      }
    }
  }
}

provider "aws" "secondary" {
  config {
    region = "eu-east-1"

    default_tags {
      tags = {
        owner      = var.owner
        terraform  = "true"
        created-by = var.created_by
        ttl        = var.TTL
      }
    }
  }
}

provider "aws" "tertiary" {
  config {
    region = "ap-northeast-1"

    default_tags {
      tags = {
        owner      = var.owner
        terraform  = "true"
        created-by = var.created_by
        ttl        = var.TTL
      }
    }
  }
}

# ---------------------------------------------------------------------------
# Random provider — single shared instance (gossip keys, join tokens etc.)
# ---------------------------------------------------------------------------

provider "random" "default" {}

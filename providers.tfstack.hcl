
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.92.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }

provider "aws" "this" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token_file = var.identity_token_file
    }

  }
}

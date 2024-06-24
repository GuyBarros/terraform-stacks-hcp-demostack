terraform {
  required_version = ">= 1.8"
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      # version = "0.30.0"
    }
    aws = {
      source  = "hashicorp/aws"
       version = "5.50"
    }
  }
}

provider "aws" "default" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn                = var.role_arn
      web_identity_token_file = var.identity_token_file
    }

    default_tags {
      tags = var.default_tags
    }
  }
}
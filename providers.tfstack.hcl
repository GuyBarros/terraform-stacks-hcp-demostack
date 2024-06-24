terraform {
  required_version = ">= 1.7"
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      # version = "0.30.0"
    }
    aws = {
      source  = "hashicorp/aws"
      # version = "4.10.2"
    }
  }
}

provider "aws" "this" {
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
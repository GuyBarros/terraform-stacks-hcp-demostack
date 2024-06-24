
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
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }


provider "aws" "default" {
  config {
    region = var.region

  }
}
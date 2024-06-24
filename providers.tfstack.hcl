
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.92.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
    ocal = {
      source = "hashicorp/local"
      version = "~> 2.5.1"
    }
  }


provider "aws" "default" {
  config {
    region = var.region

  }
}

provider "local" "default" {
  # Configuration options
  # adding another provider change to be ignored to try and trigger a 
  # config change
}
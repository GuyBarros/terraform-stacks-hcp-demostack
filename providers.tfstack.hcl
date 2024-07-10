
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

identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}

provider "aws" "default" {
  config {
    region              = "eu-west-2"

     assume_role_with_web_identity {
      identity_token_file = identity_token.aws.jwt_filename
  role_arn            = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    }

  }
}

provider "local" "default" {
  # Configuration options
  # adding another provider change to be ignored to try and trigger a 
  # config change
}
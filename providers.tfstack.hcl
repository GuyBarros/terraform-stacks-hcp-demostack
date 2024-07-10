
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

provider "aws" "default" {
  config {
    region              = "eu-west-2"

     assume_role_with_web_identity {
      identity_token_file = identity_token.aws.jwt_filename
  role_arn            = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    }

  }
}

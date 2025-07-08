
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
  tls = {
    source  = "hashicorp/tls"
    version = "~> 4.0.5"
  }
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6.3"
  }
  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.3.5"
  }

}

provider "aws" "this" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.identity_token
    }

  }

}

provider "tls" "this" {

}

provider "cloudinit" "this" {


}

provider "random" "this" {



}

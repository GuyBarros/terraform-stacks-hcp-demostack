identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}

deployment "demostack" {
variables = {
  region              = "eu-west-2"
  identity_token_file = identity_token.aws.jwt_filename
  role_arn            = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
  }
}
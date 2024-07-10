
identity_token "aws" {
  audience = ["terraform-stacks-private-preview"]
}


deployment "demostack" {
  variables = {
    region              = "eu-west-2"
    role_arn            = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    identity_token_file = identity_token.aws.jwt_filename
    #key_pair_name       = "<Set to the name of an imported SSH key pair (in AWS console under EC2->Key Pairs)>"
  }
}
deployment "demostack" {
  variables = {
    region              = var.region
     namespace = var.namespace
    vpc_cidr_block = var.vpc_cidr_block
  }
}
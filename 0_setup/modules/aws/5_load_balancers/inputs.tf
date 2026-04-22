data "aws_vpc" "demostack" {
  id = var.vpc_id
}

data "aws_instances" "workers" {


  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  instance_tags = {
    # owner = var.owner_tag
    Function = "worker"
    Purpose  = var.namespace
  }

}


# for_each        = toset(data.aws_instances.workers.private_ips)
# name            = "backend_server_service_${each.value}"
# address         = each.key
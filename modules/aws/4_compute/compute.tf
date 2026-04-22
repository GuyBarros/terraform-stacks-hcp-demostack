data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "random_id" "nomad_gossip_key" {
  byte_length = 16
}

# One cloud-init config per worker — each gets its own node name and ACL token
data "cloudinit_config" "workers" {
  count = var.workers

  gzip          = true
  base64_encode = true

  # Step 1 — install Docker
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/templates/shared/docker.sh")
  }

  # Step 2 — install Hashicorp binaries (consul, vault, nomad)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/shared/hashicorp.sh", {
      enterprise = var.enterprise
    })
  }

  # Step 3 — configure Consul client joined to HCP Consul
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/workers/consul.sh", {
      node_name       = "${var.namespace}-worker-${count.index}"
      hcp_config_file = var.hcp_consul_config_file
      hcp_ca_file     = var.hcp_consul_ca_file
      hcp_acl_token   = length(var.hcp_consul_acl_tokens) > count.index ? var.hcp_consul_acl_tokens[count.index] : ""
    })
  }

  # Step 4 — configure Vault policies and token roles
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/workers/vault.sh", {
      VAULT_ADDR  = var.vault_addr
      VAULT_TOKEN = var.vault_token
    })
  }

  # Step 5 — configure and start Nomad (client + server)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/workers/nomad.sh", {
      node_name        = "${var.namespace}-worker-${count.index}"
      hcp_acl_token    = length(var.hcp_consul_acl_tokens) > count.index ? var.hcp_consul_acl_tokens[count.index] : ""
      VAULT_ADDR       = var.vault_addr
      VAULT_TOKEN      = var.vault_token
      nomad_workers    = var.workers
      nomad_gossip_key = random_id.nomad_gossip_key.b64_std
      cni_plugin_url   = var.cni_plugin_url
      run_nomad_jobs   = var.run_nomad_jobs
      nomadlicense     = var.nomadlicense
      region           = var.region
      # 1-based index for bootstrap-on-last-worker logic
      index                        = count.index + 1
      count                        = var.workers
      aws_ebs_volume_prometheus_id = aws_ebs_volume.prometheus.id
      aws_ebs_volume_shared_id     = aws_ebs_volume.shared.id
    })
  }
}

resource "aws_instance" "workers" {
  count = var.workers

  ami           = data.aws_ami.ubuntu.image_id
  instance_type = var.instance_type_worker
  key_name      = var.aws_key_pair_id

  monitoring = true

  subnet_id              = element(var.subnet_ids[*], count.index)
  iam_instance_profile   = var.aws_iam_instance_profile_name
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device {
    volume_size           = "240"
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "240"
    delete_on_termination = "true"
  }

  tags = {
    Purpose  = var.namespace
    Function = "worker"
    Name     = "demostack-worker-${count.index}"
  }

  user_data_replace_on_change = true
  user_data_base64            = element(data.cloudinit_config.workers[*].rendered, count.index)
}
